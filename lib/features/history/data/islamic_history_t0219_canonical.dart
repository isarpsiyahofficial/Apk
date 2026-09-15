import 'islamic_history_horizontal_themes.dart';
import 'pre_islam_world_context.dart';

const _bessardCaliphsMerchants = HorizontalThemeSource(
  workFamilyId: 'bessard_caliphs_merchants',
  locator: HistorySourceLocator(
    id: 'bessard_caliphs_merchants',
    kind: HistorySourceKind.academicMonograph,
    citation: 'Fanny Bessard, Caliphs and Merchants: Cities and Economies of Power in the Near East (700-950), Oxford University Press, 2020.',
    locator: 'doi:10.1093/oso/9780198855828.001.0001',
  ),
);

IslamicHistoryThemeEntry _copyWithSources(
  IslamicHistoryThemeEntry entry,
  List<String> sourceIds,
) {
  return IslamicHistoryThemeEntry(
    id: entry.id,
    theme: entry.theme,
    title: entry.title,
    summary: entry.summary,
    startYearCe: entry.startYearCe,
    endYearCe: entry.endYearCe,
    certainty: entry.certainty,
    caveat: entry.caveat,
    sourceIds: sourceIds,
    status: entry.status,
  );
}

final islamicHistoryT0219CanonicalSources = List<HorizontalThemeSource>.unmodifiable(
  <HorizontalThemeSource>[
    ...islamicHistoryT0219Sources,
    _bessardCaliphsMerchants,
  ],
);

final islamicHistoryT0219CanonicalEntries = List<IslamicHistoryThemeEntry>.unmodifiable(
  islamicHistoryT0219Entries.map((entry) {
    if (entry.id != 'trade_urbanization_history') {
      return entry;
    }
    return _copyWithSources(
      entry,
      const ['lapidus_societies_horizontal', 'bessard_caliphs_merchants'],
    );
  }),
);

class T0219CanonicalHorizontalThemeGate {
  const T0219CanonicalHorizontalThemeGate._();

  static const _themeById = <String, IslamicHistoryTheme>{
    'science_history': IslamicHistoryTheme.science,
    'medicine_history': IslamicHistoryTheme.medicine,
    'mathematics_astronomy_history': IslamicHistoryTheme.mathematicsAstronomy,
    'philosophy_thought_history': IslamicHistoryTheme.philosophyThought,
    'hadith_tafsir_fiqh_history': IslamicHistoryTheme.hadithTafsirFiqh,
    'art_architecture_history': IslamicHistoryTheme.artArchitecture,
    'trade_urbanization_history': IslamicHistoryTheme.tradeUrbanization,
    'education_history': IslamicHistoryTheme.education,
    'women_historical_roles': IslamicHistoryTheme.womenHistoricalRoles,
  };

  static const _sourceIdsById = <String, List<String>>{
    'science_history': ['saliba_islamic_science', 'lapidus_societies_horizontal'],
    'medicine_history': ['pormann_savage_smith_medicine', 'lapidus_societies_horizontal'],
    'mathematics_astronomy_history': ['saliba_islamic_science', 'lapidus_societies_horizontal'],
    'philosophy_thought_history': ['adamson_philosophy_islamic_world', 'lapidus_societies_horizontal'],
    'hadith_tafsir_fiqh_history': ['hallaq_origins_islamic_law', 'melchert_sunni_schools'],
    'art_architecture_history': ['ettinghausen_grabar_jenkins_art', 'lapidus_societies_horizontal'],
    'trade_urbanization_history': ['lapidus_societies_horizontal', 'bessard_caliphs_merchants'],
    'education_history': ['makdisi_rise_colleges', 'sayeed_women_knowledge'],
    'women_historical_roles': ['sayeed_women_knowledge', 'ahmed_women_gender'],
  };

  static void validate(List<IslamicHistoryThemeEntry> entries) {
    final ids = entries.map((entry) => entry.id).toSet();
    if (entries.length != _themeById.length ||
        ids.length != _themeById.length ||
        !ids.containsAll(_themeById.keys)) {
      throw StateError('T0219 canonical inventory must contain exactly nine governed theme IDs.');
    }

    for (final entry in entries) {
      final expectedTheme = _themeById[entry.id];
      final expectedSources = _sourceIdsById[entry.id]!.toSet();
      final actualSources = entry.sourceIds.toSet();
      if (entry.theme != expectedTheme) {
        throw StateError('T0219 canonical ID/theme mapping changed for ${entry.id}.');
      }
      if (actualSources.length != expectedSources.length ||
          !actualSources.containsAll(expectedSources)) {
        throw StateError('T0219 canonical provenance changed for ${entry.id}.');
      }
    }
  }
}

final islamicHistoryHorizontalThemesT0219Canonical = (() {
  T0219CanonicalHorizontalThemeGate.validate(islamicHistoryT0219CanonicalEntries);
  return IslamicHistoryHorizontalThemesDataset.validated(
    sources: islamicHistoryT0219CanonicalSources,
    entries: islamicHistoryT0219CanonicalEntries,
  );
})();
