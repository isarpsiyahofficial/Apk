import 'dart:io';

import 'package:flutter_test/flutter_test.dart';

void main() {
  test('T0315 cold-start CI measures the release AOT APK, not debug/profile', () {
    final workflow = File('.github/workflows/android-emulator-smoke.yml')
        .readAsStringSync();
    final script = File('scripts/android_cold_start_t0315.sh').readAsStringSync();

    expect(
      workflow,
      contains('flutter build apk --release'),
      reason: 'Cold-start performance must reflect the final release/AOT app.',
    );
    expect(
      workflow,
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

  test('T0315 workflow keeps functional debug smoke separate from timing', () {
    final workflow = File('.github/workflows/android-emulator-smoke.yml')
        .readAsStringSync();

    final debugBuild = workflow.indexOf('flutter build apk --debug');
    final releaseBuild = workflow.indexOf('flutter build apk --release');
    final functionalSmoke = workflow.indexOf('android_emulator_smoke_retry.sh');
    final performanceGate = workflow.indexOf('android_cold_start_t0315.sh');

    expect(debugBuild, greaterThanOrEqualTo(0));
    expect(releaseBuild, greaterThan(debugBuild));
    expect(functionalSmoke, greaterThan(releaseBuild));
    expect(performanceGate, greaterThan(functionalSmoke));
  });
}
