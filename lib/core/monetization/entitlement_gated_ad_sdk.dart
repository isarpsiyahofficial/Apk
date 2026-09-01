import '../../features/premium/domain/entitlement_state_machine.dart';

/// Narrow production boundary around the platform advertisement SDK.
///
/// Concrete SDK integrations must be injected here instead of initializing
/// themselves from widgets, app startup code, or feature pages. This keeps the
/// FREE/PRO entitlement decision in front of every SDK initialization path.
abstract interface class AdSdkAdapter {
  Future<void> initialize();
}

enum AdSdkBootstrapState {
  awaitingEntitlement,
  initializedForFree,
  suppressedForPro,
}

/// Ensures advertisement SDK initialization cannot happen before entitlement
/// has been evaluated.
///
/// PRO is fail-closed: cached and online-verified PRO states both suppress SDK
/// initialization and all request paths. FREE may initialize once. A failed SDK
/// initialization leaves the coordinator unready so callers cannot request an
/// advertisement from a partially initialized SDK.
final class EntitlementGatedAdSdkCoordinator {
  EntitlementGatedAdSdkCoordinator({required AdSdkAdapter sdk}) : _sdk = sdk;

  final AdSdkAdapter _sdk;
  AdSdkBootstrapState _state = AdSdkBootstrapState.awaitingEntitlement;
  bool _initializedSuccessfully = false;

  AdSdkBootstrapState get state => _state;

  Future<AdSdkBootstrapState> evaluateAndInitialize(
    EntitlementState entitlement,
  ) async {
    if (!entitlement.allowsAdSdk) {
      _state = AdSdkBootstrapState.suppressedForPro;
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

  bool canIssueAdRequest(EntitlementState entitlement) {
    return entitlement.allowsAdSdk &&
        _initializedSuccessfully &&
        _state == AdSdkBootstrapState.initializedForFree;
  }

  void requireAdRequestAllowed(EntitlementState entitlement) {
    if (!canIssueAdRequest(entitlement)) {
      throw StateError(
        'Ad request blocked: entitlement is PRO or SDK is not safely initialized.',
      );
    }
  }
}
