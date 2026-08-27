import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:islami_hayat/app.dart';

void main() {
  Future<void> pumpAtSize(
    WidgetTester tester,
    Size size, {
    Locale? locale,
    double textScaleFactor = 1,
  }) async {
    tester.view.physicalSize = size;
    tester.view.devicePixelRatio = 1;
    tester.platformDispatcher.textScaleFactorTestValue = textScaleFactor;

    addTearDown(tester.view.resetPhysicalSize);
    addTearDown(tester.view.resetDevicePixelRatio);
    addTearDown(tester.platformDispatcher.clearTextScaleFactorTestValue);

    await tester.pumpWidget(IslamiHayatApp(locale: locale));
    await tester.pumpAndSettle();
  }

  testWidgets('narrow 320px phone stays overflow-free with bottom navigation',
      (tester) async {
    await pumpAtSize(tester, const Size(320, 640));

    expect(find.byType(NavigationBar), findsOneWidget);
    expect(find.byType(NavigationRail), findsNothing);
    expect(tester.takeException(), isNull);
  });

  testWidgets('modern phone width uses bottom navigation', (tester) async {
    await pumpAtSize(tester, const Size(390, 844));

    expect(find.byType(NavigationBar), findsOneWidget);
    expect(find.byType(NavigationRail), findsNothing);
    expect(tester.takeException(), isNull);
  });

  testWidgets('599px remains compact and 600px remains non-rail medium',
      (tester) async {
    await pumpAtSize(tester, const Size(599, 900));
    expect(find.byType(NavigationBar), findsOneWidget);
    expect(find.byType(NavigationRail), findsNothing);

    await pumpAtSize(tester, const Size(600, 900));
    expect(find.byType(NavigationBar), findsOneWidget);
    expect(find.byType(NavigationRail), findsNothing);
    expect(tester.takeException(), isNull);
  });

  testWidgets('839px medium uses bottom navigation and 840px switches to rail',
      (tester) async {
    await pumpAtSize(tester, const Size(839, 1100));
    expect(find.byType(NavigationBar), findsOneWidget);
    expect(find.byType(NavigationRail), findsNothing);

    await pumpAtSize(tester, const Size(840, 1100));
    expect(find.byType(NavigationRail), findsOneWidget);
    expect(find.byType(NavigationBar), findsNothing);
    expect(tester.takeException(), isNull);
  });

  testWidgets('4:3 tablet uses navigation rail without overflow', (tester) async {
    await pumpAtSize(tester, const Size(1024, 768));

    expect(find.byType(NavigationRail), findsOneWidget);
    expect(find.byType(NavigationBar), findsNothing);
    expect(tester.takeException(), isNull);
  });

  testWidgets('16:10 landscape emulator uses navigation rail', (tester) async {
    await pumpAtSize(tester, const Size(1280, 800));

    expect(find.byType(NavigationRail), findsOneWidget);
    expect(find.byType(NavigationBar), findsNothing);
    expect(tester.takeException(), isNull);
  });

  testWidgets('wide BlueStacks-style viewport remains bounded and uses rail',
      (tester) async {
    await pumpAtSize(tester, const Size(1920, 1080));

    expect(find.byType(NavigationRail), findsOneWidget);
    expect(tester.takeException(), isNull);
  });

  testWidgets('Arabic phone renders RTL and remains overflow-free',
      (tester) async {
    await pumpAtSize(
      tester,
      const Size(390, 844),
      locale: const Locale('ar'),
    );

    final directionality = tester.widget<Directionality>(
      find.byType(Directionality).first,
    );
    expect(directionality.textDirection, TextDirection.rtl);
    expect(find.byType(NavigationBar), findsOneWidget);
    expect(tester.takeException(), isNull);
  });

  testWidgets('Arabic tablet renders RTL with rail', (tester) async {
    await pumpAtSize(
      tester,
      const Size(1024, 1366),
      locale: const Locale('ar'),
    );

    final directionality = tester.widget<Directionality>(
      find.byType(Directionality).first,
    );
    expect(directionality.textDirection, TextDirection.rtl);
    expect(find.byType(NavigationRail), findsOneWidget);
    expect(tester.takeException(), isNull);
  });

  testWidgets('large accessibility font does not break narrow phone shell',
      (tester) async {
    await pumpAtSize(
      tester,
      const Size(360, 800),
      textScaleFactor: 1.6,
    );

    expect(find.byType(NavigationBar), findsOneWidget);
    expect(tester.takeException(), isNull);
  });
}
