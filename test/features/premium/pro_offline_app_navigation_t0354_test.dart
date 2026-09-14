import 'package:flutter/widgets.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:islami_hayat/app.dart';
import 'package:islami_hayat/core/network/internet_reachability.dart';
import 'package:islami_hayat/features/dhikr/presentation/dhikr_hub_page.dart';
import 'package:islami_hayat/features/premium/domain/entitlement_state_machine.dart';
import 'package:islami_hayat/features/profile/presentation/profile_page.dart';
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

void main() {
  final probe = InternetProbe(uri: Uri.parse('https://probe.example/204'));

  for (final localeCase in const <_LocaleCaseT0354>[
    _LocaleCaseT0354(Locale('tr'), TextDirection.ltr),
    _LocaleCaseT0354(Locale('en'), TextDirection.ltr),
    _LocaleCaseT0354(Locale('ar'), TextDirection.rtl),
  ]) {
    testWidgets(
      'T0354 cached PRO ${localeCase.locale.languageCode} keeps all five core tabs usable offline without reachability requests',
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
          await tester.pumpAndSettle();

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
