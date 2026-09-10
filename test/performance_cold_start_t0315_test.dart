import 'dart:io';

import 'package:flutter_test/flutter_test.dart';

void main() {
  test('T0315 cold-start CI measures an AOT profile APK, not debug/JIT', () {
    final workflow = File('.github/workflows/android-emulator-smoke.yml')
        .readAsStringSync();
    final script = File('scripts/android_cold_start_t0315.sh').readAsStringSync();

    expect(
      workflow,
      contains('flutter build apk --profile'),
      reason: 'Cold-start performance must be measured on AOT/profile code.',
    );
    expect(
      workflow,
      contains('COLD_START_APK=build/app/outputs/flutter-apk/app-profile.apk'),
      reason: 'The Android 35 gate must explicitly select the profile APK.',
    );
    expect(
      script,
      contains('adb install -r "$COLD_START_APK"'),
      reason: 'The selected performance artifact must actually be installed.',
    );
    expect(
      script,
      contains('MAX_COLD_START_MS="${MAX_COLD_START_MS:-3000}"'),
      reason: 'The <=3 second release requirement must stay strict.',
    );
    expect(script, contains("grep -Fq 'LaunchState: COLD'"));
    expect(script, contains('SAMPLE_COUNT=3'));
  });

  test('T0315 workflow keeps functional debug smoke separate from timing', () {
    final workflow = File('.github/workflows/android-emulator-smoke.yml')
        .readAsStringSync();

    final debugBuild = workflow.indexOf('flutter build apk --debug');
    final profileBuild = workflow.indexOf('flutter build apk --profile');
    final functionalSmoke = workflow.indexOf('android_emulator_smoke_retry.sh');
    final performanceGate = workflow.indexOf('android_cold_start_t0315.sh');

    expect(debugBuild, greaterThanOrEqualTo(0));
    expect(profileBuild, greaterThan(debugBuild));
    expect(functionalSmoke, greaterThan(profileBuild));
    expect(performanceGate, greaterThan(functionalSmoke));
  });
}
