#!/bin/sh
set -eu

GATE_LOG_DIR="${GATE_LOG_DIR:-.ci/android-api35-gates}"
mkdir -p "$GATE_LOG_DIR"

run_gate() {
  gate_id="$1"
  gate_name="$2"
  shift 2
  gate_log="$GATE_LOG_DIR/${gate_id}.log"

  echo "::group::${gate_id} ${gate_name}"
  echo "${gate_id} START: ${gate_name}"
  if "$@" >"$gate_log" 2>&1; then
    cat "$gate_log"
    echo "${gate_id} PASS: ${gate_name}"
    echo '::endgroup::'
    return 0
  else
    status=$?
    cat "$gate_log" >&2
    echo "${gate_id} FAIL (${status}): ${gate_name}" >&2
    echo "${gate_id} diagnostic log: ${gate_log}" >&2
    echo '::endgroup::'
    return "$status"
  fi
}

run_cold_start_gate() {
  COLD_START_APK=build/app/outputs/flutter-apk/app-release.apk \
    sh scripts/android_cold_start_t0315.sh
}

restore_debug_apk() {
  adb install -r build/app/outputs/flutter-apk/app-debug.apk >/dev/null
}

# Keep the Android 35 release/device contract fail-closed while preserving the
# exact stdout/stderr of every independent gate. A failing child keeps its exit
# status; the per-gate log is retained for Actions artifact upload so hosted
# emulator regressions can be diagnosed without weakening or bypassing a gate.
run_gate T0314 'functional app launch smoke' sh scripts/android_emulator_smoke_retry.sh
run_gate T0251 'Android share-sheet smoke' sh scripts/android_share_sheet_smoke_t0251.sh
run_gate T0315 'release cold-start performance gate' run_cold_start_gate
run_gate T0315D 'restore debug APK after release performance gate' restore_debug_apk
run_gate T0319 'phone/tablet/orientation viewport matrix' sh scripts/android_device_matrix_t0319.sh
run_gate T0297 'real launcher widget pin/render/tap smoke' sh scripts/android_widget_launcher_smoke_t0297.sh

echo 'Android 35 release/device gate PASS'
