import 'package:flutter_test/flutter_test.dart';
import 'package:islami_hayat/features/history/data/high_medieval_seljuq_crusades_mamluks.dart';
import 'package:islami_hayat/features/history/domain/t0215_canonical_history_gate.dart';

HighMedievalHistoryEntry copyEntry(
  HighMedievalHistoryEntry source, {
  String? id,
  HighMedievalHistoryTrack? track,
}) {
  return HighMedievalHistoryEntry(
    id: id ?? source.id,
    track: track ?? source.track,
    title: source.title,
    summary: source.summary,
    startYearCe: source.startYearCe,
    endYearCe: source.endYearCe,
    certainty: source.certainty,
    caveat: source.caveat,
    sourceIds: source.sourceIds,
    status: source.status,
  );
}

void main() {
  group('T0215 canonical history gate', () {
    test('accepts the governed five-record canonical dataset', () {
      expect(
        () => T0215CanonicalHistoryGate.validate(highMedievalHistoryT0215),
        returnsNormally,
      );
    });

    test('rejects an extra ungoverned record even when base validation accepts it', () {
      final extra = copyEntry(
        highMedievalHistoryT0215Entries.first,
        id: 'synthetic_extra_high_medieval_record',
      );
      final dataset = HighMedievalHistoryDataset.validated(
        sources: highMedievalHistoryT0215Sources,
        entries: [...highMedievalHistoryT0215Entries, extra],
      );

      expect(
        () => T0215CanonicalHistoryGate.validate(dataset),
        throwsStateError,
      );
    });

    test('rejects canonical IDs silently swapped between parallel tracks', () {
      final seljuq = highMedievalHistoryT0215Entries.singleWhere(
        (entry) => entry.id == 'great_seljuq_sultanate',
      );
      final crusades = highMedievalHistoryT0215Entries.singleWhere(
        (entry) => entry.id == 'crusading_movement_levant',
      );
      final swapped = highMedievalHistoryT0215Entries.map((entry) {
        if (entry.id == seljuq.id) {
          return copyEntry(entry, track: HighMedievalHistoryTrack.crusades);
        }
        if (entry.id == crusades.id) {
          return copyEntry(entry, track: HighMedievalHistoryTrack.seljuq);
        }
        return entry;
      }).toList();
      final dataset = HighMedievalHistoryDataset.validated(
        sources: highMedievalHistoryT0215Sources,
        entries: swapped,
      );

      expect(
        () => T0215CanonicalHistoryGate.validate(dataset),
        throwsStateError,
      );
    });
  });
}
