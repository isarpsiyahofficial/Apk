import 'package:flutter_test/flutter_test.dart';
import 'package:islami_hayat/features/history/data/pre_islam_world_context.dart';
import 'package:islami_hayat/features/history/data/pre_islam_world_secondary_research.dart';

void main() {
  test('all required T0211 topics have two independent academic works', () {
    final registry = preIslamWorldIndependentResearch;

    expect(
      registry.topicSourceIds.keys.toSet(),
      equals(PreIslamWorldContextDataset.requiredTopicIds),
    );

    for (final topicId in PreIslamWorldContextDataset.requiredTopicIds) {
      final sourceIds = registry.topicSourceIds[topicId]!;
      final families = sourceIds
          .map((sourceId) => registry.sourceFamilies[sourceId])
          .whereType<String>()
          .toSet();
      final canonicalEntry = preIslamWorldResearchEntries.singleWhere(
        (entry) => entry.id == topicId,
      );

      expect(
        sourceIds,
        containsAll(canonicalEntry.sourceIds),
        reason: '$topicId must retain its canonical research citations',
      );
      expect(
        families.length,
        greaterThanOrEqualTo(2),
        reason: '$topicId must have two independent academic works',
      );
    }
  });

  test('same edited volume cannot masquerade as two independent works', () {
    expect(
      () => IndependentHistoryResearchRegistry.validated(
        baseSources: preIslamWorldResearchSources,
        supplementalSources: preIslamWorldSupplementalSources,
        baseEntries: preIslamWorldResearchEntries,
        sourceFamilies: preIslamWorldIndependentSourceFamilies,
        topicSourceIds: {
          ...preIslamWorldTopicResearchSources,
          'south_arabia_yemen': const [
            'fisher_2015_arabs_empires',
            'robin_2015_himyar_aksum',
          ],
        },
      ),
      throwsStateError,
    );
  });

  test('unknown source IDs fail closed', () {
    expect(
      () => IndependentHistoryResearchRegistry.validated(
        baseSources: preIslamWorldResearchSources,
        supplementalSources: preIslamWorldSupplementalSources,
        baseEntries: preIslamWorldResearchEntries,
        sourceFamilies: preIslamWorldIndependentSourceFamilies,
        topicSourceIds: {
          ...preIslamWorldTopicResearchSources,
          'aksum': const ['grasso_2023_ch4', 'not-a-real-source'],
        },
      ),
      throwsStateError,
    );
  });

  test('missing required topic fails closed', () {
    final incomplete = Map<String, List<String>>.from(
      preIslamWorldTopicResearchSources,
    )..remove('late_antiquity');

    expect(
      () => IndependentHistoryResearchRegistry.validated(
        baseSources: preIslamWorldResearchSources,
        supplementalSources: preIslamWorldSupplementalSources,
        baseEntries: preIslamWorldResearchEntries,
        sourceFamilies: preIslamWorldIndependentSourceFamilies,
        topicSourceIds: incomplete,
      ),
      throwsStateError,
    );
  });

  test('unexpected topic IDs fail closed instead of becoming orphan evidence', () {
    expect(
      () => IndependentHistoryResearchRegistry.validated(
        baseSources: preIslamWorldResearchSources,
        supplementalSources: preIslamWorldSupplementalSources,
        baseEntries: preIslamWorldResearchEntries,
        sourceFamilies: preIslamWorldIndependentSourceFamilies,
        topicSourceIds: {
          ...preIslamWorldTopicResearchSources,
          'mecca_typo': const [
            'cambridge_history_islam_pre_islamic_arabia',
            'hoyland_2001_arabia_arabs',
          ],
        },
      ),
      throwsStateError,
    );
  });

  test('two replacement works cannot silently drop a canonical citation', () {
    expect(
      () => IndependentHistoryResearchRegistry.validated(
        baseSources: preIslamWorldResearchSources,
        supplementalSources: preIslamWorldSupplementalSources,
        baseEntries: preIslamWorldResearchEntries,
        sourceFamilies: preIslamWorldIndependentSourceFamilies,
        topicSourceIds: {
          ...preIslamWorldTopicResearchSources,
          'late_antiquity': const [
            'fisher_2015_arabs_empires',
            'hoyland_2001_arabia_arabs',
          ],
        },
      ),
      throwsStateError,
    );
  });

  test('orphan source-family metadata fails closed', () {
    expect(
      () => IndependentHistoryResearchRegistry.validated(
        baseSources: preIslamWorldResearchSources,
        supplementalSources: preIslamWorldSupplementalSources,
        baseEntries: preIslamWorldResearchEntries,
        sourceFamilies: {
          ...preIslamWorldIndependentSourceFamilies,
          'not-a-real-source': 'orphan-family',
        },
        topicSourceIds: preIslamWorldTopicResearchSources,
      ),
      throwsStateError,
    );
  });
}