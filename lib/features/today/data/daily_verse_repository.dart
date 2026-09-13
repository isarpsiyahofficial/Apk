import 'package:islami_hayat/features/quran/data/bundled_meal_dataset.dart';
import 'package:islami_hayat/features/quran/data/canonical_quran_source.dart';
import 'package:islami_hayat/features/quran/data/quran_search_repository.dart';
import 'package:islami_hayat/features/quran/data/quran_sura_name_metadata.dart';

/// A curated list of Quran coordinates used only to select a daily verse.
///
/// The list never stores or copies Quran text. Arabic text and TR/EN meal are
/// loaded at runtime from the already hash-verified canonical datasets.
const List<QuranAddress> dailyVersePool = <QuranAddress>[
  QuranAddress(surah: 1, ayah: 5),
  QuranAddress(surah: 2, ayah: 152),
  QuranAddress(surah: 2, ayah: 153),
  QuranAddress(surah: 2, ayah: 186),
  QuranAddress(surah: 2, ayah: 286),
  QuranAddress(surah: 3, ayah: 139),
  QuranAddress(surah: 3, ayah: 159),
  QuranAddress(surah: 3, ayah: 200),
  QuranAddress(surah: 8, ayah: 46),
  QuranAddress(surah: 9, ayah: 51),
  QuranAddress(surah: 12, ayah: 87),
  QuranAddress(surah: 13, ayah: 28),
  QuranAddress(surah: 14, ayah: 7),
  QuranAddress(surah: 16, ayah: 97),
  QuranAddress(surah: 20, ayah: 46),
  QuranAddress(surah: 21, ayah: 87),
  QuranAddress(surah: 29, ayah: 69),
  QuranAddress(surah: 33, ayah: 3),
  QuranAddress(surah: 39, ayah: 53),
  QuranAddress(surah: 40, ayah: 60),
  QuranAddress(surah: 41, ayah: 34),
  QuranAddress(surah: 65, ayah: 3),
  QuranAddress(surah: 93, ayah: 5),
  QuranAddress(surah: 94, ayah: 5),
  QuranAddress(surah: 94, ayah: 6),
];

final class DailyVerse {
  const DailyVerse({
    required this.address,
    required this.arabic,
    required this.surahDisplayName,
    this.translation,
  });

  final QuranAddress address;
  final String arabic;
  final String? translation;
  final String surahDisplayName;

  String get sourceLabel =>
      '$surahDisplayName · ${address.surah}:${address.ayah}';
}

abstract interface class DailyVerseDataSource {
  Future<DailyVerse> forDate({
    required DateTime date,
    required String languageCode,
  });
}

final class DailyVerseRepository implements DailyVerseDataSource {
  DailyVerseRepository({
    CanonicalQuranAssetLoader? quranLoader,
    BundledMealDatasetLoader? mealLoader,
  }) : _quranLoader = quranLoader ?? CanonicalQuranAssetLoader(),
       _mealLoader = mealLoader ?? BundledMealDatasetLoader();

  final CanonicalQuranAssetLoader _quranLoader;
  final BundledMealDatasetLoader _mealLoader;

  @override
  Future<DailyVerse> forDate({
    required DateTime date,
    required String languageCode,
  }) async {
    if (languageCode != 'tr' && languageCode != 'en' && languageCode != 'ar') {
      throw UnsupportedError('Unsupported daily verse locale: $languageCode');
    }
    validateDailyVersePool();

    final address = dailyVersePool[_poolIndexForCivilDate(date)];
    final quran = await _quranLoader.load();
    final ayah = quran.ayah(address.surah, address.ayah);

    String? translation;
    if (languageCode == 'tr' || languageCode == 'en') {
      final meal = await _mealLoader.loadForLocale(languageCode);
      translation = meal.verse(address.surah, address.ayah).translation;
    }

    return DailyVerse(
      address: address,
      arabic: ayah.arabic,
      translation: translation,
      surahDisplayName: quranSuraName(
        address.surah,
      ).displayNameForLocale(languageCode),
    );
  }
}

void validateDailyVersePool() {
  if (dailyVersePool.isEmpty) {
    throw StateError('Daily verse pool cannot be empty.');
  }

  final seen = <String>{};
  for (final address in dailyVersePool) {
    if (address.surah < 1 || address.surah > canonicalQuranSuraCount) {
      throw StateError('Invalid daily verse surah: ${address.key}');
    }
    if (address.ayah < 1 ||
        address.ayah > canonicalQuranAyahCountForSura(address.surah)) {
      throw StateError('Invalid daily verse ayah: ${address.key}');
    }
    if (!seen.add(address.key)) {
      throw StateError('Duplicate daily verse address: ${address.key}');
    }
  }
}

int _poolIndexForCivilDate(DateTime date) {
  // Use only civil year/month/day components so reopening at another time on
  // the same local date cannot change the selected verse.
  final civilDate = DateTime.utc(date.year, date.month, date.day);
  final epoch = DateTime.utc(2020, 1, 1);
  final dayNumber = civilDate.difference(epoch).inDays;
  return dayNumber % dailyVersePool.length;
}
