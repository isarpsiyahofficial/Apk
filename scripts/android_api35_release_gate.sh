#!/bin/sh
set -eu

run_gate() {
  gate_id="$1"
  gate_name="$2"
  shift 2

  echo "::group::${gate_id} ${gate_name}"
  echo "${gate_id} START: ${gate_name}"
  if "$@"; then
    echo "${gate_id} PASS: ${gate_name}"
    echo '::endgroup::'
    return 0
  fi

  status=$?
  echo "${gate_id} FAIL (${status}): ${gate_name}" >&2
  echo '::endgroup::'
  return "$status"
}

run_cold_start_gate() {
  COLD_START_APK=build/app/outputs/flutter-apk/app-release.apk \
    sh scripts/android_cold_start_t0315.sh
}

restore_debug_apk() {
  adb install -r build/app/outputs/flutter-apk/app-debug.apk >/dev/null
}

# Keep the Android 35 release/device contract fail-closed, but expose each
# independent gate in the Actions log. The previous workflow chained all gates
# in one shell expression, so a red job only identified the aggregate step and
# made a real product regression indistinguishable from a hosted-emulator
# transport/launcher failure without downloading raw logs.
run_gate T0314 'functional app launch smoke' sh scripts/android_emulator_smoke_retry.sh
run_gate T0251 'Android share-sheet smoke' sh scripts/android_share_sheet_smoke_t0251.sh
run_gate T0315 'release cold-start performance gate' run_cold_start_gate
run_gate T0315D 'restore debug APK after release performance gate' restore_debug_apk
run_gate T0319 'phone/tablet/orientation viewport matrix' sh scripts/android_device_matrix_t0319.sh
run_gate T0297 'real launcher widget pin/render/tap smoke' sh scripts/android_widget_launcher_smoke_t0297.sh

echo 'Android 35 release/device gate PASS'
