import 'package:flutter_test/flutter_test.dart';
import 'package:islami_hayat/core/content/content_governance.dart';
import 'package:islami_hayat/features/religious_days/data/ramadan_content.dart';
import 'package:islami_hayat/features/religious_days/data/religious_day_content.dart';

void main() {
  group('T0172 Ramadan research guide', () {
    test('is comprehensive but remains fail-closed before expert/native review', () {
      final content = ramadanResearchContent;

      expect(content.title.isComplete, isTrue);
      expect(content.whatIsIt.isComplete, isTrue);
      expect(content.history.isComplete, isTrue);
      expect(content.record.reviewStatus, ContentReviewStatus.research);
      expect(content.canEnterProductionDataset, isFalse);

      expect(content.sectionsOf(ReligiousDayEvidenceKind.quranBasis), isNotEmpty);
      expect(content.sectionsOf(ReligiousDayEvidenceKind.hadithBasis), isNotEmpty);
      expect(content.sectionsOf(ReligiousDayEvidenceKind.strongReport), hasLength(2));
      expect(content.sectionsOf(ReligiousDayEvidenceKind.tradition), isNotEmpty);
      expect(content.sectionsOf(ReligiousDayEvidenceKind.specificWorship), isNotEmpty);
      expect(content.sectionsOf(ReligiousDayEvidenceKind.generalWorship), isNotEmpty);
    });

    test('Quran basis is pinned to 2:183-185 and Quran source class only', () {
      final section = ramadanResearchContent
          .sectionsOf(ReligiousDayEvidenceKind.quranBasis)
          .single;

      expect(section.certainty, CertaintyLevel.explicitSource);
      expect(section.sources, hasLength(1));
      expect(section.sources.single.id, 'quran-2-183-185-ramadan');
      expect(section.sources.single.locator, '2:183-185');
      expect(section.sources.single.sourceClass, ReligiousSourceClass.quran);
      expect(
        section.sources.single.licenseId,
        'tanzil-uthmani-v1.1-cc-by-3.0',
      );
    });

    test('suhur and timely iftar remain strong hadith guidance, not obligations', () {
      final reports = ramadanResearchContent
          .sectionsOf(ReligiousDayEvidenceKind.strongReport)
          .toList();

      expect(reports, hasLength(2));
      expect(
        reports.every((section) =>
            section.certainty == CertaintyLevel.stronglyAttested &&
            section.sources.every((source) =>
                source.sourceClass == ReligiousSourceClass.sahihHasanHadith)),
        isTrue,
      );

      final text = reports
          .expand((section) => [section.text.tr, section.text.en, section.text.ar])
          .join(' ')
          .toLowerCase();
      expect(text.contains('sahuru farz'), isFalse);
      expect(text.contains('suhur is obligatory'), isFalse);
      expect(text.contains('السحور واجب'), isFalse);
    });

    test('cultural Ramadan customs stay tradition-only', () {
      final section = ramadanResearchContent
          .sectionsOf(ReligiousDayEvidenceKind.tradition)
          .single;

      expect(section.certainty, CertaintyLevel.traditional);
      expect(
        section.sources.every(
          (source) => source.sourceClass == ReligiousSourceClass.laterTradition,
        ),
        isTrue,
      );
    });

    test('Ramadan fasting is the specific worship and uses only strong sources', () {
      final section = ramadanResearchContent
          .sectionsOf(ReligiousDayEvidenceKind.specificWorship)
          .single;

      expect(
        ramadanResearchContent.specificWorshipStatus,
        SpecificWorshipStatus.establishedByStrongSource,
      );
      expect(section.certainty, CertaintyLevel.explicitSource);
      expect(section.sources.map((source) => source.sourceClass).toSet(), {
        ReligiousSourceClass.quran,
        ReligiousSourceClass.sahihHasanHadith,
      });
      expect(section.sources.map((source) => source.id).toSet(), {
        'quran-2-183-185-ramadan',
        'bukhari-38-ramadan-fast',
      });
    });

    test('source metadata preserves reference-only status for third-party text', () {
      final nonQuranSources = ramadanResearchContent.record.sources
          .where((source) => source.sourceClass != ReligiousSourceClass.quran);

      expect(nonQuranSources, isNotEmpty);
      expect(
        nonQuranSources.every(
          (source) => source.licenseId.startsWith('reference-only-'),
        ),
        isTrue,
      );
      expect(
        ramadanResearchContent.record.sources.every(
          (source) => (source.locator ?? '').trim().isNotEmpty,
        ),
        isTrue,
      );
    });

    test('guide keeps personal fiqh and guaranteed-outcome claims out', () {
      final texts = <String>[
        ramadanResearchContent.whatIsIt.tr,
        ramadanResearchContent.whatIsIt.en,
        ramadanResearchContent.whatIsIt.ar,
        ramadanResearchContent.history.tr,
        ramadanResearchContent.history.en,
        ramadanResearchContent.history.ar,
        for (final section in ramadanResearchContent.evidence) ...[
          section.text.tr,
          section.text.en,
          section.text.ar,
        ],
      ].join(' ').toLowerCase();

      for (final forbidden in <String>[
        'kesin şifa',
        'kesin para',
        'kesin kabul',
        'guaranteed healing',
        'guaranteed wealth',
        'guaranteed acceptance',
      ]) {
        expect(texts.contains(forbidden), isFalse, reason: forbidden);
      }

      expect(texts.contains('tek başına hüküm üretmez'), isTrue);
      expect(texts.contains('does not independently issue rulings'), isTrue);
      expect(texts.contains('لا يصدر التطبيق من تلقاء نفسه أحكاماً'), isTrue);
    });
  });
}
