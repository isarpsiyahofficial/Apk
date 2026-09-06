import 'entitlement_state_machine.dart';
import 'play_billing_product_catalog_t0274.dart';

enum PlayPurchasePhaseT0275 {
  idle,
  pending,
  cancelled,
  awaitingVerification,
  succeeded,
  verificationFailed,
}

final class PlayPurchaseStateT0275 {
  const PlayPurchaseStateT0275._({
    required this.phase,
    required this.entitlement,
    this.productId,
  });

  const PlayPurchaseStateT0275.idle({
    EntitlementState entitlement = const EntitlementState.free(),
  }) : this._(
          phase: PlayPurchasePhaseT0275.idle,
          entitlement: entitlement,
        );

  final PlayPurchasePhaseT0275 phase;
  final EntitlementState entitlement;
  final String? productId;

  bool get isPending => phase == PlayPurchasePhaseT0275.pending;
  bool get isCancelled => phase == PlayPurchasePhaseT0275.cancelled;
  bool get isSuccessful => phase == PlayPurchasePhaseT0275.succeeded;
  bool get grantsPro => isSuccessful && entitlement.isPro;
}

enum PlayPurchaseUpdateKindT0275 {
  pending,
  cancelled,
  purchased,
}

final class PlayPurchaseUpdateT0275 {
  const PlayPurchaseUpdateT0275({
    required this.kind,
    required this.productId,
  });

  final PlayPurchaseUpdateKindT0275 kind;
  final String productId;
}

/// Fail-closed Google Play purchase lifecycle for the V1 Lifetime PRO product.
///
/// A Play `PURCHASED` callback is intentionally represented as
/// [PlayPurchasePhaseT0275.awaitingVerification]. Entitlement is granted only
/// after the same canonical product is explicitly confirmed by
/// [markVerifiedPurchase]. `PENDING` and cancellation never grant PRO.
final class PlayPurchaseStateMachineT0275 {
  const PlayPurchaseStateMachineT0275({
    this.entitlementStateMachine = const EntitlementStateMachine(),
  });

  final EntitlementStateMachine entitlementStateMachine;

  PlayPurchaseStateT0275 handlePlayUpdate(
    PlayPurchaseStateT0275 current,
    PlayPurchaseUpdateT0275 update,
  ) {
    PlayBillingProductCatalogT0274.requireKnownProduct(update.productId);

    return switch (update.kind) {
      PlayPurchaseUpdateKindT0275.pending => PlayPurchaseStateT0275._(
          phase: PlayPurchasePhaseT0275.pending,
          entitlement: current.entitlement,
          productId: update.productId,
        ),
      PlayPurchaseUpdateKindT0275.cancelled => PlayPurchaseStateT0275._(
          phase: PlayPurchasePhaseT0275.cancelled,
          entitlement: current.entitlement,
          productId: update.productId,
        ),
      PlayPurchaseUpdateKindT0275.purchased => PlayPurchaseStateT0275._(
          phase: PlayPurchasePhaseT0275.awaitingVerification,
          entitlement: current.entitlement,
          productId: update.productId,
        ),
    };
  }

  PlayPurchaseStateT0275 markVerifiedPurchase(
    PlayPurchaseStateT0275 current, {
    required String productId,
  }) {
    PlayBillingProductCatalogT0274.requireKnownProduct(productId);

    if (current.phase != PlayPurchasePhaseT0275.awaitingVerification ||
        current.productId != productId) {
      throw StateError(
        'Purchase must be PURCHASED and match the canonical product before verification.',
      );
    }

    return PlayPurchaseStateT0275._(
      phase: PlayPurchasePhaseT0275.succeeded,
      entitlement: entitlementStateMachine.transition(
        current.entitlement,
        EntitlementEvent.verifiedPurchase,
      ),
      productId: productId,
    );
  }

  PlayPurchaseStateT0275 markVerificationFailed(
    PlayPurchaseStateT0275 current, {
    required String productId,
  }) {
    PlayBillingProductCatalogT0274.requireKnownProduct(productId);

    if (current.phase != PlayPurchasePhaseT0275.awaitingVerification ||
        current.productId != productId) {
      throw StateError('No matching purchase is awaiting verification.');
    }

    return PlayPurchaseStateT0275._(
      phase: PlayPurchasePhaseT0275.verificationFailed,
      entitlement: current.entitlement,
      productId: productId,
    );
  }
}
