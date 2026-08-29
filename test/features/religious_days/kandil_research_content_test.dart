import 'package:flutter_test/flutter_test.dart';
import 'package:islami_hayat/core/content/content_governance.dart';
import 'package:islami_hayat/features/religious_days/data/berat_content.dart';
import 'package:islami_hayat/features/religious_days/data/mawlid_content.dart';
import 'package:islami_hayat/features/religious_days/data/miraj_content.dart';
import 'package:islami_hayat/features/religious_days/data/regaib_content.dart';
import 'package:islami_hayat/features/religious_days/data/religious_day_content.dart';

void main() {
  group('T0177 kandil research records', () {
    final records = <ReligiousDayContent>[
      mirajResearchContent,
      beratResearchContent,
      regaibResearchContent,
      mawlidResearchContent,
    ];

    test('all four records are TR/EN/AR complete but fail closed before review', () {
      expect(records, hasLength(4));
      for (final content in records) {
        expect(content.title.isComplete, isTrue, reason: content.record.id);
        expect(content.whatIsIt.isComplete, isTrue, reason: content.record.id);
        expect(content.history.isComplete, isTrue, reason: content.record.id);
        expect(content.record.reviewStatus, ContentReviewStatus.research);
        expect(content.record.type, ContentType.religiousDay);
        expect(content.canEnterProductionDataset, isFalse);
        expect(
          content.record.sources.every(
            (source) => source.id.trim().isNotEmpty &&
                source.title.trim().isNotEmpty &&
                source.licenseId.trim().isNotEmpty &&
                (source.locator ?? '').trim().isNotEmpty,
          ),
          isTrue,
          reason: content.record.id,
        );
      }
    });

    test('Miraj keeps Quran 17:1, sound hadith and 27 Rajab tradition separate', () {
      final quran = mirajResearchContent
          .sectionsOf(ReligiousDayEvidenceKind.quranBasis)
          .single;
      final hadith = mirajResearchContent
          .sectionsOf(ReligiousDayEvidenceKind.hadithBasis)
          .single;
      final tradition = mirajResearchContent
          .sectionsOf(ReligiousDayEvidenceKind.tradition)
          .single;

      expect(quran.sources.single.locator, '17:1');
      expect(quran.sources.single.sourceClass, ReligiousSourceClass.quran);
      expect(hadith.sources.single.id, 'muslim-162a-isra-miraj');
      expect(
        hadith.sources.single.sourceClass,
        ReligiousSourceClass.sahihHasanHadith,
      );
      expect(tradition.certainty, CertaintyLevel.traditional);
      expect(tradition.text.tr, contains('27 Receb'));
      expect(mirajResearchContent.history.tr, contains('kesin tarihsel gün'));
      expect(
        mirajResearchContent.specificWorshipStatus,
        SpecificWorshipStatus.noSpecificPracticeEstablished,
      );
      expect(
        mirajResearchContent.sectionsOf(ReligiousDayEvidenceKind.specificWorship),
        isEmpty,
      );
    });

    test('Berat keeps weak reports disputed and invents no special prayer', () {
      final disputed = beratResearchContent
          .sectionsOf(ReligiousDayEvidenceKind.disputedReport)
          .single;

      expect(disputed.certainty, CertaintyLevel.disputed);
      expect(
        disputed.sources.every(
          (source) => source.sourceClass == ReligiousSourceClass.disputed,
        ),
        isTrue,
      );
      expect(disputed.text.tr, contains('zayıf'));
      expect(disputed.text.en.toLowerCase(), contains('weak'));
      expect(disputed.text.ar, contains('تضعيف'));
      expect(
        beratResearchContent.specificWorshipStatus,
        SpecificWorshipStatus.noSpecificPracticeEstablished,
      );
      expect(
        beratResearchContent.sectionsOf(ReligiousDayEvidenceKind.specificWorship),
        isEmpty,
      );
    });

    test('Regaib distinguishes sacred Rajab from fabricated special ritual reports', () {
      final hadith = regaibResearchContent
          .sectionsOf(ReligiousDayEvidenceKind.hadithBasis)
          .single;
      final disputed = regaibResearchContent
          .sectionsOf(ReligiousDayEvidenceKind.disputedReport)
          .single;

      expect(hadith.sources.single.id, 'bukhari-4662-rajab-sacred-month');
      expect(hadith.sources.single.locator, 'Book 65, Hadith 184');
      expect(disputed.certainty, CertaintyLevel.disputed);
      expect(disputed.text.tr.toLowerCase(), contains('uydurma'));
      expect(disputed.text.en.toLowerCase(), contains('fabricated'));
      expect(disputed.text.ar, contains('موضوعة'));
      expect(
        regaibResearchContent.specificWorshipStatus,
        SpecificWorshipStatus.noSpecificPracticeEstablished,
      );
    });

    test('Mawlid pins Monday birth while keeping lunar date historically non-exact', () {
      final hadith = mawlidResearchContent
          .sectionsOf(ReligiousDayEvidenceKind.hadithBasis)
          .single;
      final tradition = mawlidResearchContent
          .sectionsOf(ReligiousDayEvidenceKind.tradition)
          .single;

      expect(hadith.sources.single.id, 'muslim-1162e-monday-birth');
      expect(hadith.sources.single.locator, 'Book 13, Hadith 256');
      expect(hadith.text.tr.toLowerCase(), contains('pazartesi'));
      expect(mawlidResearchContent.whatIsIt.tr, contains('tartışmasız'));
      expect(mawlidResearchContent.history.tr, contains('2, 8, 10, 12 veya 17'));
      expect(tradition.certainty, CertaintyLevel.traditional);
      expect(
        mawlidResearchContent.specificWorshipStatus,
        SpecificWorshipStatus.noSpecificPracticeEstablished,
      );
    });

    test('third-party material stays reference-only and no guaranteed claims leak in', () {
      for (final content in records) {
        final thirdParty = content.record.sources.where(
          (source) => source.sourceClass != ReligiousSourceClass.quran,
        );
        expect(thirdParty, isNotEmpty);
        expect(
          thirdParty.every(
            (source) => source.licenseId.startsWith('reference-only-'),
          ),
          isTrue,
          reason: content.record.id,
        );
      }

      final text = records
          .expand((content) => <String>[
                content.whatIsIt.tr,
                content.whatIsIt.en,
                content.whatIsIt.ar,
                content.history.tr,
                content.history.en,
                content.history.ar,
                for (final section in content.evidence) ...[
                  section.text.tr,
                  section.text.en,
                  section.text.ar,
                ],
              ])
          .join(' ')
          .toLowerCase();

      for (final forbidden in <String>[
        '100 rekat kesin kabul',
        'regaib namazı sahih sünnettir',
        '27 receb kesin miraç tarihidir',
        '12 rebiülevvel kesin doğum tarihidir',
        'guaranteed acceptance',
        'regaib prayer is established sunnah',
        '27 rajab is certainly the historical date',
        '12 rabi al-awwal is certainly the birth date',
        'يضمن القبول',
        'صلاة الرغائب سنة صحيحة ثابتة',
        '27 رجب هو التاريخ القطعي للمعراج',
      ]) {
        expect(text.contains(forbidden), isFalse, reason: forbidden);
      }
    });
  });
}
