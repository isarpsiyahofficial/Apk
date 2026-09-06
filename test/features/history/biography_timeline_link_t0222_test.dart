import 'package:flutter_test/flutter_test.dart';
import 'package:islami_hayat/features/history/data/history_t0220_inventory.dart';
import 'package:islami_hayat/features/history/domain/biography_timeline_link_t0222.dart';
import 'package:islami_hayat/features/prophets/data/canonical_prophet_biographies.dart';

void main() {
  group('T0222 biography timeline links', () {
    test('indexes every existing canonical prophet biography page exactly once', () {
      expect(historyBiographyTimelineT0222.entries, hasLength(25));
      expect(
        historyBiographyTimelineT0222.entries.map((entry) => entry.biographyId).toSet(),
        hasLength(25),
      );
      expect(
        historyBiographyTimelineT0222.entries.map((entry) => entry.biographyId).toSet(),
        containsAll(
          canonicalProphetBiographyDrafts.map(
            (biography) => 'prophet:${biography.identity.canonicalId}',
          ),
        ),
      );
    });

    test('Muhammad biography resolves every exact T0220 Muhammad event', () {
      final expected = historyT0220Inventory.events
          .where(
            (event) => event.people.any(
              (person) => person.id == 'prophet:muhammad',
            ),
          )
          .toList(growable: false);
      final actual = historyBiographyTimelineT0222.eventsForBiography(
        'prophet:muhammad',
      );

      expect(expected, isNotEmpty);
      expect(actual.map((event) => event.id).toList(),
          expected.map((event) => event.id).toList());
      expect(
        actual.every(
          (event) => event.people.any(
            (person) => person.id == 'prophet:muhammad',
          ),
        ),
        isTrue,
      );
    });

    test('does not invent timeline events for biographies without exact person links', () {
      expect(
        historyBiographyTimelineT0222.eventsForBiography('prophet:ibrahim'),
        isEmpty,
      );
    });

    test('supports reverse event to biography lookup without fuzzy names', () {
      final muhammadEvent = historyT0220Inventory.events.firstWhere(
        (event) => event.people.any(
          (person) => person.id == 'prophet:muhammad',
        ),
      );
      final links = historyBiographyTimelineT0222.biographiesForEvent(
        muhammadEvent.id,
      );

      expect(links.map((entry) => entry.biographyId), contains('prophet:muhammad'));
      expect(
        links.every((entry) => entry.personId == 'prophet:muhammad'),
        isTrue,
      );
    });

    test('fails closed for unknown biography and unknown event IDs', () {
      expect(
        () => historyBiographyTimelineT0222.eventsForBiography('prophet:not-real'),
        throwsStateError,
      );
      expect(
        () => historyBiographyTimelineT0222.biographiesForEvent('history:not-real'),
        throwsStateError,
      );
    });

    test('rejects a fabricated biography to event relation', () {
      final knownEvent = historyT0220Inventory.events.first;
      expect(
        () => HistoryBiographyTimelineIndexT0222.validated(
          entries: [
            HistoryBiographyTimelineEntryT0222(
              biographyId: 'person:fabricated',
              personId: 'person:fabricated',
              relatedEventIds: [knownEvent.id],
            ),
          ],
          events: historyT0220Inventory.events,
        ),
        throwsStateError,
      );
    });

    test('rejects duplicate biography IDs and duplicate event links', () {
      expect(
        () => HistoryBiographyTimelineIndexT0222.validated(
          entries: const [
            HistoryBiographyTimelineEntryT0222(
              biographyId: 'bio:a',
              personId: 'person:a',
              relatedEventIds: [],
            ),
            HistoryBiographyTimelineEntryT0222(
              biographyId: 'bio:a',
              personId: 'person:b',
              relatedEventIds: [],
            ),
          ],
          events: historyT0220Inventory.events,
        ),
        throwsStateError,
      );

      final muhammadEvent = historyT0220Inventory.events.firstWhere(
        (event) => event.people.any(
          (person) => person.id == 'prophet:muhammad',
        ),
      );
      expect(
        () => HistoryBiographyTimelineIndexT0222.validated(
          entries: [
            HistoryBiographyTimelineEntryT0222(
              biographyId: 'prophet:muhammad',
              personId: 'prophet:muhammad',
              relatedEventIds: [muhammadEvent.id, muhammadEvent.id],
            ),
          ],
          events: historyT0220Inventory.events,
        ),
        throwsStateError,
      );
    });
  });
}
