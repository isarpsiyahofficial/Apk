import 'package:flutter/material.dart';
import 'package:flutter_localizations/flutter_localizations.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:islami_hayat/features/premium/presentation/premium_value_page.dart';
import 'package:islami_hayat/l10n/app_localizations.dart';

Widget _app(Locale locale) {
  return MaterialApp(
    locale: locale,
    supportedLocales: AppLocalizations.supportedLocales,
    localizationsDelegates: const [
      AppLocalizations.delegate,
      GlobalMaterialLocalizations.delegate,
      GlobalWidgetsLocalizations.delegate,
      GlobalCupertinoLocalizations.delegate,
    ],
    home: const PremiumValuePage(),
  );
}

Future<void> _setSurface(
  WidgetTester tester, {
  required Size size,
  double textScale = 1,
}) async {
  tester.view.physicalSize = size;
  tester.view.devicePixelRatio = 1;
  tester.platformDispatcher.textScaleFactorTestValue = textScale;
  addTearDown(() {
    tester.view.resetPhysicalSize();
    tester.view.resetDevicePixelRatio();
    tester.platformDispatcher.clearTextScaleFactorTestValue();
  });
}

void main() {
  testWidgets('TR value proposition states comfort benefits and no truth paywall', (
    tester,
  ) async {
    await _setSurface(tester, size: const Size(390, 844));
    await tester.pumpWidget(_app(const Locale('tr')));
    await tester.pumpAndSettle();

    expect(find.text('Lifetime PRO'), findsWidgets);
    expect(find.text('Sıfır reklam'), findsOneWidget);
    expect(find.text('Temel içeriklere çevrimdışı erişim'), findsOneWidget);
    expect(find.text('100 tasarımın tamamı'), findsOneWidget);
    expect(find.text('Gelişmiş kişiselleştirme'), findsOneWidget);
    expect(find.text('Dini doğruluk paywall değildir'), findsOneWidget);
    expect(find.textContaining('Kur’an’ın temel metni'), findsOneWidget);
    expect(find.textContaining('abonelik değildir'), findsOneWidget);
    expect(tester.takeException(), isNull);
  });

  testWidgets('EN narrow phone with large font scrolls without overflow', (
    tester,
  ) async {
    await _setSurface(
      tester,
      size: const Size(320, 640),
      textScale: 1.6,
    );
    await tester.pumpWidget(_app(const Locale('en')));
    await tester.pumpAndSettle();

    expect(find.text('Zero ads'), findsOneWidget);
    await tester.drag(find.byType(ListView), const Offset(0, -600));
    await tester.pumpAndSettle();
    expect(find.text('Religious truth is not paywalled'), findsOneWidget);
    expect(tester.takeException(), isNull);
  });

  testWidgets('AR is RTL and remains readable on tablet landscape', (
    tester,
  ) async {
    await _setSurface(tester, size: const Size(1200, 800), textScale: 1.3);
    await tester.pumpWidget(_app(const Locale('ar')));
    await tester.pumpAndSettle();

    final directionality = tester.widget<Directionality>(
      find.byType(Directionality).first,
    );
    expect(directionality.textDirection, TextDirection.rtl);
    expect(find.text('بلا إعلانات'), findsOneWidget);
    expect(find.text('جميع التصاميم المئة'), findsOneWidget);
    expect(
      find.text('صحة المعلومة الدينية ليست خلف جدار دفع'),
      findsOneWidget,
    );
    expect(tester.takeException(), isNull);
  });
}
