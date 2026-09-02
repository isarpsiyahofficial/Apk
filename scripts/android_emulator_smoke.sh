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

# T0295 reboot-restore packaging gate. flutter_local_notifications restores
# scheduled Android alarms through its boot receiver; this audit proves that the
# receiver and RECEIVE_BOOT_COMPLETED permission survived manifest merge into
# the APK actually installed on the emulator. A source-only manifest check is
# not sufficient because dependency/plugin manifest merging happens at build.
PACKAGE_DUMP="$(adb shell dumpsys package "$PACKAGE" | tr -d '\r')"
printf '%s\n' "$PACKAGE_DUMP" | grep -F 'android.permission.RECEIVE_BOOT_COMPLETED'
printf '%s\n' "$PACKAGE_DUMP" | grep -F "$BOOT_RECEIVER"
printf '%s\n' "$PACKAGE_DUMP" | grep -F "$SCHEDULE_RECEIVER"
echo 'Notification reboot-restore manifest packaging audit PASS'

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
