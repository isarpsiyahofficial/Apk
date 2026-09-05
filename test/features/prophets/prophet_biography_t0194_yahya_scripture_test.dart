import 'package:flutter_test/flutter_test.dart';
import 'package:islami_hayat/features/prophets/data/canonical_prophet_biographies.dart';
import 'package:islami_hayat/features/prophets/data/prophet_biography_t0194_dataset.dart';

void main() {
  final yahya = canonicalProphetBiographyT0194Dataset.firstWhere(
    (draft) => draft.identity.canonicalId == 'yahya',
  );

  test('T0194 Yahya birth field stays inside Quran 19:7 evidence', () {
    final field = yahya.sections[ProphetBiographySectionKey.birth]!;

    expect(field.status, ProphetBiographyFieldStatus.sourceBacked);
    expect(field.sources, hasLength(1));
    expect(field.sources.single.id, 'tanzil-uthmani-v1.1-yahya-q19-7-birth');
    expect(field.sources.single.locator, 'Quran 19:7');
    expect(field.sources.single.licenseId, 'CC-BY-3.0');
    expect(field.text.tr, contains('Yahyâ adında bir oğul'));
    expect(field.text.en, contains('a boy named John'));
    expect(field.text.ar, contains('غلام اسمه يحيى'));
    expect(field.text.tr, contains('doğum tarihi'));
    expect(field.text.en, contains('no date, place'));
    expect(field.text.ar, contains('تاريخ الميلاد'));
    expect(prophetBiographyT0194DraftHasTraceableProvenance(yahya), isTrue);
  });

  test('T0194 Yahya childhood field stays inside Quran 19:12 evidence', () {
    final field = yahya.sections[ProphetBiographySectionKey.childhoodYouth]!;

    expect(field.status, ProphetBiographyFieldStatus.sourceBacked);
    expect(field.sources, hasLength(1));
    expect(field.sources.single.id, 'tanzil-uthmani-v1.1-yahya-q19-12-childhood');
    expect(field.sources.single.locator, 'Quran 19:12');
    expect(field.sources.single.licenseId, 'CC-BY-3.0');
    expect(field.text.tr, contains('çocuk yaşta'));
    expect(field.text.en, contains('while still a child'));
    expect(field.text.ar, contains('وهو صبي'));
    expect(field.text.tr, contains('ayetin ötesine geç'));
    expect(field.text.en, contains('does not go beyond the verse'));
    expect(prophetBiographyT0194DraftHasTraceableProvenance(yahya), isTrue);
  });

  test('T0194 Yahya scripture field is source-backed without overclaiming', () {
    final field = yahya.sections[ProphetBiographySectionKey.scriptureScrolls]!;

    expect(field.status, ProphetBiographyFieldStatus.sourceBacked);
    expect(field.sources, hasLength(1));
    expect(field.sources.single.id, 'tanzil-uthmani-v1.1-yahya-q19-12-scripture');
    expect(field.sources.single.locator, 'Quran 19:12');
    expect(field.sources.single.licenseId, 'CC-BY-3.0');
    expect(field.text.tr, contains('“Kitab”'));
    expect(field.text.en, contains('“the Book”'));
    expect(field.text.ar, contains('«الكتاب»'));
    expect(prophetBiographyT0194DraftHasTraceableProvenance(yahya), isTrue);
  });

  test('T0194 Yahya death field stays inside Quran 19:15 evidence', () {
    final field = yahya.sections[ProphetBiographySectionKey.death]!;

    expect(field.status, ProphetBiographyFieldStatus.sourceBacked);
    expect(field.sources, hasLength(1));
    expect(field.sources.single.id, 'tanzil-uthmani-v1.1-yahya-q19-15-death');
    expect(field.sources.single.locator, 'Quran 19:15');
    expect(field.sources.single.licenseId, 'CC-BY-3.0');
    expect(field.text.tr, contains('öleceği gün'));
    expect(field.text.en, contains('the day he dies'));
    expect(field.text.ar, contains('يوم يموت'));
    expect(field.text.tr, contains('ölüm tarihi, yeri, sebebi'));
    expect(field.text.en, contains('no date, place, cause, or manner'));
    expect(field.text.ar, contains('تاريخ موته ولا مكانه ولا سببه'));
    expect(prophetBiographyT0194DraftHasTraceableProvenance(yahya), isTrue);
  });

  test('T0194 Yahya reference index contains Quran 19:7, 19:12 and 19:15 once', () {
    for (final ayah in <int>[7, 12, 15]) {
      final matches = yahya.quranReferences
          .where((reference) => reference.surah == 19 && reference.ayah == ayah)
          .toList(growable: false);
      expect(matches, hasLength(1), reason: 'Quran 19:$ayah must be deduplicated');
    }
  });

  test('T0194 Yahya unresolved fields remain pending research', () {
    expect(
      yahya.sections.values.any(
        (field) =>
            field.status == ProphetBiographyFieldStatus.unknownPendingResearch,
      ),
      isTrue,
    );
  });
}
