import 'package:flutter_test/flutter_test.dart';
import 'package:islami_hayat/core/network/internet_reachability.dart';
import 'package:islami_hayat/features/premium/domain/content_transition_access_guard.dart';
import 'package:islami_hayat/features/premium/domain/entitlement_state_machine.dart';

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
  final probe = InternetProbe(uri: Uri.parse('https://probe.example/204'));

  group('T0263 content transition access guard', () {
    test('FREE online can enter then fails closed after internet is cut', () async {
      final client = _MutableProbeClient()..response = 204;
      final verifier = InternetReachabilityVerifier(
        client: client,
        probes: <InternetProbe>[probe],
      );
      final guard = ContentTransitionAccessGuard(
        entitlement: const EntitlementState.free(),
        verifier: verifier,
      );

      expect(await guard.canEnterNewContent(), isTrue);
      client.response = null;
      expect(await guard.canEnterNewContent(), isFalse);
      expect(client.calls, 2);
    });

    test('captive portal response blocks FREE content transition', () async {
      final client = _MutableProbeClient()..response = 302;
      final guard = ContentTransitionAccessGuard(
        entitlement: const EntitlementState.free(),
        verifier: InternetReachabilityVerifier(
          client: client,
          probes: <InternetProbe>[probe],
        ),
      );

      expect(await guard.canEnterNewContent(), isFalse);
    });

    test('PRO never performs transition reachability probe', () async {
      final client = _MutableProbeClient()..response = null;
      final guard = ContentTransitionAccessGuard(
        entitlement: const EntitlementState.cachedPro(),
        verifier: InternetReachabilityVerifier(
          client: client,
          probes: <InternetProbe>[probe],
        ),
      );

      expect(await guard.canEnterNewContent(), isTrue);
      expect(client.calls, 0);
    });
  });
}
