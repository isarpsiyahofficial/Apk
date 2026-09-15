import '../../features/premium/domain/entitlement_state_machine.dart';
import 'rewarded_share_unlock_t0269.dart';

/// V1 access contract for the 100 logical Canva share-design slots.
///
/// This class deliberately models entitlement only. A slot becoming accessible
/// here does not mean that its Canva asset passed the final license/hash gate.
/// Final asset readiness remains a separate release requirement.
final class ShareVisualAccessMatrixT0271 {
  const ShareVisualAccessMatrixT0271();

  static const int totalDesignCount = 100;
  static const int permanentlyFreeDesignCount = 3;
  static const int rewardedOrProDesignCount =
      totalDesignCount - permanentlyFreeDesignCount;

  String designIdForSlot(int slot) {
    _requireCanonicalSlot(slot);
    return 'share-design-${slot.toString().padLeft(3, '0')}';
  }

  bool isPermanentlyFree(int slot) {
    _requireCanonicalSlot(slot);
    return slot <= permanentlyFreeDesignCount;
  }

  bool isRewardedOrPro(int slot) {
    _requireCanonicalSlot(slot);
    return !isPermanentlyFree(slot);
  }

  ShareVisualAccessDecision evaluate({
    required int slot,
    required EntitlementState entitlement,
    RewardedShareGrant? rewardedGrant,
  }) {
    _requireCanonicalSlot(slot);

    if (entitlement.isPro) {
      return const ShareVisualAccessDecision._(
        allowed: true,
        mode: ShareVisualAccessMode.proUnlimited,
      );
    }

    if (isPermanentlyFree(slot)) {
      return const ShareVisualAccessDecision._(
        allowed: true,
        mode: ShareVisualAccessMode.freeUnlimited,
      );
    }

    if (rewardedGrant == null) {
      return const ShareVisualAccessDecision._(
        allowed: false,
        mode: ShareVisualAccessMode.rewardedRequired,
      );
    }

    final expectedDesignId = designIdForSlot(slot);
    if (rewardedGrant.designId != expectedDesignId || rewardedGrant.isConsumed) {
      return const ShareVisualAccessDecision._(
        allowed: false,
        mode: ShareVisualAccessMode.rewardedRequired,
      );
    }

    return const ShareVisualAccessDecision._(
      allowed: true,
      mode: ShareVisualAccessMode.rewardedSingleUse,
    );
  }

  ShareVisualAccessDecision consumeForShare({
    required int slot,
    required EntitlementState entitlement,
    RewardedShareGrant? rewardedGrant,
  }) {
    final decision = evaluate(
      slot: slot,
      entitlement: entitlement,
      rewardedGrant: rewardedGrant,
    );

    if (!decision.allowed) {
      throw StateError('Share design is not authorized for this user state.');
    }

    if (decision.mode == ShareVisualAccessMode.rewardedSingleUse) {
      rewardedGrant!.consumeForDesign(designIdForSlot(slot));
    }

    return decision;
  }

  void _requireCanonicalSlot(int slot) {
    if (slot < 1 || slot > totalDesignCount) {
      throw RangeError.range(slot, 1, totalDesignCount, 'slot');
    }
  }
}

enum ShareVisualAccessMode {
  freeUnlimited,
  rewardedRequired,
  rewardedSingleUse,
  proUnlimited,
}

final class ShareVisualAccessDecision {
  const ShareVisualAccessDecision._({
    required this.allowed,
    required this.mode,
  });

  final bool allowed;
  final ShareVisualAccessMode mode;
}
