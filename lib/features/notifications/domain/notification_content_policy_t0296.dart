/// Content exposure classification for local notifications.
///
/// The generic notification pipeline is intentionally teaser/reference-only.
/// Full religious text or Premium-only rendered content must never be added to
/// that pipeline because a previously scheduled notification can be delivered
/// while a FREE user is offline. A future expanded-PRO path must be explicitly
/// entitlement-aware at schedule time and must not reuse the generic scheduler.
enum NotificationContentExposureT0296 {
  teaserReferenceOnly,
  expandedPremiumContent,
}

abstract final class NotificationContentPolicyT0296 {
  static bool isSafeForGenericLocalScheduler(
    NotificationContentExposureT0296 exposure,
  ) =>
      exposure == NotificationContentExposureT0296.teaserReferenceOnly;

  static void requireSafeForGenericLocalScheduler(
    NotificationContentExposureT0296 exposure,
  ) {
    if (!isSafeForGenericLocalScheduler(exposure)) {
      throw StateError(
        'Expanded Premium notification content requires a dedicated '
        'entitlement-aware scheduling path.',
      );
    }
  }
}
