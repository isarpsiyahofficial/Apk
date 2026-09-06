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

  test('T0194 Isa community response preserves Quran 3:52-53 split', () {
    final field = isa.sections[ProphetBiographySectionKey.communityResponse]!;

    expect(field.status, ProphetBiographyFieldStatus.sourceBacked);
    expect(field.sources, hasLength(1));
    expect(
      field.sources.single.id,
      'tanzil-uthmani-v1.1-isa-q3-52-53-community-response',
    );
    expect(
      field.sources.single.title,
      'Tanzil Project — Uthmani Quran Text v1.1',
    );
    expect(field.sources.single.locator, 'Quran 3:52-53');
    expect(field.sources.single.licenseId, 'CC-BY-3.0');
    expect(field.text.tr, contains('havârilerin'));
    expect(field.text.en, contains('the disciples'));
    expect(field.text.ar, contains('الحواريون'));
    expect(field.text.tr, contains('inkârı bütün topluluğa genellemez'));
    expect(field.text.en, contains('does not generalise the disbelief'));
    expect(field.text.ar, contains('ولا يعمم هذا الحقل الكفر على الجماعة كلها'));
    expect(field.text.tr, isNot(contains('bütün topluluk inkâr etti')));
    expect(field.text.en, isNot(contains('entire community disbelieved')));
    expect(field.text.ar, isNot(contains('كفرت الجماعة كلها')));
    expect(prophetBiographyT0194DraftHasTraceableProvenance(isa), isTrue);
  });

  test('T0194 Isa scripture stays inside Quran 5:46 evidence', () {
    final field = isa.sections[ProphetBiographySectionKey.scriptureScrolls]!;

    expect(field.status, ProphetBiographyFieldStatus.sourceBacked);
    expect(field.sources, hasLength(1));
    expect(field.sources.single.id, 'tanzil-uthmani-v1.1-isa-q5-46-scripture');
    expect(
      field.sources.single.title,
      'Tanzil Project — Uthmani Quran Text v1.1',
    );
    expect(field.sources.single.locator, 'Quran 5:46');
    expect(field.sources.single.licenseId, 'CC-BY-3.0');
    expect(field.text.tr, contains('İncil’in verildiğini'));
    expect(field.text.en, contains('was given the Gospel'));
    expect(field.text.ar, contains('آتاه الإنجيل'));
    expect(field.text.tr, contains('hidayet ve nur'));
    expect(field.text.en, contains('guidance and light'));
    expect(field.text.ar, contains('هدى ونور'));
    expect(field.text.tr, isNot(contains('bugünkü İncil birebir aynıdır')));
    expect(
      field.text.en,
      contains('does not claim that any specific surviving manuscript is identical'),
    );
    expect(field.text.ar, isNot(contains('مخطوط معين مطابق حرفيا')));
    expect(prophetBiographyT0194DraftHasTraceableProvenance(isa), isTrue);
  });

  test('T0194 Isa dua stays inside Quran 5:114 evidence', () {
    final field = isa.sections[ProphetBiographySectionKey.dua]!;

    expect(field.status, ProphetBiographyFieldStatus.sourceBacked);
    expect(field.sources, hasLength(1));
    expect(field.sources.single.id, 'tanzil-uthmani-v1.1-isa-q5-114-dua');
    expect(
      field.sources.single.title,
      'Tanzil Project — Uthmani Quran Text v1.1',
    );
    expect(field.sources.single.locator, 'Quran 5:114');
    expect(field.sources.single.licenseId, 'CC-BY-3.0');
    expect(field.text.tr, contains('gökten kendilerine bir sofra'));
    expect(field.text.en, contains('a table to be sent down from heaven'));
    expect(field.text.ar, contains('مائدة من السماء'));
    expect(field.text.tr, contains('maddi kazanç garantisine dönüştürmez'));
    expect(field.text.en, contains('does not turn the verse into a general guarantee'));
    expect(field.text.ar, contains('ولا يحول هذا الحقل الآية إلى ضمان عام'));
    expect(field.text.tr, isNot(contains('kesin rızık getirir')));
    expect(field.text.en, isNot(contains('guaranteed provision')));
    expect(field.text.ar, isNot(contains('يضمن الرزق')));
    expect(prophetBiographyT0194DraftHasTraceableProvenance(isa), isTrue);
  });

  test('T0194 Isa death boundary stays inside Quran 4:157-158', () {
    final field = isa.sections[ProphetBiographySectionKey.death]!;

    expect(field.status, ProphetBiographyFieldStatus.sourceBacked);
    expect(field.sources, hasLength(1));
    expect(
      field.sources.single.id,
      'tanzil-uthmani-v1.1-isa-q4-157-158-death',
    );
    expect(
      field.sources.single.title,
      'Tanzil Project — Uthmani Quran Text v1.1',
    );
    expect(field.sources.single.locator, 'Quran 4:157-158');
    expect(field.sources.single.licenseId, 'CC-BY-3.0');
    expect(field.text.tr, contains('öldürdükleri ve çarmıha gerdikleri iddiasını reddeder'));
    expect(field.text.en, contains('was killed or crucified'));
    expect(field.text.ar, contains('قتل عيسى ابن مريم أو صلبه'));
    expect(field.text.tr, contains('Allah’ın onu kendisine yükselttiğini'));
    expect(field.text.en, contains('Allah raised him to Himself'));
    expect(field.text.ar, contains('أن الله رفعه إليه'));
    expect(field.text.tr, contains('kesin bir vefat tarihi vermez'));
    expect(field.text.en, contains('no exact death date'));
    expect(field.text.ar, contains('تاريخ وفاة دقيقًا'));
    expect(field.text.tr, isNot(contains('yerine çarmıha gerildi')));
    expect(field.text.en, isNot(contains('crucified in his place')));
    expect(field.text.ar, isNot(contains('صلب بدلًا منه')));
    expect(prophetBiographyT0194DraftHasTraceableProvenance(isa), isTrue);
  });

  test('T0194 Isa key event stays inside Quran 5:112-115 evidence', () {
    final field = isa.sections[ProphetBiographySectionKey.keyEvents]!;

    expect(field.status, ProphetBiographyFieldStatus.sourceBacked);
    expect(field.sources, hasLength(1));
    expect(
      field.sources.single.id,
      'tanzil-uthmani-v1.1-isa-q5-112-115-key-events',
    );
    expect(
      field.sources.single.title,
      'Tanzil Project — Uthmani Quran Text v1.1',
    );
    expect(field.sources.single.locator, 'Quran 5:112-115');
    expect(field.sources.single.licenseId, 'CC-BY-3.0');
    expect(field.text.tr, contains('havârilerin'));
    expect(field.text.en, contains('the disciples'));
    expect(field.text.ar, contains('الحواريين'));
    expect(field.text.tr, contains('sofradaki yiyecekleri'));
    expect(field.text.en, contains('does not invent the food on the table'));
    expect(field.text.ar, contains('ولا يختلق هذا الحقل نوع الطعام'));
    expect(field.text.tr, isNot(contains('balık')));
    expect(field.text.en, isNot(contains('fish')));
    expect(field.text.ar, isNot(contains('سمك')));
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
      (3, 52),
      (3, 53),
      (4, 157),
      (4, 158),
      (5, 46),
      (5, 110),
      (5, 112),
      (5, 113),
      (5, 114),
      (5, 115),
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
