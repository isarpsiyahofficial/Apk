import 'package:flutter_test/flutter_test.dart';
import 'package:islami_hayat/core/content/content_governance.dart';
import 'package:islami_hayat/features/religious_days/data/eid_al_fitr_content.dart';
import 'package:islami_hayat/features/religious_days/data/religious_day_content.dart';

void main() {
  group('T0173 Eid al-Fitr research guide', () {
    test('is comprehensive but fail-closed before religious/native review', () {
      final content = eidAlFitrResearchContent;

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

    test('Quran basis does not falsely claim that 2:185 names Eid al-Fitr', () {
      final section = eidAlFitrResearchContent
          .sectionsOf(ReligiousDayEvidenceKind.quranBasis)
          .single;

      expect(section.sources.single.locator, '2:185');
      expect(section.sources.single.sourceClass, ReligiousSourceClass.quran);
      expect(section.certainty, CertaintyLevel.explicitSource);
      expect(section.text.tr.contains('doğrudan vermez'), isTrue);
      expect(section.text.en.contains('does not directly name Eid al-Fitr'), isTrue);
      expect(section.text.ar.contains('لا تسمّي الآية عيد الفطر مباشرة'), isTrue);
    });

    test('Eid prayer remains strong Sunnah and is not converted into a school-specific fatwa', () {
      final section = eidAlFitrResearchContent
          .sectionsOf(ReligiousDayEvidenceKind.specificWorship)
          .single;

      expect(
        eidAlFitrResearchContent.specificWorshipStatus,
        SpecificWorshipStatus.establishedByStrongSource,
      );
      expect(section.certainty, CertaintyLevel.stronglyAttested);
      expect(
        section.sources.every((source) =>
            source.sourceClass == ReligiousSourceClass.sahihHasanHadith),
        isTrue,
      );

      final text = '${section.text.tr} ${section.text.en} ${section.text.ar}'.toLowerCase();
      expect(text.contains('farzdır'), isFalse);
      expect(text.contains('is obligatory'), isFalse);
      expect(text.contains('واجب'), isFalse);
      expect(text.contains('fetva üretmez'), isTrue);
    });

    test('pre-prayer dates and charity reports stay strongly attested', () {
      final reports = eidAlFitrResearchContent
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
      expect(
        reports.expand((section) => section.sources).map((source) => source.id).toSet(),
        {'bukhari-953-eid-fitr-dates', 'bukhari-964-eid-two-rakah-charity'},
      );
    });

    test('local celebration customs remain tradition-only', () {
      final section = eidAlFitrResearchContent
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
      final nonQuranSources = eidAlFitrResearchContent.record.sources
          .where((source) => source.sourceClass != ReligiousSourceClass.quran);

      expect(nonQuranSources, isNotEmpty);
      expect(
        nonQuranSources.every(
          (source) => source.licenseId.startsWith('reference-only-'),
        ),
        isTrue,
      );
      expect(
        eidAlFitrResearchContent.record.sources.every(
          (source) => (source.locator ?? '').trim().isNotEmpty,
        ),
        isTrue,
      );
    });

    test('guide forbids guaranteed outcomes and unsupported special counts', () {
      final texts = <String>[
        eidAlFitrResearchContent.whatIsIt.tr,
        eidAlFitrResearchContent.whatIsIt.en,
        eidAlFitrResearchContent.whatIsIt.ar,
        eidAlFitrResearchContent.history.tr,
        eidAlFitrResearchContent.history.en,
        eidAlFitrResearchContent.history.ar,
        for (final section in eidAlFitrResearchContent.evidence) ...[
          section.text.tr,
          section.text.en,
          section.text.ar,
        ],
      ].join(' ').toLowerCase();

      // Match affirmative guarantee claims, not safety copy that explicitly says
      // the app does *not* attach a guarantee. This keeps the regression gate from
      // producing the same negated-substring false positive caught in T0172.
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

      expect(texts.contains('kaynaksız özel sayı'), isTrue);
      expect(texts.contains('unsupported special counts'), isTrue);
      expect(texts.contains('أعداداً خاصة بلا دليل'), isTrue);
    });
  });
}
