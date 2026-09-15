import 'dart:async';

import 'package:google_mobile_ads/google_mobile_ads.dart';

import '../domain/rewarded_share_flow_t0281.dart';
import '../domain/rewarded_share_unlock_t0269.dart';

enum RewardedSdkTerminalT0356 {
  earnedAndDismissed,
  dismissedWithoutReward,
  noFill,
  failed,
}

abstract interface class RewardedAdDriverT0356 {
  Future<RewardedSdkTerminalT0356> present({
    required String adUnitId,
    required AdRequest request,
  });
}

/// Production Google Mobile Ads driver. It does not grant product access; it
/// only reports the terminal SDK outcome to the product-domain presenter.
final class GoogleMobileAdsRewardedDriverT0356 implements RewardedAdDriverT0356 {
  const GoogleMobileAdsRewardedDriverT0356();

  @override
  Future<RewardedSdkTerminalT0356> present({
    required String adUnitId,
    required AdRequest request,
  }) {
    final result = Completer<RewardedSdkTerminalT0356>();

    void complete(RewardedSdkTerminalT0356 value) {
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
                    ? RewardedSdkTerminalT0356.earnedAndDismissed
                    : RewardedSdkTerminalT0356.dismissedWithoutReward,
              );
            },
            onAdFailedToShowFullScreenContent: (shownAd, _) {
              shownAd.dispose();
              complete(RewardedSdkTerminalT0356.failed);
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
            complete(RewardedSdkTerminalT0356.failed);
          }
        },
        onAdFailedToLoad: (error) {
          // Google Mobile Ads error code 3 is the SDK's no-fill condition.
          // Every other load failure remains an explicit integration failure.
          complete(
            error.code == 3
                ? RewardedSdkTerminalT0356.noFill
                : RewardedSdkTerminalT0356.failed,
          );
        },
      ),
    );

    return result.future;
  }
}

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
    this.request = const AdRequest(),
    RewardedAdDriverT0356 driver = const GoogleMobileAdsRewardedDriverT0356(),
  })  : adUnitId = adUnitId.trim(),
        _driver = driver {
    if (this.adUnitId.isEmpty) {
      throw ArgumentError.value(adUnitId, 'adUnitId', 'Must not be blank.');
    }
  }

  final String adUnitId;
  final AdRequest request;
  final RewardedAdDriverT0356 _driver;

  @override
  Future<RewardedAdResultT0269> showForShareUnlock({
    required String designId,
  }) async {
    // Validate the design identifier before any SDK/network activity. This
    // keeps malformed or out-of-range IDs fail-closed and observable in QA.
    RewardedShareUnlockT0269(designId: designId, isPro: false);

    final terminal = await _driver.present(
      adUnitId: adUnitId,
      request: request,
    );

    return switch (terminal) {
      RewardedSdkTerminalT0356.earnedAndDismissed =>
        RewardedAdResultT0269.completed,
      RewardedSdkTerminalT0356.dismissedWithoutReward =>
        RewardedAdResultT0269.cancelled,
      RewardedSdkTerminalT0356.noFill => RewardedAdResultT0269.noFill,
      RewardedSdkTerminalT0356.failed => RewardedAdResultT0269.failed,
    };
  }
}
