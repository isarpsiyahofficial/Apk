import 'entitlement_state_machine.dart';
import 'secure_entitlement_cache_t0277.dart';

enum PlayOwnershipEvidenceT0278 {
  verifiedOwned,
  verifiedRevokedOrRefunded,
  verifiedNoOwnership,
}

/// Authoritative online ownership result for the canonical Lifetime PRO SKU.
///
/// The gateway producing this value is responsible for querying Google Play and
/// verifying the returned purchase evidence. Transient query/verification
/// failures are represented by exceptions instead of being converted into a
/// false no-ownership result.
final class PlayOwnershipSnapshotT0278 {
  const PlayOwnershipSnapshotT0278(this.evidence);

  final PlayOwnershipEvidenceT0278 evidence;
}

abstract interface class PlayOwnershipRefreshGatewayT0278 {
  Future<PlayOwnershipSnapshotT0278> queryVerifiedLifetimeProOwnership();
}

enum PlayOwnershipRefreshOutcomeT0278 {
  skippedOffline,
  verifiedOwned,
  revokedOrRefunded,
  noOwnership,
  transientFailure,
}

final class PlayOwnershipRefreshResultT0278 {
  const PlayOwnershipRefreshResultT0278({
    required this.outcome,
    required this.entitlement,
  });

  final PlayOwnershipRefreshOutcomeT0278 outcome;
  final EntitlementState entitlement;
}

/// Online refresh boundary for Google Play Lifetime PRO ownership.
///
/// A downgrade is allowed only after authoritative verified evidence. Network,
/// Play query, or verification failures never masquerade as revocation and do
/// not erase a previously verified cache. Verified revoke/refund or verified
/// no-ownership immediately drops the in-memory entitlement to FREE and clears
/// the Keystore-backed cache so a later offline restart cannot resurrect stale
/// PRO state.
final class PlayOwnershipRefreshServiceT0278 {
  const PlayOwnershipRefreshServiceT0278({
    required this.gateway,
    required this.cache,
    this.entitlementStateMachine = const EntitlementStateMachine(),
  });

  final PlayOwnershipRefreshGatewayT0278 gateway;
  final SecureEntitlementCacheT0277 cache;
  final EntitlementStateMachine entitlementStateMachine;

  Future<PlayOwnershipRefreshResultT0278> refresh({
    required EntitlementState current,
    required bool hasVerifiedInternetReachability,
  }) async {
    if (!hasVerifiedInternetReachability) {
      return PlayOwnershipRefreshResultT0278(
        outcome: PlayOwnershipRefreshOutcomeT0278.skippedOffline,
        entitlement: current,
      );
    }

    final PlayOwnershipSnapshotT0278 snapshot;
    try {
      snapshot = await gateway.queryVerifiedLifetimeProOwnership();
    } on Object {
      return PlayOwnershipRefreshResultT0278(
        outcome: PlayOwnershipRefreshOutcomeT0278.transientFailure,
        entitlement: current,
      );
    }

    return switch (snapshot.evidence) {
      PlayOwnershipEvidenceT0278.verifiedOwned => _handleOwned(current),
      PlayOwnershipEvidenceT0278.verifiedRevokedOrRefunded =>
        _handleRevokedOrRefunded(current),
      PlayOwnershipEvidenceT0278.verifiedNoOwnership =>
        _handleNoOwnership(current),
    };
  }

  Future<PlayOwnershipRefreshResultT0278> _handleOwned(
    EntitlementState current,
  ) async {
    final entitlement = entitlementStateMachine.transition(
      current,
      EntitlementEvent.restoredPurchase,
    );
    await cache.persistVerifiedPro(entitlement);
    return PlayOwnershipRefreshResultT0278(
      outcome: PlayOwnershipRefreshOutcomeT0278.verifiedOwned,
      entitlement: entitlement,
    );
  }

  Future<PlayOwnershipRefreshResultT0278> _handleRevokedOrRefunded(
    EntitlementState current,
  ) async {
    final entitlement = entitlementStateMachine.transition(
      current,
      EntitlementEvent.verifiedRevokedOrRefunded,
    );
    await cache.clear();
    return PlayOwnershipRefreshResultT0278(
      outcome: PlayOwnershipRefreshOutcomeT0278.revokedOrRefunded,
      entitlement: entitlement,
    );
  }

  Future<PlayOwnershipRefreshResultT0278> _handleNoOwnership(
    EntitlementState current,
  ) async {
    final entitlement = entitlementStateMachine.transition(
      current,
      EntitlementEvent.verifiedNoOwnership,
    );
    await cache.clear();
    return PlayOwnershipRefreshResultT0278(
      outcome: PlayOwnershipRefreshOutcomeT0278.noOwnership,
      entitlement: entitlement,
    );
  }
}
