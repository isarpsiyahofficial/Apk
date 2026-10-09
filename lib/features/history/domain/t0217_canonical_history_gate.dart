import '../data/regional_islamic_histories.dart';

/// Fail-closed canonical-shape and provenance validation for the T0217
/// regional Islamic-history set.
///
/// The five regional histories intentionally overlap in time and therefore
/// remain parallel tracks. Canonical records must not be silently reassigned,
/// padded with unreviewed extras, or detached from the academic works selected
/// for that region.
class T0217CanonicalHistoryGate {
  const T0217CanonicalHistoryGate._();

  static const Map<String, RegionalIslamicHistoryTrack> requiredTrackByEntryId = {
    'africa_islamic_history': RegionalIslamicHistoryTrack.africa,
    'central_asia_islamic_history': RegionalIslamicHistoryTrack.centralAsia,
    'southeast_asia_islamic_history': RegionalIslamicHistoryTrack.southeastAsia,
    'indian_subcontinent_islamic_history':
        RegionalIslamicHistoryTrack.indianSubcontinent,
    'europe_islamic_history': RegionalIslamicHistoryTrack.europe,
  };

  static const Map<String, Set<String>> requiredSourceIdsByEntryId = {
    'africa_islamic_history': {
      'robinson_muslim_societies_africa',
      'lapidus_west_africa',
    },
    'central_asia_islamic_history': {
      'tor_samanid_islamization',
      'formichi_islam_across_oxus',
    },
    'southeast_asia_islamic_history': {
      'lapidus_southeast_asia',
      'feener_muslim_circulations_monsoon_asia',
    },
    'indian_subcontinent_islamic_history': {
      'wink_medieval_india_rise_islam',
      'lapidus_indian_subcontinent',
    },
    'europe_islamic_history': {
      'berger_brief_history_islam_europe',
      'nchi_muslims_west_europe',
    },
  };

  static void validateCanonicalDataset() => validate(regionalIslamicHistoriesT0217);

  static void validate(RegionalIslamicHistoriesDataset dataset) {
    final ids = dataset.entries.map((entry) => entry.id).toSet();
    final requiredIds = requiredTrackByEntryId.keys.toSet();

    if (ids.length != dataset.entries.length) {
      throw StateError('T0217 canonical history contains duplicate entry IDs.');
    }
    if (ids.length != requiredIds.length ||
        !ids.containsAll(requiredIds) ||
        !requiredIds.containsAll(ids)) {
      throw StateError(
        'T0217 canonical history must contain exactly the five governed regional records.',
      );
    }

    for (final entry in dataset.entries) {
      final expectedTrack = requiredTrackByEntryId[entry.id];
      if (expectedTrack == null || entry.track != expectedTrack) {
        throw StateError(
          'T0217 canonical record ${entry.id} is assigned to the wrong regional track.',
        );
      }

      final expectedSources = requiredSourceIdsByEntryId[entry.id];
      final actualSources = entry.sourceIds.toSet();
      if (expectedSources == null ||
          actualSources.length != expectedSources.length ||
          !actualSources.containsAll(expectedSources) ||
          !expectedSources.containsAll(actualSources)) {
        throw StateError(
          'T0217 canonical record ${entry.id} lost or replaced its governed academic provenance.',
        );
      }
    }
  }
}
