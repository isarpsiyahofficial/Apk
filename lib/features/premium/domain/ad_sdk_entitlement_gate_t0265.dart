import 'package:islami_hayat/features/premium/domain/entitlement_state_machine.dart';

/// T0265 production boundary for every ad SDK bootstrap/request path.
///
/// Entitlement must be resolved before this gate is invoked. PRO states are
/// fail-closed: the SDK initializer is never called and ad requests are never
/// authorized. FREE can initialize once, then request ads through the same
/// entitlement-aware boundary.
final class AdSdkEntitlementGateT0265 {
  bool _initialized = false;

  bool get isInitialized => _initialized;

  Future<bool> initializeIfAllowed({
    required EntitlementState entitlement,
    required Future<void> Function() initializeSdk,
  }) async {
    if (!entitlement.allowsAdSdk) {
      return false;
    }
    if (_initialized) {
      return true;
    }

    await initializeSdk();
    _initialized = true;
    return true;
  }

  bool canRequestAds(EntitlementState entitlement) {
    return _initialized && entitlement.allowsAdSdk;
  }

  void requireAdRequestAllowed(EntitlementState entitlement) {
    if (!canRequestAds(entitlement)) {
      throw StateError(
        'Ad request denied for ${entitlement.tier.name} '
        '(${entitlement.verification.name}); sdkInitialized=$_initialized.',
      );
    }
  }
}
