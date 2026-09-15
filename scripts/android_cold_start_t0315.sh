#!/bin/sh
set -eu

PACKAGE='com.example.islami_hayat'
ACTIVITY="$PACKAGE/.MainActivity"
MAX_COLD_START_MS="${MAX_COLD_START_MS:-3000}"
COLD_START_APK="${COLD_START_APK:-}"
SAMPLE_COUNT=3
SAMPLES_FILE="${TMPDIR:-/tmp}/t0315_cold_start_$$.txt"

cleanup() { rm -f "$SAMPLES_FILE"; }
trap cleanup EXIT INT TERM

case "$MAX_COLD_START_MS" in ''|*[!0-9]*) echo "MAX_COLD_START_MS must be a positive integer, got: $MAX_COLD_START_MS" >&2; exit 1;; esac
if [ "$MAX_COLD_START_MS" -le 0 ]; then echo 'MAX_COLD_START_MS must be greater than zero' >&2; exit 1; fi

if [ -n "$COLD_START_APK" ]; then
  if [ ! -f "$COLD_START_APK" ]; then echo "T0315 cold-start gate: requested performance APK not found: $COLD_START_APK" >&2; exit 1; fi
  echo "T0315 installing performance APK: $COLD_START_APK"
  adb install -r "$COLD_START_APK"
fi

: > "$SAMPLES_FILE"

# Cold state is proven before every sample by explicit force-stop plus process
# absence. `am start -S` is intentionally not used because it adds a second
# stop/start race on Android 35. Some Android 35 emulator builds also return
# from `am start -W` before pidof observes the newly spawned process. That is
# not treated as success: process visibility is polled for a bounded 5 seconds
# and the gate still fails closed if the app never becomes alive.
sample=1
while [ "$sample" -le "$SAMPLE_COUNT" ]; do
  adb shell am force-stop "$PACKAGE"
  sleep 1

  PRE_LAUNCH_PID="$(adb shell pidof "$PACKAGE" 2>/dev/null | tr -d '\r' || true)"
  if [ -n "$PRE_LAUNCH_PID" ]; then
    echo "T0315 cold-start gate: sample $sample still had a process after force-stop (pid=$PRE_LAUNCH_PID)" >&2
    exit 1
  fi

  START_OUTPUT="$(adb shell am start -W -n "$ACTIVITY" 2>&1 | tr -d '\r')"
  printf '%s\n' "$START_OUTPUT"
  if ! printf '%s\n' "$START_OUTPUT" | grep -Fq 'Status: ok'; then echo "T0315 cold-start gate: sample $sample did not report Status: ok" >&2; exit 1; fi

  RAW_LAUNCH_STATE="$(printf '%s\n' "$START_OUTPUT" | awk -F': ' '/^LaunchState:/ {print $2; exit}')"
  LAUNCH_STATE="${RAW_LAUNCH_STATE%% *}"
  case "$LAUNCH_STATE" in
    COLD) ;;
    UNKNOWN) echo "T0315 cold-start sample $sample: Android reported LaunchState $RAW_LAUNCH_STATE; accepting only because pre-launch process absence was verified" ;;
    '') echo "T0315 cold-start gate: sample $sample did not report LaunchState" >&2; exit 1 ;;
    *) echo "T0315 cold-start gate: sample $sample was not cold (LaunchState=$RAW_LAUNCH_STATE)" >&2; exit 1 ;;
  esac

  POST_LAUNCH_PID=''
  process_wait=1
  while [ "$process_wait" -le 5 ]; do
    POST_LAUNCH_PID="$(adb shell pidof "$PACKAGE" 2>/dev/null | tr -d '\r' || true)"
    [ -n "$POST_LAUNCH_PID" ] && break
    sleep 1
    process_wait=$((process_wait + 1))
  done
  if [ -z "$POST_LAUNCH_PID" ]; then
    echo "T0315 cold-start gate: sample $sample did not create an app process within 5 seconds" >&2
    adb shell dumpsys activity activities 2>/dev/null | grep -E -m 3 "${PACKAGE}|topResumedActivity|mResumedActivity" >&2 || true
    exit 1
  fi

  TOTAL_TIME_MS="$(printf '%s\n' "$START_OUTPUT" | awk -F': ' '/^TotalTime:/ {print $2; exit}')"
  METRIC_NAME='TotalTime'
  if [ -z "$TOTAL_TIME_MS" ]; then TOTAL_TIME_MS="$(printf '%s\n' "$START_OUTPUT" | awk -F': ' '/^WaitTime:/ {print $2; exit}')"; METRIC_NAME='WaitTime'; fi
  case "$TOTAL_TIME_MS" in ''|*[!0-9]*) echo "T0315 cold-start gate: invalid/missing TotalTime and WaitTime in sample $sample: $TOTAL_TIME_MS" >&2; exit 1;; esac

  printf '%s\n' "$TOTAL_TIME_MS" >> "$SAMPLES_FILE"
  echo "T0315 cold-start sample $sample/$SAMPLE_COUNT: ${TOTAL_TIME_MS}ms ($METRIC_NAME, pid=$POST_LAUNCH_PID, LaunchState=$RAW_LAUNCH_STATE)"
  sample=$((sample + 1))
done

MEDIAN_TIME_MS="$(sort -n "$SAMPLES_FILE" | sed -n '2p')"
case "$MEDIAN_TIME_MS" in ''|*[!0-9]*) echo "T0315 cold-start gate: could not calculate median: $MEDIAN_TIME_MS" >&2; exit 1;; esac
if [ "$MEDIAN_TIME_MS" -gt "$MAX_COLD_START_MS" ]; then echo "T0315 cold-start FAIL: median ${MEDIAN_TIME_MS}ms > ${MAX_COLD_START_MS}ms" >&2; echo 'Samples:' >&2; cat "$SAMPLES_FILE" >&2; exit 1; fi
echo "T0315 cold-start PASS: median ${MEDIAN_TIME_MS}ms <= ${MAX_COLD_START_MS}ms"

PID="$(adb shell pidof "$PACKAGE" | tr -d '\r' || true)"
if [ -z "$PID" ]; then echo 'T0315 cold-start gate: app process is not alive after launch' >&2; exit 1; fi
FOREGROUND="$(adb shell dumpsys activity activities 2>/dev/null | tr -d '\r' | grep -E -m 1 "(mResumedActivity|topResumedActivity|ResumedActivity).*${PACKAGE}/(\.MainActivity|${PACKAGE}\.MainActivity)" || true)"
if [ -z "$FOREGROUND" ]; then FOREGROUND="$(adb shell dumpsys window windows 2>/dev/null | tr -d '\r' | grep -E -m 1 "(mCurrentFocus|mFocusedApp).*${PACKAGE}/(\.MainActivity|${PACKAGE}\.MainActivity)" || true)"; fi
if [ -z "$FOREGROUND" ]; then echo 'T0315 cold-start gate: MainActivity is not foreground-visible after launch' >&2; exit 1; fi
echo "T0315 foreground/process verification PASS (pid=$PID)"
