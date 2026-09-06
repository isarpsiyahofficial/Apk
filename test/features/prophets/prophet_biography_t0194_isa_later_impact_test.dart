import 'package:flutter_test/flutter_test.dart';
import 'package:islami_hayat/features/prophets/data/canonical_prophet_biographies.dart';
import 'package:islami_hayat/features/prophets/data/prophet_biography_t0194_dataset.dart';

void main() {
  final isa = canonicalProphetBiographyT0194Dataset.firstWhere(
    (draft) => draft.identity.canonicalId == 'isa',
  );

  test('T0194 Isa later impact stays inside Quran 61:14 evidence', () {
    final field = isa.sections[ProphetBiographySectionKey.laterImpact]!;

    expect(field.status, ProphetBiographyFieldStatus.sourceBacked);
    expect(field.sources, hasLength(1));
    expect(
      field.sources.single.id,
      'tanzil-uthmani-v1.1-isa-q61-14-later-impact',
    );
    expect(
      field.sources.single.title,
      'Tanzil Project — Uthmani Quran Text v1.1',
    );
    expect(field.sources.single.locator, 'Quran 61:14');
    expect(field.sources.single.licenseId, 'CC-BY-3.0');

    expect(field.text.tr, contains('bir grubun iman ettiğini'));
    expect(field.text.en, contains('a faction of the Children of Israel believed'));
    expect(field.text.ar, contains('طائفة من بني إسرائيل آمنت'));
    expect(field.text.tr, contains('iman edenleri düşmanlarına karşı desteklediğini'));
    expect(field.text.en, contains('supported those who believed against their enemy'));
    expect(field.text.ar, contains('أيّد الذين آمنوا على عدوهم'));

    expect(field.text.tr, contains('kilise'));
    expect(field.text.en, contains('church'));
    expect(field.text.ar, contains('كنيسة'));
    expect(field.text.tr, contains('eşitlemez'));
    expect(field.text.en, contains('does not identify'));
    expect(field.text.ar, contains('ولا يربط'));

    expect(field.text.tr, isNot(contains('Roma İmparatorluğu')));
    expect(field.text.en, isNot(contains('Roman Empire')));
    expect(field.text.ar, isNot(contains('الإمبراطورية الرومانية')));
    expect(field.text.tr, isNot(contains('bütün İsrailoğulları')));
    expect(field.text.en, isNot(contains('all Children of Israel')));
    expect(field.text.ar, isNot(contains('كل بني إسرائيل')));

    expect(prophetBiographyT0194DraftHasTraceableProvenance(isa), isTrue);
  });

  test('T0194 Isa Quran 61:14 reference is indexed exactly once', () {
    final matches = isa.quranReferences
        .where((item) => item.surah == 61 && item.ayah == 14)
        .toList(growable: false);

    expect(matches, hasLength(1));
  });

  test('T0194 Isa unsupported geography and period remain fail-closed', () {
    for (final key in <ProphetBiographySectionKey>[
      ProphetBiographySectionKey.geography,
      ProphetBiographySectionKey.period,
    ]) {
      final field = isa.sections[key]!;
      expect(field.status, ProphetBiographyFieldStatus.unknownPendingResearch);
      expect(field.sources, isEmpty);
    }
  });
}
