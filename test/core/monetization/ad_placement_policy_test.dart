import 'package:flutter_test/flutter_test.dart';
import 'package:islami_hayat/core/monetization/ad_placement_policy.dart';

void main() {
  group('AdPlacementPolicy', () {
    test('Quran surfaces fail closed for every ad format in FREE', () {
      const quranSurfaces = <AppAdSurface>[
        AppAdSurface.quranReader,
        AppAdSurface.quranSearch,
        AppAdSurface.dailyVerse,
      ];

      for (final surface in quranSurfaces) {
        expect(AdPlacementPolicy.isSacredContentSurface(surface), isTrue);
        for (final format in AdFormat.values) {
          expect(
            AdPlacementPolicy.canRequest(
              surface: surface,
              format: format,
              isPro: false,
            ),
            isFalse,
            reason: '${surface.name}/${format.name} must never request ads',
          );
        }
      }
    });

    test('dua reader and active dhikr also fail closed for every format', () {
      const protectedSurfaces = <AppAdSurface>[
        AppAdSurface.duaReader,
        AppAdSurface.dhikrActive,
      ];

      for (final surface in protectedSurfaces) {
        for (final format in AdFormat.values) {
          expect(
            AdPlacementPolicy.canRequest(
              surface: surface,
              format: format,
              isPro: false,
            ),
            isFalse,
          );
        }
      }
    });

    test('PRO suppresses every ad request on every surface and format', () {
      for (final surface in AppAdSurface.values) {
        for (final format in AdFormat.values) {
          expect(
            AdPlacementPolicy.canRequest(
              surface: surface,
              format: format,
              isPro: true,
            ),
            isFalse,
            reason: 'PRO ${surface.name}/${format.name} must be zero-ad',
          );
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
              (surface == AppAdSurface.todayHome &&
                  format == AdFormat.banner) ||
              (surface == AppAdSurface.shareDesignUnlock &&
                  format == AdFormat.rewarded);
          expect(
            allowed,
            expected,
            reason: 'Unexpected FREE permission: ${surface.name}/${format.name}',
          );
        }
      }
    });
  });
}
