import 'package:flutter/widgets.dart';
import 'package:islami_hayat/app.dart';
import 'package:islami_hayat/core/network/internet_reachability.dart';

void main() {
  WidgetsFlutterBinding.ensureInitialized();
  final verifier = InternetReachabilityVerifier(
    client: const IoInternetProbeClient(),
  );
  runApp(IslamiHayatApp(startupAccessVerifier: verifier));
}
