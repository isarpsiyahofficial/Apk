import 'package:flutter_test/flutter_test.dart';
import 'package:islami_hayat/features/history/data/modern_global_events_t0220.dart';
import 'package:islami_hayat/features/history/data/modern_global_islamic_history.dart';
import 'package:islami_hayat/features/history/data/pre_islam_world_context.dart';
import 'package:islami_hayat/features/history/domain/history_event_contract.dart';

void main() {
  group('T0218 -> T0220 migration', () {
    test('migrates every canonical T0218 entry exactly once', () {
      expect(
        modernGlobalEventsT0220.events.map((event) => event.id).toSet(),
        modernGlobalHistoryT0218.entries.map((entry) => entry.id).toSet(),
      );
      expect(
        modernGlobalEventsT0220.events.length,
        modernGlobalHistoryT0218.entries.length,
      );
    });

    test('preserves chronology, source IDs, caveats and research status', () {
      for (final source in modernGlobalHistoryT0218.entries) {
        final migrated = modernGlobalEventsT0220.events.singleWhere(
          (event) => event.id == source.id,
        );
        expect(migrated.startYearCe, source.startYearCe, reason: source.id);
        expect(migrated.endYearCe, source.endYearCe, reason: source.id);
        expect(migrated.dateCaveat, source.caveat, reason: source.id);
        expect(migrated.sourceIds, source.sourceIds, reason: source.id);
        expect(migrated.status, source.status, reason: source.id);
      }
    });

    test('fills every T0220 mandatory event field in TR EN AR', () {
      for (final event in modernGlobalEventsT0220.events) {
        expect(event.title.isComplete, isTrue, reason: event.id);
        expect(event.dateCaveat.isComplete, isTrue, reason: event.id);
        expect(event.beforeContext.isComplete, isTrue, reason: event.id);
        expect(event.causes, isNotEmpty, reason: event.id);
        expect(
          event.causes.every((value) => value.isComplete),
          isTrue,
          reason: event.id,
        );
        expect(event.consequences, isNotEmpty, reason: event.id);
        expect(
          event.consequences.every((value) => value.isComplete),
          isTrue,
          reason: event.id,
        );
        expect(event.people, isNotEmpty, reason: event.id);
        expect(
          event.people.every((value) => value.isComplete),
          isTrue,
          reason: event.id,
        );
        expect(event.geographies, isNotEmpty, reason: event.id);
        expect(
          event.geographies.every((value) => value.isComplete),
          isTrue,
          reason: event.id,
        );
      }
    });

    test('does not promote research drafts during migration', () {
      expect(modernGlobalEventsT0220.productionEvents, isEmpty);
      expect(
        modernGlobalEventsT0220.events.every(
          (event) => event.status == HistoryResearchStatus.researchDraft,
        ),
        isTrue,
      );
    });

    test('preserves broad, contested and snapshot-bounded uncertainty', () {
      for (final source in modernGlobalHistoryT0218.entries) {
        final migrated = modernGlobalEventsT0220.events.singleWhere(
          (event) => event.id == source.id,
        );
        expect(
          migrated.dateCertainty,
          isNot(HistoryDateCertainty.exact),
          reason: source.id,
        );
        switch (source.certainty) {
          case ModernGlobalHistoryCertainty.broadPeriod:
            expect(
              migrated.dateCertainty,
              HistoryDateCertainty.broadRange,
              reason: source.id,
            );
          case ModernGlobalHistoryCertainty.contestedInterpretation:
            expect(
              migrated.dateCertainty,
              HistoryDateCertainty.contested,
              reason: source.id,
            );
          case ModernGlobalHistoryCertainty.snapshotBounded:
            expect(
              migrated.dateCertainty,
              HistoryDateCertainty.broadRange,
              reason: source.id,
            );
        }
      }
    });

    test('keeps 2026 as dataset currency boundary rather than exact endpoint', () {
      final source = modernGlobalHistoryT0218.entries.singleWhere(
        (entry) => entry.id == 'contemporary_global_muslim_societies',
      );
      final migrated = modernGlobalEventsT0220.events.singleWhere(
        (event) => event.id == source.id,
      );

      expect(source.certainty, ModernGlobalHistoryCertainty.snapshotBounded);
      expect(migrated.endYearCe, 2026);
      expect(migrated.dateCertainty, HistoryDateCertainty.broadRange);
      expect(migrated.dateCaveat, source.caveat);
      expect(migrated.dateCaveat.en, contains('currency boundary'));
      expect(migrated.dateCaveat.en, contains('not a historical endpoint'));
    });

    test('keeps actors and regional geography isolated by modern track', () {
      const expected = <String, (String, String)>{
        'colonial_imperial_rule': (
          'colonial_imperial_muslim_societies_and_empires',
          'colonial_imperial_muslim_regions',
        ),
        'decolonization_nation_states': (
          'decolonization_muslim_societies_and_state_builders',
          'decolonization_muslim_regions',
        ),
        'twentieth_century_transformations': (
          'twentieth_century_muslim_social_religious_actors',
          'twentieth_century_global_muslim_regions',
        ),
        'contemporary_global_muslim_societies': (
          'contemporary_global_muslim_societies_actors',
          'contemporary_global_muslim_geographies',
        ),
      };

      for (final event in modernGlobalEventsT0220.events) {
        final ids = expected[event.id]!;
        expect(event.people.map((person) => person.id), contains(ids.$1));
        expect(event.geographies.map((geo) => geo.id), contains(ids.$2));
        expect(
          event.geographies.every(
            (geo) => geo.precision == HistoryGeographyPrecision.regional,
          ),
          isTrue,
          reason: event.id,
        );
      }
    });
  });
}
