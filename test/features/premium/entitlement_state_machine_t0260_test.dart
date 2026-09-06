import 'package:flutter_test/flutter_test.dart';
import 'package:islami_hayat/features/premium/domain/entitlement_state_machine.dart';

void main() {
  const machine = EntitlementStateMachine();

  group('T0260 FREE/PRO entitlement state machine', () {
    test('fresh install is FREE and internet/ad gated', () {
      const state = EntitlementState.free();

      expect(state.isFree, isTrue);
      expect(state.isPro, isFalse);
      expect(state.requiresInternetForCore, isTrue);
      expect(state.allowsOfflineCore, isFalse);
      expect(state.allowsAdSdk, isTrue);
      expect(state.allowsBanner, isTrue);
      expect(state.allowsInterstitial, isTrue);
      expect(state.allowsRewardedOffer, isTrue);
    });

    test('verified purchase promotes to online-verified PRO', () {
      final state = machine.transition(
        const EntitlementState.free(),
        EntitlementEvent.verifiedPurchase,
      );

      expect(state.tier, EntitlementTier.pro);
      expect(state.verification, EntitlementVerification.verifiedOnline);
      expect(state.allowsOfflineCore, isTrue);
      expect(state.requiresInternetForCore, isFalse);
      expect(state.allowsAdSdk, isFalse);
      expect(state.allowsBanner, isFalse);
      expect(state.allowsInterstitial, isFalse);
      expect(state.allowsRewardedOffer, isFalse);
    });

    test('restore purchase promotes to PRO', () {
      final state = machine.transition(
        const EntitlementState.free(),
        EntitlementEvent.restoredPurchase,
      );

      expect(state.isPro, isTrue);
      expect(state.verification, EntitlementVerification.verifiedOnline);
    });

    test('verified refund or revoke demotes PRO to FREE fail-closed', () {
      final state = machine.transition(
        const EntitlementState.cachedPro(),
        EntitlementEvent.verifiedRevokedOrRefunded,
      );

      expect(state.isFree, isTrue);
      expect(state.allowsOfflineCore, isFalse);
      expect(state.allowsAdSdk, isTrue);
    });

    test('verified no ownership demotes stale cached PRO to FREE', () {
      final state = machine.transition(
        const EntitlementState.cachedPro(),
        EntitlementEvent.verifiedNoOwnership,
      );

      expect(state.isFree, isTrue);
      expect(state.verification, EntitlementVerification.initial);
    });

    test('only previously verified cache can restore offline PRO', () {
      final cached = machine.restoreCached(hasVerifiedProCache: true);
      final missing = machine.restoreCached(hasVerifiedProCache: false);

      expect(cached.isPro, isTrue);
      expect(cached.verification, EntitlementVerification.cached);
      expect(cached.allowsOfflineCore, isTrue);
      expect(cached.allowsAdSdk, isFalse);

      expect(missing.isFree, isTrue);
      expect(missing.allowsOfflineCore, isFalse);
    });
  });
}
