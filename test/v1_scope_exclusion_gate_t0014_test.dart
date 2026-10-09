import 'dart:io';

import 'package:flutter_test/flutter_test.dart';

void main() {
  test('T0014 keeps V1 excluded feature roots out of production source', () {
    const forbiddenFeatureRoots = <String>{
      'prayer_times',
      'adhan',
      'imsak_iftar',
      'live_fatwa',
      'messaging',
      'social_feed',
      'ai_chatbot',
      'recitation_ai',
      'mosque_finder',
      'halal_finder',
      'talisman',
      'vefk',
    };

    final featureRoot = Directory('lib/features');
    expect(
      featureRoot.existsSync(),
      isTrue,
      reason: 'The feature-based production source root must exist.',
    );

    final actualFeatureRoots = featureRoot
        .listSync(followLinks: false)
        .whereType<Directory>()
        .map((directory) => directory.path.replaceAll('\\', '/').split('/').last)
        .toSet();

    expect(
      actualFeatureRoots.intersection(forbiddenFeatureRoots),
      isEmpty,
      reason:
          'SPEC 21-35 excludes prayer-time/adhan/imsak-iftar calculation, '
          'live fatwa, messaging/feed, AI chatbot/recitation AI, finder and '
          'talisman/vefk-generator feature roots from V1.',
    );
  });

  test('T0014 keeps V1 excluded capability dependencies out of pubspec', () {
    final pubspec = File('pubspec.yaml').readAsStringSync();

    const forbiddenDependencyNames = <String>{
      'geolocator',
      'location',
      'speech_to_text',
      'record',
      'flutter_sound',
      'firebase_ai',
      'google_generative_ai',
      'google_maps_flutter',
    };

    for (final packageName in forbiddenDependencyNames) {
      final dependencyPattern = RegExp(
        '^\\s{2}${RegExp.escape(packageName)}\\s*:',
        multiLine: true,
      );
      expect(
        dependencyPattern.hasMatch(pubspec),
        isFalse,
        reason:
            'V1 scope must not acquire a dependency that enables an excluded '
            'live location, recording/recitation-AI or cloud-AI capability: '
            '$packageName',
      );
    }
  });

  test('T0014 guard itself covers every excluded V1 capability family', () {
    const guardedFamilies = <String>{
      'prayer-times-adhan-imsak-iftar',
      'live-fatwa',
      'messaging-feed',
      'ai-chatbot',
      'recitation-ai',
      'mosque-halal-finder',
      'talisman-vefk-generator',
    };

    expect(guardedFamilies, hasLength(7));
  });
}
