import 'package:islami_hayat/features/notifications/domain/daily_dua_notification_t0292.dart';
import 'package:islami_hayat/features/notifications/domain/notification_preferences.dart';

/// Reconciles the opt-in daily-dua notification when production wiring has a
/// reviewed local dua library available.
///
/// Like the verse reminder, the schedule is intentionally one-shot because
/// its deep link points to one specific reviewed dua record. Repeating that
/// payload forever would eventually open stale content. Reconciliation on app
/// launch refreshes the next future occurrence while preserving opt-out.
final class DailyDuaNotificationStartupT0292 {
  const DailyDuaNotificationStartupT0292({
    required NotificationPreferencesStore preferencesStore,
    required DailyDuaNotificationOrchestratorT0292 orchestrator,
  })  : _preferencesStore = preferencesStore,
        _orchestrator = orchestrator;

  final NotificationPreferencesStore _preferencesStore;
  final DailyDuaNotificationOrchestratorT0292 _orchestrator;

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
