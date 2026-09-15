import 'package:flutter_test/flutter_test.dart';
import 'package:islami_hayat/features/history/data/pre_islam_world_context.dart';
import 'package:islami_hayat/features/history/data/rashidun_first_fitna_events_t0220.dart';
import 'package:islami_hayat/features/history/data/rashidun_first_fitna_timeline.dart';
import 'package:islami_hayat/features/history/domain/history_event_contract.dart';

void main() {
  group('T0220 Rashidun/First Fitna migration', () {
    test('migrates every T0213 timeline entry one-to-one', () {
      expect(
        earlyCaliphateT0220Events,
        hasLength(earlyCaliphateResearchEntries.length),
      );
      expect(
        earlyCaliphateT0220Events.map((event) => event.id).toList(),
        earlyCaliphateResearchEntries.map((entry) => entry.id).toList(),
      );
    });

    test('preserves chronology, source references and research status', () {
      for (var i = 0; i < earlyCaliphateResearchEntries.length; i++) {
        final source = earlyCaliphateResearchEntries[i];
        final migrated = earlyCaliphateT0220Events[i];
        expect(migrated.startYearCe, source.startYearCe, reason: source.id);
        expect(migrated.endYearCe, source.endYearCe, reason: source.id);
        expect(migrated.sourceIds, source.sourceIds, reason: source.id);
        expect(migrated.status, source.status, reason: source.id);
      }
    });

    test('all migrated events satisfy the mandatory context fields', () {
      for (final event in earlyCaliphateT0220Events) {
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

    test('keeps all T0213 records behind the editorial production gate', () {
      expect(earlyCaliphateT0220Dataset.productionEvents, isEmpty);
      expect(
        earlyCaliphateT0220Events.every(
          (event) => event.status == HistoryResearchStatus.researchDraft,
        ),
        isTrue,
      );
    });

    test('contested First Fitna interpretation remains explicitly caveated', () {
      final fitna = earlyCaliphateT0220Events.singleWhere(
        (event) => event.id == 'first_fitna',
      );
      expect(fitna.dateCertainty, HistoryDateCertainty.contested);
      expect(fitna.dateCaveat.isComplete, isTrue);
      expect(
        fitna.people.map((person) => person.id),
        containsAll(['ali_ibn_abi_talib', 'muawiya_ibn_abi_sufyan']),
      );
    });
  });
}
