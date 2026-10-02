import 'package:flutter_test/flutter_test.dart';
import 'package:islami_hayat/features/history/data/history_t0220_inventory.dart';
import 'package:islami_hayat/features/history/domain/history_filters_t0221.dart';

void main() {
  test('T0221 rejects a silently omitted canonical dynasty assignment', () {
    final dynasties = <String, Set<String>>{
      for (final entry in T0221CanonicalFilterGate.expectedDynastyIdsByEvent.entries)
        entry.key: {...entry.value},
    }..remove('ottoman_empire');

    expect(
      () => T0221CanonicalFilterGate.validate(
        events: historyT0220Inventory.events,
        dynastyIdsByEvent: dynasties,
        subjectsByEvent: T0221CanonicalFilterGate.expectedSubjectsByEvent,
      ),
      throwsStateError,
    );
  });

  test('T0221 rejects a canonical event mapped to the wrong dynasty', () {
    final dynasties = <String, Set<String>>{
      for (final entry in T0221CanonicalFilterGate.expectedDynastyIdsByEvent.entries)
        entry.key: {...entry.value},
    };
    dynasties['ottoman_empire'] = {'safavid'};

    expect(
      () => T0221CanonicalFilterGate.validate(
        events: historyT0220Inventory.events,
        dynastyIdsByEvent: dynasties,
        subjectsByEvent: T0221CanonicalFilterGate.expectedSubjectsByEvent,
      ),
      throwsStateError,
    );
  });

  test('T0221 rejects a silently omitted canonical subject assignment', () {
    final subjects = <String, Set<HistorySubjectFacet>>{
      for (final entry in T0221CanonicalFilterGate.expectedSubjectsByEvent.entries)
        entry.key: {...entry.value},
    }..remove('first_fitna');

    expect(
      () => T0221CanonicalFilterGate.validate(
        events: historyT0220Inventory.events,
        dynastyIdsByEvent: T0221CanonicalFilterGate.expectedDynastyIdsByEvent,
        subjectsByEvent: subjects,
      ),
      throwsStateError,
    );
  });

  test('T0221 rejects an inventory missing an event required by filter metadata', () {
    final events = historyT0220Inventory.events
        .where((event) => event.id != 'ottoman_empire')
        .toList(growable: false);

    expect(
      () => T0221CanonicalFilterGate.validate(
        events: events,
        dynastyIdsByEvent: T0221CanonicalFilterGate.expectedDynastyIdsByEvent,
        subjectsByEvent: T0221CanonicalFilterGate.expectedSubjectsByEvent,
      ),
      throwsStateError,
    );
  });
}
