import 'package:flutter/widgets.dart';
import 'package:islami_hayat/app.dart';
import 'package:islami_hayat/core/network/internet_reachability.dart';
import 'package:islami_hayat/features/notifications/data/android_local_notification_scheduler_t0291.dart';
import 'package:islami_hayat/features/premium/domain/secure_entitlement_cache_t0277.dart';

Future<void> main() async {
  WidgetsFlutterBinding.ensureInitialized();

  final initialEntitlement = await SecureEntitlementCacheT0277().restoreOffline();
  final verifier = InternetReachabilityVerifier(
    client: const IoInternetProbeClient(),
  );
  final notificationRuntime = NotificationRuntimeT0291.instance;
  try {
    await notificationRuntime.initialize();
  } on Object {
    // Notification infrastructure must never prevent the core religious app
    // from starting. Scheduling remains fail-closed until initialization works.
  }

  runApp(
    IslamiHayatApp(
      startupAccessVerifier: verifier,
      initialEntitlement: initialEntitlement,
      notificationTapController: notificationRuntime.tapController,
    ),
  );
}