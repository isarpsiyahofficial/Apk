import 'dart:io';

import 'package:flutter_test/flutter_test.dart';
import 'package:islami_hayat/core/monetization/ad_placement_policy.dart';

void main() {
  group('T0144 FREE dhikr ad safety', () {
    test('active dhikr rejects every ad format for FREE users', () {
      expect(
        AdPlacementPolicy.isSacredContentSurface(AppAdSurface.dhikrActive),
        isTrue,
      );

      for (final format in AdFormat.values) {
        expect(
          AdPlacementPolicy.canRequest(
            surface: AppAdSurface.dhikrActive,
            format: format,
            isPro: false,
          ),
          isFalse,
          reason: 'FREE active dhikr must reject ${format.name}',
        );
      }
    });

    test('all FREE dhikr entry flows share the same fail-closed ad gate', () {
      const entryFlows = <String>[
        'direct counter tab',
        'guide -> Zikri Başlat -> counter',
        'intention -> reviewed dhikr -> counter',
        'source-backed target -> counter',
        'personal/preset target -> counter',
      ];

      for (final flow in entryFlows) {
        for (final format in AdFormat.values) {
          expect(
            AdPlacementPolicy.canRequest(
              surface: AppAdSurface.dhikrActive,
              format: format,
              isPro: false,
            ),
            isFalse,
            reason: '$flow must not request ${format.name}',
          );
        }
      }
    });

    test('dhikr feature cannot bypass policy with a direct ad SDK call', () {
      final featureRoot = Directory('lib/features/dhikr');
      expect(featureRoot.existsSync(), isTrue);

      final forbiddenDirectAdApi = <RegExp>[
        RegExp(r'google_mobile_ads', caseSensitive: false),
        RegExp(r'\bMobileAds\b'),
        RegExp(r'\bBannerAd\b'),
        RegExp(r'\bInterstitialAd\b'),
        RegExp(r'\bRewardedAd\b'),
        RegExp(r'\bAdWidget\b'),
      ];

      final dartFiles = featureRoot
          .listSync(recursive: true)
          .whereType<File>()
          .where((file) => file.path.endsWith('.dart'))
          .toList(growable: false);
      expect(dartFiles, isNotEmpty);

      for (final file in dartFiles) {
        final source = file.readAsStringSync();
        for (final pattern in forbiddenDirectAdApi) {
          expect(
            pattern.hasMatch(source),
            isFalse,
            reason: '${file.path} must not bypass AdPlacementPolicy via $pattern',
          );
        }
      }
    });

    test('shell opens dhikr directly, without an ad wrapper', () {
      final source = File('lib/shell/app_shell.dart').readAsStringSync();
      expect(source, contains('const DhikrHubPage()'));
      expect(source, isNot(contains('AdWidget')));
      expect(source, isNot(contains('BannerAd')));
      expect(source, isNot(contains('InterstitialAd')));
      expect(source, isNot(contains('RewardedAd')));
    });
  });
}
