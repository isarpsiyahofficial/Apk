import 'package:flutter/material.dart';
import 'package:flutter_localizations/flutter_localizations.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:islami_hayat/core/storage/storage_boundaries.dart';
import 'package:islami_hayat/core/theme/app_theme.dart';
import 'package:islami_hayat/features/quran/data/quran_reader_repository.dart';
import 'package:islami_hayat/features/quran/data/quran_reading_progress_repository.dart';
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

final class _FixtureQuranReaderDataSource implements QuranReaderDataSource {
  @override
  List<QuranChapterSummary> get chapterSummaries => const [
    QuranChapterSummary(surah: 1, ayahCount: 2),
  ];

  @override
  Future<QuranReaderChapter> loadChapter({
    required String languageCode,
    int surah = 1,
  }) async {
    return QuranReaderChapter(
      surah: surah,
      verses: const [
        QuranReaderVerse(
          surah: 1,
          ayah: 1,
          arabic: 'بِسْمِ اللَّهِ الرَّحْمَٰنِ الرَّحِيمِ',
          translation: 'Doğrulanmış arayüz test metni',
        ),
        QuranReaderVerse(
          surah: 1,
          ayah: 2,
          arabic: 'الْحَمْدُ لِلَّهِ رَبِّ الْعَالَمِينَ',
          translation: 'İkinci doğrulanmış arayüz test metni',
        ),
      ],
    );
  }
}

Future<void> _pumpUntilFound(
  WidgetTester tester,
  Finder finder, {
  int maxPumps = 40,
}) async {
  for (var i = 0; i < maxPumps; i++) {
    if (finder.evaluate().isNotEmpty) return;
    await tester.pump(const Duration(milliseconds: 25));
  }
  throw TestFailure('Timed out waiting for expected widget');
}

Future<QuranReadingProgressRepository> _openQuran(
  WidgetTester tester, {
  required Locale locale,
}) async {
  final progressRepository = QuranReadingProgressRepository(
    _MemoryPrivateStore(),
  );
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
      home: Scaffold(
        body: SafeArea(
          child: QuranReaderPage(
            repository: _FixtureQuranReaderDataSource(),
            progressRepository: progressRepository,
          ),
        ),
      ),
    ),
  );
  await _pumpUntilFound(
    tester,
    find.byKey(const ValueKey('quran-surah-selector')),
  );
  return progressRepository;
}

void main() {
  testWidgets('Quran reader persists font and explicit last-read ayah', (
    tester,
  ) async {
    final progressRepository = await _openQuran(
      tester,
      locale: const Locale('tr'),
    );

    expect(find.byKey(const ValueKey('quran-surah-selector')), findsOneWidget);
    expect(find.byKey(const ValueKey('quran-juz-selector')), findsOneWidget);
    expect(find.byKey(const ValueKey('quran-font-smaller')), findsOneWidget);
    expect(find.byKey(const ValueKey('quran-font-larger')), findsOneWidget);
    expect(find.byKey(const ValueKey('quran-open-sources')), findsOneWidget);
    expect(find.text('Cüz'), findsOneWidget);

    await tester.ensureVisible(find.byKey(const ValueKey('quran-font-larger')));
    await tester.tap(find.byKey(const ValueKey('quran-font-larger')));
    await tester.pump();

    final saveSecond = find.byKey(
      const ValueKey('quran-save-position-1-2'),
    );
    await tester.ensureVisible(saveSecond);
    await tester.tap(saveSecond);
    await tester.pump();

    final saved = await progressRepository.loadSaved();
    expect(saved, isNotNull);
    expect(saved!.surah, 1);
    expect(saved.ayah, 2);
    expect(saved.quranScale, closeTo(1.1, 0.001));
    expect(find.textContaining('Sure 1, Ayet 2'), findsOneWidget);
    expect(tester.takeException(), isNull);

    await tester.ensureVisible(find.byKey(const ValueKey('quran-open-sources')));
    await tester.tap(find.byKey(const ValueKey('quran-open-sources')));
    await _pumpUntilFound(tester, find.text('Kaynaklar ve Lisanslar'));
    expect(find.text('Kaynaklar ve Lisanslar'), findsWidgets);
    expect(find.textContaining('Tanzil Project'), findsWidgets);
  });

  testWidgets('Quran controls remain usable on narrow Arabic layout', (
    tester,
  ) async {
    tester.view.physicalSize = const Size(320, 568);
    tester.view.devicePixelRatio = 1;
    addTearDown(tester.view.resetPhysicalSize);
    addTearDown(tester.view.resetDevicePixelRatio);

    await _openQuran(tester, locale: const Locale('ar'));

    expect(find.byKey(const ValueKey('quran-surah-selector')), findsOneWidget);
    expect(find.byKey(const ValueKey('quran-juz-selector')), findsOneWidget);
    expect(find.byKey(const ValueKey('quran-font-smaller')), findsOneWidget);
    expect(find.byKey(const ValueKey('quran-font-larger')), findsOneWidget);
    expect(find.byKey(const ValueKey('quran-open-sources')), findsOneWidget);
    expect(find.text('الجزء'), findsOneWidget);
    expect(tester.takeException(), isNull);

    final context = tester.element(
      find.byKey(const ValueKey('quran-open-sources')),
    );
    expect(Directionality.of(context), TextDirection.rtl);
  });
}
