import 'package:flutter/material.dart';
import 'package:flutter_localizations/flutter_localizations.dart';
import 'package:islami_hayat/core/network/internet_reachability.dart';
import 'package:islami_hayat/core/theme/app_theme.dart';
import 'package:islami_hayat/features/premium/domain/content_transition_access_guard.dart';
import 'package:islami_hayat/features/premium/domain/entitlement_state_machine.dart';
import 'package:islami_hayat/features/premium/presentation/startup_access_gate.dart';
import 'package:islami_hayat/l10n/app_localizations.dart';
import 'package:islami_hayat/shell/app_shell.dart';

class IslamiHayatApp extends StatelessWidget {
  const IslamiHayatApp({
    super.key,
    this.locale,
    this.startupAccessVerifier,
    this.initialEntitlement = const EntitlementState.free(),
  });

  /// Optional explicit locale used by the in-app language setting and by
  /// deterministic localization/RTL tests. When null, the device locale is
  /// resolved against the supported TR/EN/AR set.
  final Locale? locale;

  /// Production injects the real HTTPS reachability verifier. Widget tests
  /// that only exercise inner product surfaces can omit it and test the gate
  /// independently.
  final InternetReachabilityVerifier? startupAccessVerifier;
  final EntitlementState initialEntitlement;

  @override
  Widget build(BuildContext context) {
    final verifier = startupAccessVerifier;
    final transitionGuard = verifier == null
        ? null
        : ContentTransitionAccessGuard(
            entitlement: initialEntitlement,
            verifier: verifier,
          );
    final shell = AppShell(
      canEnterNewContent: transitionGuard?.canEnterNewContent,
    );
    final home = verifier == null
        ? shell
        : StartupAccessGate(
            entitlement: initialEntitlement,
            verifier: verifier,
            child: shell,
          );

    return MaterialApp(
      onGenerateTitle: (context) => AppLocalizations.of(context).appName,
      debugShowCheckedModeBanner: false,
      theme: AppTheme.light(),
      darkTheme: AppTheme.dark(),
      themeMode: ThemeMode.system,
      locale: locale,
      supportedLocales: AppLocalizations.supportedLocales,
      localizationsDelegates: const [
        AppLocalizations.delegate,
        GlobalMaterialLocalizations.delegate,
        GlobalWidgetsLocalizations.delegate,
        GlobalCupertinoLocalizations.delegate,
      ],
      localeResolutionCallback: (deviceLocale, supportedLocales) {
        if (deviceLocale == null) return const Locale('tr');
        for (final supported in supportedLocales) {
          if (supported.languageCode == deviceLocale.languageCode) {
            return supported;
          }
        }
        return const Locale('tr');
      },
      home: home,
    );
  }
}
