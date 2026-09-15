import 'package:flutter_test/flutter_test.dart';
import 'package:islami_hayat/features/premium/domain/ad_sdk_entitlement_gate_t0265.dart';
import 'package:islami_hayat/features/premium/domain/entitlement_state_machine.dart';

void main() {
  group('T0265 ad SDK entitlement gate', () {
    test('cached PRO never invokes the SDK initializer', () async {
      final gate = AdSdkEntitlementGateT0265();
      var initializerCalls = 0;

      final initialized = await gate.initializeIfAllowed(
        entitlement: const EntitlementState.cachedPro(),
        initializeSdk: () async {
          initializerCalls += 1;
        },
      );

      expect(initialized, isFalse);
      expect(initializerCalls, 0);
      expect(gate.isInitialized, isFalse);
      expect(
        () => gate.requireAdRequestAllowed(
          const EntitlementState.cachedPro(),
        ),
        throwsStateError,
      );
    });

    test('verified PRO never invokes the SDK initializer', () async {
      final gate = AdSdkEntitlementGateT0265();
      var initializerCalls = 0;

      final initialized = await gate.initializeIfAllowed(
        entitlement: const EntitlementState.verifiedPro(),
        initializeSdk: () async {
          initializerCalls += 1;
        },
      );

      expect(initialized, isFalse);
      expect(initializerCalls, 0);
      expect(gate.canRequestAds(const EntitlementState.verifiedPro()), isFalse);
    });

    test('FREE initializes once and only then can request ads', () async {
      final gate = AdSdkEntitlementGateT0265();
      var initializerCalls = 0;

      expect(gate.canRequestAds(const EntitlementState.free()), isFalse);
      expect(
        () => gate.requireAdRequestAllowed(const EntitlementState.free()),
        throwsStateError,
      );

      expect(
        await gate.initializeIfAllowed(
          entitlement: const EntitlementState.free(),
          initializeSdk: () async {
            initializerCalls += 1;
          },
        ),
        isTrue,
      );
      expect(initializerCalls, 1);
      expect(gate.canRequestAds(const EntitlementState.free()), isTrue);

      expect(
        await gate.initializeIfAllowed(
          entitlement: const EntitlementState.verifiedFree(),
          initializeSdk: () async {
            initializerCalls += 1;
          },
        ),
        isTrue,
      );
      expect(initializerCalls, 1);
    });

    test('PRO cannot request ads even if SDK was initialized while FREE', () async {
      final gate = AdSdkEntitlementGateT0265();

      await gate.initializeIfAllowed(
        entitlement: const EntitlementState.free(),
        initializeSdk: () async {},
      );

      expect(gate.isInitialized, isTrue);
      expect(gate.canRequestAds(const EntitlementState.cachedPro()), isFalse);
      expect(gate.canRequestAds(const EntitlementState.verifiedPro()), isFalse);
      expect(
        () => gate.requireAdRequestAllowed(
          const EntitlementState.verifiedPro(),
        ),
        throwsStateError,
      );
    });

    test('SDK initialization failure does not authorize later ad requests', () async {
      final gate = AdSdkEntitlementGateT0265();

      await expectLater(
        gate.initializeIfAllowed(
          entitlement: const EntitlementState.free(),
          initializeSdk: () async {
            throw StateError('sdk init failed');
          },
        ),
        throwsStateError,
      );

      expect(gate.isInitialized, isFalse);
      expect(gate.canRequestAds(const EntitlementState.free()), isFalse);
    });
  });
}
