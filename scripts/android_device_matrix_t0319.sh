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

wait_for_size() {
  EXPECTED="$1"
  attempt=0
  while [ "$attempt" -lt 10 ]; do
    SIZE_STATE="$(adb shell wm size 2>/dev/null | tr -d '\r' || true)"
    if printf '%s\n' "$SIZE_STATE" | grep -F "Override size: $EXPECTED" >/dev/null; then
      return 0
    fi
    attempt=$((attempt + 1))
    sleep 1
  done
  return 1
}

fatal_or_oom_evidence() {
  adb logcat -d '*:E' | grep -E 'FATAL EXCEPTION|AndroidRuntime.*Process: com\.example\.islami_hayat|OutOfMemoryError|lowmemorykiller.*com\.example\.islami_hayat|lmkd.*com\.example\.islami_hayat' || true
}

dump_failure_evidence() {
  echo 'T0319 diagnostics: window/activity state' >&2
  adb shell dumpsys window windows >&2 || true
  adb shell dumpsys activity activities >&2 || true
  echo 'T0319 diagnostics: fatal/OOM logcat' >&2
  fatal_or_oom_evidence >&2
}

launch_viewport() {
  SIZE="$1"
  launch_attempt=1

  while [ "$launch_attempt" -le 2 ]; do
    # Low-memory API 29 runners can occasionally evict a just-started process
    # while SurfaceFlinger/launcher settles after a wm-size change. Each attempt
    # remains a true cold launch; a real fatal/OOM signal is never retried away.
    adb shell am force-stop "$PACKAGE" >/dev/null 2>&1 || true
    adb shell wm size "$SIZE" >/dev/null
    if ! wait_for_size "$SIZE"; then
      echo "T0319 viewport override was not applied at $SIZE" >&2
      dump_failure_evidence
      return 1
    fi

    adb logcat -c
    START="$(adb shell am start -W -n "$ACTIVITY" 2>&1 | tr -d '\r')"
    printf '%s\n' "$START"

    if ! printf '%s\n' "$START" | grep -F "$PACKAGE" >/dev/null; then
      echo "T0319 launch output did not reference expected package at $SIZE (attempt $launch_attempt/2)" >&2
    elif wait_for_process && wait_for_foreground; then
      return 0
    else
      echo "T0319 app did not stabilize at $SIZE (attempt $launch_attempt/2)" >&2
    fi

    FATAL_NOW="$(fatal_or_oom_evidence)"
    if [ -n "$FATAL_NOW" ]; then
      echo "T0319 fatal/OOM evidence found at $SIZE; refusing retry" >&2
      printf '%s\n' "$FATAL_NOW" >&2
      dump_failure_evidence
      return 1
    fi

    if [ "$launch_attempt" -eq 2 ]; then
      dump_failure_evidence
      return 1
    fi

    echo "T0319 transient low-memory launch loss at $SIZE; retrying one cold launch"
    sleep 2
    launch_attempt=$((launch_attempt + 1))
  done

  return 1
}

adb shell wm density 160 >/dev/null
adb logcat -c

for SIZE in 360x800 430x932 800x1280 1280x800 1920x1080 932x430; do
  echo "T0319 viewport smoke: $SIZE @160dpi"
  if ! launch_viewport "$SIZE"; then
    exit 1
  fi
done

FATAL="$(fatal_or_oom_evidence)"
if [ -n "$FATAL" ]; then
  echo 'T0319 fatal/OOM evidence found during device matrix:' >&2
  printf '%s\n' "$FATAL" >&2
  exit 1
fi

echo 'T0319 Android viewport/orientation matrix PASS'
