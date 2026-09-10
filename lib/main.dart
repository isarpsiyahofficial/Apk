import 'dart:async';

import 'package:flutter/widgets.dart';
import 'package:islami_hayat/app.dart';
import 'package:islami_hayat/core/network/internet_reachability.dart';
import 'package:islami_hayat/core/storage/secure_private_user_store.dart';
import 'package:islami_hayat/features/notifications/data/android_local_notification_scheduler_t0291.dart';
import 'package:islami_hayat/features/notifications/data/daily_verse_notification_startup_t0291.dart';
import 'package:islami_hayat/features/notifications/data/dhikr_reminder_startup_t0293.dart';
import 'package:islami_hayat/features/notifications/data/religious_day_reminder_startup_t0294.dart';
import 'package:islami_hayat/features/notifications/data/secure_notification_preferences_store.dart';
import 'package:islami_hayat/features/notifications/domain/daily_verse_notification_t0291.dart';
import 'package:islami_hayat/features/notifications/domain/dhikr_reminder_t0293.dart';
import 'package:islami_hayat/features/notifications/domain/religious_day_reminder_t0294.dart';
import 'package:islami_hayat/features/premium/domain/secure_entitlement_cache_t0277.dart';
import 'package:islami_hayat/features/today/data/daily_verse_repository.dart';

Future<void> main() async {
  WidgetsFlutterBinding.ensureInitialized();

  // Entitlement restore is startup-critical: an offline PRO user must never
  // flash or fall back to FREE while the secure local entitlement is loading.
  final initialEntitlement = await SecureEntitlementCacheT0277().restoreOffline();
  final verifier = InternetReachabilityVerifier(
    client: const IoInternetProbeClient(),
  );
  final notificationRuntime = NotificationRuntimeT0291.instance;

  runApp(
    IslamiHayatApp(
      startupAccessVerifier: verifier,
      initialEntitlement: initialEntitlement,
      notificationTapController: notificationRuntime.tapController,
    ),
  );

  // T0315: notification plugin/channel initialization and reminder restoration
  // are not required to paint the first frame. Defer them until Flutter has
  // rendered once so slow platform I/O cannot hold the launch screen hostage.
  // NotificationRuntime keeps the initial launch payload pending until the app
  // consumes it, so notification deep links remain lossless after deferral.
  WidgetsBinding.instance.addPostFrameCallback((_) {
    unawaited(_restoreNotificationsAfterFirstFrame(notificationRuntime));
  });
}

Future<void> _restoreNotificationsAfterFirstFrame(
  NotificationRuntimeT0291 notificationRuntime,
) async {
  try {
    await notificationRuntime.initialize();

    final preferencesStore = SecureNotificationPreferencesStore(
      SecurePrivateUserStore(),
    );
    final platformLocale = WidgetsBinding.instance.platformDispatcher.locale;
    final languageCode = platformLocale.languageCode;

    // Each category reconciles independently. A Quran/data failure in the
    // daily-verse path must not suppress the user's unrelated reminders.
    try {
      final dailyVerseCoordinator = DailyVerseNotificationCoordinatorT0291(
        dailyVerseDataSource: DailyVerseRepository(),
        preferencesStore: preferencesStore,
        scheduler: notificationRuntime.scheduler,
      );
      final startupReconciler = DailyVerseNotificationStartupT0291(
        preferencesStore: preferencesStore,
        orchestrator: DailyVerseNotificationOrchestratorT0291(
          coordinator: dailyVerseCoordinator,
        ),
      );
      await startupReconciler.reconcile(languageCode: languageCode);
    } on Object {
      // Fail closed for this category only; other local notification categories
      // still get a chance to restore their persisted opt-in state.
    }

    try {
      final dhikrCoordinator = DhikrReminderCoordinatorT0293(
        preferencesStore: preferencesStore,
        scheduler: notificationRuntime.scheduler,
      );
      final dhikrStartup = DhikrReminderStartupT0293(
        preferencesStore: preferencesStore,
        orchestrator: DhikrReminderOrchestratorT0293(
          coordinator: dhikrCoordinator,
        ),
      );
      await dhikrStartup.reconcile(languageCode: languageCode);
    } on Object {
      // Corrupt preferences or scheduler errors stay fail-closed and never
      // prevent the core religious app from starting.
    }

    try {
      // T0294 deliberately ships with an empty observation source until an
      // exact jurisdiction-scoped official calendar publication is imported.
      // This startup path therefore restores/cancels persisted state safely but
      // can never invent a Gregorian religious date from generic Hijri math.
      final religiousDayCoordinator = ReligiousDayReminderCoordinatorT0294(
        preferencesStore: preferencesStore,
        scheduler: notificationRuntime.scheduler,
        observationSource: const EmptyReligiousDayObservationSourceT0294(),
      );
      await ReligiousDayReminderStartupT0294(
        preferencesStore: preferencesStore,
        coordinator: religiousDayCoordinator,
      ).reconcile(
        now: DateTime.now(),
        languageCode: languageCode,
        countryCode: platformLocale.countryCode ?? '',
      );
    } on Object {
      // Missing jurisdiction, corrupt preferences, absent verified observation,
      // or scheduler errors remain category-local and fail closed.
    }
  } on Object {
    // Notification infrastructure must never prevent the core religious app
    // from starting. Scheduling remains fail-closed until initialization or
    // reconciliation works, and the user can retry from notification settings.
  }
}
