import 'pre_islam_world_context.dart';

class IndependentHistoryResearchRegistry {
  IndependentHistoryResearchRegistry._({
    required this.sources,
    required this.sourceFamilies,
    required this.topicSourceIds,
  });

  factory IndependentHistoryResearchRegistry.validated({
    required List<HistorySourceLocator> baseSources,
    required List<HistorySourceLocator> supplementalSources,
    required Map<String, String> sourceFamilies,
    required Map<String, List<String>> topicSourceIds,
  }) {
    final allSources = <HistorySourceLocator>[
      ...baseSources,
      ...supplementalSources,
    ];
    final byId = <String, HistorySourceLocator>{};
    for (final source in allSources) {
      if (!source.isComplete || byId.containsKey(source.id)) {
        throw StateError('History research sources must be unique and complete.');
      }
      byId[source.id] = source;
    }

    if (!topicSourceIds.keys.toSet().containsAll(
          PreIslamWorldContextDataset.requiredTopicIds,
        )) {
      throw StateError('Every required pre-Islam topic needs research evidence.');
    }

    for (final topicId in PreIslamWorldContextDataset.requiredTopicIds) {
      final ids = topicSourceIds[topicId] ?? const <String>[];
      if (ids.length != ids.toSet().length ||
          ids.any((sourceId) => !byId.containsKey(sourceId))) {
        throw StateError('Topic $topicId has duplicate or unknown sources.');
      }
      final families = <String>{};
      for (final sourceId in ids) {
        final family = sourceFamilies[sourceId];
        if (family == null || family.trim().isEmpty) {
          throw StateError('Source $sourceId has no independence family.');
        }
        families.add(family);
      }
      if (families.length < 2) {
        throw StateError(
          'Topic $topicId requires at least two independent academic works.',
        );
      }
    }

    return IndependentHistoryResearchRegistry._(
      sources: List.unmodifiable(allSources),
      sourceFamilies: Map.unmodifiable(sourceFamilies),
      topicSourceIds: Map.unmodifiable(
        topicSourceIds.map(
          (key, value) => MapEntry(key, List<String>.unmodifiable(value)),
        ),
      ),
    );
  }

  final List<HistorySourceLocator> sources;
  final Map<String, String> sourceFamilies;
  final Map<String, List<String>> topicSourceIds;
}

const preIslamWorldSupplementalSources = <HistorySourceLocator>[
  HistorySourceLocator(
    id: 'hoyland_2001_arabia_arabs',
    kind: HistorySourceKind.academicMonograph,
    citation:
        'Robert G. Hoyland, Arabia and the Arabs: From the Bronze Age to the Coming of Islam, Routledge, 2001.',
    locator: 'ISBN 9780415195355; chapters 1–6',
  ),
  HistorySourceLocator(
    id: 'fisher_2015_arabs_empires',
    kind: HistorySourceKind.academicMonograph,
    citation:
        'Greg Fisher (ed.), Arabs and Empires before Islam, Oxford University Press, 2015.',
    locator: 'doi:10.1093/acprof:oso/9780199654529.001.0001',
  ),
  HistorySourceLocator(
    id: 'robin_2015_himyar_aksum',
    kind: HistorySourceKind.academicChapter,
    citation:
        'Christian Julien Robin, “Himyar, Aksum, and Arabia Deserta in Late Antiquity: The Epigraphic Evidence”, in Arabs and Empires before Islam, Oxford University Press, 2015, pp. 127–171.',
    locator: 'doi:10.1093/acprof:oso/9780199654529.003.0004',
  ),
  HistorySourceLocator(
    id: 'bowersock_2013_throne_adulis',
    kind: HistorySourceKind.academicMonograph,
    citation:
        'G. W. Bowersock, The Throne of Adulis: Red Sea Wars on the Eve of Islam, Oxford University Press, 2013.',
    locator: 'ISBN 9780199739325',
  ),
  HistorySourceLocator(
    id: 'robin_harris_2021_judaism_arabia',
    kind: HistorySourceKind.academicChapter,
    citation:
        'Christian Julien Robin and Jason Harris, “Judaism in Pre-Islamic Arabia”, The Cambridge History of Judaism, Cambridge University Press, 2021, pp. 294–331.',
    locator: 'doi:10.1017/9781139048873.013',
  ),
];

const preIslamWorldIndependentSourceFamilies = <String, String>{
  'grasso_2023_ch1': 'grasso_2023_pre_islamic_arabia',
  'grasso_2023_ch3': 'grasso_2023_pre_islamic_arabia',
  'grasso_2023_ch4': 'grasso_2023_pre_islamic_arabia',
  'cambridge_history_islam_pre_islamic_arabia':
      'new_cambridge_history_of_islam_v1',
  'hallaq_pre_islamic_near_east': 'hallaq_origins_evolution_islamic_law',
  'hawting_idolatry': 'hawting_idea_of_idolatry',
  'hoyland_2001_arabia_arabs': 'hoyland_2001_arabia_arabs',
  'fisher_2015_arabs_empires': 'fisher_2015_arabs_empires',
  'robin_2015_himyar_aksum': 'fisher_2015_arabs_empires',
  'bowersock_2013_throne_adulis': 'bowersock_2013_throne_adulis',
  'robin_harris_2021_judaism_arabia': 'cambridge_history_judaism_v5',
};

const preIslamWorldTopicResearchSources = <String, List<String>>{
  'late_antiquity': ['grasso_2023_ch1', 'fisher_2015_arabs_empires'],
  'byzantine_world': [
    'cambridge_history_islam_pre_islamic_arabia',
    'fisher_2015_arabs_empires',
  ],
  'sasanian_world': [
    'cambridge_history_islam_pre_islamic_arabia',
    'fisher_2015_arabs_empires',
  ],
  'aksum': ['grasso_2023_ch4', 'bowersock_2013_throne_adulis'],
  'south_arabia_yemen': [
    'grasso_2023_ch3',
    'robin_2015_himyar_aksum',
    'bowersock_2013_throne_adulis',
  ],
  'mecca': [
    'cambridge_history_islam_pre_islamic_arabia',
    'hoyland_2001_arabia_arabs',
  ],
  'yathrib_medina': [
    'cambridge_history_islam_pre_islamic_arabia',
    'hoyland_2001_arabia_arabs',
  ],
  'tribal_society': ['grasso_2023_ch1', 'hoyland_2001_arabia_arabs'],
  'jewish_communities': [
    'grasso_2023_ch3',
    'robin_harris_2021_judaism_arabia',
  ],
  'christian_communities': [
    'grasso_2023_ch4',
    'fisher_2015_arabs_empires',
  ],
  'arabian_polytheism': [
    'hawting_idolatry',
    'hoyland_2001_arabia_arabs',
  ],
};

final preIslamWorldIndependentResearch =
    IndependentHistoryResearchRegistry.validated(
  baseSources: preIslamWorldResearchSources,
  supplementalSources: preIslamWorldSupplementalSources,
  sourceFamilies: preIslamWorldIndependentSourceFamilies,
  topicSourceIds: preIslamWorldTopicResearchSources,
);
