import 'package:flutter/material.dart';
import 'package:flutter_localizations/flutter_localizations.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:islami_hayat/core/storage/storage_boundaries.dart';
import 'package:islami_hayat/core/theme/app_theme.dart';
import 'package:islami_hayat/features/quran/data/quran_reader_repository.dart';
import 'package:islami_hayat/features/quran/data/quran_reading_progress_repository.dart';
import 'package:islami_hayat/features/quran/data/quran_reflection_note_repository.dart';
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

final class _EmptyVerseState implements QuranVerseUserStateDataSource {
  @override
  Future<QuranVerseUserState> load() async => const QuranVerseUserState.empty();
  @override
  Future<QuranVerseUserState> toggleBookmark({
    required int surah,
    required int ayah,
  }) async => const QuranVerseUserState.empty();
  @override
  Future<QuranVerseUserState> toggleFavorite({
    required int surah,
    required int ayah,
  }) async => const QuranVerseUserState.empty();
}

final class _NoteFixture implements QuranReflectionNoteDataSource {
  final Map<String, String> notes = <String, String>{};
  bool failWrites = false;

  @override
  Future<Map<String, String>> loadNotes() async => Map.unmodifiable(notes);

  @override
  Future<String?> loadNote({required int surah, required int ayah}) async =>
      notes[quranVerseUserDataId(surah: surah, ayah: ayah)];

  @override
  Future<void> saveNote({
    required int surah,
    required int ayah,
    required String text,
  }) async {
    if (failWrites) throw StateError('private storage unavailable');
    final id = quranVerseUserDataId(surah: surah, ayah: ayah);
    if (text.trim().isEmpty) {
      notes.remove(id);
    } else {
      notes[id] = text;
    }
  }

  @override
  Future<void> deleteNote({required int surah, required int ayah}) async {
    if (failWrites) throw StateError('private storage unavailable');
    notes.remove(quranVerseUserDataId(surah: surah, ayah: ayah));
  }
}

Future<void> _pumpReader(
  WidgetTester tester,
  _NoteFixture notes, {
  Locale locale = const Locale('tr'),
}) async {
  await tester.pumpWidget(
    MaterialApp(
      locale: locale,
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
          verseUserStateRepository: _EmptyVerseState(),
          reflectionNoteRepository: notes,
        ),
      ),
    ),
  );
  for (var i = 0; i < 40; i++) {
    if (find.byKey(const ValueKey('quran-note-1-1')).evaluate().isNotEmpty) {
      return;
    }
    await tester.pump(const Duration(milliseconds: 25));
  }
  throw TestFailure('Quran note action did not render');
}

void main() {
  testWidgets('reflection note can be added, edited and deleted privately', (
    tester,
  ) async {
    final notes = _NoteFixture();
    await _pumpReader(tester, notes);

    final noteButton = find.byKey(const ValueKey('quran-note-1-1'));
    await tester.tap(noteButton);
    await tester.pumpAndSettle();
    expect(find.text('Tefekkür notu'), findsOneWidget);

    final field = find.byKey(const ValueKey('quran-reflection-note-field'));
    await tester.enterText(field, 'Kişisel tefekkür');
    await tester.tap(find.byKey(const ValueKey('quran-reflection-note-save')));
    await tester.pumpAndSettle();
    expect(notes.notes['quran:1:1'], 'Kişisel tefekkür');
    expect(find.byIcon(Icons.sticky_note_2_rounded), findsOneWidget);

    await tester.tap(noteButton);
    await tester.pumpAndSettle();
    expect(find.text('Tefekkür notunu düzenle'), findsOneWidget);
    expect(find.text('Kişisel tefekkür'), findsOneWidget);
    await tester.tap(find.byKey(const ValueKey('quran-reflection-note-delete')));
    await tester.pumpAndSettle();
    expect(notes.notes, isEmpty);
    expect(find.byIcon(Icons.note_add_outlined), findsOneWidget);
    expect(tester.takeException(), isNull);
  });

  testWidgets('note storage failure does not replace or crash Quran content', (
    tester,
  ) async {
    final notes = _NoteFixture()..failWrites = true;
    await _pumpReader(tester, notes);

    await tester.tap(find.byKey(const ValueKey('quran-note-1-1')));
    await tester.pumpAndSettle();
    await tester.enterText(
      find.byKey(const ValueKey('quran-reflection-note-field')),
      'Kaydedilemeyecek not',
    );
    await tester.tap(find.byKey(const ValueKey('quran-reflection-note-save')));
    await tester.pumpAndSettle();

    expect(find.text('1:1'), findsOneWidget);
    expect(find.textContaining('بِسْمِ اللَّهِ'), findsOneWidget);
    expect(find.textContaining('Not kaydedilemedi'), findsOneWidget);
    expect(notes.notes, isEmpty);
    expect(tester.takeException(), isNull);
  });

  testWidgets('Arabic reflection dialog follows RTL direction', (tester) async {
    final notes = _NoteFixture();
    await _pumpReader(tester, notes, locale: const Locale('ar'));

    await tester.tap(find.byKey(const ValueKey('quran-note-1-1')));
    await tester.pumpAndSettle();
    final field = find.byKey(const ValueKey('quran-reflection-note-field'));
    expect(field, findsOneWidget);
    expect(Directionality.of(tester.element(field)), TextDirection.rtl);
    expect(find.text('ملاحظة تدبّر'), findsOneWidget);
  });
}
