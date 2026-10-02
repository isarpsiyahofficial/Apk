import 'package:flutter_test/flutter_test.dart';
import 'package:islami_hayat/features/share/domain/rewarded_share_unlock_t0269.dart';

void main() {
  group('RewardedShareUnlockT0269', () {
    test('first three Canva designs are permanently free', () {
      for (final id in ['Canva-001', 'Canva-002', 'Canva-003']) {
        final gate = RewardedShareUnlockT0269(designId: id, isPro: false);
        expect(gate.currentDecision(), ShareUnlockDecisionT0269.allowedFree);
        expect(gate.shouldOfferRewarded, isFalse);
        expect(gate.consumeSingleShareRight(), isTrue);
        expect(gate.consumeSingleShareRight(), isTrue);
      }
    });

    test('locked FREE design needs rewarded before one share', () {
      final gate = RewardedShareUnlockT0269(
        designId: 'Canva-004',
        isPro: false,
      );

      expect(gate.currentDecision(), ShareUnlockDecisionT0269.rewardRequired);
      expect(gate.shouldOfferRewarded, isTrue);
      expect(gate.consumeSingleShareRight(), isFalse);

      expect(
        gate.applyRewardedResult(RewardedAdResultT0269.completed),
        ShareUnlockDecisionT0269.allowedSingleRewardedShare,
      );
      expect(gate.shouldOfferRewarded, isFalse);
      expect(gate.consumeSingleShareRight(), isTrue);
      expect(gate.currentDecision(), ShareUnlockDecisionT0269.rewardRequired);
      expect(gate.consumeSingleShareRight(), isFalse);
    });

    test('reward right is bound to the selected design instance', () {
      final selected = RewardedShareUnlockT0269(
        designId: 'Canva-057',
        isPro: false,
      );
      final other = RewardedShareUnlockT0269(
        designId: 'Canva-058',
        isPro: false,
      );

      selected.applyRewardedResult(RewardedAdResultT0269.completed);
      expect(selected.consumeSingleShareRight(), isTrue);
      expect(other.consumeSingleShareRight(), isFalse);
    });

    test('cancel fail and no-fill never grant a share right', () {
      for (final result in [
        RewardedAdResultT0269.cancelled,
        RewardedAdResultT0269.failed,
        RewardedAdResultT0269.noFill,
      ]) {
        final gate = RewardedShareUnlockT0269(
          designId: 'Canva-100',
          isPro: false,
        );
        expect(gate.applyRewardedResult(result), ShareUnlockDecisionT0269.denied);
        expect(gate.consumeSingleShareRight(), isFalse);
        expect(gate.shouldOfferRewarded, isTrue);
      }
    });

    test('PRO gets all designs without rewarded offer or consumption limit', () {
      final gate = RewardedShareUnlockT0269(
        designId: 'Canva-100',
        isPro: true,
      );
      expect(gate.currentDecision(), ShareUnlockDecisionT0269.allowedPro);
      expect(gate.shouldOfferRewarded, isFalse);
      expect(gate.consumeSingleShareRight(), isTrue);
      expect(gate.consumeSingleShareRight(), isTrue);
    });

    test('invalid design ids fail closed', () {
      for (final id in ['Canva-000', 'Canva-101', 'canva-004', 'Canva-4']) {
        expect(
          () => RewardedShareUnlockT0269(designId: id, isPro: false),
          throwsArgumentError,
        );
      }
    });
  });
}
