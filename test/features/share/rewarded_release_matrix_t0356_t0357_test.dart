import 'package:flutter_test/flutter_test.dart';
import 'package:islami_hayat/features/share/domain/rewarded_share_flow_t0281.dart';
import 'package:islami_hayat/features/share/domain/rewarded_share_unlock_t0269.dart';

final class _MatrixPresenterT0356 implements RewardedAdPresenterT0281 {
  _MatrixPresenterT0356(this.result);

  final RewardedAdResultT0269 result;
  int calls = 0;
  final List<String> designIds = <String>[];

  @override
  Future<RewardedAdResultT0269> showForShareUnlock({
    required String designId,
  }) async {
    calls += 1;
    designIds.add(designId);
    return result;
  }
}

RewardedShareFlowT0281 _flowT0356({
  required String designId,
  required bool isPro,
  required RewardedAdPresenterT0281 presenter,
}) {
  return RewardedShareFlowT0281(
    unlock: RewardedShareUnlockT0269(
      designId: designId,
      isPro: isPro,
    ),
    presenter: presenter,
  );
}

String _designIdT0356(int number) => 'Canva-${number.toString().padLeft(3, '0')}';

void main() {
  group('T0356/T0357 rewarded release matrix', () {
    test('all 97 locked FREE designs grant exactly one share only after completed reward', () async {
      for (var number = 4; number <= 100; number += 1) {
        final designId = _designIdT0356(number);
        final presenter = _MatrixPresenterT0356(RewardedAdResultT0269.completed);
        final flow = _flowT0356(
          designId: designId,
          isPro: false,
          presenter: presenter,
        );

        expect(flow.decision, ShareUnlockDecisionT0269.rewardRequired);
        expect(flow.shouldOfferRewarded, isTrue);
        expect(
          await flow.requestUnlock(),
          ShareUnlockDecisionT0269.allowedSingleRewardedShare,
          reason: '$designId must unlock only after a completed reward',
        );
        expect(presenter.calls, 1);
        expect(presenter.designIds, <String>[designId]);
        expect(flow.shouldOfferRewarded, isFalse);

        expect(flow.consumeShareRight(), isTrue);
        expect(
          flow.consumeShareRight(),
          isFalse,
          reason: '$designId rewarded entitlement must be single-use',
        );
        expect(flow.decision, ShareUnlockDecisionT0269.rewardRequired);
        expect(flow.shouldOfferRewarded, isTrue);
      }
    });

    test('cancel fail and no-fill deny every locked FREE design without leaking a token', () async {
      for (final result in <RewardedAdResultT0269>[
        RewardedAdResultT0269.cancelled,
        RewardedAdResultT0269.failed,
        RewardedAdResultT0269.noFill,
      ]) {
        for (var number = 4; number <= 100; number += 1) {
          final designId = _designIdT0356(number);
          final presenter = _MatrixPresenterT0356(result);
          final flow = _flowT0356(
            designId: designId,
            isPro: false,
            presenter: presenter,
          );

          expect(
            await flow.requestUnlock(),
            ShareUnlockDecisionT0269.denied,
            reason: '$designId must fail closed for $result',
          );
          expect(presenter.calls, 1);
          expect(flow.consumeShareRight(), isFalse);
          expect(flow.shouldOfferRewarded, isTrue);
        }
      }
    });

    test('the 3 permanent FREE designs never request rewarded', () async {
      for (var number = 1; number <= 3; number += 1) {
        final designId = _designIdT0356(number);
        final presenter = _MatrixPresenterT0356(RewardedAdResultT0269.completed);
        final flow = _flowT0356(
          designId: designId,
          isPro: false,
          presenter: presenter,
        );

        expect(await flow.requestUnlock(), ShareUnlockDecisionT0269.allowedFree);
        expect(presenter.calls, 0);
        expect(flow.consumeShareRight(), isTrue);
        expect(flow.consumeShareRight(), isTrue);
      }
    });

    test('PRO bypasses rewarded for all 100 designs and remains unlimited', () async {
      for (var number = 1; number <= 100; number += 1) {
        final designId = _designIdT0356(number);
        final presenter = _MatrixPresenterT0356(RewardedAdResultT0269.completed);
        final flow = _flowT0356(
          designId: designId,
          isPro: true,
          presenter: presenter,
        );

        expect(await flow.requestUnlock(), ShareUnlockDecisionT0269.allowedPro);
        expect(presenter.calls, 0);
        expect(flow.shouldOfferRewarded, isFalse);
        expect(flow.consumeShareRight(), isTrue);
        expect(flow.consumeShareRight(), isTrue);
      }
    });
  });
}
