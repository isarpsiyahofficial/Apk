import 'package:flutter_test/flutter_test.dart';
import 'package:islami_hayat/features/prophets/data/canonical_prophet_biographies.dart';
import 'package:islami_hayat/features/prophets/data/prophet_biography_t0194_dataset.dart';

void main() {
  final isa = canonicalProphetBiographyT0194Dataset.firstWhere(
    (draft) => draft.identity.canonicalId == 'isa',
  );

  test('T0194 Isa geography stays inside Quran 23:50 evidence', () {
    final field = isa.sections[ProphetBiographySectionKey.geography]!;

    expect(field.status, ProphetBiographyFieldStatus.sourceBacked);
    expect(field.sources, hasLength(1));
    expect(
      field.sources.single.id,
      'tanzil-uthmani-v1.1-isa-q23-50-geography',
    );
    expect(
      field.sources.single.title,
      'Tanzil Project — Uthmani Quran Text v1.1',
    );
    expect(field.sources.single.locator, 'Quran 23:50');
    expect(field.sources.single.licenseId, 'CC-BY-3.0');

    expect(field.text.tr, contains('yüksekçe bir yere'));
    expect(field.text.en, contains('elevated ground'));
    expect(field.text.ar, contains('ربوة ذات قرار ومعين'));

    expect(field.text.tr, contains('Ayet bu yerin adını vermez'));
    expect(field.text.en, contains('The verse does not name that place'));
    expect(field.text.ar, contains('ولا تسمّي الآية ذلك الموضع'));

    expect(field.text.tr, contains('şehir, bölge veya ülke adı'));
    expect(field.text.en, contains('no city, region, or country'));
    expect(field.text.ar, contains('اسم مدينة أو إقليم أو بلد'));

    for (final unsupportedName in <String>['Kudüs', 'Şam', 'Filistin']) {
      expect(field.text.tr, isNot(contains(unsupportedName)));
    }
    for (final unsupportedName in <String>['Jerusalem', 'Damascus', 'Palestine']) {
      expect(field.text.en, isNot(contains(unsupportedName)));
    }
    for (final unsupportedName in <String>['القدس', 'دمشق', 'فلسطين']) {
      expect(field.text.ar, isNot(contains(unsupportedName)));
    }

    expect(prophetBiographyT0194DraftHasTraceableProvenance(isa), isTrue);
  });

  test('T0194 Isa Quran 23:50 reference is indexed exactly once', () {
    final matches = isa.quranReferences
        .where((item) => item.surah == 23 && item.ayah == 50)
        .toList(growable: false);

    expect(matches, hasLength(1));
  });
}
