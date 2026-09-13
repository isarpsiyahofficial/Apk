import 'package:flutter_test/flutter_test.dart';
import 'package:islami_hayat/features/premium/domain/entitlement_state_machine.dart';
import 'package:islami_hayat/features/premium/domain/play_billing_product_catalog_t0274.dart';
import 'package:islami_hayat/features/premium/domain/play_restore_purchases_t0276.dart';

void main() {
  const machine = PlayRestorePurchasesStateMachineT0276();
  const productId = PlayBillingProductCatalogT0274.lifetimeProProductId;
  const evidence = 'restore-evidence-sha256:abc123';

  PlayRestoreStateT0276 restoring({
    EntitlementState entitlement = const EntitlementState.free(),
  }) {
    return machine.begin(PlayRestoreStateT0276.idle(entitlement: entitlement));
  }

  PlayRestoreOwnershipSnapshotT0276 verifiedOwnership({
    String fingerprint = evidence,
  }) {
    return PlayRestoreOwnershipSnapshotT0276(
      ownedProductIds: const [productId],
      verificationEvidenceFingerprintsByProductId: {
        productId: fingerprint,
      },
    );
  }

  test('restore begins without granting PRO', () {
    final state = restoring();

    expect(state.phase, PlayRestorePhaseT0276.restoring);
    expect(state.entitlement.isFree, isTrue);
    expect(state.grantsPro, isFalse);
  });

  test('canonical ownership waits for matching verification before PRO', () {
    final candidate = machine.handleOwnershipSnapshot(
      restoring(),
      verifiedOwnership(),
    );

    expect(candidate.phase, PlayRestorePhaseT0276.awaitingVerification);
    expect(candidate.productId, productId);
    expect(candidate.verificationEvidenceFingerprint, evidence);
    expect(candidate.entitlement.isFree, isTrue);
    expect(candidate.grantsPro, isFalse);
  });

  test('verified canonical restore transitions entitlement to online PRO', () {
    final candidate = machine.handleOwnershipSnapshot(
      restoring(),
      verifiedOwnership(),
    );

    final restored = machine.markVerifiedRestore(
      candidate,
      productId: productId,
      verificationEvidenceFingerprint: evidence,
    );

    expect(restored.phase, PlayRestorePhaseT0276.restored);
    expect(restored.entitlement.isPro, isTrue);
    expect(
      restored.entitlement.verification,
      EntitlementVerification.verifiedOnline,
    );
    expect(restored.verificationEvidenceFingerprint, evidence);
    expect(restored.grantsPro, isTrue);
  });

  test('canonical ownership without evidence fails closed', () {
    final state = machine.handleOwnershipSnapshot(
      restoring(),
      PlayRestoreOwnershipSnapshotT0276(ownedProductIds: const [productId]),
    );

    expect(state.phase, PlayRestorePhaseT0276.verificationFailed);
    expect(state.entitlement.isFree, isTrue);
    expect(state.grantsPro, isFalse);
  });

  test('empty ownership result never grants PRO', () {
    final state = machine.handleOwnershipSnapshot(
      restoring(),
      PlayRestoreOwnershipSnapshotT0276(ownedProductIds: const []),
    );

    expect(state.phase, PlayRestorePhaseT0276.nothingToRestore);
    expect(state.entitlement.isFree, isTrue);
    expect(state.grantsPro, isFalse);
  });

  test('unrelated product cannot become a restore candidate', () {
    final state = machine.handleOwnershipSnapshot(
      restoring(),
      PlayRestoreOwnershipSnapshotT0276(
        ownedProductIds: const ['legacy_or_unrelated_product'],
      ),
    );

    expect(state.phase, PlayRestorePhaseT0276.nothingToRestore);
    expect(state.productId, isNull);
    expect(state.grantsPro, isFalse);
  });

  test('query failure preserves entitlement and never creates a reward', () {
    final freeFailure = machine.markQueryFailed(restoring());
    final proFailure = machine.markQueryFailed(
      restoring(entitlement: const EntitlementState.cachedPro()),
    );

    expect(freeFailure.phase, PlayRestorePhaseT0276.queryFailed);
    expect(freeFailure.entitlement.isFree, isTrue);
    expect(freeFailure.grantsPro, isFalse);
    expect(proFailure.entitlement.isPro, isTrue);
    expect(proFailure.grantsPro, isFalse);
  });

  test('verification failure preserves current entitlement', () {
    final candidate = machine.handleOwnershipSnapshot(
      restoring(),
      verifiedOwnership(),
    );

    final failed = machine.markVerificationFailed(
      candidate,
      productId: productId,
      verificationEvidenceFingerprint: evidence,
    );

    expect(failed.phase, PlayRestorePhaseT0276.verificationFailed);
    expect(failed.entitlement.isFree, isTrue);
    expect(failed.verificationEvidenceFingerprint, evidence);
    expect(failed.grantsPro, isFalse);
  });

  test('verification cannot bypass ownership discovery', () {
    final state = restoring();

    expect(
      () => machine.markVerifiedRestore(
        state,
        productId: productId,
        verificationEvidenceFingerprint: evidence,
      ),
      throwsStateError,
    );
  });

  test('unknown product cannot complete restore verification', () {
    final candidate = machine.handleOwnershipSnapshot(
      restoring(),
      verifiedOwnership(),
    );

    expect(
      () => machine.markVerifiedRestore(
        candidate,
        productId: 'unknown_lifetime_product',
        verificationEvidenceFingerprint: evidence,
      ),
      throwsStateError,
    );
  });

  test('mismatched verification evidence cannot complete restore', () {
    final candidate = machine.handleOwnershipSnapshot(
      restoring(),
      verifiedOwnership(),
    );

    expect(
      () => machine.markVerifiedRestore(
        candidate,
        productId: productId,
        verificationEvidenceFingerprint: 'different-purchase-evidence',
      ),
      throwsStateError,
    );
    expect(
      () => machine.markVerificationFailed(
        candidate,
        productId: productId,
        verificationEvidenceFingerprint: 'different-purchase-evidence',
      ),
      throwsStateError,
    );
  });

  test('blank verification evidence is rejected at snapshot boundary', () {
    expect(
      () => PlayRestoreOwnershipSnapshotT0276(
        ownedProductIds: const [productId],
        verificationEvidenceFingerprintsByProductId: const {productId: '   '},
      ),
      throwsStateError,
    );
  });

  test('evidence for an unowned product is rejected', () {
    expect(
      () => PlayRestoreOwnershipSnapshotT0276(
        ownedProductIds: const [productId],
        verificationEvidenceFingerprintsByProductId: const {
          productId: evidence,
          'other_product': 'other-evidence',
        },
      ),
      throwsStateError,
    );
  });

  test('ownership snapshot evidence map and ID set are immutable', () {
    final snapshot = verifiedOwnership();

    expect(() => snapshot.ownedProductIds.add('other'), throwsUnsupportedError);
    expect(
      () => snapshot.verificationEvidenceFingerprintsByProductId[productId] = 'tampered',
      throwsUnsupportedError,
    );
  });

  test('ownership callbacks outside restoring phase fail closed', () {
    const idle = PlayRestoreStateT0276.idle();
    final snapshot = verifiedOwnership();

    expect(
      () => machine.handleOwnershipSnapshot(idle, snapshot),
      throwsStateError,
    );
    expect(() => machine.markQueryFailed(idle), throwsStateError);
  });

  test('restore keeps existing PRO stable until explicit revoke flow', () {
    final candidate = machine.handleOwnershipSnapshot(
      restoring(entitlement: const EntitlementState.cachedPro()),
      verifiedOwnership(),
    );

    expect(candidate.entitlement.isPro, isTrue);

    final restored = machine.markVerifiedRestore(
      candidate,
      productId: productId,
      verificationEvidenceFingerprint: evidence,
    );

    expect(restored.entitlement.isPro, isTrue);
    expect(
      restored.entitlement.verification,
      EntitlementVerification.verifiedOnline,
    );
  });
}
