import 'package:islami_hayat/core/content/content_governance.dart';
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

const Set<ReligiousSourceClass> _dailyProphetLearningAllowedSourceClasses = {
  ReligiousSourceClass.quran,
  ReligiousSourceClass.sahihHasanHadith,
  ReligiousSourceClass.earlyIslamicHistoryTafsir,
  ReligiousSourceClass.modernHistoryArchaeology,
};

/// T0204 daily recommendations must be suitable for a short, source-forward
/// learning surface. Traditional/Israiliyat/disputed/unknown material may stay
/// visible in its explicitly labelled research context, but it is never
/// promoted into the daily recommendation carousel.
bool isDailyProphetLearningFieldEligible(ProphetBiographyField field) {
  if (field.status != ProphetBiographyFieldStatus.sourceBacked ||
      !field.text.isComplete ||
      field.sources.isEmpty) {
    return false;
  }

  return field.sources.every((source) {
    final locator = source.locator?.trim();
    return _dailyProphetLearningAllowedSourceClasses.contains(
          source.sourceClass,
        ) &&
        source.id.trim().isNotEmpty &&
        source.title.trim().isNotEmpty &&
        source.licenseId.trim().isNotEmpty &&
        locator != null &&
        locator.isNotEmpty;
  });
}

/// Builds the T0204 "What shall we learn today?" suggestion exclusively from
/// source-backed T0194 biography fields. Pending/unknown research and weaker
/// provenance classes are never promoted into a daily recommendation.
DailyProphetLearningSuggestion? dailyProphetLearningForDate(DateTime date) {
  final candidates = <DailyProphetLearningSuggestion>[];

  for (final biography in canonicalProphetBiographyT0194Dataset) {
    for (final entry in biography.sections.entries) {
      if (entry.key == ProphetBiographySectionKey.mainMessage) continue;
      final field = entry.value;
      if (!isDailyProphetLearningFieldEligible(field)) continue;
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
