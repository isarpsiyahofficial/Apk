import 'package:flutter_test/flutter_test.dart';
import 'package:islami_hayat/core/content/content_governance.dart';
import 'package:islami_hayat/features/prophets/data/canonical_prophet_biographies.dart';
import 'package:islami_hayat/features/prophets/data/prophet_biography_t0194_supplements.dart';

void main() {
  test('T0194 supplements are Quran-source backed', () {
    expect(
      t0194ProphetBiographySupplements.keys.toSet(),
      {'ishaq', 'yakub', 'yusuf', 'ayyub', 'shuayb', 'musa'},
    );

    for (final entry in t0194ProphetBiographySupplements.entries) {
      expect(entry.value, isNotEmpty, reason: entry.key);
      for (final field in entry.value.values) {
        expect(field.isValid, isTrue, reason: entry.key);
        expect(field.status, ProphetBiographyFieldStatus.sourceBacked);
        expect(field.sources, isNotEmpty);
        expect(
          field.sources.every(
            (source) => source.sourceClass == ReligiousSourceClass.quran,
          ),
          isTrue,
          reason: entry.key,
        );
        expect(
          field.sources.every(
            (source) => source.id.startsWith('tanzil-uthmani-v1.1-'),
          ),
          isTrue,
          reason: entry.key,
        );
        expect(
          field.sources.every((source) => source.licenseId == 'CC-BY-3.0'),
          isTrue,
          reason: entry.key,
        );
        expect(
          field.sources.every((source) => (source.locator ?? '').isNotEmpty),
          isTrue,
          reason: entry.key,
        );
      }
    }
  });

  test('supplements do not invent exact birth or death chronology', () {
    final ishaq = t0194ProphetBiographySupplements['ishaq']!;
    final yakub = t0194ProphetBiographySupplements['yakub']!;
    final yusuf = t0194ProphetBiographySupplements['yusuf']!;
    final ayyub = t0194ProphetBiographySupplements['ayyub']!;
    final shuayb = t0194ProphetBiographySupplements['shuayb']!;
    final musa = t0194ProphetBiographySupplements['musa']!;

    expect(ishaq.containsKey(ProphetBiographySectionKey.death), isFalse);
    expect(yakub.containsKey(ProphetBiographySectionKey.death), isFalse);
    expect(yusuf.containsKey(ProphetBiographySectionKey.birth), isFalse);
    expect(yusuf.containsKey(ProphetBiographySectionKey.death), isFalse);
    expect(ayyub.containsKey(ProphetBiographySectionKey.birth), isFalse);
    expect(ayyub.containsKey(ProphetBiographySectionKey.death), isFalse);
    expect(shuayb.containsKey(ProphetBiographySectionKey.birth), isFalse);
    expect(shuayb.containsKey(ProphetBiographySectionKey.death), isFalse);
    expect(musa.containsKey(ProphetBiographySectionKey.birth), isFalse);
    expect(musa.containsKey(ProphetBiographySectionKey.death), isFalse);
    expect(musa.containsKey(ProphetBiographySectionKey.period), isFalse);

    expect(
      ishaq[ProphetBiographySectionKey.birth]!.text.tr,
      contains('doğum yılı vermez'),
    );
    expect(
      yakub[ProphetBiographySectionKey.birth]!.text.en,
      contains('no exact birth date'),
    );
  });

  test('Ayyub distress and dua claims carry explicit Quran locators', () {
    final ayyub = t0194ProphetBiographySupplements['ayyub']!;

    expect(
      ayyub[ProphetBiographySectionKey.keyEvents]!.sources.single.locator,
      'Quran 21:83-84',
    );
    expect(
      ayyub[ProphetBiographySectionKey.dua]!.sources.single.locator,
      'Quran 21:83',
    );
  });

  test('Shuayb keeps Midian as community instead of inventing map coordinates', () {
    final shuayb = t0194ProphetBiographySupplements['shuayb']!;

    expect(
      shuayb[ProphetBiographySectionKey.community]!.sources.single.locator,
      'Quran 11:84',
    );
    expect(shuayb.containsKey(ProphetBiographySectionKey.geography), isFalse);
    expect(
      shuayb[ProphetBiographySectionKey.communityResponse]!
          .sources
          .single
          .locator,
      'Quran 11:87',
    );
  });

  test('Musa childhood mission signs and dua use separate Quran provenance', () {
    final musa = t0194ProphetBiographySupplements['musa']!;

    expect(
      musa[ProphetBiographySectionKey.childhoodYouth]!.sources.single.locator,
      'Quran 28:7-13',
    );
    expect(
      musa[ProphetBiographySectionKey.missionStart]!.sources.single.locator,
      'Quran 28:30-32',
    );
    expect(
      musa[ProphetBiographySectionKey.miracles]!.sources.single.locator,
      'Quran 28:31-32',
    );
    expect(
      musa[ProphetBiographySectionKey.dua]!.sources.single.locator,
      'Quran 20:25-35',
    );
  });

  test('Yusuf dua and interpretation claims carry explicit Quran locators', () {
    final yusuf = t0194ProphetBiographySupplements['yusuf']!;

    expect(
      yusuf[ProphetBiographySectionKey.dua]!.sources.single.locator,
      'Quran 12:101',
    );
    expect(
      yusuf[ProphetBiographySectionKey.miracles]!.sources.single.locator,
      'Quran 12:6, 12:21',
    );
  });

  test('supplement reference lists are valid and duplicate-free', () {
    for (final entry in t0194ProphetSupplementReferences.entries) {
      expect(entry.value, isNotEmpty, reason: entry.key);
      expect(
        entry.value.every((reference) => reference.isValid),
        isTrue,
        reason: entry.key,
      );
      expect(
        entry.value.map((reference) => reference.stableId).toSet().length,
        entry.value.length,
        reason: entry.key,
      );
    }
  });
}
