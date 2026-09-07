import '../data/early_modern_ottoman_safavid_mughal.dart';

/// Fail-closed canonical-shape validation for the T0216 early-modern set.
///
/// Ottoman, Safavid and Mughal histories overlap in time and therefore remain
/// separate tracks. The governed three records must not be silently
/// reclassified, duplicated, or padded with unreviewed extra records.
class T0216CanonicalHistoryGate {
  const T0216CanonicalHistoryGate._();

  static const Map<String, EarlyModernEmpireTrack> requiredTrackByEntryId = {
    'ottoman_empire': EarlyModernEmpireTrack.ottoman,
    'safavid_iran': EarlyModernEmpireTrack.safavid,
    'mughal_empire': EarlyModernEmpireTrack.mughal,
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
    }
  }
}
