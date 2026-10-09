import 'package:flutter_test/flutter_test.dart';
import 'package:islami_hayat/features/topic_search/data/quran_theme_taxonomy.dart';
import 'package:islami_hayat/features/topic_search/data/quran_theme_verse_mappings.dart';
import 'package:islami_hayat/features/topic_search/domain/topic_theme_confidence_gate.dart';
import 'package:islami_hayat/features/topic_search/domain/topic_verse_result_resolver.dart';

void main() {
  List<QuranThemeReviewEvidence> approvedThemeEvidence(String themeId) {
    return QuranThemeReviewKind.values
        .map(
          (kind) => QuranThemeReviewEvidence(
            themeId: themeId,
            taxonomyRevision: QuranThemeTaxonomy.revision,
            kind: kind,
            decision: QuranThemeReviewDecision.approved,
            reviewerId: 'test-${kind.name}',
            reviewedAtUtc: '2026-09-03T05:30:00Z',
          ),
        )
        .toList(growable: false);
  }

  QuranThemeDefinition approvedTheme(
    String id,
    String tr,
    String en,
    String ar,
  ) {
    return QuranThemeDefinition(
      id: id,
      labelTr: tr,
      labelEn: en,
      labelAr: ar,
      reviewStatus: QuranThemeReviewStatus.approved,
      reviewEvidence: approvedThemeEvidence(id),
    );
  }

  QuranThemeVerseMapping approvedMapping(
    String themeId,
    List<QuranVerseReference> verses,
  ) {
    return QuranThemeVerseMapping(
      themeId: themeId,
      verses: verses,
      reviewStatus: QuranThemeMappingReviewStatus.approved,
      reviewerId: 'religious-reviewer-01',
      reviewedAtUtc: DateTime.utc(2026, 8, 29),
    );
  }

  test('returns 3-5 reviewed verses instead of a single oracle verse', () {
    final resolver = TopicVerseResultResolver(
      themes: [approvedTheme('patience', 'Sabır', 'Patience', 'الصبر')],
      mappings: [
        approvedMapping('patience', const [
          QuranVerseReference(2, 153),
          QuranVerseReference(2, 155),
          QuranVerseReference(3, 200),
          QuranVerseReference(8, 46),
          QuranVerseReference(16, 126),
        ]),
      ],
    );

    final result = resolver.resolve(
      TopicThemeDecision.matchedThemes(const ['patience']),
      locale: TopicResultLocale.tr,
    );

    expect(result, isNotNull);
    expect(result!.verses.map((v) => v.key), [
      '2:153',
      '2:155',
      '3:200',
      '8:46',
      '16:126',
    ]);
    expect(
      result.whyShown,
      'Bu neden gösterildi? Sorunda Sabır teması tespit edildi.',
    );
  });

  test('single-theme why explanation stays grammatically singular in TR EN AR', () {
    final resolver = TopicVerseResultResolver(
      themes: [approvedTheme('patience', 'Sabır', 'Patience', 'الصبر')],
      mappings: [
        approvedMapping('patience', const [
          QuranVerseReference(2, 153),
          QuranVerseReference(2, 155),
          QuranVerseReference(3, 200),
        ]),
      ],
    );
    final decision = TopicThemeDecision.matchedThemes(const ['patience']);

    expect(
      resolver.resolve(decision, locale: TopicResultLocale.tr)!.whyShown,
      'Bu neden gösterildi? Sorunda Sabır teması tespit edildi.',
    );
    expect(
      resolver.resolve(decision, locale: TopicResultLocale.en)!.whyShown,
      'Why was this shown? Your query matched the Patience theme.',
    );
    expect(
      resolver.resolve(decision, locale: TopicResultLocale.ar)!.whyShown,
      'لماذا ظهر هذا؟ تم رصد موضوع الصبر في سؤالك.',
    );
  });

  test('multi-theme result round-robins reviewed verse sets and explains both', () {
    final resolver = TopicVerseResultResolver(
      themes: [
        approvedTheme('patience', 'Sabır', 'Patience', 'الصبر'),
        approvedTheme('anxiety', 'Kaygı', 'Anxiety', 'القلق'),
      ],
      mappings: [
        approvedMapping('patience', const [
          QuranVerseReference(2, 153),
          QuranVerseReference(2, 155),
          QuranVerseReference(3, 200),
        ]),
        approvedMapping('anxiety', const [
          QuranVerseReference(13, 28),
          QuranVerseReference(2, 286),
          QuranVerseReference(94, 5),
        ]),
      ],
    );

    final result = resolver.resolve(
      TopicThemeDecision.matchedThemes(const ['patience', 'anxiety']),
      locale: TopicResultLocale.en,
      maximumVerses: 4,
    );

    expect(result, isNotNull);
    expect(result!.verses.map((v) => v.key), [
      '2:153',
      '13:28',
      '2:155',
      '2:286',
    ]);
    expect(
      result.whyShown,
      'Why was this shown? Your query matched the Patience and Anxiety themes.',
    );
  });

  test('fails closed for clarification decisions', () {
    final resolver = TopicVerseResultResolver(
      themes: [approvedTheme('patience', 'Sabır', 'Patience', 'الصبر')],
      mappings: [
        approvedMapping('patience', const [
          QuranVerseReference(2, 153),
          QuranVerseReference(2, 155),
          QuranVerseReference(3, 200),
        ]),
      ],
    );

    expect(
      resolver.resolve(
        TopicThemeDecision.clarifyTheme(
          candidateThemeIds: const ['patience'],
        ),
        locale: TopicResultLocale.tr,
      ),
      isNull,
    );
  });

  test('fails closed when even one requested theme lacks expert approval', () {
    final resolver = TopicVerseResultResolver(
      themes: [
        approvedTheme('patience', 'Sabır', 'Patience', 'الصبر'),
        const QuranThemeDefinition(
          id: 'anxiety',
          labelTr: 'Kaygı',
          labelEn: 'Anxiety',
          labelAr: 'القلق',
        ),
      ],
      mappings: [
        approvedMapping('patience', const [
          QuranVerseReference(2, 153),
          QuranVerseReference(2, 155),
          QuranVerseReference(3, 200),
        ]),
        approvedMapping('anxiety', const [
          QuranVerseReference(13, 28),
          QuranVerseReference(2, 286),
          QuranVerseReference(94, 5),
        ]),
      ],
    );

    expect(
      resolver.resolve(
        TopicThemeDecision.matchedThemes(const ['patience', 'anxiety']),
        locale: TopicResultLocale.tr,
      ),
      isNull,
    );
  });

  test('production catalog remains fail-closed before real expert review', () {
    final resolver = TopicVerseResultResolver.productionCatalog();

    expect(
      resolver.resolve(
        TopicThemeDecision.matchedThemes(const ['patience']),
        locale: TopicResultLocale.ar,
      ),
      isNull,
    );
  });

  test('deduplicates overlapping multi-theme verses', () {
    final resolver = TopicVerseResultResolver(
      themes: [
        approvedTheme('hope', 'Ümit', 'Hope', 'الرجاء'),
        approvedTheme('repentance', 'Tövbe', 'Repentance', 'التوبة'),
      ],
      mappings: [
        approvedMapping('hope', const [
          QuranVerseReference(39, 53),
          QuranVerseReference(12, 87),
          QuranVerseReference(94, 5),
        ]),
        approvedMapping('repentance', const [
          QuranVerseReference(39, 53),
          QuranVerseReference(25, 70),
          QuranVerseReference(66, 8),
        ]),
      ],
    );

    final result = resolver.resolve(
      TopicThemeDecision.matchedThemes(const ['hope', 'repentance']),
      locale: TopicResultLocale.ar,
      maximumVerses: 5,
    );

    expect(result, isNotNull);
    expect(result!.verses.map((v) => v.key).toSet().length, result.verses.length);
    expect(result.verses.length, inInclusiveRange(3, 5));
    expect(result.whyShown, contains('الرجاء'));
    expect(result.whyShown, contains('التوبة'));
    expect(result.whyShown, startsWith('لماذا ظهر هذا؟'));
  });

  test('rejects result windows outside the SPEC 3-5 range', () {
    final resolver = TopicVerseResultResolver(
      themes: [approvedTheme('patience', 'Sabır', 'Patience', 'الصبر')],
      mappings: [
        approvedMapping('patience', const [
          QuranVerseReference(2, 153),
          QuranVerseReference(2, 155),
          QuranVerseReference(3, 200),
        ]),
      ],
    );

    expect(
      () => resolver.resolve(
        TopicThemeDecision.matchedThemes(const ['patience']),
        locale: TopicResultLocale.tr,
        maximumVerses: 2,
      ),
      throwsArgumentError,
    );
    expect(
      () => resolver.resolve(
        TopicThemeDecision.matchedThemes(const ['patience']),
        locale: TopicResultLocale.tr,
        maximumVerses: 6,
      ),
      throwsArgumentError,
    );
  });
}
