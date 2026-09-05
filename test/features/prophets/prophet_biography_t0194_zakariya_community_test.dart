import 'package:flutter_test/flutter_test.dart';
import 'package:islami_hayat/features/prophets/data/canonical_prophet_biographies.dart';
import 'package:islami_hayat/features/prophets/data/prophet_biography_t0194_dataset.dart';

void main() {
  final zakariya = canonicalProphetBiographyT0194Dataset.firstWhere(
    (draft) => draft.identity.canonicalId == 'zakariya',
  );

  test('T0194 Zakariya community stays inside Quran 19:11 evidence', () {
    final field = zakariya.sections[ProphetBiographySectionKey.community]!;

    expect(field.status, ProphetBiographyFieldStatus.sourceBacked);
    expect(field.sources, hasLength(1));
    expect(
      field.sources.single.id,
      'tanzil-uthmani-v1.1-zakariya-q19-11-community',
    );
    expect(field.sources.single.locator, 'Quran 19:11');
    expect(field.sources.single.licenseId, 'CC-BY-3.0');

    expect(field.text.tr, contains('kavminin/toplumunun'));
    expect(field.text.en, contains('to his people'));
    expect(field.text.ar, contains('على قومه'));

    expect(field.text.tr, contains('etnik, kabilevî veya şehir adı vermez'));
    expect(field.text.en, contains('does not additionally assign'));
    expect(field.text.ar, contains('اسمًا عرقيًا أو قبليًا'));
  });

  test('T0194 Zakariya dua stays inside Quran 3:38 evidence', () {
    final field = zakariya.sections[ProphetBiographySectionKey.dua]!;

    expect(field.status, ProphetBiographyFieldStatus.sourceBacked);
    expect(field.sources, hasLength(1));
    expect(
      field.sources.single.id,
      'tanzil-uthmani-v1.1-zakariya-q3-38-dua',
    );
    expect(field.sources.single.locator, 'Quran 3:38');
    expect(field.sources.single.licenseId, 'CC-BY-3.0');

    expect(field.text.tr, contains('temiz ve iyi bir nesil'));
    expect(field.text.en, contains('good offspring'));
    expect(field.text.ar, contains('ذرية طيبة'));
  });

  test('T0194 Zakariya key events include Quran 3:37 care of Mary safely', () {
    final field = zakariya.sections[ProphetBiographySectionKey.keyEvents]!;

    expect(field.status, ProphetBiographyFieldStatus.sourceBacked);
    expect(field.sources, hasLength(1));
    expect(
      field.sources.single.id,
      'tanzil-uthmani-v1.1-zakariya-q3-37-41-key-events',
    );
    expect(field.sources.single.locator, 'Quran 3:37; 3:39-41');
    expect(field.sources.single.licenseId, 'CC-BY-3.0');

    expect(field.text.tr, contains('Meryem’in bakımının Zekeriyyâ’ya verildiğini'));
    expect(field.text.tr, contains('Yahyâ’yı müjdelediğini'));
    expect(field.text.tr, contains('üç gün yalnız işaretle'));
    expect(field.text.tr, contains('kesin bir akrabalık derecesi belirtmez'));

    expect(field.text.en, contains('Mary was placed in Zechariah’s care'));
    expect(field.text.en, contains('good news of Yahya'));
    expect(field.text.en, contains('three days'));
    expect(field.text.en, contains('do not additionally specify an exact degree of kinship'));

    expect(field.text.ar, contains('مريم جُعلت في كفالة زكريا'));
    expect(field.text.ar, contains('فبشرته بيحيى'));
    expect(field.text.ar, contains('ثلاثة أيام إلا رمزًا'));
    expect(field.text.ar, contains('ولا تحدد هذه الآيات درجة قرابة بعينها'));
  });

  test('T0194 Zakariya signs stay inside Quran 19:8-10 evidence', () {
    final field = zakariya.sections[ProphetBiographySectionKey.miracles]!;

    expect(field.status, ProphetBiographyFieldStatus.sourceBacked);
    expect(field.sources, hasLength(1));
    expect(
      field.sources.single.id,
      'tanzil-uthmani-v1.1-zakariya-q19-8-10-sign',
    );
    expect(field.sources.single.locator, 'Quran 19:8-10');
    expect(field.sources.single.licenseId, 'CC-BY-3.0');

    expect(field.text.tr, contains('ileri yaşını'));
    expect(field.text.tr, contains('üç gece'));
    expect(field.text.en, contains('old age'));
    expect(field.text.en, contains('three nights'));
    expect(field.text.ar, contains('مع بلوغه الكبر'));
    expect(field.text.ar, contains('ثلاث ليال'));

    expect(field.text.tr, contains('mekanizma veya tarihsel ayrıntı eklenmez'));
    expect(field.text.en, contains('No mechanism or later historical detail'));
    expect(field.text.ar, contains('ولا يضاف إلى ذلك'));
  });

  test('T0194 Zakariya Quran evidence references remain deduplicated', () {
    for (final expected in <({int surah, int ayah})>[
      (surah: 3, ayah: 37),
      (surah: 3, ayah: 38),
      (surah: 3, ayah: 39),
      (surah: 3, ayah: 40),
      (surah: 3, ayah: 41),
      (surah: 19, ayah: 8),
      (surah: 19, ayah: 9),
      (surah: 19, ayah: 10),
      (surah: 19, ayah: 11),
    ]) {
      final matches = zakariya.quranReferences
          .where(
            (reference) =>
                reference.surah == expected.surah &&
                reference.ayah == expected.ayah,
          )
          .toList(growable: false);
      expect(matches, hasLength(1));
    }
  });

  test('T0194 Zakariya provenance remains traceable', () {
    expect(prophetBiographyT0194DraftHasTraceableProvenance(zakariya), isTrue);
  });

  test('T0194 Zakariya unsupported historical details stay pending research', () {
    for (final key in <ProphetBiographySectionKey>[
      ProphetBiographySectionKey.geography,
      ProphetBiographySectionKey.period,
      ProphetBiographySectionKey.birth,
      ProphetBiographySectionKey.childhoodYouth,
      ProphetBiographySectionKey.death,
      ProphetBiographySectionKey.laterImpact,
    ]) {
      expect(
        zakariya.sections[key]!.status,
        ProphetBiographyFieldStatus.unknownPendingResearch,
        reason: '$key must not be promoted without verified evidence',
      );
    }
  });
}
