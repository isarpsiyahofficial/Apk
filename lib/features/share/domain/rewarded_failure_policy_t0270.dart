import 'rewarded_share_unlock_t0269.dart';

enum RewardedFailureSurfaceT0270 {
  cancelled,
  failed,
  noFill,
}

class RewardedFailureDecisionT0270 {
  const RewardedFailureDecisionT0270({
    required this.surface,
    required this.grantsShareRight,
    required this.canContinueReligiousContent,
    required this.canRetryRewarded,
    required this.shouldForcePro,
  });

  final RewardedFailureSurfaceT0270 surface;
  final bool grantsShareRight;
  final bool canContinueReligiousContent;
  final bool canRetryRewarded;
  final bool shouldForcePro;
}

/// T0270 policy boundary for unsuccessful rewarded-ad outcomes.
///
/// An unsuccessful ad may prevent use of the selected locked visual design,
/// but it must never become a gate in front of Quran/dua/dhikr content and must
/// never turn into a forced Lifetime PRO redirect.
class RewardedFailurePolicyT0270 {
  const RewardedFailurePolicyT0270();

  RewardedFailureDecisionT0270 evaluate(RewardedAdResultT0269 result) {
    switch (result) {
      case RewardedAdResultT0269.completed:
        throw ArgumentError.value(
          result,
          'result',
          'Completed rewards belong to the T0269 success path.',
        );
      case RewardedAdResultT0269.cancelled:
        return const RewardedFailureDecisionT0270(
          surface: RewardedFailureSurfaceT0270.cancelled,
          grantsShareRight: false,
          canContinueReligiousContent: true,
          canRetryRewarded: true,
          shouldForcePro: false,
        );
      case RewardedAdResultT0269.failed:
        return const RewardedFailureDecisionT0270(
          surface: RewardedFailureSurfaceT0270.failed,
          grantsShareRight: false,
          canContinueReligiousContent: true,
          canRetryRewarded: true,
          shouldForcePro: false,
        );
      case RewardedAdResultT0269.noFill:
        return const RewardedFailureDecisionT0270(
          surface: RewardedFailureSurfaceT0270.noFill,
          grantsShareRight: false,
          canContinueReligiousContent: true,
          canRetryRewarded: true,
          shouldForcePro: false,
        );
    }
  }
}
