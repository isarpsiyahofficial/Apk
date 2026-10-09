import 'package:flutter_test/flutter_test.dart';
import 'package:islami_hayat/core/content/content_governance.dart';
import 'package:islami_hayat/features/prophets/data/canonical_prophet_biographies.dart';
import 'package:islami_hayat/features/prophets/data/prophet_biography_t0194_dataset.dart';

void main() {
  test('T0194 reviewed geography remains pinned to exact owner and source', () {
    const expected = <String, ({String sourceId, String locator, String verse})>{
      'salih': (sourceId: 'tanzil-uthmani-v1.1-salih-q7-73-74-q89-9-thamud-settlement-geography', locator: 'Quran 7:73-74; 89:9', verse: '7:73'),
      'lut': (sourceId: 'tanzil-uthmani-v1.1-lut-q21-74-q15-76-town-road-geography', locator: 'Quran 21:74; 15:76', verse: '21:74'),
      'hud': (sourceId: 'tanzil-uthmani-v1.1-hud-q11-50-q46-21-ahqaf-geography', locator: 'Quran 11:50; 46:21', verse: '46:21'),
      'harun': (sourceId: 'tanzil-uthmani-v1.1-harun-q23-45-46-q43-51-egypt-geography', locator: 'Quran 23:45-46; 43:51', verse: '23:45'),
      'nuh': (sourceId: 'tanzil-uthmani-v1.1-nuh-q11-44-al-judi-geography', locator: 'Quran 11:44', verse: '11:44'),
      'ibrahim': (sourceId: 'tanzil-uthmani-v1.1-ibrahim-q2-127-kaaba-geography', locator: 'Quran 2:127', verse: '2:127'),
      'ismail': (sourceId: 'tanzil-uthmani-v1.1-ismail-q2-127-kaaba-geography', locator: 'Quran 2:127', verse: '2:127'),
      'yusuf': (sourceId: 'tanzil-uthmani-v1.1-yusuf-q12-21-egypt-geography', locator: 'Quran 12:21', verse: '12:21'),
      'shuayb': (sourceId: 'tanzil-uthmani-v1.1-shuayb-q11-84-madyan-geography', locator: 'Quran 11:84', verse: '11:84'),
      'musa': (sourceId: 'tanzil-uthmani-v1.1-musa-q28-22-23-madyan-geography', locator: 'Quran 28:22-23', verse: '28:22'),
      'isa': (sourceId: 'tanzil-uthmani-v1.1-isa-q23-50-geography', locator: 'Quran 23:50', verse: '23:50'),
      'muhammad': (sourceId: 'tanzil-uthmani-v1.1-muhammad-q17-1-isra-geography', locator: 'Quran 17:1', verse: '17:1'),
      'yakub': (sourceId: 'tanzil-uthmani-v1.1-yakub-q12-99-egypt-geography', locator: 'Quran 12:99', verse: '12:99'),
      'yunus': (sourceId: 'tanzil-uthmani-v1.1-yunus-q37-145-open-shore-geography', locator: 'Quran 37:145', verse: '37:145'),
      'ayyub': (sourceId: 'tanzil-uthmani-v1.1-ayyub-q38-42-water-geography', locator: 'Quran 38:42', verse: '38:42'),
      'sulayman': (sourceId: 'tanzil-uthmani-v1.1-sulayman-q27-18-valley-of-ants-geography', locator: 'Quran 27:18', verse: '27:18'),
      'zakariya': (sourceId: 'tanzil-uthmani-v1.1-zakariya-q3-38-39-sanctuary-geography', locator: 'Quran 3:38-39', verse: '3:39'),
      'dawud': (sourceId: 'tanzil-uthmani-v1.1-dawud-q34-10-mountains-geography', locator: 'Quran 34:10', verse: '34:10'),
    };

    for (final entry in expected.entries) {
      final draft = canonicalProphetBiographyT0194Dataset.singleWhere(
        (item) => item.identity.canonicalId == entry.key,
      );
      final geography = draft.sections[ProphetBiographySectionKey.geography]!;
      expect(geography.status, ProphetBiographyFieldStatus.sourceBacked,
          reason: '${entry.key} geography must remain source-backed');
      expect(geography.sources, hasLength(1));
      expect(geography.sources.single.id, entry.value.sourceId);
      expect(geography.sources.single.locator, entry.value.locator);
      expect(geography.sources.single.sourceClass, ReligiousSourceClass.quran);
      expect(
        draft.quranReferences.map((reference) => reference.stableId),
        contains(entry.value.verse),
        reason: '${entry.key} reviewed geography verse must remain auditable',
      );
    }
  });

  test('T0194 Quran cross-reference geography keeps every supporting verse', () {
    final byId = {
      for (final item in canonicalProphetBiographyT0194Dataset)
        item.identity.canonicalId: item,
    };
    expect(byId['salih']!.quranReferences.map((item) => item.stableId).toSet(), containsAll(<String>['7:73', '7:74', '89:9']));
    expect(byId['lut']!.quranReferences.map((item) => item.stableId).toSet(), containsAll(<String>['21:74', '15:76']));
    expect(byId['hud']!.quranReferences.map((item) => item.stableId).toSet(), containsAll(<String>['11:50', '46:21']));
    expect(byId['harun']!.quranReferences.map((item) => item.stableId).toSet(), containsAll(<String>['23:45', '23:46', '43:51']));
    expect(byId['zakariya']!.quranReferences.map((item) => item.stableId).toSet(), containsAll(<String>['3:38', '3:39']));
    expect(byId['yakub']!.quranReferences.map((item) => item.stableId).toSet(), contains('12:99'));
  });

  test('T0194 Muhammad merge keeps earlier reviewed 48:24 reference', () {
    final muhammad = canonicalProphetBiographyT0194Dataset.singleWhere(
      (item) => item.identity.canonicalId == 'muhammad',
    );
    final references = muhammad.quranReferences.map((item) => item.stableId).toSet();
    expect(references, containsAll(<String>['17:1', '48:24']));
  });
}