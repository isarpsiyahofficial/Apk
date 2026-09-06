import 'entitlement_state_machine.dart';
import 'play_billing_product_catalog_t0274.dart';

enum PlayRestorePhaseT0276 {
  idle,
  restoring,
  awaitingVerification,
  restored,
  nothingToRestore,
  queryFailed,
  verificationFailed,
}

final class PlayRestoreStateT0276 {
  const PlayRestoreStateT0276._({
    required this.phase,
    required this.entitlement,
    this.productId,
  });

  const PlayRestoreStateT0276.idle({
    EntitlementState entitlement = const EntitlementState.free(),
  }) : this._(
          phase: PlayRestorePhaseT0276.idle,
          entitlement: entitlement,
        );

  final PlayRestorePhaseT0276 phase;
  final EntitlementState entitlement;
  final String? productId;

  bool get isRestoring => phase == PlayRestorePhaseT0276.restoring;
  bool get isRestored => phase == PlayRestorePhaseT0276.restored;
  bool get grantsPro => isRestored && entitlement.isPro;
}

/// Ownership snapshot returned by the Google Play restore/query boundary.
///
/// Product IDs are intentionally kept separate from entitlement. Discovering
/// the canonical product only creates a verification candidate; it never grants
/// PRO by itself.
final class PlayRestoreOwnershipSnapshotT0276 {
  PlayRestoreOwnershipSnapshotT0276({required Iterable<String> ownedProductIds})
      : ownedProductIds = Set<String>.unmodifiable(ownedProductIds);

  final Set<String> ownedProductIds;

  bool get containsLifetimePro => ownedProductIds.contains(
        PlayBillingProductCatalogT0274.lifetimeProProductId,
      );
}

/// Fail-closed restore lifecycle for the V1 Google Play Lifetime PRO product.
///
/// Restore is deliberately two-step: Google Play ownership discovery followed
/// by explicit purchase verification. Neither an unrelated product nor a query
/// callback alone may create PRO entitlement.
final class PlayRestorePurchasesStateMachineT0276 {
  const PlayRestorePurchasesStateMachineT0276({
    this.entitlementStateMachine = const EntitlementStateMachine(),
  });

  final EntitlementStateMachine entitlementStateMachine;

  PlayRestoreStateT0276 begin(PlayRestoreStateT0276 current) {
    return PlayRestoreStateT0276._(
      phase: PlayRestorePhaseT0276.restoring,
      entitlement: current.entitlement,
    );
  }

  PlayRestoreStateT0276 handleOwnershipSnapshot(
    PlayRestoreStateT0276 current,
    PlayRestoreOwnershipSnapshotT0276 snapshot,
  ) {
    _requireRestoring(current);

    if (!snapshot.containsLifetimePro) {
      return PlayRestoreStateT0276._(
        phase: PlayRestorePhaseT0276.nothingToRestore,
        entitlement: current.entitlement,
      );
    }

    return PlayRestoreStateT0276._(
      phase: PlayRestorePhaseT0276.awaitingVerification,
      entitlement: current.entitlement,
      productId: PlayBillingProductCatalogT0274.lifetimeProProductId,
    );
  }

  PlayRestoreStateT0276 markQueryFailed(PlayRestoreStateT0276 current) {
    _requireRestoring(current);

    return PlayRestoreStateT0276._(
      phase: PlayRestorePhaseT0276.queryFailed,
      entitlement: current.entitlement,
    );
  }

  PlayRestoreStateT0276 markVerifiedRestore(
    PlayRestoreStateT0276 current, {
    required String productId,
  }) {
    PlayBillingProductCatalogT0274.requireKnownProduct(productId);
    _requireMatchingVerificationCandidate(current, productId);

    return PlayRestoreStateT0276._(
      phase: PlayRestorePhaseT0276.restored,
      entitlement: entitlementStateMachine.transition(
        current.entitlement,
        EntitlementEvent.restoredPurchase,
      ),
      productId: productId,
    );
  }

  PlayRestoreStateT0276 markVerificationFailed(
    PlayRestoreStateT0276 current, {
    required String productId,
  }) {
    PlayBillingProductCatalogT0274.requireKnownProduct(productId);
    _requireMatchingVerificationCandidate(current, productId);

    return PlayRestoreStateT0276._(
      phase: PlayRestorePhaseT0276.verificationFailed,
      entitlement: current.entitlement,
      productId: productId,
    );
  }

  void _requireRestoring(PlayRestoreStateT0276 current) {
    if (current.phase != PlayRestorePhaseT0276.restoring) {
      throw StateError('Restore ownership may only be handled while restoring.');
    }
  }

  void _requireMatchingVerificationCandidate(
    PlayRestoreStateT0276 current,
    String productId,
  ) {
    if (current.phase != PlayRestorePhaseT0276.awaitingVerification ||
        current.productId != productId) {
      throw StateError(
        'Restore must discover and match the canonical product before verification.',
      );
    }
  }
}
