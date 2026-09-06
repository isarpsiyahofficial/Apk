import 'package:flutter_test/flutter_test.dart';
import 'package:islami_hayat/core/network/internet_reachability.dart';

final class _FakeProbeClient implements InternetProbeClient {
  _FakeProbeClient(this.responses);

  final Map<String, int?> responses;
  final List<Uri> calls = <Uri>[];

  @override
  Future<int?> statusCode(
    Uri uri, {
    required Duration timeout,
  }) async {
    calls.add(uri);
    return responses[uri.toString()];
  }
}

void main() {
  final first = InternetProbe(uri: Uri.parse('https://one.example/generate_204'));
  final second = InternetProbe(uri: Uri.parse('https://two.example/generate_204'));

  group('T0261 real internet reachability verification', () {
    test('transport unavailable fails closed without network probe', () async {
      final client = _FakeProbeClient(<String, int?>{});
      final verifier = InternetReachabilityVerifier(
        client: client,
        probes: <InternetProbe>[first],
      );

      final result = await verifier.verify(transportAvailable: false);

      expect(result, InternetReachability.unreachable);
      expect(client.calls, isEmpty);
    });

    test('wifi flag alone is insufficient when HTTPS probe fails', () async {
      final client = _FakeProbeClient(<String, int?>{
        first.uri.toString(): null,
      });
      final verifier = InternetReachabilityVerifier(
        client: client,
        probes: <InternetProbe>[first],
      );

      final result = await verifier.verify(transportAvailable: true);

      expect(result, InternetReachability.unreachable);
      expect(client.calls, <Uri>[first.uri]);
    });

    test('expected 204 proves usable internet access', () async {
      final client = _FakeProbeClient(<String, int?>{
        first.uri.toString(): 204,
      });
      final verifier = InternetReachabilityVerifier(
        client: client,
        probes: <InternetProbe>[first],
      );

      final result = await verifier.verify();

      expect(result, InternetReachability.reachable);
    });

    test('captive portal redirect or login page is not internet success', () async {
      for (final status in <int>[200, 301, 302, 307, 308]) {
        final client = _FakeProbeClient(<String, int?>{
          first.uri.toString(): status,
        });
        final verifier = InternetReachabilityVerifier(
          client: client,
          probes: <InternetProbe>[first],
        );

        expect(
          await verifier.verify(),
          InternetReachability.unreachable,
          reason: 'status $status must not pass the 204 reachability gate',
        );
      }
    });

    test('falls back to second probe after timeout/failure', () async {
      final client = _FakeProbeClient(<String, int?>{
        first.uri.toString(): null,
        second.uri.toString(): 204,
      });
      final verifier = InternetReachabilityVerifier(
        client: client,
        probes: <InternetProbe>[first, second],
      );

      final result = await verifier.verify();

      expect(result, InternetReachability.reachable);
      expect(client.calls, <Uri>[first.uri, second.uri]);
    });

    test('all probes failing remains fail-closed unreachable', () async {
      final client = _FakeProbeClient(<String, int?>{
        first.uri.toString(): null,
        second.uri.toString(): 503,
      });
      final verifier = InternetReachabilityVerifier(
        client: client,
        probes: <InternetProbe>[first, second],
      );

      expect(await verifier.verify(), InternetReachability.unreachable);
    });

    test('empty probe set and non-positive timeout are rejected', () {
      expect(
        () => InternetReachabilityVerifier(
          client: _FakeProbeClient(<String, int?>{}),
          probes: const <InternetProbe>[],
        ),
        throwsArgumentError,
      );
      expect(
        () => InternetReachabilityVerifier(
          client: _FakeProbeClient(<String, int?>{}),
          probes: <InternetProbe>[first],
          probeTimeout: Duration.zero,
        ),
        throwsArgumentError,
      );
    });
  });
}
