import 'package:flutter_test/flutter_test.dart';
import 'package:islami_hayat/features/history/data/pre_islam_world_context.dart';

void main() {
  group('PreIslamWorldContextDataset', () {
    test('canonical research dataset covers every T0211 topic', () {
      final ids = preIslamWorldContextDataset.entries.map((entry) => entry.id).toSet();

      expect(ids, PreIslamWorldContextDataset.requiredTopicIds);
      expect(preIslamWorldContextDataset.entries.length, 11);
    });

    test('all research entries are source-backed and kept out of production', () {
      final sourceIds = preIslamWorldContextDataset.sources
          .map((source) => source.id)
          .toSet();

      for (final source in preIslamWorldContextDataset.sources) {
        expect(source.isComplete, isTrue);
      }
      for (final entry in preIslamWorldContextDataset.entries) {
        expect(entry.status, HistoryResearchStatus.researchDraft);
        expect(entry.title.isComplete, isTrue);
        expect(entry.summary.isComplete, isTrue);
        expect(entry.sourceIds, isNotEmpty);
        expect(entry.sourceIds.every(sourceIds.contains), isTrue);
      }
      expect(preIslamWorldContextDataset.productionEntries, isEmpty);
    });

    test('missing required topic fails closed', () {
      expect(
        () => PreIslamWorldContextDataset.validated(
          sources: preIslamWorldResearchSources,
          entries: preIslamWorldResearchEntries
              .where((entry) => entry.id != 'aksum')
              .toList(),
        ),
        throwsStateError,
      );
    });

    test('unknown source reference fails closed', () {
      final entries = [...preIslamWorldResearchEntries];
      final original = entries.first;
      entries[0] = PreIslamWorldContextEntry(
        id: original.id,
        title: original.title,
        summary: original.summary,
        sourceIds: const ['missing_source'],
        status: original.status,
      );

      expect(
        () => PreIslamWorldContextDataset.validated(
          sources: preIslamWorldResearchSources,
          entries: entries,
        ),
        throwsStateError,
      );
    });

    test('incomplete Arabic text fails closed', () {
      final entries = [...preIslamWorldResearchEntries];
      final original = entries.first;
      entries[0] = PreIslamWorldContextEntry(
        id: original.id,
        title: original.title,
        summary: LocalizedHistorySummary(
          tr: original.summary.tr,
          en: original.summary.en,
          ar: ' ',
        ),
        sourceIds: original.sourceIds,
        status: original.status,
      );

      expect(
        () => PreIslamWorldContextDataset.validated(
          sources: preIslamWorldResearchSources,
          entries: entries,
        ),
        throwsStateError,
      );
    });

    test('duplicate source IDs fail closed', () {
      expect(
        () => PreIslamWorldContextDataset.validated(
          sources: [
            ...preIslamWorldResearchSources,
            preIslamWorldResearchSources.first,
          ],
          entries: preIslamWorldResearchEntries,
        ),
        throwsStateError,
      );
    });
  });
}
