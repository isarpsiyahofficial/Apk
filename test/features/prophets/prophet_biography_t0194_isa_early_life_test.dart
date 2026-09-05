import 'package:flutter_test/flutter_test.dart';
import 'package:islami_hayat/features/prophets/data/canonical_prophet_biographies.dart';
import 'package:islami_hayat/features/prophets/data/prophet_biography_t0194_dataset.dart';

void main() {
  final isa = canonicalProphetBiographyT0194Dataset.firstWhere(
    (draft) => draft.identity.canonicalId == 'isa',
  );

  test('T0194 Isa birth stays inside Quran 3:45-47 evidence', () {
    final field = isa.sections[ProphetBiographySectionKey.birth]!;

    expect(field.status, ProphetBiographyFieldStatus.sourceBacked);
    expect(field.sources, hasLength(1));
    expect(field.sources.single.id, 'tanzil-uthmani-v1.1-isa-q3-45-47-birth');
    expect(field.sources.single.locator, 'Quran 3:45-47');
    expect(field.sources.single.licenseId, 'CC-BY-3.0');
    expect(field.text.tr, contains('Mesih Îsâ b. Meryem'));
    expect(field.text.en, contains('Jesus son of Mary'));
    expect(field.text.ar, contains('المسيح عيسى ابن مريم'));
    expect(field.text.tr, contains('kesin doğum tarihi'));
    expect(field.text.en, contains('no exact birth date'));
    expect(field.text.ar, contains('تاريخ ميلاد دقيق'));
    expect(prophetBiographyT0194DraftHasTraceableProvenance(isa), isTrue);
  });

  test('T0194 Isa childhood stays inside cradle verses', () {
    final field = isa.sections[ProphetBiographySectionKey.childhoodYouth]!;

    expect(field.status, ProphetBiographyFieldStatus.sourceBacked);
    expect(field.sources, hasLength(1));
    expect(
      field.sources.single.id,
      'tanzil-uthmani-v1.1-isa-q3-46-q19-29-30-childhood',
    );
    expect(field.sources.single.locator, 'Quran 3:46; 19:29-30');
    expect(field.sources.single.licenseId, 'CC-BY-3.0');
    expect(field.text.tr, contains('beşikte'));
    expect(field.text.en, contains('in the cradle'));
    expect(field.text.ar, contains('في المهد'));
    expect(field.text.tr, contains('doğrulanmamış çocukluk anlatıları eklenmez'));
    expect(field.text.en, contains('No unverified childhood narrative'));
    expect(field.text.ar, contains('روايات طفولة غير موثقة'));
    expect(prophetBiographyT0194DraftHasTraceableProvenance(isa), isTrue);
  });

  test('T0194 Isa community is limited to Quran 3:49 naming', () {
    final field = isa.sections[ProphetBiographySectionKey.community]!;

    expect(field.status, ProphetBiographyFieldStatus.sourceBacked);
    expect(field.sources, hasLength(1));
    expect(field.sources.single.id, 'tanzil-uthmani-v1.1-isa-q3-49-community');
    expect(field.sources.single.locator, 'Quran 3:49');
    expect(field.sources.single.licenseId, 'CC-BY-3.0');
    expect(field.text.tr, contains('İsrailoğullarına'));
    expect(field.text.en, contains('Children of Israel'));
    expect(field.text.ar, contains('بني إسرائيل'));
    expect(field.text.tr, contains('şehir, devlet'));
    expect(field.text.en, contains('no city, state'));
    expect(field.text.ar, contains('من غير إضافة مدينة أو دولة'));
  });

  test('T0194 Isa mission stays inside Quran 3:49-51 evidence', () {
    final field = isa.sections[ProphetBiographySectionKey.missionStart]!;

    expect(field.status, ProphetBiographyFieldStatus.sourceBacked);
    expect(field.sources, hasLength(1));
    expect(field.sources.single.id, 'tanzil-uthmani-v1.1-isa-q3-49-51-mission');
    expect(field.sources.single.locator, 'Quran 3:49-51');
    expect(field.sources.single.licenseId, 'CC-BY-3.0');
    expect(field.text.tr, contains('Tevrat’ı doğruladığını'));
    expect(field.text.en, contains('confirming the Torah'));
    expect(field.text.ar, contains('مصدقًا لما بين يديه من التوراة'));
    expect(field.text.tr, contains('kesin bir başlangıç tarihi vermez'));
    expect(field.text.en, contains('no exact calendar date'));
    expect(field.text.ar, contains('تاريخًا تقويميًا دقيقًا'));
  });

  test('T0194 Isa miracles preserve Allah permission boundary', () {
    final field = isa.sections[ProphetBiographySectionKey.miracles]!;

    expect(field.status, ProphetBiographyFieldStatus.sourceBacked);
    expect(field.sources, hasLength(1));
    expect(
      field.sources.single.id,
      'tanzil-uthmani-v1.1-isa-q3-49-q5-110-miracles',
    );
    expect(field.sources.single.locator, 'Quran 3:49; 5:110');
    expect(field.sources.single.licenseId, 'CC-BY-3.0');
    expect(field.text.tr, contains('Allah’ın izniyle'));
    expect(field.text.en, contains('by Allah’s permission'));
    expect(field.text.ar, contains('بإذن الله'));
    expect(field.text.tr, contains('tıbbi ya da doğal bir mekanizma eklemez'));
    expect(field.text.en, contains('adds no medical or natural mechanism'));
    expect(field.text.ar, contains('ولا يضيف تفسيرًا طبيًا أو طبيعيًا'));
    expect(prophetBiographyT0194DraftHasTraceableProvenance(isa), isTrue);
  });

  test('T0194 Isa reference index deduplicates admitted reviewed verses', () {
    for (final reference in <(int, int)>[
      (3, 45),
      (3, 46),
      (3, 47),
      (3, 49),
      (3, 50),
      (3, 51),
      (5, 110),
      (19, 29),
      (19, 30),
    ]) {
      final matches = isa.quranReferences
          .where(
            (item) => item.surah == reference.$1 && item.ayah == reference.$2,
          )
          .toList(growable: false);
      expect(
        matches,
        hasLength(1),
        reason: 'Quran ${reference.$1}:${reference.$2} must be deduplicated',
      );
    }
  });

  test('T0194 Isa unsupported geography and chronology stay pending', () {
    for (final key in <ProphetBiographySectionKey>[
      ProphetBiographySectionKey.geography,
      ProphetBiographySectionKey.period,
    ]) {
      expect(
        isa.sections[key]!.status,
        ProphetBiographyFieldStatus.unknownPendingResearch,
        reason: '$key must not be inferred from the reviewed Quran verses',
      );
    }
  });
}
