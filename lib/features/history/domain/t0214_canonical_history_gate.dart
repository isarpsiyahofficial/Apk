import '../data/medieval_caliphates_regional_dynasties.dart';

/// Fail-closed canonical-shape validation for the T0214 medieval history set.
///
/// T0214 is intentionally parallel rather than a single linear timeline, but
/// its six canonical records must not be silently reclassified, duplicated, or
/// padded with unreviewed extra records.
class T0214CanonicalHistoryGate {
  const T0214CanonicalHistoryGate._();

  static const Map<String, MedievalHistoryTrack> requiredTrackByEntryId = {
    'umayyad_caliphate': MedievalHistoryTrack.umayyad,
    'abbasid_caliphate': MedievalHistoryTrack.abbasid,
    'umayyad_al_andalus': MedievalHistoryTrack.alAndalus,
    'fatimid_caliphate': MedievalHistoryTrack.fatimid,
    'samanid_regional_power': MedievalHistoryTrack.regionalDynasties,
    'buyid_regional_power': MedievalHistoryTrack.regionalDynasties,
  };

  static void validateCanonicalDataset() => validate(medievalHistoryT0214);

  static void validate(MedievalHistoryDataset dataset) {
    final ids = dataset.entries.map((entry) => entry.id).toSet();
    final requiredIds = requiredTrackByEntryId.keys.toSet();

    if (ids.length != dataset.entries.length) {
      throw StateError('T0214 canonical history contains duplicate entry IDs.');
    }
    if (ids.length != requiredIds.length ||
        !ids.containsAll(requiredIds) ||
        !requiredIds.containsAll(ids)) {
      throw StateError(
        'T0214 canonical history must contain exactly the six governed records.',
      );
    }

    for (final entry in dataset.entries) {
      final expectedTrack = requiredTrackByEntryId[entry.id];
      if (expectedTrack == null || entry.track != expectedTrack) {
        throw StateError(
          'T0214 canonical record ${entry.id} is assigned to the wrong history track.',
        );
      }
    }
  }
}
