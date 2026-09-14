import 'dart:io';

import 'package:flutter_test/flutter_test.dart';

void main() {
  test('T0315 cold-start CI measures the release AOT APK, not debug/profile', () {
    final workflow = File('.github/workflows/android-emulator-smoke.yml')
        .readAsStringSync();
    final gate =
        File('scripts/android_api35_release_gate.sh').readAsStringSync();
    final script = File('scripts/android_cold_start_t0315.sh').readAsStringSync();

    expect(
      workflow,
      contains('flutter build apk --release'),
      reason: 'Cold-start performance must reflect the final release/AOT app.',
    );
    expect(
      workflow,
      contains('script: sh scripts/android_api35_release_gate.sh'),
      reason: 'Android 35 must execute the named fail-closed release gate.',
    );
    expect(
      gate,
      contains('COLD_START_APK=build/app/outputs/flutter-apk/app-release.apk'),
      reason: 'The Android 35 gate must explicitly install the release APK.',
    );
    expect(
      workflow,
      isNot(contains('flutter build apk --profile')),
      reason: 'Profile instrumentation must not distort the release gate.',
    );
    expect(
      script,
      contains('adb install -r "\$COLD_START_APK"'),
      reason: 'The selected performance artifact must actually be installed.',
    );
    expect(
      script,
      contains('MAX_COLD_START_MS="\${MAX_COLD_START_MS:-3000}"'),
      reason: 'The <=3 second release requirement must stay strict.',
    );
    expect(
      script,
      contains('adb shell am force-stop "\$PACKAGE"'),
      reason: 'Every timing sample must begin from a force-stopped package.',
    );
    expect(
      script,
      contains('PRE_LAUNCH_PID="\$(adb shell pidof "\$PACKAGE"'),
      reason: 'Cold state must be proven by process absence before launch.',
    );
    expect(
      script,
      contains("START_OUTPUT=\"\$(adb shell am start -W -S -n \"\$ACTIVITY\""),
      reason: 'Timing must come from an ActivityManager wait launch.',
    );
    expect(
      script,
      contains('RAW_LAUNCH_STATE="\$(printf'),
      reason:
          'The platform-reported launch state must be preserved for audit output.',
    );
    expect(
      script,
      contains('LAUNCH_STATE="\${RAW_LAUNCH_STATE%% *}"'),
      reason:
          'Android 35 variants such as UNKNOWN (0) must normalize to UNKNOWN without widening the allow-list.',
    );
    expect(
      script,
      contains('UNKNOWN)'),
      reason: 'Android 35 UNKNOWN LaunchState needs an explicit guarded path.',
    );
    expect(
      script,
      contains('sample \$sample was not cold (LaunchState=\$RAW_LAUNCH_STATE)'),
      reason:
          'HOT/WARM or any other non-cold state must remain fail-closed and retain raw diagnostics.',
    );
    expect(
      script,
      contains("'/^WaitTime:/ {print \$2; exit}'"),
      reason: 'WaitTime may be used only as the same -W invocation fallback.',
    );
    expect(script, contains('SAMPLE_COUNT=3'));
  });

  test('T0315/T0319 named gate isolates debug-only smoke from release timing', () {
    final workflow = File('.github/workflows/android-emulator-smoke.yml')
        .readAsStringSync();
    final gate =
        File('scripts/android_api35_release_gate.sh').readAsStringSync();

    final debugBuild = workflow.indexOf('flutter build apk --debug');
    final releaseBuild = workflow.indexOf('flutter build apk --release');
    final namedGate = workflow.indexOf('scripts/android_api35_release_gate.sh');

    // Order must be measured from the actual run_gate invocations, not helper
    // function bodies. Helper definitions can mention the same script names
    // before execution starts and would make an indexOf-based contract lie.
    final functionalSmoke = gate.indexOf(
      "run_gate T0314 'functional app launch smoke'",
    );
    final shareSmoke = gate.indexOf(
      "run_gate T0251 'Android share-sheet smoke'",
    );
    final performanceGate = gate.indexOf(
      "run_gate T0315 'release cold-start performance gate'",
    );
    final debugRestore = gate.indexOf(
      "run_gate T0315D 'restore debug APK after release performance gate'",
    );
    final matrixGate = gate.indexOf(
      "run_gate T0319 'phone/tablet/orientation viewport matrix'",
    );
    final widgetSmoke = gate.indexOf(
      "run_gate T0297 'real launcher widget pin/render/tap smoke'",
    );

    expect(debugBuild, greaterThanOrEqualTo(0));
    expect(releaseBuild, greaterThan(debugBuild));
    expect(namedGate, greaterThan(releaseBuild));
    expect(functionalSmoke, greaterThanOrEqualTo(0));
    expect(shareSmoke, greaterThan(functionalSmoke));
    expect(
      performanceGate,
      greaterThan(shareSmoke),
      reason: 'Debug-only share activity must run before release APK replaces it.',
    );
    expect(
      debugRestore,
      greaterThan(performanceGate),
      reason: 'Functional debug APK must be restored after release timing.',
    );
    expect(matrixGate, greaterThan(debugRestore));
    expect(widgetSmoke, greaterThan(matrixGate));
  });

  test('named Android 35 wrapper preserves failure status and diagnostics', () {
    final workflow = File('.github/workflows/android-emulator-smoke.yml')
        .readAsStringSync();
    final gate =
        File('scripts/android_api35_release_gate.sh').readAsStringSync();

    expect(gate, startsWith('#!/bin/sh\nset -eu'));
    expect(gate, contains('GATE_LOG_DIR="\${GATE_LOG_DIR:-.ci/android-api35-gates}"'));
    expect(gate, contains('if "\$@" >"\$gate_log" 2>&1; then'));
    expect(gate, contains('status=\$?'));
    expect(gate, contains('return "\$status"'));
    expect(gate, isNot(contains('|| true')));
    expect(gate, contains('diagnostic log: \${gate_log}'));
    expect(gate, contains("run_gate T0314 'functional app launch smoke'"));
    expect(gate, contains("run_gate T0251 'Android share-sheet smoke'"));
    expect(gate, contains("run_gate T0315 'release cold-start performance gate'"));
    expect(gate, contains("run_gate T0319 'phone/tablet/orientation viewport matrix'"));
    expect(gate, contains("run_gate T0297 'real launcher widget pin/render/tap smoke'"));

    expect(workflow, contains('- name: Upload Android 35 gate diagnostics'));
    expect(workflow, contains('if: failure()'));
    expect(workflow, contains('uses: actions/upload-artifact@v4'));
    expect(workflow, contains('path: .ci/android-api35-gates/*.log'));
    expect(workflow, contains('if-no-files-found: error'));
  });

  test('T0319 matrix cold-launch helper resizes, verifies, launches, and retries fail-closed', () {
    final script = File('scripts/android_device_matrix_t0319.sh')
        .readAsStringSync();

    final launchFunction = script.indexOf('launch_viewport() {');
    final loopStart = script.indexOf(
      'for SIZE in 360x800 430x932 800x1280 1280x800 1920x1080 932x430',
    );
    final forceStop = script.indexOf(
      'adb shell am force-stop "\$PACKAGE"',
      launchFunction,
    );
    final resize = script.indexOf('adb shell wm size "\$SIZE"', launchFunction);
    final sizeCheck = script.indexOf('wait_for_size "\$SIZE"', launchFunction);
    final launch = script.indexOf(
      'adb shell am start -W -n "\$ACTIVITY"',
      launchFunction,
    );
    final fatalCheck = script.indexOf('fatal_or_oom_evidence', launch);
    final loopCall = script.indexOf('launch_viewport "\$SIZE"', loopStart);

    expect(launchFunction, greaterThanOrEqualTo(0));
    expect(forceStop, greaterThan(launchFunction));
    expect(resize, greaterThan(forceStop));
    expect(sizeCheck, greaterThan(resize));
    expect(launch, greaterThan(sizeCheck));
    expect(fatalCheck, greaterThan(launch));
    expect(loopStart, greaterThan(fatalCheck));
    expect(loopCall, greaterThan(loopStart));
    expect(
      script,
      contains("grep -F \"Override size: \$EXPECTED\""),
      reason: 'Each emulator viewport must be confirmed before launch.',
    );
    expect(script, contains('while [ "\$launch_attempt" -le 2 ]'));
    expect(
      script,
      contains('fatal/OOM evidence found at \$SIZE; refusing retry'),
      reason: 'A real fatal/OOM signal must never be hidden by the retry path.',
    );
    expect(script, contains('dump_failure_evidence'));
  });
}
