import '../data/prophet_deep_links.dart';
import 'prophet_deep_link_authorization_t0202.dart';

/// Runtime executor for T0202 prophet cross-module navigation.
///
/// The data layer owns validation/parsing. This layer owns the actual dispatch
/// contract and deliberately refuses to invent a destination when a feature
/// adapter is not available yet (notably reviewed History/Map datasets).
typedef QuranVerseDeepLinkHandler = Future<void> Function({
  required String prophetId,
  required int surah,
  required int ayah,
});

typedef ProphetTargetDeepLinkHandler = Future<void> Function({
  required String prophetId,
  required String targetId,
});

final class ProphetDeepLinkExecutionHandlers {
  const ProphetDeepLinkExecutionHandlers({
    this.openQuranVerse,
    this.openDua,
    this.openIslamicHistory,
    this.openMap,
  });

  final QuranVerseDeepLinkHandler? openQuranVerse;
  final ProphetTargetDeepLinkHandler? openDua;
  final ProphetTargetDeepLinkHandler? openIslamicHistory;
  final ProphetTargetDeepLinkHandler? openMap;
}

enum ProphetDeepLinkExecutionFailure {
  invalidLink,
  unauthorizedTarget,
  unavailableDestination,
}

final class ProphetDeepLinkExecutionResult {
  const ProphetDeepLinkExecutionResult._({
    required this.executed,
    this.failure,
  });

  const ProphetDeepLinkExecutionResult.executed()
      : this._(executed: true);

  const ProphetDeepLinkExecutionResult.failed(
    ProphetDeepLinkExecutionFailure failure,
  ) : this._(executed: false, failure: failure);

  final bool executed;
  final ProphetDeepLinkExecutionFailure? failure;
}

final class ProphetDeepLinkExecutor {
  const ProphetDeepLinkExecutor(
    this.handlers, {
    this.authorization,
  });

  final ProphetDeepLinkExecutionHandlers handlers;
  final ProphetDeepLinkAuthorization? authorization;

  Future<ProphetDeepLinkExecutionResult> execute(ProphetDeepLink link) async {
    if (!link.isValid) {
      return const ProphetDeepLinkExecutionResult.failed(
        ProphetDeepLinkExecutionFailure.invalidLink,
      );
    }
    final gate = authorization;
    if (gate != null && !gate.authorizes(link)) {
      return const ProphetDeepLinkExecutionResult.failed(
        ProphetDeepLinkExecutionFailure.unauthorizedTarget,
      );
    }

    switch (link.kind) {
      case ProphetDeepLinkKind.quranVerse:
        final handler = handlers.openQuranVerse;
        if (handler == null || link.surah == null || link.ayah == null) {
          return const ProphetDeepLinkExecutionResult.failed(
            ProphetDeepLinkExecutionFailure.unavailableDestination,
          );
        }
        await handler(
          prophetId: link.prophetId,
          surah: link.surah!,
          ayah: link.ayah!,
        );
      case ProphetDeepLinkKind.dua:
        final handler = handlers.openDua;
        if (handler == null) {
          return const ProphetDeepLinkExecutionResult.failed(
            ProphetDeepLinkExecutionFailure.unavailableDestination,
          );
        }
        await handler(prophetId: link.prophetId, targetId: link.targetId);
      case ProphetDeepLinkKind.islamicHistory:
        final handler = handlers.openIslamicHistory;
        if (handler == null) {
          return const ProphetDeepLinkExecutionResult.failed(
            ProphetDeepLinkExecutionFailure.unavailableDestination,
          );
        }
        await handler(prophetId: link.prophetId, targetId: link.targetId);
      case ProphetDeepLinkKind.map:
        final handler = handlers.openMap;
        if (handler == null) {
          return const ProphetDeepLinkExecutionResult.failed(
            ProphetDeepLinkExecutionFailure.unavailableDestination,
          );
        }
        await handler(prophetId: link.prophetId, targetId: link.targetId);
    }

    return const ProphetDeepLinkExecutionResult.executed();
  }

  Future<ProphetDeepLinkExecutionResult> executeUri(Uri uri) async {
    final link = parseProphetDeepLink(uri);
    if (link == null) {
      return const ProphetDeepLinkExecutionResult.failed(
        ProphetDeepLinkExecutionFailure.invalidLink,
      );
    }
    return execute(link);
  }
}