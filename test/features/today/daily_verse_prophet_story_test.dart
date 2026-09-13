import 'package:flutter_test/flutter_test.dart';
import 'package:islami_hayat/features/quran/data/quran_search_repository.dart';
import 'package:islami_hayat/features/today/domain/daily_verse_prophet_story.dart';

void main() {
  test('resolves only exact Quran-reference matches to canonical prophet ids', () {
    final ids = prophetStoryIdsForDailyVerse(
      const QuranAddress(surah: 21, ayah: 87),
    );

    expect(ids, contains('yunus'));
  });

  test('non-story daily verse does not receive an invented prophet target', () {
    final ids = prophetStoryIdsForDailyVerse(
      const QuranAddress(surah: 1, ayah: 5),
    );

    expect(ids, isEmpty);
  });

  test('adjacent verse does not fuzzy-match the Yunus story', () {
    final exact = prophetStoryIdsForDailyVerse(
      const QuranAddress(surah: 21, ayah: 87),
    );
    final adjacent = prophetStoryIdsForDailyVerse(
      const QuranAddress(surah: 21, ayah: 86),
    );

    expect(exact, contains('yunus'));
    expect(adjacent, isNot(contains('yunus')));
  });
}
