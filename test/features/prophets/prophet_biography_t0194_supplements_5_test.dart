import 'package:flutter_test/flutter_test.dart';
import 'package:islami_hayat/core/content/content_governance.dart';
import 'package:islami_hayat/features/prophets/data/canonical_prophet_biographies.dart';
import 'package:islami_hayat/features/prophets/data/prophet_biography_t0194_dataset.dart';
import 'package:islami_hayat/features/prophets/data/prophet_biography_t0194_supplements_5.dart';

void main() {
  test('fifth T0194 batch is Quran-only and source complete', () {
    expect(t0194ProphetBiographySupplements5.keys.toSet(), {'isa', 'muhammad'});

    for (final entry in t0194ProphetBiographySupplements5.entries) {
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

  test('batch does not invent geography period or exact death data', () {
    for (final prophet in t0194ProphetBiographySupplements5.values) {
      expect(prophet.containsKey(ProphetBiographySectionKey.geography), isFalse);
      expect(prophet.containsKey(ProphetBiographySectionKey.period), isFalse);
      expect(prophet.containsKey(ProphetBiographySectionKey.death), isFalse);
    }
  });

  test('Isa miracles retain by-Allah-permission qualification in all locales', () {
    final miracles = t0194ProphetBiographySupplements5['isa']![
      ProphetBiographySectionKey.miracles
    ]!;
    expect(miracles.sources.single.locator, 'Quran 3:49');
    expect(miracles.text.tr, contains('Allah’ın iznine'));
    expect(miracles.text.en, contains('Allah’s permission'));
    expect(miracles.text.ar, contains('بإذن الله'));
  });

  test('Isa birth and raising claims keep chronology/death overclaim closed', () {
    final isa = t0194ProphetBiographySupplements5['isa']!;
    expect(isa[ProphetBiographySectionKey.birth]!.text.tr, contains('takvim tarihi vermez'));
    expect(
      isa[ProphetBiographySectionKey.keyEvents]!.sources.single.locator,
      'Quran 4:157-158',
    );
    expect(isa.containsKey(ProphetBiographySectionKey.death), isFalse);
  });

  test('Isa Gospel and dua keep distinct Quran provenance', () {
    final isa = t0194ProphetBiographySupplements5['isa']!;
    expect(
      isa[ProphetBiographySectionKey.scriptureScrolls]!.sources.single.locator,
      'Quran 5:46',
    );
    expect(
      isa[ProphetBiographySectionKey.dua]!.sources.single.locator,
      'Quran 5:114',
    );
  });

  test('Muhammad universal mission and finality keep explicit provenance', () {
    final muhammad = t0194ProphetBiographySupplements5['muhammad']!;
    expect(
      muhammad[ProphetBiographySectionKey.community]!.sources.single.locator,
      'Quran 7:158',
    );
    expect(
      muhammad[ProphetBiographySectionKey.laterImpact]!.sources.single.locator,
      'Quran 33:40',
    );
  });

  test('Muhammad cave event and knowledge prayer are not conflated', () {
    final muhammad = t0194ProphetBiographySupplements5['muhammad']!;
    expect(
      muhammad[ProphetBiographySectionKey.keyEvents]!.sources.single.locator,
      'Quran 9:40',
    );
    expect(
      muhammad[ProphetBiographySectionKey.dua]!.sources.single.locator,
      'Quran 20:114',
    );
  });

  test('fifth batch reference lists are valid and duplicate-free', () {
    for (final entry in t0194ProphetSupplementReferences5.entries) {
      expect(entry.value, isNotEmpty, reason: entry.key);
      expect(entry.value.every((reference) => reference.isValid), isTrue);
      expect(
        entry.value.map((reference) => reference.stableId).toSet().length,
        entry.value.length,
        reason: entry.key,
      );
    }
  });

  test('working dataset actually merges the fifth source batch', () {
    CanonicalProphetBiographyDraft draft(String id) =>
        canonicalProphetBiographyT0194Dataset.singleWhere(
          (entry) => entry.identity.canonicalId == id,
        );

    expect(
      draft('isa').sections[ProphetBiographySectionKey.miracles]!.status,
      ProphetBiographyFieldStatus.sourceBacked,
    );
    expect(
      draft('muhammad').sections[ProphetBiographySectionKey.dua]!.status,
      ProphetBiographyFieldStatus.sourceBacked,
    );
    expect(canonicalProphetBiographyT0194DatasetIsStructurallyValid, isTrue);
  });
}
