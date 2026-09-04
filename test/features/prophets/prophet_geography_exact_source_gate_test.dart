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

  const modernHistorySource = SourceReference(
    id: 'modern-location-source',
    title: 'Modern historical or archaeological location source',
    sourceClass: ReligiousSourceClass.modernHistoryArchaeology,
    licenseId: 'reference-only',
    locator: 'location evidence',
  );

  test('classical tradition cannot be promoted to an exact prophet pin', () {
    final geography = ProphetGeography(
      name: label('Traditional exact pin'),
      precision: ProphetLocationPrecision.exact,
      certainty: CertaintyLevel.explicitSource,
      sources: const [classicalTraditionSource],
      latitude: 31.0,
      longitude: 35.0,
    );

    expect(geography.isValid, isFalse);
  });

  test('later tradition cannot be promoted to an exact prophet pin', () {
    final geography = ProphetGeography(
      name: label('Later-tradition exact pin'),
      precision: ProphetLocationPrecision.exact,
      certainty: CertaintyLevel.explicitSource,
      sources: const [laterTraditionSource],
      latitude: 31.0,
      longitude: 35.0,
    );

    expect(geography.isValid, isFalse);
  });

  test('exact geography still permits an explicit non-traditional source', () {
    final geography = ProphetGeography(
      name: label('Explicitly sourced exact pin'),
      precision: ProphetLocationPrecision.exact,
      certainty: CertaintyLevel.explicitSource,
      sources: const [modernHistorySource],
      latitude: 31.0,
      longitude: 35.0,
    );

    expect(geography.isValid, isTrue);
  });
}
