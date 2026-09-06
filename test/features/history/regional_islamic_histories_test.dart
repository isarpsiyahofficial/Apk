import 'package:flutter_test/flutter_test.dart';
import 'package:islami_hayat/features/history/data/pre_islam_world_context.dart';
import 'package:islami_hayat/features/history/data/regional_islamic_histories.dart';

void main() {
  group('RegionalIslamicHistoriesDataset T0217', () {
    test('covers all five required regional tracks and entries', () {
      final dataset = regionalIslamicHistoriesT0217;

      expect(
        dataset.entries.map((entry) => entry.track).toSet(),
        RegionalIslamicHistoryTrack.values.toSet(),
      );
      expect(
        dataset.entries.map((entry) => entry.id).toSet(),
        containsAll(RegionalIslamicHistoriesDataset.requiredEntryIds),
      );
    });

    test('keeps regional histories parallel instead of forcing one false global succession', () {
      final dataset = regionalIslamicHistoriesT0217;
      final africa = dataset.entries.singleWhere((e) => e.track == RegionalIslamicHistoryTrack.africa);
      final centralAsia = dataset.entries.singleWhere((e) => e.track == RegionalIslamicHistoryTrack.centralAsia);
      final southeastAsia = dataset.entries.singleWhere((e) => e.track == RegionalIslamicHistoryTrack.southeastAsia);
      final india = dataset.entries.singleWhere((e) => e.track == RegionalIslamicHistoryTrack.indianSubcontinent);
      final europe = dataset.entries.singleWhere((e) => e.track == RegionalIslamicHistoryTrack.europe);

      expect(centralAsia.startYearCe, lessThan(africa.endYearCe));
      expect(southeastAsia.startYearCe, lessThan(centralAsia.endYearCe));
      expect(india.startYearCe, lessThan(europe.endYearCe));
      expect(europe.startYearCe, lessThan(africa.endYearCe));
    });

    test('keeps all records research-only pending factual and native review', () {
      final dataset = regionalIslamicHistoriesT0217;

      expect(dataset.productionEntries, isEmpty);
      expect(
        dataset.entries.every((entry) => entry.status == HistoryResearchStatus.researchDraft),
        isTrue,
      );
    });

    test('requires two independent academic work families', () {
      final africa = regionalIslamicHistoriesT0217Entries.first;
      const duplicateFamily = RegionalHistoryResearchSource(
        workFamilyId: 'robinson_muslim_societies_africa',
        locator: HistorySourceLocator(
          id: 'robinson_same_family_test',
          kind: HistorySourceKind.academicChapter,
          citation: 'Second locator from the same Robinson work family.',
          locator: 'same-work:test-locator',
        ),
      );
      final invalid = RegionalIslamicHistoryEntry(
        id: africa.id,
        track: africa.track,
        title: africa.title,
        summary: africa.summary,
        startYearCe: africa.startYearCe,
        endYearCe: africa.endYearCe,
        certainty: africa.certainty,
        caveat: africa.caveat,
        sourceIds: const ['robinson_muslim_societies_africa', 'robinson_same_family_test'],
        status: africa.status,
      );

      expect(
        () => RegionalIslamicHistoriesDataset.validated(
          sources: [...regionalIslamicHistoriesT0217Sources, duplicateFamily],
          entries: [invalid, ...regionalIslamicHistoriesT0217Entries.skip(1)],
        ),
        throwsStateError,
      );
    });

    test('rejects unknown sources and missing required regional tracks', () {
      final africa = regionalIslamicHistoriesT0217Entries.first;
      final invalid = RegionalIslamicHistoryEntry(
        id: africa.id,
        track: africa.track,
        title: africa.title,
        summary: africa.summary,
        startYearCe: africa.startYearCe,
        endYearCe: africa.endYearCe,
        certainty: africa.certainty,
        caveat: africa.caveat,
        sourceIds: const ['robinson_muslim_societies_africa', 'unknown_source'],
        status: africa.status,
      );

      expect(
        () => RegionalIslamicHistoriesDataset.validated(
          sources: regionalIslamicHistoriesT0217Sources,
          entries: [invalid, ...regionalIslamicHistoriesT0217Entries.skip(1)],
        ),
        throwsStateError,
      );

      expect(
        () => RegionalIslamicHistoriesDataset.validated(
          sources: regionalIslamicHistoriesT0217Sources,
          entries: regionalIslamicHistoriesT0217Entries
              .where((entry) => entry.track != RegionalIslamicHistoryTrack.europe)
              .toList(),
        ),
        throwsStateError,
      );
    });

    test('requires complete TR/EN/AR certainty caveats', () {
      final centralAsia = regionalIslamicHistoriesT0217Entries.singleWhere(
        (entry) => entry.track == RegionalIslamicHistoryTrack.centralAsia,
      );
      final invalid = RegionalIslamicHistoryEntry(
        id: centralAsia.id,
        track: centralAsia.track,
        title: centralAsia.title,
        summary: centralAsia.summary,
        startYearCe: centralAsia.startYearCe,
        endYearCe: centralAsia.endYearCe,
        certainty: centralAsia.certainty,
        caveat: const LocalizedHistorySummary(tr: 'Yaklaşık dönem.', en: 'Approximate period.', ar: ''),
        sourceIds: centralAsia.sourceIds,
        status: centralAsia.status,
      );

      expect(
        () => RegionalIslamicHistoriesDataset.validated(
          sources: regionalIslamicHistoriesT0217Sources,
          entries: regionalIslamicHistoriesT0217Entries
              .map((entry) => entry.id == centralAsia.id ? invalid : entry)
              .toList(),
        ),
        throwsStateError,
      );
    });

    test('rejects backwards chronology inside one region while allowing cross-region overlap', () {
      final africa = regionalIslamicHistoriesT0217Entries.first;
      final later = RegionalIslamicHistoryEntry(
        id: 'africa_later_phase_test',
        track: RegionalIslamicHistoryTrack.africa,
        title: africa.title,
        summary: africa.summary,
        startYearCe: 1000,
        endYearCe: 1500,
        certainty: africa.certainty,
        caveat: africa.caveat,
        sourceIds: africa.sourceIds,
        status: africa.status,
      );
      final reversed = RegionalIslamicHistoryEntry(
        id: 'africa_reversed_phase_test',
        track: RegionalIslamicHistoryTrack.africa,
        title: africa.title,
        summary: africa.summary,
        startYearCe: 900,
        endYearCe: 1200,
        certainty: africa.certainty,
        caveat: africa.caveat,
        sourceIds: africa.sourceIds,
        status: africa.status,
      );

      expect(
        () => RegionalIslamicHistoriesDataset.validated(
          sources: regionalIslamicHistoriesT0217Sources,
          entries: [
            africa,
            later,
            reversed,
            ...regionalIslamicHistoriesT0217Entries.skip(1),
          ],
        ),
        throwsStateError,
      );
    });
  });
}
