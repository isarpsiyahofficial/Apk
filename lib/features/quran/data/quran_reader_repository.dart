import 'package:islami_hayat/features/quran/data/bundled_meal_dataset.dart';
import 'package:islami_hayat/features/quran/data/canonical_quran_source.dart';
import 'package:islami_hayat/features/quran/data/verified_meal_sources.dart';

final class QuranReaderVerse {
  const QuranReaderVerse({
    required this.surah,
    required this.ayah,
    required this.arabic,
    this.translation,
    this.footnotes,
  });

  final int surah;
  final int ayah;
  final String arabic;
  final String? translation;
  final String? footnotes;
}

final class QuranChapterSummary {
  const QuranChapterSummary({
    required this.surah,
    required this.ayahCount,
  });

  final int surah;
  final int ayahCount;
}

final class QuranReaderChapter {
  const QuranReaderChapter({
    required this.surah,
    required this.verses,
    this.mealSource,
  });

  final int surah;
  final List<QuranReaderVerse> verses;
  final VerifiedMealSource? mealSource;
}

final class QuranReaderRepository {
  QuranReaderRepository({
    CanonicalQuranAssetLoader? quranLoader,
    BundledMealDatasetLoader? mealLoader,
  }) : _quranLoader = quranLoader ?? CanonicalQuranAssetLoader(),
       _mealLoader = mealLoader ?? BundledMealDatasetLoader();

  final CanonicalQuranAssetLoader _quranLoader;
  final BundledMealDatasetLoader _mealLoader;

  List<QuranChapterSummary> get chapterSummaries => List.unmodifiable(
    List.generate(
      canonicalQuranSuraCount,
      (index) => QuranChapterSummary(
        surah: index + 1,
        ayahCount: canonicalQuranAyahCountForSura(index + 1),
      ),
      growable: false,
    ),
  );

  Future<QuranReaderChapter> loadChapter({
    required String languageCode,
    int surah = 1,
  }) async {
    if (surah < 1 || surah > canonicalQuranSuraCount) {
      throw RangeError.range(surah, 1, canonicalQuranSuraCount, 'surah');
    }

    final quran = await _quranLoader.load();
    BundledMealDataset? meal;
    VerifiedMealSource? mealSource;
    if (languageCode == 'tr' || languageCode == 'en') {
      meal = await _mealLoader.loadForLocale(languageCode);
      mealSource = meal.source;
    }

    final verses = <QuranReaderVerse>[];
    for (final ayah in quran.ayahs.where((item) => item.sura == surah)) {
      final mealVerse = meal?.verse(ayah.sura, ayah.ayah);
      verses.add(
        QuranReaderVerse(
          surah: ayah.sura,
          ayah: ayah.ayah,
          arabic: ayah.arabic,
          translation: mealVerse?.translation,
          footnotes: mealVerse?.footnotes,
        ),
      );
    }

    if (verses.length != canonicalQuranAyahCountForSura(surah)) {
      throw StateError('Verified Quran chapter $surah is structurally incomplete');
    }

    return QuranReaderChapter(
      surah: surah,
      verses: List.unmodifiable(verses),
      mealSource: mealSource,
    );
  }
}
