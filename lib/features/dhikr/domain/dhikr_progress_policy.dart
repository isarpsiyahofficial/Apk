/// Product-level guardrails for dhikr progress surfaces.
///
/// SPEC 265-269 requires local personal progress without peer competition,
/// leaderboards, or guilt messaging for missed days. Any future dhikr UI must
/// ask this policy before exposing a progress surface.
enum DhikrProgressSurface {
  localDailyTotal,
  localWeeklyTotal,
  personalStreak,
  leaderboard,
  peerComparison,
  missedDayGuilt,
}

abstract final class DhikrProgressPolicy {
  static const Set<DhikrProgressSurface> allowedSurfaces = {
    DhikrProgressSurface.localDailyTotal,
    DhikrProgressSurface.localWeeklyTotal,
    DhikrProgressSurface.personalStreak,
  };

  static bool isAllowed(DhikrProgressSurface surface) =>
      allowedSurfaces.contains(surface);

  static void requireAllowed(DhikrProgressSurface surface) {
    if (!isAllowed(surface)) {
      throw StateError('Blocked dhikr progress surface: ${surface.name}');
    }
  }
}
