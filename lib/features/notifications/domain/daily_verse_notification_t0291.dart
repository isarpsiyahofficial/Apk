import 'package:islami_hayat/features/notifications/domain/notification_content_policy_t0296.dart';
import 'package:islami_hayat/features/notifications/domain/notification_preferences.dart';
import 'package:islami_hayat/features/quran/data/canonical_quran_source.dart';
import 'package:islami_hayat/features/quran/data/quran_search_repository.dart';
import 'package:islami_hayat/features/today/data/daily_verse_repository.dart';

const int dailyVerseNotificationIdT0291 = 2901;
const String notificationDeepLinkSchemeT0291 = 'islami-hayat';
const String notificationQuranDeepLinkHostT0291 = 'quran';
const int dailyVerseDefaultHourT0291 = 9;

final class LocalNotificationRequestT0291 {
  const LocalNotificationRequestT0291({
    required this.id,
    required this.scheduledAt,
    required this.title,
    required this.body,
    required this.payload,
    this.contentExposure =
        NotificationContentExposureT0296.teaserReferenceOnly,
  });

  final int id;
  final DateTime scheduledAt;
  final String title;
  final String body;
  final String payload;
  final NotificationContentExposureT0296 contentExposure;
}

abstract interface class LocalNotificationSchedulerT0291 {
  Future<void> schedule(LocalNotificationRequestT0291 request);

  Future<void> cancel(int id);
}

/// Small lifecycle bridge for notification taps.
///
/// It intentionally stores only the most recent app-local deep-link payload;
/// no religious text, note, history, user identifier, or analytics data is
/// retained. Listeners are notified for repeated identical payloads as well.
final class NotificationTapControllerT0291 {
  final Set<void Function()> _listeners = <void Function()>{};
  String? _pendingPayload;

  void emit(String payload) {
    final normalized = payload.trim();
    if (normalized.isEmpty) return;
    _pendingPayload = normalized;
    for (final listener in List<void Function()>.of(_listeners)) {
      listener();
    }
  }

  String? takePendingPayload() {
    final payload = _pendingPayload;
    _pendingPayload = null;
    return payload;
  }

  void addListener(void Function() listener) => _listeners.add(listener);

  void removeListener(void Function() listener) => _listeners.remove(listener);
}

/// Parses only the canonical Quran notification route produced by this app.
/// Everything else is rejected instead of being forwarded into navigation.
QuranAddress? parseNotificationQuranDeepLinkT0291(String payload) {
  final Uri uri;
  try {
    uri = Uri.parse(payload);
  } on FormatException {
    return null;
  }

  if (uri.scheme != notificationDeepLinkSchemeT0291 ||
      uri.host != notificationQuranDeepLinkHostT0291 ||
      uri.query.isNotEmpty ||
      uri.fragment.isNotEmpty ||
      uri.pathSegments.length != 2) {
    return null;
  }

  final surah = int.tryParse(uri.pathSegments[0]);
  final ayah = int.tryParse(uri.pathSegments[1]);
  if (surah == null || ayah == null) return null;
  if (surah < 1 || surah > canonicalQuranSuraCount) return null;
  if (ayah < 1 || ayah > canonicalQuranAyahCountForSura(surah)) return null;

  return QuranAddress(surah: surah, ayah: ayah);
}

final class DailyVerseNotificationCoordinatorT0291 {
  const DailyVerseNotificationCoordinatorT0291({
    required DailyVerseDataSource dailyVerseDataSource,
    required NotificationPreferencesStore preferencesStore,
    required LocalNotificationSchedulerT0291 scheduler,
  })  : _dailyVerseDataSource = dailyVerseDataSource,
        _preferencesStore = preferencesStore,
        _scheduler = scheduler;

  final DailyVerseDataSource _dailyVerseDataSource;
  final NotificationPreferencesStore _preferencesStore;
  final LocalNotificationSchedulerT0291 _scheduler;

  Future<void> syncForDate({
    required DateTime civilDate,
    required DateTime scheduledAt,
    required String languageCode,
    NotificationPreferences? preferencesOverride,
  }) async {
    final preferences = preferencesOverride ?? await _preferencesStore.load();
    if (!preferences.dailyVerse) {
      await _scheduler.cancel(dailyVerseNotificationIdT0291);
      return;
    }

    _validateLocale(languageCode);
    _validateSchedule(civilDate: civilDate, scheduledAt: scheduledAt);

    final verse = await _dailyVerseDataSource.forDate(
      date: civilDate,
      languageCode: languageCode,
    );

    final copy = _copyFor(languageCode, verse.sourceLabel);
    await _scheduler.schedule(
      LocalNotificationRequestT0291(
        id: dailyVerseNotificationIdT0291,
        scheduledAt: scheduledAt,
        title: copy.title,
        body: copy.body,
        payload: '$notificationDeepLinkSchemeT0291://'
            '$notificationQuranDeepLinkHostT0291/'
            '${verse.address.surah}/${verse.address.ayah}',
      ),
    );
  }

  static void _validateLocale(String languageCode) {
    if (languageCode != 'tr' && languageCode != 'en' && languageCode != 'ar') {
      throw UnsupportedError(
        'Unsupported daily verse notification locale: $languageCode',
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
        'Daily verse notification must be scheduled for the same civil date.',
      );
    }
  }

  static _DailyVerseNotificationCopy _copyFor(
    String languageCode,
    String sourceLabel,
  ) =>
      switch (languageCode) {
        'ar' => _DailyVerseNotificationCopy(
            title: 'آية اليوم',
            body: 'افتح آية اليوم من مصدر القرآن الموثّق: $sourceLabel',
          ),
        'en' => _DailyVerseNotificationCopy(
            title: 'Verse of the day',
            body: 'Open today’s verse from the verified Quran source: $sourceLabel',
          ),
        _ => _DailyVerseNotificationCopy(
            title: 'Günün Ayeti',
            body: 'Bugünün ayetini doğrulanmış Kur’an kaynağından aç: $sourceLabel',
          ),
      };
}

/// Production scheduling policy for the daily-verse reminder.
///
/// The reminder uses a stable local 09:00 default. Enabling it before 09:00
/// schedules the current civil day's verified verse; enabling it at/after
/// 09:00 schedules the next civil day's verse so no stale/past notification is
/// submitted to Android. A preference override is used during an explicit UI
/// toggle so scheduling reflects the user's new choice before persistence
/// finishes; if persistence rolls back, the UI emits the previous preference
/// again and this policy cancels/reschedules accordingly.
final class DailyVerseNotificationOrchestratorT0291 {
  const DailyVerseNotificationOrchestratorT0291({
    required DailyVerseNotificationCoordinatorT0291 coordinator,
    DateTime Function()? now,
    this.deliveryHour = dailyVerseDefaultHourT0291,
  })  : _coordinator = coordinator,
        _now = now ?? DateTime.now;

  final DailyVerseNotificationCoordinatorT0291 _coordinator;
  final DateTime Function() _now;
  final int deliveryHour;

  Future<void> sync({
    required String languageCode,
    required NotificationPreferences preferences,
  }) async {
    if (deliveryHour < 0 || deliveryHour > 23) {
      throw StateError('Daily verse delivery hour must be between 0 and 23.');
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

final class _DailyVerseNotificationCopy {
  const _DailyVerseNotificationCopy({
    required this.title,
    required this.body,
  });

  final String title;
  final String body;
}
