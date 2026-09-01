import 'package:flutter_test/flutter_test.dart';
import 'package:islami_hayat/core/monetization/ad_safety_policy_t0272.dart';
import 'package:islami_hayat/core/monetization/entitlement_gated_ad_sdk.dart';
import 'package:islami_hayat/core/monetization/rewarded_share_unlock_t0269.dart';
import 'package:islami_hayat/core/monetization/share_visual_access_matrix_t0271.dart';
import 'package:islami_hayat/features/premium/domain/entitlement_state_machine.dart';

final class _FakeAdSdk implements AdSdkAdapter {
  @override
  Future<AdSafetyConfigurationEvidenceT0272> initialize({
    required AdSafetyProfileT0272 safetyProfile,
  }) async {
    return const AdSafetyConfigurationEvidenceT0272(
      runtimeMaxContentRatingApplied: true,
      accountCategoryBlocksVerified: true,
    );
  }
}

void main() {
  const matrix = ShareVisualAccessMatrixT0271();

  Future<RewardedShareGrant> completedGrantFor(int slot) async {
    final coordinator = EntitlementGatedAdSdkCoordinator(sdk: _FakeAdSdk());
    await coordinator.evaluateAndInitialize(const EntitlementState.free());
    final flow = RewardedShareUnlockT0269(adCoordinator: coordinator);
    final designId = matrix.designIdForSlot(slot);
    flow.begin(designId: designId, isDesignLocked: true, entitlement: const EntitlementState.free());
    return flow.finish(designId: designId, outcome: RewardedAdTerminalOutcome.completed).grant!;
  }

  test('V1 matrix is exactly 3 free plus 97 rewarded-or-PRO slots', () {
    final free = <int>[];
    final locked = <int>[];

    for (var slot = 1; slot <= ShareVisualAccessMatrixT0271.totalDesignCount; slot++) {
      (matrix.isPermanentlyFree(slot) ? free : locked).add(slot);
    }

    expect(ShareVisualAccessMatrixT0271.totalDesignCount, 100);
    expect(ShareVisualAccessMatrixT0271.permanentlyFreeDesignCount, 3);
    expect(ShareVisualAccessMatrixT0271.rewardedOrProDesignCount, 97);
    expect(free, <int>[1, 2, 3]);
    expect(locked.length, 97);
    expect(locked.first, 4);
    expect(locked.last, 100);
  });

  test('FREE gets the first three designs without ads and no others', () {
    for (var slot = 1; slot <= 100; slot++) {
      final decision = matrix.evaluate(slot: slot, entitlement: const EntitlementState.free());
      if (slot <= 3) {
        expect(decision.allowed, isTrue, reason: 'slot $slot');
        expect(decision.mode, ShareVisualAccessMode.freeUnlimited);
      } else {
        expect(decision.allowed, isFalse, reason: 'slot $slot');
        expect(decision.mode, ShareVisualAccessMode.rewardedRequired);
      }
    }
  });

  test('PRO gets all 100 designs without a rewarded grant', () {
    for (var slot = 1; slot <= 100; slot++) {
      final decision = matrix.evaluate(slot: slot, entitlement: const EntitlementState.verifiedPro());
      expect(decision.allowed, isTrue, reason: 'slot $slot');
      expect(decision.mode, ShareVisualAccessMode.proUnlimited);
    }
  });

  test('completed rewarded grant authorizes only its selected locked design once', () async {
    final grant = await completedGrantFor(4);

    final before = matrix.evaluate(slot: 4, entitlement: const EntitlementState.free(), rewardedGrant: grant);
    expect(before.allowed, isTrue);
    expect(before.mode, ShareVisualAccessMode.rewardedSingleUse);

    matrix.consumeForShare(slot: 4, entitlement: const EntitlementState.free(), rewardedGrant: grant);
    expect(grant.remainingUses, 0);

    final after = matrix.evaluate(slot: 4, entitlement: const EntitlementState.free(), rewardedGrant: grant);
    expect(after.allowed, isFalse);
    expect(after.mode, ShareVisualAccessMode.rewardedRequired);
  });

  test('reward for another design fails closed', () async {
    final grant = await completedGrantFor(4);
    final decision = matrix.evaluate(slot: 5, entitlement: const EntitlementState.free(), rewardedGrant: grant);

    expect(decision.allowed, isFalse);
    expect(decision.mode, ShareVisualAccessMode.rewardedRequired);
    expect(grant.remainingUses, 1);
  });

  test('PRO access never consumes a rewarded grant', () async {
    final grant = await completedGrantFor(4);
    final decision = matrix.consumeForShare(slot: 4, entitlement: const EntitlementState.cachedPro(), rewardedGrant: grant);

    expect(decision.mode, ShareVisualAccessMode.proUnlimited);
    expect(grant.remainingUses, 1);
  });

  test('unknown visual slots are rejected instead of inheriting access', () {
    for (final invalidSlot in <int>[0, 101, -1]) {
      expect(
        () => matrix.evaluate(slot: invalidSlot, entitlement: const EntitlementState.verifiedPro()),
        throwsRangeError,
      );
    }
  });

  test('logical slot IDs are stable and zero-padded', () {
    expect(matrix.designIdForSlot(1), 'share-design-001');
    expect(matrix.designIdForSlot(3), 'share-design-003');
    expect(matrix.designIdForSlot(4), 'share-design-004');
    expect(matrix.designIdForSlot(100), 'share-design-100');
  });
}
