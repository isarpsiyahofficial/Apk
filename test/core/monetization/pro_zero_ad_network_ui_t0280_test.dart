import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:islami_hayat/core/monetization/ad_network_dispatch_t0280.dart';
import 'package:islami_hayat/core/monetization/ad_placement_policy.dart';
import 'package:islami_hayat/core/monetization/ad_privacy_policy_t0273.dart';
import 'package:islami_hayat/core/monetization/ad_safety_policy_t0272.dart';
import 'package:islami_hayat/core/monetization/entitlement_gated_ad_sdk.dart';
import 'package:islami_hayat/core/monetization/free_home_banner_surface.dart';
import 'package:islami_hayat/features/premium/domain/entitlement_state_machine.dart';

final class _NetworkBoundarySpy
    implements AdSdkAdapter, AdNetworkRequestTransportT0280 {
  int sdkInitializeCalls = 0;
  int networkRequestCalls = 0;
  final List<AdFormat> requestedFormats = <AdFormat>[];
  final List<AdSdkRequestPayloadT0273> observedPayloads =
      <AdSdkRequestPayloadT0273>[];

  @override
  Future<AdSafetyConfigurationEvidenceT0272> initialize({
    required AdSafetyProfileT0272 safetyProfile,
  }) async {
    sdkInitializeCalls += 1;
    return const AdSafetyConfigurationEvidenceT0272(
      runtimeAppliedMaxContentRating: AdContentRatingT0272.general,
      verifiedBlockedCategories:
          AdSafetyProfileT0272.mandatoryBlockedCategories,
      accountCategoryBlocksVerified: true,
    );
  }

  @override
  Future<void> requestAd({
    required AdFormat format,
    required AdSdkRequestPayloadT0273 payload,
  }) async {
    networkRequestCalls += 1;
    requestedFormats.add(format);
    observedPayloads.add(payload);
  }
}

final class _LoadedAdSpy implements LoadedAdHandle {
  int disposeCalls = 0;

  @override
  Future<void> dispose() async {
    disposeCalls += 1;
  }
}

Widget _bannerHost({required EntitlementState entitlement}) {
  return MaterialApp(
    home: Scaffold(
      body: FreeHomeBannerSurface(
        entitlement: entitlement,
        adContent: const SizedBox(
          key: ValueKey('t0280-ad-widget'),
          width: 320,
          height: 50,
        ),
      ),
    ),
  );
}

void main() {
  group('T0280 PRO zero ad network + UI', () {
    for (final entitlement in <EntitlementState>[
      const EntitlementState.verifiedPro(),
      const EntitlementState.cachedPro(),
    ]) {
      test('PRO blocks every surface/format before SDK or network dispatch', () async {
        final network = _NetworkBoundarySpy();
        final coordinator = EntitlementGatedAdSdkCoordinator(sdk: network);

        await coordinator.evaluateAndInitialize(entitlement);

        expect(coordinator.state, AdSdkBootstrapState.suppressedForPro);
        expect(network.sdkInitializeCalls, 0);

        for (final surface in AppAdSurface.values) {
          for (final format in AdFormat.values) {
            expect(
              coordinator.canIssueAdRequestFor(
                entitlement: entitlement,
                surface: surface,
                format: format,
              ),
              isFalse,
              reason: 'PRO must reject $surface / $format',
            );
            await expectLater(
              dispatchPrivacySafeAdRequestT0280(
                coordinator: coordinator,
                transport: network,
                entitlement: entitlement,
                surface: surface,
                format: format,
              ),
              throwsStateError,
              reason: 'PRO must fail before network dispatch for $surface / $format',
            );
          }
        }

        expect(network.networkRequestCalls, 0);
        expect(network.requestedFormats, isEmpty);
        expect(network.observedPayloads, isEmpty);
      });
    }

    test('FREE positive control reaches transport only for allowed placements', () async {
      final network = _NetworkBoundarySpy();
      final coordinator = EntitlementGatedAdSdkCoordinator(sdk: network);
      const free = EntitlementState.free();

      await coordinator.evaluateAndInitialize(free);

      await dispatchPrivacySafeAdRequestT0280(
        coordinator: coordinator,
        transport: network,
        entitlement: free,
        surface: AppAdSurface.todayHome,
        format: AdFormat.banner,
      );
      await dispatchPrivacySafeAdRequestT0280(
        coordinator: coordinator,
        transport: network,
        entitlement: free,
        surface: AppAdSurface.shareDesignUnlock,
        format: AdFormat.rewarded,
      );

      expect(network.sdkInitializeCalls, 1);
      expect(network.networkRequestCalls, 2);
      expect(network.requestedFormats, <AdFormat>[
        AdFormat.banner,
        AdFormat.rewarded,
      ]);
      expect(network.observedPayloads, hasLength(2));
      for (final payload in network.observedPayloads) {
        expect(payload.isStrictV1, isTrue);
        expect(
          payload.toPlatformParameters().keys.toSet(),
          AdSdkRequestPayloadT0273.allowedPlatformParameterKeys,
        );
      }

      await expectLater(
        dispatchPrivacySafeAdRequestT0280(
          coordinator: coordinator,
          transport: network,
          entitlement: free,
          surface: AppAdSurface.quranReader,
          format: AdFormat.banner,
        ),
        throwsStateError,
      );
      expect(network.networkRequestCalls, 2);
    });

    testWidgets('verified and cached PRO render zero banner UI', (tester) async {
      for (final entitlement in <EntitlementState>[
        const EntitlementState.verifiedPro(),
        const EntitlementState.cachedPro(),
      ]) {
        await tester.pumpWidget(_bannerHost(entitlement: entitlement));

        expect(find.byKey(const ValueKey('free-home-banner-surface')), findsNothing);
        expect(find.byKey(const ValueKey('t0280-ad-widget')), findsNothing);
        expect(tester.takeException(), isNull);
      }
    });

    test('FREE to PRO closes requests, disposes loaded ads and rejects late loads', () async {
      final network = _NetworkBoundarySpy();
      final coordinator = EntitlementGatedAdSdkCoordinator(sdk: network);
      const free = EntitlementState.free();
      const pro = EntitlementState.verifiedPro();

      await coordinator.evaluateAndInitialize(free);
      expect(network.sdkInitializeCalls, 1);

      final banner = _LoadedAdSpy();
      final interstitial = _LoadedAdSpy();
      final rewarded = _LoadedAdSpy();
      await coordinator.retainLoadedAd(
        kind: LoadedAdKind.banner,
        ad: banner,
        entitlement: free,
      );
      await coordinator.retainLoadedAd(
        kind: LoadedAdKind.interstitial,
        ad: interstitial,
        entitlement: free,
      );
      await coordinator.retainLoadedAd(
        kind: LoadedAdKind.rewarded,
        ad: rewarded,
        entitlement: free,
      );

      expect(coordinator.loadedAdCount, 3);

      await coordinator.evaluateAndInitialize(pro);

      expect(coordinator.state, AdSdkBootstrapState.suppressedForPro);
      expect(coordinator.loadedAdCount, 0);
      expect(banner.disposeCalls, 1);
      expect(interstitial.disposeCalls, 1);
      expect(rewarded.disposeCalls, 1);
      expect(network.sdkInitializeCalls, 1);

      final lateRewarded = _LoadedAdSpy();
      await coordinator.retainLoadedAd(
        kind: LoadedAdKind.rewarded,
        ad: lateRewarded,
        entitlement: pro,
      );

      expect(lateRewarded.disposeCalls, 1);
      expect(coordinator.loadedAdCount, 0);
      await expectLater(
        dispatchPrivacySafeAdRequestT0280(
          coordinator: coordinator,
          transport: network,
          entitlement: pro,
          surface: AppAdSurface.shareDesignUnlock,
          format: AdFormat.rewarded,
        ),
        throwsStateError,
      );
      expect(network.networkRequestCalls, 0);
    });
  });
}
