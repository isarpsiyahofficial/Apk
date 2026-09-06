import 'package:islami_hayat/features/prophets/data/canonical_prophet_biographies.dart';
import 'package:islami_hayat/features/prophets/data/prophet_biography_t0194_dataset.dart';

class DailyProphetLearningSuggestion {
  const DailyProphetLearningSuggestion({
    required this.prophetId,
    required this.sectionKey,
    required this.field,
  });

  final String prophetId;
  final ProphetBiographySectionKey sectionKey;
  final ProphetBiographyField field;
}

/// Builds the T0204 "What shall we learn today?" suggestion exclusively from
/// source-backed T0194 biography fields. Pending/unknown research is never
/// promoted into a daily recommendation.
DailyProphetLearningSuggestion? dailyProphetLearningForDate(DateTime date) {
  final candidates = <DailyProphetLearningSuggestion>[];

  for (final biography in canonicalProphetBiographyT0194Dataset) {
    for (final entry in biography.sections.entries) {
      if (entry.key == ProphetBiographySectionKey.mainMessage) continue;
      final field = entry.value;
      if (field.status != ProphetBiographyFieldStatus.sourceBacked ||
          field.sources.isEmpty ||
          field.sources.any(
            (source) => source.locator?.trim().isEmpty ?? true,
          )) {
        continue;
      }
      candidates.add(
        DailyProphetLearningSuggestion(
          prophetId: biography.identity.canonicalId,
          sectionKey: entry.key,
          field: field,
        ),
      );
    }
  }

  if (candidates.isEmpty) return null;
  final day = DateTime.utc(date.year, date.month, date.day)
      .difference(DateTime.utc(2026, 1, 1))
      .inDays;
  return candidates[day.abs() % candidates.length];
}
