import 'package:flutter_test/flutter_test.dart';
import 'package:islami_hayat/features/topic_search/data/quran_theme_taxonomy.dart';
import 'package:islami_hayat/features/topic_search/data/quran_theme_verse_mappings.dart';
import 'package:islami_hayat/features/topic_search/domain/topic_health_safety_policy.dart';
import 'package:islami_hayat/features/topic_search/domain/topic_theme_confidence_gate.dart';
import 'package:islami_hayat/features/topic_search/domain/topic_verse_result_resolver.dart';

void main() {
  group('TopicHealthSafetyPolicy', () {
    test('requires a professional-help notice only for illness support', () {
      expect(
        TopicHealthSafetyPolicy.requiresProfessionalHelpNotice(
          const ['illness_spiritual_support'],
        ),
        isTrue,
      );
      expect(
        TopicHealthSafetyPolicy.requiresProfessionalHelpNotice(
          const ['patience', 'hope'],
        ),
        isFalse,
      );
    });

    test('fixed TR EN AR notices never claim diagnosis or treatment', () {
      final tr = TopicHealthSafetyPolicy.noticeFor(
        const ['illness_spiritual_support'],
        locale: TopicSafetyLocale.tr,
      )!;
      final en = TopicHealthSafetyPolicy.noticeFor(
        const ['illness_spiritual_support'],
        locale: TopicSafetyLocale.en,
      )!;
      final ar = TopicHealthSafetyPolicy.noticeFor(
        const ['illness_spiritual_support'],
        locale: TopicSafetyLocale.ar,
      )!;

      expect(tr, contains('yerini tutmaz'));
      expect(tr, contains('tıbbi tanı'));
      expect(en, contains('does not replace'));
      expect(en, contains('not medical diagnosis'));
      expect(ar, contains('لا يغني عن'));
      expect(ar, contains('ليس تشخيصًا طبيًا'));
    });

    test('non-health themes do not receive a medical disclaimer', () {
      expect(
        TopicHealthSafetyPolicy.noticeFor(
          const ['patience'],
          locale: TopicSafetyLocale.tr,
        ),
        isNull,
      );
    });
  });

  group('TopicVerseResultResolver health integration', () {
    QuranThemeDefinition approvedTheme(String id) {
      return QuranThemeDefinition(
        id: id,
        labelTr: 'Hastalıkta manevi destek',
        labelEn: 'Spiritual support during illness',
        labelAr: 'الدعم الروحي عند المرض',
        reviewStatus: QuranThemeReviewStatus.approved,
      );
    }

    QuranThemeVerseMapping approvedMapping(String id) {
      return QuranThemeVerseMapping(
        themeId: id,
        verses: const [
          QuranVerseReference(17, 82),
          QuranVerseReference(21, 83),
          QuranVerseReference(26, 80),
        ],
        reviewStatus: QuranThemeMappingReviewStatus.approved,
        reviewerId: 'religious-reviewer-health-test',
        reviewedAtUtc: DateTime.utc(2026, 8, 29),
      );
    }

    test('reviewed illness result cannot be returned without safety notice', () {
      const themeId = 'illness_spiritual_support';
      final resolver = TopicVerseResultResolver(
        themes: [approvedTheme(themeId)],
        mappings: [approvedMapping(themeId)],
      );

      final result = resolver.resolve(
        TopicThemeDecision.matchedThemes(const [themeId]),
        locale: TopicResultLocale.tr,
        maximumVerses: 3,
      );

      expect(result, isNotNull);
      expect(result!.themeIds, const [themeId]);
      expect(result.safetyNotice, isNotNull);
      expect(result.safetyNotice, contains('manevi destek'));
      expect(result.safetyNotice, contains('yerini tutmaz'));
    });

    test('multi-theme result still carries illness safety notice', () {
      const illness = 'illness_spiritual_support';
      const patience = 'patience';
      final resolver = TopicVerseResultResolver(
        themes: [
          approvedTheme(illness),
          const QuranThemeDefinition(
            id: patience,
            labelTr: 'Sabır',
            labelEn: 'Patience',
            labelAr: 'الصبر',
            reviewStatus: QuranThemeReviewStatus.approved,
          ),
        ],
        mappings: [
          approvedMapping(illness),
          QuranThemeVerseMapping(
            themeId: patience,
            verses: const [
              QuranVerseReference(2, 153),
              QuranVerseReference(2, 155),
              QuranVerseReference(3, 200),
            ],
            reviewStatus: QuranThemeMappingReviewStatus.approved,
            reviewerId: 'religious-reviewer-patience-test',
            reviewedAtUtc: DateTime.utc(2026, 8, 29),
          ),
        ],
      );

      final result = resolver.resolve(
        TopicThemeDecision.matchedThemes(const [patience, illness]),
        locale: TopicResultLocale.en,
        maximumVerses: 4,
      );

      expect(result, isNotNull);
      expect(result!.safetyNotice, contains('does not replace'));
      expect(result.safetyNotice, contains('health professional'));
    });
  });
}
