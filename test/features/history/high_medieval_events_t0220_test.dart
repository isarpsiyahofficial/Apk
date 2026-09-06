import 'package:flutter_test/flutter_test.dart';
import 'package:islami_hayat/features/history/data/high_medieval_events_t0220.dart';
import 'package:islami_hayat/features/history/data/high_medieval_seljuq_crusades_mamluks.dart';
import 'package:islami_hayat/features/history/data/pre_islam_world_context.dart';
import 'package:islami_hayat/features/history/domain/history_event_contract.dart';

void main() {
  group('T0215 -> T0220 migration', () {
    test('migrates every canonical T0215 entry exactly once', () {
      expect(
        highMedievalHistoryT0215EventsT0220.map((event) => event.id).toSet(),
        highMedievalHistoryT0215.entries.map((entry) => entry.id).toSet(),
      );
      expect(
        highMedievalHistoryT0215EventsT0220.length,
        highMedievalHistoryT0215.entries.length,
      );
    });

    test('preserves chronology, source IDs and research status', () {
      for (final source in highMedievalHistoryT0215.entries) {
        final migrated = highMedievalHistoryT0215EventsT0220.singleWhere(
          (event) => event.id == source.id,
        );
        expect(migrated.startYearCe, source.startYearCe);
        expect(migrated.endYearCe, source.endYearCe);
        expect(migrated.sourceIds, source.sourceIds);
        expect(migrated.status, source.status);
      }
    });

    test('fills every T0220 mandatory event field in TR EN AR', () {
      for (final event in highMedievalHistoryT0215EventsT0220) {
        expect(event.title.isComplete, isTrue, reason: event.id);
        expect(event.dateCaveat.isComplete, isTrue, reason: event.id);
        expect(event.beforeContext.isComplete, isTrue, reason: event.id);
        expect(event.causes, isNotEmpty, reason: event.id);
        expect(event.causes.every((value) => value.isComplete), isTrue,
            reason: event.id);
        expect(event.consequences, isNotEmpty, reason: event.id);
        expect(
          event.consequences.every((value) => value.isComplete),
          isTrue,
          reason: event.id,
        );
        expect(event.people, isNotEmpty, reason: event.id);
        expect(event.people.every((value) => value.isComplete), isTrue,
            reason: event.id);
        expect(event.geographies, isNotEmpty, reason: event.id);
        expect(
          event.geographies.every((value) => value.isComplete),
          isTrue,
          reason: event.id,
        );
      }
    });

    test('does not promote research drafts during migration', () {
      expect(highMedievalHistoryT0215EventDatasetT0220.productionEvents, isEmpty);
      expect(
        highMedievalHistoryT0215EventsT0220.every(
          (event) => event.status == HistoryResearchStatus.researchDraft,
        ),
        isTrue,
      );
    });

    test('keeps broad legacy periods non-exact', () {
      for (final source in highMedievalHistoryT0215.entries.where(
        (entry) =>
            entry.certainty != HighMedievalHistoryCertainty.establishedChronology,
      )) {
        final migrated = highMedievalHistoryT0215EventsT0220.singleWhere(
          (event) => event.id == source.id,
        );
        expect(migrated.dateCertainty, isNot(HistoryDateCertainty.exact));
      }
    });

    test('keeps multi-sided Crusades and Mongol geography scoped to each event', () {
      final crusades = highMedievalHistoryT0215EventsT0220.singleWhere(
        (event) => event.id == 'crusading_movement_levant',
      );
      final mongols = highMedievalHistoryT0215EventsT0220.singleWhere(
        (event) => event.id == 'mongol_invasions_islamic_lands',
      );

      expect(
        crusades.people.map((person) => person.id),
        containsAll(<String>['latin_crusading_powers', 'muslim_levant_powers']),
      );
      expect(
        crusades.geographies.map((geo) => geo.id),
        contains('eastern_mediterranean_levant'),
      );
      expect(
        mongols.geographies.map((geo) => geo.id),
        contains('transoxiana_khorasan_iran_iraq_syria'),
      );
      expect(mongols.dateCertainty, HistoryDateCertainty.broadRange);
    });
  });
}
