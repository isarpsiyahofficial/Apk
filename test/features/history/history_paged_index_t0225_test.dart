import 'package:flutter_test/flutter_test.dart';
import 'package:islamic_life/features/history/data/history_t0220_inventory.dart';
import 'package:islamic_life/features/history/domain/history_paged_index_t0225.dart';

void main() {
  group('HistoryPagedIndexT0225', () {
    test('does not invoke loader until first access and loads only once', () {
      var loaderCalls = 0;
      final index = HistoryPagedIndexT0225(
        loader: () {
          loaderCalls += 1;
          return historyT0220Inventory.events;
        },
      );

      expect(index.isLoaded, isFalse);
      expect(loaderCalls, 0);

      final firstPage = index.loadPage(pageSize: 5);
      expect(index.isLoaded, isTrue);
      expect(loaderCalls, 1);
      expect(firstPage.items, hasLength(5));
      expect(firstPage.totalCount, historyT0220Inventory.events.length);

      index.loadPage(cursor: firstPage.nextCursor!, pageSize: 5);
      expect(loaderCalls, 1);
    });

    test('pages are deterministic, bounded and do not overlap', () {
      final index = HistoryPagedIndexT0225(
        loader: () => historyT0220Inventory.events,
      );

      final first = index.loadPage(pageSize: 4);
      final second = index.loadPage(cursor: first.nextCursor!, pageSize: 4);

      expect(first.items.map((event) => event.id).toSet()
          .intersection(second.items.map((event) => event.id).toSet()), isEmpty);
      expect(first.items.length, lessThanOrEqualTo(4));
      expect(second.items.length, lessThanOrEqualTo(4));

      final combined = <String>[
        ...first.items.map((event) => event.id),
        ...second.items.map((event) => event.id),
      ];
      expect(combined.toSet(), hasLength(combined.length));
    });

    test('stable-ID person and geography indexes return only matching events', () {
      final index = HistoryPagedIndexT0225(
        loader: () => historyT0220Inventory.events,
      );
      final seed = index.loadPage(pageSize: 1).items.single;
      final personId = seed.people.first.id;
      final geographyId = seed.geographies.first.id;

      final personEvents = index.eventsForPerson(personId);
      final geographyEvents = index.eventsForGeography(geographyId);

      expect(personEvents, isNotEmpty);
      expect(
        personEvents.every(
          (event) => event.people.any((person) => person.id == personId),
        ),
        isTrue,
      );
      expect(geographyEvents, isNotEmpty);
      expect(
        geographyEvents.every(
          (event) => event.geographies.any((geo) => geo.id == geographyId),
        ),
        isTrue,
      );
      expect(index.eventById(seed.id)?.id, seed.id);
    });

    test('unknown or blank index keys do not invent matches', () {
      final index = HistoryPagedIndexT0225(
        loader: () => historyT0220Inventory.events,
      );

      expect(index.eventById(''), isNull);
      expect(index.eventsForPerson(''), isEmpty);
      expect(index.eventsForGeography(''), isEmpty);
      expect(index.eventById('event:does-not-exist'), isNull);
      expect(index.eventsForPerson('person:does-not-exist'), isEmpty);
      expect(index.eventsForGeography('geo:does-not-exist'), isEmpty);
    });

    test('invalid cursor and page size fail closed', () {
      final index = HistoryPagedIndexT0225(
        loader: () => historyT0220Inventory.events,
      );

      expect(() => index.loadPage(cursor: -1), throwsArgumentError);
      expect(() => index.loadPage(pageSize: 0), throwsArgumentError);
      expect(() => index.loadPage(pageSize: 101), throwsArgumentError);
      expect(
        () => index.loadPage(cursor: historyT0220Inventory.events.length + 1),
        throwsRangeError,
      );
    });

    test('empty and duplicate loader output fail closed', () {
      final empty = HistoryPagedIndexT0225(loader: () => const []);
      expect(() => empty.loadPage(), throwsStateError);

      final seed = historyT0220Inventory.events.first;
      final duplicate = HistoryPagedIndexT0225(loader: () => [seed, seed]);
      expect(() => duplicate.loadPage(), throwsStateError);
    });

    test('chronological ordering keeps unknown dates after dated events', () {
      final index = HistoryPagedIndexT0225(
        loader: () => historyT0220Inventory.events,
      );
      final all = index.loadPage(pageSize: 100).items;

      var seenUnknown = false;
      int? previousKnownYear;
      for (final event in all) {
        if (event.startYearCe == null) {
          seenUnknown = true;
          continue;
        }
        expect(seenUnknown, isFalse);
        if (previousKnownYear != null) {
          expect(event.startYearCe!, greaterThanOrEqualTo(previousKnownYear));
        }
        previousKnownYear = event.startYearCe;
      }
    });
  });
}
