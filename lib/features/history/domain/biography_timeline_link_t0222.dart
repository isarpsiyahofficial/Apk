import '../../prophets/data/canonical_prophet_biographies.dart';
import '../data/history_t0220_inventory.dart';
import 'history_event_contract.dart';

/// A biography-page -> history-timeline relation for T0222.
///
/// `personId` deliberately reuses the stable person identifier already present
/// on T0220 history events. A relation therefore cannot be created from display
/// names or fuzzy text matching.
class HistoryBiographyTimelineEntryT0222 {
  const HistoryBiographyTimelineEntryT0222({
    required this.biographyId,
    required this.personId,
    required this.relatedEventIds,
  });

  final String biographyId;
  final String personId;
  final List<String> relatedEventIds;
}

class HistoryBiographyTimelineIndexT0222 {
  HistoryBiographyTimelineIndexT0222._({
    required this.entries,
    required this.eventsById,
  });

  factory HistoryBiographyTimelineIndexT0222.validated({
    required List<HistoryBiographyTimelineEntryT0222> entries,
    required List<HistoryEventRecord> events,
  }) {
    if (entries.isEmpty) {
      throw StateError('T0222 biography timeline index must not be empty.');
    }

    final eventsById = <String, HistoryEventRecord>{
      for (final event in events) event.id: event,
    };
    if (eventsById.length != events.length) {
      throw StateError('T0222 cannot index duplicate history event IDs.');
    }

    final biographyIds = <String>{};
    final normalizedEntries = <HistoryBiographyTimelineEntryT0222>[];

    for (final entry in entries) {
      final biographyId = entry.biographyId.trim();
      final personId = entry.personId.trim();
      if (biographyId.isEmpty || personId.isEmpty) {
        throw StateError('T0222 biography and person IDs are required.');
      }
      if (!biographyIds.add(biographyId)) {
        throw StateError('T0222 biography IDs must be unique: $biographyId');
      }

      final relatedIds = entry.relatedEventIds.map((id) => id.trim()).toList();
      if (relatedIds.any((id) => id.isEmpty) ||
          relatedIds.toSet().length != relatedIds.length) {
        throw StateError('T0222 related event IDs must be non-empty and unique.');
      }

      for (final eventId in relatedIds) {
        final event = eventsById[eventId];
        if (event == null) {
          throw StateError('T0222 biography links an unknown event: $eventId');
        }
        final personIsOnEvent = event.people.any((person) => person.id == personId);
        if (!personIsOnEvent) {
          throw StateError(
            'T0222 cannot link $biographyId to $eventId without an exact person ID match.',
          );
        }
      }

      normalizedEntries.add(
        HistoryBiographyTimelineEntryT0222(
          biographyId: biographyId,
          personId: personId,
          relatedEventIds: List.unmodifiable(relatedIds),
        ),
      );
    }

    return HistoryBiographyTimelineIndexT0222._(
      entries: List.unmodifiable(normalizedEntries),
      eventsById: Map.unmodifiable(eventsById),
    );
  }

  /// Builds links only for biography pages that already exist in the canonical
  /// prophet biography dataset. This does not invent biography pages for every
  /// T0220 actor (dynasties, communities, armies, institutions, etc.).
  factory HistoryBiographyTimelineIndexT0222.fromCanonicalProphetBiographies({
    required List<CanonicalProphetBiographyDraft> biographies,
    required List<HistoryEventRecord> events,
  }) {
    if (biographies.isEmpty ||
        biographies.any((biography) => !biography.isStructurallyComplete)) {
      throw StateError(
        'T0222 requires structurally valid canonical biography pages.',
      );
    }

    final entries = <HistoryBiographyTimelineEntryT0222>[];
    for (final biography in biographies) {
      final canonicalId = biography.identity.canonicalId.trim();
      if (canonicalId.isEmpty) {
        throw StateError('T0222 canonical biography ID must not be empty.');
      }
      final personId = 'prophet:$canonicalId';
      final relatedEventIds = events
          .where(
            (event) => event.people.any((person) => person.id == personId),
          )
          .map((event) => event.id)
          .toList(growable: false);

      entries.add(
        HistoryBiographyTimelineEntryT0222(
          biographyId: personId,
          personId: personId,
          relatedEventIds: relatedEventIds,
        ),
      );
    }

    return HistoryBiographyTimelineIndexT0222.validated(
      entries: entries,
      events: events,
    );
  }

  final List<HistoryBiographyTimelineEntryT0222> entries;
  final Map<String, HistoryEventRecord> eventsById;

  HistoryBiographyTimelineEntryT0222 requireBiography(String biographyId) {
    final normalized = biographyId.trim();
    for (final entry in entries) {
      if (entry.biographyId == normalized) return entry;
    }
    throw StateError('Unknown T0222 biography page: $normalized');
  }

  List<HistoryEventRecord> eventsForBiography(String biographyId) {
    final entry = requireBiography(biographyId);
    return List.unmodifiable(
      entry.relatedEventIds.map((eventId) => eventsById[eventId]!),
    );
  }

  List<HistoryBiographyTimelineEntryT0222> biographiesForEvent(
    String eventId,
  ) {
    if (!eventsById.containsKey(eventId)) {
      throw StateError('Unknown T0222 history event: $eventId');
    }
    return List.unmodifiable(
      entries.where((entry) => entry.relatedEventIds.contains(eventId)),
    );
  }
}

/// T0222 production engineering bridge.
///
/// At this stage the existing canonical biography pages are the 25 Quran-named
/// prophet biography drafts. Only biographies whose exact stable person ID is
/// already attached to a T0220 event receive timeline links. In practice this
/// links Prophet Muhammad's biography to the canonical seerah/history events;
/// other prophet biographies remain unlinked instead of receiving invented
/// historical events.
final historyBiographyTimelineT0222 =
    HistoryBiographyTimelineIndexT0222.fromCanonicalProphetBiographies(
  biographies: canonicalProphetBiographyDrafts,
  events: historyT0220Inventory.events,
);
