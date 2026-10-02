import 'canonical_prophets.dart';
import 'prophet_semantic_ownership_qa.dart';
import 'prophet_semantic_release_backlog_t0336.dart';

/// Fail-closed audit for the family/lineage dimension of the mandatory T0336
/// 25×8 prophet biography gate.
///
/// A prophet is unresolved here only when the canonical semantic backlog has
/// not admitted a biography-owned, verified family/lineage claim. This does not
/// assert that no kinship is mentioned anywhere in the wider literature; it
/// means the app has not yet accepted an independently reviewed explicit claim
/// into its canonical genealogy graph. No transitive or popularity-based
/// genealogy inference may close one of these gaps.
enum ProphetFamilyGapReasonT0336 {
  noReviewedExplicitProphetKinshipAdmitted,
}

final class ProphetFamilyGapT0336 {
  const ProphetFamilyGapT0336({
    required this.prophetId,
    required this.reason,
  });

  final String prophetId;
  final ProphetFamilyGapReasonT0336 reason;
}

List<ProphetFamilyGapT0336> buildProphetFamilyUnresolvedAuditT0336({
  List<ProphetSemanticDimensionBacklogT0336>? backlog,
}) {
  final resolvedBacklog =
      backlog ?? canonicalProphetSemanticReleaseBacklogT0336;
  final family = resolvedBacklog.singleWhere(
    (entry) => entry.dimension == ProphetSemanticDimension.familyLineage,
  );

  final canonicalIds = canonicalQuranNamedProphets
      .map((identity) => identity.canonicalId)
      .toSet();
  final verifiedIds = family.verifiedProphetIds.toSet();
  final unresolvedIds = family.unresolvedProphetIds.toSet();

  if (canonicalIds.length != 25 ||
      verifiedIds.intersection(unresolvedIds).isNotEmpty ||
      verifiedIds.union(unresolvedIds).length != canonicalIds.length ||
      !canonicalIds.containsAll(verifiedIds) ||
      !canonicalIds.containsAll(unresolvedIds)) {
    throw StateError(
      'T0336 family audit requires a partition of all 25 canonical prophets',
    );
  }

  return List<ProphetFamilyGapT0336>.unmodifiable(
    family.unresolvedProphetIds.map(
      (prophetId) => ProphetFamilyGapT0336(
        prophetId: prophetId,
        reason:
            ProphetFamilyGapReasonT0336.noReviewedExplicitProphetKinshipAdmitted,
      ),
    ),
  );
}

final List<ProphetFamilyGapT0336> canonicalProphetFamilyUnresolvedAuditT0336 =
    buildProphetFamilyUnresolvedAuditT0336();
