import 'dart:async';

import 'package:flutter/material.dart';
import 'package:islami_hayat/core/storage/secure_private_user_store.dart';
import 'package:islami_hayat/features/notifications/data/android_local_notification_scheduler_t0291.dart';
import 'package:islami_hayat/features/notifications/data/secure_notification_preferences_store.dart';
import 'package:islami_hayat/features/notifications/domain/daily_verse_notification_t0291.dart';
import 'package:islami_hayat/features/notifications/domain/dhikr_reminder_t0293.dart';
import 'package:islami_hayat/features/notifications/domain/notification_preferences.dart';
import 'package:islami_hayat/features/notifications/presentation/notification_settings_page.dart';
import 'package:islami_hayat/features/premium/presentation/premium_value_page.dart';
import 'package:islami_hayat/features/profile/presentation/sources_licenses_page.dart';
import 'package:islami_hayat/features/today/data/daily_verse_repository.dart';
import 'package:islami_hayat/l10n/app_localizations.dart';

class ProfilePage extends StatelessWidget {
  const ProfilePage({
    super.key,
    this.notificationPreferencesStore,
    this.notificationPermissionRequester,
    this.notificationScheduleSync,
  });

  final NotificationPreferencesStore? notificationPreferencesStore;

  /// Injectable for widget tests. Production requests Android notification
  /// permission only after the user explicitly enables a notification category.
  final Future<bool> Function(NotificationCategory category)?
      notificationPermissionRequester;

  /// Injectable scheduling seam. Production wires verified/local notification
  /// coordinators to the Android scheduler. Isolated widget tests can inject a
  /// recorder without invoking platform channels.
  final Future<void> Function(
    NotificationPreferences preferences,
    String languageCode,
  )? notificationScheduleSync;

  @override
  Widget build(BuildContext context) {
    final l10n = AppLocalizations.of(context);
    final theme = Theme.of(context);
    final languageCode = Localizations.localeOf(context).languageCode;
    final notificationTitle = switch (languageCode) {
      'ar' => 'الإشعارات',
      'en' => 'Notifications',
      _ => 'Bildirimler',
    };
    final notificationSubtitle = switch (languageCode) {
      'ar' => 'تحكم بكل فئة بشكل مستقل. جميع الإشعارات اختيارية.',
      'en' =>
        'Control each category independently. All notifications are opt-in.',
      _ => 'Her kategoriyi ayrı yönet. Tüm bildirimler isteğe bağlıdır.',
    };

    return ListView(
      padding: const EdgeInsets.fromLTRB(20, 28, 20, 32),
      children: [
        Text(l10n.profileTitle, style: theme.textTheme.headlineMedium),
        const SizedBox(height: 8),
        Text(l10n.profileSubtitle, style: theme.textTheme.bodyLarge),
        const SizedBox(height: 28),
        Card(
          margin: EdgeInsets.zero,
          child: ListTile(
            minVerticalPadding: 16,
            leading: const Icon(Icons.notifications_none_outlined),
            title: Text(notificationTitle),
            subtitle: Text(notificationSubtitle),
            trailing: const Icon(Icons.chevron_right),
            onTap: () {
              final store = notificationPreferencesStore ??
                  SecureNotificationPreferencesStore(
                    SecurePrivateUserStore(),
                  );
              final injectedRequester = notificationPermissionRequester;
              final scheduler = injectedRequester == null
                  ? NotificationRuntimeT0291.instance.scheduler
                  : null;

              Future<void> syncSchedule(NotificationPreferences preferences) async {
                final injectedSync = notificationScheduleSync;
                if (injectedSync != null) {
                  await injectedSync(preferences, languageCode);
                  return;
                }
                if (injectedRequester != null) {
                  // Isolated widget tests that inject only permission handling
                  // intentionally avoid production platform channels.
                  return;
                }

                final dailyVerseCoordinator = DailyVerseNotificationCoordinatorT0291(
                  dailyVerseDataSource: DailyVerseRepository(),
                  preferencesStore: store,
                  scheduler: scheduler!,
                );
                await DailyVerseNotificationOrchestratorT0291(
                  coordinator: dailyVerseCoordinator,
                ).sync(
                  languageCode: languageCode,
                  preferences: preferences,
                );

                final dhikrCoordinator = DhikrReminderCoordinatorT0293(
                  preferencesStore: store,
                  scheduler: scheduler,
                );
                await DhikrReminderOrchestratorT0293(
                  coordinator: dhikrCoordinator,
                ).sync(
                  languageCode: languageCode,
                  preferences: preferences,
                );
              }

              Navigator.of(context).push(
                MaterialPageRoute<void>(
                  builder: (_) => NotificationSettingsPage(
                    store: store,
                    onEnableRequested: injectedRequester ??
                        (_) => scheduler!.requestUserPermission(),
                    onChanged: (preferences) {
                      unawaited(syncSchedule(preferences).catchError((Object _) {
                        // Preferences remain user-controlled. Scheduling is
                        // fail-closed and will be retried on the next explicit
                        // preference change/reconciliation pass.
                      }));
                    },
                  ),
                ),
              );
            },
          ),
        ),
        const SizedBox(height: 12),
        Card(
          margin: EdgeInsets.zero,
          child: ListTile(
            minVerticalPadding: 16,
            leading: const Icon(Icons.workspace_premium_outlined),
            title: Text(l10n.premiumProfileTitle),
            subtitle: Text(l10n.premiumProfileSubtitle),
            trailing: const Icon(Icons.chevron_right),
            onTap: () {
              Navigator.of(context).push(
                MaterialPageRoute<void>(
                  builder: (_) => const PremiumValuePage(),
                ),
              );
            },
          ),
        ),
        const SizedBox(height: 12),
        Card(
          margin: EdgeInsets.zero,
          child: ListTile(
            minVerticalPadding: 16,
            leading: const Icon(Icons.fact_check_outlined),
            title: Text(l10n.sourcesLicensesTitle),
            subtitle: Text(l10n.sourcesLicensesSubtitle),
            trailing: const Icon(Icons.chevron_right),
            onTap: () {
              Navigator.of(context).push(
                MaterialPageRoute<void>(
                  builder: (_) => const SourcesLicensesPage(),
                ),
              );
            },
          ),
        ),
      ],
    );
  }
}
