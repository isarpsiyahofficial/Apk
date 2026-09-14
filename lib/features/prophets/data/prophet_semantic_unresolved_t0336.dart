import 'canonical_prophets.dart';
import 'prophet_hadith_evidence_t0336_batch32.dart';
import 'prophet_hadith_evidence_t0336_batch33.dart';
import 'prophet_hadith_evidence_t0336_batch34.dart';
import 'prophet_hadith_evidence_t0336_batch35.dart';
import 'prophet_hadith_evidence_t0336_batch36.dart';
import 'prophet_hadith_evidence_t0336_batch37.dart';
import 'prophet_semantic_evidence_t0336.dart';
import 'prophet_semantic_ownership_qa.dart';

/// Adds an explicit, non-verifying record for every canonical prophet/dimension
/// pair that has no biography-owned semantic record yet.
///
/// This is intentionally editorial metadata, not factual evidence. A generated
/// record is `pendingReview`, has no source ids/classes, and therefore can never
/// satisfy verified release coverage. Its purpose is to make every one of the
/// 25 x 8 required slots machine-visible so a missing hadith, lineage,
/// geography, date, or other dimension cannot disappear as a silent omission.
/// Existing verified/unknown/pending records are preserved and never duplicated.
List<ProphetSemanticClaim> buildProphetSemanticEvidenceWithUnresolvedT0336({
  Iterable<ProphetSemanticClaim>? claims,
}) {
  final base = List<ProphetSemanticClaim>.unmodifiable(
    claims ?? <ProphetSemanticClaim>[
      ...canonicalProphetSemanticEvidenceT0336,
      ...prophetHadithEvidenceT0336Batch32,
      ...prophetHadithEvidenceT0336Batch33,
      ...prophetHadithEvidenceT0336Batch34,
      ...prophetHadithEvidenceT0336Batch35,
      ...prophetHadithEvidenceT0336Batch36,
      ...prophetHadithEvidenceT0336Batch37,
    ],
  );
  final output = <ProphetSemanticClaim>[...base];

  for (final identity in canonicalQuranNamedProphets) {
    for (final dimension in ProphetSemanticDimension.values) {
      final alreadyRecorded = base.any(
        (claim) =>
            claim.biographyProphetId == identity.canonicalId &&
            claim.subjectProphetId == identity.canonicalId &&
            claim.dimension == dimension &&
            !claim.contextReference,
      );
      if (alreadyRecorded) continue;

      output.add(
        ProphetSemanticClaim(
          biographyProphetId: identity.canonicalId,
          subjectProphetId: identity.canonicalId,
          dimension: dimension,
          claimKey:
              '${dimension.name}:${identity.canonicalId}:pending-semantic-review',
          sourceIds: const <String>[],
          evidenceState: ProphetSemanticEvidenceState.pendingReview,
        ),
      );
    }
  }

  return List<ProphetSemanticClaim>.unmodifiable(output);
}

final List<ProphetSemanticClaim> canonicalProphetSemanticEvidenceWithUnresolvedT0336 =
    buildProphetSemanticEvidenceWithUnresolvedT0336();
