import 'package:flutter_test/flutter_test.dart';
import 'package:islami_hayat/core/content/content_governance.dart';
import 'package:islami_hayat/features/prophets/data/prophet_content.dart';
import 'package:islami_hayat/features/prophets/data/prophet_map_markers.dart';

void main() {
  const quranSource = SourceReference(
    id: 'tanzil-uthmani-v1.1-location-test',
    title: 'Tanzil Project — Uthmani Quran Text v1.1',
    sourceClass: ReligiousSourceClass.quran,
    licenseId: 'CC-BY-3.0',
    locator: 'Quran test locator',
  );
  const modernHistorySource = SourceReference(
    id: 'modern-location-source',
    title: 'Modern historical or archaeological location source',
    sourceClass: ReligiousSourceClass.modernHistoryArchaeology,
    licenseId: 'reference-only',
    locator: 'location evidence',
  );

  group('T0199 prophet map marker precision', () {
    test('exact geography stays exact and requires coordinates', () {
      const geography = ProphetGeography(
        name: LocalizedReligiousText(
          tr: 'Doğrulanmış nokta',
          en: 'Verified point',
          ar: 'نقطة موثقة',
        ),
        precision: ProphetLocationPrecision.exact,
        certainty: CertaintyLevel.explicitSource,
        sources: [modernHistorySource],
        latitude: 21.4225,
        longitude: 39.8262,
      );

      final marker = mapMarkerFromGeography(geography);
      expect(marker, isNotNull);
      expect(marker!.kind, ProphetMapMarkerKind.exactPoint);
      expect(marker.certainty, CertaintyLevel.explicitSource);
      expect(marker.latitude, 21.4225);
      expect(marker.longitude, 39.8262);
      expect(marker.isValid, isTrue);
    });

    test('Quran evidence cannot become an exact modern map marker', () {
      const geography = ProphetGeography(
        name: LocalizedReligiousText(
          tr: 'Kaynakta geçen yer',
          en: 'Place mentioned in source',
          ar: 'موضع مذكور في المصدر',
        ),
        precision: ProphetLocationPrecision.exact,
        certainty: CertaintyLevel.explicitSource,
        sources: [quranSource],
        latitude: 21.4225,
        longitude: 39.8262,
      );

      expect(geography.isValid, isFalse);
      expect(mapMarkerFromGeography(geography), isNull);
    });

    test('approximate geography can never be promoted to exact marker', () {
      const geography = ProphetGeography(
        name: LocalizedReligiousText(
          tr: 'Yaklaşık bölge',
          en: 'Approximate region',
          ar: 'منطقة تقريبية',
        ),
        precision: ProphetLocationPrecision.approximateRegion,
        certainty: CertaintyLevel.approximate,
        sources: [quranSource],
        latitude: 30.0,
        longitude: 35.0,
      );

      final marker = mapMarkerFromGeography(geography);
      expect(marker, isNotNull);
      expect(marker!.kind, ProphetMapMarkerKind.approximateRegion);
      expect(marker.certainty, CertaintyLevel.approximate);
      expect(marker.isValid, isTrue);
    });

    test('approximate region does not require invented coordinates', () {
      const geography = ProphetGeography(
        name: LocalizedReligiousText(
          tr: 'Yaklaşık bölge',
          en: 'Approximate region',
          ar: 'منطقة تقريبية',
        ),
        precision: ProphetLocationPrecision.approximateRegion,
        certainty: CertaintyLevel.approximate,
        sources: [quranSource],
      );

      final marker = mapMarkerFromGeography(geography);
      expect(marker, isNotNull);
      expect(marker!.latitude, isNull);
      expect(marker.longitude, isNull);
      expect(marker.kind, ProphetMapMarkerKind.approximateRegion);
    });

    test('unknown and disputed geography never become normal map pins', () {
      const unknown = ProphetGeography(
        name: LocalizedReligiousText(
          tr: 'Bilinmiyor',
          en: 'Unknown',
          ar: 'غير معروف',
        ),
        precision: ProphetLocationPrecision.unknown,
        certainty: CertaintyLevel.unknown,
        sources: [quranSource],
      );
      const disputed = ProphetGeography(
        name: LocalizedReligiousText(
          tr: 'Tartışmalı yer',
          en: 'Disputed place',
          ar: 'موضع مختلف فيه',
        ),
        precision: ProphetLocationPrecision.disputed,
        certainty: CertaintyLevel.disputed,
        sources: [quranSource],
      );

      expect(mapMarkerFromGeography(unknown), isNull);
      expect(mapMarkerFromGeography(disputed), isNull);
    });

    test('exact marker with approximate certainty fails closed', () {
      const marker = ProphetMapMarker(
        label: LocalizedReligiousText(tr: 'Yer', en: 'Place', ar: 'مكان'),
        kind: ProphetMapMarkerKind.exactPoint,
        certainty: CertaintyLevel.approximate,
        sources: [quranSource],
        latitude: 10,
        longitude: 20,
      );

      expect(marker.isValid, isFalse);
    });

    test('exact marker requires modern history or archaeology source', () {
      const marker = ProphetMapMarker(
        label: LocalizedReligiousText(tr: 'Yer', en: 'Place', ar: 'مكان'),
        kind: ProphetMapMarkerKind.exactPoint,
        certainty: CertaintyLevel.explicitSource,
        sources: [quranSource],
        latitude: 10,
        longitude: 20,
      );

      expect(marker.isValid, isFalse);
    });

    test('invalid or half coordinates fail closed', () {
      const half = ProphetMapMarker(
        label: LocalizedReligiousText(tr: 'Yer', en: 'Place', ar: 'مكان'),
        kind: ProphetMapMarkerKind.approximateRegion,
        certainty: CertaintyLevel.approximate,
        sources: [quranSource],
        latitude: 10,
      );
      const invalidLatitude = ProphetMapMarker(
        label: LocalizedReligiousText(tr: 'Yer', en: 'Place', ar: 'مكان'),
        kind: ProphetMapMarkerKind.approximateRegion,
        certainty: CertaintyLevel.approximate,
        sources: [quranSource],
        latitude: 95,
        longitude: 20,
      );

      expect(half.isValid, isFalse);
      expect(invalidLatitude.isValid, isFalse);
    });

    test('precision badge is explicit in TR EN AR', () {
      expect(
        prophetMapMarkerPrecisionLabel(
          ProphetMapMarkerKind.approximateRegion,
          'tr',
        ),
        'Yaklaşık bölge',
      );
      expect(
        prophetMapMarkerPrecisionLabel(
          ProphetMapMarkerKind.approximateRegion,
          'en-US',
        ),
        'Approximate region',
      );
      expect(
        prophetMapMarkerPrecisionLabel(
          ProphetMapMarkerKind.approximateRegion,
          'ar',
        ),
        'منطقة تقريبية',
      );
      expect(
        prophetMapMarkerPrecisionLabel(ProphetMapMarkerKind.exactPoint, 'tr'),
        'Kesin konum',
      );
    });

    test('missing locator cannot create a marker', () {
      const missingLocator = ProphetMapMarker(
        label: LocalizedReligiousText(tr: 'Yer', en: 'Place', ar: 'مكان'),
        kind: ProphetMapMarkerKind.approximateRegion,
        certainty: CertaintyLevel.approximate,
        sources: [
          SourceReference(
            id: 'source',
            title: 'Source',
            sourceClass: ReligiousSourceClass.quran,
            licenseId: 'CC-BY-3.0',
          ),
        ],
      );

      expect(missingLocator.isValid, isFalse);
    });

    test('non-geographic or weak source classes cannot create normal pins', () {
      const rejectedClasses = <ReligiousSourceClass>[
        ReligiousSourceClass.meaningBasedDua,
        ReligiousSourceClass.classicalTraditional,
        ReligiousSourceClass.israiliyat,
        ReligiousSourceClass.laterTradition,
        ReligiousSourceClass.ebcedHavasTradition,
        ReligiousSourceClass.disputed,
        ReligiousSourceClass.unknown,
      ];

      for (final sourceClass in rejectedClasses) {
        final marker = ProphetMapMarker(
          label: const LocalizedReligiousText(
            tr: 'Yaklaşık yer',
            en: 'Approximate place',
            ar: 'موضع تقريبي',
          ),
          kind: ProphetMapMarkerKind.approximateRegion,
          certainty: CertaintyLevel.approximate,
          sources: [
            SourceReference(
              id: 'source-${sourceClass.name}',
              title: 'Rejected map source',
              sourceClass: sourceClass,
              licenseId: 'REFERENCE-ONLY',
              locator: 'location claim',
            ),
          ],
        );

        expect(
          marker.isValid,
          isFalse,
          reason: '${sourceClass.name} must not create a normal map pin',
        );
      }
    });
  });
}
