import 'dart:io';

import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:islami_hayat/core/monetization/free_home_banner_surface.dart';
import 'package:islami_hayat/features/premium/domain/entitlement_state_machine.dart';

Widget _host({
  required EntitlementState entitlement,
  Widget? adContent,
  Size size = const Size(390, 844),
  double textScale = 1,
}) {
  return MaterialApp(
    home: MediaQuery(
      data: MediaQueryData(size: size, textScaler: TextScaler.linear(textScale)),
      child: Scaffold(
        body: FreeHomeBannerSurface(
          entitlement: entitlement,
          adContent: adContent,
        ),
      ),
    ),
  );
}

void main() {
  group('T0267 FREE home banner surface', () {
    testWidgets('FREE renders a filled banner in the dedicated home surface', (
      tester,
    ) async {
      await tester.pumpWidget(
        _host(
          entitlement: const EntitlementState.free(),
          adContent: const SizedBox(
            key: ValueKey('fake-filled-banner'),
            height: 50,
            width: 320,
          ),
        ),
      );

      expect(find.byKey(const ValueKey('free-home-banner-surface')), findsOneWidget);
      expect(find.byKey(const ValueKey('fake-filled-banner')), findsOneWidget);
      expect(tester.takeException(), isNull);
    });

    testWidgets('verified and cached PRO both fail closed with zero banner', (
      tester,
    ) async {
      for (final entitlement in <EntitlementState>[
        const EntitlementState.cachedPro(),
        const EntitlementState.verifiedPro(),
      ]) {
        await tester.pumpWidget(
          _host(
            entitlement: entitlement,
            adContent: const SizedBox(
              key: ValueKey('should-never-render'),
              height: 50,
            ),
          ),
        );

        expect(
          find.byKey(const ValueKey('free-home-banner-surface')),
          findsNothing,
        );
        expect(find.byKey(const ValueKey('should-never-render')), findsNothing);
      }
    });

    testWidgets('no-fill collapses and cannot block home content', (tester) async {
      await tester.pumpWidget(
        _host(entitlement: const EntitlementState.free()),
      );

      expect(find.byKey(const ValueKey('free-home-banner-surface')), findsNothing);
      expect(tester.takeException(), isNull);
    });

    testWidgets('narrow phone, tablet and large-font layouts do not overflow', (
      tester,
    ) async {
      const scenarios = <({Size size, double scale})>[
        (size: Size(320, 640), scale: 2.0),
        (size: Size(800, 1280), scale: 1.0),
        (size: Size(1280, 800), scale: 1.4),
      ];

      for (final scenario in scenarios) {
        await tester.pumpWidget(
          _host(
            entitlement: const EntitlementState.free(),
            size: scenario.size,
            textScale: scenario.scale,
            adContent: const SizedBox(
              key: ValueKey('responsive-banner'),
              height: 50,
              width: double.infinity,
            ),
          ),
        );
        expect(find.byKey(const ValueKey('responsive-banner')), findsOneWidget);
        expect(tester.takeException(), isNull);
      }
    });

    test('shell mounts banner outside TodayPage instead of inside sacred blocks', () {
      final source = File('lib/shell/app_shell.dart').readAsStringSync();
      final todaySource =
          File('lib/features/today/presentation/today_page.dart').readAsStringSync();

      expect(source, contains('_TodayHomeWithBanner'));
      expect(source, contains('FreeHomeBannerSurface('));
      expect(source, contains('Expanded(child: child)'));
      expect(todaySource, isNot(contains('FreeHomeBannerSurface')));
      expect(todaySource, isNot(contains('AdWidget')));
      expect(todaySource, isNot(contains('BannerAd')));
    });
  });
}
