import 'package:flutter_test/flutter_test.dart';
import 'package:islami_hayat/features/quran/data/canonical_quran_source.dart';
import 'package:islami_hayat/features/quran/data/quran_reader_repository.dart';

void main() {
  group('QuranReaderRepository chapter metadata', () {
    final repository = QuranReaderRepository();

    test('contains all 114 surahs in canonical order', () {
      final chapters = repository.chapterSummaries;

      expect(chapters, hasLength(canonicalQuranSuraCount));
      expect(chapters.first.surah, 1);
      expect(chapters.first.ayahCount, 7);
      expect(chapters[1].surah, 2);
      expect(chapters[1].ayahCount, 286);
      expect(chapters.last.surah, 114);
      expect(chapters.last.ayahCount, 6);
    });

    test('canonical surah counts total exactly 6236 ayahs', () {
      final total = repository.chapterSummaries.fold<int>(
        0,
        (sum, chapter) => sum + chapter.ayahCount,
      );

      expect(total, canonicalQuranAyahCount);
    });

    test('rejects out-of-range surah count access', () {
      expect(() => canonicalQuranAyahCountForSura(0), throwsRangeError);
      expect(
        () => canonicalQuranAyahCountForSura(115),
        throwsRangeError,
      );
    });

    test('loads exact Juz 2 start at Al-Baqara 2:142', () async {
      final chapter = await repository.loadChapter(
        languageCode: 'ar',
        surah: 2,
        startAyah: 142,
      );

      expect(chapter.surah, 2);
      expect(chapter.verses, hasLength(145));
      expect(chapter.verses.first.surah, 2);
      expect(chapter.verses.first.ayah, 142);
      expect(chapter.verses.last.surah, 2);
      expect(chapter.verses.last.ayah, 286);
      expect(chapter.mealSource, isNull);
    });

    test('rejects an impossible start ayah before loading Quran assets', () async {
      await expectLater(
        repository.loadChapter(
          languageCode: 'ar',
          surah: 1,
          startAyah: 8,
        ),
        throwsRangeError,
      );
    });
  });
}
