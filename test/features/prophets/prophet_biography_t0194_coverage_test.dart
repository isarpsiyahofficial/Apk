import 'package:flutter_test/flutter_test.dart';
import 'package:islami_hayat/core/content/content_governance.dart';
import 'package:islami_hayat/features/prophets/data/canonical_prophet_biographies.dart';
import 'package:islami_hayat/features/prophets/data/prophet_biography_t0194_dataset.dart';

void main() {
  test('T0194 covers every canonical prophet with prophet-specific evidence', () {
    expect(canonicalProphetBiographyT0194Dataset, hasLength(25));

    for (final draft in canonicalProphetBiographyT0194Dataset) {
      expect(draft.isStructurallyComplete, isTrue, reason: draft.identity.canonicalId);

      final sourceBacked = draft.sections.entries
          .where(
            (entry) =>
                entry.value.status == ProphetBiographyFieldStatus.sourceBacked,
          )
          .toList(growable: false);

      // mainMessage is universal Quran 21:25. Requiring at least one further
      // field prevents a canonical identity from looking researched when it
      // only inherited the universal prophethood message.
      expect(
        sourceBacked.length,
        greaterThanOrEqualTo(2),
        reason: '${draft.identity.canonicalId} needs prophet-specific evidence',
      );

      expect(
        sourceBacked.every(
          (entry) => entry.value.sources.every(
            (source) =>
                source.sourceClass == ReligiousSourceClass.quran ||
                source.sourceClass == ReligiousSourceClass.sahihHasanHadith,
          ),
        ),
        isTrue,
        reason: '${draft.identity.canonicalId} contains an unreviewed source class',
      );
    }
  });

  test('T0194 unresolved claims remain explicit unknowns instead of guesses', () {
    for (final draft in canonicalProphetBiographyT0194Dataset) {
      for (final field in draft.sections.values.where(
        (entry) =>
            entry.status == ProphetBiographyFieldStatus.unknownPendingResearch,
      )) {
        expect(field.sources, isEmpty, reason: draft.identity.canonicalId);
        expect(field.text.tr, contains('kesin bilgi uydurulmayacaktır'));
        expect(field.text.en, contains('no definite claim will be invented'));
        expect(field.text.ar, contains('لن تُختلق معلومة قطعية'));
      }
    }
  });

  test('T0194 source-backed fields retain usable provenance metadata', () {
    for (final draft in canonicalProphetBiographyT0194Dataset) {
      for (final field in draft.sections.values.where(
        (entry) => entry.status == ProphetBiographyFieldStatus.sourceBacked,
      )) {
        expect(field.sources, isNotEmpty, reason: draft.identity.canonicalId);
        for (final source in field.sources) {
          expect(source.id.trim(), isNotEmpty);
          expect(source.title.trim(), isNotEmpty);
          expect(source.licenseId.trim(), isNotEmpty);
          expect(source.sourceClass, isNot(ReligiousSourceClass.unknown));
        }
      }
    }
  });
}
