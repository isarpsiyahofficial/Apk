#!/bin/sh
set -eu

PACKAGE='com.example.islami_hayat'
ACTIVITY="$PACKAGE/.MainActivity"
APK='build/app/outputs/flutter-apk/app-debug.apk'
BOOT_RECEIVER='com.dexterous.flutterlocalnotifications.ScheduledNotificationBootReceiver'
SCHEDULE_RECEIVER='com.dexterous.flutterlocalnotifications.ScheduledNotificationReceiver'
WIDGET_PROVIDER="$PACKAGE.IslamiHayatWidgetProvider"
WIDGET_PIN_ACTIVITY="$PACKAGE/.WidgetPinSmokeActivity"
WIDGET_EMPTY_TR="Bugünün widget’ını hazırlamak için İslami Hayat’ı açın."

find_main_activity_record() {
  # ActivityManager output is not byte-stable across Android/OEM images. Some
  # hosts print package/.MainActivity while others expand the class name. Keep
  # the assertion semantic: MainActivity must be present and resumed/visible,
  # without accepting a mere background process as success.
  activities="$(adb shell dumpsys activity activities 2>/dev/null | tr -d '\r' || true)"
  record="$(printf '%s\n' "$activities" | grep -E -m 1 "$PACKAGE/(\.MainActivity|$PACKAGE\.MainActivity)" || true)"
  if [ -n "$record" ]; then
    resumed="$(printf '%s\n' "$activities" | grep -E -m 1 "(mResumedActivity|topResumedActivity|ResumedActivity).*${PACKAGE}/(\.MainActivity|${PACKAGE}\.MainActivity)" || true)"
    if [ -n "$resumed" ]; then
      printf '%s\n' "$resumed"
      return 0
    fi
  fi

  # WindowManager is an independent foreground signal and also varies in how
  # it abbreviates component names. Require current focus/focused-app evidence.
  windows="$(adb shell dumpsys window windows 2>/dev/null | tr -d '\r' || true)"
  focused="$(printf '%s\n' "$windows" | grep -E -m 1 "(mCurrentFocus|mFocusedApp).*${PACKAGE}/(\.MainActivity|${PACKAGE}\.MainActivity)" || true)"
  if [ -n "$focused" ]; then
    printf '%s\n' "$focused"
    return 0
  fi
  return 1
}

if [ -n "${MAX_MEMTOTAL_KB:-}" ]; then
  MEMTOTAL_KB="$(adb shell cat /proc/meminfo | awk '/MemTotal:/ {print $2}' | tr -d '\r')"
  if [ -z "$MEMTOTAL_KB" ]; then
    echo 'Could not read emulator MemTotal' >&2
    exit 1
  fi
  if [ "$MEMTOTAL_KB" -gt "$MAX_MEMTOTAL_KB" ]; then
    echo "Emulator exceeds requested memory class: MemTotal=${MEMTOTAL_KB}kB max=${MAX_MEMTOTAL_KB}kB" >&2
    exit 1
  fi
  echo "Requested memory class confirmed: MemTotal=${MEMTOTAL_KB}kB max=${MAX_MEMTOTAL_KB}kB"
fi

adb install -r "$APK"

INSTALLED_APK_PATH="$(adb shell pm path "$PACKAGE" | sed -n 's/^package://p' | head -n 1 | tr -d '\r')"
if [ -z "$INSTALLED_APK_PATH" ]; then
  echo 'Could not resolve installed base APK path' >&2
  exit 1
fi
adb pull "$INSTALLED_APK_PATH" /tmp/islami-hayat-installed.apk >/dev/null

if ! cmp -s "$APK" /tmp/islami-hayat-installed.apk; then
  echo 'Installed base APK bytes differ from the debug APK produced by this run' >&2
  sha256sum "$APK" /tmp/islami-hayat-installed.apk >&2 || true
  exit 1
fi

ANDROID_SDK="${ANDROID_HOME:-${ANDROID_SDK_ROOT:-}}"
if [ -z "$ANDROID_SDK" ]; then
  echo 'ANDROID_HOME/ANDROID_SDK_ROOT is unavailable for merged-manifest audit' >&2
  exit 1
fi
AAPT2="$(find "$ANDROID_SDK/build-tools" -type f -name aapt2 -perm -u+x 2>/dev/null | sort -V | tail -n 1)"
if [ -z "$AAPT2" ]; then
  echo 'aapt2 not found for installed APK merged-manifest audit' >&2
  exit 1
fi

INSTALLED_MANIFEST="$($AAPT2 dump xmltree --file AndroidManifest.xml /tmp/islami-hayat-installed.apk)"
printf '%s\n' "$INSTALLED_MANIFEST" | grep -F 'android.permission.RECEIVE_BOOT_COMPLETED'
printf '%s\n' "$INSTALLED_MANIFEST" | grep -F "$BOOT_RECEIVER"
printf '%s\n' "$INSTALLED_MANIFEST" | grep -F "$SCHEDULE_RECEIVER"
echo 'Notification reboot-restore installed-APK manifest audit PASS'

# T0297 must survive clean-runner generation and manifest merge. Validate the
# actual installed APK, not only source files. Compiled Android manifests may
# resolve android:resource values to numeric IDs, so resource filenames are
# verified against the exact installed APK archive instead of manifest text.
printf '%s\n' "$INSTALLED_MANIFEST" | grep -F "$WIDGET_PROVIDER"
printf '%s\n' "$INSTALLED_MANIFEST" | grep -F 'android.appwidget.action.APPWIDGET_UPDATE'
INSTALLED_ZIP_ENTRIES="$(unzip -Z1 /tmp/islami-hayat-installed.apk)"
printf '%s\n' "$INSTALLED_ZIP_ENTRIES" | grep -Fx 'res/xml/islami_hayat_widget_info.xml'
printf '%s\n' "$INSTALLED_ZIP_ENTRIES" | grep -Fx 'res/layout/islami_hayat_widget.xml'
echo 'T0297 installed-APK widget manifest/resource audit PASS'

# Manifest presence alone is not enough: after installation Android's
# AppWidgetService must discover the provider. This catches malformed provider
# metadata/resource combinations that still package successfully.
APPWIDGET_DUMP="$(adb shell dumpsys appwidget 2>&1 | tr -d '\r')"
if ! printf '%s\n' "$APPWIDGET_DUMP" | grep -F "$WIDGET_PROVIDER"; then
  echo 'T0297 widget provider was packaged but not registered by AppWidgetService' >&2
  printf '%s\n' "$APPWIDGET_DUMP" >&2
  exit 1
fi
echo 'T0297 emulator AppWidgetService provider-registration audit PASS'

find_click_target() {
  xml_file="$1"
  mode="$2"
  python3 - "$xml_file" "$mode" <<'PY'
import re
import sys
import xml.etree.ElementTree as ET

path, mode = sys.argv[1], sys.argv[2]
root = ET.parse(path).getroot()


def center(bounds: str):
    match = re.fullmatch(r"\[(\d+),(\d+)\]\[(\d+),(\d+)\]", bounds or "")
    if not match:
        return None
    x1, y1, x2, y2 = map(int, match.groups())
    if x2 <= x1 or y2 <= y1:
        return None
    return ((x1 + x2) // 2, (y1 + y2) // 2)

candidates = []
for node in root.iter("node"):
    text = (node.attrib.get("text") or "").strip()
    desc = (node.attrib.get("content-desc") or "").strip()
    resource = (node.attrib.get("resource-id") or "").strip()
    point = center(node.attrib.get("bounds") or "")
    if point is None:
        continue
    haystack = " ".join((text, desc, resource)).lower()
    clickable = node.attrib.get("clickable") == "true"
    score = None
    if mode == "pin":
        if any(bad in haystack for bad in ("cancel", "not now", "dismiss")):
            continue
        if clickable and text.lower() == "add to home screen":
            score = 120
        elif clickable and desc.lower() == "add to home screen":
            score = 115
        elif clickable and "automatically" in haystack:
            score = 100
        elif clickable and text.lower() == "add":
            score = 95
        elif clickable and ("add_to_home" in resource or "widget_add_button" in resource):
            score = 90
        elif clickable and "add" in haystack:
            score = 80
    elif mode == "anr-wait":
        if clickable and resource == "android:id/aerr_wait":
            score = 120
        elif clickable and text.lower() == "wait":
            score = 100
    elif mode == "widget":
        if "bugünün widget" in text.lower() or "bugünün widget" in desc.lower():
            score = 100
    if score is not None:
        candidates.append((score, point, text, desc, resource))

if not candidates:
    sys.exit(2)
candidates.sort(reverse=True)
score, (x, y), text, desc, resource = candidates[0]
print(f"{x} {y}")
print(f"selected score={score} text={text!r} desc={desc!r} resource={resource!r}", file=sys.stderr)
PY
}

verify_pin_target_selector() {
  cat > /tmp/t0297-pin-selector-fixture.xml <<'XML'
<?xml version='1.0' encoding='utf-8' standalone='yes' ?>
<hierarchy rotation="0">
  <node text="" resource-id="com.android.launcher3:id/add_item_bottom_sheet_content" clickable="false" bounds="[0,100][1080,1800]">
    <node text="Add to home screen" resource-id="com.android.launcher3:id/add_item_button" clickable="true" bounds="[300,1500][780,1650]" />
  </node>
</hierarchy>
XML
  selector_target="$(find_click_target /tmp/t0297-pin-selector-fixture.xml pin 2>/tmp/t0297-pin-selector-fixture.log || true)"
  if [ "$selector_target" != '540 1575' ]; then
    echo 'T0297 pin selector regression: actionable confirmation button was not preferred over its container' >&2
    cat /tmp/t0297-pin-selector-fixture.log >&2 || true
    exit 1
  fi

  cat > /tmp/t0297-anr-selector-fixture.xml <<'XML'
<?xml version='1.0' encoding='utf-8' standalone='yes' ?>
<hierarchy rotation="0">
  <node text="Quickstep isn't responding" resource-id="android:id/alertTitle" clickable="false" bounds="[100,900][900,1050]" />
  <node text="Close app" resource-id="android:id/aerr_close" clickable="true" bounds="[100,1100][900,1230]" />
  <node text="Wait" resource-id="android:id/aerr_wait" clickable="true" bounds="[100,1230][900,1360]" />
</hierarchy>
XML
  anr_target="$(find_click_target /tmp/t0297-anr-selector-fixture.xml anr-wait 2>/tmp/t0297-anr-selector-fixture.log || true)"
  if [ "$anr_target" != '500 1295' ]; then
    echo 'T0297 ANR selector regression: system Wait action was not selected safely' >&2
    cat /tmp/t0297-anr-selector-fixture.log >&2 || true
    exit 1
  fi
  echo 'T0297 pin/ANR selector regressions PASS'
}

if [ "${VERIFY_WIDGET_LAUNCHER_PIN:-0}" = "1" ]; then
  verify_pin_target_selector
  echo 'T0297 starting real launcher pin/render/tap smoke'

  adb shell input keyevent KEYCODE_HOME
  sleep 3
  adb shell uiautomator dump /sdcard/t0297-home-warm.xml >/dev/null 2>&1 || true

  adb shell am force-stop "$PACKAGE"
  adb shell am start -n "$WIDGET_PIN_ACTIVITY" | tee /tmp/widget-pin-start.txt
  grep -F 'Starting: Intent' /tmp/widget-pin-start.txt

  PIN_TARGET=''
  ANR_RECOVERIES=0
  attempt=0
  while [ "$attempt" -lt 40 ]; do
    adb shell uiautomator dump /sdcard/t0297-pin.xml >/dev/null 2>&1 || true
    adb pull /sdcard/t0297-pin.xml /tmp/t0297-pin.xml >/dev/null 2>&1 || true
    if [ -s /tmp/t0297-pin.xml ]; then
      PIN_TARGET="$(find_click_target /tmp/t0297-pin.xml pin 2>/tmp/t0297-pin-target.log || true)"
      if [ -n "$PIN_TARGET" ]; then
        break
      fi

      ANR_TARGET="$(find_click_target /tmp/t0297-pin.xml anr-wait 2>/tmp/t0297-anr-target.log || true)"
      if [ -n "$ANR_TARGET" ]; then
        if [ "$ANR_RECOVERIES" -ge 2 ]; then
          echo 'T0297 Launcher3 remained unresponsive after bounded Wait recovery' >&2
          cat /tmp/t0297-pin.xml >&2 || true
          exit 1
        fi
        ANR_RECOVERIES=$((ANR_RECOVERIES + 1))
        echo "T0297 hosted-emulator Launcher3 ANR detected; selecting system Wait recovery ($ANR_RECOVERIES/2)"
        cat /tmp/t0297-anr-target.log
        set -- $ANR_TARGET
        adb shell input tap "$1" "$2"
        sleep 3
        attempt=$((attempt + 1))
        continue
      fi
    fi
    attempt=$((attempt + 1))
    sleep 1
  done

  if [ -z "$PIN_TARGET" ]; then
    echo 'T0297 launcher pin confirmation control was not found' >&2
    cat /tmp/t0297-pin.xml >&2 2>/dev/null || true
    adb shell dumpsys activity top >&2 || true
    exit 1
  fi
  cat /tmp/t0297-pin-target.log
  set -- $PIN_TARGET
  adb shell input tap "$1" "$2"

  SMOKE_PREFS=''
  attempt=0
  while [ "$attempt" -lt 20 ]; do
    SMOKE_PREFS="$(adb shell run-as "$PACKAGE" cat shared_prefs/islami_hayat_widget_smoke.xml 2>/dev/null | tr -d '\r' || true)"
    if printf '%s\n' "$SMOKE_PREFS" | grep -Fq '>pinned<'; then
      break
    fi
    attempt=$((attempt + 1))
    sleep 1
  done
  if ! printf '%s\n' "$SMOKE_PREFS" | grep -Fq '>pinned<'; then
    echo 'T0297 launcher did not deliver a successful pinned-widget callback' >&2
    printf '%s\n' "$SMOKE_PREFS" >&2
    adb shell dumpsys appwidget >&2 || true
    exit 1
  fi
  if ! printf '%s\n' "$SMOKE_PREFS" | grep -Eq '<int name="widgetId" value="[0-9]+"'; then
    echo 'T0297 pin callback did not include a valid appWidgetId' >&2
    printf '%s\n' "$SMOKE_PREFS" >&2
    exit 1
  fi
  echo 'T0297 launcher pin callback PASS'

  adb shell input keyevent KEYCODE_HOME
  sleep 2
  adb shell uiautomator dump /sdcard/t0297-home.xml >/dev/null
  adb pull /sdcard/t0297-home.xml /tmp/t0297-home.xml >/dev/null
  WIDGET_TARGET="$(find_click_target /tmp/t0297-home.xml widget 2>/tmp/t0297-widget-target.log || true)"
  if [ -z "$WIDGET_TARGET" ]; then
    echo 'T0297 pinned widget did not render its localized RemoteViews empty state on the launcher' >&2
    cat /tmp/t0297-home.xml >&2 || true
    adb shell dumpsys appwidget >&2 || true
    exit 1
  fi
  cat /tmp/t0297-widget-target.log
  grep -F "$WIDGET_EMPTY_TR" /tmp/t0297-home.xml >/dev/null
  echo 'T0297 launcher RemoteViews render PASS'

  # Verify the real launcher-delivered PendingIntent without mutating package
  # stopped-state or killing the process between render and tap. Process-death
  # lifecycle is a separate concern; T0297's release gate is the actual
  # add -> render -> tap -> MainActivity behavior exposed to the user.
  adb shell input keyevent KEYCODE_HOME
  sleep 1
  adb shell uiautomator dump /sdcard/t0297-home-before-tap.xml >/dev/null
  adb pull /sdcard/t0297-home-before-tap.xml /tmp/t0297-home-before-tap.xml >/dev/null
  WIDGET_TARGET="$(find_click_target /tmp/t0297-home-before-tap.xml widget 2>/tmp/t0297-widget-target-before-tap.log || true)"
  if [ -z "$WIDGET_TARGET" ]; then
    echo 'T0297 pinned widget disappeared before tap verification' >&2
    cat /tmp/t0297-home-before-tap.xml >&2 || true
    exit 1
  fi
  cat /tmp/t0297-widget-target-before-tap.log
  set -- $WIDGET_TARGET
  adb logcat -c
  adb shell input tap "$1" "$2"

  TAP_ACTIVITY=''
  attempt=0
  while [ "$attempt" -lt 20 ]; do
    TAP_ACTIVITY="$(find_main_activity_record || true)"
    if [ -n "$TAP_ACTIVITY" ]; then
      break
    fi
    attempt=$((attempt + 1))
    sleep 1
  done
  if [ -z "$TAP_ACTIVITY" ]; then
    echo 'T0297 launcher widget tap did not open/resume MainActivity' >&2
    adb shell dumpsys activity activities >&2 || true
    adb shell dumpsys window windows >&2 || true
    adb logcat -d -t 800 >&2 || true
    exit 1
  fi
  echo "$TAP_ACTIVITY"
  echo 'T0297 real launcher pin/render/tap smoke PASS'
fi

adb shell am force-stop "$PACKAGE"
adb logcat -c
adb shell am start -n "$ACTIVITY" | tee /tmp/start.txt
grep -F 'Starting: Intent' /tmp/start.txt

PID=''
attempt=0
while [ "$attempt" -lt 30 ]; do
  PID="$(adb shell pidof "$PACKAGE" 2>/dev/null | tr -d '\r' || true)"
  if [ -n "$PID" ]; then
    break
  fi
  attempt=$((attempt + 1))
  sleep 1
done

if [ -z "$PID" ]; then
  echo 'Application process did not start within 30 seconds' >&2
  adb logcat -d -t 800 >&2 || true
  exit 1
fi
echo "App process running with PID $PID"

ACTIVITY_FOUND=''
attempt=0
while [ "$attempt" -lt 30 ]; do
  ACTIVITY_FOUND="$(find_main_activity_record || true)"
  if [ -n "$ACTIVITY_FOUND" ]; then
    break
  fi
  attempt=$((attempt + 1))
  sleep 1
done

if [ -z "$ACTIVITY_FOUND" ]; then
  echo 'MainActivity did not become resumed/focused within 30 seconds' >&2
  adb shell dumpsys activity activities >&2 || true
  adb shell dumpsys window windows >&2 || true
  adb logcat -d -t 800 >&2 || true
  exit 1
fi
echo "$ACTIVITY_FOUND"

sleep 3
if adb logcat -d -t 800 | grep -E 'FATAL EXCEPTION.*com\.example\.islami_hayat|Process: com\.example\.islami_hayat.*FATAL'; then
  echo 'Fatal application crash found after launch' >&2
  exit 1
fi

echo 'Android emulator install/launch smoke PASS'
