import 'package:flutter_test/flutter_test.dart';
import 'package:islami_hayat/core/content/content_governance.dart';
import 'package:islami_hayat/features/prophets/data/canonical_prophet_biographies.dart';
import 'package:islami_hayat/features/prophets/data/prophet_biography_t0194_dataset.dart';

void main() {
  test('T0194 nested supplement chain preserves reviewed geography for every owner', () {
    const expected = <String, ({String sourceId, String locator, String verse})>{
      'ibrahim': (
        sourceId: 'tanzil-uthmani-v1.1-ibrahim-q2-127-kaaba-geography',
        locator: 'Quran 2:127',
        verse: '2:127',
      ),
      'ismail': (
        sourceId: 'tanzil-uthmani-v1.1-ismail-q2-127-kaaba-geography',
        locator: 'Quran 2:127',
        verse: '2:127',
      ),
      'yusuf': (
        sourceId: 'tanzil-uthmani-v1.1-yusuf-q12-21-egypt-geography',
        locator: 'Quran 12:21',
        verse: '12:21',
      ),
      'shuayb': (
        sourceId: 'tanzil-uthmani-v1.1-shuayb-q11-84-madyan-geography',
        locator: 'Quran 11:84',
        verse: '11:84',
      ),
      'musa': (
        sourceId: 'tanzil-uthmani-v1.1-musa-q28-22-23-madyan-geography',
        locator: 'Quran 28:22-23',
        verse: '28:22',
      ),
      'muhammad': (
        sourceId: 'tanzil-uthmani-v1.1-muhammad-q17-1-isra-geography',
        locator: 'Quran 17:1',
        verse: '17:1',
      ),
    };

    for (final entry in expected.entries) {
      final draft = canonicalProphetBiographyT0194Dataset.singleWhere(
        (item) => item.identity.canonicalId == entry.key,
      );
      final geography = draft.sections[ProphetBiographySectionKey.geography]!;

      expect(
        geography.status,
        ProphetBiographyFieldStatus.sourceBacked,
        reason: '${entry.key} geography must survive nested supplement composition',
      );
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

  test('T0194 Muhammad merge keeps earlier reviewed 48:24 reference', () {
    final muhammad = canonicalProphetBiographyT0194Dataset.singleWhere(
      (item) => item.identity.canonicalId == 'muhammad',
    );
    final references = muhammad.quranReferences.map((item) => item.stableId).toSet();

    expect(references, containsAll(<String>['17:1', '48:24']));
  });
}
