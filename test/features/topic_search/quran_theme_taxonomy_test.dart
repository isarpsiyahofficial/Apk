import 'package:flutter_test/flutter_test.dart';
import 'package:islami_hayat/features/topic_search/data/quran_theme_taxonomy.dart';

void main() {
  group('T0150 QuranThemeTaxonomy', () {
    test('contains every SPEC 214 starting theme exactly once', () {
      const expectedIds = <String>{
        'patience',
        'anxiety',
        'fear',
        'hope',
        'loneliness',
        'repentance',
        'forgiveness_from_god',
        'family',
        'parents',
        'marriage',
        'love_mercy',
        'anger',
        'forgiving_others',
        'justice',
        'injustice',
        'provision',
        'debt',
        'work',
        'decision',
        'trust_in_god',
        'illness_spiritual_support',
        'loss',
        'death',
        'gratitude',
        'supplication',
      };

      final actualIds = QuranThemeTaxonomy.themes.map((theme) => theme.id).toList();
      expect(actualIds, hasLength(expectedIds.length));
      expect(actualIds.toSet(), expectedIds);
    });

    test('TR EN AR labels are complete and IDs are stable machine keys', () {
      final idPattern = RegExp(r'^[a-z][a-z0-9_]*$');
      for (final theme in QuranThemeTaxonomy.themes) {
        expect(theme.id, matches(idPattern));
        expect(theme.labelTr.trim(), isNotEmpty);
        expect(theme.labelEn.trim(), isNotEmpty);
        expect(theme.labelAr.trim(), isNotEmpty);
      }
    });

    test('taxonomy is expert-review ready but fail-closed for production', () {
      for (final theme in QuranThemeTaxonomy.themes) {
        expect(theme.reviewStatus, QuranThemeReviewStatus.awaitingExpertReview);
        expect(theme.isProductionReady, isFalse);
      }
    });

    test('unknown theme ID does not silently fall back to another theme', () {
      expect(QuranThemeTaxonomy.byId('not_a_real_theme'), isNull);
      expect(QuranThemeTaxonomy.byId(''), isNull);
    });

    test('high-risk illness theme remains explicitly spiritual support', () {
      final theme = QuranThemeTaxonomy.byId('illness_spiritual_support');
      expect(theme, isNotNull);
      expect(theme!.labelTr, 'Hastalıkta manevi destek');
      expect(theme.labelEn, 'Spiritual support during illness');
      expect(theme.labelAr, 'الدعم الروحي عند المرض');
    });
  });
}
