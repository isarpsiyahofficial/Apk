import '../domain/history_event_contract.dart';
import '../domain/history_record_classification.dart';
import '../domain/t0214_canonical_history_gate.dart';
import '../domain/t0215_canonical_history_gate.dart';
import '../domain/t0216_canonical_history_gate.dart';
import '../domain/t0217_canonical_history_gate.dart';
import '../domain/t0218_canonical_history_gate.dart';
import 'early_modern_events_t0220.dart';
import 'high_medieval_events_t0220.dart';
import 'islamic_history_t0219_canonical.dart';
import 'medieval_caliphates_events_t0220.dart';
import 'modern_global_events_t0220.dart';
import 'muhammad_period_events_t0220.dart';
import 'rashidun_first_fitna_events_t0220.dart';
import 'regional_events_t0220.dart';

class HistoryT0220Inventory {
  HistoryT0220Inventory._({required this.events, required this.nonEvents});

  factory HistoryT0220Inventory.validated({
    required List<HistoryEventRecord> events,
    required HistoryNonEventClassificationDataset nonEvents,
  }) {
    if (events.isEmpty) {
      throw StateError('T0220 final event inventory must not be empty.');
    }

    final eventIds = <String>{};
    for (final event in events) {
      if (!eventIds.add(event.id)) {
        throw StateError('T0220 final inventory contains a duplicate event ID: ${event.id}');
      }
    }

    final overlap = eventIds.intersection(nonEvents.ids);
    if (overlap.isNotEmpty) {
      throw StateError('T0220 records cannot be both event and non-event: $overlap');
    }

    return HistoryT0220Inventory._(
      events: List.unmodifiable(events),
      nonEvents: nonEvents,
    );
  }

  final List<HistoryEventRecord> events;
  final HistoryNonEventClassificationDataset nonEvents;

  Set<String> get eventIds => events.map((event) => event.id).toSet();
}

List<HistoryEventRecord> _validatedT0214Events() {
  T0214CanonicalHistoryGate.validateCanonicalDataset();
  return medievalHistoryT0214EventDatasetT0220.events;
}

List<HistoryEventRecord> _validatedT0215Events() {
  T0215CanonicalHistoryGate.validateCanonicalDataset();
  return highMedievalHistoryT0215EventDatasetT0220.events;
}

List<HistoryEventRecord> _validatedT0216Events() {
  T0216CanonicalHistoryGate.validateCanonicalDataset();
  return earlyModernEventsT0220.events;
}

List<HistoryEventRecord> _validatedT0217Events() {
  T0217CanonicalHistoryGate.validateCanonicalDataset();
  return regionalEventsT0220.events;
}

List<HistoryEventRecord> _validatedT0218Events() {
  T0218CanonicalHistoryGate.validateCanonicalDataset();
  return modernGlobalEventsT0220.events;
}

void _validateT0219HorizontalThemes() {
  final dataset = islamicHistoryHorizontalThemesT0219Canonical;
  if (dataset.entries.length != 9) {
    throw StateError('T0219 canonical horizontal-theme inventory is incomplete.');
  }
}

/// Final T0220 engineering inventory.
///
/// T0212–T0218 are the canonical event-bearing history tracks and each already
/// has a migration test proving 1:1 correspondence with its legacy dataset.
/// T0211 and T0219 are explicitly classified as non-event background/theme
/// records so the event contract cannot force artificial dates or actors onto
/// contextual material. T0219 still passes its canonical ID/theme/provenance
/// gate before the final history inventory can initialize.
final historyT0220Inventory = (() {
  _validateT0219HorizontalThemes();
  return HistoryT0220Inventory.validated(
    events: <HistoryEventRecord>[
      ...muhammadPeriodEventsT0220.events,
      ...earlyCaliphateT0220Dataset.events,
      ..._validatedT0214Events(),
      ..._validatedT0215Events(),
      ..._validatedT0216Events(),
      ..._validatedT0217Events(),
      ..._validatedT0218Events(),
    ],
    nonEvents: historyNonEventClassificationT0220,
  );
})();
