import 'dart:io';

import 'package:flutter_test/flutter_test.dart';
import 'package:islami_hayat/core/privacy/telemetry_policy_t0300.dart';

void main() {
  test('T0300 keeps all V1 telemetry channels disabled', () {
    for (final channel in PrivacyEgressChannelT0300.values) {
      expect(TelemetryPolicyT0300.isEnabled(channel), isFalse);
      expect(
        () => TelemetryPolicyT0300.requireDisabled(channel),
        returnsNormally,
      );
    }
  });

  test('T0300 forbidden analytics and marketing packages are absent', () {
    final pubspec = File('pubspec.yaml').readAsStringSync();

    for (final package in TelemetryPolicyT0300.forbiddenFlutterPackages) {
      expect(
        RegExp('^\\s*${RegExp.escape(package)}\\s*:', multiLine: true)
            .hasMatch(pubspec),
        isFalse,
        reason: '$package must not enter the V1 dependency graph',
      );
    }
  });
}
