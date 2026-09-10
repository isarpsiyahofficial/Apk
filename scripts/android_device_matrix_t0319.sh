#!/bin/sh
set -eu

PACKAGE='com.example.islami_hayat'
ACTIVITY="$PACKAGE/.MainActivity"

cleanup() {
  adb shell wm size reset >/dev/null 2>&1 || true
  adb shell wm density reset >/dev/null 2>&1 || true
}
trap cleanup EXIT INT TERM

wait_for_process() {
  attempt=0
  while [ "$attempt" -lt 15 ]; do
    PID="$(adb shell pidof "$PACKAGE" 2>/dev/null | tr -d '\r' || true)"
    if [ -n "$PID" ]; then
      return 0
    fi
    attempt=$((attempt + 1))
    sleep 1
  done
  return 1
}

wait_for_foreground() {
  attempt=0
  while [ "$attempt" -lt 15 ]; do
    WINDOW="$(adb shell dumpsys window windows 2>/dev/null | tr -d '\r' || true)"
    if printf '%s\n' "$WINDOW" | grep -E "(mCurrentFocus|mFocusedApp).*${PACKAGE}" >/dev/null; then
      return 0
    fi
    RESUMED="$(adb shell dumpsys activity activities 2>/dev/null | tr -d '\r' || true)"
    if printf '%s\n' "$RESUMED" | grep -E "(mResumedActivity|topResumedActivity|ResumedActivity).*${PACKAGE}" >/dev/null; then
      return 0
    fi
    attempt=$((attempt + 1))
    sleep 1
  done
  return 1
}

adb shell wm density 160 >/dev/null
adb logcat -c

for SIZE in 360x800 430x932 800x1280 1280x800 1920x1080 932x430; do
  echo "T0319 viewport smoke: $SIZE @160dpi"
  adb shell wm size "$SIZE" >/dev/null
  sleep 1
  adb shell am force-stop "$PACKAGE"
  START="$(adb shell am start -W -n "$ACTIVITY" 2>&1 | tr -d '\r')"
  printf '%s\n' "$START"

  if ! printf '%s\n' "$START" | grep -F "$PACKAGE" >/dev/null; then
    echo "T0319 launch output did not reference expected package at $SIZE" >&2
    exit 1
  fi
  if ! wait_for_process; then
    echo "T0319 process did not become live at $SIZE" >&2
    exit 1
  fi
  if ! wait_for_foreground; then
    echo "T0319 MainActivity did not become foreground at $SIZE" >&2
    adb shell dumpsys window windows >&2 || true
    adb shell dumpsys activity activities >&2 || true
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
