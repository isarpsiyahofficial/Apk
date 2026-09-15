import 'package:flutter_test/flutter_test.dart';
import 'package:islami_hayat/features/history/data/high_medieval_seljuq_crusades_mamluks.dart';
import 'package:islami_hayat/features/history/data/pre_islam_world_context.dart';

void main() {
  group('HighMedievalHistoryDataset T0215', () {
    test('covers all required Seljuq, Crusades, Ayyubid, Mongol and Mamluk tracks', () {
      final dataset = highMedievalHistoryT0215;

      expect(
        dataset.entries.map((entry) => entry.track).toSet(),
        HighMedievalHistoryTrack.values.toSet(),
      );
      expect(
        dataset.entries.map((entry) => entry.id).toSet(),
        containsAll(HighMedievalHistoryDataset.requiredEntryIds),
      );
    });

    test('preserves historical overlap instead of forcing one false linear timeline', () {
      final dataset = highMedievalHistoryT0215;
      final crusades = dataset.entries.singleWhere(
        (entry) => entry.id == 'crusading_movement_levant',
      );
      final ayyubid = dataset.entries.singleWhere(
        (entry) => entry.id == 'ayyubid_egypt_syria',
      );
      final mongol = dataset.entries.singleWhere(
        (entry) => entry.id == 'mongol_invasions_islamic_lands',
      );
      final mamluk = dataset.entries.singleWhere(
        (entry) => entry.id == 'mamluk_sultanate_egypt_syria',
      );

      expect(ayyubid.startYearCe, lessThan(crusades.endYearCe));
      expect(mongol.startYearCe, lessThan(crusades.endYearCe));
      expect(mamluk.startYearCe, lessThanOrEqualTo(mongol.endYearCe));
    });

    test('keeps all T0215 records research-only before editorial and native review', () {
      final dataset = highMedievalHistoryT0215;

      expect(dataset.productionEntries, isEmpty);
      expect(
        dataset.entries.every(
          (entry) => entry.status == HistoryResearchStatus.researchDraft,
        ),
        isTrue,
      );
    });

    test('requires two independent academic work families', () {
      final seljuq = highMedievalHistoryT0215Entries.first;
      const duplicateFamilySource = HighMedievalHistoryResearchSource(
        workFamilyId: 'cambridge_history_iran_bosworth',
        locator: HistorySourceLocator(
          id: 'bosworth_same_work_second_locator',
          kind: HistorySourceKind.academicChapter,
          citation: 'Second locator from the same Cambridge History of Iran work.',
          locator: 'same-work:test-locator',
        ),
      );
      final invalid = HighMedievalHistoryEntry(
        id: seljuq.id,
        track: seljuq.track,
        title: seljuq.title,
        summary: seljuq.summary,
        startYearCe: seljuq.startYearCe,
        endYearCe: seljuq.endYearCe,
        certainty: seljuq.certainty,
        caveat: seljuq.caveat,
        sourceIds: const [
          'bosworth_iran_1000_1217',
          'bosworth_same_work_second_locator',
        ],
        status: seljuq.status,
      );

      expect(
        () => HighMedievalHistoryDataset.validated(
          sources: [
            ...highMedievalHistoryT0215Sources,
            duplicateFamilySource,
          ],
          entries: [invalid, ...highMedievalHistoryT0215Entries.skip(1)],
        ),
        throwsStateError,
      );
    });

    test('rejects unknown sources and missing required tracks', () {
      final seljuq = highMedievalHistoryT0215Entries.first;
      final unknownSource = HighMedievalHistoryEntry(
        id: seljuq.id,
        track: seljuq.track,
        title: seljuq.title,
        summary: seljuq.summary,
        startYearCe: seljuq.startYearCe,
        endYearCe: seljuq.endYearCe,
        certainty: seljuq.certainty,
        caveat: seljuq.caveat,
        sourceIds: const ['bosworth_iran_1000_1217', 'unknown_source'],
        status: seljuq.status,
      );

      expect(
        () => HighMedievalHistoryDataset.validated(
          sources: highMedievalHistoryT0215Sources,
          entries: [unknownSource, ...highMedievalHistoryT0215Entries.skip(1)],
        ),
        throwsStateError,
      );

      expect(
        () => HighMedievalHistoryDataset.validated(
          sources: highMedievalHistoryT0215Sources,
          entries: highMedievalHistoryT0215Entries
              .where((entry) => entry.track != HighMedievalHistoryTrack.mongol)
              .toList(),
        ),
        throwsStateError,
      );
    });

    test('requires complete TR/EN/AR caveats for broad or contested dating', () {
      final crusades = highMedievalHistoryT0215Entries.singleWhere(
        (entry) => entry.id == 'crusading_movement_levant',
      );
      final invalid = HighMedievalHistoryEntry(
        id: crusades.id,
        track: crusades.track,
        title: crusades.title,
        summary: crusades.summary,
        startYearCe: crusades.startYearCe,
        endYearCe: crusades.endYearCe,
        certainty: crusades.certainty,
        caveat: const LocalizedHistorySummary(
          tr: 'Geniş dönem.',
          en: 'Broad period.',
          ar: '',
        ),
        sourceIds: crusades.sourceIds,
        status: crusades.status,
      );

      expect(
        () => HighMedievalHistoryDataset.validated(
          sources: highMedievalHistoryT0215Sources,
          entries: highMedievalHistoryT0215Entries
              .map((entry) => entry.id == crusades.id ? invalid : entry)
              .toList(),
        ),
        throwsStateError,
      );
    });

    test('rejects backwards chronology inside a track while permitting cross-track overlap', () {
      final seljuq = highMedievalHistoryT0215Entries.first;
      final laterSeljuq = HighMedievalHistoryEntry(
        id: 'seljuq_second_phase_test',
        track: HighMedievalHistoryTrack.seljuq,
        title: seljuq.title,
        summary: seljuq.summary,
        startYearCe: 1050,
        endYearCe: 1100,
        certainty: seljuq.certainty,
        caveat: seljuq.caveat,
        sourceIds: seljuq.sourceIds,
        status: seljuq.status,
      );
      final reversedSeljuq = HighMedievalHistoryEntry(
        id: 'seljuq_reversed_phase_test',
        track: HighMedievalHistoryTrack.seljuq,
        title: seljuq.title,
        summary: seljuq.summary,
        startYearCe: 1040,
        endYearCe: 1090,
        certainty: seljuq.certainty,
        caveat: seljuq.caveat,
        sourceIds: seljuq.sourceIds,
        status: seljuq.status,
      );

      expect(
        () => HighMedievalHistoryDataset.validated(
          sources: highMedievalHistoryT0215Sources,
          entries: [
            seljuq,
            laterSeljuq,
            reversedSeljuq,
            ...highMedievalHistoryT0215Entries.skip(1),
          ],
        ),
        throwsStateError,
      );
    });
  });
}
