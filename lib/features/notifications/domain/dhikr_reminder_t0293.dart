import 'package:islami_hayat/features/notifications/domain/daily_verse_notification_t0291.dart';
import 'package:islami_hayat/features/notifications/domain/notification_preferences.dart';

const int dhikrReminderNotificationIdT0293 = 2903;
const int dhikrReminderDefaultHourT0293 = 20;
const String dhikrReminderDeepLinkHostT0293 = 'dhikr';

/// Accepts only the exact app-local dhikr notification route.
///
/// Query parameters, fragments, user-info, ports, and path segments are
/// intentionally rejected so a notification payload cannot smuggle state into
/// the dhikr surface. Navigation still goes through AppShell's FREE reachability
/// gate after this parser succeeds.
bool isCanonicalDhikrReminderDeepLinkT0293(String payload) {
  final Uri uri;
  try {
    uri = Uri.parse(payload);
  } on FormatException {
    return false;
  }

  return uri.scheme == notificationDeepLinkSchemeT0291 &&
      uri.host == dhikrReminderDeepLinkHostT0293 &&
      uri.userInfo.isEmpty &&
      !uri.hasPort &&
      uri.pathSegments.isEmpty &&
      uri.query.isEmpty &&
      uri.fragment.isEmpty;
}

/// Local-only reminder for the user's optional dhikr practice.
///
/// The OS notification intentionally carries no prescribed count, claimed
/// virtue, promise, sacred text, or source claim. It only opens the existing
/// dhikr surface. This keeps T0293 independent from source-backed dhikr counts
/// and prevents a generic reminder from being mistaken for a Sunnah claim.
final class DhikrReminderCoordinatorT0293 {
  const DhikrReminderCoordinatorT0293({
    required NotificationPreferencesStore preferencesStore,
    required LocalNotificationSchedulerT0291 scheduler,
  })  : _preferencesStore = preferencesStore,
        _scheduler = scheduler;

  final NotificationPreferencesStore _preferencesStore;
  final LocalNotificationSchedulerT0291 _scheduler;

  Future<void> syncForDate({
    required DateTime civilDate,
    required DateTime scheduledAt,
    required String languageCode,
    NotificationPreferences? preferencesOverride,
  }) async {
    final preferences = preferencesOverride ?? await _preferencesStore.load();
    if (!preferences.dhikrReminder) {
      await _scheduler.cancel(dhikrReminderNotificationIdT0293);
      return;
    }

    _validateLocale(languageCode);
    _validateSchedule(civilDate: civilDate, scheduledAt: scheduledAt);
    final copy = _copyFor(languageCode);

    await _scheduler.schedule(
      LocalNotificationRequestT0291(
        id: dhikrReminderNotificationIdT0293,
        scheduledAt: scheduledAt,
        title: copy.title,
        body: copy.body,
        payload: '$notificationDeepLinkSchemeT0291://$dhikrReminderDeepLinkHostT0293',
      ),
    );
  }

  static void _validateLocale(String languageCode) {
    if (languageCode != 'tr' && languageCode != 'en' && languageCode != 'ar') {
      throw UnsupportedError(
        'Unsupported dhikr reminder locale: $languageCode',
      );
    }
  }

  static void _validateSchedule({
    required DateTime civilDate,
    required DateTime scheduledAt,
  }) {
    final sameCivilDay = civilDate.year == scheduledAt.year &&
        civilDate.month == scheduledAt.month &&
        civilDate.day == scheduledAt.day;
    if (!sameCivilDay) {
      throw ArgumentError.value(
        scheduledAt,
        'scheduledAt',
        'Dhikr reminder must be scheduled for the same civil date.',
      );
    }
  }

  static _DhikrReminderCopy _copyFor(String languageCode) => switch (languageCode) {
        'ar' => const _DhikrReminderCopy(
            title: 'تذكير الذكر',
            body: 'افتح قسم الذكر عندما يناسبك.',
          ),
        'en' => const _DhikrReminderCopy(
            title: 'Dhikr reminder',
            body: 'Open your dhikr space when it suits you.',
          ),
        _ => const _DhikrReminderCopy(
            title: 'Zikir hatırlatıcısı',
            body: 'Uygun olduğunda zikir alanını aç.',
          ),
      };
}

final class DhikrReminderOrchestratorT0293 {
  const DhikrReminderOrchestratorT0293({
    required DhikrReminderCoordinatorT0293 coordinator,
    DateTime Function()? now,
    this.deliveryHour = dhikrReminderDefaultHourT0293,
  })  : _coordinator = coordinator,
        _now = now ?? DateTime.now;

  final DhikrReminderCoordinatorT0293 _coordinator;
  final DateTime Function() _now;
  final int deliveryHour;

  Future<void> sync({
    required String languageCode,
    required NotificationPreferences preferences,
  }) async {
    if (deliveryHour < 0 || deliveryHour > 23) {
      throw StateError('Dhikr reminder delivery hour must be between 0 and 23.');
    }

    final now = _now();
    var civilDate = DateTime(now.year, now.month, now.day);
    var scheduledAt = DateTime(
      civilDate.year,
      civilDate.month,
      civilDate.day,
      deliveryHour,
    );
    if (!scheduledAt.isAfter(now)) {
      civilDate = civilDate.add(const Duration(days: 1));
      scheduledAt = DateTime(
        civilDate.year,
        civilDate.month,
        civilDate.day,
        deliveryHour,
      );
    }

    await _coordinator.syncForDate(
      civilDate: civilDate,
      scheduledAt: scheduledAt,
      languageCode: languageCode,
      preferencesOverride: preferences,
    );
  }
}

final class _DhikrReminderCopy {
  const _DhikrReminderCopy({required this.title, required this.body});

  final String title;
  final String body;
}
