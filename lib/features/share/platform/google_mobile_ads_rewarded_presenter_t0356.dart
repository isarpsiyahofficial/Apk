import 'dart:async';

import 'package:google_mobile_ads/google_mobile_ads.dart';

import '../domain/rewarded_share_flow_t0281.dart';
import '../domain/rewarded_share_unlock_t0269.dart';

/// Real Google Mobile Ads rewarded adapter for share-design unlocks.
///
/// The adapter is deliberately narrow: it translates SDK terminal callbacks
/// into the product-domain result and never grants an entitlement itself.
/// [RewardedShareFlowT0281] remains the only layer allowed to turn a completed
/// reward into one single-use share right.
final class GoogleMobileAdsRewardedPresenterT0356
    implements RewardedAdPresenterT0281 {
  GoogleMobileAdsRewardedPresenterT0356({
    required String adUnitId,
    AdRequest request = const AdRequest(),
  })  : adUnitId = adUnitId.trim(),
        request = request {
    if (this.adUnitId.isEmpty) {
      throw ArgumentError.value(adUnitId, 'adUnitId', 'Must not be blank.');
    }
  }

  final String adUnitId;
  final AdRequest request;

  @override
  Future<RewardedAdResultT0269> showForShareUnlock({
    required String designId,
  }) {
    // Validate the design identifier before any SDK/network activity. This
    // keeps malformed or out-of-range IDs fail-closed and observable in QA.
    RewardedShareUnlockT0269(designId: designId, isPro: false);

    final result = Completer<RewardedAdResultT0269>();

    void complete(RewardedAdResultT0269 value) {
      if (!result.isCompleted) result.complete(value);
    }

    RewardedAd.load(
      adUnitId: adUnitId,
      request: request,
      rewardedAdLoadCallback: RewardedAdLoadCallback(
        onAdLoaded: (ad) {
          var earnedReward = false;

          ad.fullScreenContentCallback = FullScreenContentCallback<RewardedAd>(
            onAdDismissedFullScreenContent: (shownAd) {
              shownAd.dispose();
              complete(
                earnedReward
                    ? RewardedAdResultT0269.completed
                    : RewardedAdResultT0269.cancelled,
              );
            },
            onAdFailedToShowFullScreenContent: (shownAd, _) {
              shownAd.dispose();
              complete(RewardedAdResultT0269.failed);
            },
          );

          try {
            ad.show(
              onUserEarnedReward: (_, __) {
                earnedReward = true;
              },
            );
          } on Object {
            ad.dispose();
            complete(RewardedAdResultT0269.failed);
          }
        },
        onAdFailedToLoad: (error) {
          // Google Mobile Ads uses code 3 for no-fill. Other load failures are
          // kept distinct so telemetry/QA cannot silently relabel a real SDK
          // integration error as an expected inventory miss.
          complete(
            error.code == 3
                ? RewardedAdResultT0269.noFill
                : RewardedAdResultT0269.failed,
          );
        },
      ),
    );

    return result.future;
  }
}
