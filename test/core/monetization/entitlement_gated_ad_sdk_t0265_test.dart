import 'package:flutter_test/flutter_test.dart';
import 'package:islami_hayat/core/monetization/entitlement_gated_ad_sdk.dart';
import 'package:islami_hayat/features/premium/domain/entitlement_state_machine.dart';

final class _FakeAdSdk implements AdSdkAdapter {
  _FakeAdSdk({this.failInitialization = false});

  final bool failInitialization;
  int initializeCalls = 0;

  @override
  Future<void> initialize() async {
    initializeCalls += 1;
    if (failInitialization) {
      throw StateError('simulated SDK init failure');
    }
  }
}

void main() {
  group('T0265 entitlement-gated ad SDK initialization', () {
    test('verified PRO suppresses SDK initialization completely', () async {
      final sdk = _FakeAdSdk();
      final coordinator = EntitlementGatedAdSdkCoordinator(sdk: sdk);

      final state = await coordinator.evaluateAndInitialize(
        const EntitlementState.verifiedPro(),
      );

      expect(state, AdSdkBootstrapState.suppressedForPro);
      expect(sdk.initializeCalls, 0);
      expect(
        coordinator.canIssueAdRequest(const EntitlementState.verifiedPro()),
        isFalse,
      );
    });

    test('cached PRO also suppresses SDK initialization completely', () async {
      final sdk = _FakeAdSdk();
      final coordinator = EntitlementGatedAdSdkCoordinator(sdk: sdk);

      await coordinator.evaluateAndInitialize(const EntitlementState.cachedPro());

      expect(sdk.initializeCalls, 0);
      expect(coordinator.state, AdSdkBootstrapState.suppressedForPro);
    });

    test('FREE initializes the SDK once after entitlement evaluation', () async {
      final sdk = _FakeAdSdk();
      final coordinator = EntitlementGatedAdSdkCoordinator(sdk: sdk);

      await coordinator.evaluateAndInitialize(const EntitlementState.free());
      await coordinator.evaluateAndInitialize(const EntitlementState.free());

      expect(sdk.initializeCalls, 1);
      expect(coordinator.state, AdSdkBootstrapState.initializedForFree);
      expect(
        coordinator.canIssueAdRequest(const EntitlementState.free()),
        isTrue,
      );
    });

    test('ad requests fail closed before successful initialization', () {
      final coordinator = EntitlementGatedAdSdkCoordinator(sdk: _FakeAdSdk());

      expect(
        () => coordinator.requireAdRequestAllowed(
          const EntitlementState.free(),
        ),
        throwsStateError,
      );
    });

    test('SDK init failure leaves request path closed', () async {
      final sdk = _FakeAdSdk(failInitialization: true);
      final coordinator = EntitlementGatedAdSdkCoordinator(sdk: sdk);

      await expectLater(
        coordinator.evaluateAndInitialize(const EntitlementState.free()),
        throwsStateError,
      );

      expect(coordinator.state, AdSdkBootstrapState.awaitingEntitlement);
      expect(
        coordinator.canIssueAdRequest(const EntitlementState.free()),
        isFalse,
      );
    });

    test('FREE to PRO transition closes request path without a new init', () async {
      final sdk = _FakeAdSdk();
      final coordinator = EntitlementGatedAdSdkCoordinator(sdk: sdk);

      await coordinator.evaluateAndInitialize(const EntitlementState.free());
      expect(coordinator.canIssueAdRequest(const EntitlementState.free()), isTrue);

      await coordinator.evaluateAndInitialize(const EntitlementState.verifiedPro());

      expect(sdk.initializeCalls, 1);
      expect(coordinator.state, AdSdkBootstrapState.suppressedForPro);
      expect(
        coordinator.canIssueAdRequest(const EntitlementState.verifiedPro()),
        isFalse,
      );
      expect(
        () => coordinator.requireAdRequestAllowed(
          const EntitlementState.verifiedPro(),
        ),
        throwsStateError,
      );
    });
  });
}
