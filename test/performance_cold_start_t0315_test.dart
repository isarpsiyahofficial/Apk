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
    expect(script, contains("grep -Fq 'LaunchState: COLD'"));
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

    final functionalSmoke = gate.indexOf('android_emulator_smoke_retry.sh');
    final shareSmoke = gate.indexOf('android_share_sheet_smoke_t0251.sh');
    final performanceGate = gate.indexOf('android_cold_start_t0315.sh');
    final debugRestore = gate.indexOf(
      'adb install -r build/app/outputs/flutter-apk/app-debug.apk',
    );
    final matrixGate = gate.indexOf('android_device_matrix_t0319.sh');
    final widgetSmoke = gate.indexOf('android_widget_launcher_smoke_t0297.sh');

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
    expect(
      gate,
      contains("run_gate T0315 'release cold-start performance gate'"),
      reason: 'Release timing must remain an independently named fail-closed gate.',
    );
  });

  test('T0319 matrix stops app before resize and confirms viewport override', () {
    final script = File('scripts/android_device_matrix_t0319.sh')
        .readAsStringSync();

    final loopStart = script.indexOf(
      'for SIZE in 360x800 430x932 800x1280 1280x800 1920x1080 932x430',
    );
    final forceStop = script.indexOf('adb shell am force-stop "\$PACKAGE"', loopStart);
    final resize = script.indexOf('adb shell wm size "\$SIZE"', loopStart);
    final sizeCheck = script.indexOf('wait_for_size "\$SIZE"', loopStart);
    final launch = script.indexOf('adb shell am start -W -n "\$ACTIVITY"', loopStart);

    expect(loopStart, greaterThanOrEqualTo(0));
    expect(forceStop, greaterThan(loopStart));
    expect(resize, greaterThan(forceStop));
    expect(sizeCheck, greaterThan(resize));
    expect(launch, greaterThan(sizeCheck));
    expect(
      script,
      contains("grep -F \"Override size: \$EXPECTED\""),
      reason: 'Each emulator viewport must be confirmed before launch.',
    );
    expect(script, contains('dump_failure_evidence'));
  });
}
