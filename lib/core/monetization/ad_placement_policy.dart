enum AdFormat { banner, interstitial, rewarded }

enum AppAdSurface {
  todayHome,
  quranReader,
  quranSearch,
  dailyVerse,
  duaReader,
  dhikrActive,
  shareDesignUnlock,
}

/// Single source of truth for where an advertisement may ever be requested.
///
/// Actual ad SDK integrations must call this policy before loading or showing
/// an ad. A sacred-content surface is fail-closed for every format, regardless
/// of FREE/PRO state. PRO suppression remains a separate, stricter entitlement
/// gate and will prevent ad SDK initialization/request paths altogether.
abstract final class AdPlacementPolicy {
  static bool isSacredContentSurface(AppAdSurface surface) {
    return switch (surface) {
      AppAdSurface.quranReader ||
      AppAdSurface.quranSearch ||
      AppAdSurface.dailyVerse ||
      AppAdSurface.duaReader ||
      AppAdSurface.dhikrActive => true,
      AppAdSurface.todayHome || AppAdSurface.shareDesignUnlock => false,
    };
  }

  static bool canRequest({
    required AppAdSurface surface,
    required AdFormat format,
    required bool isPro,
  }) {
    if (isPro) return false;
    if (isSacredContentSurface(surface)) return false;

    return switch ((surface, format)) {
      (AppAdSurface.todayHome, AdFormat.banner) => true,
      (AppAdSurface.shareDesignUnlock, AdFormat.rewarded) => true,
      _ => false,
    };
  }
}
