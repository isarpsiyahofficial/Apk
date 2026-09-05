import 'package:flutter_test/flutter_test.dart';
import 'package:islami_hayat/features/history/data/islamic_history_horizontal_themes.dart';
import 'package:islami_hayat/features/history/data/pre_islam_world_context.dart';
import 'package:islami_hayat/features/history/domain/history_record_classification.dart';

void main() {
  group('T0220 event versus context classification', () {
    test('classifies every T0211 record 1:1 as background context', () {
      final expected = preIslamWorldResearchEntries.map((entry) => entry.id).toSet();
      final actual = historyNonEventClassificationT0220.records
          .where((record) => record.originTask == 'T0211')
          .toList();

      expect(actual.map((record) => record.id).toSet(), expected);
      expect(actual, hasLength(expected.length));
      expect(
        actual.every((record) => record.kind == HistoryRecordKind.backgroundContext),
        isTrue,
      );
    });

    test('classifies every T0219 record 1:1 as a horizontal theme', () {
      final expected = islamicHistoryT0219Entries.map((entry) => entry.id).toSet();
      final actual = historyNonEventClassificationT0220.records
          .where((record) => record.originTask == 'T0219')
          .toList();

      expect(actual.map((record) => record.id).toSet(), expected);
      expect(actual, hasLength(expected.length));
      expect(
        actual.every((record) => record.kind == HistoryRecordKind.horizontalTheme),
        isTrue,
      );
    });

    test('does not manufacture T0220 events from background or horizontal themes', () {
      expect(
        historyNonEventClassificationT0220.records
            .where((record) => record.kind == HistoryRecordKind.event),
        isEmpty,
      );
      expect(
        historyNonEventClassificationT0220.records.every(
          (record) => record.rationale.isComplete,
        ),
        isTrue,
      );
    });

    test('fails closed when a canonical T0219 record is missing', () {
      final records = historyNonEventClassificationT0220.records
          .where((record) => record.id != islamicHistoryT0219Entries.last.id)
          .toList();

      expect(
        () => HistoryNonEventClassificationDataset.validated(
          records: records,
          expectedT0211Ids: preIslamWorldResearchEntries.map((entry) => entry.id).toSet(),
          expectedT0219Ids: islamicHistoryT0219Entries.map((entry) => entry.id).toSet(),
        ),
        throwsStateError,
      );
    });

    test('fails closed if a non-event record is reclassified as an event', () {
      final first = historyNonEventClassificationT0220.records.first;
      final invalid = HistoryRecordClassification(
        id: first.id,
        originTask: first.originTask,
        kind: HistoryRecordKind.event,
        rationale: first.rationale,
      );

      expect(
        () => HistoryNonEventClassificationDataset.validated(
          records: [invalid, ...historyNonEventClassificationT0220.records.skip(1)],
          expectedT0211Ids: preIslamWorldResearchEntries.map((entry) => entry.id).toSet(),
          expectedT0219Ids: islamicHistoryT0219Entries.map((entry) => entry.id).toSet(),
        ),
        throwsStateError,
      );
    });
  });
}
