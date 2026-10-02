import 'package:flutter_test/flutter_test.dart';
import 'package:islami_hayat/features/history/data/modern_global_islamic_history.dart';
import 'package:islami_hayat/features/history/domain/t0218_canonical_history_gate.dart';

void main() {
  group('T0218CanonicalHistoryGate', () {
    test('accepts the exact governed modern/global dataset', () {
      expect(T0218CanonicalHistoryGate.validateCanonicalDataset, returnsNormally);
    });

    test('rejects an extra unreviewed modern-history record', () {
      final colonial = modernGlobalHistoryT0218Entries.first;
      final extra = ModernGlobalHistoryEntry(
        id: 'extra_modern_global_history_test_record',
        track: ModernGlobalHistoryTrack.colonialImperialRule,
        title: colonial.title,
        summary: colonial.summary,
        startYearCe: 1850,
        endYearCe: 1900,
        certainty: colonial.certainty,
        caveat: colonial.caveat,
        sourceIds: colonial.sourceIds,
        status: colonial.status,
      );

      final dataset = ModernGlobalIslamicHistoryDataset.validated(
        sources: modernGlobalHistoryT0218Sources,
        entries: [...modernGlobalHistoryT0218Entries, extra],
      );

      expect(
        () => T0218CanonicalHistoryGate.validate(dataset),
        throwsStateError,
      );
    });

    test('rejects canonical IDs silently reassigned to different tracks', () {
      final colonial = modernGlobalHistoryT0218Entries.singleWhere(
        (entry) => entry.id == 'colonial_imperial_rule',
      );
      final decolonization = modernGlobalHistoryT0218Entries.singleWhere(
        (entry) => entry.id == 'decolonization_nation_states',
      );

      ModernGlobalHistoryEntry copyWithTrack(
        ModernGlobalHistoryEntry entry,
        ModernGlobalHistoryTrack track,
      ) =>
          ModernGlobalHistoryEntry(
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

      final swapped = modernGlobalHistoryT0218Entries.map((entry) {
        if (entry.id == colonial.id) {
          return copyWithTrack(
            entry,
            ModernGlobalHistoryTrack.decolonizationNationStates,
          );
        }
        if (entry.id == decolonization.id) {
          return copyWithTrack(
            entry,
            ModernGlobalHistoryTrack.colonialImperialRule,
          );
        }
        return entry;
      }).toList();

      final dataset = ModernGlobalIslamicHistoryDataset.validated(
        sources: modernGlobalHistoryT0218Sources,
        entries: swapped,
      );

      expect(
        () => T0218CanonicalHistoryGate.validate(dataset),
        throwsStateError,
      );
    });

    test('rejects a canonical topic whose governed sources are replaced', () {
      final colonial = modernGlobalHistoryT0218Entries.singleWhere(
        (entry) => entry.id == 'colonial_imperial_rule',
      );
      final replacement = ModernGlobalHistoryEntry(
        id: colonial.id,
        track: colonial.track,
        title: colonial.title,
        summary: colonial.summary,
        startYearCe: colonial.startYearCe,
        endYearCe: colonial.endYearCe,
        certainty: colonial.certainty,
        caveat: colonial.caveat,
        sourceIds: const [
          'ansari_islam_west',
          'greble_muslims_modern_europe',
        ],
        status: colonial.status,
      );

      final dataset = ModernGlobalIslamicHistoryDataset.validated(
        sources: modernGlobalHistoryT0218Sources,
        entries: modernGlobalHistoryT0218Entries
            .map((entry) => entry.id == colonial.id ? replacement : entry)
            .toList(),
      );

      expect(
        () => T0218CanonicalHistoryGate.validate(dataset),
        throwsStateError,
      );
    });
  });
}
