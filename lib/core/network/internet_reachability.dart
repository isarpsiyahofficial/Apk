import 'dart:async';
import 'dart:io';

enum InternetReachability { reachable, unreachable }

final class InternetProbe {
  const InternetProbe({
    required this.uri,
    this.expectedStatusCode = HttpStatus.noContent,
  });

  final Uri uri;
  final int expectedStatusCode;
}

abstract interface class InternetProbeClient {
  Future<int?> statusCode(
    Uri uri, {
    required Duration timeout,
  });
}

final class IoInternetProbeClient implements InternetProbeClient {
  const IoInternetProbeClient();

  @override
  Future<int?> statusCode(
    Uri uri, {
    required Duration timeout,
  }) async {
    final client = HttpClient()..connectionTimeout = timeout;
    try {
      final request = await client.getUrl(uri).timeout(timeout);
      request.followRedirects = false;
      request.headers.set(HttpHeaders.cacheControlHeader, 'no-cache');
      final response = await request.close().timeout(timeout);
      final status = response.statusCode;
      await response.drain<void>().timeout(timeout);
      return status;
    } on Object {
      return null;
    } finally {
      client.close(force: true);
    }
  }
}

final class InternetReachabilityVerifier {
  InternetReachabilityVerifier({
    required InternetProbeClient client,
    List<InternetProbe>? probes,
    this.probeTimeout = const Duration(seconds: 4),
  })  : _client = client,
        probes = List<InternetProbe>.unmodifiable(
          probes ??
              <InternetProbe>[
                InternetProbe(
                  uri: Uri.parse(
                    'https://connectivitycheck.gstatic.com/generate_204',
                  ),
                ),
                InternetProbe(
                  uri: Uri.parse('https://clients3.google.com/generate_204'),
                ),
              ],
        ) {
    if (this.probes.isEmpty) {
      throw ArgumentError.value(probes, 'probes', 'must not be empty');
    }
    if (probeTimeout <= Duration.zero) {
      throw ArgumentError.value(
        probeTimeout,
        'probeTimeout',
        'must be positive',
      );
    }
  }

  final InternetProbeClient _client;
  final List<InternetProbe> probes;
  final Duration probeTimeout;

  Future<InternetReachability> verify({
    bool transportAvailable = true,
  }) async {
    if (!transportAvailable) {
      return InternetReachability.unreachable;
    }

    for (final probe in probes) {
      final status = await _client.statusCode(
        probe.uri,
        timeout: probeTimeout,
      );
      if (status == probe.expectedStatusCode) {
        return InternetReachability.reachable;
      }
    }

    return InternetReachability.unreachable;
  }
}
