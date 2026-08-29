import 'canonical_prophet_biographies.dart';
import 'prophet_biography_t0194_supplements.dart';
import 'prophet_content.dart';

CanonicalProphetBiographyDraft _applySupplement(
  CanonicalProphetBiographyDraft draft,
) {
  final supplement = t0194ProphetBiographySupplements[draft.identity.canonicalId];
  final extraReferences =
      t0194ProphetSupplementReferences[draft.identity.canonicalId] ??
          const <ProphetVerseReference>[];

  if (supplement == null && extraReferences.isEmpty) return draft;

  final referencesById = <String, ProphetVerseReference>{
    for (final reference in draft.quranReferences) reference.stableId: reference,
    for (final reference in extraReferences) reference.stableId: reference,
  };

  return CanonicalProphetBiographyDraft(
    identity: draft.identity,
    quranReferences: referencesById.values.toList(growable: false),
    sections: <ProphetBiographySectionKey, ProphetBiographyField>{
      ...draft.sections,
      if (supplement != null) ...supplement,
    },
  );
}

/// T0194 working dataset. It preserves the 25 canonical identities while
/// layering source-reviewed biography fields onto the fail-closed base drafts.
///
/// This remains a research dataset: unresolved fields keep
/// `unknownPendingResearch`, so it must not be treated as a reviewed production
/// dataset until the remaining prophets and native/religious review gates close.
final canonicalProphetBiographyT0194Dataset = <CanonicalProphetBiographyDraft>[
  for (final draft in canonicalProphetBiographyDrafts) _applySupplement(draft),
];

bool get canonicalProphetBiographyT0194DatasetIsStructurallyValid =>
    canonicalProphetBiographyT0194Dataset.length == 25 &&
    canonicalProphetBiographyT0194Dataset.every(
      (draft) => draft.isStructurallyComplete && draft.hasPendingResearch,
    );
