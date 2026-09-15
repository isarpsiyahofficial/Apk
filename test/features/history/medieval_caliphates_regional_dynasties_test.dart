import 'package:flutter_test/flutter_test.dart';
import 'package:islami_hayat/features/history/data/medieval_caliphates_regional_dynasties.dart';
import 'package:islami_hayat/features/history/data/pre_islam_world_context.dart';

void main() {
  group('MedievalHistoryDataset T0214', () {
    test('covers every required parallel history track', () {
      final dataset = medievalHistoryT0214;

      expect(
        dataset.entries.map((entry) => entry.track).toSet(),
        MedievalHistoryTrack.values.toSet(),
      );
      expect(
        dataset.entries.map((entry) => entry.id).toSet(),
        containsAll(MedievalHistoryDataset.requiredEntryIds),
      );
    });

    test('does not force Abbasid, Andalusian and Fatimid histories into one false linear timeline', () {
      final dataset = medievalHistoryT0214;
      final abbasid = dataset.entries.singleWhere(
        (entry) => entry.id == 'abbasid_caliphate',
      );
      final andalus = dataset.entries.singleWhere(
        (entry) => entry.id == 'umayyad_al_andalus',
      );
      final fatimid = dataset.entries.singleWhere(
        (entry) => entry.id == 'fatimid_caliphate',
      );

      expect(andalus.startYearCe, lessThan(abbasid.endYearCe));
      expect(fatimid.startYearCe, lessThan(abbasid.endYearCe));
      expect(fatimid.startYearCe, lessThan(andalus.endYearCe));
    });

    test('keeps all T0214 records research-only before editorial and native review', () {
      final dataset = medievalHistoryT0214;

      expect(dataset.productionEntries, isEmpty);
      expect(
        dataset.entries.every(
          (entry) => entry.status == HistoryResearchStatus.researchDraft,
        ),
        isTrue,
      );
    });

    test('requires two independent academic work families, not two locators from one work', () {
      final umayyad = medievalHistoryT0214Entries.first;
      const duplicateFamilySource = MedievalHistoryResearchSource(
        workFamilyId: 'cambridge_history_strategy_kader',
        locator: HistorySourceLocator(
          id: 'kader_same_work_second_locator',
          kind: HistorySourceKind.academicChapter,
          citation: 'Second locator from the same Kader Cambridge History of Strategy work.',
          locator: 'same-work:test-locator',
        ),
      );
      final invalid = MedievalHistoryEntry(
        id: umayyad.id,
        track: umayyad.track,
        title: umayyad.title,
        summary: umayyad.summary,
        startYearCe: umayyad.startYearCe,
        endYearCe: umayyad.endYearCe,
        certainty: umayyad.certainty,
        caveat: umayyad.caveat,
        sourceIds: const [
          'kader_caliphates_2025',
          'kader_same_work_second_locator',
        ],
        status: umayyad.status,
      );

      expect(
        () => MedievalHistoryDataset.validated(
          sources: [
            ...medievalHistoryT0214Sources,
            duplicateFamilySource,
          ],
          entries: [invalid, ...medievalHistoryT0214Entries.skip(1)],
        ),
        throwsStateError,
      );
    });

    test('rejects unknown sources and missing required historical tracks', () {
      final umayyad = medievalHistoryT0214Entries.first;
      final unknownSource = MedievalHistoryEntry(
        id: umayyad.id,
        track: umayyad.track,
        title: umayyad.title,
        summary: umayyad.summary,
        startYearCe: umayyad.startYearCe,
        endYearCe: umayyad.endYearCe,
        certainty: umayyad.certainty,
        caveat: umayyad.caveat,
        sourceIds: const ['kader_caliphates_2025', 'unknown_source'],
        status: umayyad.status,
      );

      expect(
        () => MedievalHistoryDataset.validated(
          sources: medievalHistoryT0214Sources,
          entries: [unknownSource, ...medievalHistoryT0214Entries.skip(1)],
        ),
        throwsStateError,
      );

      expect(
        () => MedievalHistoryDataset.validated(
          sources: medievalHistoryT0214Sources,
          entries: medievalHistoryT0214Entries
              .where((entry) => entry.track != MedievalHistoryTrack.fatimid)
              .toList(),
        ),
        throwsStateError,
      );
    });

    test('requires complete TR/EN/AR caveats for broad or contested dating', () {
      final samanid = medievalHistoryT0214Entries.singleWhere(
        (entry) => entry.id == 'samanid_regional_power',
      );
      final invalid = MedievalHistoryEntry(
        id: samanid.id,
        track: samanid.track,
        title: samanid.title,
        summary: samanid.summary,
        startYearCe: samanid.startYearCe,
        endYearCe: samanid.endYearCe,
        certainty: samanid.certainty,
        caveat: const LocalizedHistorySummary(
          tr: 'Yaklaşık dönem.',
          en: 'Broad period.',
          ar: '',
        ),
        sourceIds: samanid.sourceIds,
        status: samanid.status,
      );

      expect(
        () => MedievalHistoryDataset.validated(
          sources: medievalHistoryT0214Sources,
          entries: medievalHistoryT0214Entries
              .map((entry) => entry.id == samanid.id ? invalid : entry)
              .toList(),
        ),
        throwsStateError,
      );
    });

    test('allows cross-track overlap but rejects backwards chronology inside one track', () {
      final buyid = medievalHistoryT0214Entries.singleWhere(
        (entry) => entry.id == 'buyid_regional_power',
      );
      final reversedBuyid = MedievalHistoryEntry(
        id: buyid.id,
        track: buyid.track,
        title: buyid.title,
        summary: buyid.summary,
        startYearCe: 800,
        endYearCe: buyid.endYearCe,
        certainty: buyid.certainty,
        caveat: buyid.caveat,
        sourceIds: buyid.sourceIds,
        status: buyid.status,
      );

      expect(
        () => MedievalHistoryDataset.validated(
          sources: medievalHistoryT0214Sources,
          entries: medievalHistoryT0214Entries
              .map((entry) => entry.id == buyid.id ? reversedBuyid : entry)
              .toList(),
        ),
        throwsStateError,
      );
    });
  });
}
