import 'dart:io';

import 'package:flutter_test/flutter_test.dart';
import 'package:islami_hayat/core/monetization/ad_placement_policy.dart';

void main() {
  group('FREE sacred-content ad placement gate', () {
    const sacredSurfaces = <AppAdSurface>[
      AppAdSurface.quranReader,
      AppAdSurface.quranSearch,
      AppAdSurface.dailyVerse,
      AppAdSurface.duaReader,
      AppAdSurface.dhikrActive,
    ];

    test('every sacred surface rejects every ad format for FREE and PRO', () {
      for (final surface in sacredSurfaces) {
        expect(
          AdPlacementPolicy.isSacredContentSurface(surface),
          isTrue,
          reason: '${surface.name} must remain classified as sacred content',
        );
        for (final isPro in <bool>[false, true]) {
          for (final format in AdFormat.values) {
            expect(
              AdPlacementPolicy.canRequest(
                surface: surface,
                format: format,
                isPro: isPro,
              ),
              isFalse,
              reason:
                  '${surface.name} must reject ${format.name} (isPro=$isPro)',
            );
          }
        }
      }
    });

    test('FREE allow-list contains only home banner and share rewarded', () {
      for (final surface in AppAdSurface.values) {
        for (final format in AdFormat.values) {
          final allowed = AdPlacementPolicy.canRequest(
            surface: surface,
            format: format,
            isPro: false,
          );
          final expected =
              (surface == AppAdSurface.todayHome && format == AdFormat.banner) ||
              (surface == AppAdSurface.shareDesignUnlock &&
                  format == AdFormat.rewarded);
          expect(
            allowed,
            expected,
            reason: 'Unexpected FREE ad permission: ${surface.name}/${format.name}',
          );
        }
      }
    });

    test('core sacred feature roots cannot bypass policy with direct SDK APIs', () {
      const sacredFeatureRoots = <String>[
        'lib/features/quran',
        'lib/features/dua',
        'lib/features/dhikr',
      ];
      final forbiddenDirectAdApi = <RegExp>[
        RegExp(r'google_mobile_ads', caseSensitive: false),
        RegExp(r'\bMobileAds\b'),
        RegExp(r'\bBannerAd\b'),
        RegExp(r'\bInterstitialAd\b'),
        RegExp(r'\bRewardedAd\b'),
        RegExp(r'\bAdWidget\b'),
      ];

      for (final rootPath in sacredFeatureRoots) {
        final root = Directory(rootPath);
        expect(root.existsSync(), isTrue, reason: '$rootPath must exist');
        final dartFiles = root
            .listSync(recursive: true)
            .whereType<File>()
            .where((file) => file.path.endsWith('.dart'))
            .toList(growable: false);
        expect(dartFiles, isNotEmpty, reason: '$rootPath must contain Dart code');

        for (final file in dartFiles) {
          final source = file.readAsStringSync();
          for (final pattern in forbiddenDirectAdApi) {
            expect(
              pattern.hasMatch(source),
              isFalse,
              reason:
                  '${file.path} must not bypass AdPlacementPolicy via $pattern',
            );
          }
        }
      }
    });
  });
}
