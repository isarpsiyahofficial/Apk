import 'canonical_prophets.dart';
import 'prophet_semantic_evidence_t0336.dart';
import 'prophet_semantic_ownership_qa.dart';

enum ProphetSemanticSlotStateT0336 {
  verified,
  missingVerifiedEvidence,
}

/// One auditable slot in the mandatory 25 prophets × 8 semantic dimensions
/// release gate. A slot is never inferred from prose or another dimension.
final class ProphetSemanticGapSlotT0336 {
  const ProphetSemanticGapSlotT0336({
    required this.prophetId,
    required this.dimension,
    required this.state,
    required this.verifiedClaimKeys,
    required this.sourceIds,
  });

  final String prophetId;
  final ProphetSemanticDimension dimension;
  final ProphetSemanticSlotStateT0336 state;
  final List<String> verifiedClaimKeys;
  final List<String> sourceIds;

  bool get isVerified => state == ProphetSemanticSlotStateT0336.verified;

  String get gapReason => isVerified
      ? ''
      : 'No biography-owned, verified, source-class-valid evidence is admitted '
          'for ${dimension.name}.';
}

final class ProphetSemanticGapManifestT0336 {
  const ProphetSemanticGapManifestT0336({required this.slots});

  final List<ProphetSemanticGapSlotT0336> slots;

  int get requiredSlotCount =>
      canonicalQuranNamedProphets.length * ProphetSemanticDimension.values.length;

  int get verifiedSlotCount => slots.where((slot) => slot.isVerified).length;

  int get missingSlotCount => requiredSlotCount - verifiedSlotCount;

  bool get isReleaseComplete =>
      slots.length == requiredSlotCount && missingSlotCount == 0;

  List<ProphetSemanticGapSlotT0336> missingFor(String prophetId) =>
      List<ProphetSemanticGapSlotT0336>.unmodifiable(
        slots.where((slot) => slot.prophetId == prophetId && !slot.isVerified),
      );

  ProphetSemanticGapSlotT0336 slotFor(
    String prophetId,
    ProphetSemanticDimension dimension,
  ) =>
      slots.singleWhere(
        (slot) => slot.prophetId == prophetId && slot.dimension == dimension,
        orElse: () => throw ArgumentError(
          'Unknown T0336 semantic slot: $prophetId/${dimension.name}',
        ),
      );
}

/// Produces an editorially useful 200-slot manifest without inventing missing
/// dates, lineage, hadith or geography. Only evidence that passes the same
/// ownership/source-class gate used by release QA may become `verified`.
ProphetSemanticGapManifestT0336 buildProphetSemanticGapManifestT0336({
  Iterable<ProphetSemanticClaim>? claims,
}) {
  final claimList = List<ProphetSemanticClaim>.unmodifiable(
    claims ?? canonicalProphetSemanticEvidenceT0336,
  );

  final audit = const ProphetSemanticOwnershipQa().audit(
    claims: claimList,
    requireFull25Coverage: false,
  );
  if (!audit.isValid) {
    throw StateError(
      'T0336 gap manifest received invalid semantic evidence: '
      '${audit.errors.join(' | ')}',
    );
  }

  final canonicalIds = canonicalQuranNamedProphets
      .map((identity) => identity.canonicalId)
      .toSet();
  if (canonicalIds.length != 25) {
    throw StateError(
      'T0336 gap manifest requires exactly 25 unique canonical prophets',
    );
  }

  final usableClaims = claimList.where(
    (claim) =>
        claim.evidenceState == ProphetSemanticEvidenceState.verified &&
        !claim.contextReference &&
        claim.biographyProphetId == claim.subjectProphetId,
  );

  final slots = <ProphetSemanticGapSlotT0336>[];
  for (final identity in canonicalQuranNamedProphets) {
    for (final dimension in ProphetSemanticDimension.values) {
      final evidence = usableClaims
          .where(
            (claim) =>
                claim.biographyProphetId == identity.canonicalId &&
                claim.dimension == dimension,
          )
          .toList(growable: false);

      final claimKeys = evidence.map((claim) => claim.claimKey).toSet().toList()
        ..sort();
      final sourceIds = evidence
          .expand((claim) => claim.sourceIds)
          .map((id) => id.trim())
          .where((id) => id.isNotEmpty)
          .toSet()
          .toList()
        ..sort();

      slots.add(
        ProphetSemanticGapSlotT0336(
          prophetId: identity.canonicalId,
          dimension: dimension,
          state: evidence.isEmpty
              ? ProphetSemanticSlotStateT0336.missingVerifiedEvidence
              : ProphetSemanticSlotStateT0336.verified,
          verifiedClaimKeys: List<String>.unmodifiable(claimKeys),
          sourceIds: List<String>.unmodifiable(sourceIds),
        ),
      );
    }
  }

  return ProphetSemanticGapManifestT0336(
    slots: List<ProphetSemanticGapSlotT0336>.unmodifiable(slots),
  );
}

final ProphetSemanticGapManifestT0336 canonicalProphetSemanticGapManifestT0336 =
    buildProphetSemanticGapManifestT0336();
