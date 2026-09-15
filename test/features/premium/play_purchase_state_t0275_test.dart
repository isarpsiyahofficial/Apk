import 'package:flutter_test/flutter_test.dart';
import 'package:islami_hayat/features/premium/domain/entitlement_state_machine.dart';
import 'package:islami_hayat/features/premium/domain/play_billing_product_catalog_t0274.dart';
import 'package:islami_hayat/features/premium/domain/play_purchase_state_t0275.dart';

void main() {
  const machine = PlayPurchaseStateMachineT0275();
  const productId = PlayBillingProductCatalogT0274.lifetimeProProductId;
  const evidence = 'sha256:purchase-evidence-a';

  PlayPurchaseUpdateT0275 update(
    PlayPurchaseUpdateKindT0275 kind, {
    String? verificationEvidenceFingerprint,
  }) {
    return PlayPurchaseUpdateT0275(
      kind: kind,
      productId: productId,
      verificationEvidenceFingerprint: verificationEvidenceFingerprint,
    );
  }

  PlayPurchaseStateT0275 purchasedState() {
    return machine.handlePlayUpdate(
      const PlayPurchaseStateT0275.idle(),
      update(
        PlayPurchaseUpdateKindT0275.purchased,
        verificationEvidenceFingerprint: evidence,
      ),
    );
  }

  test('pending purchase never grants PRO', () {
    const initial = PlayPurchaseStateT0275.idle();

    final pending = machine.handlePlayUpdate(
      initial,
      update(PlayPurchaseUpdateKindT0275.pending),
    );

    expect(pending.phase, PlayPurchasePhaseT0275.pending);
    expect(pending.entitlement.isFree, isTrue);
    expect(pending.grantsPro, isFalse);
    expect(pending.verificationEvidenceFingerprint, isNull);
  });

  test('cancelled purchase never grants PRO', () {
    const initial = PlayPurchaseStateT0275.idle();
    final pending = machine.handlePlayUpdate(
      initial,
      update(PlayPurchaseUpdateKindT0275.pending),
    );

    final cancelled = machine.handlePlayUpdate(
      pending,
      update(PlayPurchaseUpdateKindT0275.cancelled),
    );

    expect(cancelled.phase, PlayPurchasePhaseT0275.cancelled);
    expect(cancelled.entitlement.isFree, isTrue);
    expect(cancelled.grantsPro, isFalse);
    expect(cancelled.verificationEvidenceFingerprint, isNull);
  });

  test('PURCHASED waits for exact verification evidence before granting PRO', () {
    final purchased = purchasedState();

    expect(purchased.phase, PlayPurchasePhaseT0275.awaitingVerification);
    expect(purchased.entitlement.isFree, isTrue);
    expect(purchased.grantsPro, isFalse);
    expect(purchased.verificationEvidenceFingerprint, evidence);
  });

  test('verified canonical purchase with exact evidence transitions to PRO', () {
    final purchased = purchasedState();

    final success = machine.markVerifiedPurchase(
      purchased,
      productId: productId,
      verificationEvidenceFingerprint: evidence,
    );

    expect(success.phase, PlayPurchasePhaseT0275.succeeded);
    expect(success.entitlement, isA<EntitlementState>());
    expect(success.entitlement.isPro, isTrue);
    expect(
      success.entitlement.verification,
      EntitlementVerification.verifiedOnline,
    );
    expect(success.grantsPro, isTrue);
    expect(success.verificationEvidenceFingerprint, evidence);
  });

  test('verification failure preserves existing FREE entitlement', () {
    final purchased = purchasedState();

    final failed = machine.markVerificationFailed(
      purchased,
      productId: productId,
      verificationEvidenceFingerprint: evidence,
    );

    expect(failed.phase, PlayPurchasePhaseT0275.verificationFailed);
    expect(failed.entitlement.isFree, isTrue);
    expect(failed.grantsPro, isFalse);
  });

  test('PURCHASED without evidence fails closed', () {
    const initial = PlayPurchaseStateT0275.idle();

    expect(
      () => machine.handlePlayUpdate(
        initial,
        update(PlayPurchaseUpdateKindT0275.purchased),
      ),
      throwsStateError,
    );
    expect(
      () => machine.handlePlayUpdate(
        initial,
        update(
          PlayPurchaseUpdateKindT0275.purchased,
          verificationEvidenceFingerprint: '   ',
        ),
      ),
      throwsStateError,
    );
  });

  test('pending and cancelled updates cannot smuggle verification evidence', () {
    const initial = PlayPurchaseStateT0275.idle();

    for (final kind in <PlayPurchaseUpdateKindT0275>[
      PlayPurchaseUpdateKindT0275.pending,
      PlayPurchaseUpdateKindT0275.cancelled,
    ]) {
      expect(
        () => machine.handlePlayUpdate(
          initial,
          update(kind, verificationEvidenceFingerprint: evidence),
        ),
        throwsStateError,
      );
    }
  });

  test('mismatched verification evidence cannot grant PRO', () {
    final purchased = purchasedState();

    expect(
      () => machine.markVerifiedPurchase(
        purchased,
        productId: productId,
        verificationEvidenceFingerprint: 'sha256:different-purchase',
      ),
      throwsStateError,
    );
    expect(purchased.entitlement.isFree, isTrue);
  });

  test('pending or cancelled state cannot be promoted by verification', () {
    const initial = PlayPurchaseStateT0275.idle();
    final pending = machine.handlePlayUpdate(
      initial,
      update(PlayPurchaseUpdateKindT0275.pending),
    );
    final cancelled = machine.handlePlayUpdate(
      pending,
      update(PlayPurchaseUpdateKindT0275.cancelled),
    );

    expect(
      () => machine.markVerifiedPurchase(
        pending,
        productId: productId,
        verificationEvidenceFingerprint: evidence,
      ),
      throwsStateError,
    );
    expect(
      () => machine.markVerifiedPurchase(
        cancelled,
        productId: productId,
        verificationEvidenceFingerprint: evidence,
      ),
      throwsStateError,
    );
  });

  test('unknown product IDs fail closed in every purchase state', () {
    const initial = PlayPurchaseStateT0275.idle();

    for (final kind in PlayPurchaseUpdateKindT0275.values) {
      expect(
        () => machine.handlePlayUpdate(
          initial,
          PlayPurchaseUpdateT0275(
            kind: kind,
            productId: 'unknown_lifetime_product',
            verificationEvidenceFingerprint:
                kind == PlayPurchaseUpdateKindT0275.purchased ? evidence : null,
          ),
        ),
        throwsStateError,
      );
    }
  });

  test('mismatched product cannot complete a purchased transaction', () {
    final purchased = purchasedState();

    expect(
      () => machine.markVerifiedPurchase(
        purchased,
        productId: 'unknown_lifetime_product',
        verificationEvidenceFingerprint: evidence,
      ),
      throwsStateError,
    );
  });

  test('existing verified PRO is never downgraded by cancel or pending', () {
    const initial = PlayPurchaseStateT0275.idle(
      entitlement: EntitlementState.verifiedPro(),
    );

    final pending = machine.handlePlayUpdate(
      initial,
      update(PlayPurchaseUpdateKindT0275.pending),
    );
    final cancelled = machine.handlePlayUpdate(
      pending,
      update(PlayPurchaseUpdateKindT0275.cancelled),
    );

    expect(pending.entitlement.isPro, isTrue);
    expect(cancelled.entitlement.isPro, isTrue);
  });
}
