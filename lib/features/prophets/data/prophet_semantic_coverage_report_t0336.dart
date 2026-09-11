import 'canonical_prophets.dart';
import 'prophet_biography_qa.dart';
import 'prophet_semantic_evidence_t0336.dart';
import 'prophet_semantic_ownership_qa.dart';

/// Machine-readable coverage snapshot for the v1.2 T0336 25×8 release gate.
///
/// Only verified, biography-owned (non-context-reference) claims count. This
/// report never fills gaps: unknown/pending evidence and contextual mentions
/// stay visible as missing dimensions so editorial QA cannot accidentally turn
/// incomplete biography research into a release PASS.
final class ProphetSemanticCoverageRowT0336 {
  const ProphetSemanticCoverageRowT0336({
    required this.prophetId,
    required this.covered,
  });

  final String prophetId;
  final Set<ProphetSemanticDimension> covered;

  Set<ProphetSemanticDimension> get missing =>
      ProphetSemanticDimension.values.toSet().difference(covered);

  bool get isComplete => missing.isEmpty;
}

final class ProphetSemanticCoverageReportT0336 {
  const ProphetSemanticCoverageReportT0336({required this.rows});

  final List<ProphetSemanticCoverageRowT0336> rows;

  int get requiredClaimSlots =>
      canonicalQuranNamedProphets.length * ProphetSemanticDimension.values.length;

  int get coveredClaimSlots =>
      rows.fold<int>(0, (sum, row) => sum + row.covered.length);

  int get missingClaimSlots => requiredClaimSlots - coveredClaimSlots;

  bool get isReleaseComplete =>
      rows.length == 25 && rows.every((row) => row.isComplete);

  ProphetSemanticCoverageRowT0336 rowFor(String prophetId) => rows.singleWhere(
        (row) => row.prophetId == prophetId,
        orElse: () => throw ArgumentError.value(
          prophetId,
          'prophetId',
          'Unknown canonical prophet id',
        ),
      );
}

ProphetSemanticCoverageReportT0336 buildCanonicalProphetCoverageReportT0336({
  Iterable<ProphetSemanticClaim>? claims,
}) {
  // T0336 must not count semantic coverage on top of a contradictory canonical
  // biography graph. This independently validates source provenance,
  // genealogy direction/cycles and chronology-band consistency before any
  // 25×8 slot can contribute to release readiness.
  final biographyAudit = const ProphetBiographyQaAudit().auditCanonicalResearchDataset();
  if (!biographyAudit.isValid) {
    throw StateError(
      'T0336 canonical biography genealogy/chronology audit failed: '
      '${biographyAudit.errors.join(' | ')}',
    );
  }

  final claimList = List<ProphetSemanticClaim>.unmodifiable(
    claims ?? canonicalProphetSemanticEvidenceT0336,
  );
  final semanticAudit = const ProphetSemanticOwnershipQa().audit(
    claims: claimList,
    requireFull25Coverage: false,
  );
  if (!semanticAudit.isValid) {
    throw StateError(
      'T0336 coverage received invalid semantic evidence: '
      '${semanticAudit.errors.join(' | ')}',
    );
  }

  final canonicalIds = canonicalQuranNamedProphets
      .map((identity) => identity.canonicalId)
      .toSet();
  if (canonicalIds.length != 25) {
    throw StateError(
      'T0336 canonical identity registry must contain exactly 25 unique ids',
    );
  }

  final coveredByProphet = <String, Set<ProphetSemanticDimension>>{
    for (final id in canonicalIds) id: <ProphetSemanticDimension>{},
  };

  for (final claim in claimList) {
    if (claim.evidenceState != ProphetSemanticEvidenceState.verified ||
        claim.contextReference ||
        claim.subjectProphetId != claim.biographyProphetId) {
      continue;
    }

    coveredByProphet[claim.biographyProphetId]!.add(claim.dimension);
  }

  final rows = canonicalQuranNamedProphets
      .map(
        (identity) => ProphetSemanticCoverageRowT0336(
          prophetId: identity.canonicalId,
          covered: Set<ProphetSemanticDimension>.unmodifiable(
            coveredByProphet[identity.canonicalId]!,
          ),
        ),
      )
      .toList(growable: false);

  return ProphetSemanticCoverageReportT0336(rows: List.unmodifiable(rows));
}

final ProphetSemanticCoverageReportT0336 canonicalProphetCoverageReportT0336 =
    buildCanonicalProphetCoverageReportT0336();
