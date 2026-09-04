import 'package:flutter_test/flutter_test.dart';
import 'package:islami_hayat/core/content/content_governance.dart';
import 'package:islami_hayat/features/prophets/data/prophet_content.dart';

void main() {
  LocalizedReligiousText label(String value) => LocalizedReligiousText(
        tr: '$value TR',
        en: '$value EN',
        ar: '$value AR',
      );

  const classicalTraditionSource = SourceReference(
    id: 'classical-location-tradition',
    title: 'Classical traditional location report',
    sourceClass: ReligiousSourceClass.classicalTraditional,
    licenseId: 'reference-only',
    locator: 'traditional location claim',
  );

  const laterTraditionSource = SourceReference(
    id: 'later-location-tradition',
    title: 'Later traditional location report',
    sourceClass: ReligiousSourceClass.laterTradition,
    licenseId: 'reference-only',
    locator: 'later traditional location claim',
  );

  const quranSource = SourceReference(
    id: 'quran-location-reference',
    title: 'Quran location reference',
    sourceClass: ReligiousSourceClass.quran,
    licenseId: 'reference-only',
    locator: 'Quran 12:21',
  );

  const hadithSource = SourceReference(
    id: 'hadith-location-reference',
    title: 'Hadith location reference',
    sourceClass: ReligiousSourceClass.sahihHasanHadith,
    licenseId: 'reference-only',
    locator: 'hadith location wording',
  );

  const earlyHistorySource = SourceReference(
    id: 'early-history-location-reference',
    title: 'Early history location reference',
    sourceClass: ReligiousSourceClass.earlyIslamicHistoryTafsir,
    licenseId: 'reference-only',
    locator: 'early historical location wording',
  );

  const modernHistorySource = SourceReference(
    id: 'modern-location-source',
    title: 'Modern historical or archaeological location source',
    sourceClass: ReligiousSourceClass.modernHistoryArchaeology,
    licenseId: 'reference-only',
    locator: 'location evidence',
  );

  ProphetGeography exactWith(SourceReference source) => ProphetGeography(
        name: label('Exact pin'),
        precision: ProphetLocationPrecision.exact,
        certainty: CertaintyLevel.explicitSource,
        sources: <SourceReference>[source],
        latitude: 31.0,
        longitude: 35.0,
      );

  test('classical tradition cannot be promoted to an exact prophet pin', () {
    expect(exactWith(classicalTraditionSource).isValid, isFalse);
  });

  test('later tradition cannot be promoted to an exact prophet pin', () {
    expect(exactWith(laterTraditionSource).isValid, isFalse);
  });

  test('scripture wording cannot be converted into an exact modern pin', () {
    expect(exactWith(quranSource).isValid, isFalse);
  });

  test('hadith wording cannot be converted into an exact modern pin', () {
    expect(exactWith(hadithSource).isValid, isFalse);
  });

  test('early history or tafsir cannot be promoted to an exact modern pin', () {
    expect(exactWith(earlyHistorySource).isValid, isFalse);
  });

  test('exact geography requires explicit modern historical evidence', () {
    expect(exactWith(modernHistorySource).isValid, isTrue);
  });
}
