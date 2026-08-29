import 'package:flutter_test/flutter_test.dart';
import 'package:islami_hayat/core/content/content_governance.dart';
import 'package:islami_hayat/features/prophets/data/canonical_prophet_biographies.dart';
import 'package:islami_hayat/features/prophets/data/prophet_biography_t0194_supplements.dart';

void main() {
  test('T0194 Ishaq Yakub Yusuf supplements are Quran-source backed', () {
    expect(t0194ProphetBiographySupplements.keys.toSet(), {'ishaq', 'yakub', 'yusuf'});

    for (final entry in t0194ProphetBiographySupplements.entries) {
      expect(entry.value, isNotEmpty, reason: entry.key);
      for (final field in entry.value.values) {
        expect(field.isValid, isTrue, reason: entry.key);
        expect(field.status, ProphetBiographyFieldStatus.sourceBacked);
        expect(field.sources, isNotEmpty);
        expect(
          field.sources.every((source) => source.sourceClass == ReligiousSourceClass.quran),
          isTrue,
          reason: entry.key,
        );
        expect(
          field.sources.every((source) => source.id.startsWith('tanzil-uthmani-v1.1-')),
          isTrue,
          reason: entry.key,
        );
        expect(
          field.sources.every((source) => source.licenseId == 'CC-BY-3.0'),
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

    expect(ishaq.containsKey(ProphetBiographySectionKey.death), isFalse);
    expect(yakub.containsKey(ProphetBiographySectionKey.death), isFalse);
    expect(yusuf.containsKey(ProphetBiographySectionKey.birth), isFalse);
    expect(yusuf.containsKey(ProphetBiographySectionKey.death), isFalse);

    expect(ishaq[ProphetBiographySectionKey.birth]!.text.tr, contains('doğum yılı vermez'));
    expect(yakub[ProphetBiographySectionKey.birth]!.text.en, contains('no exact birth date'));
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
      expect(entry.value.every((reference) => reference.isValid), isTrue, reason: entry.key);
      expect(
        entry.value.map((reference) => reference.stableId).toSet().length,
        entry.value.length,
        reason: entry.key,
      );
    }
  });
}
