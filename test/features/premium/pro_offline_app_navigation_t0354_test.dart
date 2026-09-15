import 'package:flutter/widgets.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:islami_hayat/app.dart';
import 'package:islami_hayat/core/network/internet_reachability.dart';
import 'package:islami_hayat/features/dhikr/presentation/dhikr_hub_page.dart';
import 'package:islami_hayat/features/premium/domain/entitlement_state_machine.dart';
import 'package:islami_hayat/features/profile/presentation/profile_page.dart';
import 'package:islami_hayat/features/prophets/presentation/revelation_journey_page.dart';
import 'package:islami_hayat/features/quran/presentation/quran_hub_page.dart';
import 'package:islami_hayat/features/shared/presentation/discover_page.dart';
import 'package:islami_hayat/features/today/presentation/today_page.dart';

final class _OfflineProbeClientT0354 implements InternetProbeClient {
  int calls = 0;

  @override
  Future<int?> statusCode(
    Uri uri, {
    required Duration timeout,
  }) async {
    calls += 1;
    return null;
  }
}

Future<void> _pumpNavigationFrameT0354(WidgetTester tester) async {
  // App surfaces may contain intentionally repeating animations. Waiting for
  // the entire tree to settle would therefore make a navigation assertion
  // depend on unrelated animation lifecycles. Pump the route transition
  // deterministically instead; the assertions below still verify the mounted
  // destination and surface any framework exception.
  await tester.pump();
  await tester.pump(const Duration(milliseconds: 400));
}

void main() {
  final probe = InternetProbe(uri: Uri.parse('https://probe.example/204'));

  for (final localeCase in const <_LocaleCaseT0354>[
    _LocaleCaseT0354(Locale('tr'), TextDirection.ltr),
    _LocaleCaseT0354(Locale('en'), TextDirection.ltr),
    _LocaleCaseT0354(Locale('ar'), TextDirection.rtl),
  ]) {
    testWidgets(
      'T0354 cached PRO ${localeCase.locale.languageCode} keeps core and nested prophet surfaces usable offline without reachability requests',
      (tester) async {
        final client = _OfflineProbeClientT0354();
        final verifier = InternetReachabilityVerifier(
          client: client,
          probes: <InternetProbe>[probe],
        );

        await tester.pumpWidget(
          IslamiHayatApp(
            locale: localeCase.locale,
            startupAccessVerifier: verifier,
            initialEntitlement: const EntitlementState.cachedPro(),
          ),
        );
        await tester.pumpAndSettle();

        expect(client.calls, 0);
        expect(find.byType(TodayPage), findsOneWidget);
        expect(
          tester.widget<Directionality>(find.byType(Directionality).first).textDirection,
          localeCase.direction,
        );

        final destinations = <(String, Type)>[
          ('quran', QuranHubPage),
          ('discover', DiscoverPage),
          ('dhikr', DhikrHubPage),
          ('profile', ProfilePage),
          ('today', TodayPage),
        ];

        for (final destination in destinations) {
          await tester.tap(find.byKey(ValueKey('nav-${destination.$1}')));
          await _pumpNavigationFrameT0354(tester);

          expect(
            find.byType(destination.$2),
            findsOneWidget,
            reason: '${destination.$1} must remain reachable for cached PRO offline',
          );
          expect(
            client.calls,
            0,
            reason: 'cached PRO navigation must never probe the network',
          );
          expect(tester.takeException(), isNull);

          if (destination.$1 == 'discover') {
            await tester.tap(
              find.byKey(const ValueKey('discover-revelation-journey')),
            );
            await _pumpNavigationFrameT0354(tester);

            expect(
              find.byType(RevelationJourneyPage),
              findsOneWidget,
              reason: 'nested prophet core surface must remain reachable for cached PRO offline',
            );
            expect(
              client.calls,
              0,
              reason: 'nested cached PRO content must never probe the network',
            );
            expect(tester.takeException(), isNull);

            Navigator.of(
              tester.element(find.byType(RevelationJourneyPage)),
            ).pop();
            await _pumpNavigationFrameT0354(tester);
            expect(find.byType(DiscoverPage), findsOneWidget);
          }
        }
      },
    );
  }
}

final class _LocaleCaseT0354 {
  const _LocaleCaseT0354(this.locale, this.direction);

  final Locale locale;
  final TextDirection direction;
}