import 'package:islami_hayat/features/notifications/domain/daily_verse_notification_t0291.dart';
import 'package:islami_hayat/features/notifications/domain/notification_preferences.dart';

/// Reconciles the opt-in daily-verse notification whenever the application
/// starts successfully enough to access local preferences and the Android
/// notification scheduler.
///
/// The OS schedule is intentionally one-shot because its payload points to a
/// specific verified verse. Repeating the same payload indefinitely would
/// eventually open a stale verse. Reconciliation on every app launch refreshes
/// the next future occurrence while still allowing that local notification to
/// fire when the app is closed.
final class DailyVerseNotificationStartupT0291 {
  const DailyVerseNotificationStartupT0291({
    required NotificationPreferencesStore preferencesStore,
    required DailyVerseNotificationOrchestratorT0291 orchestrator,
  })  : _preferencesStore = preferencesStore,
        _orchestrator = orchestrator;

  final NotificationPreferencesStore _preferencesStore;
  final DailyVerseNotificationOrchestratorT0291 _orchestrator;

  Future<void> reconcile({required String languageCode}) async {
    final preferences = await _preferencesStore.load();
    await _orchestrator.sync(
      languageCode: _supportedLanguage(languageCode),
      preferences: preferences,
    );
  }

  static String _supportedLanguage(String languageCode) {
    return switch (languageCode) {
      'tr' || 'en' || 'ar' => languageCode,
      _ => 'tr',
    };
  }
}
