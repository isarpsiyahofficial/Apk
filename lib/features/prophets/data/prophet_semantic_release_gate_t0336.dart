import 'prophet_semantic_coverage_report_t0336.dart';
import 'prophet_semantic_gap_manifest_t0336.dart';
import 'prophet_semantic_ownership_qa.dart';
import 'verified_prophet_family_relations.dart';

final class ProphetSemanticReleaseGateResultT0336 {
  const ProphetSemanticReleaseGateResultT0336({
    required this.errors,
    required this.coveredSlots,
    required this.missingSlots,
  });

  final List<String> errors;
  final int coveredSlots;
  final int missingSlots;

  bool get isValid => errors.isEmpty;
  bool get isReleaseComplete => isValid && missingSlots == 0;
}

/// Cross-validates the independently useful T0336 views:
/// - the compact per-prophet coverage report;
/// - the explicit 200-slot editorial gap manifest;
/// - the reviewed genealogy graph and its approximate chronology consistency.
///
/// A release may never pass if these views disagree. In particular, filling all
/// 200 semantic slots is insufficient when the separately reviewed family graph
/// is invalid or a parent/ancestor relation contradicts the governed chronology.
/// This keeps family/date claims fail-closed instead of allowing coverage counts
/// to hide a semantic genealogy regression.
ProphetSemanticReleaseGateResultT0336 auditProphetSemanticReleaseGateT0336({
  ProphetSemanticCoverageReportT0336? coverage,
  ProphetSemanticGapManifestT0336? manifest,
  bool? familyGraphValid,
  bool? familyChronologyConsistent,
}) {
  final coverageReport = coverage ?? canonicalProphetCoverageReportT0336;
  final gapManifest = manifest ?? canonicalProphetSemanticGapManifestT0336;
  final genealogyValid = familyGraphValid ?? verifiedProphetFamilyGraphIsValid;
  final chronologyConsistent = familyChronologyConsistent ??
      verifiedProphetFamilyChronologyIsConsistent;
  final errors = <String>[];

  if (!genealogyValid) {
    errors.add('T0336 reviewed prophet genealogy graph is invalid');
  }
  if (!chronologyConsistent) {
    errors.add(
      'T0336 reviewed prophet genealogy contradicts approximate chronology',
    );
  }

  if (coverageReport.requiredClaimSlots != 200) {
    errors.add(
      'T0336 coverage report must expose exactly 200 required slots; got '
      '${coverageReport.requiredClaimSlots}',
    );
  }
  if (coverageReport.rows.length != 25) {
    errors.add(
      'T0336 coverage report must expose exactly 25 prophet rows; got '
      '${coverageReport.rows.length}',
    );
  }
  if (gapManifest.requiredSlotCount != 200 || gapManifest.slots.length != 200) {
    errors.add(
      'T0336 gap manifest must expose exactly 200 slots; got '
      '${gapManifest.slots.length}/${gapManifest.requiredSlotCount}',
    );
  }

  final uniqueManifestSlots = gapManifest.slots
      .map((slot) => '${slot.prophetId}|${slot.dimension.name}')
      .toSet();
  if (uniqueManifestSlots.length != gapManifest.slots.length) {
    errors.add('T0336 gap manifest contains duplicate prophet/dimension slots');
  }

  for (final row in coverageReport.rows) {
    for (final dimension in ProphetSemanticDimension.values) {
      ProphetSemanticGapSlotT0336 slot;
      try {
        slot = gapManifest.slotFor(row.prophetId, dimension);
      } on ArgumentError {
        errors.add('${row.prophetId}/${dimension.name}: missing manifest slot');
        continue;
      } on StateError {
        errors.add('${row.prophetId}/${dimension.name}: duplicate manifest slot');
        continue;
      }

      final reportCovered = row.covered.contains(dimension);
      if (reportCovered != slot.isVerified) {
        errors.add(
          '${row.prophetId}/${dimension.name}: coverage/manifest disagreement '
          '(report=$reportCovered manifest=${slot.isVerified})',
        );
      }

      if (slot.unresolvedClaimKeys.length !=
          slot.unresolvedClaimKeys.toSet().length) {
        errors.add(
          '${row.prophetId}/${dimension.name}: duplicate unresolved claim keys',
        );
      }
      if (slot.unresolvedEvidenceStates.any(
        (state) => state == ProphetSemanticEvidenceState.verified,
      )) {
        errors.add(
          '${row.prophetId}/${dimension.name}: unresolved metadata cannot carry '
          'verified evidence state',
        );
      }

      if (slot.isVerified &&
          (slot.verifiedClaimKeys.isEmpty || slot.sourceIds.isEmpty)) {
        errors.add(
          '${row.prophetId}/${dimension.name}: verified manifest slot lacks '
          'claim/source evidence',
        );
      }
      if (!slot.isVerified &&
          (slot.verifiedClaimKeys.isNotEmpty || slot.sourceIds.isNotEmpty)) {
        errors.add(
          '${row.prophetId}/${dimension.name}: missing slot carries verified '
          'claim/source evidence',
        );
      }

      // Exact historical dates are particularly high-risk. If exact verified
      // evidence does not exist, the gap must be explicit rather than silently
      // absent. This keeps uncertainty visible and prevents future code from
      // filling a date from chronology/order/lineage inference.
      if (dimension == ProphetSemanticDimension.historicalDate &&
          !slot.isVerified &&
          !slot.hasExplicitUnresolvedEvidence) {
        errors.add(
          '${row.prophetId}/historicalDate: missing exact-date evidence must be '
          'explicitly unknown or pendingReview',
        );
      }
    }
  }

  if (coverageReport.coveredClaimSlots != gapManifest.verifiedSlotCount) {
    errors.add(
      'T0336 total covered-slot mismatch: report='
      '${coverageReport.coveredClaimSlots} manifest=${gapManifest.verifiedSlotCount}',
    );
  }
  if (coverageReport.missingClaimSlots != gapManifest.missingSlotCount) {
    errors.add(
      'T0336 total missing-slot mismatch: report='
      '${coverageReport.missingClaimSlots} manifest=${gapManifest.missingSlotCount}',
    );
  }

  return ProphetSemanticReleaseGateResultT0336(
    errors: List<String>.unmodifiable(errors),
    coveredSlots: gapManifest.verifiedSlotCount,
    missingSlots: gapManifest.missingSlotCount,
  );
}

final ProphetSemanticReleaseGateResultT0336 canonicalProphetSemanticReleaseGateT0336 =
    auditProphetSemanticReleaseGateT0336();
