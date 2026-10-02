import 'package:flutter/material.dart';
import 'package:flutter_localizations/flutter_localizations.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:islami_hayat/core/storage/storage_boundaries.dart';
import 'package:islami_hayat/core/theme/app_theme.dart';
import 'package:islami_hayat/features/quran/data/quran_reader_repository.dart';
import 'package:islami_hayat/features/quran/data/quran_reading_progress_repository.dart';
import 'package:islami_hayat/features/quran/data/quran_verse_user_state_repository.dart';
import 'package:islami_hayat/features/quran/presentation/quran_reader_page.dart';
import 'package:islami_hayat/l10n/app_localizations.dart';

final class _MemoryPrivateStore implements PrivateUserStore {
  final Map<String, String> values = <String, String>{};

  @override
  StorageDomain get domain => StorageDomain.privateUserData;

  @override
  Future<void> clear() async => values.clear();

  @override
  Future<void> delete(String key) async => values.remove(key);

  @override
  Future<String?> read(String key) async => values[key];

  @override
  Future<void> write(String key, String value) async => values[key] = value;
}

final class _ReaderFixture implements QuranReaderDataSource {
  @override
  List<QuranChapterSummary> get chapterSummaries => const [
    QuranChapterSummary(surah: 1, ayahCount: 1),
  ];

  @override
  Future<QuranReaderChapter> loadChapter({
    required String languageCode,
    int surah = 1,
    int startAyah = 1,
  }) async => const QuranReaderChapter(
    surah: 1,
    verses: [
      QuranReaderVerse(
        surah: 1,
        ayah: 1,
        arabic: 'بِسْمِ اللَّهِ الرَّحْمَٰنِ الرَّحِيمِ',
        translation: 'Doğrulanmış test meali',
      ),
    ],
  );
}

final class _VerseStateFixture implements QuranVerseUserStateDataSource {
  QuranVerseUserState state = const QuranVerseUserState.empty();

  @override
  Future<QuranVerseUserState> load() async => state;

  @override
  Future<QuranVerseUserState> toggleBookmark({
    required int surah,
    required int ayah,
  }) async {
    final id = quranVerseUserDataId(surah: surah, ayah: ayah);
    final next = Set<String>.of(state.bookmarkVerseIds);
    if (!next.remove(id)) next.add(id);
    state = QuranVerseUserState(
      favoriteVerseIds: state.favoriteVerseIds,
      bookmarkVerseIds: Set<String>.unmodifiable(next),
    );
    return state;
  }

  @override
  Future<QuranVerseUserState> toggleFavorite({
    required int surah,
    required int ayah,
  }) async {
    final id = quranVerseUserDataId(surah: surah, ayah: ayah);
    final next = Set<String>.of(state.favoriteVerseIds);
    if (!next.remove(id)) next.add(id);
    state = QuranVerseUserState(
      favoriteVerseIds: Set<String>.unmodifiable(next),
      bookmarkVerseIds: state.bookmarkVerseIds,
    );
    return state;
  }
}

Future<void> _pumpReader(
  WidgetTester tester,
  _VerseStateFixture verseState,
) async {
  await tester.pumpWidget(
    MaterialApp(
      locale: const Locale('tr'),
      theme: AppTheme.light(),
      supportedLocales: AppLocalizations.supportedLocales,
      localizationsDelegates: const [
        AppLocalizations.delegate,
        GlobalMaterialLocalizations.delegate,
        GlobalWidgetsLocalizations.delegate,
        GlobalCupertinoLocalizations.delegate,
      ],
      home: Scaffold(
        body: QuranReaderPage(
          repository: _ReaderFixture(),
          progressRepository: QuranReadingProgressRepository(
            _MemoryPrivateStore(),
          ),
          verseUserStateRepository: verseState,
        ),
      ),
    ),
  );
  for (var i = 0; i < 20; i++) {
    if (find.byKey(const ValueKey('quran-favorite-1-1')).evaluate().isNotEmpty) {
      break;
    }
    await tester.pump(const Duration(milliseconds: 25));
  }
}

void main() {
  testWidgets('favorite and bookmark are independent Quran verse actions', (
    tester,
  ) async {
    final verseState = _VerseStateFixture();
    await _pumpReader(tester, verseState);

    final favorite = find.byKey(const ValueKey('quran-favorite-1-1'));
    final bookmark = find.byKey(const ValueKey('quran-bookmark-1-1'));
    final continueFromHere = find.byKey(
      const ValueKey('quran-save-position-1-1'),
    );

    expect(favorite, findsOneWidget);
    expect(bookmark, findsOneWidget);
    expect(continueFromHere, findsOneWidget);

    await tester.tap(favorite);
    await tester.pumpAndSettle();
    expect(verseState.state.isFavorite(surah: 1, ayah: 1), isTrue);
    expect(verseState.state.isBookmarked(surah: 1, ayah: 1), isFalse);
    expect(find.byIcon(Icons.favorite_rounded), findsOneWidget);

    await tester.tap(bookmark);
    await tester.pumpAndSettle();
    expect(verseState.state.isFavorite(surah: 1, ayah: 1), isTrue);
    expect(verseState.state.isBookmarked(surah: 1, ayah: 1), isTrue);
    expect(find.byIcon(Icons.bookmark_rounded), findsOneWidget);
    expect(tester.takeException(), isNull);
  });
}
