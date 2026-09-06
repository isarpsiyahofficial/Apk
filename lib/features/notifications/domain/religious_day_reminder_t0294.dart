import 'package:islami_hayat/features/notifications/domain/daily_verse_notification_t0291.dart';
import 'package:islami_hayat/features/notifications/domain/notification_preferences.dart';
import 'package:islami_hayat/features/religious_days/data/religious_date_metadata.dart';
import 'package:islami_hayat/features/religious_days/data/religious_day_notification_gate.dart';

const int religiousDayNotificationIdT0294 = 2904;
const int religiousDayReminderHourT0294 = 9;
const String religiousDayDeepLinkHostT0294 = 'religious-day';

abstract interface class ReligiousDayObservationSourceT0294 {
  Future<ReligiousDateObservation?> nextObservation({
    required DateTime now,
    required String countryCode,
  });
}

/// Production-safe default until a jurisdiction-specific official calendar
/// observation has been imported and reviewed. Never synthesizes a Hijri date.
final class EmptyReligiousDayObservationSourceT0294
    implements ReligiousDayObservationSourceT0294 {
  const EmptyReligiousDayObservationSourceT0294();

  @override
  Future<ReligiousDateObservation?> nextObservation({
    required DateTime now,
    required String countryCode,
  }) async => null;
}

final class ReligiousDayReminderCoordinatorT0294 {
  const ReligiousDayReminderCoordinatorT0294({
    required NotificationPreferencesStore preferencesStore,
    required LocalNotificationSchedulerT0291 scheduler,
    required ReligiousDayObservationSourceT0294 observationSource,
  })  : _preferencesStore = preferencesStore,
        _scheduler = scheduler,
        _observationSource = observationSource;

  final NotificationPreferencesStore _preferencesStore;
  final LocalNotificationSchedulerT0291 _scheduler;
  final ReligiousDayObservationSourceT0294 _observationSource;

  Future<void> sync({
    required DateTime now,
    required String languageCode,
    required String countryCode,
    NotificationPreferences? preferencesOverride,
  }) async {
    final preferences = preferencesOverride ?? await _preferencesStore.load();
    if (!preferences.religiousDay) {
      await _scheduler.cancel(religiousDayNotificationIdT0294);
      return;
    }

    _validateLocale(languageCode);
    final normalizedCountry = countryCode.trim().toUpperCase();
    if (normalizedCountry.length != 2) {
      await _scheduler.cancel(religiousDayNotificationIdT0294);
      return;
    }

    final observation = await _observationSource.nextObservation(
      now: now,
      countryCode: normalizedCountry,
    );
    final gate = ReligiousDayNotificationGate.evaluate(
      userOptedIn: true,
      observation: observation,
    );
    if (!gate.allowed ||
        observation == null ||
        observation.source.countryCode.toUpperCase() != normalizedCountry) {
      await _scheduler.cancel(religiousDayNotificationIdT0294);
      return;
    }

    final date = observation.gregorianDate;
    final scheduledAt = DateTime(
      date.year,
      date.month,
      date.day,
      religiousDayReminderHourT0294,
    );
    if (!scheduledAt.isAfter(now)) {
      await _scheduler.cancel(religiousDayNotificationIdT0294);
      return;
    }

    final copy = _copyFor(languageCode);
    final safeContentId = Uri.encodeComponent(observation.contentId);
    await _scheduler.schedule(
      LocalNotificationRequestT0291(
        id: religiousDayNotificationIdT0294,
        scheduledAt: scheduledAt,
        title: copy.title,
        body: copy.body,
        payload:
            '$notificationDeepLinkSchemeT0291://$religiousDayDeepLinkHostT0294/$safeContentId',
      ),
    );
  }

  static void _validateLocale(String languageCode) {
    if (languageCode != 'tr' && languageCode != 'en' && languageCode != 'ar') {
      throw UnsupportedError(
        'Unsupported religious-day reminder locale: $languageCode',
      );
    }
  }

  static _ReligiousDayReminderCopy _copyFor(String languageCode) =>
      switch (languageCode) {
        'ar' => const _ReligiousDayReminderCopy(
            title: 'تذكير بمناسبة دينية',
            body: 'افتح التطبيق للاطلاع على المعلومات والمصدر المحلي الموثق.',
          ),
        'en' => const _ReligiousDayReminderCopy(
            title: 'Religious day reminder',
            body: 'Open the app to review the information and verified local date source.',
          ),
        _ => const _ReligiousDayReminderCopy(
            title: 'Dini gün hatırlatıcısı',
            body: 'Bilgiyi ve doğrulanmış yerel tarih kaynağını görmek için uygulamayı aç.',
          ),
      };
}

final class _ReligiousDayReminderCopy {
  const _ReligiousDayReminderCopy({required this.title, required this.body});

  final String title;
  final String body;
}
