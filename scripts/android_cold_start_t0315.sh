#!/bin/sh
set -eu

PACKAGE='com.example.islami_hayat'
ACTIVITY="$PACKAGE/.MainActivity"
MAX_COLD_START_MS="${MAX_COLD_START_MS:-3000}"

case "$MAX_COLD_START_MS" in
  ''|*[!0-9]*)
    echo "MAX_COLD_START_MS must be a positive integer, got: $MAX_COLD_START_MS" >&2
    exit 1
    ;;
esac
if [ "$MAX_COLD_START_MS" -le 0 ]; then
  echo 'MAX_COLD_START_MS must be greater than zero' >&2
  exit 1
fi

# The APK is installed by the core emulator smoke before this gate. Force-stop
# guarantees a new app process while keeping package data intact, matching a
# normal user cold launch rather than an artificial reinstall/first-run setup.
adb shell am force-stop "$PACKAGE"
sleep 1

START_OUTPUT="$(adb shell am start -W -S -n "$ACTIVITY" 2>&1 | tr -d '\r')"
printf '%s\n' "$START_OUTPUT"

if ! printf '%s\n' "$START_OUTPUT" | grep -Fq 'Status: ok'; then
  echo 'T0315 cold-start gate: ActivityManager did not report Status: ok' >&2
  exit 1
fi

TOTAL_TIME_MS="$(printf '%s\n' "$START_OUTPUT" | awk -F': ' '/^TotalTime:/ {print $2; exit}')"
case "$TOTAL_TIME_MS" in
  ''|*[!0-9]*)
    echo "T0315 cold-start gate: invalid/missing TotalTime: $TOTAL_TIME_MS" >&2
    exit 1
    ;;
esac

if [ "$TOTAL_TIME_MS" -gt "$MAX_COLD_START_MS" ]; then
  echo "T0315 cold-start FAIL: ${TOTAL_TIME_MS}ms > ${MAX_COLD_START_MS}ms" >&2
  exit 1
fi

echo "T0315 cold-start PASS: ${TOTAL_TIME_MS}ms <= ${MAX_COLD_START_MS}ms"

# A timing number is not sufficient if the app immediately crashes or never
# becomes foreground-visible after ActivityManager reports launch completion.
PID="$(adb shell pidof "$PACKAGE" | tr -d '\r' || true)"
if [ -z "$PID" ]; then
  echo 'T0315 cold-start gate: app process is not alive after launch' >&2
  exit 1
fi

FOREGROUND="$(adb shell dumpsys activity activities 2>/dev/null | tr -d '\r' | grep -E -m 1 "(mResumedActivity|topResumedActivity|ResumedActivity).*${PACKAGE}/(\.MainActivity|${PACKAGE}\.MainActivity)" || true)"
if [ -z "$FOREGROUND" ]; then
  FOREGROUND="$(adb shell dumpsys window windows 2>/dev/null | tr -d '\r' | grep -E -m 1 "(mCurrentFocus|mFocusedApp).*${PACKAGE}/(\.MainActivity|${PACKAGE}\.MainActivity)" || true)"
fi
if [ -z "$FOREGROUND" ]; then
  echo 'T0315 cold-start gate: MainActivity is not foreground-visible after launch' >&2
  exit 1
fi

echo "T0315 foreground/process verification PASS (pid=$PID)"
