import '../../features/premium/domain/entitlement_state_machine.dart';
import 'ad_placement_policy.dart';
import 'ad_privacy_policy_t0273.dart';
import 'entitlement_gated_ad_sdk.dart';

/// Final product-owned boundary immediately before a concrete advertisement
/// SDK performs a network request.
///
/// Widgets and feature code must not call an ad SDK request API directly. They
/// pass the request through this transport only after the entitlement/placement
/// coordinator has produced the strict T0273 descriptor. This gives T0280 a
/// production-level invariant: verified or cached PRO fails before the
/// transport can observe a request, rather than relying on each caller to
/// remember a separate PRO check.
abstract interface class AdNetworkRequestTransportT0280 {
  Future<void> requestAd({
    required AdFormat format,
    required AdSdkRequestPayloadT0273 payload,
  });
}

/// Dispatches one privacy-safe advertisement request through the sole approved
/// network boundary.
///
/// The coordinator performs entitlement + placement checks synchronously before
/// [transport] is invoked. The descriptor is then converted to the closed T0273
/// SDK payload and revalidated. Therefore PRO, sacred/unsupported placements,
/// unsafe initialization and malformed privacy state all fail before a concrete
/// SDK gets a chance to start network I/O.
Future<void> dispatchPrivacySafeAdRequestT0280({
  required EntitlementGatedAdSdkCoordinator coordinator,
  required AdNetworkRequestTransportT0280 transport,
  required EntitlementState entitlement,
  required AppAdSurface surface,
  required AdFormat format,
}) async {
  final descriptor = coordinator.buildPrivacySafeAdRequestFor(
    entitlement: entitlement,
    surface: surface,
    format: format,
  );
  final payload = descriptor.toSdkPayload();
  payload.requireStrictV1();

  await transport.requestAd(format: format, payload: payload);
}
