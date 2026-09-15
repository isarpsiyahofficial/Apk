import 'package:islami_hayat/features/notifications/domain/notification_preferences.dart';
import 'package:islami_hayat/features/notifications/domain/religious_day_reminder_t0294.dart';

/// Restores the persisted religious-day reminder without synthesizing a Hijri
/// date. Scheduling is delegated to the T0294 coordinator, which requires a
/// jurisdiction-scoped confirmed observation with pinned official evidence.
final class ReligiousDayReminderStartupT0294 {
  const ReligiousDayReminderStartupT0294({
    required NotificationPreferencesStore preferencesStore,
    required ReligiousDayReminderCoordinatorT0294 coordinator,
  })  : _preferencesStore = preferencesStore,
        _coordinator = coordinator;

  final NotificationPreferencesStore _preferencesStore;
  final ReligiousDayReminderCoordinatorT0294 _coordinator;

  Future<void> reconcile({
    required DateTime now,
    required String languageCode,
    required String countryCode,
  }) async {
    final preferences = await _preferencesStore.load();
    await _coordinator.sync(
      now: now,
      languageCode: _supportedLanguage(languageCode),
      countryCode: countryCode,
      preferencesOverride: preferences,
    );
  }

  static String _supportedLanguage(String languageCode) {
    return switch (languageCode) {
      'tr' || 'en' || 'ar' => languageCode,
      _ => 'tr',
    };
  }
}
