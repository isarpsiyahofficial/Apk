import 'package:flutter_test/flutter_test.dart';
import 'package:islami_hayat/features/history/data/muhammad_period_events_t0220.dart';
import 'package:islami_hayat/features/history/data/pre_islam_world_context.dart';
import 'package:islami_hayat/features/history/domain/history_event_contract.dart';
import 'package:islami_hayat/features/history/domain/muhammad_history_seerah_bridge.dart';
import 'package:islami_hayat/features/prophets/data/muhammad_seerah_timeline.dart';

void main() {
  group('T0212 -> T0220 Muhammad-period migration', () {
    test('is a 1:1 projection of the canonical seerah bridge', () {
      final events = muhammadPeriodEventsT0220.events;
      expect(events.length, muhammadSeerahT0201Events.length);
      expect(events.length, canonicalMuhammadHistorySeerahBridge.links.length);

      for (var index = 0; index < events.length; index++) {
        final migrated = events[index];
        final seerah = muhammadSeerahT0201Events[index];
        final link = canonicalMuhammadHistorySeerahBridge.links[index];

        expect(migrated.id, link.historyEventId);
        expect(link.seerahEventId, seerah.id);
        expect(
          migrated.sourceIds,
          seerah.sources.map((source) => source.id).toList(growable: false),
        );
        expect(migrated.status, HistoryResearchStatus.researchDraft);
      }
    });

    test('does not manufacture calendar years absent from T0201', () {
      for (final event in muhammadPeriodEventsT0220.events) {
        expect(event.startYearCe, isNull);
        expect(event.endYearCe, isNull);
        expect(event.dateCertainty, HistoryDateCertainty.unknown);
        expect(event.dateCaveat.isComplete, isTrue);
      }
      expect(muhammadPeriodEventsT0220.productionEvents, isEmpty);
    });

    test('all mandatory T0220 narrative/actor/geography fields are complete', () {
      for (final event in muhammadPeriodEventsT0220.events) {
        expect(event.title.isComplete, isTrue);
        expect(event.beforeContext.isComplete, isTrue);
        expect(event.causes, isNotEmpty);
        expect(event.causes.every((value) => value.isComplete), isTrue);
        expect(event.consequences, isNotEmpty);
        expect(event.consequences.every((value) => value.isComplete), isTrue);
        expect(event.people, isNotEmpty);
        expect(event.people.every((value) => value.isComplete), isTrue);
        expect(event.geographies, isNotEmpty);
        expect(event.geographies.every((value) => value.isComplete), isTrue);
        expect(event.sourceIds, isNotEmpty);
      }
    });

    test('preserves phase ordering instead of creating a second chronology', () {
      for (var index = 0; index < muhammadPeriodEventsT0220.events.length; index++) {
        final migrated = muhammadPeriodEventsT0220.events[index];
        final link = canonicalMuhammadHistorySeerahBridge.links[index];
        final resolved = canonicalMuhammadHistorySeerahBridge.resolveSeerahEvent(migrated.id);

        expect(resolved.id, link.seerahEventId);
        expect(resolved.order, link.order);
        expect(resolved.phase, link.phase);
      }
    });

    test('Abyssinia and conquest records do not inherit the wrong default geography', () {
      final abyssiniaSource = muhammadSeerahT0201Events.singleWhere(
        (event) => event.kind == SeerahEventKind.abyssiniaMigration,
      );
      final abyssinia = muhammadPeriodEventsT0220.events.singleWhere(
        (event) => event.id == 'history:${abyssiniaSource.id}',
      );
      expect(abyssinia.geographies.single.id, 'region:abyssinia');

      final conquestSource = muhammadSeerahT0201Events.singleWhere(
        (event) => event.kind == SeerahEventKind.conquestOfMecca,
      );
      final conquest = muhammadPeriodEventsT0220.events.singleWhere(
        (event) => event.id == 'history:${conquestSource.id}',
      );
      expect(conquest.geographies.single.id, 'city:mecca');
    });
  });
}
