import 'rewarded_share_unlock_t0269.dart';

/// Narrow boundary for the concrete rewarded-ad SDK presentation layer.
///
/// The platform adapter must translate its terminal callback into one of the
/// explicit product results. It must never grant access itself.
abstract interface class RewardedAdPresenterT0281 {
  Future<RewardedAdResultT0269> showForShareUnlock({
    required String designId,
  });
}

/// Connects the rewarded-ad terminal result to the single-share design gate.
///
/// This is intentionally fail-closed:
/// - PRO never sees or requests rewarded ads.
/// - Canva-001..003 never request rewarded ads.
/// - only a completed reward grants exactly one share.
/// - cancellation, no-fill, explicit failure and presenter exceptions grant
///   nothing and keep the design locked.
/// - an already-earned one-share right is never replaced by another ad request.
final class RewardedShareFlowT0281 {
  RewardedShareFlowT0281({
    required RewardedShareUnlockT0269 unlock,
    required RewardedAdPresenterT0281 presenter,
  })  : _unlock = unlock,
        _presenter = presenter;

  final RewardedShareUnlockT0269 _unlock;
  final RewardedAdPresenterT0281 _presenter;

  ShareUnlockDecisionT0269 get decision => _unlock.currentDecision();

  bool get shouldOfferRewarded => _unlock.shouldOfferRewarded;

  Future<ShareUnlockDecisionT0269> requestUnlock() async {
    final current = _unlock.currentDecision();

    if (current == ShareUnlockDecisionT0269.allowedFree ||
        current == ShareUnlockDecisionT0269.allowedPro ||
        current == ShareUnlockDecisionT0269.allowedSingleRewardedShare) {
      return current;
    }

    if (!_unlock.shouldOfferRewarded) {
      return ShareUnlockDecisionT0269.denied;
    }

    RewardedAdResultT0269 result;
    try {
      result = await _presenter.showForShareUnlock(
        designId: _unlock.designId,
      );
    } catch (_) {
      result = RewardedAdResultT0269.failed;
    }

    return _unlock.applyRewardedResult(result);
  }

  bool consumeShareRight() => _unlock.consumeSingleShareRight();
}
