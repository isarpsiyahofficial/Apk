import 'package:flutter_test/flutter_test.dart';
import 'package:islami_hayat/core/content/content_governance.dart';
import 'package:islami_hayat/features/religious_days/data/eid_al_adha_content.dart';
import 'package:islami_hayat/features/religious_days/data/religious_day_content.dart';

void main() {
  group('T0174 Eid al-Adha research guide', () {
    test('is comprehensive but fail-closed before religious/native review', () {
      final content = eidAlAdhaResearchContent;

      expect(content.title.isComplete, isTrue);
      expect(content.whatIsIt.isComplete, isTrue);
      expect(content.history.isComplete, isTrue);
      expect(content.record.reviewStatus, ContentReviewStatus.research);
      expect(content.canEnterProductionDataset, isFalse);

      for (final kind in ReligiousDayEvidenceKind.values) {
        if (kind == ReligiousDayEvidenceKind.disputedReport) continue;
        expect(content.sectionsOf(kind), isNotEmpty, reason: kind.name);
      }
    });

    test('all SPEC 306 evidence areas were deliberately reviewed', () {
      final content = eidAlAdhaResearchContent;

      expect(
        content.reviewedEvidenceKinds,
        ReligiousDayContent.requiredReviewedEvidenceKinds,
      );
      expect(content.hasCompleteRequiredReviewCoverage, isTrue);
      expect(
        content.hasReviewedEvidenceKind(
          ReligiousDayEvidenceKind.disputedReport,
        ),
        isTrue,
      );
      expect(
        content.sectionsOf(ReligiousDayEvidenceKind.disputedReport),
        isEmpty,
        reason: 'Reviewed but no separate reliable disputed-report claim found.',
      );
    });

    test('Quran basis is pinned to 22:36-37 and remains Quran-only', () {
      final section = eidAlAdhaResearchContent
          .sectionsOf(ReligiousDayEvidenceKind.quranBasis)
          .single;

      expect(section.certainty, CertaintyLevel.explicitSource);
      expect(
        section.sources.map((source) => source.locator).toSet(),
        {'22:36', '22:37'},
      );
      expect(
        section.sources.every(
          (source) => source.sourceClass == ReligiousSourceClass.quran,
        ),
        isTrue,
      );
    });

    test('sacrifice timing is grounded in Sahih al-Bukhari 5560', () {
      final section = eidAlAdhaResearchContent
          .sectionsOf(ReligiousDayEvidenceKind.hadithBasis)
          .single;

      expect(section.certainty, CertaintyLevel.stronglyAttested);
      expect(section.sources, hasLength(1));
      expect(section.sources.single.id, 'bukhari-5560-sacrifice-after-eid-prayer');
      expect(section.sources.single.locator, 'Book 73, Hadith 16');
      expect(
        section.sources.single.sourceClass,
        ReligiousSourceClass.sahihHasanHadith,
      );
    });

    test('two-rams report remains a report rather than a numeric target model', () {
      final section = eidAlAdhaResearchContent
          .sectionsOf(ReligiousDayEvidenceKind.strongReport)
          .single;

      expect(section.sources.single.id, 'bukhari-5558-prophetic-sacrifice');
      expect(section.sources.single.locator, 'Book 73, Hadith 14');
      expect(section.certainty, CertaintyLevel.stronglyAttested);
      expect(
        section.sources.single.sourceClass,
        ReligiousSourceClass.sahihHasanHadith,
      );
    });

    test('specific worship uses only Quran/strong hadith and avoids personal fatwa', () {
      final section = eidAlAdhaResearchContent
          .sectionsOf(ReligiousDayEvidenceKind.specificWorship)
          .single;
      final text = '${section.text.tr} ${section.text.en} ${section.text.ar}'.toLowerCase();

      expect(
        eidAlAdhaResearchContent.specificWorshipStatus,
        SpecificWorshipStatus.establishedByStrongSource,
      );
      expect(section.certainty, CertaintyLevel.stronglyAttested);
      expect(
        section.sources.every((source) =>
            source.sourceClass == ReligiousSourceClass.quran ||
            source.sourceClass == ReligiousSourceClass.sahihHasanHadith),
        isTrue,
      );
      for (final forbidden in <String>[
        'kurban farzdır',
        'sacrifice is obligatory for everyone',
        'الأضحية واجبة على الجميع',
      ]) {
        expect(text.contains(forbidden), isFalse, reason: forbidden);
      }
    });

    test('local celebration customs remain tradition-only', () {
      final section = eidAlAdhaResearchContent
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
      final nonQuranSources = eidAlAdhaResearchContent.record.sources
          .where((source) => source.sourceClass != ReligiousSourceClass.quran);

      expect(nonQuranSources, isNotEmpty);
      expect(
        nonQuranSources.every(
          (source) => source.licenseId.startsWith('reference-only-'),
        ),
        isTrue,
      );
      expect(
        eidAlAdhaResearchContent.record.sources.every(
          (source) => (source.locator ?? '').trim().isNotEmpty,
        ),
        isTrue,
      );
    });

    test('guide forbids affirmative guaranteed-outcome claims', () {
      final texts = <String>[
        eidAlAdhaResearchContent.whatIsIt.tr,
        eidAlAdhaResearchContent.whatIsIt.en,
        eidAlAdhaResearchContent.whatIsIt.ar,
        eidAlAdhaResearchContent.history.tr,
        eidAlAdhaResearchContent.history.en,
        eidAlAdhaResearchContent.history.ar,
        for (final section in eidAlAdhaResearchContent.evidence) ...[
          section.text.tr,
          section.text.en,
          section.text.ar,
        ],
      ].join(' ').toLowerCase();

      for (final forbidden in <String>[
        'kesin şifa verir',
        'kesin para getirir',
        'kesin kabul edilir',
        'guarantees healing',
        'guarantees wealth',
        'guarantees acceptance',
        'يضمن الشفاء',
        'يضمن المال',
        'يضمن القبول',
      ]) {
        expect(texts.contains(forbidden), isFalse, reason: forbidden);
      }
    });
  });
}
