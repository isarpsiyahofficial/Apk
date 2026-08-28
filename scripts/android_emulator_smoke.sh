#!/bin/sh
set -eu

PACKAGE='com.example.islami_hayat'
ACTIVITY="$PACKAGE/.MainActivity"
APK='build/app/outputs/flutter-apk/app-debug.apk'

MEMTOTAL_KB="$(adb shell cat /proc/meminfo | awk '/MemTotal:/ {print $2}' | tr -d '\r')"
if [ -z "$MEMTOTAL_KB" ]; then
  echo 'Could not read emulator MemTotal' >&2
  exit 1
fi
# This smoke intentionally targets a low-memory Android class. Android reserves
# part of configured AVD RAM, so a 2048 MB guest usually reports slightly less
# than 2 GiB. Keep a small tolerance but fail if the runner silently regresses
# to a modern multi-gigabyte profile.
if [ "$MEMTOTAL_KB" -gt 2300000 ]; then
  echo "Emulator is not low-memory enough: MemTotal=${MEMTOTAL_KB}kB" >&2
  exit 1
fi
echo "Low-memory emulator confirmed: MemTotal=${MEMTOTAL_KB}kB"

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
