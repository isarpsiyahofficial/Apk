import 'package:flutter_test/flutter_test.dart';
import 'package:islami_hayat/core/monetization/ad_placement_policy.dart';
import 'package:islami_hayat/core/monetization/ad_privacy_policy_t0273.dart';
import 'package:islami_hayat/core/monetization/ad_safety_policy_t0272.dart';
import 'package:islami_hayat/core/monetization/entitlement_gated_ad_sdk.dart';
import 'package:islami_hayat/features/premium/domain/entitlement_state_machine.dart';

final class _PrivacyTestSdk implements AdSdkAdapter {
  @override
  Future<AdSafetyConfigurationEvidenceT0272> initialize({
    required AdSafetyProfileT0272 safetyProfile,
  }) async {
    return const AdSafetyConfigurationEvidenceT0272(
      runtimeAppliedMaxContentRating: AdContentRatingT0272.general,
      verifiedBlockedCategories:
          AdSafetyProfileT0272.mandatoryBlockedCategories,
      accountCategoryBlocksVerified: true,
    );
  }
}

void main() {
  group('T0273 religious/sensitive ad privacy boundary', () {
    test('strict V1 is contextual/non-personalized with all targeting off', () {
      const profile = AdPrivacyProfileT0273.strictV1;

      expect(
        profile.servingMode,
        AdServingModeT0273.contextualNonPersonalized,
      );
      expect(profile.publisherFirstPartyIdEnabled, isFalse);
      expect(profile.userTargetingKeywordsEnabled, isFalse);
      expect(profile.historicalInterestTargetingEnabled, isFalse);
      expect(profile.religiousInterestSignalsEnabled, isFalse);
      expect(profile.isStrictV1, isTrue);
      expect(profile.requireStrictV1, returnsNormally);
    });

    test('personalized serving is rejected fail-closed', () {
      const unsafe = AdPrivacyProfileT0273(
        servingMode: AdServingModeT0273.personalized,
        publisherFirstPartyIdEnabled: false,
        userTargetingKeywordsEnabled: false,
        historicalInterestTargetingEnabled: false,
        religiousInterestSignalsEnabled: false,
      );

      expect(unsafe.isStrictV1, isFalse);
      expect(unsafe.requireStrictV1, throwsStateError);
    });

    test('religious-interest targeting is rejected fail-closed', () {
      const unsafe = AdPrivacyProfileT0273(
        servingMode: AdServingModeT0273.contextualNonPersonalized,
        publisherFirstPartyIdEnabled: false,
        userTargetingKeywordsEnabled: false,
        historicalInterestTargetingEnabled: false,
        religiousInterestSignalsEnabled: true,
      );

      expect(unsafe.isStrictV1, isFalse);
      expect(unsafe.requireStrictV1, throwsStateError);
    });

    test('user keywords or historical targeting are rejected', () {
      const keywordUnsafe = AdPrivacyProfileT0273(
        servingMode: AdServingModeT0273.contextualNonPersonalized,
        publisherFirstPartyIdEnabled: false,
        userTargetingKeywordsEnabled: true,
        historicalInterestTargetingEnabled: false,
        religiousInterestSignalsEnabled: false,
      );
      const historyUnsafe = AdPrivacyProfileT0273(
        servingMode: AdServingModeT0273.contextualNonPersonalized,
        publisherFirstPartyIdEnabled: false,
        userTargetingKeywordsEnabled: false,
        historicalInterestTargetingEnabled: true,
        religiousInterestSignalsEnabled: false,
      );

      expect(keywordUnsafe.requireStrictV1, throwsStateError);
      expect(historyUnsafe.requireStrictV1, throwsStateError);
    });

    test('FREE home request emits only a data-minimized strict descriptor', () async {
      final coordinator = EntitlementGatedAdSdkCoordinator(sdk: _PrivacyTestSdk());
      await coordinator.evaluateAndInitialize(const EntitlementState.free());

      final request = coordinator.buildPrivacySafeAdRequestFor(
        entitlement: const EntitlementState.free(),
        surface: AppAdSurface.todayHome,
        format: AdFormat.banner,
      );

      expect(request.surface, AdContextSurfaceT0273.homeGeneral);
      expect(request.profile, same(AdPrivacyProfileT0273.strictV1));
      expect(request.profile.isStrictV1, isTrue);
    });

    test('rewarded share unlock is contextual and carries no religious topic', () async {
      final coordinator = EntitlementGatedAdSdkCoordinator(sdk: _PrivacyTestSdk());
      await coordinator.evaluateAndInitialize(const EntitlementState.free());

      final request = coordinator.buildPrivacySafeAdRequestFor(
        entitlement: const EntitlementState.free(),
        surface: AppAdSurface.shareDesignUnlock,
        format: AdFormat.rewarded,
      );

      expect(request.surface, AdContextSurfaceT0273.shareVisualUnlock);
      expect(request.profile.religiousInterestSignalsEnabled, isFalse);
      expect(request.profile.userTargetingKeywordsEnabled, isFalse);
    });

    test('SDK payload is fixed to contextual non-personalized serving', () async {
      final coordinator = EntitlementGatedAdSdkCoordinator(sdk: _PrivacyTestSdk());
      await coordinator.evaluateAndInitialize(const EntitlementState.free());

      for (final entry in <(AppAdSurface, AdFormat)>[
        (AppAdSurface.todayHome, AdFormat.banner),
        (AppAdSurface.shareDesignUnlock, AdFormat.rewarded),
      ]) {
        final descriptor = coordinator.buildPrivacySafeAdRequestFor(
          entitlement: const EntitlementState.free(),
          surface: entry.$1,
          format: entry.$2,
        );
        final payload = descriptor.toSdkPayload();

        expect(payload.nonPersonalizedAds, isTrue);
        expect(payload.contextualOnly, isTrue);
        expect(payload.publisherFirstPartyIdEnabled, isFalse);
        expect(payload.isStrictV1, isTrue);
        expect(payload.requireStrictV1, returnsNormally);
      }
    });

    test('platform parameters are exact allow-list with no targeting channel', () {
      final parameters = PrivacySafeAdRequestT0273.strictV1(
        surface: AdContextSurfaceT0273.homeGeneral,
      ).toSdkPayload().toPlatformParameters();

      expect(
        parameters.keys.toSet(),
        equals(AdSdkRequestPayloadT0273.allowedPlatformParameterKeys),
      );
      expect(parameters['surface'], 'homeGeneral');
      expect(parameters['non_personalized_ads'], isTrue);
      expect(parameters['contextual_only'], isTrue);
      expect(parameters['publisher_first_party_id_enabled'], isFalse);
      expect(
        () => parameters['keyword'] = 'religious-topic',
        throwsUnsupportedError,
      );

      const forbiddenFragments = <String>[
        'keyword',
        'target',
        'query',
        'note',
        'history',
        'religious',
        'interest',
        'verse',
        'dua',
        'dhikr',
        'user_id',
        'custom',
      ];
      for (final key in parameters.keys) {
        for (final fragment in forbiddenFragments) {
          expect(
            key.toLowerCase().contains(fragment),
            isFalse,
            reason: 'SDK payload must not expose a $fragment targeting channel.',
          );
        }
      }
    });

    test('sacred surfaces cannot produce an ad request descriptor', () async {
      final coordinator = EntitlementGatedAdSdkCoordinator(sdk: _PrivacyTestSdk());
      await coordinator.evaluateAndInitialize(const EntitlementState.free());

      for (final surface in <AppAdSurface>[
        AppAdSurface.quranReader,
        AppAdSurface.quranSearch,
        AppAdSurface.dailyVerse,
        AppAdSurface.duaReader,
        AppAdSurface.dhikrActive,
      ]) {
        expect(
          () => coordinator.buildPrivacySafeAdRequestFor(
            entitlement: const EntitlementState.free(),
            surface: surface,
            format: AdFormat.banner,
          ),
          throwsStateError,
        );
      }
    });

    test('PRO cannot obtain privacy descriptor because ad path is zero', () async {
      final coordinator = EntitlementGatedAdSdkCoordinator(sdk: _PrivacyTestSdk());
      await coordinator.evaluateAndInitialize(
        const EntitlementState.verifiedPro(),
      );

      expect(
        () => coordinator.buildPrivacySafeAdRequestFor(
          entitlement: const EntitlementState.verifiedPro(),
          surface: AppAdSurface.todayHome,
          format: AdFormat.banner,
        ),
        throwsStateError,
      );
    });
  });
}
