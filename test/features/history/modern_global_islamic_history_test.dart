import 'package:flutter_test/flutter_test.dart';
import 'package:islami_hayat/features/history/data/modern_global_islamic_history.dart';
import 'package:islami_hayat/features/history/data/pre_islam_world_context.dart';

void main() {
  group('ModernGlobalIslamicHistoryDataset T0218', () {
    test('covers all required modern-history tracks and entries', () {
      final dataset = modernGlobalIslamicHistoryT0218;

      expect(
        dataset.entries.map((entry) => entry.track).toSet(),
        ModernGlobalHistoryTrack.values.toSet(),
      );
      expect(
        dataset.entries.map((entry) => entry.id).toSet(),
        containsAll(ModernGlobalIslamicHistoryDataset.requiredEntryIds),
      );
    });

    test('keeps colonial, nation-state, twentieth-century and contemporary layers overlapping where history overlaps', () {
      final dataset = modernGlobalIslamicHistoryT0218;
      final colonial = dataset.entries.singleWhere(
        (entry) => entry.track == ModernGlobalHistoryTrack.colonialImperialRule,
      );
      final nationStates = dataset.entries.singleWhere(
        (entry) => entry.track == ModernGlobalHistoryTrack.decolonizationNationStates,
      );
      final twentieth = dataset.entries.singleWhere(
        (entry) => entry.track == ModernGlobalHistoryTrack.twentiethCenturyTransformations,
      );
      final contemporary = dataset.entries.singleWhere(
        (entry) => entry.track == ModernGlobalHistoryTrack.contemporaryGlobalMuslimSocieties,
      );

      expect(twentieth.startYearCe, lessThan(colonial.endYearCe));
      expect(twentieth.endYearCe, greaterThan(nationStates.startYearCe));
      expect(contemporary.startYearCe, lessThan(twentieth.endYearCe));
    });

    test('keeps every T0218 record research-only pending factual and native review', () {
      final dataset = modernGlobalIslamicHistoryT0218;

      expect(dataset.productionEntries, isEmpty);
      expect(
        dataset.entries.every((entry) => entry.status == HistoryResearchStatus.researchDraft),
        isTrue,
      );
    });

    test('requires two independent academic work families', () {
      final colonial = modernGlobalHistoryT0218Entries.first;
      const sameFamily = ModernHistoryResearchSource(
        workFamilyId: 'motadel_islam_european_empires',
        locator: HistorySourceLocator(
          id: 'motadel_same_family_test',
          kind: HistorySourceKind.academicChapter,
          citation: 'Second locator from the same Motadel edited volume.',
          locator: 'same-work:test-locator',
        ),
      );
      final invalid = ModernGlobalHistoryEntry(
        id: colonial.id,
        track: colonial.track,
        title: colonial.title,
        summary: colonial.summary,
        startYearCe: colonial.startYearCe,
        endYearCe: colonial.endYearCe,
        certainty: colonial.certainty,
        caveat: colonial.caveat,
        sourceIds: const ['motadel_islam_european_empires', 'motadel_same_family_test'],
        status: colonial.status,
      );

      expect(
        () => ModernGlobalIslamicHistoryDataset.validated(
          sources: [...modernGlobalHistoryT0218Sources, sameFamily],
          entries: [invalid, ...modernGlobalHistoryT0218Entries.skip(1)],
        ),
        throwsStateError,
      );
    });

    test('rejects unknown sources and missing required modern-history tracks', () {
      final colonial = modernGlobalHistoryT0218Entries.first;
      final invalid = ModernGlobalHistoryEntry(
        id: colonial.id,
        track: colonial.track,
        title: colonial.title,
        summary: colonial.summary,
        startYearCe: colonial.startYearCe,
        endYearCe: colonial.endYearCe,
        certainty: colonial.certainty,
        caveat: colonial.caveat,
        sourceIds: const ['motadel_islam_european_empires', 'unknown_source'],
        status: colonial.status,
      );

      expect(
        () => ModernGlobalIslamicHistoryDataset.validated(
          sources: modernGlobalHistoryT0218Sources,
          entries: [invalid, ...modernGlobalHistoryT0218Entries.skip(1)],
        ),
        throwsStateError,
      );

      expect(
        () => ModernGlobalIslamicHistoryDataset.validated(
          sources: modernGlobalHistoryT0218Sources,
          entries: modernGlobalHistoryT0218Entries
              .where(
                (entry) =>
                    entry.track != ModernGlobalHistoryTrack.contemporaryGlobalMuslimSocieties,
              )
              .toList(),
        ),
        throwsStateError,
      );
    });

    test('requires complete TR/EN/AR certainty caveats', () {
      final contemporary = modernGlobalHistoryT0218Entries.singleWhere(
        (entry) => entry.track == ModernGlobalHistoryTrack.contemporaryGlobalMuslimSocieties,
      );
      final invalid = ModernGlobalHistoryEntry(
        id: contemporary.id,
        track: contemporary.track,
        title: contemporary.title,
        summary: contemporary.summary,
        startYearCe: contemporary.startYearCe,
        endYearCe: contemporary.endYearCe,
        certainty: contemporary.certainty,
        caveat: const LocalizedHistorySummary(
          tr: 'Sürüm sınırı.',
          en: 'Dataset boundary.',
          ar: '',
        ),
        sourceIds: contemporary.sourceIds,
        status: contemporary.status,
      );

      expect(
        () => ModernGlobalIslamicHistoryDataset.validated(
          sources: modernGlobalHistoryT0218Sources,
          entries: modernGlobalHistoryT0218Entries
              .map((entry) => entry.id == contemporary.id ? invalid : entry)
              .toList(),
        ),
        throwsStateError,
      );
    });

    test('marks the present-day boundary as snapshot-bounded instead of a historical endpoint', () {
      final contemporary = modernGlobalHistoryT0218Entries.singleWhere(
        (entry) => entry.track == ModernGlobalHistoryTrack.contemporaryGlobalMuslimSocieties,
      );

      expect(contemporary.certainty, ModernGlobalHistoryCertainty.snapshotBounded);
      expect(contemporary.endYearCe, 2026);
      expect(contemporary.caveat.tr, contains('veri sürümünün'));
      expect(contemporary.caveat.en, contains('dataset version'));
      expect(contemporary.caveat.ar, isNotEmpty);
    });
  });
}
