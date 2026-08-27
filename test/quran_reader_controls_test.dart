import 'package:flutter/material.dart';
import 'package:flutter_localizations/flutter_localizations.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:islami_hayat/core/theme/app_theme.dart';
import 'package:islami_hayat/features/quran/presentation/quran_reader_page.dart';
import 'package:islami_hayat/l10n/app_localizations.dart';

Future<void> _pumpUntilFound(
  WidgetTester tester,
  Finder finder, {
  int maxPumps = 300,
}) async {
  for (var i = 0; i < maxPumps; i++) {
    if (finder.evaluate().isNotEmpty) return;
    await tester.pump(const Duration(milliseconds: 50));
  }
  throw TestFailure('Timed out waiting for expected widget');
}

Future<void> _openQuran(
  WidgetTester tester, {
  required Locale locale,
}) async {
  await tester.pumpWidget(
    MaterialApp(
      debugShowCheckedModeBanner: false,
      locale: locale,
      theme: AppTheme.light(),
      supportedLocales: AppLocalizations.supportedLocales,
      localizationsDelegates: const [
        AppLocalizations.delegate,
        GlobalMaterialLocalizations.delegate,
        GlobalWidgetsLocalizations.delegate,
        GlobalCupertinoLocalizations.delegate,
      ],
      home: Scaffold(body: SafeArea(child: QuranReaderPage())),
    ),
  );
  await _pumpUntilFound(
    tester,
    find.byKey(const ValueKey('quran-surah-selector')),
  );
}

void main() {
  testWidgets('Quran reader exposes accessible font controls and sources', (
    tester,
  ) async {
    await _openQuran(tester, locale: const Locale('tr'));

    expect(find.byKey(const ValueKey('quran-surah-selector')), findsOneWidget);
    expect(find.byKey(const ValueKey('quran-font-smaller')), findsOneWidget);
    expect(find.byKey(const ValueKey('quran-font-larger')), findsOneWidget);
    expect(find.byKey(const ValueKey('quran-open-sources')), findsOneWidget);

    await tester.ensureVisible(find.byKey(const ValueKey('quran-font-larger')));
    await tester.tap(find.byKey(const ValueKey('quran-font-larger')));
    await tester.pump();
    expect(tester.takeException(), isNull);

    await tester.ensureVisible(find.byKey(const ValueKey('quran-open-sources')));
    await tester.tap(find.byKey(const ValueKey('quran-open-sources')));
    await _pumpUntilFound(tester, find.text('Kaynaklar ve Lisanslar'));
    expect(find.text('Kaynaklar ve Lisanslar'), findsWidgets);
    expect(find.textContaining('Tanzil Project'), findsWidgets);
  });

  testWidgets('Quran controls remain usable on narrow Arabic layout', (
    tester,
  ) async {
    tester.view.physicalSize = const Size(320, 568);
    tester.view.devicePixelRatio = 1;
    addTearDown(tester.view.resetPhysicalSize);
    addTearDown(tester.view.resetDevicePixelRatio);

    await _openQuran(tester, locale: const Locale('ar'));

    expect(find.byKey(const ValueKey('quran-font-smaller')), findsOneWidget);
    expect(find.byKey(const ValueKey('quran-font-larger')), findsOneWidget);
    expect(find.byKey(const ValueKey('quran-open-sources')), findsOneWidget);
    expect(tester.takeException(), isNull);

    final context = tester.element(
      find.byKey(const ValueKey('quran-open-sources')),
    );
    expect(Directionality.of(context), TextDirection.rtl);
  });
}
