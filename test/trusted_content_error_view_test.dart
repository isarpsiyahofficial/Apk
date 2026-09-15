import 'package:flutter/material.dart';
import 'package:flutter_localizations/flutter_localizations.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:islami_hayat/core/content/trusted_content_error_view.dart';
import 'package:islami_hayat/l10n/app_localizations.dart';

Widget _appFor(Locale locale) {
  return MaterialApp(
    locale: locale,
    supportedLocales: AppLocalizations.supportedLocales,
    localizationsDelegates: const [
      AppLocalizations.delegate,
      GlobalMaterialLocalizations.delegate,
      GlobalWidgetsLocalizations.delegate,
      GlobalCupertinoLocalizations.delegate,
    ],
    home: const Scaffold(body: TrustedContentErrorView()),
  );
}

void main() {
  testWidgets('unverified religious content is hidden behind localized TR copy',
      (tester) async {
    await tester.pumpWidget(_appFor(const Locale('tr')));
    await tester.pumpAndSettle();

    expect(find.text('İçerik doğrulanamadı'), findsOneWidget);
    expect(find.textContaining('metin gösterilmiyor'), findsOneWidget);
  });

  testWidgets('Arabic fail-safe surface renders RTL without overflow',
      (tester) async {
    tester.view.physicalSize = const Size(360, 640);
    tester.view.devicePixelRatio = 1;
    addTearDown(tester.view.resetPhysicalSize);
    addTearDown(tester.view.resetDevicePixelRatio);

    await tester.pumpWidget(_appFor(const Locale('ar')));
    await tester.pumpAndSettle();

    expect(find.text('تعذّر التحقق من المحتوى'), findsOneWidget);
    expect(Directionality.of(tester.element(find.byType(Scaffold))), TextDirection.rtl);
    expect(tester.takeException(), isNull);
  });
}
