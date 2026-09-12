import 'package:flutter_test/flutter_test.dart';
import 'package:islami_hayat/features/share/domain/rewarded_share_flow_t0281.dart';
import 'package:islami_hayat/features/share/domain/rewarded_share_unlock_t0269.dart';

final class _Presenter implements RewardedAdPresenterT0281 {
  _Presenter(this.result, {this.error});

  final RewardedAdResultT0269 result;
  final Object? error;
  int calls = 0;
  final List<String> designIds = <String>[];

  @override
  Future<RewardedAdResultT0269> showForShareUnlock({
    required String designId,
  }) async {
    calls += 1;
    designIds.add(designId);
    if (error != null) throw error!;
    return result;
  }
}

RewardedShareFlowT0281 _flow({
  required String designId,
  required bool isPro,
  required _Presenter presenter,
}) {
  return RewardedShareFlowT0281(
    unlock: RewardedShareUnlockT0269(designId: designId, isPro: isPro),
    presenter: presenter,
  );
}

void main() {
  group('RewardedShareFlowT0281', () {
    test('completed rewarded grants exactly one share then locks again', () async {
      final presenter = _Presenter(RewardedAdResultT0269.completed);
      final flow = _flow(
        designId: 'Canva-004',
        isPro: false,
        presenter: presenter,
      );

      expect(await flow.requestUnlock(),
          ShareUnlockDecisionT0269.allowedSingleRewardedShare);
      expect(presenter.calls, 1);
      expect(presenter.designIds, <String>['Canva-004']);

      expect(flow.consumeShareRight(), isTrue);
      expect(flow.consumeShareRight(), isFalse);
      expect(flow.decision, ShareUnlockDecisionT0269.rewardRequired);
    });

    test('cancel fail and no-fill never grant a share', () async {
      for (final result in <RewardedAdResultT0269>[
        RewardedAdResultT0269.cancelled,
        RewardedAdResultT0269.failed,
        RewardedAdResultT0269.noFill,
      ]) {
        final presenter = _Presenter(result);
        final flow = _flow(
          designId: 'Canva-100',
          isPro: false,
          presenter: presenter,
        );

        expect(await flow.requestUnlock(), ShareUnlockDecisionT0269.denied);
        expect(flow.consumeShareRight(), isFalse);
        expect(flow.shouldOfferRewarded, isTrue);
        expect(presenter.calls, 1);
      }
    });

    test('presenter exception fails closed and grants nothing', () async {
      final presenter = _Presenter(
        RewardedAdResultT0269.completed,
        error: StateError('sdk failure'),
      );
      final flow = _flow(
        designId: 'Canva-077',
        isPro: false,
        presenter: presenter,
      );

      expect(await flow.requestUnlock(), ShareUnlockDecisionT0269.denied);
      expect(flow.consumeShareRight(), isFalse);
      expect(flow.shouldOfferRewarded, isTrue);
      expect(presenter.calls, 1);
    });

    test('PRO bypasses rewarded presenter for locked designs', () async {
      final presenter = _Presenter(RewardedAdResultT0269.completed);
      final flow = _flow(
        designId: 'Canva-100',
        isPro: true,
        presenter: presenter,
      );

      expect(await flow.requestUnlock(), ShareUnlockDecisionT0269.allowedPro);
      expect(presenter.calls, 0);
      expect(flow.consumeShareRight(), isTrue);
      expect(flow.consumeShareRight(), isTrue);
    });

    test('permanent FREE designs bypass rewarded presenter', () async {
      final presenter = _Presenter(RewardedAdResultT0269.completed);
      final flow = _flow(
        designId: 'Canva-003',
        isPro: false,
        presenter: presenter,
      );

      expect(await flow.requestUnlock(), ShareUnlockDecisionT0269.allowedFree);
      expect(presenter.calls, 0);
      expect(flow.consumeShareRight(), isTrue);
    });

    test('earned right does not trigger a second ad before consumption', () async {
      final presenter = _Presenter(RewardedAdResultT0269.completed);
      final flow = _flow(
        designId: 'Canva-050',
        isPro: false,
        presenter: presenter,
      );

      expect(await flow.requestUnlock(),
          ShareUnlockDecisionT0269.allowedSingleRewardedShare);
      expect(await flow.requestUnlock(),
          ShareUnlockDecisionT0269.allowedSingleRewardedShare);
      expect(presenter.calls, 1);
      expect(flow.consumeShareRight(), isTrue);
    });
  });
}
