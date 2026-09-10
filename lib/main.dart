import 'package:flutter/widgets.dart';
import 'package:islami_hayat/app.dart';
import 'package:islami_hayat/core/network/internet_reachability.dart';
import 'package:islami_hayat/core/storage/secure_private_user_store.dart';
import 'package:islami_hayat/features/notifications/data/android_local_notification_scheduler_t0291.dart';
import 'package:islami_hayat/features/notifications/data/daily_verse_notification_startup_t0291.dart';
import 'package:islami_hayat/features/notifications/data/secure_notification_preferences_store.dart';
import 'package:islami_hayat/features/notifications/domain/daily_verse_notification_t0291.dart';
import 'package:islami_hayat/features/premium/domain/secure_entitlement_cache_t0277.dart';
import 'package:islami_hayat/features/today/data/daily_verse_repository.dart';

Future<void> main() async {
  WidgetsFlutterBinding.ensureInitialized();

  final initialEntitlement = await SecureEntitlementCacheT0277().restoreOffline();
  final verifier = InternetReachabilityVerifier(
    client: const IoInternetProbeClient(),
  );
  final notificationRuntime = NotificationRuntimeT0291.instance;
  try {
    await notificationRuntime.initialize();

    final preferencesStore = SecureNotificationPreferencesStore(
      SecurePrivateUserStore(),
    );
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
    await startupReconciler.reconcile(
      languageCode:
          WidgetsBinding.instance.platformDispatcher.locale.languageCode,
    );
  } on Object {
    // Notification infrastructure must never prevent the core religious app
    // from starting. Scheduling remains fail-closed until initialization or
    // reconciliation works, and the user can retry from notification settings.
  }

  runApp(
    IslamiHayatApp(
      startupAccessVerifier: verifier,
      initialEntitlement: initialEntitlement,
      notificationTapController: notificationRuntime.tapController,
    ),
  );
}
