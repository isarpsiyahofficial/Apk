import 'dart:io';

import 'package:flutter_test/flutter_test.dart';

void main() {
  group('T0295 reboot schedule restore contract', () {
    late String manifest;

    setUpAll(() {
      manifest = File('android_hardening/AndroidManifest.xml').readAsStringSync();
    });

    test('requests RECEIVE_BOOT_COMPLETED in the hardened production manifest', () {
      expect(
        manifest,
        contains(
          '<uses-permission android:name="android.permission.RECEIVE_BOOT_COMPLETED" />',
        ),
      );
    });

    test('packages flutter_local_notifications scheduling receivers', () {
      expect(
        manifest,
        contains(
          'com.dexterous.flutterlocalnotifications.ScheduledNotificationReceiver',
        ),
      );
      expect(
        manifest,
        contains(
          'com.dexterous.flutterlocalnotifications.ScheduledNotificationBootReceiver',
        ),
      );
    });

    test('boot receiver listens to reboot and package-replacement restore paths', () {
      expect(
        manifest,
        contains('<action android:name="android.intent.action.BOOT_COMPLETED" />'),
      );
      expect(
        manifest,
        contains('<action android:name="android.intent.action.MY_PACKAGE_REPLACED" />'),
      );
      expect(
        manifest,
        contains('<action android:name="android.intent.action.QUICKBOOT_POWERON" />'),
      );
      expect(
        manifest,
        contains('<action android:name="com.htc.intent.action.QUICKBOOT_POWERON" />'),
      );
    });

    test('boot receiver is not exported to arbitrary callers', () {
      final receiverStart = manifest.indexOf(
        'com.dexterous.flutterlocalnotifications.ScheduledNotificationBootReceiver',
      );
      expect(receiverStart, greaterThanOrEqualTo(0));
      final receiverWindow = manifest.substring(
        receiverStart,
        manifest.indexOf('</receiver>', receiverStart),
      );
      expect(receiverWindow, contains('android:exported="false"'));
    });
  });
}
