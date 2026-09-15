import 'package:flutter_test/flutter_test.dart';
import 'package:islami_hayat/core/content/content_governance.dart';
import 'package:islami_hayat/features/prophets/data/canonical_prophet_biographies.dart';
import 'package:islami_hayat/features/prophets/data/prophet_biography_t0194_dataset.dart';
import 'package:islami_hayat/features/prophets/data/prophet_biography_t0194_supplements_6.dart';

void main() {
  test('sixth T0194 batch is sahih-hadith reference-only and source complete', () {
    expect(t0194ProphetBiographySupplements6.keys.toSet(), {'muhammad'});

    for (final field in t0194ProphetBiographySupplements6['muhammad']!.values) {
      expect(field.isValid, isTrue);
      expect(field.status, ProphetBiographyFieldStatus.sourceBacked);
      expect(field.sources, hasLength(1));
      final source = field.sources.single;
      expect(source.sourceClass, ReligiousSourceClass.sahihHasanHadith);
      expect(source.licenseId, 'REFERENCE-ONLY');
      expect(source.locator, isNotEmpty);
    }
  });

  test('birth report does not manufacture exact calendar chronology', () {
    final birth = t0194ProphetBiographySupplements6['muhammad']![
      ProphetBiographySectionKey.birth
    ]!;
    expect(birth.sources.single.locator, 'Sahih Muslim 1162e');
    expect(birth.text.tr, contains('kesin bir takvim tarihi veya doğum yılı vermez'));
    expect(birth.text.en, contains('does not provide an exact calendar date or birth year'));
    expect(birth.text.ar, contains('من غير تحديد تاريخ تقويمي دقيق أو سنة للميلاد'));
  });

  test('death report records death without inventing Gregorian date', () {
    final death = t0194ProphetBiographySupplements6['muhammad']![
      ProphetBiographySectionKey.death
    ]!;
    expect(death.sources.single.locator, 'Sahih al-Bukhari 4449');
    expect(death.text.tr, contains('kesin bir miladi ölüm tarihi türetmez'));
    expect(death.text.en, contains('does not derive an exact Gregorian death date'));
    expect(death.text.ar, contains('تاريخًا ميلاديًا دقيقًا للوفاة'));
  });

  test('sixth batch does not promote unsupported geography or period', () {
    final muhammad = t0194ProphetBiographySupplements6['muhammad']!;
    expect(muhammad.containsKey(ProphetBiographySectionKey.geography), isFalse);
    expect(muhammad.containsKey(ProphetBiographySectionKey.period), isFalse);
  });

  test('working dataset actually merges sahih-hadith birth and death fields', () {
    final draft = canonicalProphetBiographyT0194Dataset.singleWhere(
      (entry) => entry.identity.canonicalId == 'muhammad',
    );

    final birth = draft.sections[ProphetBiographySectionKey.birth]!;
    final death = draft.sections[ProphetBiographySectionKey.death]!;
    expect(birth.status, ProphetBiographyFieldStatus.sourceBacked);
    expect(death.status, ProphetBiographyFieldStatus.sourceBacked);
    expect(
      birth.sources.single.sourceClass,
      ReligiousSourceClass.sahihHasanHadith,
    );
    expect(
      death.sources.single.sourceClass,
      ReligiousSourceClass.sahihHasanHadith,
    );
    expect(canonicalProphetBiographyT0194DatasetIsStructurallyValid, isTrue);
  });
}
