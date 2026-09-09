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

    for (final probe in this.probes) {
      if (probe.uri.scheme != 'https' || probe.uri.host.isEmpty) {
        throw ArgumentError.value(
          probe.uri,
          'probes',
          'reachability probes must use absolute HTTPS URLs',
        );
      }
      if (probe.uri.userInfo.isNotEmpty || probe.uri.fragment.isNotEmpty) {
        throw ArgumentError.value(
          probe.uri,
          'probes',
          'reachability probes must not contain credentials or fragments',
        );
      }
      if (probe.expectedStatusCode != HttpStatus.noContent) {
        throw ArgumentError.value(
          probe.expectedStatusCode,
          'probes',
          'reachability probes must require HTTP 204',
        );
      }
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
      int? status;
      try {
        status = await _client.statusCode(
          probe.uri,
          timeout: probeTimeout,
        );
      } on Object {
        // Reachability is a gate, so a broken DNS/socket/custom probe client
        // must never bubble out as an accidental allow or crash. Treat the
        // failed probe exactly like a timeout and continue to the next pinned
        // HTTPS 204 endpoint. If every probe fails, the result stays closed.
        status = null;
      }
      if (status == probe.expectedStatusCode) {
        return InternetReachability.reachable;
      }
    }

    return InternetReachability.unreachable;
  }
}
