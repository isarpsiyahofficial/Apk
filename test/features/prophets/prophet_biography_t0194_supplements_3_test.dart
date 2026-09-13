import 'package:flutter_test/flutter_test.dart';
import 'package:islami_hayat/core/content/content_governance.dart';
import 'package:islami_hayat/features/prophets/data/canonical_prophet_biographies.dart';
import 'package:islami_hayat/features/prophets/data/prophet_biography_t0194_dataset.dart';
import 'package:islami_hayat/features/prophets/data/prophet_biography_t0194_supplements_3.dart';

void main() {
  test('third T0194 batch is Quran-only and source complete', () {
    expect(
      t0194ProphetBiographySupplements3.keys.toSet(),
      {'ilyas', 'alyasa', 'yunus'},
    );

    for (final entry in t0194ProphetBiographySupplements3.entries) {
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
    for (final prophet in t0194ProphetBiographySupplements3.values) {
      expect(prophet.containsKey(ProphetBiographySectionKey.geography), isFalse);
      expect(prophet.containsKey(ProphetBiographySectionKey.period), isFalse);
      expect(prophet.containsKey(ProphetBiographySectionKey.birth), isFalse);
      expect(prophet.containsKey(ProphetBiographySectionKey.death), isFalse);
    }
  });

  test('Ilyas Baal warning and rejection keep explicit Quran provenance', () {
    final ilyas = t0194ProphetBiographySupplements3['ilyas']!;
    expect(
      ilyas[ProphetBiographySectionKey.missionStart]!.sources.single.locator,
      'Quran 37:123',
    );
    expect(
      ilyas[ProphetBiographySectionKey.mainMessage]!.sources.single.locator,
      'Quran 37:124-126',
    );
    expect(
      ilyas[ProphetBiographySectionKey.communityResponse]!.sources.single.locator,
      'Quran 37:127-128',
    );
  });

  test('Alyasa remains limited to the two explicit Quran notices', () {
    final alyasa = t0194ProphetBiographySupplements3['alyasa']!;
    expect(alyasa.keys.toSet(), {
      ProphetBiographySectionKey.keyEvents,
      ProphetBiographySectionKey.laterImpact,
    });
    expect(
      alyasa[ProphetBiographySectionKey.keyEvents]!.sources.single.locator,
      'Quran 6:86',
    );
    expect(
      alyasa[ProphetBiographySectionKey.laterImpact]!.sources.single.locator,
      'Quran 38:48',
    );
  });

  test('Yunus community is not silently promoted to a named city', () {
    final yunus = t0194ProphetBiographySupplements3['yunus']!;
    final community = yunus[ProphetBiographySectionKey.community]!;
    expect(community.sources.single.locator, 'Quran 10:98');
    expect(community.text.tr, contains('özel bir şehir adı vermeden'));
    expect(community.text.en, contains('without naming a city'));
    expect(community.text.ar, contains('من غير تسمية مدينة'));
  });

  test('Yunus event and prayer claims keep separate Quran provenance', () {
    final yunus = t0194ProphetBiographySupplements3['yunus']!;
    expect(
      yunus[ProphetBiographySectionKey.keyEvents]!.sources.single.locator,
      'Quran 37:140-148',
    );
    expect(
      yunus[ProphetBiographySectionKey.dua]!.sources.single.locator,
      'Quran 21:87-88',
    );
    expect(
      yunus[ProphetBiographySectionKey.communityResponse]!.sources.single.locator,
      'Quran 10:98',
    );
  });

  test('third batch reference lists are valid and duplicate-free', () {
    for (final entry in t0194ProphetSupplementReferences3.entries) {
      expect(entry.value, isNotEmpty, reason: entry.key);
      expect(entry.value.every((reference) => reference.isValid), isTrue);
      expect(
        entry.value.map((reference) => reference.stableId).toSet().length,
        entry.value.length,
        reason: entry.key,
      );
    }
  });

  test('working dataset actually merges the third source batch', () {
    CanonicalProphetBiographyDraft draft(String id) =>
        canonicalProphetBiographyT0194Dataset.singleWhere(
          (entry) => entry.identity.canonicalId == id,
        );

    expect(
      draft('ilyas').sections[ProphetBiographySectionKey.communityResponse]!.status,
      ProphetBiographyFieldStatus.sourceBacked,
    );
    expect(
      draft('alyasa').sections[ProphetBiographySectionKey.laterImpact]!.status,
      ProphetBiographyFieldStatus.sourceBacked,
    );
    expect(
      draft('yunus').sections[ProphetBiographySectionKey.dua]!.status,
      ProphetBiographyFieldStatus.sourceBacked,
    );
    expect(canonicalProphetBiographyT0194DatasetIsStructurallyValid, isTrue);
  });
}
