import 'dart:io';

import 'package:flutter_test/flutter_test.dart';

void main() {
  group('T0356 Android AdMob manifest contract', () {
    final manifest = File('android_hardening/AndroidManifest.xml');

    test('hardening manifest declares a syntactically valid AdMob application id', () {
      expect(manifest.existsSync(), isTrue);
      final source = manifest.readAsStringSync();

      final metadata = RegExp(
        r'<meta-data\s+android:name="com\.google\.android\.gms\.ads\.APPLICATION_ID"\s+android:value="([^"]+)"\s*/>',
        multiLine: true,
      ).firstMatch(source);

      expect(
        metadata,
        isNotNull,
        reason: 'google_mobile_ads crashes before Flutter startup when the Android '
            'manifest omits com.google.android.gms.ads.APPLICATION_ID.',
      );

      final appId = metadata!.group(1)!;
      expect(
        RegExp(r'^ca-app-pub-\d{16}~\d{10}$').hasMatch(appId),
        isTrue,
        reason: 'The manifest value must be an AdMob application ID, not an ad-unit ID.',
      );
    });

    test('development manifest uses Google sample App ID instead of live ad traffic', () {
      final source = manifest.readAsStringSync();
      expect(
        source,
        contains('ca-app-pub-3940256099942544~3347511713'),
        reason: 'CI/emulator verification must use Google\'s sample App ID until the '
            'production AdMob App ID is explicitly supplied for the final store artifact.',
      );
      expect(source, contains('development/CI verification only'));
      expect(source, contains('Replace with the production AdMob App ID'));
    });
  });
}
