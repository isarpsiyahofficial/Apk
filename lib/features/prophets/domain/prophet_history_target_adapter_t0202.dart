import '../../history/data/pre_islam_world_context.dart';
import '../../history/domain/biography_timeline_link_t0222.dart';
import '../../history/domain/history_event_contract.dart';
import '../data/prophet_deep_links.dart';

/// Resolves a T0202 Prophet -> Islamic History deep link only when the exact
/// target is already joined to that prophet by the verified T0222 biography
/// timeline index.
///
/// No display-name, localized-text or fuzzy matching fallback is allowed. A
/// research-draft event is also refused even if its ID is present in a custom
/// index, so navigation cannot promote unfinished historical content.
final class ProphetHistoryTargetAdapterT0202 {
  const ProphetHistoryTargetAdapterT0202(this.index);

  final HistoryBiographyTimelineIndexT0222 index;

  HistoryEventRecord? resolve(ProphetDeepLink link) {
    if (!link.isValid || link.kind != ProphetDeepLinkKind.islamicHistory) {
      return null;
    }

    final biographyId = 'prophet:${link.prophetId}';
    try {
      final relation = index.requireBiography(biographyId);
      if (!relation.relatedEventIds.contains(link.targetId)) return null;

      for (final event in index.eventsForBiography(biographyId)) {
        if (event.id == link.targetId &&
            event.status == HistoryResearchStatus.reviewedForProduction) {
          return event;
        }
      }
    } on StateError {
      return null;
    }
    return null;
  }

  bool canOpen(ProphetDeepLink link) => resolve(link) != null;

  Future<bool> open(
    ProphetDeepLink link, {
    required Future<void> Function(HistoryEventRecord event) onOpen,
  }) async {
    final event = resolve(link);
    if (event == null) return false;
    await onOpen(event);
    return true;
  }
}
