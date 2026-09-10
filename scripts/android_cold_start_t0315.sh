#!/bin/sh
set -eu

PACKAGE='com.example.islami_hayat'
ACTIVITY="$PACKAGE/.MainActivity"
MAX_COLD_START_MS="${MAX_COLD_START_MS:-3000}"
COLD_START_APK="${COLD_START_APK:-}"
SAMPLE_COUNT=3
SAMPLES_FILE="${TMPDIR:-/tmp}/t0315_cold_start_$$.txt"

cleanup() {
  rm -f "$SAMPLES_FILE"
}
trap cleanup EXIT INT TERM

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

if [ -n "$COLD_START_APK" ]; then
  if [ ! -f "$COLD_START_APK" ]; then
    echo "T0315 cold-start gate: requested performance APK not found: $COLD_START_APK" >&2
    exit 1
  fi
  echo "T0315 installing performance APK: $COLD_START_APK"
  adb install -r "$COLD_START_APK"
fi

: > "$SAMPLES_FILE"

# The performance gate must reflect ahead-of-time compiled app behavior rather
# than Flutter debug/JIT overhead. CI passes the profile APK explicitly. Every
# sample force-stops the package and asks ActivityManager for a new process, so
# all three timings are genuine cold launches while retaining normal app data.
# A median keeps the <=3s product requirement strict without allowing a single
# noisy hosted-runner scheduling spike to decide the release gate.
sample=1
while [ "$sample" -le "$SAMPLE_COUNT" ]; do
  adb shell am force-stop "$PACKAGE"
  sleep 1

  START_OUTPUT="$(adb shell am start -W -S -n "$ACTIVITY" 2>&1 | tr -d '\r')"
  printf '%s\n' "$START_OUTPUT"

  if ! printf '%s\n' "$START_OUTPUT" | grep -Fq 'Status: ok'; then
    echo "T0315 cold-start gate: sample $sample did not report Status: ok" >&2
    exit 1
  fi
  if ! printf '%s\n' "$START_OUTPUT" | grep -Fq 'LaunchState: COLD'; then
    echo "T0315 cold-start gate: sample $sample was not a COLD launch" >&2
    exit 1
  fi

  TOTAL_TIME_MS="$(printf '%s\n' "$START_OUTPUT" | awk -F': ' '/^TotalTime:/ {print $2; exit}')"
  case "$TOTAL_TIME_MS" in
    ''|*[!0-9]*)
      echo "T0315 cold-start gate: invalid/missing TotalTime in sample $sample: $TOTAL_TIME_MS" >&2
      exit 1
      ;;
  esac

  printf '%s\n' "$TOTAL_TIME_MS" >> "$SAMPLES_FILE"
  echo "T0315 cold-start sample $sample/$SAMPLE_COUNT: ${TOTAL_TIME_MS}ms"
  sample=$((sample + 1))
done

MEDIAN_TIME_MS="$(sort -n "$SAMPLES_FILE" | sed -n '2p')"
case "$MEDIAN_TIME_MS" in
  ''|*[!0-9]*)
    echo "T0315 cold-start gate: could not calculate median: $MEDIAN_TIME_MS" >&2
    exit 1
    ;;
esac

if [ "$MEDIAN_TIME_MS" -gt "$MAX_COLD_START_MS" ]; then
  echo "T0315 cold-start FAIL: median ${MEDIAN_TIME_MS}ms > ${MAX_COLD_START_MS}ms" >&2
  echo 'Samples:' >&2
  cat "$SAMPLES_FILE" >&2
  exit 1
fi

echo "T0315 cold-start PASS: median ${MEDIAN_TIME_MS}ms <= ${MAX_COLD_START_MS}ms"

# A timing number is not sufficient if the app immediately crashes or never
# becomes foreground-visible after the final ActivityManager launch.
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
