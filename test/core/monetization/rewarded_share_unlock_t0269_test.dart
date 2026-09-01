import 'package:flutter_test/flutter_test.dart';
import 'package:islami_hayat/core/monetization/entitlement_gated_ad_sdk.dart';
import 'package:islami_hayat/core/monetization/rewarded_share_unlock_t0269.dart';
import 'package:islami_hayat/features/premium/domain/entitlement_state_machine.dart';

final class _FakeAdSdk implements AdSdkAdapter {
  int initializeCalls = 0;

  @override
  Future<void> initialize() async {
    initializeCalls += 1;
  }
}

void main() {
  EntitlementState freeState() => const EntitlementState.free();
  EntitlementState proState() => const EntitlementState.verifiedPro();

  test('locked FREE design exposes explicit one-use rewarded contract', () async {
    final sdk = _FakeAdSdk();
    final adCoordinator = EntitlementGatedAdSdkCoordinator(sdk: sdk);
    final entitlement = freeState();
    await adCoordinator.evaluateAndInitialize(entitlement);
    final unlock = RewardedShareUnlockT0269(adCoordinator: adCoordinator);

    final prompt = unlock.begin(
      designId: 'canva-locked-004',
      isDesignLocked: true,
      entitlement: entitlement,
    );

    expect(prompt.designId, 'canva-locked-004');
    expect(
      prompt.disclosureKey,
      RewardedShareUnlockT0269.disclosureLocalizationKey,
    );
    expect(prompt.shareUsesGrantedOnCompletion, 1);
    expect(sdk.initializeCalls, 1);
  });

  test('completed reward creates exactly one use bound to selected design', () async {
    final adCoordinator = EntitlementGatedAdSdkCoordinator(sdk: _FakeAdSdk());
    final entitlement = freeState();
    await adCoordinator.evaluateAndInitialize(entitlement);
    final unlock = RewardedShareUnlockT0269(adCoordinator: adCoordinator);

    unlock.begin(
      designId: 'canva-locked-021',
      isDesignLocked: true,
      entitlement: entitlement,
    );
    final grant = unlock.complete(
      designId: 'canva-locked-021',
      adCompleted: true,
    );

    expect(grant.remainingUses, 1);
    expect(grant.isConsumed, isFalse);
    grant.consumeForDesign('canva-locked-021');
    expect(grant.remainingUses, 0);
    expect(grant.isConsumed, isTrue);
    expect(
      () => grant.consumeForDesign('canva-locked-021'),
      throwsStateError,
    );
  });

  test('grant cannot be spent on another design', () async {
    final adCoordinator = EntitlementGatedAdSdkCoordinator(sdk: _FakeAdSdk());
    final entitlement = freeState();
    await adCoordinator.evaluateAndInitialize(entitlement);
    final unlock = RewardedShareUnlockT0269(adCoordinator: adCoordinator);

    unlock.begin(
      designId: 'canva-locked-033',
      isDesignLocked: true,
      entitlement: entitlement,
    );
    final grant = unlock.complete(
      designId: 'canva-locked-033',
      adCompleted: true,
    );

    expect(
      () => grant.consumeForDesign('canva-locked-034'),
      throwsStateError,
    );
    expect(grant.remainingUses, 1);
  });

  test('PRO users never enter rewarded unlock flow', () async {
    final adCoordinator = EntitlementGatedAdSdkCoordinator(sdk: _FakeAdSdk());
    final entitlement = proState();
    await adCoordinator.evaluateAndInitialize(entitlement);
    final unlock = RewardedShareUnlockT0269(adCoordinator: adCoordinator);

    expect(
      () => unlock.begin(
        designId: 'canva-locked-010',
        isDesignLocked: true,
        entitlement: entitlement,
      ),
      throwsStateError,
    );
  });

  test('unlocked designs and empty ids fail closed', () async {
    final adCoordinator = EntitlementGatedAdSdkCoordinator(sdk: _FakeAdSdk());
    final entitlement = freeState();
    await adCoordinator.evaluateAndInitialize(entitlement);
    final unlock = RewardedShareUnlockT0269(adCoordinator: adCoordinator);

    expect(
      () => unlock.begin(
        designId: 'free-design-001',
        isDesignLocked: false,
        entitlement: entitlement,
      ),
      throwsStateError,
    );
    expect(
      () => unlock.begin(
        designId: '   ',
        isDesignLocked: true,
        entitlement: entitlement,
      ),
      throwsArgumentError,
    );
  });

  test('completion mismatch and incomplete ad never create a grant', () async {
    final adCoordinator = EntitlementGatedAdSdkCoordinator(sdk: _FakeAdSdk());
    final entitlement = freeState();
    await adCoordinator.evaluateAndInitialize(entitlement);
    final unlock = RewardedShareUnlockT0269(adCoordinator: adCoordinator);

    unlock.begin(
      designId: 'canva-locked-044',
      isDesignLocked: true,
      entitlement: entitlement,
    );
    expect(
      () => unlock.complete(
        designId: 'canva-locked-044',
        adCompleted: false,
      ),
      throwsStateError,
    );

    unlock.begin(
      designId: 'canva-locked-045',
      isDesignLocked: true,
      entitlement: entitlement,
    );
    expect(
      () => unlock.complete(
        designId: 'canva-locked-046',
        adCompleted: true,
      ),
      throwsStateError,
    );
  });
}
