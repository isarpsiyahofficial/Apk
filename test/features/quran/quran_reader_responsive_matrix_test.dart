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

final class _EmptyVerseUserStateDataSource
    implements QuranVerseUserStateDataSource {
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

final class _ResponsiveFixtureSource implements QuranReaderDataSource {
  @override
  List<QuranChapterSummary> get chapterSummaries => const [
    QuranChapterSummary(surah: 1, ayahCount: 3),
  ];

  @override
  Future<QuranReaderChapter> loadChapter({
    required String languageCode,
    int surah = 1,
    int startAyah = 1,
  }) async {
    if (surah != 1) throw RangeError.range(surah, 1, 1, 'surah');
    if (startAyah < 1 || startAyah > 3) {
      throw RangeError.range(startAyah, 1, 3, 'startAyah');
    }

    final translation = switch (languageCode) {
      'tr' => 'Doğrulanmış Türkçe meal test metni, uzun ekranlarda da doğal biçimde satır kırmalıdır.',
      'en' => 'Verified English translation fixture that must wrap naturally across responsive layouts.',
      'ar' => null,
      _ => throw UnsupportedError('Unsupported fixture locale: $languageCode'),
    };

    const arabic = [
      'بِسْمِ اللَّهِ الرَّحْمَٰنِ الرَّحِيمِ',
      'الْحَمْدُ لِلَّهِ رَبِّ الْعَالَمِينَ',
      'الرَّحْمَٰنِ الرَّحِيمِ',
    ];

    return QuranReaderChapter(
      surah: 1,
      verses: [
        for (var index = startAyah - 1; index < arabic.length; index++)
          QuranReaderVerse(
            surah: 1,
            ayah: index + 1,
            arabic: arabic[index],
            translation: translation,
          ),
      ],
    );
  }
}

Future<void> _pumpReader(
  WidgetTester tester, {
  required Locale locale,
  required Size size,
  double textScale = 1,
}) async {
  tester.view.physicalSize = size;
  tester.view.devicePixelRatio = 1;

  final progressRepository = QuranReadingProgressRepository(_MemoryPrivateStore());

  await tester.pumpWidget(
    MaterialApp(
      debugShowCheckedModeBanner: false,
      locale: locale,
      theme: AppTheme.light(),
      supportedLocales: AppLocalizations.supportedLocales,
      localizationsDelegates: const [
        AppLocalizations.delegate,
        GlobalMaterialLocalizations.delegate,
        GlobalWidgetsLocalizations.delegate,
        GlobalCupertinoLocalizations.delegate,
      ],
      builder: (context, child) => MediaQuery(
        data: MediaQuery.of(context).copyWith(
          textScaler: TextScaler.linear(textScale),
        ),
        child: child!,
      ),
      home: Scaffold(
        body: SafeArea(
          child: QuranReaderPage(
            repository: _ResponsiveFixtureSource(),
            progressRepository: progressRepository,
            verseUserStateRepository: _EmptyVerseUserStateDataSource(),
          ),
        ),
      ),
    ),
  );

  for (var i = 0; i < 40; i++) {
    if (find.byKey(const ValueKey('quran-surah-selector')).evaluate().isNotEmpty) {
      break;
    }
    await tester.pump(const Duration(milliseconds: 25));
  }
  expect(find.byKey(const ValueKey('quran-surah-selector')), findsOneWidget);
}

void main() {
  testWidgets('English reader remains usable on 4:3 tablet', (tester) async {
    addTearDown(tester.view.resetPhysicalSize);
    addTearDown(tester.view.resetDevicePixelRatio);

    await _pumpReader(
      tester,
      locale: const Locale('en'),
      size: const Size(1024, 768),
    );

    expect(find.byKey(const ValueKey('quran-juz-selector')), findsOneWidget);
    expect(find.byKey(const ValueKey('quran-font-larger')), findsOneWidget);
    expect(find.textContaining('Verified English translation'), findsWidgets);
    expect(tester.takeException(), isNull);
  });

  testWidgets('Turkish reader survives BlueStacks-like 1280x720 viewport', (
    tester,
  ) async {
    addTearDown(tester.view.resetPhysicalSize);
    addTearDown(tester.view.resetDevicePixelRatio);

    await _pumpReader(
      tester,
      locale: const Locale('tr'),
      size: const Size(1280, 720),
    );

    expect(find.byKey(const ValueKey('quran-surah-selector')), findsOneWidget);
    expect(find.byKey(const ValueKey('quran-open-sources')), findsOneWidget);
    expect(find.textContaining('Doğrulanmış Türkçe meal'), findsWidgets);
    expect(tester.takeException(), isNull);
  });

  testWidgets('Arabic RTL reader tolerates 1.6x text on narrow phone', (
    tester,
  ) async {
    addTearDown(tester.view.resetPhysicalSize);
    addTearDown(tester.view.resetDevicePixelRatio);

    await _pumpReader(
      tester,
      locale: const Locale('ar'),
      size: const Size(360, 800),
      textScale: 1.6,
    );

    final sourceButton = find.byKey(const ValueKey('quran-open-sources'));
    expect(sourceButton, findsOneWidget);
    expect(find.byKey(const ValueKey('quran-font-smaller')), findsOneWidget);
    expect(find.byKey(const ValueKey('quran-font-larger')), findsOneWidget);
    expect(Directionality.of(tester.element(sourceButton)), TextDirection.rtl);
    expect(tester.takeException(), isNull);

    await tester.drag(find.byType(CustomScrollView), const Offset(0, -600));
    await tester.pumpAndSettle();

    final renderedArabic = tester
        .widgetList<SelectableText>(find.byType(SelectableText))
        .map((widget) => widget.data)
        .whereType<String>()
        .toList(growable: false);
    expect(
      renderedArabic,
      contains('بِسْمِ اللَّهِ الرَّحْمَٰنِ الرَّحِيمِ'),
    );
    expect(tester.takeException(), isNull);
  });

  testWidgets('Arabic RTL reader remains stable on tablet landscape', (
    tester,
  ) async {
    addTearDown(tester.view.resetPhysicalSize);
    addTearDown(tester.view.resetDevicePixelRatio);

    await _pumpReader(
      tester,
      locale: const Locale('ar'),
      size: const Size(1280, 800),
    );

    final selector = find.byKey(const ValueKey('quran-surah-selector'));
    expect(selector, findsOneWidget);
    expect(Directionality.of(tester.element(selector)), TextDirection.rtl);
    expect(find.text('الجزء'), findsOneWidget);
    expect(tester.takeException(), isNull);
  });
}
