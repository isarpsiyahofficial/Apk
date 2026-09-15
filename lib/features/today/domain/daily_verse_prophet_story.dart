import '../../prophets/data/prophet_biography_t0194_dataset.dart';
import '../../quran/data/quran_search_repository.dart';

/// Returns only canonical prophet IDs whose reviewed Quran-reference list
/// explicitly contains [address].
///
/// No fuzzy surah matching, story inference, tafsir guess or prophet-name
/// search is used. If the verse has no explicit T0194 Quran reference, the
/// daily card must not advertise a prophet-story destination.
List<String> prophetStoryIdsForDailyVerse(QuranAddress address) {
  final ids = <String>[];
  for (final biography in canonicalProphetBiographyT0194Dataset) {
    final exact = biography.quranReferences.any(
      (reference) =>
          reference.surah == address.surah && reference.ayah == address.ayah,
    );
    if (exact) ids.add(biography.identity.canonicalId);
  }
  return List<String>.unmodifiable(ids);
}
