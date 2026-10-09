import 'package:flutter_test/flutter_test.dart';
import 'package:islami_hayat/core/content/content_governance.dart';
import 'package:islami_hayat/features/religious_days/data/laylat_al_qadr_content.dart';
import 'package:islami_hayat/features/religious_days/data/religious_day_content.dart';

void main() {
  group('T0171 Laylat al-Qadr research file', () {
    test('is comprehensive but remains fail-closed before expert/native review', () {
      final content = laylatAlQadrResearchContent;

      expect(content.title.isComplete, isTrue);
      expect(content.whatIsIt.isComplete, isTrue);
      expect(content.history.isComplete, isTrue);
      expect(content.record.reviewStatus, ContentReviewStatus.research);
      expect(content.canEnterProductionDataset, isFalse);

      expect(content.sectionsOf(ReligiousDayEvidenceKind.quranBasis), isNotEmpty);
      expect(content.sectionsOf(ReligiousDayEvidenceKind.hadithBasis), isNotEmpty);
      expect(content.sectionsOf(ReligiousDayEvidenceKind.strongReport), isNotEmpty);
      expect(content.sectionsOf(ReligiousDayEvidenceKind.tradition), isNotEmpty);
      expect(content.sectionsOf(ReligiousDayEvidenceKind.specificWorship), isNotEmpty);
      expect(content.sectionsOf(ReligiousDayEvidenceKind.generalWorship), isNotEmpty);
    });

    test('all SPEC 306 evidence areas are explicitly reviewed', () {
      final content = laylatAlQadrResearchContent;

      expect(content.hasCompleteRequiredReviewCoverage, isTrue);
      expect(
        content.reviewedEvidenceKinds,
        containsAll(ReligiousDayContent.requiredReviewedEvidenceKinds),
      );
      expect(
        content.sectionsOf(ReligiousDayEvidenceKind.disputedReport),
        isEmpty,
        reason: 'Reviewed with no standalone disputed-report claim in the research record.',
      );
    });

    test('Quran basis is pinned to Surah 97 and only Quran source class', () {
      final section = laylatAlQadrResearchContent
          .sectionsOf(ReligiousDayEvidenceKind.quranBasis)
          .single;

      expect(section.certainty, CertaintyLevel.explicitSource);
      expect(section.sources, hasLength(1));
      expect(section.sources.single.id, 'quran-97-al-qadr');
      expect(section.sources.single.locator, '97:1-5');
      expect(section.sources.single.sourceClass, ReligiousSourceClass.quran);
      expect(
        section.sources.single.licenseId,
        'tanzil-uthmani-v1.1-cc-by-3.0',
      );
    });

    test('odd last-ten guidance stays strong while 27th-night practice stays tradition', () {
      final hadith = laylatAlQadrResearchContent
          .sectionsOf(ReligiousDayEvidenceKind.hadithBasis)
          .single;
      final tradition = laylatAlQadrResearchContent
          .sectionsOf(ReligiousDayEvidenceKind.tradition)
          .single;

      expect(hadith.certainty, CertaintyLevel.stronglyAttested);
      expect(
        hadith.sources.every(
          (source) => source.sourceClass == ReligiousSourceClass.sahihHasanHadith,
        ),
        isTrue,
      );
      expect(tradition.certainty, CertaintyLevel.traditional);
      expect(
        tradition.sources.every(
          (source) => source.sourceClass == ReligiousSourceClass.laterTradition,
        ),
        isTrue,
      );

      final allStrongText = '${hadith.text.tr} ${hadith.text.en} ${hadith.text.ar}'.toLowerCase();
      expect(allStrongText.contains('27'), isFalse);
      expect(allStrongText.contains('twenty-seventh'), isFalse);
    });

    test('specific worship is sourced only by strong hadith references', () {
      final section = laylatAlQadrResearchContent
          .sectionsOf(ReligiousDayEvidenceKind.specificWorship)
          .single;

      expect(
        laylatAlQadrResearchContent.specificWorshipStatus,
        SpecificWorshipStatus.establishedByStrongSource,
      );
      expect(section.certainty, CertaintyLevel.stronglyAttested);
      expect(section.sources.map((source) => source.id).toSet(), {
        'bukhari-2014',
        'tirmidhi-3513',
      });
      expect(
        section.sources.every(
          (source) => source.sourceClass == ReligiousSourceClass.sahihHasanHadith,
        ),
        isTrue,
      );
    });

    test('source metadata makes copied-translation status explicit', () {
      final nonQuranSources = laylatAlQadrResearchContent.record.sources
          .where((source) => source.sourceClass != ReligiousSourceClass.quran);

      expect(nonQuranSources, isNotEmpty);
      expect(
        nonQuranSources.every(
          (source) => source.licenseId.startsWith('reference-only-'),
        ),
        isTrue,
      );
      expect(
        laylatAlQadrResearchContent.record.sources.every(
          (source) => (source.locator ?? '').trim().isNotEmpty,
        ),
        isTrue,
      );
    });

    test('content does not turn the night into a guaranteed outcome claim', () {
      final texts = <String>[
        laylatAlQadrResearchContent.whatIsIt.tr,
        laylatAlQadrResearchContent.whatIsIt.en,
        laylatAlQadrResearchContent.whatIsIt.ar,
        laylatAlQadrResearchContent.history.tr,
        laylatAlQadrResearchContent.history.en,
        laylatAlQadrResearchContent.history.ar,
        for (final section in laylatAlQadrResearchContent.evidence) ...[
          section.text.tr,
          section.text.en,
          section.text.ar,
        ],
      ].join(' ').toLowerCase();

      for (final forbidden in <String>[
        'kesin kabul olur',
        'kesin şifa',
        'kesin para',
        'guaranteed healing',
        'guaranteed wealth',
        'guaranteed acceptance',
      ]) {
        expect(texts.contains(forbidden), isFalse, reason: forbidden);
      }
    });
  });
}
