import 'package:flutter/material.dart';
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
        home: Directionality(
          textDirection: direction,
          child: const RevelationJourneyPage(),
        ),
      ),
    );
    await tester.pumpAndSettle();
  }

  testWidgets('TR surface exposes period filters and parallel lanes', (tester) async {
    await pumpJourney(
      tester,
      locale: const Locale('tr'),
      direction: TextDirection.ltr,
    );

    expect(find.text('Vahiy Yolculuğu'), findsOneWidget);
    expect(find.byKey(const ValueKey('journey-filter-all')), findsOneWidget);
    expect(find.text('Paralel'), findsWidgets);
    expect(tester.takeException(), isNull);
  });

  testWidgets('period filter narrows the visible journey without fake dates', (tester) async {
    await pumpJourney(
      tester,
      locale: const Locale('en'),
      direction: TextDirection.ltr,
    );

    await tester.tap(find.byKey(const ValueKey('journey-filter-isa')));
    await tester.pumpAndSettle();

    expect(find.text('Jesus period'), findsWidgets);
    expect(find.text('Jesus'), findsOneWidget);
    expect(find.text('Muhammad'), findsNothing);
    expect(find.textContaining('no exact date'), findsOneWidget);
  });

  testWidgets('Arabic surface remains RTL and readable on narrow phone', (tester) async {
    await pumpJourney(
      tester,
      locale: const Locale('ar'),
      direction: TextDirection.rtl,
      size: const Size(320, 800),
    );

    expect(find.text('رحلة الوحي'), findsOneWidget);
    expect(find.text('كل الفترات'), findsOneWidget);
    expect(find.text('موسى'), findsOneWidget);
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
