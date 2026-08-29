import 'package:flutter_test/flutter_test.dart';
import 'package:islami_hayat/features/prophets/data/canonical_prophet_biographies.dart';
import 'package:islami_hayat/features/prophets/data/prophet_biography_t0194_dataset.dart';

void main() {
  test('T0194 working dataset keeps all 25 canonical biographies valid', () {
    expect(canonicalProphetBiographyT0194Dataset, hasLength(25));
    expect(canonicalProphetBiographyT0194DatasetIsStructurallyValid, isTrue);
  });

  test('Ishaq Yakub Yusuf supplements are applied to canonical drafts', () {
    CanonicalProphetBiographyDraft byId(String id) =>
        canonicalProphetBiographyT0194Dataset.singleWhere(
          (draft) => draft.identity.canonicalId == id,
        );

    final ishaq = byId('ishaq');
    final yakub = byId('yakub');
    final yusuf = byId('yusuf');

    expect(
      ishaq.sections[ProphetBiographySectionKey.missionStart]!.status,
      ProphetBiographyFieldStatus.sourceBacked,
    );
    expect(
      yakub.sections[ProphetBiographySectionKey.dua]!.sources.single.locator,
      'Quran 12:86',
    );
    expect(
      yusuf.sections[ProphetBiographySectionKey.dua]!.sources.single.locator,
      'Quran 12:101',
    );

    expect(ishaq.hasPendingResearch, isTrue);
    expect(yakub.hasPendingResearch, isTrue);
    expect(yusuf.hasPendingResearch, isTrue);
  });

  test('supplement Quran references are merged without duplicates', () {
    for (final id in const ['ishaq', 'yakub', 'yusuf']) {
      final draft = canonicalProphetBiographyT0194Dataset.singleWhere(
        (entry) => entry.identity.canonicalId == id,
      );
      expect(
        draft.quranReferences.map((entry) => entry.stableId).toSet().length,
        draft.quranReferences.length,
        reason: id,
      );
    }
  });
}
