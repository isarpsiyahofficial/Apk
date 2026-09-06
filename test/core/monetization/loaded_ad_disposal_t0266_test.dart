import 'package:flutter_test/flutter_test.dart';
import 'package:islami_hayat/core/monetization/ad_safety_policy_t0272.dart';
import 'package:islami_hayat/core/monetization/entitlement_gated_ad_sdk.dart';
import 'package:islami_hayat/features/premium/domain/entitlement_state_machine.dart';

final class _FakeAdSdk implements AdSdkAdapter {
  int initializeCalls = 0;

  @override
  Future<AdSafetyConfigurationEvidenceT0272> initialize({
    required AdSafetyProfileT0272 safetyProfile,
  }) async {
    initializeCalls += 1;
    return const AdSafetyConfigurationEvidenceT0272(
      runtimeMaxContentRatingApplied: true,
      accountCategoryBlocksVerified: true,
    );
  }
}

final class _FakeLoadedAd implements LoadedAdHandle {
  _FakeLoadedAd({this.failDispose = false});

  final bool failDispose;
  int disposeCalls = 0;

  @override
  Future<void> dispose() async {
    disposeCalls += 1;
    if (failDispose) {
      throw StateError('simulated dispose failure');
    }
  }
}

void main() {
  group('T0266 loaded ad disposal on PRO transition', () {
    test('FREE to verified PRO disposes banner, interstitial and rewarded', () async {
      final sdk = _FakeAdSdk();
      final coordinator = EntitlementGatedAdSdkCoordinator(sdk: sdk);
      const free = EntitlementState.free();
      const pro = EntitlementState.verifiedPro();
      final banner = _FakeLoadedAd();
      final interstitial = _FakeLoadedAd();
      final rewarded = _FakeLoadedAd();

      await coordinator.evaluateAndInitialize(free);
      await coordinator.retainLoadedAd(kind: LoadedAdKind.banner, ad: banner, entitlement: free);
      await coordinator.retainLoadedAd(kind: LoadedAdKind.interstitial, ad: interstitial, entitlement: free);
      await coordinator.retainLoadedAd(kind: LoadedAdKind.rewarded, ad: rewarded, entitlement: free);

      expect(coordinator.loadedAdCount, 3);
      expect(coordinator.loadedAdKinds, containsAll(<LoadedAdKind>{LoadedAdKind.banner, LoadedAdKind.interstitial, LoadedAdKind.rewarded}));

      await coordinator.evaluateAndInitialize(pro);

      expect(coordinator.state, AdSdkBootstrapState.suppressedForPro);
      expect(coordinator.loadedAdCount, 0);
      expect(banner.disposeCalls, 1);
      expect(interstitial.disposeCalls, 1);
      expect(rewarded.disposeCalls, 1);
      expect(coordinator.lastDisposalFailures, isEmpty);
      expect(coordinator.canIssueAdRequest(pro), isFalse);
    });

    test('cached PRO also disposes ads retained while FREE', () async {
      final coordinator = EntitlementGatedAdSdkCoordinator(sdk: _FakeAdSdk());
      const free = EntitlementState.free();
      final banner = _FakeLoadedAd();

      await coordinator.evaluateAndInitialize(free);
      await coordinator.retainLoadedAd(kind: LoadedAdKind.banner, ad: banner, entitlement: free);
      await coordinator.evaluateAndInitialize(const EntitlementState.cachedPro());

      expect(banner.disposeCalls, 1);
      expect(coordinator.loadedAdCount, 0);
      expect(coordinator.state, AdSdkBootstrapState.suppressedForPro);
    });

    test('late load callback in PRO is disposed immediately and never retained', () async {
      final coordinator = EntitlementGatedAdSdkCoordinator(sdk: _FakeAdSdk());
      const pro = EntitlementState.verifiedPro();
      final lateRewarded = _FakeLoadedAd();

      await coordinator.evaluateAndInitialize(pro);
      await coordinator.retainLoadedAd(kind: LoadedAdKind.rewarded, ad: lateRewarded, entitlement: pro);

      expect(lateRewarded.disposeCalls, 1);
      expect(coordinator.loadedAdCount, 0);
    });

    test('dispose failure cannot preserve another loaded ad or reopen requests', () async {
      final coordinator = EntitlementGatedAdSdkCoordinator(sdk: _FakeAdSdk());
      const free = EntitlementState.free();
      const pro = EntitlementState.verifiedPro();
      final brokenBanner = _FakeLoadedAd(failDispose: true);
      final interstitial = _FakeLoadedAd();
      final rewarded = _FakeLoadedAd();

      await coordinator.evaluateAndInitialize(free);
      await coordinator.retainLoadedAd(kind: LoadedAdKind.banner, ad: brokenBanner, entitlement: free);
      await coordinator.retainLoadedAd(kind: LoadedAdKind.interstitial, ad: interstitial, entitlement: free);
      await coordinator.retainLoadedAd(kind: LoadedAdKind.rewarded, ad: rewarded, entitlement: free);

      await coordinator.evaluateAndInitialize(pro);

      expect(brokenBanner.disposeCalls, 1);
      expect(interstitial.disposeCalls, 1);
      expect(rewarded.disposeCalls, 1);
      expect(coordinator.loadedAdCount, 0);
      expect(coordinator.lastDisposalFailures, hasLength(1));
      expect(coordinator.lastDisposalFailures.single.kind, LoadedAdKind.banner);
      expect(coordinator.canIssueAdRequest(pro), isFalse);
    });

    test('re-evaluating PRO does not double-dispose detached objects', () async {
      final coordinator = EntitlementGatedAdSdkCoordinator(sdk: _FakeAdSdk());
      const free = EntitlementState.free();
      const pro = EntitlementState.verifiedPro();
      final interstitial = _FakeLoadedAd();

      await coordinator.evaluateAndInitialize(free);
      await coordinator.retainLoadedAd(kind: LoadedAdKind.interstitial, ad: interstitial, entitlement: free);
      await coordinator.evaluateAndInitialize(pro);
      await coordinator.evaluateAndInitialize(pro);

      expect(interstitial.disposeCalls, 1);
      expect(coordinator.loadedAdCount, 0);
    });

    test('replacing a loaded ad disposes the previous object while FREE', () async {
      final coordinator = EntitlementGatedAdSdkCoordinator(sdk: _FakeAdSdk());
      const free = EntitlementState.free();
      final first = _FakeLoadedAd();
      final replacement = _FakeLoadedAd();

      await coordinator.evaluateAndInitialize(free);
      await coordinator.retainLoadedAd(kind: LoadedAdKind.banner, ad: first, entitlement: free);
      await coordinator.retainLoadedAd(kind: LoadedAdKind.banner, ad: replacement, entitlement: free);

      expect(first.disposeCalls, 1);
      expect(replacement.disposeCalls, 0);
      expect(coordinator.loadedAdCount, 1);
      expect(coordinator.loadedAdKinds, <LoadedAdKind>{LoadedAdKind.banner});
    });
  });
}
