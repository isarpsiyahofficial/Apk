import 'package:flutter_test/flutter_test.dart';
import 'package:islami_hayat/features/history/data/early_modern_events_t0220.dart';
import 'package:islami_hayat/features/history/data/early_modern_ottoman_safavid_mughal.dart';
import 'package:islami_hayat/features/history/data/pre_islam_world_context.dart';
import 'package:islami_hayat/features/history/domain/history_event_contract.dart';

void main() {
  group('T0216 -> T0220 migration', () {
    test('migrates every canonical T0216 entry exactly once', () {
      expect(
        earlyModernEventsT0220.events.map((event) => event.id).toSet(),
        earlyModernEmpiresT0216.entries.map((entry) => entry.id).toSet(),
      );
      expect(earlyModernEventsT0220.events.length, earlyModernEmpiresT0216.entries.length);
    });

    test('preserves chronology, source IDs and research status', () {
      for (final source in earlyModernEmpiresT0216.entries) {
        final migrated = earlyModernEventsT0220.events.singleWhere(
          (event) => event.id == source.id,
        );
        expect(migrated.startYearCe, source.startYearCe, reason: source.id);
        expect(migrated.endYearCe, source.endYearCe, reason: source.id);
        expect(migrated.sourceIds, source.sourceIds, reason: source.id);
        expect(migrated.status, source.status, reason: source.id);
      }
    });

    test('fills every T0220 mandatory event field in TR EN AR', () {
      for (final event in earlyModernEventsT0220.events) {
        expect(event.title.isComplete, isTrue, reason: event.id);
        expect(event.dateCaveat.isComplete, isTrue, reason: event.id);
        expect(event.beforeContext.isComplete, isTrue, reason: event.id);
        expect(event.causes, isNotEmpty, reason: event.id);
        expect(event.causes.every((value) => value.isComplete), isTrue,
            reason: event.id);
        expect(event.consequences, isNotEmpty, reason: event.id);
        expect(event.consequences.every((value) => value.isComplete), isTrue,
            reason: event.id);
        expect(event.people, isNotEmpty, reason: event.id);
        expect(event.people.every((value) => value.isComplete), isTrue,
            reason: event.id);
        expect(event.geographies, isNotEmpty, reason: event.id);
        expect(event.geographies.every((value) => value.isComplete), isTrue,
            reason: event.id);
      }
    });

    test('does not promote research drafts during migration', () {
      expect(earlyModernEventsT0220.productionEvents, isEmpty);
      expect(
        earlyModernEventsT0220.events.every(
          (event) => event.status == HistoryResearchStatus.researchDraft,
        ),
        isTrue,
      );
    });

    test('keeps broad legacy periods non-exact', () {
      for (final source in earlyModernEmpiresT0216.entries.where(
        (entry) =>
            entry.certainty != EarlyModernHistoryCertainty.establishedChronology,
      )) {
        final migrated = earlyModernEventsT0220.events.singleWhere(
          (event) => event.id == source.id,
        );
        expect(migrated.dateCertainty, isNot(HistoryDateCertainty.exact),
            reason: source.id);
      }
    });

    test('keeps event-specific actors and regional geography', () {
      final ottoman = earlyModernEventsT0220.events.singleWhere(
        (event) => event.id == 'ottoman_empire',
      );
      final safavid = earlyModernEventsT0220.events.singleWhere(
        (event) => event.id == 'safavid_iran',
      );
      final mughal = earlyModernEventsT0220.events.singleWhere(
        (event) => event.id == 'mughal_empire',
      );

      expect(ottoman.people.map((person) => person.id), contains('ottoman_dynasty'));
      expect(
        ottoman.geographies.map((geo) => geo.id),
        contains('anatolia_balkans_eastern_mediterranean'),
      );
      expect(
        safavid.people.map((person) => person.id),
        containsAll(<String>['shah_ismail_i', 'safavid_dynasty']),
      );
      expect(
        safavid.geographies.map((geo) => geo.id),
        contains('safavid_iran_caucasus'),
      );
      expect(mughal.people.map((person) => person.id), contains('babur'));
      expect(
        mughal.geographies.map((geo) => geo.id),
        contains('north_india_indian_subcontinent'),
      );
      expect(ottoman.dateCertainty, HistoryDateCertainty.broadRange);
      expect(safavid.dateCertainty, HistoryDateCertainty.broadRange);
      expect(mughal.dateCertainty, HistoryDateCertainty.broadRange);
    });
  });
}
