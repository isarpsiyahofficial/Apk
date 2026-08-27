import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:islami_hayat/app.dart';

Future<void> _openSources(
  WidgetTester tester, {
  required Locale locale,
  required String profileLabel,
  required String sourcesLabel,
}) async {
  await tester.pumpWidget(IslamiHayatApp(locale: locale));
  await tester.pumpAndSettle();

  await tester.tap(find.text(profileLabel).last);
  await tester.pumpAndSettle();
  expect(find.text(sourcesLabel), findsOneWidget);

  await tester.tap(find.text(sourcesLabel));
  await tester.pumpAndSettle();
}

void main() {
  testWidgets('Turkish sources screen exposes Tanzil attribution', (tester) async {
    await _openSources(
      tester,
      locale: const Locale('tr'),
      profileLabel: 'Ben',
      sourcesLabel: 'Kaynaklar ve Lisanslar',
    );

    expect(find.textContaining('Tanzil Project'), findsOneWidget);
    expect(find.textContaining('CC BY 3.0'), findsOneWidget);
    expect(find.text('https://tanzil.net/'), findsOneWidget);
  });

  testWidgets('English sources screen exposes Tanzil attribution', (tester) async {
    await _openSources(
      tester,
      locale: const Locale('en'),
      profileLabel: 'Me',
      sourcesLabel: 'Sources & Licenses',
    );

    expect(find.textContaining('Tanzil Project'), findsOneWidget);
    expect(find.textContaining('CC BY 3.0'), findsOneWidget);
  });

  testWidgets('Arabic sources screen is RTL and source-transparent', (tester) async {
    await _openSources(
      tester,
      locale: const Locale('ar'),
      profileLabel: 'أنا',
      sourcesLabel: 'المصادر والتراخيص',
    );

    final context = tester.element(find.text('المصادر والتراخيص').last);
    expect(Directionality.of(context), TextDirection.rtl);
    expect(find.textContaining('مشروع تنزيل'), findsOneWidget);
    expect(find.textContaining('CC BY 3.0'), findsOneWidget);
  });

  testWidgets('sources screen does not overflow on a narrow phone', (tester) async {
    tester.view.physicalSize = const Size(320, 568);
    tester.view.devicePixelRatio = 1;
    addTearDown(tester.view.resetPhysicalSize);
    addTearDown(tester.view.resetDevicePixelRatio);

    await _openSources(
      tester,
      locale: const Locale('tr'),
      profileLabel: 'Ben',
      sourcesLabel: 'Kaynaklar ve Lisanslar',
    );

    expect(tester.takeException(), isNull);
  });
}
