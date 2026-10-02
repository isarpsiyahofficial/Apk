import 'package:flutter_test/flutter_test.dart';
import 'package:islami_hayat/features/prophets/data/prophet_semantic_gap_manifest_t0336.dart';
import 'package:islami_hayat/features/prophets/data/prophet_semantic_ownership_qa.dart';
import 'package:islami_hayat/features/prophets/data/prophet_semantic_release_gate_t0336.dart';

void main() {
  test('canonical T0336 report and 200-slot manifest agree exactly', () {
    final gate = canonicalProphetSemanticReleaseGateT0336;

    expect(gate.isValid, isTrue, reason: gate.errors.join('\n'));
    expect(gate.coveredSlots + gate.missingSlots, 200);
    expect(gate.missingSlots, greaterThan(0));
    expect(gate.isReleaseComplete, isFalse);
  });

  test('coverage/manifest semantic disagreement fails closed', () {
    final canonical = canonicalProphetSemanticGapManifestT0336;
    final tamperedSlots = canonical.slots.map((slot) {
      if (slot.prophetId == 'adam' &&
          slot.dimension == ProphetSemanticDimension.historicalDate) {
        return const ProphetSemanticGapSlotT0336(
          prophetId: 'adam',
          dimension: ProphetSemanticDimension.historicalDate,
          state: ProphetSemanticSlotStateT0336.verified,
          verifiedClaimKeys: ['historicalDate:adam:tampered'],
          sourceIds: ['tampered-source'],
        );
      }
      return slot;
    }).toList(growable: false);

    final result = auditProphetSemanticReleaseGateT0336(
      manifest: ProphetSemanticGapManifestT0336(slots: tamperedSlots),
    );

    expect(result.isValid, isFalse);
    expect(
      result.errors.any(
        (error) => error.contains('adam/historicalDate') &&
            error.contains('coverage/manifest disagreement'),
      ),
      isTrue,
    );
  });

  test('verified manifest slot without evidence fails closed', () {
    final canonical = canonicalProphetSemanticGapManifestT0336;
    final tamperedSlots = canonical.slots.map((slot) {
      if (slot.prophetId == 'adam' &&
          slot.dimension == ProphetSemanticDimension.historicalDate) {
        return const ProphetSemanticGapSlotT0336(
          prophetId: 'adam',
          dimension: ProphetSemanticDimension.historicalDate,
          state: ProphetSemanticSlotStateT0336.verified,
          verifiedClaimKeys: [],
          sourceIds: [],
        );
      }
      return slot;
    }).toList(growable: false);

    final result = auditProphetSemanticReleaseGateT0336(
      manifest: ProphetSemanticGapManifestT0336(slots: tamperedSlots),
    );

    expect(result.isValid, isFalse);
    expect(
      result.errors.any((error) => error.contains('lacks claim/source evidence')),
      isTrue,
    );
  });

  test('silent historical date gap fails closed', () {
    final canonical = canonicalProphetSemanticGapManifestT0336;
    final tamperedSlots = canonical.slots.map((slot) {
      if (slot.prophetId == 'adam' &&
          slot.dimension == ProphetSemanticDimension.historicalDate) {
        return const ProphetSemanticGapSlotT0336(
          prophetId: 'adam',
          dimension: ProphetSemanticDimension.historicalDate,
          state: ProphetSemanticSlotStateT0336.missingVerifiedEvidence,
          verifiedClaimKeys: [],
          sourceIds: [],
        );
      }
      return slot;
    }).toList(growable: false);

    final result = auditProphetSemanticReleaseGateT0336(
      manifest: ProphetSemanticGapManifestT0336(slots: tamperedSlots),
    );

    expect(result.isValid, isFalse);
    expect(
      result.errors.any(
        (error) => error.contains('adam/historicalDate') &&
            error.contains('explicitly unknown or pendingReview'),
      ),
      isTrue,
    );
  });

  test('missing manifest slot fails closed instead of shrinking the matrix', () {
    final canonical = canonicalProphetSemanticGapManifestT0336;
    final shortened = canonical.slots
        .where(
          (slot) =>
              !(slot.prophetId == 'adam' &&
                  slot.dimension == ProphetSemanticDimension.historicalDate),
        )
        .toList(growable: false);

    final result = auditProphetSemanticReleaseGateT0336(
      manifest: ProphetSemanticGapManifestT0336(slots: shortened),
    );

    expect(result.isValid, isFalse);
    expect(
      result.errors.any((error) => error.contains('missing manifest slot')),
      isTrue,
    );
  });

  test('duplicate prophet/dimension slot fails closed', () {
    final canonical = canonicalProphetSemanticGapManifestT0336;
    final duplicated = <ProphetSemanticGapSlotT0336>[
      ...canonical.slots,
      canonical.slotFor('adam', ProphetSemanticDimension.identity),
    ];

    final result = auditProphetSemanticReleaseGateT0336(
      manifest: ProphetSemanticGapManifestT0336(slots: duplicated),
    );

    expect(result.isValid, isFalse);
    expect(
      result.errors.any(
        (error) => error.contains('duplicate prophet/dimension slots'),
      ),
      isTrue,
    );
  });
}