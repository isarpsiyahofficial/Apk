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
    this.verificationEvidenceFingerprint,
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

  /// Non-secret fingerprint that binds the Play purchase callback to the
  /// verification result. Raw purchase tokens/receipts must not be persisted in
  /// this state object.
  final String? verificationEvidenceFingerprint;

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
    this.verificationEvidenceFingerprint,
  });

  final PlayPurchaseUpdateKindT0275 kind;
  final String productId;

  /// Required only for PURCHASED. This is a fingerprint derived by the billing
  /// boundary from Play verification material; it is not the raw token itself.
  final String? verificationEvidenceFingerprint;
}

/// Fail-closed Google Play purchase lifecycle for the V1 Lifetime PRO product.
///
/// A Play `PURCHASED` callback is intentionally represented as
/// [PlayPurchasePhaseT0275.awaitingVerification]. Entitlement is granted only
/// after the same canonical product and the same purchase-evidence fingerprint
/// are explicitly confirmed by [markVerifiedPurchase]. `PENDING` and
/// cancellation never grant PRO.
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

    final evidence = update.verificationEvidenceFingerprint?.trim();
    switch (update.kind) {
      case PlayPurchaseUpdateKindT0275.pending:
      case PlayPurchaseUpdateKindT0275.cancelled:
        if (evidence != null && evidence.isNotEmpty) {
          throw StateError(
            'Pending/cancelled purchases must not carry verification evidence.',
          );
        }
      case PlayPurchaseUpdateKindT0275.purchased:
        if (evidence == null || evidence.isEmpty) {
          throw StateError(
            'PURCHASED requires verification evidence before it can await verification.',
          );
        }
    }

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
          verificationEvidenceFingerprint: evidence,
        ),
    };
  }

  PlayPurchaseStateT0275 markVerifiedPurchase(
    PlayPurchaseStateT0275 current, {
    required String productId,
    required String verificationEvidenceFingerprint,
  }) {
    PlayBillingProductCatalogT0274.requireKnownProduct(productId);
    final evidence = verificationEvidenceFingerprint.trim();

    if (evidence.isEmpty ||
        current.phase != PlayPurchasePhaseT0275.awaitingVerification ||
        current.productId != productId ||
        current.verificationEvidenceFingerprint != evidence) {
      throw StateError(
        'Purchase verification must match the canonical product and exact purchase evidence.',
      );
    }

    return PlayPurchaseStateT0275._(
      phase: PlayPurchasePhaseT0275.succeeded,
      entitlement: entitlementStateMachine.transition(
        current.entitlement,
        EntitlementEvent.verifiedPurchase,
      ),
      productId: productId,
      verificationEvidenceFingerprint: evidence,
    );
  }

  PlayPurchaseStateT0275 markVerificationFailed(
    PlayPurchaseStateT0275 current, {
    required String productId,
    required String verificationEvidenceFingerprint,
  }) {
    PlayBillingProductCatalogT0274.requireKnownProduct(productId);
    final evidence = verificationEvidenceFingerprint.trim();

    if (evidence.isEmpty ||
        current.phase != PlayPurchasePhaseT0275.awaitingVerification ||
        current.productId != productId ||
        current.verificationEvidenceFingerprint != evidence) {
      throw StateError('No matching purchase evidence is awaiting verification.');
    }

    return PlayPurchaseStateT0275._(
      phase: PlayPurchasePhaseT0275.verificationFailed,
      entitlement: current.entitlement,
      productId: productId,
      verificationEvidenceFingerprint: evidence,
    );
  }
}
