#!/bin/sh
set -eu

PACKAGE='com.example.islami_hayat'
WIDGET_PROVIDER="$PACKAGE.IslamiHayatWidgetProvider"
WIDGET_PIN_ACTIVITY="$PACKAGE/.WidgetPinSmokeActivity"
WIDGET_EMPTY_TR="Bugünün widget’ını hazırlamak için İslami Hayat’ı açın."

find_target() {
  xml_file="$1"
  mode="$2"
  python3 - "$xml_file" "$mode" <<'PY'
import re
import sys
import xml.etree.ElementTree as ET

path, mode = sys.argv[1], sys.argv[2]
root = ET.parse(path).getroot()

def center(bounds):
    m = re.fullmatch(r"\[(\d+),(\d+)\]\[(\d+),(\d+)\]", bounds or "")
    if not m:
        return None
    x1, y1, x2, y2 = map(int, m.groups())
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

foreground_main_activity() {
  top="$(adb shell dumpsys activity top 2>/dev/null | tr -d '\r' || true)"
  if printf '%s\n' "$top" | grep -Eq "ACTIVITY ${PACKAGE}/(\.MainActivity|${PACKAGE}\.MainActivity)|mActivityComponent=${PACKAGE}/(\.MainActivity|${PACKAGE}\.MainActivity)"; then
    printf '%s\n' "$top" | grep -E -m 1 "${PACKAGE}/(\.MainActivity|${PACKAGE}\.MainActivity)" || true
    return 0
  fi

  window="$(adb shell dumpsys window 2>/dev/null | tr -d '\r' || true)"
  if printf '%s\n' "$window" | grep -Eq "(mCurrentFocus|mFocusedApp).*${PACKAGE}/(\.MainActivity|${PACKAGE}\.MainActivity)"; then
    printf '%s\n' "$window" | grep -E -m 1 "(mCurrentFocus|mFocusedApp).*${PACKAGE}/(\.MainActivity|${PACKAGE}\.MainActivity)" || true
    return 0
  fi
  return 1
}

APPWIDGET_DUMP="$(adb shell dumpsys appwidget 2>&1 | tr -d '\r')"
if ! printf '%s\n' "$APPWIDGET_DUMP" | grep -Fq "$WIDGET_PROVIDER"; then
  echo 'T0297 provider is not registered with AppWidgetService' >&2
  exit 1
fi

adb shell input keyevent KEYCODE_HOME
sleep 2
adb shell am force-stop "$PACKAGE"
adb shell am start -n "$WIDGET_PIN_ACTIVITY" | tee /tmp/t0297-pin-start.txt
grep -F 'Starting: Intent' /tmp/t0297-pin-start.txt >/dev/null

PIN_TARGET=''
ANR_RECOVERIES=0
attempt=0
while [ "$attempt" -lt 40 ]; do
  adb shell uiautomator dump /sdcard/t0297-pin.xml >/dev/null 2>&1 || true
  adb pull /sdcard/t0297-pin.xml /tmp/t0297-pin.xml >/dev/null 2>&1 || true
  if [ -s /tmp/t0297-pin.xml ]; then
    PIN_TARGET="$(find_target /tmp/t0297-pin.xml pin 2>/tmp/t0297-pin-target.log || true)"
    if [ -n "$PIN_TARGET" ]; then
      break
    fi
    ANR_TARGET="$(find_target /tmp/t0297-pin.xml anr-wait 2>/tmp/t0297-anr-target.log || true)"
    if [ -n "$ANR_TARGET" ]; then
      if [ "$ANR_RECOVERIES" -ge 2 ]; then
        echo 'T0297 launcher remained unresponsive after bounded Wait recovery' >&2
        exit 1
      fi
      ANR_RECOVERIES=$((ANR_RECOVERIES + 1))
      set -- $ANR_TARGET
      adb shell input tap "$1" "$2"
      sleep 3
    fi
  fi
  attempt=$((attempt + 1))
  sleep 1
done

if [ -z "$PIN_TARGET" ]; then
  echo 'T0297 launcher pin confirmation control was not found' >&2
  cat /tmp/t0297-pin.xml >&2 2>/dev/null || true
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
WIDGET_TARGET="$(find_target /tmp/t0297-home.xml widget 2>/tmp/t0297-widget-target.log || true)"
if [ -z "$WIDGET_TARGET" ]; then
  echo 'T0297 pinned widget did not render its localized RemoteViews empty state on launcher' >&2
  cat /tmp/t0297-home.xml >&2 || true
  exit 1
fi
grep -F "$WIDGET_EMPTY_TR" /tmp/t0297-home.xml >/dev/null
cat /tmp/t0297-widget-target.log
echo 'T0297 launcher RemoteViews render PASS'

# Tap the real launcher-hosted RemoteViews and require MainActivity to become
# foreground. dumpsys activity top is used as the primary Android 35 signal;
# WindowManager focus is an independent fallback for OEM/BlueStacks-like hosts.
set -- $WIDGET_TARGET
adb logcat -c
adb shell input tap "$1" "$2"

TAP_ACTIVITY=''
attempt=0
while [ "$attempt" -lt 20 ]; do
  TAP_ACTIVITY="$(foreground_main_activity || true)"
  if [ -n "$TAP_ACTIVITY" ]; then
    break
  fi
  attempt=$((attempt + 1))
  sleep 1
done
if [ -z "$TAP_ACTIVITY" ]; then
  echo 'T0297 launcher widget tap did not foreground MainActivity' >&2
  adb shell dumpsys activity top >&2 || true
  adb shell dumpsys window >&2 || true
  adb logcat -d -t 800 >&2 || true
  exit 1
fi
printf '%s\n' "$TAP_ACTIVITY"
echo 'T0297 real launcher pin/render/tap smoke PASS'
