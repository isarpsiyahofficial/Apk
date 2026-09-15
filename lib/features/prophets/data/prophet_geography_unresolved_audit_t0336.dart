import 'canonical_prophets.dart';
import 'prophet_semantic_ownership_qa.dart';
import 'prophet_semantic_release_backlog_t0336.dart';

/// Fail-closed audit for unresolved geography slots in the mandatory T0336
/// prophet biography gate.
///
/// The audit does not invent a location from later tradition, modern map pins,
/// or another prophet's biography. A row remains unresolved until a
/// biography-owned geography claim with reviewed provenance is admitted by the
/// canonical semantic evidence pipeline.
enum ProphetGeographyGapReasonT0336 {
  noReviewedBiographyOwnedGeographyAdmitted,
}

final class ProphetGeographyGapT0336 {
  const ProphetGeographyGapT0336({
    required this.prophetId,
    required this.reason,
  });

  final String prophetId;
  final ProphetGeographyGapReasonT0336 reason;
}

List<ProphetGeographyGapT0336> buildProphetGeographyUnresolvedAuditT0336({
  List<ProphetSemanticDimensionBacklogT0336>? backlog,
}) {
  final resolvedBacklog =
      backlog ?? canonicalProphetSemanticReleaseBacklogT0336;
  final geography = resolvedBacklog.singleWhere(
    (entry) => entry.dimension == ProphetSemanticDimension.geography,
  );

  final canonicalIds = canonicalQuranNamedProphets
      .map((identity) => identity.canonicalId)
      .toSet();
  final verifiedIds = geography.verifiedProphetIds.toSet();
  final unresolvedIds = geography.unresolvedProphetIds.toSet();

  if (canonicalIds.length != 25 ||
      verifiedIds.intersection(unresolvedIds).isNotEmpty ||
      verifiedIds.union(unresolvedIds).length != canonicalIds.length ||
      !canonicalIds.containsAll(verifiedIds) ||
      !canonicalIds.containsAll(unresolvedIds)) {
    throw StateError(
      'T0336 geography audit requires a partition of all 25 canonical prophets',
    );
  }

  return List<ProphetGeographyGapT0336>.unmodifiable(
    geography.unresolvedProphetIds.map(
      (prophetId) => ProphetGeographyGapT0336(
        prophetId: prophetId,
        reason: ProphetGeographyGapReasonT0336
            .noReviewedBiographyOwnedGeographyAdmitted,
      ),
    ),
  );
}

final List<ProphetGeographyGapT0336> canonicalProphetGeographyUnresolvedAuditT0336 =
    buildProphetGeographyUnresolvedAuditT0336();
