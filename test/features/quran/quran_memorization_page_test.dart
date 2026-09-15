import 'package:flutter/material.dart';
import 'package:flutter_localizations/flutter_localizations.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:islami_hayat/core/storage/storage_boundaries.dart';
import 'package:islami_hayat/core/theme/app_theme.dart';
import 'package:islami_hayat/features/quran/data/quran_reader_repository.dart';
import 'package:islami_hayat/features/quran/data/quran_reading_progress_repository.dart';
import 'package:islami_hayat/features/quran/presentation/quran_memorization_page.dart';
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

final class _FixtureQuranReader implements QuranReaderDataSource {
  @override
  List<QuranChapterSummary> get chapterSummaries => const [
    QuranChapterSummary(surah: 2, ayahCount: 286),
  ];

  @override
  Future<QuranReaderChapter> loadChapter({
    required String languageCode,
    int surah = 1,
    int startAyah = 1,
  }) async {
    expect(surah, 2);
    expect(startAyah, 255);
    return QuranReaderChapter(
      surah: 2,
      verses: [
        QuranReaderVerse(
          surah: 2,
          ayah: 255,
          arabic: 'اللَّهُ لَا إِلَٰهَ إِلَّا هُوَ',
          translation: languageCode == 'ar'
              ? null
              : 'Verified translation fixture',
        ),
      ],
    );
  }
}

Widget _app({
  required Locale locale,
  required QuranReadingProgressRepository progressRepository,
}) {
  return MaterialApp(
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
      body: QuranMemorizationPage(
        repository: _FixtureQuranReader(),
        progressRepository: progressRepository,
      ),
    ),
  );
}

void main() {
  testWidgets('memorization mode starts hidden and reveals only on user action', (
    tester,
  ) async {
    final progressRepository = QuranReadingProgressRepository(
      _MemoryPrivateStore(),
    );
    await progressRepository.save(
      const QuranReadingProgress(surah: 2, ayah: 255, quranScale: 1),
    );

    await tester.pumpWidget(
      _app(
        locale: const Locale('tr'),
        progressRepository: progressRepository,
      ),
    );
    await tester.pumpAndSettle();

    expect(find.byKey(const ValueKey('quran-memorize-position')), findsOneWidget);
    expect(find.text('Sure 2, Ayet 255'), findsOneWidget);
    expect(find.byKey(const ValueKey('quran-memorize-hidden')), findsOneWidget);
    expect(find.byKey(const ValueKey('quran-memorize-arabic')), findsNothing);
    expect(
      find.byKey(const ValueKey('quran-memorize-no-microphone')),
      findsOneWidget,
    );

    await tester.tap(find.byKey(const ValueKey('quran-memorize-toggle')));
    await tester.pumpAndSettle();

    expect(find.byKey(const ValueKey('quran-memorize-revealed')), findsOneWidget);
    expect(find.byKey(const ValueKey('quran-memorize-arabic')), findsOneWidget);
    expect(
      find.byKey(const ValueKey('quran-memorize-translation')),
      findsOneWidget,
    );

    await tester.tap(find.byKey(const ValueKey('quran-memorize-card')));
    await tester.pumpAndSettle();
    expect(find.byKey(const ValueKey('quran-memorize-hidden')), findsOneWidget);
    expect(find.byKey(const ValueKey('quran-memorize-arabic')), findsNothing);
  });

  testWidgets('Arabic memorization mode is RTL-safe on a narrow phone', (
    tester,
  ) async {
    tester.view.physicalSize = const Size(320, 700);
    tester.view.devicePixelRatio = 1;
    addTearDown(tester.view.resetPhysicalSize);
    addTearDown(tester.view.resetDevicePixelRatio);

    final progressRepository = QuranReadingProgressRepository(
      _MemoryPrivateStore(),
    );
    await progressRepository.save(
      const QuranReadingProgress(surah: 2, ayah: 255, quranScale: 1),
    );

    await tester.pumpWidget(
      _app(
        locale: const Locale('ar'),
        progressRepository: progressRepository,
      ),
    );
    await tester.pumpAndSettle();

    expect(Directionality.of(tester.element(find.byType(QuranMemorizationPage))), TextDirection.rtl);
    expect(find.byKey(const ValueKey('quran-memorize-hidden')), findsOneWidget);
    expect(tester.takeException(), isNull);

    await tester.tap(find.byKey(const ValueKey('quran-memorize-toggle')));
    await tester.pumpAndSettle();

    expect(find.byKey(const ValueKey('quran-memorize-arabic')), findsOneWidget);
    expect(find.byKey(const ValueKey('quran-memorize-translation')), findsNothing);
    expect(tester.takeException(), isNull);
  });
}
