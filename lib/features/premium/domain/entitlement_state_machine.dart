enum EntitlementTier { free, pro }

enum EntitlementVerification {
  initial,
  cached,
  verifiedOnline,
}

final class EntitlementState {
  const EntitlementState._({
    required this.tier,
    required this.verification,
  });

  const EntitlementState.free()
      : this._(
          tier: EntitlementTier.free,
          verification: EntitlementVerification.initial,
        );

  const EntitlementState.cachedPro()
      : this._(
          tier: EntitlementTier.pro,
          verification: EntitlementVerification.cached,
        );

  const EntitlementState.verifiedPro()
      : this._(
          tier: EntitlementTier.pro,
          verification: EntitlementVerification.verifiedOnline,
        );

  final EntitlementTier tier;
  final EntitlementVerification verification;

  bool get isPro => tier == EntitlementTier.pro;
  bool get isFree => tier == EntitlementTier.free;

  bool get allowsOfflineCore => isPro;
  bool get requiresInternetForCore => isFree;
  bool get allowsAdSdk => isFree;
  bool get allowsBanner => isFree;
  bool get allowsInterstitial => isFree;
  bool get allowsRewardedOffer => isFree;
}

enum EntitlementEvent {
  verifiedPurchase,
  restoredPurchase,
  verifiedRevokedOrRefunded,
  verifiedNoOwnership,
}

final class EntitlementStateMachine {
  const EntitlementStateMachine();

  EntitlementState transition(
    EntitlementState current,
    EntitlementEvent event,
  ) {
    return switch (event) {
      EntitlementEvent.verifiedPurchase ||
      EntitlementEvent.restoredPurchase => const EntitlementState.verifiedPro(),
      EntitlementEvent.verifiedRevokedOrRefunded ||
      EntitlementEvent.verifiedNoOwnership => const EntitlementState.free(),
    };
  }

  EntitlementState restoreCached({required bool hasVerifiedProCache}) {
    return hasVerifiedProCache
        ? const EntitlementState.cachedPro()
        : const EntitlementState.free();
  }
}
