/// Brand-safety contract applied before the advertisement SDK is initialized.
///
/// The application intentionally uses the strictest V1 profile. Vendor-specific
/// adapters must translate this contract to their SDK/runtime settings and to
/// the corresponding account-console blocking controls.
enum AdContentRatingT0272 {
  general,
  parentalGuidance,
  teen,
  matureAudience,
}

enum BlockedAdCategoryT0272 {
  alcohol,
  gambling,
  adultContent,
  dating,
  inappropriateContent,
}

final class AdSafetyProfileT0272 {
  const AdSafetyProfileT0272({
    required this.maxContentRating,
    required this.blockedCategories,
  });

  static const Set<BlockedAdCategoryT0272> mandatoryBlockedCategories =
      <BlockedAdCategoryT0272>{
    BlockedAdCategoryT0272.alcohol,
    BlockedAdCategoryT0272.gambling,
    BlockedAdCategoryT0272.adultContent,
    BlockedAdCategoryT0272.dating,
    BlockedAdCategoryT0272.inappropriateContent,
  };

  static const AdSafetyProfileT0272 strictV1 = AdSafetyProfileT0272(
    maxContentRating: AdContentRatingT0272.general,
    blockedCategories: mandatoryBlockedCategories,
  );

  final AdContentRatingT0272 maxContentRating;
  final Set<BlockedAdCategoryT0272> blockedCategories;

  bool get isStrictV1 {
    return maxContentRating == AdContentRatingT0272.general &&
        blockedCategories.length == mandatoryBlockedCategories.length &&
        blockedCategories.containsAll(mandatoryBlockedCategories);
  }

  void requireStrictV1() {
    if (!isStrictV1) {
      throw StateError(
        'Ad safety configuration blocked: V1 requires G-rated ads and all mandatory sensitive-category blocks.',
      );
    }
  }
}

/// Evidence returned by a concrete ad SDK adapter after applying the safety
/// profile.
///
/// Sensitive category exclusions are commonly controlled in the ad-network
/// account/console rather than purely by a mobile SDK. The adapter therefore
/// must not report the configuration as ready until both the runtime maximum
/// content rating and the account-side category exclusions have been verified.
final class AdSafetyConfigurationEvidenceT0272 {
  const AdSafetyConfigurationEvidenceT0272({
    required this.runtimeMaxContentRatingApplied,
    required this.accountCategoryBlocksVerified,
  });

  final bool runtimeMaxContentRatingApplied;
  final bool accountCategoryBlocksVerified;

  bool get isComplete =>
      runtimeMaxContentRatingApplied && accountCategoryBlocksVerified;

  void requireComplete() {
    if (!isComplete) {
      throw StateError(
        'Ad SDK initialization blocked: strict ad-safety evidence is incomplete.',
      );
    }
  }
}
