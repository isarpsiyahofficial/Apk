import 'package:flutter_test/flutter_test.dart';
import 'package:islami_hayat/core/content/content_governance.dart';
import 'package:islami_hayat/features/religious_days/data/muharram_ashura_content.dart';
import 'package:islami_hayat/features/religious_days/data/religious_day_content.dart';

void main() {
  group('T0176 Muharram and Ashura research guide', () {
    test('is comprehensive but fail-closed before religious/native review', () {
      final content = muharramAshuraResearchContent;

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
        muharramAshuraResearchContent.hasReviewedEvidenceKind(
          ReligiousDayEvidenceKind.disputedReport,
        ),
        isTrue,
      );
      expect(
        muharramAshuraResearchContent.sectionsOf(
          ReligiousDayEvidenceKind.disputedReport,
        ),
        isEmpty,
      );
    });

    test('Quran basis stays general and does not claim 9:36 names Ashura', () {
      final section = muharramAshuraResearchContent
          .sectionsOf(ReligiousDayEvidenceKind.quranBasis)
          .single;

      expect(section.sources, hasLength(1));
      expect(section.sources.single.locator, '9:36');
      expect(section.sources.single.sourceClass, ReligiousSourceClass.quran);
      expect(section.text.tr.toLowerCase(), contains('adını tek başına söylemez'));
      expect(section.text.en.toLowerCase(), contains('does not itself name'));
      expect(section.text.ar, contains('لا تسمي الآية'));
    });

    test('Muharram general virtue is tied to Sahih Muslim 1163b', () {
      final section = muharramAshuraResearchContent
          .sectionsOf(ReligiousDayEvidenceKind.hadithBasis)
          .single;

      expect(section.certainty, CertaintyLevel.stronglyAttested);
      expect(section.sources.single.id, 'muslim-1163b-muharram-fast');
      expect(section.sources.single.locator, 'Book 13, Hadith 262');
      expect(
        section.sources.single.sourceClass,
        ReligiousSourceClass.sahihHasanHadith,
      );
    });

    test('Ashura expiation and ninth-day reports remain separately sourced', () {
      final reports = muharramAshuraResearchContent
          .sectionsOf(ReligiousDayEvidenceKind.strongReport)
          .toList();

      expect(reports, hasLength(2));
      expect(
        reports.expand((section) => section.sources).map((source) => source.id).toSet(),
        {
          'muslim-1162b-ashura-fast',
          'muslim-1134b-ninth-ashura',
        },
      );
    });

    test('specific worship is hadith-backed and never upgraded to obligatory', () {
      final section = muharramAshuraResearchContent
          .sectionsOf(ReligiousDayEvidenceKind.specificWorship)
          .single;

      expect(
        muharramAshuraResearchContent.specificWorshipStatus,
        SpecificWorshipStatus.establishedByStrongSource,
      );
      expect(
        section.sources.every(
          (source) => source.sourceClass == ReligiousSourceClass.sahihHasanHadith,
        ),
        isTrue,
      );
      expect(section.text.tr.toLowerCase(), contains('farz gibi sunmaz'));
      expect(section.text.en.toLowerCase(), contains('does not label the fast as obligatory'));
      expect(section.text.ar, contains('ولا يصف الصيام بأنه فرض'));
    });

    test('Karbala history is preserved without turning mourning custom into hadith', () {
      final history = muharramAshuraResearchContent.history;
      final tradition = muharramAshuraResearchContent
          .sectionsOf(ReligiousDayEvidenceKind.tradition)
          .single;

      expect(history.tr, contains('10 Muharrem 61'));
      expect(history.en, contains('10 Muharram 61 AH'));
      expect(history.ar, contains('10 محرّم سنة 61هـ'));
      expect(tradition.certainty, CertaintyLevel.traditional);
      expect(
        tradition.sources.every(
          (source) => source.sourceClass == ReligiousSourceClass.laterTradition,
        ),
        isTrue,
      );
      expect(
        muharramAshuraResearchContent.record.sources
            .singleWhere((source) => source.id == 'tdv-islam-ansiklopedisi-kerbela')
            .sourceClass,
        ReligiousSourceClass.earlyIslamicHistoryTafsir,
      );
    });

    test('third-party metadata is reference-only and locator-complete', () {
      final nonQuranSources = muharramAshuraResearchContent.record.sources
          .where((source) => source.sourceClass != ReligiousSourceClass.quran);

      expect(nonQuranSources, isNotEmpty);
      expect(
        nonQuranSources.every(
          (source) => source.licenseId.startsWith('reference-only-'),
        ),
        isTrue,
      );
      expect(
        muharramAshuraResearchContent.record.sources.every(
          (source) => (source.locator ?? '').trim().isNotEmpty,
        ),
        isTrue,
      );
    });

    test('rejects popular unsupported Ashura-specific guarantee claims', () {
      final texts = <String>[
        muharramAshuraResearchContent.whatIsIt.tr,
        muharramAshuraResearchContent.whatIsIt.en,
        muharramAshuraResearchContent.whatIsIt.ar,
        muharramAshuraResearchContent.history.tr,
        muharramAshuraResearchContent.history.en,
        muharramAshuraResearchContent.history.ar,
        for (final section in muharramAshuraResearchContent.evidence) ...[
          section.text.tr,
          section.text.en,
          section.text.ar,
        ],
      ].join(' ').toLowerCase();

      for (final forbidden in <String>[
        'aşure günü gusleden o yıl hasta olmaz',
        'aşure günü sürme çeken helâk olmaz',
        '100 kez oku kesin kabul olur',
        'ashura guarantees healing',
        'recite 100 times for guaranteed acceptance',
        'عاشوراء يضمن الشفاء',
        'اقرأه 100 مرة ليضمن القبول',
      ]) {
        expect(texts.contains(forbidden), isFalse, reason: forbidden);
      }
    });
  });
}
