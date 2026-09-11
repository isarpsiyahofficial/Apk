import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:islami_hayat/app.dart';
import 'package:islami_hayat/core/network/internet_reachability.dart';

final class _MutableProbeClient implements InternetProbeClient {
  int? response;
  int calls = 0;

  @override
  Future<int?> statusCode(
    Uri uri, {
    required Duration timeout,
  }) async {
    calls += 1;
    return response;
  }
}

final class _LocaleCase {
  const _LocaleCase({
    required this.locale,
    required this.offlineBody,
    required this.direction,
  });

  final Locale locale;
  final String offlineBody;
  final TextDirection direction;
}

const _cases = <_LocaleCase>[
  _LocaleCase(
    locale: Locale('tr'),
    offlineBody:
        'Ücretsiz mod internet erişimi gerektirir. İnternete bağlanıp tekrar deneyin.',
    direction: TextDirection.ltr,
  ),
  _LocaleCase(
    locale: Locale('en'),
    offlineBody:
        'Free mode needs internet access. Connect to the internet and try again.',
    direction: TextDirection.ltr,
  ),
  _LocaleCase(
    locale: Locale('ar'),
    offlineBody:
        'يتطلب الوضع المجاني اتصالًا بالإنترنت. اتصل بالإنترنت ثم أعد المحاولة.',
    direction: TextDirection.rtl,
  ),
];

void main() {
  for (final localeCase in _cases) {
    testWidgets(
      'T0263/T0344 ${localeCase.locale.languageCode.toUpperCase()} FREE online -> offline blocks next content and recovers',
      (tester) async {
        final probe = InternetProbe(uri: Uri.parse('https://probe.example/204'));
        final client = _MutableProbeClient()..response = 204;
        final verifier = InternetReachabilityVerifier(
          client: client,
          probes: <InternetProbe>[probe],
        );

        await tester.pumpWidget(
          IslamiHayatApp(
            locale: localeCase.locale,
            startupAccessVerifier: verifier,
          ),
        );
        await tester.pump();
        await tester.pump();

        expect(find.byType(NavigationBar), findsOneWidget);
        expect(
          tester.widget<NavigationBar>(find.byType(NavigationBar)).selectedIndex,
          0,
        );
        expect(client.calls, 1, reason: 'cold start must verify FREE connectivity');
        expect(
          tester.widget<Directionality>(find.byType(Directionality).first).textDirection,
          localeCase.direction,
        );

        client.response = null;
        await tester.tap(find.byKey(const ValueKey('nav-quran')));
        await tester.pump();
        await tester.pump(const Duration(milliseconds: 300));

        expect(
          tester.widget<NavigationBar>(find.byType(NavigationBar)).selectedIndex,
          0,
          reason: 'current screen must remain visible when connectivity drops',
        );
        expect(client.calls, 2, reason: 'new content transition must re-check');
        expect(find.byType(SnackBar), findsOneWidget);
        expect(find.text(localeCase.offlineBody), findsOneWidget);

        client.response = 204;
        await tester.tap(find.byKey(const ValueKey('nav-quran')));
        await tester.pump();
        await tester.pump(const Duration(milliseconds: 300));

        expect(
          tester.widget<NavigationBar>(find.byType(NavigationBar)).selectedIndex,
          1,
        );
        expect(client.calls, 3);
        expect(tester.takeException(), isNull);
      },
    );
  }
}
