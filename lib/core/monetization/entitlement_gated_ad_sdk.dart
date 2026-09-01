import 'ad_placement_policy.dart';
import '../../features/premium/domain/entitlement_state_machine.dart';

/// Narrow production boundary around the platform advertisement SDK.
///
/// Concrete SDK integrations must be injected here instead of initializing
/// themselves from widgets, app startup code, or feature pages. This keeps the
/// FREE/PRO entitlement decision in front of every SDK initialization path.
abstract interface class AdSdkAdapter {
  Future<void> initialize();
}

/// SDK-owned ad object kept in memory after a successful load.
///
/// Banner, interstitial and rewarded adapters must wrap their concrete loaded
/// object with this interface before retaining it in the coordinator.
abstract interface class LoadedAdHandle {
  Future<void> dispose();
}

enum LoadedAdKind { banner, interstitial, rewarded }

enum AdSdkBootstrapState {
  awaitingEntitlement,
  initializedForFree,
  suppressedForPro,
}

final class AdDisposalFailure {
  const AdDisposalFailure({
    required this.kind,
    required this.error,
  });

  final LoadedAdKind kind;
  final Object error;
}

/// Ensures advertisement SDK initialization cannot happen before entitlement
/// has been evaluated and loaded ad objects cannot survive a PRO transition.
///
/// PRO is fail-closed: cached and online-verified PRO states both suppress SDK
/// initialization and all request paths. Any banner/interstitial/rewarded that
/// was retained while FREE is detached from memory and disposed when PRO is
/// observed. A late load callback that arrives after PRO is active is disposed
/// immediately instead of being retained.
///
/// FREE may initialize once. A failed SDK initialization leaves the coordinator
/// unready so callers cannot request an advertisement from a partially
/// initialized SDK.
final class EntitlementGatedAdSdkCoordinator {
  EntitlementGatedAdSdkCoordinator({required AdSdkAdapter sdk}) : _sdk = sdk;

  final AdSdkAdapter _sdk;
  final Map<LoadedAdKind, LoadedAdHandle> _loadedAds =
      <LoadedAdKind, LoadedAdHandle>{};

  AdSdkBootstrapState _state = AdSdkBootstrapState.awaitingEntitlement;
  bool _initializedSuccessfully = false;
  List<AdDisposalFailure> _lastDisposalFailures = const <AdDisposalFailure>[];

  AdSdkBootstrapState get state => _state;
  int get loadedAdCount => _loadedAds.length;
  Set<LoadedAdKind> get loadedAdKinds => Set<LoadedAdKind>.unmodifiable(
        _loadedAds.keys,
      );
  List<AdDisposalFailure> get lastDisposalFailures =>
      List<AdDisposalFailure>.unmodifiable(_lastDisposalFailures);

  Future<AdSdkBootstrapState> evaluateAndInitialize(
    EntitlementState entitlement,
  ) async {
    if (!entitlement.allowsAdSdk) {
      // Suppress request eligibility before awaiting disposal so a slow or
      // failing SDK dispose cannot leave an ad request window open.
      _state = AdSdkBootstrapState.suppressedForPro;
      await _disposeAllLoadedAdsFailClosed();
      return _state;
    }

    if (_initializedSuccessfully) {
      _state = AdSdkBootstrapState.initializedForFree;
      return _state;
    }

    try {
      await _sdk.initialize();
      _initializedSuccessfully = true;
      _state = AdSdkBootstrapState.initializedForFree;
      return _state;
    } catch (_) {
      _initializedSuccessfully = false;
      _state = AdSdkBootstrapState.awaitingEntitlement;
      rethrow;
    }
  }

  /// Retains one loaded ad per kind while FREE.
  ///
  /// A replacement disposes the previous object first. If entitlement has
  /// already become PRO, the newly-arrived object is disposed immediately and
  /// is never placed in the in-memory registry. This closes the race where an
  /// asynchronous SDK load completes just after purchase/restore activates PRO.
  Future<void> retainLoadedAd({
    required LoadedAdKind kind,
    required LoadedAdHandle ad,
    required EntitlementState entitlement,
  }) async {
    if (!entitlement.allowsAdSdk ||
        _state == AdSdkBootstrapState.suppressedForPro) {
      await ad.dispose();
      return;
    }

    requireAdRequestAllowed(entitlement);

    final previous = _loadedAds.remove(kind);
    if (previous != null && !identical(previous, ad)) {
      await previous.dispose();
    }
    _loadedAds[kind] = ad;
  }

  bool canIssueAdRequest(EntitlementState entitlement) {
    return entitlement.allowsAdSdk &&
        _initializedSuccessfully &&
        _state == AdSdkBootstrapState.initializedForFree;
  }

  /// Product-facing request eligibility. Concrete banner/interstitial/rewarded
  /// integrations should call this instead of checking entitlement or placement
  /// separately, so a sacred-content surface cannot accidentally bypass policy.
  bool canIssueAdRequestFor({
    required EntitlementState entitlement,
    required AppAdSurface surface,
    required AdFormat format,
  }) {
    return canIssueAdRequest(entitlement) &&
        AdPlacementPolicy.canRequest(
          surface: surface,
          format: format,
          isPro: entitlement.isPro,
        );
  }

  void requireAdRequestAllowed(EntitlementState entitlement) {
    if (!canIssueAdRequest(entitlement)) {
      throw StateError(
        'Ad request blocked: entitlement is PRO or SDK is not safely initialized.',
      );
    }
  }

  void requireAdRequestAllowedFor({
    required EntitlementState entitlement,
    required AppAdSurface surface,
    required AdFormat format,
  }) {
    if (!canIssueAdRequestFor(
      entitlement: entitlement,
      surface: surface,
      format: format,
    )) {
      throw StateError(
        'Ad request blocked: placement is forbidden, entitlement is PRO, or SDK is not safely initialized.',
      );
    }
  }

  Future<void> _disposeAllLoadedAdsFailClosed() async {
    final pending = Map<LoadedAdKind, LoadedAdHandle>.of(_loadedAds);

    // Detach first. Even if a concrete SDK throws during dispose, no loaded ad
    // remains reachable from the coordinator and all remaining kinds are still
    // attempted.
    _loadedAds.clear();
    final failures = <AdDisposalFailure>[];

    for (final entry in pending.entries) {
      try {
        await entry.value.dispose();
      } catch (error) {
        failures.add(AdDisposalFailure(kind: entry.key, error: error));
      }
    }

    _lastDisposalFailures = List<AdDisposalFailure>.unmodifiable(failures);
  }
}
