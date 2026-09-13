import 'package:islami_hayat/features/notifications/domain/dhikr_reminder_t0293.dart';
import 'package:islami_hayat/features/notifications/domain/notification_preferences.dart';

/// Reconciles the opt-in dhikr reminder from persisted notification settings.
///
/// The reminder is intentionally local-only and carries no prescribed count,
/// virtue, promise, sacred text, or source claim. Reconciliation on app launch
/// restores the next future occurrence after process death while preserving the
/// user's category-specific opt-out and selected local delivery time.
final class DhikrReminderStartupT0293 {
  const DhikrReminderStartupT0293({
    required NotificationPreferencesStore preferencesStore,
    required DhikrReminderOrchestratorT0293 orchestrator,
  })  : _preferencesStore = preferencesStore,
        _orchestrator = orchestrator;

  final NotificationPreferencesStore _preferencesStore;
  final DhikrReminderOrchestratorT0293 _orchestrator;

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
