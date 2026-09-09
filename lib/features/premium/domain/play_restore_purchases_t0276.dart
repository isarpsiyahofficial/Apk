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
    this.verificationEvidenceFingerprint,
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

  /// Non-secret fingerprint binding the ownership callback to its later
  /// verification result. Raw Play purchase tokens/receipts are deliberately
  /// excluded from this state object.
  final String? verificationEvidenceFingerprint;

  bool get isRestoring => phase == PlayRestorePhaseT0276.restoring;
  bool get isRestored => phase == PlayRestorePhaseT0276.restored;
  bool get grantsPro => isRestored && entitlement.isPro;
}

/// Ownership snapshot returned by the Google Play restore/query boundary.
///
/// Product IDs remain separate from entitlement. Canonical ownership also has
/// to carry a non-secret fingerprint derived from the exact Play verification
/// material. Discovery alone never grants PRO.
final class PlayRestoreOwnershipSnapshotT0276 {
  PlayRestoreOwnershipSnapshotT0276({
    required Iterable<String> ownedProductIds,
    Map<String, String> verificationEvidenceFingerprintsByProductId = const {},
  })  : ownedProductIds = Set<String>.unmodifiable(ownedProductIds),
        verificationEvidenceFingerprintsByProductId = Map<String, String>.unmodifiable(
          verificationEvidenceFingerprintsByProductId.map((productId, evidence) {
            final normalizedEvidence = evidence.trim();
            if (normalizedEvidence.isEmpty) {
              throw StateError('Restore verification evidence must not be blank.');
            }
            return MapEntry(productId, normalizedEvidence);
          }),
        ) {
    for (final productId in verificationEvidenceFingerprintsByProductId.keys) {
      if (!this.ownedProductIds.contains(productId)) {
        throw StateError(
          'Restore verification evidence cannot reference an unowned product.',
        );
      }
    }
  }

  final Set<String> ownedProductIds;
  final Map<String, String> verificationEvidenceFingerprintsByProductId;

  bool get containsLifetimePro => ownedProductIds.contains(
        PlayBillingProductCatalogT0274.lifetimeProProductId,
      );

  String? get lifetimeProVerificationEvidenceFingerprint =>
      verificationEvidenceFingerprintsByProductId[
        PlayBillingProductCatalogT0274.lifetimeProProductId
      ];
}

/// Fail-closed restore lifecycle for the V1 Google Play Lifetime PRO product.
///
/// Restore is deliberately two-step: Google Play ownership discovery followed
/// by explicit purchase verification. Neither an unrelated product, a query
/// callback alone, nor verification evidence from another purchase may create
/// PRO entitlement.
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

    final evidence = snapshot.lifetimeProVerificationEvidenceFingerprint;
    if (evidence == null || evidence.isEmpty) {
      return PlayRestoreStateT0276._(
        phase: PlayRestorePhaseT0276.verificationFailed,
        entitlement: current.entitlement,
        productId: PlayBillingProductCatalogT0274.lifetimeProProductId,
      );
    }

    return PlayRestoreStateT0276._(
      phase: PlayRestorePhaseT0276.awaitingVerification,
      entitlement: current.entitlement,
      productId: PlayBillingProductCatalogT0274.lifetimeProProductId,
      verificationEvidenceFingerprint: evidence,
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
    required String verificationEvidenceFingerprint,
  }) {
    PlayBillingProductCatalogT0274.requireKnownProduct(productId);
    final evidence = verificationEvidenceFingerprint.trim();
    _requireMatchingVerificationCandidate(current, productId, evidence);

    return PlayRestoreStateT0276._(
      phase: PlayRestorePhaseT0276.restored,
      entitlement: entitlementStateMachine.transition(
        current.entitlement,
        EntitlementEvent.restoredPurchase,
      ),
      productId: productId,
      verificationEvidenceFingerprint: evidence,
    );
  }

  PlayRestoreStateT0276 markVerificationFailed(
    PlayRestoreStateT0276 current, {
    required String productId,
    required String verificationEvidenceFingerprint,
  }) {
    PlayBillingProductCatalogT0274.requireKnownProduct(productId);
    final evidence = verificationEvidenceFingerprint.trim();
    _requireMatchingVerificationCandidate(current, productId, evidence);

    return PlayRestoreStateT0276._(
      phase: PlayRestorePhaseT0276.verificationFailed,
      entitlement: current.entitlement,
      productId: productId,
      verificationEvidenceFingerprint: evidence,
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
    String verificationEvidenceFingerprint,
  ) {
    if (verificationEvidenceFingerprint.isEmpty ||
        current.phase != PlayRestorePhaseT0276.awaitingVerification ||
        current.productId != productId ||
        current.verificationEvidenceFingerprint != verificationEvidenceFingerprint) {
      throw StateError(
        'Restore verification must match the canonical product and exact ownership evidence.',
      );
    }
  }
}
