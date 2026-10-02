import 'package:flutter_test/flutter_test.dart';
import 'package:islami_hayat/core/content/content_governance.dart';
import 'package:islami_hayat/features/prophets/data/canonical_prophet_biographies.dart';
import 'package:islami_hayat/features/prophets/data/prophet_biography_t0194_dataset.dart';
import 'package:islami_hayat/features/prophets/data/prophet_biography_t0194_supplements_4.dart';

void main() {
  test('fourth T0194 batch is Quran-only and source complete', () {
    expect(
      t0194ProphetBiographySupplements4.keys.toSet(),
      {'dhul_kifl', 'zakariya', 'yahya'},
    );

    for (final entry in t0194ProphetBiographySupplements4.entries) {
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

  test('batch does not invent geography period or death details', () {
    for (final prophet in t0194ProphetBiographySupplements4.values) {
      expect(prophet.containsKey(ProphetBiographySectionKey.geography), isFalse);
      expect(prophet.containsKey(ProphetBiographySectionKey.period), isFalse);
      expect(prophet.containsKey(ProphetBiographySectionKey.death), isFalse);
    }
  });

  test('Dhul-Kifl remains limited to explicit Quran notices', () {
    final dhulKifl = t0194ProphetBiographySupplements4['dhul_kifl']!;
    expect(dhulKifl.keys.toSet(), {
      ProphetBiographySectionKey.keyEvents,
      ProphetBiographySectionKey.laterImpact,
    });
    expect(
      dhulKifl[ProphetBiographySectionKey.keyEvents]!.sources.single.locator,
      'Quran 21:85',
    );
    expect(
      dhulKifl[ProphetBiographySectionKey.laterImpact]!.sources.single.locator,
      'Quran 21:86; 38:48',
    );
    expect(dhulKifl.containsKey(ProphetBiographySectionKey.missionStart), isFalse);
  });

  test('Zakariya prayer and sign claims keep separate Quran provenance', () {
    final zakariya = t0194ProphetBiographySupplements4['zakariya']!;
    expect(
      zakariya[ProphetBiographySectionKey.dua]!.sources.single.locator,
      'Quran 3:38; 21:89-90',
    );
    expect(
      zakariya[ProphetBiographySectionKey.keyEvents]!.sources.single.locator,
      'Quran 3:39-41',
    );
    expect(
      zakariya[ProphetBiographySectionKey.mainMessage]!.sources.single.locator,
      'Quran 19:11',
    );
  });

  test('Yahya birth wording preserves unknown calendar chronology', () {
    final yahya = t0194ProphetBiographySupplements4['yahya']!;
    final birth = yahya[ProphetBiographySectionKey.birth]!;
    expect(birth.sources.single.locator, 'Quran 19:7');
    expect(birth.text.tr, contains('kesin bir takvim tarihi vermez'));
    expect(birth.text.en, contains('without providing a calendar date'));
    expect(birth.text.ar, contains('من غير تحديد تاريخ'));
  });

  test('Yahya prophethood and virtues retain explicit Quran provenance', () {
    final yahya = t0194ProphetBiographySupplements4['yahya']!;
    expect(
      yahya[ProphetBiographySectionKey.missionStart]!.sources.single.locator,
      'Quran 3:39',
    );
    expect(
      yahya[ProphetBiographySectionKey.keyEvents]!.sources.single.locator,
      'Quran 19:12-14',
    );
    expect(
      yahya[ProphetBiographySectionKey.laterImpact]!.sources.single.locator,
      'Quran 19:15',
    );
  });

  test('fourth batch reference lists are valid and duplicate-free', () {
    for (final entry in t0194ProphetSupplementReferences4.entries) {
      expect(entry.value, isNotEmpty, reason: entry.key);
      expect(entry.value.every((reference) => reference.isValid), isTrue);
      expect(
        entry.value.map((reference) => reference.stableId).toSet().length,
        entry.value.length,
        reason: entry.key,
      );
    }
  });

  test('working dataset actually merges the fourth source batch', () {
    CanonicalProphetBiographyDraft draft(String id) =>
        canonicalProphetBiographyT0194Dataset.singleWhere(
          (entry) => entry.identity.canonicalId == id,
        );

    expect(
      draft('dhul_kifl').sections[ProphetBiographySectionKey.keyEvents]!.status,
      ProphetBiographyFieldStatus.sourceBacked,
    );
    expect(
      draft('zakariya').sections[ProphetBiographySectionKey.dua]!.status,
      ProphetBiographyFieldStatus.sourceBacked,
    );
    expect(
      draft('yahya').sections[ProphetBiographySectionKey.missionStart]!.status,
      ProphetBiographyFieldStatus.sourceBacked,
    );
    expect(canonicalProphetBiographyT0194DatasetIsStructurallyValid, isTrue);
  });
}
