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
