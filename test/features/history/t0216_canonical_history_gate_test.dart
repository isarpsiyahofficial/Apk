import 'package:flutter_test/flutter_test.dart';
import 'package:islami_hayat/features/history/data/early_modern_ottoman_safavid_mughal.dart';
import 'package:islami_hayat/features/history/domain/t0216_canonical_history_gate.dart';

void main() {
  group('T0216CanonicalHistoryGate', () {
    test('accepts the exact governed Ottoman, Safavid and Mughal dataset', () {
      expect(T0216CanonicalHistoryGate.validateCanonicalDataset, returnsNormally);
    });

    test('rejects an extra unreviewed early-modern record', () {
      final ottoman = earlyModernEmpiresT0216Entries.first;
      final extra = EarlyModernEmpireEntry(
        id: 'extra_early_modern_test_record',
        track: EarlyModernEmpireTrack.ottoman,
        title: ottoman.title,
        summary: ottoman.summary,
        startYearCe: 1700,
        endYearCe: 1750,
        certainty: ottoman.certainty,
        caveat: ottoman.caveat,
        sourceIds: ottoman.sourceIds,
        status: ottoman.status,
      );

      final dataset = EarlyModernEmpiresDataset.validated(
        sources: earlyModernEmpiresT0216Sources,
        entries: [...earlyModernEmpiresT0216Entries, extra],
      );

      expect(
        () => T0216CanonicalHistoryGate.validate(dataset),
        throwsStateError,
      );
    });

    test('rejects canonical IDs silently reassigned to different tracks', () {
      final ottoman = earlyModernEmpiresT0216Entries.singleWhere(
        (entry) => entry.id == 'ottoman_empire',
      );
      final safavid = earlyModernEmpiresT0216Entries.singleWhere(
        (entry) => entry.id == 'safavid_iran',
      );

      EarlyModernEmpireEntry copyWithTrack(
        EarlyModernEmpireEntry entry,
        EarlyModernEmpireTrack track,
      ) =>
          EarlyModernEmpireEntry(
            id: entry.id,
            track: track,
            title: entry.title,
            summary: entry.summary,
            startYearCe: entry.startYearCe,
            endYearCe: entry.endYearCe,
            certainty: entry.certainty,
            caveat: entry.caveat,
            sourceIds: entry.sourceIds,
            status: entry.status,
          );

      final swapped = earlyModernEmpiresT0216Entries.map((entry) {
        if (entry.id == ottoman.id) {
          return copyWithTrack(entry, EarlyModernEmpireTrack.safavid);
        }
        if (entry.id == safavid.id) {
          return copyWithTrack(entry, EarlyModernEmpireTrack.ottoman);
        }
        return entry;
      }).toList();

      final dataset = EarlyModernEmpiresDataset.validated(
        sources: earlyModernEmpiresT0216Sources,
        entries: swapped,
      );

      expect(
        () => T0216CanonicalHistoryGate.validate(dataset),
        throwsStateError,
      );
    });
  });
}
