import 'package:flutter_test/flutter_test.dart';
import 'package:islami_hayat/features/share/domain/rewarded_failure_policy_t0270.dart';
import 'package:islami_hayat/features/share/domain/rewarded_share_unlock_t0269.dart';

void main() {
  group('RewardedFailurePolicyT0270', () {
    const policy = RewardedFailurePolicyT0270();

    test('cancel never grants reward, blocks religious content, or forces PRO', () {
      final decision = policy.evaluate(RewardedAdResultT0269.cancelled);

      expect(decision.surface, RewardedFailureSurfaceT0270.cancelled);
      expect(decision.grantsShareRight, isFalse);
      expect(decision.canContinueReligiousContent, isTrue);
      expect(decision.canRetryRewarded, isTrue);
      expect(decision.shouldForcePro, isFalse);
    });

    test('failure never grants reward, blocks religious content, or forces PRO', () {
      final decision = policy.evaluate(RewardedAdResultT0269.failed);

      expect(decision.surface, RewardedFailureSurfaceT0270.failed);
      expect(decision.grantsShareRight, isFalse);
      expect(decision.canContinueReligiousContent, isTrue);
      expect(decision.canRetryRewarded, isTrue);
      expect(decision.shouldForcePro, isFalse);
    });

    test('no-fill keeps religious content usable without forced PRO', () {
      final decision = policy.evaluate(RewardedAdResultT0269.noFill);

      expect(decision.surface, RewardedFailureSurfaceT0270.noFill);
      expect(decision.grantsShareRight, isFalse);
      expect(decision.canContinueReligiousContent, isTrue);
      expect(decision.canRetryRewarded, isTrue);
      expect(decision.shouldForcePro, isFalse);
    });

    test('completed result cannot enter failure-policy path', () {
      expect(
        () => policy.evaluate(RewardedAdResultT0269.completed),
        throwsArgumentError,
      );
    });

    test('T0269 gate remains locked after every unsuccessful ad result', () {
      for (final result in <RewardedAdResultT0269>[
        RewardedAdResultT0269.cancelled,
        RewardedAdResultT0269.failed,
        RewardedAdResultT0269.noFill,
      ]) {
        final unlock = RewardedShareUnlockT0269(
          designId: 'Canva-004',
          isPro: false,
        );

        unlock.applyRewardedResult(result);
        final failure = policy.evaluate(result);

        expect(failure.grantsShareRight, isFalse);
        expect(unlock.consumeSingleShareRight(), isFalse);
        expect(unlock.shouldOfferRewarded, isTrue);
        expect(failure.canContinueReligiousContent, isTrue);
        expect(failure.shouldForcePro, isFalse);
      }
    });
  });
}
