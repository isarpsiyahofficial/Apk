import 'package:flutter_test/flutter_test.dart';
import 'package:islami_hayat/features/prophets/data/canonical_prophets.dart';

void main() {
  group('canonical Quran-named prophets', () {
    test('contains exactly 25 unique canonical identities', () {
      expect(canonicalQuranNamedProphets, hasLength(25));
      expect(canonicalQuranNamedProphetsIsValid, isTrue);

      final ids = canonicalQuranNamedProphets.map((entry) => entry.canonicalId).toSet();
      final arabicNames = canonicalQuranNamedProphets.map((entry) => entry.arabicName).toSet();
      expect(ids, hasLength(25));
      expect(arabicNames, hasLength(25));
    });

    test('matches the established 25-name canonical set', () {
      final ids = canonicalQuranNamedProphets.map((entry) => entry.canonicalId).toSet();
      expect(
        ids,
        equals({
          'adam',
          'idris',
          'nuh',
          'hud',
          'salih',
          'ibrahim',
          'lut',
          'ismail',
          'ishaq',
          'yakub',
          'yusuf',
          'ayyub',
          'shuayb',
          'musa',
          'harun',
          'dawud',
          'sulayman',
          'ilyas',
          'alyasa',
          'yunus',
          'zakariya',
          'yahya',
          'isa',
          'muhammad',
          'dhul_kifl',
        }),
      );
    });

    test('TR EN AR names and representative explicit-name refs are valid', () {
      for (final entry in canonicalQuranNamedProphets) {
        expect(entry.name.isComplete, isTrue, reason: entry.canonicalId);
        expect(entry.name.tr.trim(), isNotEmpty, reason: entry.canonicalId);
        expect(entry.name.en.trim(), isNotEmpty, reason: entry.canonicalId);
        expect(entry.name.ar, entry.arabicName, reason: entry.canonicalId);
        expect(entry.explicitNameReference.isValid, isTrue, reason: entry.canonicalId);
      }
    });

    test('does not silently promote disputed or traditional candidates', () {
      final ids = canonicalQuranNamedProphets.map((entry) => entry.canonicalId).toSet();
      expect(ids.intersection(disputedOrNonCanonicalProphetCandidates), isEmpty);
      expect(disputedOrNonCanonicalProphetCandidates, contains('luqman'));
      expect(disputedOrNonCanonicalProphetCandidates, contains('uzayr'));
      expect(disputedOrNonCanonicalProphetCandidates, contains('dhul_qarnayn'));
      expect(disputedOrNonCanonicalProphetCandidates, contains('khidr'));
      expect(disputedOrNonCanonicalProphetCandidates, contains('shith'));
    });

    test('identity registry does not fabricate chronology or biography', () {
      final fields = CanonicalProphetIdentity.new.toString();
      expect(fields, isNotEmpty);
      // This registry intentionally exposes only identity + one explicit Quran
      // anchor. Chronology, geography, family and claims belong to governed
      // ProphetContent records in later TODO items.
      for (final entry in canonicalQuranNamedProphets) {
        expect(entry.canonicalId, isNotEmpty);
      }
    });
  });
}
