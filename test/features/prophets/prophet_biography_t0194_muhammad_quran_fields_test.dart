import 'package:flutter_test/flutter_test.dart';
import 'package:islami_hayat/features/prophets/data/canonical_prophet_biographies.dart';
import 'package:islami_hayat/features/prophets/data/prophet_biography_t0194_dataset.dart';

void main() {
  final muhammad = canonicalProphetBiographyT0194Dataset.firstWhere(
    (draft) => draft.identity.canonicalId == 'muhammad',
  );

  test('T0194 Muhammad Quran batch fills only the reviewed biography fields', () {
    for (final key in <ProphetBiographySectionKey>[
      ProphetBiographySectionKey.geography,
      ProphetBiographySectionKey.childhoodYouth,
      ProphetBiographySectionKey.communityResponse,
    ]) {
      final field = muhammad.sections[key]!;
      expect(field.status, ProphetBiographyFieldStatus.sourceBacked);
      expect(field.sources, hasLength(1));
      expect(field.sources.single.id, startsWith('tanzil-uthmani-v1.1-'));
      expect(field.sources.single.licenseId, 'CC-BY-3.0');
    }
  });

  test('T0194 Muhammad Quran batch keeps exact reviewed locators auditable', () {
    expect(
      muhammad.sections[ProphetBiographySectionKey.geography]!.sources.single.locator,
      'Quran 48:24',
    );
    expect(
      muhammad
          .sections[ProphetBiographySectionKey.childhoodYouth]!
          .sources
          .single
          .locator,
      'Quran 93:6',
    );
    expect(
      muhammad
          .sections[ProphetBiographySectionKey.communityResponse]!
          .sources
          .single
          .locator,
      'Quran 25:4-5',
    );
    expect(prophetBiographyT0194DraftHasTraceableProvenance(muhammad), isTrue);
  });

  test('T0194 Muhammad Quran-reference index contains the reviewed verses', () {
    final references = muhammad.quranReferences.map((ref) => ref.stableId).toSet();
    expect(references, containsAll(<String>['25:4', '25:5', '48:24', '93:6']));
  });
}
