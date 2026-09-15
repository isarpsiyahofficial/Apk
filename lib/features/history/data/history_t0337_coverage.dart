import 'early_modern_events_t0220.dart';
import 'high_medieval_events_t0220.dart';
import 'history_t0220_inventory.dart';
import 'history_t0337_canonical_audit.dart';
import 'medieval_caliphates_events_t0220.dart';
import 'modern_global_events_t0220.dart';
import 'muhammad_period_events_t0220.dart';
import 'rashidun_first_fitna_events_t0220.dart';
import 'regional_events_t0220.dart';

class HistoryT0337CoverageReport {
  const HistoryT0337CoverageReport._({
    required this.canonicalEventIds,
    required this.auditedEventIds,
    required this.missingEventIds,
    required this.auditedTrackCount,
  });

  factory HistoryT0337CoverageReport.validated({
    required Iterable<String> canonicalEventIds,
    required List<Iterable<String>> auditedTrackEventIds,
  }) {
    final canonicalList = canonicalEventIds.map((id) => id.trim()).toList(growable: false);
    if (canonicalList.isEmpty || canonicalList.any((id) => id.isEmpty)) {
      throw StateError('T0337 canonical inventory must contain non-empty event IDs.');
    }
    final canonicalSet = canonicalList.toSet();
    if (canonicalSet.length != canonicalList.length) {
      throw StateError('T0337 canonical inventory contains duplicate event IDs.');
    }

    if (auditedTrackEventIds.isEmpty) {
      throw StateError('T0337 coverage requires at least one audited history track.');
    }

    final auditedList = <String>[];
    for (final track in auditedTrackEventIds) {
      final ids = track.map((id) => id.trim()).toList(growable: false);
      if (ids.isEmpty || ids.any((id) => id.isEmpty)) {
        throw StateError('T0337 audited tracks must contain non-empty event IDs.');
      }
      auditedList.addAll(ids);
    }

    final auditedSet = auditedList.toSet();
    if (auditedSet.length != auditedList.length) {
      throw StateError(
        'T0337 an event cannot be counted by more than one audited track.',
      );
    }

    final unexpected = auditedSet.difference(canonicalSet);
    if (unexpected.isNotEmpty) {
      throw StateError(
        'T0337 audited coverage contains events outside the canonical inventory: $unexpected',
      );
    }

    return HistoryT0337CoverageReport._(
      canonicalEventIds: Set.unmodifiable(canonicalSet),
      auditedEventIds: Set.unmodifiable(auditedSet),
      missingEventIds: Set.unmodifiable(canonicalSet.difference(auditedSet)),
      auditedTrackCount: auditedTrackEventIds.length,
    );
  }

  final Set<String> canonicalEventIds;
  final Set<String> auditedEventIds;
  final Set<String> missingEventIds;
  final int auditedTrackCount;

  int get canonicalEventCount => canonicalEventIds.length;
  int get auditedEventCount => auditedEventIds.length;
  bool get isComplete => missingEventIds.isEmpty;

  void requireComplete() {
    if (!isComplete) {
      throw StateError(
        'T0337 aggregate history audit is incomplete. Missing canonical events: $missingEventIds',
      );
    }
  }
}

HistoryT0337CoverageReport buildHistoryT0337CoverageReport() {
  final auditedResults = [
    auditEarlyCaliphateT0337(),
    auditMuhammadPartialT0337(),
    auditMedievalT0214T0337(),
    auditHighMedievalT0215T0337(),
    auditEarlyModernT0216T0337(),
    auditRegionalT0217T0337(),
    auditModernGlobalT0218T0337(),
  ];

  final auditedTracks = <Iterable<String>>[
    earlyCaliphateT0220Dataset.events.map((event) => event.id),
    muhammadPeriodEventsT0220.events
        .where((event) => muhammadPartialT0337EventIds.contains(event.id))
        .map((event) => event.id),
    medievalHistoryT0214EventDatasetT0220.events.map((event) => event.id),
    highMedievalHistoryT0215EventDatasetT0220.events.map((event) => event.id),
    earlyModernEventsT0220.events.map((event) => event.id),
    regionalEventsT0220.events.map((event) => event.id),
    modernGlobalEventsT0220.events.map((event) => event.id),
  ];

  final auditedResultCount = auditedResults.fold<int>(
    0,
    (total, result) => total + result.eventCount,
  );
  final auditedIdCount = auditedTracks.fold<int>(
    0,
    (total, ids) => total + ids.length,
  );
  if (auditedResultCount != auditedIdCount) {
    throw StateError(
      'T0337 per-track audit results drift from their canonical event projections.',
    );
  }

  return HistoryT0337CoverageReport.validated(
    canonicalEventIds: historyT0220Inventory.events.map((event) => event.id),
    auditedTrackEventIds: auditedTracks,
  );
}
