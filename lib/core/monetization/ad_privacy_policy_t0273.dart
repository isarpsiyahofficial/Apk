/// Advertisement privacy boundary for T0273.
///
/// Religious behaviour and other sensitive in-app activity must never become
/// advertisement targeting input. The production request path is therefore
/// constrained to a contextual/non-personalized profile that contains no user
/// query, verse, dua, dhikr, history, note, topic, or inferred-interest fields.
enum AdServingModeT0273 {
  contextualNonPersonalized,
  personalized,
}

/// Coarse placement context that is safe to expose to an ad adapter.
///
/// Values deliberately describe only the product surface. They never encode
/// the religious content currently being viewed or searched.
enum AdContextSurfaceT0273 {
  homeGeneral,
  shareVisualUnlock,
}

final class AdPrivacyProfileT0273 {
  const AdPrivacyProfileT0273({
    required this.servingMode,
    required this.publisherFirstPartyIdEnabled,
    required this.userTargetingKeywordsEnabled,
    required this.historicalInterestTargetingEnabled,
    required this.religiousInterestSignalsEnabled,
  });

  static const strictV1 = AdPrivacyProfileT0273(
    servingMode: AdServingModeT0273.contextualNonPersonalized,
    publisherFirstPartyIdEnabled: false,
    userTargetingKeywordsEnabled: false,
    historicalInterestTargetingEnabled: false,
    religiousInterestSignalsEnabled: false,
  );

  final AdServingModeT0273 servingMode;
  final bool publisherFirstPartyIdEnabled;
  final bool userTargetingKeywordsEnabled;
  final bool historicalInterestTargetingEnabled;
  final bool religiousInterestSignalsEnabled;

  bool get isStrictV1 =>
      servingMode == AdServingModeT0273.contextualNonPersonalized &&
      !publisherFirstPartyIdEnabled &&
      !userTargetingKeywordsEnabled &&
      !historicalInterestTargetingEnabled &&
      !religiousInterestSignalsEnabled;

  void requireStrictV1() {
    if (!isStrictV1) {
      throw StateError(
        'Ad privacy profile rejected: V1 requires contextual/non-personalized '
        'serving with religious, historical and user-derived targeting disabled.',
      );
    }
  }
}

/// The only request descriptor product code is allowed to hand to an ad SDK.
///
/// It has no field capable of carrying raw query text, notes, verse/dua/dhikr
/// identifiers, search history, or inferred religious interests. This is an
/// intentional data-minimization boundary rather than a convention.
final class PrivacySafeAdRequestT0273 {
  const PrivacySafeAdRequestT0273._({
    required this.surface,
    required this.profile,
  });

  factory PrivacySafeAdRequestT0273.strictV1({
    required AdContextSurfaceT0273 surface,
  }) {
    const profile = AdPrivacyProfileT0273.strictV1;
    profile.requireStrictV1();
    return PrivacySafeAdRequestT0273._(surface: surface, profile: profile);
  }

  final AdContextSurfaceT0273 surface;
  final AdPrivacyProfileT0273 profile;

  /// Converts the product-owned descriptor into the only SDK-facing payload
  /// shape permitted by V1.
  ///
  /// The payload is deliberately closed: there is no keyword, custom targeting,
  /// content identifier, publisher-provided user ID, history, note, query or
  /// religious-interest slot. Concrete SDK adapters must translate only these
  /// fixed values to their platform-specific non-personalized/contextual flags.
  AdSdkRequestPayloadT0273 toSdkPayload() {
    profile.requireStrictV1();
    return AdSdkRequestPayloadT0273._(
      surface: surface,
      nonPersonalizedAds: true,
      contextualOnly: true,
      publisherFirstPartyIdEnabled: false,
    );
  }
}

/// Closed SDK-facing payload for advertisement requests.
///
/// Do not add arbitrary maps, keywords or custom-targeting fields here. Any new
/// field requires a privacy review because this type is the final application
/// boundary before a concrete advertisement SDK adapter.
final class AdSdkRequestPayloadT0273 {
  const AdSdkRequestPayloadT0273._({
    required this.surface,
    required this.nonPersonalizedAds,
    required this.contextualOnly,
    required this.publisherFirstPartyIdEnabled,
  });

  final AdContextSurfaceT0273 surface;
  final bool nonPersonalizedAds;
  final bool contextualOnly;
  final bool publisherFirstPartyIdEnabled;

  bool get isStrictV1 =>
      nonPersonalizedAds &&
      contextualOnly &&
      !publisherFirstPartyIdEnabled;

  void requireStrictV1() {
    if (!isStrictV1) {
      throw StateError(
        'Ad SDK payload rejected: V1 allows only contextual, non-personalized '
        'requests without a publisher-provided user identifier.',
      );
    }
  }
}
