import 'package:flutter_test/flutter_test.dart';
import 'package:islami_hayat/features/premium/domain/entitlement_state_machine.dart';
import 'package:islami_hayat/features/premium/domain/play_billing_product_catalog_t0274.dart';
import 'package:islami_hayat/features/premium/domain/play_restore_purchases_t0276.dart';

void main() {
  const machine = PlayRestorePurchasesStateMachineT0276();
  const productId = PlayBillingProductCatalogT0274.lifetimeProProductId;

  PlayRestoreStateT0276 restoring({
    EntitlementState entitlement = const EntitlementState.free(),
  }) {
    return machine.begin(PlayRestoreStateT0276.idle(entitlement: entitlement));
  }

  test('restore begins without granting PRO', () {
    final state = restoring();

    expect(state.phase, PlayRestorePhaseT0276.restoring);
    expect(state.entitlement.isFree, isTrue);
    expect(state.grantsPro, isFalse);
  });

  test('canonical ownership waits for verification before granting PRO', () {
    final candidate = machine.handleOwnershipSnapshot(
      restoring(),
      PlayRestoreOwnershipSnapshotT0276(ownedProductIds: const [productId]),
    );

    expect(candidate.phase, PlayRestorePhaseT0276.awaitingVerification);
    expect(candidate.productId, productId);
    expect(candidate.entitlement.isFree, isTrue);
    expect(candidate.grantsPro, isFalse);
  });

  test('verified canonical restore transitions entitlement to online PRO', () {
    final candidate = machine.handleOwnershipSnapshot(
      restoring(),
      PlayRestoreOwnershipSnapshotT0276(ownedProductIds: const [productId]),
    );

    final restored = machine.markVerifiedRestore(
      candidate,
      productId: productId,
    );

    expect(restored.phase, PlayRestorePhaseT0276.restored);
    expect(restored.entitlement.isPro, isTrue);
    expect(
      restored.entitlement.verification,
      EntitlementVerification.verifiedOnline,
    );
    expect(restored.grantsPro, isTrue);
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
      PlayRestoreOwnershipSnapshotT0276(ownedProductIds: const [productId]),
    );

    final failed = machine.markVerificationFailed(
      candidate,
      productId: productId,
    );

    expect(failed.phase, PlayRestorePhaseT0276.verificationFailed);
    expect(failed.entitlement.isFree, isTrue);
    expect(failed.grantsPro, isFalse);
  });

  test('verification cannot bypass ownership discovery', () {
    final state = restoring();

    expect(
      () => machine.markVerifiedRestore(state, productId: productId),
      throwsStateError,
    );
  });

  test('unknown product cannot complete restore verification', () {
    final candidate = machine.handleOwnershipSnapshot(
      restoring(),
      PlayRestoreOwnershipSnapshotT0276(ownedProductIds: const [productId]),
    );

    expect(
      () => machine.markVerifiedRestore(
        candidate,
        productId: 'unknown_lifetime_product',
      ),
      throwsStateError,
    );
  });

  test('ownership callbacks outside restoring phase fail closed', () {
    const idle = PlayRestoreStateT0276.idle();
    final snapshot = PlayRestoreOwnershipSnapshotT0276(
      ownedProductIds: const [productId],
    );

    expect(
      () => machine.handleOwnershipSnapshot(idle, snapshot),
      throwsStateError,
    );
    expect(() => machine.markQueryFailed(idle), throwsStateError);
  });

  test('restore keeps existing PRO stable until explicit revoke flow', () {
    final candidate = machine.handleOwnershipSnapshot(
      restoring(entitlement: const EntitlementState.cachedPro()),
      PlayRestoreOwnershipSnapshotT0276(ownedProductIds: const [productId]),
    );

    expect(candidate.entitlement.isPro, isTrue);

    final restored = machine.markVerifiedRestore(
      candidate,
      productId: productId,
    );

    expect(restored.entitlement.isPro, isTrue);
    expect(
      restored.entitlement.verification,
      EntitlementVerification.verifiedOnline,
    );
  });
}
