import 'package:flutter_test/flutter_test.dart';
import 'package:islami_hayat/features/history/data/pre_islam_world_context.dart';
import 'package:islami_hayat/features/history/data/regional_events_t0220.dart';
import 'package:islami_hayat/features/history/data/regional_islamic_histories.dart';
import 'package:islami_hayat/features/history/domain/history_event_contract.dart';

void main() {
  group('T0217 -> T0220 migration', () {
    test('migrates every canonical T0217 entry exactly once', () {
      expect(
        regionalEventsT0220.events.map((event) => event.id).toSet(),
        regionalIslamicHistoriesT0217.entries.map((entry) => entry.id).toSet(),
      );
      expect(
        regionalEventsT0220.events.length,
        regionalIslamicHistoriesT0217.entries.length,
      );
    });

    test('preserves chronology, source IDs and research status', () {
      for (final source in regionalIslamicHistoriesT0217.entries) {
        final migrated = regionalEventsT0220.events.singleWhere(
          (event) => event.id == source.id,
        );
        expect(migrated.startYearCe, source.startYearCe, reason: source.id);
        expect(migrated.endYearCe, source.endYearCe, reason: source.id);
        expect(migrated.sourceIds, source.sourceIds, reason: source.id);
        expect(migrated.status, source.status, reason: source.id);
      }
    });

    test('fills every T0220 mandatory event field in TR EN AR', () {
      for (final event in regionalEventsT0220.events) {
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
      expect(regionalEventsT0220.productionEvents, isEmpty);
      expect(
        regionalEventsT0220.events.every(
          (event) => event.status == HistoryResearchStatus.researchDraft,
        ),
        isTrue,
      );
    });

    test('keeps broad regional chronology non-exact', () {
      for (final source in regionalIslamicHistoriesT0217.entries) {
        final migrated = regionalEventsT0220.events.singleWhere(
          (event) => event.id == source.id,
        );
        expect(
          migrated.dateCertainty,
          isNot(HistoryDateCertainty.exact),
          reason: source.id,
        );
        if (source.certainty == RegionalIslamicHistoryCertainty.broadPeriod) {
          expect(
            migrated.dateCertainty,
            HistoryDateCertainty.broadRange,
            reason: source.id,
          );
        }
      }
    });

    test('keeps regional actors and geography isolated by track', () {
      const expected = <String, (String, String)>{
        'africa_islamic_history': (
          'african_muslim_societies_historical_actors',
          'africa_regional_history',
        ),
        'central_asia_islamic_history': (
          'central_asian_muslim_historical_actors',
          'central_asia_regional_history',
        ),
        'southeast_asia_islamic_history': (
          'southeast_asian_muslim_historical_actors',
          'southeast_asia_regional_history',
        ),
        'indian_subcontinent_islamic_history': (
          'indian_subcontinent_muslim_historical_actors',
          'indian_subcontinent_regional_history',
        ),
        'europe_islamic_history': (
          'european_muslim_historical_actors',
          'europe_regional_islamic_history',
        ),
      };

      for (final event in regionalEventsT0220.events) {
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
