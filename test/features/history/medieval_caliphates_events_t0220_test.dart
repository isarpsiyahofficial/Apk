import 'package:flutter_test/flutter_test.dart';
import 'package:islami_hayat/features/history/data/medieval_caliphates_events_t0220.dart';
import 'package:islami_hayat/features/history/data/medieval_caliphates_regional_dynasties.dart';
import 'package:islami_hayat/features/history/data/pre_islam_world_context.dart';
import 'package:islami_hayat/features/history/domain/history_event_contract.dart';

void main() {
  group('T0214 -> T0220 migration', () {
    test('migrates every canonical T0214 entry exactly once', () {
      expect(
        medievalHistoryT0214EventsT0220.map((event) => event.id).toSet(),
        medievalHistoryT0214.entries.map((entry) => entry.id).toSet(),
      );
      expect(
        medievalHistoryT0214EventsT0220.length,
        medievalHistoryT0214.entries.length,
      );
    });

    test('preserves chronology, source IDs and research status', () {
      for (final source in medievalHistoryT0214.entries) {
        final migrated = medievalHistoryT0214EventsT0220.singleWhere(
          (event) => event.id == source.id,
        );

        expect(migrated.startYearCe, source.startYearCe);
        expect(migrated.endYearCe, source.endYearCe);
        expect(migrated.sourceIds, source.sourceIds);
        expect(migrated.status, source.status);
      }
    });

    test('fills every T0220 mandatory event field in TR EN AR', () {
      for (final event in medievalHistoryT0214EventsT0220) {
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
      expect(medievalHistoryT0214EventDatasetT0220.productionEvents, isEmpty);
      expect(
        medievalHistoryT0214EventsT0220.every(
          (event) => event.status == HistoryResearchStatus.researchDraft,
        ),
        isTrue,
      );
    });

    test('keeps broad or contested legacy certainty non-exact', () {
      for (final source in medievalHistoryT0214.entries.where(
        (entry) =>
            entry.certainty != MedievalHistoryCertainty.establishedChronology,
      )) {
        final migrated = medievalHistoryT0214EventsT0220.singleWhere(
          (event) => event.id == source.id,
        );
        expect(migrated.dateCertainty, isNot(HistoryDateCertainty.exact));
      }
    });

    test('key actors and geographies stay attached to their event, not guessed globally', () {
      final andalus = medievalHistoryT0214EventsT0220.singleWhere(
        (event) => event.id == 'umayyad_al_andalus',
      );
      final buyid = medievalHistoryT0214EventsT0220.singleWhere(
        (event) => event.id == 'buyid_regional_power',
      );

      expect(
        andalus.people.map((person) => person.id),
        containsAll(<String>['abd_al_rahman_i', 'abd_al_rahman_iii']),
      );
      expect(
        andalus.geographies.map((geo) => geo.id),
        contains('al_andalus_cordoba'),
      );
      expect(
        buyid.people.map((person) => person.id),
        contains('ahmad_ibn_buya_muizz_al_dawla'),
      );
      expect(
        buyid.geographies.map((geo) => geo.id),
        containsAll(<String>['western_iran_iraq', 'iraq_baghdad']),
      );
    });
  });
}
