import '../domain/history_event_contract.dart';
import '../domain/history_record_classification.dart';
import 'early_modern_events_t0220.dart';
import 'high_medieval_events_t0220.dart';
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

/// Final T0220 engineering inventory.
///
/// T0212–T0218 are the canonical event-bearing history tracks and each already
/// has a migration test proving 1:1 correspondence with its legacy dataset.
/// T0211 and T0219 are explicitly classified as non-event background/theme
/// records so the event contract cannot force artificial dates or actors onto
/// contextual material.
final historyT0220Inventory = HistoryT0220Inventory.validated(
  events: <HistoryEventRecord>[
    ...muhammadPeriodEventsT0220.events,
    ...earlyCaliphateT0220Dataset.events,
    ...medievalHistoryT0214EventDatasetT0220.events,
    ...highMedievalHistoryT0215EventDatasetT0220.events,
    ...earlyModernEventsT0220.events,
    ...regionalEventsT0220.events,
    ...modernGlobalEventsT0220.events,
  ],
  nonEvents: historyNonEventClassificationT0220,
);
