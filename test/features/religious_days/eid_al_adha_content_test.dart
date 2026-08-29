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

      expect(content.sectionsOf(ReligiousDayEvidenceKind.quranBasis), isNotEmpty);
      expect(content.sectionsOf(ReligiousDayEvidenceKind.hadithBasis), isNotEmpty);
      expect(content.sectionsOf(ReligiousDayEvidenceKind.strongReport), isNotEmpty);
      expect(content.sectionsOf(ReligiousDayEvidenceKind.tradition), isNotEmpty);
      expect(content.sectionsOf(ReligiousDayEvidenceKind.specificWorship), isNotEmpty);
      expect(content.sectionsOf(ReligiousDayEvidenceKind.generalWorship), isNotEmpty);
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
      expect(section.text.tr.contains('takva'), isTrue);
      expect(section.text.en.contains('piety'), isTrue);
      expect(section.text.ar.contains('التقوى'), isTrue);
    });

    test('sacrifice timing is grounded in Sahih al-Bukhari 5560', () {
      final section = eidAlAdhaResearchContent
          .sectionsOf(ReligiousDayEvidenceKind.hadithBasis)
          .single;

      expect(section.certainty, CertaintyLevel.stronglyAttested);
      expect(section.sources, hasLength(1));
      expect(section.sources.single.id, 'bukhari-5560-sacrifice-after-eid-prayer');
      expect(
        section.sources.single.sourceClass,
        ReligiousSourceClass.sahihHasanHadith,
      );
      expect(section.text.tr.contains('önce namaz'), isTrue);
      expect(section.text.en.contains('prayer came first'), isTrue);
      expect(section.text.ar.contains('صلاة العيد كانت أولاً'), isTrue);
    });

    test('two-rams report is not converted into a mandatory numeric target', () {
      final section = eidAlAdhaResearchContent
          .sectionsOf(ReligiousDayEvidenceKind.strongReport)
          .single;
      final text = '${section.text.tr} ${section.text.en} ${section.text.ar}'.toLowerCase();

      expect(section.sources.single.id, 'bukhari-5558-prophetic-sacrifice');
      expect(section.certainty, CertaintyLevel.stronglyAttested);
      expect(text.contains('zorunlu hedefe dönüştürülmez'), isTrue);
      expect(text.contains('not converted into a mandatory target'), isTrue);
      expect(text.contains('لا يحوّل التطبيق عدد الأضاحي'), isTrue);
    });

    test('school-specific obligation is not turned into an app fatwa', () {
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
      expect(text.contains('fetva üretmez'), isTrue);
      expect(text.contains('does not independently issue'), isTrue);
      expect(text.contains('فلا يصدر التطبيق من تلقاء نفسه'), isTrue);
      expect(text.contains('kurban farzdır'), isFalse);
      expect(text.contains('sacrifice is obligatory'), isFalse);
      expect(text.contains('الأضحية واجبة على الجميع'), isFalse);
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

    test('guide forbids guaranteed outcomes while preserving explicit safety copy', () {
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

      expect(texts.contains('kaynaksız özel sayı'), isTrue);
      expect(texts.contains('unsupported special counts'), isTrue);
      expect(texts.contains('أعداداً خاصة بلا دليل'), isTrue);
    });
  });
}
