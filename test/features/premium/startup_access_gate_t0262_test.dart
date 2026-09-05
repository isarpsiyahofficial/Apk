import 'package:flutter/material.dart';
import 'package:flutter_localizations/flutter_localizations.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:islami_hayat/core/network/internet_reachability.dart';
import 'package:islami_hayat/features/premium/domain/entitlement_state_machine.dart';
import 'package:islami_hayat/features/premium/presentation/startup_access_gate.dart';

final class _MutableProbeClient implements InternetProbeClient {
  int? response;
  final List<Uri> calls = <Uri>[];

  @override
  Future<int?> statusCode(
    Uri uri, {
    required Duration timeout,
  }) async {
    calls.add(uri);
    return response;
  }
}

Widget _app({
  required EntitlementState entitlement,
  required InternetReachabilityVerifier verifier,
  Locale locale = const Locale('tr'),
  double textScale = 1,
}) {
  return MaterialApp(
    locale: locale,
    supportedLocales: const <Locale>[
      Locale('tr'),
      Locale('en'),
      Locale('ar'),
    ],
    localizationsDelegates: const <LocalizationsDelegate<dynamic>>[
      GlobalMaterialLocalizations.delegate,
      GlobalWidgetsLocalizations.delegate,
      GlobalCupertinoLocalizations.delegate,
    ],
    builder: (context, child) {
      final media = MediaQuery.of(context);
      return MediaQuery(
        data: media.copyWith(textScaler: TextScaler.linear(textScale)),
        child: child!,
      );
    },
    home: StartupAccessGate(
      entitlement: entitlement,
      verifier: verifier,
      child: const Scaffold(body: Text('CORE_CONTENT')),
    ),
  );
}

void main() {
  final probe = InternetProbe(uri: Uri.parse('https://probe.example/204'));

  group('T0262 FREE cold-start offline gate', () {
    testWidgets('FREE offline cold start blocks core content', (tester) async {
      final client = _MutableProbeClient()..response = null;
      final verifier = InternetReachabilityVerifier(
        client: client,
        probes: <InternetProbe>[probe],
      );

      await tester.pumpWidget(
        _app(
          entitlement: const EntitlementState.free(),
          verifier: verifier,
        ),
      );
      await tester.pump();

      expect(find.text('İnternet bağlantısı gerekli'), findsOneWidget);
      expect(find.text('CORE_CONTENT'), findsNothing);
      expect(client.calls, <Uri>[probe.uri]);
    });

    testWidgets('retry opens FREE core only after verified 204', (tester) async {
      final client = _MutableProbeClient()..response = null;
      final verifier = InternetReachabilityVerifier(
        client: client,
        probes: <InternetProbe>[probe],
      );

      await tester.pumpWidget(
        _app(
          entitlement: const EntitlementState.free(),
          verifier: verifier,
        ),
      );
      await tester.pump();
      expect(find.text('CORE_CONTENT'), findsNothing);

      client.response = 204;
      await tester.tap(find.text('Tekrar dene'));
      await tester.pump();

      expect(find.text('CORE_CONTENT'), findsOneWidget);
      expect(client.calls, <Uri>[probe.uri, probe.uri]);
    });

    testWidgets('PRO bypasses cold-start internet probe entirely', (tester) async {
      final client = _MutableProbeClient()..response = null;
      final verifier = InternetReachabilityVerifier(
        client: client,
        probes: <InternetProbe>[probe],
      );

      await tester.pumpWidget(
        _app(
          entitlement: const EntitlementState.cachedPro(),
          verifier: verifier,
        ),
      );
      await tester.pump();

      expect(find.text('CORE_CONTENT'), findsOneWidget);
      expect(client.calls, isEmpty);
    });

    testWidgets('Arabic offline gate is RTL and localized', (tester) async {
      final client = _MutableProbeClient()..response = 503;
      final verifier = InternetReachabilityVerifier(
        client: client,
        probes: <InternetProbe>[probe],
      );

      await tester.pumpWidget(
        _app(
          entitlement: const EntitlementState.free(),
          verifier: verifier,
          locale: const Locale('ar'),
        ),
      );
      await tester.pump();

      final title = find.text('يلزم الاتصال بالإنترنت');
      expect(title, findsOneWidget);
      expect(Directionality.of(tester.element(title)), TextDirection.rtl);
      expect(find.text('CORE_CONTENT'), findsNothing);
    });

    testWidgets('narrow phone and 1.6x text scale do not overflow', (tester) async {
      tester.view.physicalSize = const Size(320, 640);
      tester.view.devicePixelRatio = 1;
      addTearDown(() {
        tester.view.resetPhysicalSize();
        tester.view.resetDevicePixelRatio();
      });

      final client = _MutableProbeClient()..response = 302;
      final verifier = InternetReachabilityVerifier(
        client: client,
        probes: <InternetProbe>[probe],
      );

      await tester.pumpWidget(
        _app(
          entitlement: const EntitlementState.free(),
          verifier: verifier,
          locale: const Locale('en'),
          textScale: 1.6,
        ),
      );
      await tester.pump();

      expect(find.text('Internet connection required'), findsOneWidget);
      expect(tester.takeException(), isNull);
    });
  });
}
