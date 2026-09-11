import 'package:flutter/widgets.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:islami_hayat/app.dart';
import 'package:islami_hayat/core/network/internet_reachability.dart';
import 'package:islami_hayat/features/premium/domain/entitlement_state_machine.dart';
import 'package:islami_hayat/shell/app_shell.dart';

final class _AppProbeClientT0262 implements InternetProbeClient {
  _AppProbeClientT0262(this.status);

  int? status;
  int calls = 0;

  @override
  Future<int?> statusCode(
    Uri uri, {
    required Duration timeout,
  }) async {
    calls += 1;
    return status;
  }
}

void main() {
  final probe = InternetProbe(uri: Uri.parse('https://probe.example/204'));

  InternetReachabilityVerifier verifier(_AppProbeClientT0262 client) {
    return InternetReachabilityVerifier(
      client: client,
      probes: <InternetProbe>[probe],
    );
  }

  group('T0262 app-level FREE cold-start gate integration', () {
    testWidgets('offline FREE never mounts AppShell', (tester) async {
      final client = _AppProbeClientT0262(null);

      await tester.pumpWidget(
        IslamiHayatApp(
          locale: const Locale('tr'),
          startupAccessVerifier: verifier(client),
          initialEntitlement: const EntitlementState.free(),
        ),
      );
      await tester.pump();

      expect(client.calls, 1);
      expect(find.text('İnternet bağlantısı gerekli'), findsOneWidget);
      expect(find.byType(AppShell), findsNothing);
    });

    for (final localeCase in const <_OfflineLocaleCase>[
      _OfflineLocaleCase(
        locale: Locale('en'),
        title: 'Internet connection required',
        body:
            'Free mode needs internet access. Connect to the internet and try again.',
        retry: 'Try again',
        direction: TextDirection.ltr,
      ),
      _OfflineLocaleCase(
        locale: Locale('ar'),
        title: 'يلزم الاتصال بالإنترنت',
        body:
            'يتطلب الوضع المجاني اتصالًا بالإنترنت. اتصل بالإنترنت ثم أعد المحاولة.',
        retry: 'إعادة المحاولة',
        direction: TextDirection.rtl,
      ),
    ]) {
      testWidgets(
          '${localeCase.locale.languageCode} offline FREE gate is localized and fail-closed',
          (tester) async {
        final client = _AppProbeClientT0262(null);

        await tester.pumpWidget(
          IslamiHayatApp(
            locale: localeCase.locale,
            startupAccessVerifier: verifier(client),
            initialEntitlement: const EntitlementState.free(),
          ),
        );
        await tester.pump();

        expect(client.calls, 1);
        expect(find.text(localeCase.title), findsOneWidget);
        expect(find.text(localeCase.body), findsOneWidget);
        expect(find.text(localeCase.retry), findsOneWidget);
        expect(find.byType(AppShell), findsNothing);
        expect(
          tester.widget<Directionality>(find.byType(Directionality).first).textDirection,
          localeCase.direction,
        );
        expect(tester.takeException(), isNull);
      });
    }

    testWidgets('verified online FREE mounts AppShell only after HTTP 204',
        (tester) async {
      final client = _AppProbeClientT0262(204);

      await tester.pumpWidget(
        IslamiHayatApp(
          locale: const Locale('tr'),
          startupAccessVerifier: verifier(client),
          initialEntitlement: const EntitlementState.free(),
        ),
      );
      expect(find.byType(AppShell), findsNothing);

      await tester.pump();

      expect(client.calls, 1);
      expect(find.byType(AppShell), findsOneWidget);
    });

    testWidgets('cached PRO mounts AppShell without any reachability request',
        (tester) async {
      final client = _AppProbeClientT0262(null);

      await tester.pumpWidget(
        IslamiHayatApp(
          locale: const Locale('tr'),
          startupAccessVerifier: verifier(client),
          initialEntitlement: const EntitlementState.cachedPro(),
        ),
      );
      await tester.pump();

      expect(client.calls, 0);
      expect(find.byType(AppShell), findsOneWidget);
    });
  });
}

final class _OfflineLocaleCase {
  const _OfflineLocaleCase({
    required this.locale,
    required this.title,
    required this.body,
    required this.retry,
    required this.direction,
  });

  final Locale locale;
  final String title;
  final String body;
  final String retry;
  final TextDirection direction;
}
