enum ShareDesignTierT0269 { permanentFree, rewardedOrPro }

enum RewardedAdResultT0269 { completed, cancelled, failed, noFill }

enum ShareUnlockDecisionT0269 {
  allowedFree,
  allowedPro,
  rewardRequired,
  allowedSingleRewardedShare,
  denied,
}

class RewardedShareUnlockT0269 {
  RewardedShareUnlockT0269({required this.designId, required this.isPro}) {
    final designNumber = _parseDesignNumber(designId);
    tier = designNumber <= permanentFreeDesignCount
        ? ShareDesignTierT0269.permanentFree
        : ShareDesignTierT0269.rewardedOrPro;
  }

  static const int permanentFreeDesignCount = 3;
  static const int totalDesignCount = 100;

  final String designId;
  final bool isPro;
  late final ShareDesignTierT0269 tier;
  bool _singleShareRewardAvailable = false;

  bool get shouldOfferRewarded =>
      !isPro && tier == ShareDesignTierT0269.rewardedOrPro && !_singleShareRewardAvailable;

  ShareUnlockDecisionT0269 currentDecision() {
    if (isPro) return ShareUnlockDecisionT0269.allowedPro;
    if (tier == ShareDesignTierT0269.permanentFree) {
      return ShareUnlockDecisionT0269.allowedFree;
    }
    if (_singleShareRewardAvailable) {
      return ShareUnlockDecisionT0269.allowedSingleRewardedShare;
    }
    return ShareUnlockDecisionT0269.rewardRequired;
  }

  ShareUnlockDecisionT0269 applyRewardedResult(RewardedAdResultT0269 result) {
    if (isPro || tier == ShareDesignTierT0269.permanentFree) {
      return currentDecision();
    }

    if (result == RewardedAdResultT0269.completed) {
      _singleShareRewardAvailable = true;
      return ShareUnlockDecisionT0269.allowedSingleRewardedShare;
    }

    _singleShareRewardAvailable = false;
    return ShareUnlockDecisionT0269.denied;
  }

  bool consumeSingleShareRight() {
    if (isPro || tier == ShareDesignTierT0269.permanentFree) return true;
    if (!_singleShareRewardAvailable) return false;
    _singleShareRewardAvailable = false;
    return true;
  }

  static int _parseDesignNumber(String designId) {
    final match = RegExp(r'^Canva-(\d{3})$').firstMatch(designId);
    if (match == null) {
      throw ArgumentError.value(designId, 'designId', 'Expected Canva-001..Canva-100.');
    }
    final number = int.parse(match.group(1)!);
    if (number < 1 || number > totalDesignCount) {
      throw ArgumentError.value(designId, 'designId', 'Expected Canva-001..Canva-100.');
    }
    return number;
  }
}
