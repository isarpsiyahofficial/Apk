import 'canonical_prophets.dart';
import 'prophet_semantic_ownership_qa.dart';
import 'prophet_semantic_release_backlog_t0336.dart';

/// Fail-closed audit for the historical-date dimension of the T0336 gate.
///
/// A missing exact/approximate date must remain explicit instead of being
/// populated from popular chronology, genealogy inference, or another
/// prophet's timeline. This audit mirrors the canonical 25×8 backlog and makes
/// every unresolved date slot machine-readable.
enum ProphetHistoricalDateGapReasonT0336 {
  noReviewedHistoricalDateEvidenceAdmitted,
}

final class ProphetHistoricalDateGapT0336 {
  const ProphetHistoricalDateGapT0336({
    required this.prophetId,
    required this.reason,
  });

  final String prophetId;
  final ProphetHistoricalDateGapReasonT0336 reason;
}

List<ProphetHistoricalDateGapT0336>
    buildProphetHistoricalDateUnresolvedAuditT0336({
  List<ProphetSemanticDimensionBacklogT0336>? backlog,
}) {
  final resolvedBacklog =
      backlog ?? canonicalProphetSemanticReleaseBacklogT0336;
  final historicalDate = resolvedBacklog.singleWhere(
    (entry) => entry.dimension == ProphetSemanticDimension.historicalDate,
  );

  final canonicalIds = canonicalQuranNamedProphets
      .map((identity) => identity.canonicalId)
      .toSet();
  final verifiedIds = historicalDate.verifiedProphetIds.toSet();
  final unresolvedIds = historicalDate.unresolvedProphetIds.toSet();

  if (canonicalIds.length != 25 ||
      verifiedIds.intersection(unresolvedIds).isNotEmpty ||
      verifiedIds.union(unresolvedIds).length != canonicalIds.length ||
      !canonicalIds.containsAll(verifiedIds) ||
      !canonicalIds.containsAll(unresolvedIds)) {
    throw StateError(
      'T0336 historical-date audit requires a partition of all 25 canonical prophets',
    );
  }

  return List<ProphetHistoricalDateGapT0336>.unmodifiable(
    historicalDate.unresolvedProphetIds.map(
      (prophetId) => ProphetHistoricalDateGapT0336(
        prophetId: prophetId,
        reason: ProphetHistoricalDateGapReasonT0336
            .noReviewedHistoricalDateEvidenceAdmitted,
      ),
    ),
  );
}

final List<ProphetHistoricalDateGapT0336>
    canonicalProphetHistoricalDateUnresolvedAuditT0336 =
    buildProphetHistoricalDateUnresolvedAuditT0336();
