import 'prophet_semantic_coverage_report_t0336.dart';
import 'prophet_semantic_gap_manifest_t0336.dart';
import 'prophet_semantic_ownership_qa.dart';

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

/// Cross-validates the two independently useful T0336 views:
/// - the compact per-prophet coverage report;
/// - the explicit 200-slot editorial gap manifest.
///
/// A release may never pass if they disagree. This prevents a future refactor
/// from accidentally hiding a missing dimension in one representation while
/// the other still reports it.
ProphetSemanticReleaseGateResultT0336 auditProphetSemanticReleaseGateT0336({
  ProphetSemanticCoverageReportT0336? coverage,
  ProphetSemanticGapManifestT0336? manifest,
}) {
  final coverageReport = coverage ?? canonicalProphetCoverageReportT0336;
  final gapManifest = manifest ?? canonicalProphetSemanticGapManifestT0336;
  final errors = <String>[];

  if (coverageReport.requiredClaimSlots != 200) {
    errors.add(
      'T0336 coverage report must expose exactly 200 required slots; got '
      '${coverageReport.requiredClaimSlots}',
    );
  }
  if (gapManifest.requiredSlotCount != 200 || gapManifest.slots.length != 200) {
    errors.add(
      'T0336 gap manifest must expose exactly 200 slots; got '
      '${gapManifest.slots.length}/${gapManifest.requiredSlotCount}',
    );
  }

  for (final row in coverageReport.rows) {
    for (final dimension in ProphetSemanticDimension.values) {
      ProphetSemanticGapSlotT0336 slot;
      try {
        slot = gapManifest.slotFor(row.prophetId, dimension);
      } on ArgumentError {
        errors.add('${row.prophetId}/${dimension.name}: missing manifest slot');
        continue;
      }

      final reportCovered = row.covered.contains(dimension);
      if (reportCovered != slot.isVerified) {
        errors.add(
          '${row.prophetId}/${dimension.name}: coverage/manifest disagreement '
          '(report=$reportCovered manifest=${slot.isVerified})',
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
