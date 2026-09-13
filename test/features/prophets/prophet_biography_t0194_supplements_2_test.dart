import 'package:flutter_test/flutter_test.dart';
import 'package:islami_hayat/core/content/content_governance.dart';
import 'package:islami_hayat/features/prophets/data/canonical_prophet_biographies.dart';
import 'package:islami_hayat/features/prophets/data/prophet_biography_t0194_dataset.dart';
import 'package:islami_hayat/features/prophets/data/prophet_biography_t0194_supplements_2.dart';

void main() {
  test('second T0194 batch is Quran-only and source complete', () {
    expect(
      t0194ProphetBiographySupplements2.keys.toSet(),
      {'harun', 'dawud', 'sulayman'},
    );

    for (final entry in t0194ProphetBiographySupplements2.entries) {
      expect(entry.value, isNotEmpty, reason: entry.key);
      for (final field in entry.value.values) {
        expect(field.isValid, isTrue, reason: entry.key);
        expect(field.status, ProphetBiographyFieldStatus.sourceBacked);
        expect(field.sources, hasLength(1));
        final source = field.sources.single;
        expect(source.sourceClass, ReligiousSourceClass.quran);
        expect(source.id, startsWith('tanzil-uthmani-v1.1-'));
        expect(source.licenseId, 'CC-BY-3.0');
        expect(source.locator, startsWith('Quran '));
      }
    }
  });

  test('batch does not invent chronology geography birth or death', () {
    for (final prophet in t0194ProphetBiographySupplements2.values) {
      expect(prophet.containsKey(ProphetBiographySectionKey.geography), isFalse);
      expect(prophet.containsKey(ProphetBiographySectionKey.period), isFalse);
      expect(prophet.containsKey(ProphetBiographySectionKey.birth), isFalse);
      expect(prophet.containsKey(ProphetBiographySectionKey.death), isFalse);
    }
  });

  test('Harun support and calf warning keep explicit Quran provenance', () {
    final harun = t0194ProphetBiographySupplements2['harun']!;
    expect(
      harun[ProphetBiographySectionKey.missionStart]!.sources.single.locator,
      'Quran 19:53',
    );
    expect(
      harun[ProphetBiographySectionKey.keyEvents]!.sources.single.locator,
      'Quran 20:90-94',
    );
  });

  test('Dawud justice Zabur and worship claims use separate provenance', () {
    final dawud = t0194ProphetBiographySupplements2['dawud']!;
    expect(
      dawud[ProphetBiographySectionKey.missionStart]!.sources.single.locator,
      'Quran 38:26',
    );
    expect(
      dawud[ProphetBiographySectionKey.scriptureScrolls]!.sources.single.locator,
      'Quran 4:163',
    );
    expect(
      dawud[ProphetBiographySectionKey.dua]!.sources.single.locator,
      'Quran 38:24-25',
    );
  });

  test('Sulayman wind jinn and dua claims keep explicit Quran provenance', () {
    final sulayman = t0194ProphetBiographySupplements2['sulayman']!;
    expect(
      sulayman[ProphetBiographySectionKey.keyEvents]!.sources.single.locator,
      'Quran 27:15-16',
    );
    expect(
      sulayman[ProphetBiographySectionKey.miracles]!.sources.single.locator,
      'Quran 34:12-13',
    );
    expect(
      sulayman[ProphetBiographySectionKey.dua]!.sources.single.locator,
      'Quran 27:19',
    );
  });

  test('second batch reference lists are valid and duplicate-free', () {
    for (final entry in t0194ProphetSupplementReferences2.entries) {
      expect(entry.value, isNotEmpty, reason: entry.key);
      expect(entry.value.every((reference) => reference.isValid), isTrue);
      expect(
        entry.value.map((reference) => reference.stableId).toSet().length,
        entry.value.length,
        reason: entry.key,
      );
    }
  });

  test('working dataset actually merges the second source batch', () {
    CanonicalProphetBiographyDraft draft(String id) =>
        canonicalProphetBiographyT0194Dataset.singleWhere(
          (entry) => entry.identity.canonicalId == id,
        );

    expect(
      draft('harun').sections[ProphetBiographySectionKey.missionStart]!.status,
      ProphetBiographyFieldStatus.sourceBacked,
    );
    expect(
      draft('dawud').sections[ProphetBiographySectionKey.scriptureScrolls]!.status,
      ProphetBiographyFieldStatus.sourceBacked,
    );
    expect(
      draft('sulayman').sections[ProphetBiographySectionKey.dua]!.status,
      ProphetBiographyFieldStatus.sourceBacked,
    );
    expect(canonicalProphetBiographyT0194DatasetIsStructurallyValid, isTrue);
  });
}
