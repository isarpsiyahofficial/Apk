import '../data/high_medieval_seljuq_crusades_mamluks.dart';

/// Fail-closed canonical-shape validation for the T0215 high-medieval set.
///
/// T0215 is intentionally parallel because Seljuq, Crusading, Ayyubid,
/// Mongol and Mamluk histories overlap. The governed five records must not be
/// silently reclassified, duplicated, or padded with unreviewed extra records.
class T0215CanonicalHistoryGate {
  const T0215CanonicalHistoryGate._();

  static const Map<String, HighMedievalHistoryTrack> requiredTrackByEntryId = {
    'great_seljuq_sultanate': HighMedievalHistoryTrack.seljuq,
    'crusading_movement_levant': HighMedievalHistoryTrack.crusades,
    'ayyubid_egypt_syria': HighMedievalHistoryTrack.ayyubid,
    'mongol_invasions_islamic_lands': HighMedievalHistoryTrack.mongol,
    'mamluk_sultanate_egypt_syria': HighMedievalHistoryTrack.mamluk,
  };

  static void validateCanonicalDataset() => validate(highMedievalHistoryT0215);

  static void validate(HighMedievalHistoryDataset dataset) {
    final ids = dataset.entries.map((entry) => entry.id).toSet();
    final requiredIds = requiredTrackByEntryId.keys.toSet();

    if (ids.length != dataset.entries.length) {
      throw StateError('T0215 canonical history contains duplicate entry IDs.');
    }
    if (ids.length != requiredIds.length ||
        !ids.containsAll(requiredIds) ||
        !requiredIds.containsAll(ids)) {
      throw StateError(
        'T0215 canonical history must contain exactly the five governed records.',
      );
    }

    for (final entry in dataset.entries) {
      final expectedTrack = requiredTrackByEntryId[entry.id];
      if (expectedTrack == null || entry.track != expectedTrack) {
        throw StateError(
          'T0215 canonical record ${entry.id} is assigned to the wrong history track.',
        );
      }
    }
  }
}
