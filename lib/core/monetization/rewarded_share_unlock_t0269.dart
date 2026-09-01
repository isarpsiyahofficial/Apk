import '../../features/premium/domain/entitlement_state_machine.dart';
import 'ad_placement_policy.dart';
import 'entitlement_gated_ad_sdk.dart';

/// Product contract for the opt-in rewarded share-design flow.
///
/// The presentation layer must localize [disclosureKey] to copy that explicitly
/// communicates: complete one ad -> receive one share with this design.
final class RewardedShareUnlockPrompt {
  const RewardedShareUnlockPrompt({
    required this.designId,
    required this.disclosureKey,
    required this.shareUsesGrantedOnCompletion,
  });

  final String designId;
  final String disclosureKey;
  final int shareUsesGrantedOnCompletion;
}

/// Single-use capability created only after the rewarded ad completion callback.
///
/// It is deliberately bound to one design. It cannot unlock another design and
/// it cannot be consumed twice.
final class RewardedShareGrant {
  RewardedShareGrant._({required this.designId});

  final String designId;
  bool _consumed = false;

  bool get isConsumed => _consumed;
  int get remainingUses => _consumed ? 0 : 1;

  void consumeForDesign(String requestedDesignId) {
    if (_consumed) {
      throw StateError('Rewarded share grant has already been consumed.');
    }
    if (requestedDesignId != designId) {
      throw StateError('Rewarded share grant is bound to a different design.');
    }
    _consumed = true;
  }
}

enum RewardedAdTerminalOutcome { completed, cancelled, failed, noFill }

/// Terminal result for T0270 failure paths and the T0269 success path.
///
/// Failed/cancelled/no-fill outcomes deliberately keep religious content
/// available and never request a forced PRO upsell. They only deny the premium
/// visual-design use that depended on completing the optional ad.
final class RewardedShareTerminalResult {
  const RewardedShareTerminalResult._({
    required this.outcome,
    required this.grant,
    required this.messageLocalizationKey,
  });

  final RewardedAdTerminalOutcome outcome;
  final RewardedShareGrant? grant;
  final String? messageLocalizationKey;

  bool get hasGrant => grant != null;
  bool get religiousContentRemainsAvailable => true;
  bool get shouldForceProPurchase => false;
}

/// Orchestrates the opt-in rewarded design-unlock flow without granting
/// religious content or changing entitlement. Rewarded unlocks affect only
/// visual-design usage.
final class RewardedShareUnlockT0269 {
  RewardedShareUnlockT0269({
    required EntitlementGatedAdSdkCoordinator adCoordinator,
  }) : _adCoordinator = adCoordinator;

  static const disclosureLocalizationKey = 'rewardedShareOneUseDisclosure';
  static const cancelledLocalizationKey = 'rewardedShareCancelled';
  static const failedLocalizationKey = 'rewardedShareFailed';
  static const noFillLocalizationKey = 'rewardedShareNoFill';
  static const shareUsesPerCompletedReward = 1;

  final EntitlementGatedAdSdkCoordinator _adCoordinator;
  String? _activeDesignId;

  RewardedShareUnlockPrompt begin({
    required String designId,
    required bool isDesignLocked,
    required EntitlementState entitlement,
  }) {
    final normalizedDesignId = designId.trim();
    if (normalizedDesignId.isEmpty) {
      throw ArgumentError.value(designId, 'designId', 'must not be empty');
    }
    if (!isDesignLocked) {
      throw StateError('Rewarded flow is only for a locked share design.');
    }
    if (entitlement.isPro) {
      throw StateError('PRO users must not be asked to watch a rewarded ad.');
    }

    _adCoordinator.requireAdRequestAllowedFor(
      entitlement: entitlement,
      surface: AppAdSurface.shareDesignUnlock,
      format: AdFormat.rewarded,
    );

    _activeDesignId = normalizedDesignId;
    return RewardedShareUnlockPrompt(
      designId: normalizedDesignId,
      disclosureKey: disclosureLocalizationKey,
      shareUsesGrantedOnCompletion: shareUsesPerCompletedReward,
    );
  }

  RewardedShareTerminalResult finish({
    required String designId,
    required RewardedAdTerminalOutcome outcome,
  }) {
    final normalizedDesignId = designId.trim();
    final activeDesignId = _activeDesignId;
    _activeDesignId = null;

    if (activeDesignId == null || activeDesignId != normalizedDesignId) {
      throw StateError('Rewarded result does not match the active design.');
    }

    return switch (outcome) {
      RewardedAdTerminalOutcome.completed => RewardedShareTerminalResult._(
          outcome: outcome,
          grant: RewardedShareGrant._(designId: activeDesignId),
          messageLocalizationKey: null,
        ),
      RewardedAdTerminalOutcome.cancelled => RewardedShareTerminalResult._(
          outcome: outcome,
          grant: null,
          messageLocalizationKey: cancelledLocalizationKey,
        ),
      RewardedAdTerminalOutcome.failed => RewardedShareTerminalResult._(
          outcome: outcome,
          grant: null,
          messageLocalizationKey: failedLocalizationKey,
        ),
      RewardedAdTerminalOutcome.noFill => RewardedShareTerminalResult._(
          outcome: outcome,
          grant: null,
          messageLocalizationKey: noFillLocalizationKey,
        ),
    };
  }

  RewardedShareGrant complete({
    required String designId,
    required bool adCompleted,
  }) {
    if (!adCompleted) {
      final activeDesignId = _activeDesignId;
      _activeDesignId = null;
      if (activeDesignId == null || activeDesignId != designId.trim()) {
        throw StateError('Reward completion does not match the active design.');
      }
      throw StateError('Rewarded ad did not complete; no share grant created.');
    }

    final result = finish(
      designId: designId,
      outcome: RewardedAdTerminalOutcome.completed,
    );
    return result.grant!;
  }
}
