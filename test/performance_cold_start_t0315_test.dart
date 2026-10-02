import 'dart:io';

import 'package:flutter_test/flutter_test.dart';

void main() {
  test('T0315 cold-start CI measures release AOT and proves lifecycle fail-closed', () {
    final workflow = File('.github/workflows/android-emulator-smoke.yml').readAsStringSync();
    final gate = File('scripts/android_api35_release_gate.sh').readAsStringSync();
    final script = File('scripts/android_cold_start_t0315.sh').readAsStringSync();

    expect(workflow, contains('flutter build apk --release'));
    expect(workflow, contains('script: sh scripts/android_api35_release_gate.sh'));
    expect(gate, contains('COLD_START_APK=build/app/outputs/flutter-apk/app-release.apk'));
    expect(workflow, isNot(contains('flutter build apk --profile')));
    expect(script, contains('adb install -r "\$COLD_START_APK"'));
    expect(script, contains('MAX_COLD_START_MS="\${MAX_COLD_START_MS:-3000}"'));
    expect(script, contains('adb shell am force-stop "\$PACKAGE"'));
    expect(script, contains('PRE_LAUNCH_PID="\$(adb shell pidof "\$PACKAGE"'));
    expect(script, contains('START_OUTPUT="\$(adb shell am start -W -n "\$ACTIVITY"'));
    expect(script, isNot(contains('am start -W -S -n')));
    expect(script, contains('RAW_LAUNCH_STATE="\$(printf'));
    expect(script, contains('LAUNCH_STATE="\${RAW_LAUNCH_STATE%% *}"'));
    expect(script, contains('UNKNOWN)'));
    expect(script, contains('sample \$sample was not cold (LaunchState=\$RAW_LAUNCH_STATE)'));
    expect(script, contains("'/^WaitTime:/ {print \$2; exit}'"));
    expect(script, contains('SAMPLE_COUNT=3'));

    // Android 35 may return from am start -W before pidof sees the spawned
    // process. Permit only a bounded observation delay; never convert absence
    // into success or alter the measured ActivityManager timing value.
    expect(script, contains('while [ "\$process_wait" -le 5 ]'));
    expect(script, contains('POST_LAUNCH_PID="\$(adb shell pidof "\$PACKAGE"'));
    expect(script, contains('sleep 1'));
    expect(script, contains('did not create an app process within 5 seconds'));
    expect(script, isNot(contains('POST_LAUNCH_PID=unknown')));
    expect(script, isNot(contains('|| echo')));
  });

  test('T0315/T0319 named gate isolates debug-only smoke from release timing', () {
    final workflow = File('.github/workflows/android-emulator-smoke.yml').readAsStringSync();
    final gate = File('scripts/android_api35_release_gate.sh').readAsStringSync();
    final debugBuild = workflow.indexOf('flutter build apk --debug');
    final releaseBuild = workflow.indexOf('flutter build apk --release');
    final namedGate = workflow.indexOf('scripts/android_api35_release_gate.sh');
    final functionalSmoke = gate.indexOf("run_gate T0314 'functional app launch smoke'");
    final shareSmoke = gate.indexOf("run_gate T0251 'Android share-sheet smoke'");
    final performanceGate = gate.indexOf("run_gate T0315 'release cold-start performance gate'");
    final debugRestore = gate.indexOf("run_gate T0315D 'restore debug APK after release performance gate'");
    final matrixGate = gate.indexOf("run_gate T0319 'phone/tablet/orientation viewport matrix'");
    final widgetSmoke = gate.indexOf("run_gate T0297 'real launcher widget pin/render/tap smoke'");
    expect(debugBuild, greaterThanOrEqualTo(0));
    expect(releaseBuild, greaterThan(debugBuild));
    expect(namedGate, greaterThan(releaseBuild));
    expect(functionalSmoke, greaterThanOrEqualTo(0));
    expect(shareSmoke, greaterThan(functionalSmoke));
    expect(performanceGate, greaterThan(shareSmoke));
    expect(debugRestore, greaterThan(performanceGate));
    expect(matrixGate, greaterThan(debugRestore));
    expect(widgetSmoke, greaterThan(matrixGate));
  });

  test('named Android 35 wrapper preserves failure status and diagnostics', () {
    final workflow = File('.github/workflows/android-emulator-smoke.yml').readAsStringSync();
    final gate = File('scripts/android_api35_release_gate.sh').readAsStringSync();
    expect(gate, startsWith('#!/bin/sh\nset -eu'));
    expect(gate, contains('GATE_LOG_DIR="\${GATE_LOG_DIR:-.ci/android-api35-gates}"'));
    expect(gate, contains('if "\$@" >"\$gate_log" 2>&1; then'));
    expect(gate, contains('status=\$?'));
    expect(gate, contains('return "\$status"'));
    expect(gate, isNot(contains('|| true')));
    expect(workflow, contains('- name: Upload Android 35 gate diagnostics'));
    expect(workflow, contains('if: failure()'));
    expect(workflow, contains('path: .ci/android-api35-gates/*.log'));
  });

  test('T0319 matrix helper remains fail-closed', () {
    final script = File('scripts/android_device_matrix_t0319.sh').readAsStringSync();
    final launchFunction = script.indexOf('launch_viewport() {');
    final loopStart = script.indexOf('for SIZE in 360x800 430x932 800x1280 1280x800 1920x1080 932x430');
    final forceStop = script.indexOf('adb shell am force-stop "\$PACKAGE"', launchFunction);
    final resize = script.indexOf('adb shell wm size "\$SIZE"', launchFunction);
    final sizeCheck = script.indexOf('wait_for_size "\$SIZE"', launchFunction);
    final launch = script.indexOf('adb shell am start -W -n "\$ACTIVITY"', launchFunction);
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
    expect(script, contains('while [ "\$launch_attempt" -le 2 ]'));
    expect(script, contains('fatal/OOM evidence found at \$SIZE; refusing retry'));
  });
}
