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
  });
}
