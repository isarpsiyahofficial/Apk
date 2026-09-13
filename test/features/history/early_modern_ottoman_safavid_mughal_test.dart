import 'package:flutter_test/flutter_test.dart';
import 'package:islami_hayat/features/history/data/early_modern_ottoman_safavid_mughal.dart';
import 'package:islami_hayat/features/history/data/pre_islam_world_context.dart';

void main() {
  group('EarlyModernEmpiresDataset T0216', () {
    test('covers Ottoman, Safavid and Mughal tracks with required entries', () {
      final dataset = earlyModernEmpiresT0216;

      expect(
        dataset.entries.map((entry) => entry.track).toSet(),
        EarlyModernEmpireTrack.values.toSet(),
      );
      expect(
        dataset.entries.map((entry) => entry.id).toSet(),
        containsAll(EarlyModernEmpiresDataset.requiredEntryIds),
      );
    });

    test('preserves early-modern overlap instead of forcing a false linear succession', () {
      final dataset = earlyModernEmpiresT0216;
      final ottoman = dataset.entries.singleWhere((e) => e.id == 'ottoman_empire');
      final safavid = dataset.entries.singleWhere((e) => e.id == 'safavid_iran');
      final mughal = dataset.entries.singleWhere((e) => e.id == 'mughal_empire');

      expect(safavid.startYearCe, lessThan(ottoman.endYearCe));
      expect(mughal.startYearCe, lessThan(safavid.endYearCe));
      expect(mughal.startYearCe, lessThan(ottoman.endYearCe));
    });

    test('keeps all T0216 records research-only before editorial and native review', () {
      final dataset = earlyModernEmpiresT0216;

      expect(dataset.productionEntries, isEmpty);
      expect(
        dataset.entries.every(
          (entry) => entry.status == HistoryResearchStatus.researchDraft,
        ),
        isTrue,
      );
    });

    test('requires two independent academic work families', () {
      final ottoman = earlyModernEmpiresT0216Entries.first;
      const duplicateFamily = EarlyModernHistoryResearchSource(
        workFamilyId: 'cambridge_history_turkey',
        locator: HistorySourceLocator(
          id: 'cambridge_history_turkey_same_family_test',
          kind: HistorySourceKind.academicChapter,
          citation: 'Second locator from the same Cambridge History of Turkey work family.',
          locator: 'same-work:test-locator',
        ),
      );
      final invalid = EarlyModernEmpireEntry(
        id: ottoman.id,
        track: ottoman.track,
        title: ottoman.title,
        summary: ottoman.summary,
        startYearCe: ottoman.startYearCe,
        endYearCe: ottoman.endYearCe,
        certainty: ottoman.certainty,
        caveat: ottoman.caveat,
        sourceIds: const [
          'cambridge_history_turkey_v2',
          'cambridge_history_turkey_same_family_test',
        ],
        status: ottoman.status,
      );

      expect(
        () => EarlyModernEmpiresDataset.validated(
          sources: [...earlyModernEmpiresT0216Sources, duplicateFamily],
          entries: [invalid, ...earlyModernEmpiresT0216Entries.skip(1)],
        ),
        throwsStateError,
      );
    });

    test('rejects unknown source IDs and missing required empire tracks', () {
      final ottoman = earlyModernEmpiresT0216Entries.first;
      final invalid = EarlyModernEmpireEntry(
        id: ottoman.id,
        track: ottoman.track,
        title: ottoman.title,
        summary: ottoman.summary,
        startYearCe: ottoman.startYearCe,
        endYearCe: ottoman.endYearCe,
        certainty: ottoman.certainty,
        caveat: ottoman.caveat,
        sourceIds: const ['cambridge_history_turkey_v2', 'unknown_source'],
        status: ottoman.status,
      );

      expect(
        () => EarlyModernEmpiresDataset.validated(
          sources: earlyModernEmpiresT0216Sources,
          entries: [invalid, ...earlyModernEmpiresT0216Entries.skip(1)],
        ),
        throwsStateError,
      );

      expect(
        () => EarlyModernEmpiresDataset.validated(
          sources: earlyModernEmpiresT0216Sources,
          entries: earlyModernEmpiresT0216Entries
              .where((entry) => entry.track != EarlyModernEmpireTrack.safavid)
              .toList(),
        ),
        throwsStateError,
      );
    });

    test('requires complete TR/EN/AR caveats for broad dating', () {
      final safavid = earlyModernEmpiresT0216Entries.singleWhere(
        (entry) => entry.id == 'safavid_iran',
      );
      final invalid = EarlyModernEmpireEntry(
        id: safavid.id,
        track: safavid.track,
        title: safavid.title,
        summary: safavid.summary,
        startYearCe: safavid.startYearCe,
        endYearCe: safavid.endYearCe,
        certainty: safavid.certainty,
        caveat: const LocalizedHistorySummary(
          tr: 'Geniş dönem.',
          en: 'Broad period.',
          ar: '',
        ),
        sourceIds: safavid.sourceIds,
        status: safavid.status,
      );

      expect(
        () => EarlyModernEmpiresDataset.validated(
          sources: earlyModernEmpiresT0216Sources,
          entries: earlyModernEmpiresT0216Entries
              .map((entry) => entry.id == safavid.id ? invalid : entry)
              .toList(),
        ),
        throwsStateError,
      );
    });

    test('rejects backwards chronology inside a track while allowing cross-track overlap', () {
      final ottoman = earlyModernEmpiresT0216Entries.first;
      final later = EarlyModernEmpireEntry(
        id: 'ottoman_later_phase_test',
        track: EarlyModernEmpireTrack.ottoman,
        title: ottoman.title,
        summary: ottoman.summary,
        startYearCe: 1453,
        endYearCe: 1603,
        certainty: ottoman.certainty,
        caveat: ottoman.caveat,
        sourceIds: ottoman.sourceIds,
        status: ottoman.status,
      );
      final reversed = EarlyModernEmpireEntry(
        id: 'ottoman_reversed_phase_test',
        track: EarlyModernEmpireTrack.ottoman,
        title: ottoman.title,
        summary: ottoman.summary,
        startYearCe: 1400,
        endYearCe: 1500,
        certainty: ottoman.certainty,
        caveat: ottoman.caveat,
        sourceIds: ottoman.sourceIds,
        status: ottoman.status,
      );

      expect(
        () => EarlyModernEmpiresDataset.validated(
          sources: earlyModernEmpiresT0216Sources,
          entries: [
            ottoman,
            later,
            reversed,
            ...earlyModernEmpiresT0216Entries.skip(1),
          ],
        ),
        throwsStateError,
      );
    });
  });
}
