import 'canonical_prophet_biographies.dart';
import 'prophet_biography_t0194_supplements.dart';
import 'prophet_biography_t0194_supplements_2.dart';
import 'prophet_biography_t0194_supplements_3.dart';
import 'prophet_biography_t0194_supplements_4.dart';
import 'prophet_biography_t0194_supplements_5.dart';
import 'prophet_biography_t0194_supplements_6.dart';
import 'prophet_content.dart';

CanonicalProphetBiographyDraft _applySupplement(
  CanonicalProphetBiographyDraft draft,
) {
  final firstSupplement =
      t0194ProphetBiographySupplements[draft.identity.canonicalId];
  final secondSupplement =
      t0194ProphetBiographySupplements2[draft.identity.canonicalId];
  final thirdSupplement =
      t0194ProphetBiographySupplements3[draft.identity.canonicalId];
  final fourthSupplement =
      t0194ProphetBiographySupplements4[draft.identity.canonicalId];
  final fifthSupplement =
      t0194ProphetBiographySupplements5[draft.identity.canonicalId];
  final sixthSupplement =
      t0194ProphetBiographySupplements6[draft.identity.canonicalId];
  final firstReferences =
      t0194ProphetSupplementReferences[draft.identity.canonicalId] ??
          const <ProphetVerseReference>[];
  final secondReferences =
      t0194ProphetSupplementReferences2[draft.identity.canonicalId] ??
          const <ProphetVerseReference>[];
  final thirdReferences =
      t0194ProphetSupplementReferences3[draft.identity.canonicalId] ??
          const <ProphetVerseReference>[];
  final fourthReferences =
      t0194ProphetSupplementReferences4[draft.identity.canonicalId] ??
          const <ProphetVerseReference>[];
  final fifthReferences =
      t0194ProphetSupplementReferences5[draft.identity.canonicalId] ??
          const <ProphetVerseReference>[];

  if (firstSupplement == null &&
      secondSupplement == null &&
      thirdSupplement == null &&
      fourthSupplement == null &&
      fifthSupplement == null &&
      sixthSupplement == null &&
      firstReferences.isEmpty &&
      secondReferences.isEmpty &&
      thirdReferences.isEmpty &&
      fourthReferences.isEmpty &&
      fifthReferences.isEmpty) {
    return draft;
  }

  final referencesById = <String, ProphetVerseReference>{
    for (final reference in draft.quranReferences) reference.stableId: reference,
    for (final reference in firstReferences) reference.stableId: reference,
    for (final reference in secondReferences) reference.stableId: reference,
    for (final reference in thirdReferences) reference.stableId: reference,
    for (final reference in fourthReferences) reference.stableId: reference,
    for (final reference in fifthReferences) reference.stableId: reference,
  };

  return CanonicalProphetBiographyDraft(
    identity: draft.identity,
    quranReferences: referencesById.values.toList(growable: false),
    sections: <ProphetBiographySectionKey, ProphetBiographyField>{
      ...draft.sections,
      if (firstSupplement != null) ...firstSupplement,
      if (secondSupplement != null) ...secondSupplement,
      if (thirdSupplement != null) ...thirdSupplement,
      if (fourthSupplement != null) ...fourthSupplement,
      if (fifthSupplement != null) ...fifthSupplement,
      if (sixthSupplement != null) ...sixthSupplement,
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
