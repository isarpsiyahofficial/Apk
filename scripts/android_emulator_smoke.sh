#!/bin/sh
set -eu

PACKAGE='com.example.islami_hayat'
ACTIVITY="$PACKAGE/.MainActivity"
APK='build/app/outputs/flutter-apk/app-debug.apk'

adb install -r "$APK"
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
