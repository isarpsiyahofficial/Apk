import 'package:flutter/material.dart';
import 'package:flutter_localizations/flutter_localizations.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:islami_hayat/features/prophets/presentation/revelation_journey_page.dart';

void main() {
  Future<void> pumpJourney(
    WidgetTester tester, {
    required Locale locale,
    required TextDirection direction,
    Size size = const Size(390, 844),
  }) async {
    tester.view.physicalSize = size;
    tester.view.devicePixelRatio = 1;
    addTearDown(tester.view.resetPhysicalSize);
    addTearDown(tester.view.resetDevicePixelRatio);

    await tester.pumpWidget(
      MaterialApp(
        locale: locale,
        supportedLocales: const [Locale('tr'), Locale('en'), Locale('ar')],
        localizationsDelegates: const [
          GlobalMaterialLocalizations.delegate,
          GlobalWidgetsLocalizations.delegate,
          GlobalCupertinoLocalizations.delegate,
        ],
        home: Directionality(
          textDirection: direction,
          child: const RevelationJourneyPage(),
        ),
      ),
    );
    await tester.pumpAndSettle();
  }

  testWidgets('TR phone surface renders its localized entry without overflow', (
    tester,
  ) async {
    await pumpJourney(
      tester,
      locale: const Locale('tr'),
      direction: TextDirection.ltr,
    );

    expect(find.text('Vahiy Yolculuğu'), findsOneWidget);
    expect(find.byKey(const ValueKey('journey-filter-all')), findsOneWidget);
    expect(tester.takeException(), isNull);
  });

  testWidgets('wide period filter narrows journey and exposes parallel lanes', (
    tester,
  ) async {
    await pumpJourney(
      tester,
      locale: const Locale('en'),
      direction: TextDirection.ltr,
      size: const Size(1280, 900),
    );

    await tester.tap(find.byKey(const ValueKey('journey-filter-abrahamic')));
    await tester.pumpAndSettle();

    expect(find.text('Abrahamic period'), findsWidgets);
    expect(
      find.byKey(const ValueKey('journey-prophet-ibrahim')),
      findsOneWidget,
    );
    expect(find.byKey(const ValueKey('journey-prophet-lut')), findsOneWidget);
    expect(find.text('Parallel'), findsWidgets);
    expect(find.textContaining('no exact date'), findsWidgets);
    expect(tester.takeException(), isNull);
  });

  testWidgets('exact-date-free period filter shows Isa without Muhammad', (
    tester,
  ) async {
    await pumpJourney(
      tester,
      locale: const Locale('en'),
      direction: TextDirection.ltr,
      size: const Size(1280, 900),
    );

    await tester.tap(find.byKey(const ValueKey('journey-filter-isa')));
    await tester.pumpAndSettle();

    expect(find.text('Jesus period'), findsWidgets);
    expect(find.byKey(const ValueKey('journey-prophet-isa')), findsOneWidget);
    expect(
      find.byKey(const ValueKey('journey-prophet-muhammad')),
      findsNothing,
    );
    expect(find.textContaining('no exact date'), findsOneWidget);
  });

  testWidgets('Arabic surface remains RTL and readable on narrow phone', (
    tester,
  ) async {
    await pumpJourney(
      tester,
      locale: const Locale('ar'),
      direction: TextDirection.rtl,
      size: const Size(320, 800),
    );

    expect(find.text('رحلة الوحي'), findsOneWidget);
    expect(find.text('كل الفترات'), findsOneWidget);
    final titleContext = tester.element(find.text('رحلة الوحي'));
    expect(Directionality.of(titleContext), TextDirection.rtl);
    expect(tester.takeException(), isNull);
  });

  testWidgets('wide landscape renders without overflow', (tester) async {
    await pumpJourney(
      tester,
      locale: const Locale('tr'),
      direction: TextDirection.ltr,
      size: const Size(1280, 720),
    );

    expect(find.text('Vahiy Yolculuğu'), findsOneWidget);
    expect(tester.takeException(), isNull);
  });
}
