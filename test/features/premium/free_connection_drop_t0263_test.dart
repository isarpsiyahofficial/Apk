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

void main() {
  testWidgets(
    'T0263 FREE online then offline keeps current screen until next content passes',
    (tester) async {
      final probe = InternetProbe(uri: Uri.parse('https://probe.example/204'));
      final client = _MutableProbeClient()..response = 204;
      final verifier = InternetReachabilityVerifier(
        client: client,
        probes: <InternetProbe>[probe],
      );

      await tester.pumpWidget(
        IslamiHayatApp(startupAccessVerifier: verifier),
      );
      await tester.pump();
      await tester.pump();

      expect(find.byType(NavigationBar), findsOneWidget);
      expect(tester.widget<NavigationBar>(find.byType(NavigationBar)).selectedIndex, 0);
      expect(client.calls, 1, reason: 'cold start must verify FREE connectivity');

      client.response = null;
      await tester.tap(find.byKey(const ValueKey('nav-quran')));
      await tester.pump();
      await tester.pump();

      expect(
        tester.widget<NavigationBar>(find.byType(NavigationBar)).selectedIndex,
        0,
        reason: 'current screen must remain visible when connectivity drops',
      );
      expect(client.calls, 2, reason: 'new content transition must re-check');
      expect(
        find.textContaining('Ücretsiz mod internet erişimi gerektirir'),
        findsOneWidget,
      );

      client.response = 204;
      await tester.tap(find.byKey(const ValueKey('nav-quran')));
      await tester.pump();
      await tester.pump();

      expect(tester.widget<NavigationBar>(find.byType(NavigationBar)).selectedIndex, 1);
      expect(client.calls, 3);
      expect(tester.takeException(), isNull);
    },
  );
}
