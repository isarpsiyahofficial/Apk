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
/// A pair of booleans is deliberately not enough here: the adapter must report
/// the exact runtime rating it applied and the exact category set verified in
/// the ad-network account. This prevents a PG/T/MA rating or an incomplete
/// category block list from being accidentally accepted as "configured".
///
/// Sensitive category exclusions are commonly controlled in the ad-network
/// account/console rather than purely by a mobile SDK. The adapter therefore
/// must not report the configuration as ready until the account-side controls
/// have also been verified.
final class AdSafetyConfigurationEvidenceT0272 {
  const AdSafetyConfigurationEvidenceT0272({
    required this.runtimeAppliedMaxContentRating,
    required this.verifiedBlockedCategories,
    required this.accountCategoryBlocksVerified,
  });

  final AdContentRatingT0272 runtimeAppliedMaxContentRating;
  final Set<BlockedAdCategoryT0272> verifiedBlockedCategories;
  final bool accountCategoryBlocksVerified;

  bool get isComplete {
    const requiredProfile = AdSafetyProfileT0272.strictV1;
    return accountCategoryBlocksVerified &&
        runtimeAppliedMaxContentRating == requiredProfile.maxContentRating &&
        verifiedBlockedCategories.length ==
            requiredProfile.blockedCategories.length &&
        verifiedBlockedCategories.containsAll(requiredProfile.blockedCategories);
  }

  void requireComplete() {
    if (!isComplete) {
      throw StateError(
        'Ad SDK initialization blocked: exact G-rating and mandatory category-block evidence is incomplete or mismatched.',
      );
    }
  }
}
