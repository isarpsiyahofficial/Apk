import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:islami_hayat/app.dart';

void main() {
  Future<void> pumpAtSize(
    WidgetTester tester,
    Size size,
  ) async {
    tester.view.physicalSize = size;
    tester.view.devicePixelRatio = 1;
    addTearDown(tester.view.resetPhysicalSize);
    addTearDown(tester.view.resetDevicePixelRatio);

    await tester.pumpWidget(const IslamiHayatApp());
    await tester.pumpAndSettle();
  }

  testWidgets('phone width uses bottom navigation', (tester) async {
    await pumpAtSize(tester, const Size(390, 844));

    expect(find.byType(NavigationBar), findsOneWidget);
    expect(find.byType(NavigationRail), findsNothing);
  });

  testWidgets('tablet width uses navigation rail', (tester) async {
    await pumpAtSize(tester, const Size(1024, 1366));

    expect(find.byType(NavigationRail), findsOneWidget);
    expect(find.byType(NavigationBar), findsNothing);
  });

  testWidgets('wide emulator width remains bounded and uses rail', (tester) async {
    await pumpAtSize(tester, const Size(1920, 1080));

    expect(find.byType(NavigationRail), findsOneWidget);
    expect(tester.takeException(), isNull);
  });
}
