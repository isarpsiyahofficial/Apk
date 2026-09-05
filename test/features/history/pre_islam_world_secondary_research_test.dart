import 'package:flutter_test/flutter_test.dart';
import 'package:islami_hayat/features/history/data/pre_islam_world_context.dart';
import 'package:islami_hayat/features/history/data/pre_islam_world_secondary_research.dart';

void main() {
  test('all required T0211 topics have two independent academic works', () {
    final registry = preIslamWorldIndependentResearch;

    expect(
      registry.topicSourceIds.keys.toSet(),
      containsAll(PreIslamWorldContextDataset.requiredTopicIds),
    );

    for (final topicId in PreIslamWorldContextDataset.requiredTopicIds) {
      final sourceIds = registry.topicSourceIds[topicId]!;
      final families = sourceIds
          .map((sourceId) => registry.sourceFamilies[sourceId])
          .whereType<String>()
          .toSet();

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
        sourceFamilies: preIslamWorldIndependentSourceFamilies,
        topicSourceIds: incomplete,
      ),
      throwsStateError,
    );
  });
}
