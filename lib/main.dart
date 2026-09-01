import 'package:flutter/widgets.dart';
import 'package:islami_hayat/app.dart';
import 'package:islami_hayat/core/network/internet_reachability.dart';
import 'package:islami_hayat/features/premium/domain/secure_entitlement_cache_t0277.dart';

Future<void> main() async {
  WidgetsFlutterBinding.ensureInitialized();

  final initialEntitlement = await SecureEntitlementCacheT0277().restoreOffline();
  final verifier = InternetReachabilityVerifier(
    client: const IoInternetProbeClient(),
  );

  runApp(
    IslamiHayatApp(
      startupAccessVerifier: verifier,
      initialEntitlement: initialEntitlement,
    ),
  );
}
