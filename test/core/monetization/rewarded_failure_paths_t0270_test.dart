import 'package:flutter_test/flutter_test.dart';
import 'package:islami_hayat/core/monetization/ad_safety_policy_t0272.dart';
import 'package:islami_hayat/core/monetization/entitlement_gated_ad_sdk.dart';
import 'package:islami_hayat/core/monetization/rewarded_share_unlock_t0269.dart';
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
  Future<RewardedShareUnlockT0269> readyFlow() async {
    final coordinator = EntitlementGatedAdSdkCoordinator(sdk: _FakeAdSdk());
    await coordinator.evaluateAndInitialize(const EntitlementState.free());
    return RewardedShareUnlockT0269(adCoordinator: coordinator);
  }

  for (final scenario in <(RewardedAdTerminalOutcome, String)>[
    (RewardedAdTerminalOutcome.cancelled, RewardedShareUnlockT0269.cancelledLocalizationKey),
    (RewardedAdTerminalOutcome.failed, RewardedShareUnlockT0269.failedLocalizationKey),
    (RewardedAdTerminalOutcome.noFill, RewardedShareUnlockT0269.noFillLocalizationKey),
  ]) {
    test('${scenario.$1.name} gives no reward and never forces PRO', () async {
      final flow = await readyFlow();
      flow.begin(designId: 'locked-design-0270', isDesignLocked: true, entitlement: const EntitlementState.free());

      final result = flow.finish(designId: 'locked-design-0270', outcome: scenario.$1);

      expect(result.hasGrant, isFalse);
      expect(result.grant, isNull);
      expect(result.messageLocalizationKey, scenario.$2);
      expect(result.religiousContentRemainsAvailable, isTrue);
      expect(result.shouldForceProPurchase, isFalse);
    });
  }

  test('completed outcome is the only terminal state that grants a use', () async {
    final flow = await readyFlow();
    flow.begin(designId: 'locked-design-success', isDesignLocked: true, entitlement: const EntitlementState.free());

    final result = flow.finish(designId: 'locked-design-success', outcome: RewardedAdTerminalOutcome.completed);

    expect(result.hasGrant, isTrue);
    expect(result.grant?.remainingUses, 1);
    expect(result.messageLocalizationKey, isNull);
    expect(result.religiousContentRemainsAvailable, isTrue);
    expect(result.shouldForceProPurchase, isFalse);
  });

  test('terminal result clears active attempt so callbacks cannot double grant', () async {
    final flow = await readyFlow();
    flow.begin(designId: 'locked-design-race', isDesignLocked: true, entitlement: const EntitlementState.free());

    final first = flow.finish(designId: 'locked-design-race', outcome: RewardedAdTerminalOutcome.noFill);
    expect(first.hasGrant, isFalse);

    expect(
      () => flow.finish(designId: 'locked-design-race', outcome: RewardedAdTerminalOutcome.completed),
      throwsStateError,
    );
  });

  test('mismatched terminal callback fails closed without a grant', () async {
    final flow = await readyFlow();
    flow.begin(designId: 'locked-design-a', isDesignLocked: true, entitlement: const EntitlementState.free());

    expect(
      () => flow.finish(designId: 'locked-design-b', outcome: RewardedAdTerminalOutcome.completed),
      throwsStateError,
    );
  });
}
