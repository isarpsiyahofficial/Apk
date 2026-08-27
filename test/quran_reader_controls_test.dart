import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:islami_hayat/app.dart';

Future<void> _openQuran(
  WidgetTester tester, {
  required Locale locale,
  required String quranLabel,
}) async {
  await tester.pumpWidget(IslamiHayatApp(locale: locale));
  await tester.pumpAndSettle();
  await tester.tap(find.text(quranLabel).last);
  await tester.pumpAndSettle();
}

void main() {
  testWidgets('Quran reader exposes accessible font controls and sources', (
    tester,
  ) async {
    await _openQuran(
      tester,
      locale: const Locale('tr'),
      quranLabel: 'Kur’an',
    );

    expect(find.byKey(const ValueKey('quran-surah-selector')), findsOneWidget);
    expect(find.byKey(const ValueKey('quran-font-smaller')), findsOneWidget);
    expect(find.byKey(const ValueKey('quran-font-larger')), findsOneWidget);
    expect(find.byKey(const ValueKey('quran-open-sources')), findsOneWidget);

    await tester.tap(find.byKey(const ValueKey('quran-font-larger')));
    await tester.pump();
    expect(tester.takeException(), isNull);

    await tester.tap(find.byKey(const ValueKey('quran-open-sources')));
    await tester.pumpAndSettle();
    expect(find.text('Kaynaklar ve Lisanslar'), findsWidgets);
    expect(find.textContaining('Tanzil Project'), findsOneWidget);
  });

  testWidgets('Quran controls remain usable on narrow Arabic layout', (
    tester,
  ) async {
    tester.view.physicalSize = const Size(320, 568);
    tester.view.devicePixelRatio = 1;
    addTearDown(tester.view.resetPhysicalSize);
    addTearDown(tester.view.resetDevicePixelRatio);

    await _openQuran(
      tester,
      locale: const Locale('ar'),
      quranLabel: 'القرآن',
    );

    expect(find.byKey(const ValueKey('quran-font-smaller')), findsOneWidget);
    expect(find.byKey(const ValueKey('quran-font-larger')), findsOneWidget);
    expect(find.byKey(const ValueKey('quran-open-sources')), findsOneWidget);
    expect(tester.takeException(), isNull);

    final context = tester.element(find.byKey(const ValueKey('quran-open-sources')));
    expect(Directionality.of(context), TextDirection.rtl);
  });
}
