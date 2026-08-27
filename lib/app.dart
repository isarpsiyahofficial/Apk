import 'package:flutter/material.dart';
import 'package:flutter_localizations/flutter_localizations.dart';
import 'package:islami_hayat/core/theme/app_theme.dart';
import 'package:islami_hayat/l10n/app_localizations.dart';
import 'package:islami_hayat/shell/app_shell.dart';

class IslamiHayatApp extends StatelessWidget {
  const IslamiHayatApp({super.key, this.locale});

  /// Optional explicit locale used by the in-app language setting and by
  /// deterministic localization/RTL tests. When null, the device locale is
  /// resolved against the supported TR/EN/AR set.
  final Locale? locale;

  @override
  Widget build(BuildContext context) {
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
      home: const AppShell(),
    );
  }
}
