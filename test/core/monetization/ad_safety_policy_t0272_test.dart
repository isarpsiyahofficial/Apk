import 'package:flutter_test/flutter_test.dart';
import 'package:islami_hayat/core/monetization/ad_safety_policy_t0272.dart';
import 'package:islami_hayat/core/monetization/entitlement_gated_ad_sdk.dart';
import 'package:islami_hayat/features/premium/domain/entitlement_state_machine.dart';

final class _SafetyAwareSdk implements AdSdkAdapter {
  _SafetyAwareSdk({
    this.runtimeRatingApplied = true,
    this.categoryBlocksVerified = true,
  });

  final bool runtimeRatingApplied;
  final bool categoryBlocksVerified;
  AdSafetyProfileT0272? receivedProfile;
  int initializeCalls = 0;

  @override
  Future<AdSafetyConfigurationEvidenceT0272> initialize({
    required AdSafetyProfileT0272 safetyProfile,
  }) async {
    initializeCalls += 1;
    receivedProfile = safetyProfile;
    return AdSafetyConfigurationEvidenceT0272(
      runtimeMaxContentRatingApplied: runtimeRatingApplied,
      accountCategoryBlocksVerified: categoryBlocksVerified,
    );
  }
}

void main() {
  group('T0272 strict advertisement safety configuration', () {
    test('V1 profile blocks every mandatory sensitive category', () {
      const profile = AdSafetyProfileT0272.strictV1;

      expect(profile.maxContentRating, AdContentRatingT0272.general);
      expect(
        profile.blockedCategories,
        AdSafetyProfileT0272.mandatoryBlockedCategories,
      );
      expect(profile.blockedCategories, contains(BlockedAdCategoryT0272.alcohol));
      expect(profile.blockedCategories, contains(BlockedAdCategoryT0272.gambling));
      expect(profile.blockedCategories, contains(BlockedAdCategoryT0272.adultContent));
      expect(profile.blockedCategories, contains(BlockedAdCategoryT0272.dating));
      expect(
        profile.blockedCategories,
        contains(BlockedAdCategoryT0272.inappropriateContent),
      );
      expect(profile.isStrictV1, isTrue);
      expect(profile.requireStrictV1, returnsNormally);
    });

    test('weaker content rating is rejected as non-compliant', () {
      const unsafe = AdSafetyProfileT0272(
        maxContentRating: AdContentRatingT0272.parentalGuidance,
        blockedCategories: AdSafetyProfileT0272.mandatoryBlockedCategories,
      );

      expect(unsafe.isStrictV1, isFalse);
      expect(unsafe.requireStrictV1, throwsStateError);
    });

    test('missing one category block is rejected as non-compliant', () {
      const incomplete = AdSafetyProfileT0272(
        maxContentRating: AdContentRatingT0272.general,
        blockedCategories: <BlockedAdCategoryT0272>{
          BlockedAdCategoryT0272.alcohol,
          BlockedAdCategoryT0272.gambling,
          BlockedAdCategoryT0272.adultContent,
          BlockedAdCategoryT0272.dating,
        },
      );

      expect(incomplete.isStrictV1, isFalse);
      expect(incomplete.requireStrictV1, throwsStateError);
    });

    test('FREE SDK receives strict profile before initialization opens requests', () async {
      final sdk = _SafetyAwareSdk();
      final coordinator = EntitlementGatedAdSdkCoordinator(sdk: sdk);

      await coordinator.evaluateAndInitialize(const EntitlementState.free());

      expect(sdk.initializeCalls, 1);
      expect(sdk.receivedProfile, same(AdSafetyProfileT0272.strictV1));
      expect(coordinator.canIssueAdRequest(const EntitlementState.free()), isTrue);
    });

    test('missing runtime max-rating evidence fails closed', () async {
      final sdk = _SafetyAwareSdk(runtimeRatingApplied: false);
      final coordinator = EntitlementGatedAdSdkCoordinator(sdk: sdk);

      await expectLater(
        coordinator.evaluateAndInitialize(const EntitlementState.free()),
        throwsStateError,
      );

      expect(coordinator.state, AdSdkBootstrapState.awaitingEntitlement);
      expect(coordinator.canIssueAdRequest(const EntitlementState.free()), isFalse);
    });

    test('missing account category-block evidence fails closed', () async {
      final sdk = _SafetyAwareSdk(categoryBlocksVerified: false);
      final coordinator = EntitlementGatedAdSdkCoordinator(sdk: sdk);

      await expectLater(
        coordinator.evaluateAndInitialize(const EntitlementState.free()),
        throwsStateError,
      );

      expect(coordinator.state, AdSdkBootstrapState.awaitingEntitlement);
      expect(coordinator.canIssueAdRequest(const EntitlementState.free()), isFalse);
    });

    test('PRO never initializes or configures the advertisement SDK', () async {
      final sdk = _SafetyAwareSdk();
      final coordinator = EntitlementGatedAdSdkCoordinator(sdk: sdk);

      await coordinator.evaluateAndInitialize(
        const EntitlementState.verifiedPro(),
      );

      expect(sdk.initializeCalls, 0);
      expect(sdk.receivedProfile, isNull);
      expect(coordinator.state, AdSdkBootstrapState.suppressedForPro);
    });
  });
}
