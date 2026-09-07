import '../data/modern_global_islamic_history.dart';

/// Fail-closed canonical-shape and provenance validation for the T0218
/// modern/global Islamic-history set.
///
/// These records deliberately summarize overlapping global processes. The
/// canonical IDs must not be padded with unreviewed extras, silently moved to
/// another track, or detached from the academic works selected for that topic.
class T0218CanonicalHistoryGate {
  const T0218CanonicalHistoryGate._();

  static const Map<String, ModernGlobalHistoryTrack> requiredTrackByEntryId = {
    'colonial_imperial_rule': ModernGlobalHistoryTrack.colonialImperialRule,
    'decolonization_nation_states':
        ModernGlobalHistoryTrack.decolonizationNationStates,
    'twentieth_century_transformations':
        ModernGlobalHistoryTrack.twentiethCenturyTransformations,
    'contemporary_global_muslim_societies':
        ModernGlobalHistoryTrack.contemporaryGlobalMuslimSocieties,
  };

  static const Map<String, Set<String>> requiredSourceIdsByEntryId = {
    'colonial_imperial_rule': {
      'motadel_islam_european_empires',
      'nchi_v5_western_dominance',
    },
    'decolonization_nation_states': {
      'nchi_v5_western_dominance',
      'lapidus_modern_muslim_societies',
    },
    'twentieth_century_transformations': {
      'ali_islam_colonialism_indonesia_malaya',
      'nchi_v5_western_dominance',
    },
    'contemporary_global_muslim_societies': {
      'ansari_islam_west',
      'greble_muslims_modern_europe',
      'lapidus_modern_muslim_societies',
    },
  };

  static void validateCanonicalDataset() =>
      validate(modernGlobalIslamicHistoryT0218);

  static void validate(ModernGlobalIslamicHistoryDataset dataset) {
    final ids = dataset.entries.map((entry) => entry.id).toSet();
    final requiredIds = requiredTrackByEntryId.keys.toSet();

    if (ids.length != dataset.entries.length) {
      throw StateError('T0218 canonical history contains duplicate entry IDs.');
    }
    if (ids.length != requiredIds.length ||
        !ids.containsAll(requiredIds) ||
        !requiredIds.containsAll(ids)) {
      throw StateError(
        'T0218 canonical history must contain exactly the four governed modern/global records.',
      );
    }

    for (final entry in dataset.entries) {
      final expectedTrack = requiredTrackByEntryId[entry.id];
      if (expectedTrack == null || entry.track != expectedTrack) {
        throw StateError(
          'T0218 canonical record ${entry.id} is assigned to the wrong modern-history track.',
        );
      }

      final expectedSources = requiredSourceIdsByEntryId[entry.id];
      final actualSources = entry.sourceIds.toSet();
      if (expectedSources == null ||
          actualSources.length != expectedSources.length ||
          !actualSources.containsAll(expectedSources) ||
          !expectedSources.containsAll(actualSources)) {
        throw StateError(
          'T0218 canonical record ${entry.id} lost or replaced its governed academic provenance.',
        );
      }
    }
  }
}
