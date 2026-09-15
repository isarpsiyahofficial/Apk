import 'package:flutter_test/flutter_test.dart';
import 'package:islami_hayat/features/prophets/data/prophet_semantic_gap_manifest_t0336.dart';
import 'package:islami_hayat/features/prophets/data/prophet_semantic_ownership_qa.dart';
import 'package:islami_hayat/features/prophets/data/prophet_semantic_release_gate_t0336.dart';

void main() {
  test('silent non-date semantic gap fails closed', () {
    final canonical = canonicalProphetSemanticGapManifestT0336;
    final candidate = canonical.slots.firstWhere(
      (slot) =>
          !slot.isVerified &&
          slot.dimension != ProphetSemanticDimension.historicalDate,
    );
    final tamperedSlots = canonical.slots.map((slot) {
      if (identical(slot, candidate)) {
        return ProphetSemanticGapSlotT0336(
          prophetId: slot.prophetId,
          dimension: slot.dimension,
          state: ProphetSemanticSlotStateT0336.missingVerifiedEvidence,
          verifiedClaimKeys: const [],
          sourceIds: const [],
        );
      }
      return slot;
    }).toList(growable: false);

    final result = auditProphetSemanticReleaseGateT0336(
      manifest: ProphetSemanticGapManifestT0336(slots: tamperedSlots),
    );

    expect(result.isValid, isFalse);
    expect(
      result.errors,
      contains(
        '${candidate.prophetId}/${candidate.dimension.name}: missing verified '
        'evidence must be explicitly unknown or pendingReview',
      ),
    );
  });
}
