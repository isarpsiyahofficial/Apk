import 'package:islami_hayat/features/quran/data/bundled_meal_dataset.dart';
import 'package:islami_hayat/features/quran/data/canonical_quran_source.dart';

final class QuranAddress {
  const QuranAddress({required this.surah, required this.ayah});

  final int surah;
  final int ayah;

  String get key => '$surah:$ayah';
}

final class QuranSearchResult {
  const QuranSearchResult({
    required this.surah,
    required this.ayah,
    required this.arabic,
    this.translation,
  });

  final int surah;
  final int ayah;
  final String arabic;
  final String? translation;

  String get key => '$surah:$ayah';
}

abstract interface class QuranSearchDataSource {
  QuranAddress? parseAddress(String input);

  Future<List<QuranSearchResult>> search({
    required String languageCode,
    required String query,
    int limit = 50,
  });
}

final class QuranSearchRepository implements QuranSearchDataSource {
  QuranSearchRepository({
    CanonicalQuranAssetLoader? quranLoader,
    BundledMealDatasetLoader? mealLoader,
  }) : _quranLoader = quranLoader ?? CanonicalQuranAssetLoader(),
       _mealLoader = mealLoader ?? BundledMealDatasetLoader();

  final CanonicalQuranAssetLoader _quranLoader;
  final BundledMealDatasetLoader _mealLoader;

  @override
  QuranAddress? parseAddress(String input) {
    final match = RegExp(r'^\s*(\d{1,3})\s*:\s*(\d{1,3})\s*$').firstMatch(input);
    if (match == null) return null;

    final surah = int.tryParse(match.group(1)!);
    final ayah = int.tryParse(match.group(2)!);
    if (surah == null || ayah == null) return null;
    if (surah < 1 || surah > canonicalQuranSuraCount) return null;
    if (ayah < 1 || ayah > canonicalQuranAyahCountForSura(surah)) return null;
    return QuranAddress(surah: surah, ayah: ayah);
  }

  @override
  Future<List<QuranSearchResult>> search({
    required String languageCode,
    required String query,
    int limit = 50,
  }) async {
    if (limit < 1 || limit > 200) {
      throw RangeError.range(limit, 1, 200, 'limit');
    }

    final trimmed = query.trim();
    if (trimmed.isEmpty) return const [];

    final quran = await _quranLoader.load();
    BundledMealDataset? meal;
    if (languageCode == 'tr' || languageCode == 'en') {
      meal = await _mealLoader.loadForLocale(languageCode);
    } else if (languageCode != 'ar') {
      throw UnsupportedError('Unsupported Quran search locale: $languageCode');
    }

    final direct = parseAddress(trimmed);
    if (direct != null) {
      final ayah = quran.ayah(direct.surah, direct.ayah);
      final translation = meal?.verse(direct.surah, direct.ayah).translation;
      return [
        QuranSearchResult(
          surah: direct.surah,
          ayah: direct.ayah,
          arabic: ayah.arabic,
          translation: translation,
        ),
      ];
    }

    final needle = languageCode == 'ar'
        ? _normalizeArabic(trimmed)
        : _normalizeLatin(trimmed);
    if (needle.isEmpty) return const [];

    final results = <QuranSearchResult>[];
    for (final ayah in quran.ayahs) {
      final translation = meal?.verse(ayah.sura, ayah.ayah).translation;
      final haystack = languageCode == 'ar'
          ? _normalizeArabic(ayah.arabic)
          : _normalizeLatin(translation ?? '');
      if (!haystack.contains(needle)) continue;

      results.add(
        QuranSearchResult(
          surah: ayah.sura,
          ayah: ayah.ayah,
          arabic: ayah.arabic,
          translation: translation,
        ),
      );
      if (results.length == limit) break;
    }
    return List.unmodifiable(results);
  }
}

String _normalizeLatin(String value) {
  return value
      .trim()
      .toLowerCase()
      .replaceAll('ı', 'i')
      .replaceAll('İ', 'i')
      .replaceAll(RegExp(r'\s+'), ' ');
}

String _normalizeArabic(String value) {
  return value
      .replaceAll('\u0640', '')
      .replaceAll(RegExp(r'[\u0610-\u061A\u064B-\u065F\u0670\u06D6-\u06ED]'), '')
      .replaceAll(RegExp(r'[أإآٱ]'), 'ا')
      .replaceAll('ى', 'ي')
      .replaceAll(RegExp(r'\s+'), ' ')
      .trim();
}
