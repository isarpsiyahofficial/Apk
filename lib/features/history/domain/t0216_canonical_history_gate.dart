import '../data/early_modern_ottoman_safavid_mughal.dart';

/// Fail-closed canonical-shape and provenance validation for the T0216
/// early-modern set.
///
/// Ottoman, Safavid and Mughal histories overlap in time and therefore remain
/// separate tracks. The governed three records must not be silently
/// reclassified, duplicated, padded with unreviewed extra records, or detached
/// from the academic works selected for that record.
class T0216CanonicalHistoryGate {
  const T0216CanonicalHistoryGate._();

  static const Map<String, EarlyModernEmpireTrack> requiredTrackByEntryId = {
    'ottoman_empire': EarlyModernEmpireTrack.ottoman,
    'safavid_iran': EarlyModernEmpireTrack.safavid,
    'mughal_empire': EarlyModernEmpireTrack.mughal,
  };

  static const Map<String, Set<String>> requiredSourceIdsByEntryId = {
    'ottoman_empire': {
      'cambridge_history_turkey_v2',
      'imber_ottoman_1300_1650',
    },
    'safavid_iran': {
      'cambridge_history_iran_safavid',
      'newman_safavid_iran',
    },
    'mughal_empire': {
      'richards_mughal_empire',
      'asher_talbot_india_before_europe',
    },
  };

  static void validateCanonicalDataset() => validate(earlyModernEmpiresT0216);

  static void validate(EarlyModernEmpiresDataset dataset) {
    final ids = dataset.entries.map((entry) => entry.id).toSet();
    final requiredIds = requiredTrackByEntryId.keys.toSet();

    if (ids.length != dataset.entries.length) {
      throw StateError('T0216 canonical history contains duplicate entry IDs.');
    }
    if (ids.length != requiredIds.length ||
        !ids.containsAll(requiredIds) ||
        !requiredIds.containsAll(ids)) {
      throw StateError(
        'T0216 canonical history must contain exactly the three governed records.',
      );
    }

    for (final entry in dataset.entries) {
      final expectedTrack = requiredTrackByEntryId[entry.id];
      if (expectedTrack == null || entry.track != expectedTrack) {
        throw StateError(
          'T0216 canonical record ${entry.id} is assigned to the wrong history track.',
        );
      }

      final expectedSources = requiredSourceIdsByEntryId[entry.id];
      final actualSources = entry.sourceIds.toSet();
      if (expectedSources == null ||
          actualSources.length != expectedSources.length ||
          !actualSources.containsAll(expectedSources) ||
          !expectedSources.containsAll(actualSources)) {
        throw StateError(
          'T0216 canonical record ${entry.id} lost or replaced its governed academic provenance.',
        );
      }
    }
  }
}