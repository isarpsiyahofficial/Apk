import 'package:flutter_test/flutter_test.dart';
import 'package:islami_hayat/core/content/content_governance.dart';
import 'package:islami_hayat/features/religious_days/data/arafah_content.dart';
import 'package:islami_hayat/features/religious_days/data/religious_day_content.dart';

void main() {
  group('T0175 Day of Arafah research guide', () {
    test('is comprehensive but fail-closed before religious/native review', () {
      final content = arafahResearchContent;

      expect(content.title.isComplete, isTrue);
      expect(content.whatIsIt.isComplete, isTrue);
      expect(content.history.isComplete, isTrue);
      expect(content.record.reviewStatus, ContentReviewStatus.research);
      expect(content.canEnterProductionDataset, isFalse);

      expect(content.hasCompleteRequiredReviewCoverage, isTrue);
      expect(
        content.reviewedEvidenceKinds,
        ReligiousDayContent.requiredReviewedEvidenceKinds,
      );

      for (final kind in ReligiousDayEvidenceKind.values) {
        expect(content.hasReviewedEvidenceKind(kind), isTrue, reason: kind.name);
        if (kind == ReligiousDayEvidenceKind.disputedReport) continue;
        expect(content.sectionsOf(kind), isNotEmpty, reason: kind.name);
      }
    });

    test('disputed-report area was reviewed without inventing a claim', () {
      expect(
        arafahResearchContent.hasReviewedEvidenceKind(
          ReligiousDayEvidenceKind.disputedReport,
        ),
        isTrue,
      );
      expect(
        arafahResearchContent.sectionsOf(
          ReligiousDayEvidenceKind.disputedReport,
        ),
        isEmpty,
      );
    });

    test('Quran basis is pinned to 2:198 and remains Quran-only', () {
      final section = arafahResearchContent
          .sectionsOf(ReligiousDayEvidenceKind.quranBasis)
          .single;

      expect(section.certainty, CertaintyLevel.explicitSource);
      expect(section.sources, hasLength(1));
      expect(section.sources.single.locator, '2:198');
      expect(section.sources.single.sourceClass, ReligiousSourceClass.quran);
    });

    test('non-pilgrim fasting merit stays tied to Sahih Muslim 1162a', () {
      final section = arafahResearchContent
          .sectionsOf(ReligiousDayEvidenceKind.hadithBasis)
          .single;

      expect(section.certainty, CertaintyLevel.stronglyAttested);
      expect(section.sources, hasLength(1));
      expect(section.sources.single.id, 'muslim-1162a-arafah-fast');
      expect(section.sources.single.locator, 'Book 13, Hadith 252');
      expect(
        section.sources.single.sourceClass,
        ReligiousSourceClass.sahihHasanHadith,
      );
    });

    test('pilgrim context is kept distinct using Bukhari 1661', () {
      final strong = arafahResearchContent
          .sectionsOf(ReligiousDayEvidenceKind.strongReport)
          .single;
      final worship = arafahResearchContent
          .sectionsOf(ReligiousDayEvidenceKind.specificWorship)
          .single;

      expect(strong.sources.single.id, 'bukhari-1661-arafat-not-fasting');
      expect(strong.sources.single.locator, 'Book 25, Hadith 142');
      expect(
        worship.sources.map((source) => source.id).toSet(),
        {
          'muslim-1162a-arafah-fast',
          'bukhari-1661-arafat-not-fasting',
        },
      );
      expect(
        arafahResearchContent.specificWorshipStatus,
        SpecificWorshipStatus.establishedByStrongSource,
      );
    });

    test('Turkish eve usage remains tradition-only', () {
      final section = arafahResearchContent
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

    test('third-party source metadata is reference-only and locator-complete', () {
      final nonQuranSources = arafahResearchContent.record.sources
          .where((source) => source.sourceClass != ReligiousSourceClass.quran);

      expect(nonQuranSources, isNotEmpty);
      expect(
        nonQuranSources.every(
          (source) => source.licenseId.startsWith('reference-only-'),
        ),
        isTrue,
      );
      expect(
        arafahResearchContent.record.sources.every(
          (source) => (source.locator ?? '').trim().isNotEmpty,
        ),
        isTrue,
      );
    });

    test('does not invent a special Arafah prayer/count or blanket guarantee', () {
      final texts = <String>[
        arafahResearchContent.whatIsIt.tr,
        arafahResearchContent.whatIsIt.en,
        arafahResearchContent.whatIsIt.ar,
        arafahResearchContent.history.tr,
        arafahResearchContent.history.en,
        arafahResearchContent.history.ar,
        for (final section in arafahResearchContent.evidence) ...[
          section.text.tr,
          section.text.en,
          section.text.ar,
        ],
      ].join(' ').toLowerCase();

      for (final forbidden in <String>[
        'kesin kabul edilir',
        'bütün günahlar kesin silinir',
        '100 kez oku',
        'fasting guarantees acceptance',
        'all sins are guaranteed erased',
        'recite 100 times',
        'يضمن القبول',
        'تغفر جميع الذنوب حتما',
        'اقرأه 100 مرة',
      ]) {
        expect(texts.contains(forbidden), isFalse, reason: forbidden);
      }
    });
  });
}
