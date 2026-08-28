import 'package:flutter_test/flutter_test.dart';
import 'package:islami_hayat/features/topic_search/data/quran_theme_taxonomy.dart';
import 'package:islami_hayat/features/topic_search/data/quran_theme_verse_mappings.dart';

void main() {
  group('T0151 QuranThemeVerseCatalog', () {
    test('every taxonomy theme has exactly one mapping candidate', () {
      final themeIds = QuranThemeTaxonomy.themes.map((theme) => theme.id).toSet();
      final mappingIds = QuranThemeVerseCatalog.mappings.map((mapping) => mapping.themeId).toList();

      expect(mappingIds, hasLength(themeIds.length));
      expect(mappingIds.toSet(), themeIds);
    });

    test('every mapping has at least three unique canonical verse references', () {
      for (final mapping in QuranThemeVerseCatalog.mappings) {
        expect(mapping.hasRequiredVerseCount, isTrue, reason: mapping.themeId);
        expect(mapping.hasUniqueCanonicalReferences, isTrue, reason: mapping.themeId);
      }
    });

    test('review candidates fail closed until expert evidence exists', () {
      for (final mapping in QuranThemeVerseCatalog.mappings) {
        expect(mapping.reviewStatus, QuranThemeMappingReviewStatus.awaitingExpertReview);
        expect(mapping.hasExpertReviewEvidence, isFalse);
        expect(mapping.isProductionReady, isFalse);
        expect(QuranThemeVerseCatalog.productionMappingFor(mapping.themeId), isNull);
      }
    });

    test('approved mapping without reviewer evidence still fails closed', () {
      const mapping = QuranThemeVerseMapping(
        themeId: 'patience',
        verses: [
          QuranVerseReference(2, 153),
          QuranVerseReference(2, 155),
          QuranVerseReference(3, 200),
        ],
        reviewStatus: QuranThemeMappingReviewStatus.approved,
      );

      expect(mapping.hasExpertReviewEvidence, isFalse);
      expect(mapping.isProductionReady, isFalse);
    });

    test('invalid and duplicate canonical references are rejected', () {
      const invalid = QuranThemeVerseMapping(
        themeId: 'patience',
        verses: [
          QuranVerseReference(2, 153),
          QuranVerseReference(2, 153),
          QuranVerseReference(114, 99),
        ],
      );

      expect(invalid.hasRequiredVerseCount, isTrue);
      expect(invalid.hasUniqueCanonicalReferences, isFalse);
      expect(invalid.isProductionReady, isFalse);
    });

    test('unknown theme never becomes a production mapping', () {
      const mapping = QuranThemeVerseMapping(
        themeId: 'invented_theme',
        verses: [
          QuranVerseReference(2, 153),
          QuranVerseReference(3, 159),
          QuranVerseReference(39, 53),
        ],
      );

      expect(QuranThemeTaxonomy.byId(mapping.themeId), isNull);
      expect(mapping.isProductionReady, isFalse);
      expect(QuranThemeVerseCatalog.productionMappingFor('invented_theme'), isNull);
    });

    test('high-risk illness mapping remains spiritual support only', () {
      final mapping = QuranThemeVerseCatalog.byThemeId('illness_spiritual_support');
      expect(mapping, isNotNull);
      expect(mapping!.verses.map((verse) => verse.key).toSet(), {'10:57', '17:82', '26:80'});
      expect(mapping.isProductionReady, isFalse);
    });
  });
}
