import 'package:flutter_test/flutter_test.dart';
import 'package:islami_hayat/core/content/content_governance.dart';
import 'package:islami_hayat/features/prophets/data/canonical_prophets.dart';
import 'package:islami_hayat/features/prophets/data/prophet_timeline.dart';

void main() {
  group('main approximate prophet chronology', () {
    test('is valid and covers every canonical Quran-named prophet exactly once', () {
      expect(mainApproximateProphetChronologyIsValid, isTrue);

      final flattened = mainApproximateProphetChronology
          .expand((band) => band.prophetIds)
          .toList(growable: false);
      final canonicalIds = canonicalQuranNamedProphets
          .map((entry) => entry.canonicalId)
          .toSet();

      expect(flattened, specificationMainChronologyFlattened);
      expect(flattened.length, 25);
      expect(flattened.toSet().length, 25);
      expect(flattened.toSet(), canonicalIds);
    });

    test('never encodes a Gregorian year or exact dating claim', () {
      for (final band in mainApproximateProphetChronology) {
        expect(band.certainty, CertaintyLevel.approximate);
        expect(band.isValid, isTrue);
      }
    });

    test('known broad contemporaneous groups remain parallel instead of fake ordering', () {
      final parallelGroups = mainApproximateProphetChronology
          .where((band) => band.kind == ProphetChronologyBandKind.parallel)
          .map((band) => band.prophetIds)
          .toList(growable: false);

      expect(
        parallelGroups,
        containsAll(<List<String>>[
          ['ibrahim', 'lut'],
          ['ismail', 'ishaq'],
          ['musa', 'harun'],
        ]),
      );
    });

    test('chronology evidence excludes weak/disputed source classes', () {
      const forbidden = <ReligiousSourceClass>{
        ReligiousSourceClass.israiliyat,
        ReligiousSourceClass.laterTradition,
        ReligiousSourceClass.disputed,
        ReligiousSourceClass.unknown,
      };

      for (final band in mainApproximateProphetChronology) {
        expect(band.sources, isNotEmpty);
        for (final source in band.sources) {
          expect(forbidden.contains(source.sourceClass), isFalse);
          expect(source.id.trim(), isNotEmpty);
          expect(source.title.trim(), isNotEmpty);
          expect(source.licenseId.trim(), isNotEmpty);
          expect(source.locator?.trim(), isNotEmpty);
        }
      }
    });

    test('sequential band cannot silently contain multiple prophets', () {
      const invalid = ProphetChronologyBand(
        order: 1,
        prophetIds: ['musa', 'harun'],
        kind: ProphetChronologyBandKind.sequential,
        certainty: CertaintyLevel.approximate,
        sources: [
          SourceReference(
            id: 'quran-4-163',
            title: 'Qur’an 4:163',
            sourceClass: ReligiousSourceClass.quran,
            licenseId: 'quran-reference-only',
            locator: '4:163',
          ),
        ],
      );

      expect(invalid.isValid, isFalse);
    });

    test('parallel band cannot be promoted to exact certainty', () {
      const invalid = ProphetChronologyBand(
        order: 1,
        prophetIds: ['ibrahim', 'lut'],
        kind: ProphetChronologyBandKind.parallel,
        certainty: CertaintyLevel.explicitSource,
        sources: [
          SourceReference(
            id: 'quran-4-163',
            title: 'Qur’an 4:163',
            sourceClass: ReligiousSourceClass.quran,
            licenseId: 'quran-reference-only',
            locator: '4:163',
          ),
        ],
      );

      expect(invalid.isValid, isFalse);
    });

    test('disputed evidence cannot drive the main chronology', () {
      const invalid = ProphetChronologyBand(
        order: 1,
        prophetIds: ['adam'],
        kind: ProphetChronologyBandKind.sequential,
        certainty: CertaintyLevel.approximate,
        sources: [
          SourceReference(
            id: 'late-story',
            title: 'Unverified later narrative',
            sourceClass: ReligiousSourceClass.laterTradition,
            licenseId: 'reference-only',
            locator: 'n/a',
          ),
        ],
      );

      expect(invalid.isValid, isFalse);
    });
  });
}
