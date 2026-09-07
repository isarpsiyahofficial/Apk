import '../../prophets/data/muhammad_seerah_timeline.dart';

/// T0212 bridge: the Islamic History Muhammad-period timeline must reuse the
/// canonical seerah chronology instead of maintaining a second drifting copy.
class MuhammadHistoryTimelineLink {
  const MuhammadHistoryTimelineLink({
    required this.historyEventId,
    required this.seerahEventId,
    required this.order,
    required this.phase,
  });

  final String historyEventId;
  final String seerahEventId;
  final int order;
  final SeerahPhase phase;

  bool get isValid =>
      historyEventId.trim().isNotEmpty &&
      seerahEventId.trim().isNotEmpty &&
      historyEventId == 'history:$seerahEventId' &&
      order > 0;
}

class MuhammadHistorySeerahBridge {
  MuhammadHistorySeerahBridge._({
    required List<MuhammadSeerahEvent> seerahEvents,
    required List<MuhammadHistoryTimelineLink> links,
  })  : _seerahEvents = List.unmodifiable(seerahEvents),
        links = List.unmodifiable(links);

  factory MuhammadHistorySeerahBridge.validated(
    List<MuhammadSeerahEvent> seerahEvents,
  ) {
    if (seerahEvents.isEmpty) {
      throw StateError('Muhammad seerah timeline cannot be empty.');
    }

    final ids = <String>{};
    final orders = <int>{};
    final historyIds = <String>{};
    var previousOrder = -1;
    var previousPhaseRank = -1;
    final links = <MuhammadHistoryTimelineLink>[];

    for (final event in seerahEvents) {
      if (!event.isValid) {
        throw StateError('Invalid seerah event: ${event.id}');
      }
      if (!ids.add(event.id)) {
        throw StateError('Duplicate seerah event id: ${event.id}');
      }
      if (!orders.add(event.order)) {
        throw StateError('Duplicate seerah event order: ${event.order}');
      }
      if (event.order <= previousOrder) {
        throw StateError('Seerah events must remain strictly chronological.');
      }
      previousOrder = event.order;

      final phaseRank = _phaseRank(event.phase);
      if (phaseRank < previousPhaseRank) {
        throw StateError('Seerah phase cannot move backwards in history.');
      }
      previousPhaseRank = phaseRank;

      final link = MuhammadHistoryTimelineLink(
        historyEventId: 'history:${event.id}',
        seerahEventId: event.id,
        order: event.order,
        phase: event.phase,
      );
      if (!link.isValid || !historyIds.add(link.historyEventId)) {
        throw StateError('Invalid or duplicate history/seerah link: ${event.id}');
      }
      links.add(link);
    }

    return MuhammadHistorySeerahBridge._(
      seerahEvents: seerahEvents,
      links: links,
    );
  }

  final List<MuhammadSeerahEvent> _seerahEvents;
  final List<MuhammadHistoryTimelineLink> links;

  MuhammadSeerahEvent resolveSeerahEvent(String historyEventId) {
    final matchingLinks = links.where(
      (link) => link.historyEventId == historyEventId,
    );
    if (matchingLinks.length != 1) {
      throw StateError('Unknown or ambiguous history event: $historyEventId');
    }

    final seerahId = matchingLinks.single.seerahEventId;
    return _seerahEvents.singleWhere((event) => event.id == seerahId);
  }

  MuhammadHistoryTimelineLink resolveHistoryLink(String seerahEventId) {
    final matchingLinks = links.where(
      (link) => link.seerahEventId == seerahEventId,
    );
    if (matchingLinks.length != 1) {
      throw StateError('Unknown or ambiguous seerah event: $seerahEventId');
    }
    return matchingLinks.single;
  }
}

int _phaseRank(SeerahPhase phase) => switch (phase) {
      SeerahPhase.birthAndEarlyLife => 0,
      SeerahPhase.meccan => 1,
      SeerahPhase.hijrah => 2,
      SeerahPhase.medinan => 3,
      SeerahPhase.finalYears => 4,
    };

final canonicalMuhammadHistorySeerahBridge =
    MuhammadHistorySeerahBridge.validated(muhammadSeerahT0201Events);
