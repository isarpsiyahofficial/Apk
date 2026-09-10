#!/bin/sh
set -eu

PACKAGE='com.example.islami_hayat'
ACTIVITY="$PACKAGE/.MainActivity"

cleanup() {
  adb shell wm size reset >/dev/null 2>&1 || true
  adb shell wm density reset >/dev/null 2>&1 || true
}
trap cleanup EXIT INT TERM

adb shell wm density 160 >/dev/null
adb logcat -c

for SIZE in 360x800 430x932 800x1280 1280x800 1920x1080 932x430; do
  echo "T0319 viewport smoke: $SIZE @160dpi"
  adb shell wm size "$SIZE" >/dev/null
  adb shell am force-stop "$PACKAGE"
  START="$(adb shell am start -W -n "$ACTIVITY" | tr -d '\r')"
  printf '%s\n' "$START"
  printf '%s\n' "$START" | grep -F 'Status: ok'
  sleep 1
  PID="$(adb shell pidof "$PACKAGE" | tr -d '\r')"
  if [ -z "$PID" ]; then
    echo "T0319 process died at $SIZE" >&2
    exit 1
  fi
  WINDOW="$(adb shell dumpsys window windows | tr -d '\r')"
  if ! printf '%s\n' "$WINDOW" | grep -E -m 1 "(mCurrentFocus|mFocusedApp).*${PACKAGE}" >/dev/null; then
    echo "T0319 MainActivity is not foreground at $SIZE" >&2
    exit 1
  fi
done

FATAL="$(adb logcat -d '*:E' | grep -E 'FATAL EXCEPTION|AndroidRuntime.*Process: com\.example\.islami_hayat|OutOfMemoryError' || true)"
if [ -n "$FATAL" ]; then
  echo 'T0319 fatal/OOM evidence found during device matrix:' >&2
  printf '%s\n' "$FATAL" >&2
  exit 1
fi

echo 'T0319 Android viewport/orientation matrix PASS'
