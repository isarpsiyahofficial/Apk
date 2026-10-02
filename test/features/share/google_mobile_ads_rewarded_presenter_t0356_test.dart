import 'package:flutter_test/flutter_test.dart';
import 'package:google_mobile_ads/google_mobile_ads.dart';
import 'package:islami_hayat/features/share/domain/rewarded_share_unlock_t0269.dart';
import 'package:islami_hayat/features/share/platform/google_mobile_ads_rewarded_presenter_t0356.dart';

void main() {
  group('GoogleMobileAdsRewardedPresenterT0356', () {
    for (final scenario in <RewardedSdkTerminalT0356, RewardedAdResultT0269>{
      RewardedSdkTerminalT0356.earnedAndDismissed:
          RewardedAdResultT0269.completed,
      RewardedSdkTerminalT0356.dismissedWithoutReward:
          RewardedAdResultT0269.cancelled,
      RewardedSdkTerminalT0356.noFill: RewardedAdResultT0269.noFill,
      RewardedSdkTerminalT0356.failed: RewardedAdResultT0269.failed,
    }.entries) {
      test('${scenario.key} maps to ${scenario.value}', () async {
        final driver = _FakeRewardedDriver(scenario.key);
        final presenter = GoogleMobileAdsRewardedPresenterT0356(
          adUnitId: 'test-rewarded-unit',
          driver: driver,
        );

        final result = await presenter.showForShareUnlock(
          designId: 'Canva-004',
        );

        expect(result, scenario.value);
        expect(driver.calls, 1);
        expect(driver.lastAdUnitId, 'test-rewarded-unit');
      });
    }

    test('malformed design fails before SDK/network dispatch', () async {
      final driver = _FakeRewardedDriver(
        RewardedSdkTerminalT0356.earnedAndDismissed,
      );
      final presenter = GoogleMobileAdsRewardedPresenterT0356(
        adUnitId: 'test-rewarded-unit',
        driver: driver,
      );

      await expectLater(
        presenter.showForShareUnlock(designId: 'Canva-101'),
        throwsArgumentError,
      );
      expect(driver.calls, 0);
    });

    test('blank ad unit id is rejected fail-closed', () {
      expect(
        () => GoogleMobileAdsRewardedPresenterT0356(
          adUnitId: '   ',
          driver: _FakeRewardedDriver(RewardedSdkTerminalT0356.failed),
        ),
        throwsArgumentError,
      );
    });
  });
}

final class _FakeRewardedDriver implements RewardedAdDriverT0356 {
  _FakeRewardedDriver(this.terminal);

  final RewardedSdkTerminalT0356 terminal;
  int calls = 0;
  String? lastAdUnitId;

  @override
  Future<RewardedSdkTerminalT0356> present({
    required String adUnitId,
    required AdRequest request,
  }) async {
    calls += 1;
    lastAdUnitId = adUnitId;
    return terminal;
  }
}
