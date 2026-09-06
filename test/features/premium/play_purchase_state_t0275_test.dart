import 'package:flutter_test/flutter_test.dart';
import 'package:islami_hayat/features/premium/domain/entitlement_state_machine.dart';
import 'package:islami_hayat/features/premium/domain/play_billing_product_catalog_t0274.dart';
import 'package:islami_hayat/features/premium/domain/play_purchase_state_t0275.dart';

void main() {
  const machine = PlayPurchaseStateMachineT0275();
  const productId = PlayBillingProductCatalogT0274.lifetimeProProductId;

  PlayPurchaseUpdateT0275 update(PlayPurchaseUpdateKindT0275 kind) {
    return PlayPurchaseUpdateT0275(kind: kind, productId: productId);
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
  });

  test('PURCHASED waits for verification before granting PRO', () {
    const initial = PlayPurchaseStateT0275.idle();

    final purchased = machine.handlePlayUpdate(
      initial,
      update(PlayPurchaseUpdateKindT0275.purchased),
    );

    expect(purchased.phase, PlayPurchasePhaseT0275.awaitingVerification);
    expect(purchased.entitlement.isFree, isTrue);
    expect(purchased.grantsPro, isFalse);
  });

  test('verified canonical purchase transitions entitlement to PRO', () {
    const initial = PlayPurchaseStateT0275.idle();
    final purchased = machine.handlePlayUpdate(
      initial,
      update(PlayPurchaseUpdateKindT0275.purchased),
    );

    final success = machine.markVerifiedPurchase(
      purchased,
      productId: productId,
    );

    expect(success.phase, PlayPurchasePhaseT0275.succeeded);
    expect(success.entitlement, isA<EntitlementState>());
    expect(success.entitlement.isPro, isTrue);
    expect(
      success.entitlement.verification,
      EntitlementVerification.verifiedOnline,
    );
    expect(success.grantsPro, isTrue);
  });

  test('verification failure preserves existing FREE entitlement', () {
    const initial = PlayPurchaseStateT0275.idle();
    final purchased = machine.handlePlayUpdate(
      initial,
      update(PlayPurchaseUpdateKindT0275.purchased),
    );

    final failed = machine.markVerificationFailed(
      purchased,
      productId: productId,
    );

    expect(failed.phase, PlayPurchasePhaseT0275.verificationFailed);
    expect(failed.entitlement.isFree, isTrue);
    expect(failed.grantsPro, isFalse);
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
      () => machine.markVerifiedPurchase(pending, productId: productId),
      throwsStateError,
    );
    expect(
      () => machine.markVerifiedPurchase(cancelled, productId: productId),
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
          ),
        ),
        throwsStateError,
      );
    }
  });

  test('mismatched product cannot complete a purchased transaction', () {
    const initial = PlayPurchaseStateT0275.idle();
    final purchased = machine.handlePlayUpdate(
      initial,
      update(PlayPurchaseUpdateKindT0275.purchased),
    );

    expect(
      () => machine.markVerifiedPurchase(
        purchased,
        productId: 'unknown_lifetime_product',
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
