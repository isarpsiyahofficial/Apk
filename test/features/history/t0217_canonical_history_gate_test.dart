import 'package:flutter_test/flutter_test.dart';
import 'package:islami_hayat/features/history/data/regional_islamic_histories.dart';
import 'package:islami_hayat/features/history/domain/t0217_canonical_history_gate.dart';

void main() {
  group('T0217CanonicalHistoryGate', () {
    test('accepts the exact governed five-region dataset', () {
      expect(T0217CanonicalHistoryGate.validateCanonicalDataset, returnsNormally);
    });

    test('rejects an extra unreviewed regional record', () {
      final africa = regionalIslamicHistoriesT0217Entries.first;
      final extra = RegionalIslamicHistoryEntry(
        id: 'extra_regional_history_test_record',
        track: RegionalIslamicHistoryTrack.africa,
        title: africa.title,
        summary: africa.summary,
        startYearCe: 1500,
        endYearCe: 1700,
        certainty: africa.certainty,
        caveat: africa.caveat,
        sourceIds: africa.sourceIds,
        status: africa.status,
      );

      final dataset = RegionalIslamicHistoriesDataset.validated(
        sources: regionalIslamicHistoriesT0217Sources,
        entries: [...regionalIslamicHistoriesT0217Entries, extra],
      );

      expect(
        () => T0217CanonicalHistoryGate.validate(dataset),
        throwsStateError,
      );
    });

    test('rejects canonical IDs silently reassigned to different regional tracks', () {
      final africa = regionalIslamicHistoriesT0217Entries.singleWhere(
        (entry) => entry.id == 'africa_islamic_history',
      );
      final centralAsia = regionalIslamicHistoriesT0217Entries.singleWhere(
        (entry) => entry.id == 'central_asia_islamic_history',
      );

      RegionalIslamicHistoryEntry copyWithTrack(
        RegionalIslamicHistoryEntry entry,
        RegionalIslamicHistoryTrack track,
      ) =>
          RegionalIslamicHistoryEntry(
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

      final swapped = regionalIslamicHistoriesT0217Entries.map((entry) {
        if (entry.id == africa.id) {
          return copyWithTrack(entry, RegionalIslamicHistoryTrack.centralAsia);
        }
        if (entry.id == centralAsia.id) {
          return copyWithTrack(entry, RegionalIslamicHistoryTrack.africa);
        }
        return entry;
      }).toList();

      final dataset = RegionalIslamicHistoriesDataset.validated(
        sources: regionalIslamicHistoriesT0217Sources,
        entries: swapped,
      );

      expect(
        () => T0217CanonicalHistoryGate.validate(dataset),
        throwsStateError,
      );
    });

    test('rejects a canonical region whose governed sources are replaced', () {
      final africa = regionalIslamicHistoriesT0217Entries.singleWhere(
        (entry) => entry.id == 'africa_islamic_history',
      );
      final replacement = RegionalIslamicHistoryEntry(
        id: africa.id,
        track: africa.track,
        title: africa.title,
        summary: africa.summary,
        startYearCe: africa.startYearCe,
        endYearCe: africa.endYearCe,
        certainty: africa.certainty,
        caveat: africa.caveat,
        sourceIds: const [
          'berger_brief_history_islam_europe',
          'nchi_muslims_west_europe',
        ],
        status: africa.status,
      );

      final dataset = RegionalIslamicHistoriesDataset.validated(
        sources: regionalIslamicHistoriesT0217Sources,
        entries: regionalIslamicHistoriesT0217Entries
            .map((entry) => entry.id == africa.id ? replacement : entry)
            .toList(),
      );

      expect(
        () => T0217CanonicalHistoryGate.validate(dataset),
        throwsStateError,
      );
    });
  });
}
