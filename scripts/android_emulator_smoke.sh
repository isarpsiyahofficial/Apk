#!/bin/sh
set -eu

PACKAGE='com.example.islami_hayat'
ACTIVITY="$PACKAGE/.MainActivity"
APK='build/app/outputs/flutter-apk/app-debug.apk'
BOOT_RECEIVER='com.dexterous.flutterlocalnotifications.ScheduledNotificationBootReceiver'
SCHEDULE_RECEIVER='com.dexterous.flutterlocalnotifications.ScheduledNotificationReceiver'

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

# T0295 reboot-restore packaging gate. Verify the exact APK that Android installed,
# not the source manifest and not dumpsys' resolver summary (which does not list
# receivers without intent filters consistently across Android API levels).
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
  ACTIVITY_FOUND="$(adb shell dumpsys activity activities | grep -m 1 "$ACTIVITY" || true)"
  if [ -n "$ACTIVITY_FOUND" ]; then
    break
  fi
  attempt=$((attempt + 1))
  sleep 1
done

if [ -z "$ACTIVITY_FOUND" ]; then
  echo 'MainActivity did not become active within 30 seconds' >&2
  adb shell dumpsys activity activities >&2 || true
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
