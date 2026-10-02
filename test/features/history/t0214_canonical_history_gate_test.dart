import 'package:flutter_test/flutter_test.dart';
import 'package:islami_hayat/features/history/data/medieval_caliphates_regional_dynasties.dart';
import 'package:islami_hayat/features/history/domain/t0214_canonical_history_gate.dart';

MedievalHistoryEntry copyEntry(
  MedievalHistoryEntry source, {
  String? id,
  MedievalHistoryTrack? track,
}) {
  return MedievalHistoryEntry(
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
  group('T0214 canonical history gate', () {
    test('accepts the governed six-record canonical dataset', () {
      expect(
        () => T0214CanonicalHistoryGate.validate(medievalHistoryT0214),
        returnsNormally,
      );
    });

    test('rejects an extra ungoverned record even when base validation accepts it', () {
      final extra = copyEntry(
        medievalHistoryT0214Entries.first,
        id: 'synthetic_extra_dynasty',
      );
      final dataset = MedievalHistoryDataset.validated(
        sources: medievalHistoryT0214Sources,
        entries: [...medievalHistoryT0214Entries, extra],
      );

      expect(
        () => T0214CanonicalHistoryGate.validate(dataset),
        throwsStateError,
      );
    });

    test('rejects canonical IDs silently swapped between parallel tracks', () {
      final umayyad = medievalHistoryT0214Entries.singleWhere(
        (entry) => entry.id == 'umayyad_caliphate',
      );
      final abbasid = medievalHistoryT0214Entries.singleWhere(
        (entry) => entry.id == 'abbasid_caliphate',
      );
      final swapped = medievalHistoryT0214Entries.map((entry) {
        if (entry.id == umayyad.id) {
          return copyEntry(entry, track: MedievalHistoryTrack.abbasid);
        }
        if (entry.id == abbasid.id) {
          return copyEntry(entry, track: MedievalHistoryTrack.umayyad);
        }
        return entry;
      }).toList();
      final dataset = MedievalHistoryDataset.validated(
        sources: medievalHistoryT0214Sources,
        entries: swapped,
      );

      expect(
        () => T0214CanonicalHistoryGate.validate(dataset),
        throwsStateError,
      );
    });
  });
}
