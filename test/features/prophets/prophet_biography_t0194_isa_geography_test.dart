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

    expect(field.text.tr, contains('Kudüs'));
    expect(field.text.en, contains('Jerusalem'));
    expect(field.text.ar, contains('القدس'));
    expect(field.text.tr, contains('kesin coğrafî tespiti gibi sunmaz'));
    expect(field.text.en, contains('does not present'));
    expect(field.text.ar, contains('لا يقدّم'));

    expect(field.text.tr, isNot(contains('Kudüs’tür')));
    expect(field.text.en, isNot(contains('is Jerusalem')));
    expect(field.text.ar, isNot(contains('هي القدس')));
    expect(field.text.tr, isNot(contains('Şam’dır')));
    expect(field.text.en, isNot(contains('is Damascus')));
    expect(field.text.ar, isNot(contains('هي دمشق')));

    expect(prophetBiographyT0194DraftHasTraceableProvenance(isa), isTrue);
  });

  test('T0194 Isa Quran 23:50 reference is indexed exactly once', () {
    final matches = isa.quranReferences
        .where((item) => item.surah == 23 && item.ayah == 50)
        .toList(growable: false);

    expect(matches, hasLength(1));
  });

  test('T0194 Isa period remains fail-closed after geography review', () {
    final field = isa.sections[ProphetBiographySectionKey.period]!;
    expect(field.status, ProphetBiographyFieldStatus.unknownPendingResearch);
    expect(field.sources, isEmpty);
  });
}
