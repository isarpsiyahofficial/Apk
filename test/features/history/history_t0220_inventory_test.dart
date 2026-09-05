import 'package:flutter_test/flutter_test.dart';
import 'package:islami_hayat/features/history/data/early_modern_events_t0220.dart';
import 'package:islami_hayat/features/history/data/high_medieval_events_t0220.dart';
import 'package:islami_hayat/features/history/data/history_t0220_inventory.dart';
import 'package:islami_hayat/features/history/data/medieval_caliphates_events_t0220.dart';
import 'package:islami_hayat/features/history/data/modern_global_events_t0220.dart';
import 'package:islami_hayat/features/history/data/muhammad_period_events_t0220.dart';
import 'package:islami_hayat/features/history/data/rashidun_first_fitna_events_t0220.dart';
import 'package:islami_hayat/features/history/data/regional_events_t0220.dart';
import 'package:islami_hayat/features/history/domain/history_record_classification.dart';

void main() {
  group('T0220 final inventory', () {
    test('contains every migrated event exactly once across T0212-T0218', () {
      final expected = {
        ...muhammadPeriodEventsT0220.events.map((event) => event.id),
        ...earlyCaliphateT0220Dataset.events.map((event) => event.id),
        ...medievalHistoryT0214EventDatasetT0220.events.map((event) => event.id),
        ...highMedievalHistoryT0215EventDatasetT0220.events.map((event) => event.id),
        ...earlyModernEventsT0220.events.map((event) => event.id),
        ...regionalEventsT0220.events.map((event) => event.id),
        ...modernGlobalEventsT0220.events.map((event) => event.id),
      };
      final summedLength = muhammadPeriodEventsT0220.events.length +
          earlyCaliphateT0220Dataset.events.length +
          medievalHistoryT0214EventDatasetT0220.events.length +
          highMedievalHistoryT0215EventDatasetT0220.events.length +
          earlyModernEventsT0220.events.length +
          regionalEventsT0220.events.length +
          modernGlobalEventsT0220.events.length;

      expect(historyT0220Inventory.eventIds, expected);
      expect(historyT0220Inventory.events, hasLength(summedLength));
      expect(expected, hasLength(summedLength));
    });

    test('keeps T0211 and T0219 classifications outside the event inventory', () {
      expect(
        historyT0220Inventory.eventIds.intersection(
          historyT0220Inventory.nonEvents.ids,
        ),
        isEmpty,
      );
      expect(
        historyT0220Inventory.nonEvents.records.every(
          (record) => record.kind != HistoryRecordKind.event,
        ),
        isTrue,
      );
    });

    test('all inventoried events have passed the mandatory T0220 constructor', () {
      for (final event in historyT0220Inventory.events) {
        expect(event.id, isNotEmpty);
        expect(event.title.isComplete, isTrue);
        expect(event.dateCaveat.isComplete, isTrue);
        expect(event.beforeContext.isComplete, isTrue);
        expect(event.causes, isNotEmpty);
        expect(event.consequences, isNotEmpty);
        expect(event.people, isNotEmpty);
        expect(event.geographies, isNotEmpty);
        expect(event.sourceIds, isNotEmpty);
      }
    });

    test('fails closed on duplicate event identities', () {
      final events = historyT0220Inventory.events;
      expect(
        () => HistoryT0220Inventory.validated(
          events: [events.first, ...events],
          nonEvents: historyNonEventClassificationT0220,
        ),
        throwsStateError,
      );
    });
  });
}
