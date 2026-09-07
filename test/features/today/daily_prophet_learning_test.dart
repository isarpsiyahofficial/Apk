import 'package:flutter_test/flutter_test.dart';
import 'package:islami_hayat/core/content/content_governance.dart';
import 'package:islami_hayat/features/prophets/data/canonical_prophet_biographies.dart';
import 'package:islami_hayat/features/prophets/data/prophet_biography_t0194_dataset.dart';
import 'package:islami_hayat/features/today/domain/daily_prophet_learning.dart';

void main() {
  test('daily learning is deterministic and source-backed', () {
    final date = DateTime(2026, 8, 30);
    final first = dailyProphetLearningForDate(date);
    final second = dailyProphetLearningForDate(date);

    expect(first, isNotNull);
    expect(second, isNotNull);
    expect(second!.prophetId, first!.prophetId);
    expect(second.sectionKey, first.sectionKey);
    expect(first.sectionKey, isNot(ProphetBiographySectionKey.mainMessage));
    expect(first.field.status, ProphetBiographyFieldStatus.sourceBacked);
    expect(first.field.sources, isNotEmpty);
    expect(isDailyProphetLearningFieldEligible(first.field), isTrue);
    expect(
      first.field.sources.every(
        (source) => source.locator?.trim().isNotEmpty ?? false,
      ),
      isTrue,
    );
    expect(
      canonicalProphetBiographyT0194Dataset.any(
        (biography) => biography.identity.canonicalId == first.prophetId,
      ),
      isTrue,
    );
  });

  test('a full year never promotes pending or weak research into recommendations', () {
    const allowedClasses = <ReligiousSourceClass>{
      ReligiousSourceClass.quran,
      ReligiousSourceClass.sahihHasanHadith,
      ReligiousSourceClass.earlyIslamicHistoryTafsir,
      ReligiousSourceClass.modernHistoryArchaeology,
    };

    for (var day = 0; day < 366; day++) {
      final suggestion = dailyProphetLearningForDate(
        DateTime.utc(2026, 1, 1).add(Duration(days: day)),
      );

      expect(suggestion, isNotNull, reason: 'day=$day');
      expect(
        suggestion!.field.status,
        ProphetBiographyFieldStatus.sourceBacked,
        reason: 'day=$day prophet=${suggestion.prophetId}',
      );
      expect(
        isDailyProphetLearningFieldEligible(suggestion.field),
        isTrue,
        reason: 'day=$day prophet=${suggestion.prophetId}',
      );
      expect(
        suggestion.field.sources.every(
          (source) =>
              allowedClasses.contains(source.sourceClass) &&
              (source.locator?.trim().isNotEmpty ?? false),
        ),
        isTrue,
        reason: 'day=$day prophet=${suggestion.prophetId}',
      );
    }
  });

  test('daily learning rejects traditional disputed occult and unrelated sources', () {
    const rejectedClasses = <ReligiousSourceClass>[
      ReligiousSourceClass.meaningBasedDua,
      ReligiousSourceClass.classicalTraditional,
      ReligiousSourceClass.israiliyat,
      ReligiousSourceClass.laterTradition,
      ReligiousSourceClass.ebcedHavasTradition,
      ReligiousSourceClass.disputed,
      ReligiousSourceClass.unknown,
    ];

    for (final sourceClass in rejectedClasses) {
      final field = ProphetBiographyField(
        text: const LocalizedReligiousText(
          tr: 'Doğrulama testi',
          en: 'Verification test',
          ar: 'اختبار التحقق',
        ),
        status: ProphetBiographyFieldStatus.sourceBacked,
        sources: <SourceReference>[
          SourceReference(
            id: 't0204-${sourceClass.name}',
            title: 'T0204 rejected provenance fixture',
            sourceClass: sourceClass,
            licenseId: 'TEST-ONLY',
            locator: 'fixture:1',
          ),
        ],
      );

      expect(
        isDailyProphetLearningFieldEligible(field),
        isFalse,
        reason: 'sourceClass=$sourceClass',
      );
    }
  });

  test('daily learning rejects missing locator even for an allowed source class', () {
    const field = ProphetBiographyField(
      text: LocalizedReligiousText(
        tr: 'Doğrulama testi',
        en: 'Verification test',
        ar: 'اختبار التحقق',
      ),
      status: ProphetBiographyFieldStatus.sourceBacked,
      sources: <SourceReference>[
        SourceReference(
          id: 't0204-quran-without-locator',
          title: 'Tanzil Project — Uthmani Quran Text v1.1',
          sourceClass: ReligiousSourceClass.quran,
          licenseId: 'CC-BY-3.0',
        ),
      ],
    );

    expect(isDailyProphetLearningFieldEligible(field), isFalse);
  });
}
