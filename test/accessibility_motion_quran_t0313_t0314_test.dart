import 'package:flutter/material.dart';
import 'package:flutter_localizations/flutter_localizations.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:islami_hayat/core/accessibility/app_motion.dart';
import 'package:islami_hayat/core/storage/storage_boundaries.dart';
import 'package:islami_hayat/core/theme/app_theme.dart';
import 'package:islami_hayat/features/quran/data/quran_reader_repository.dart';
import 'package:islami_hayat/features/quran/data/quran_reading_progress_repository.dart';
import 'package:islami_hayat/features/quran/data/quran_verse_user_state_repository.dart';
import 'package:islami_hayat/features/quran/presentation/quran_reader_page.dart';
import 'package:islami_hayat/l10n/app_localizations.dart';

const _arabicFixture = 'بِسْمِ اللَّهِ الرَّحْمَٰنِ الرَّحِيمِ';

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

final class _ArabicFixtureQuran implements QuranReaderDataSource {
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
        arabic: _arabicFixture,
        translation: 'Accessibility fixture translation',
      ),
    ],
  );
}

Future<void> _pumpUntilFound(WidgetTester tester, Finder finder) async {
  for (var i = 0; i < 40; i++) {
    if (finder.evaluate().isNotEmpty) return;
    await tester.pump(const Duration(milliseconds: 25));
  }
  throw TestFailure('Timed out waiting for Quran accessibility fixture');
}

Future<void> _pumpReader(
  WidgetTester tester, {
  required _MemoryPrivateStore store,
  required double systemTextScale,
}) async {
  tester.view.physicalSize = const Size(320, 568);
  tester.view.devicePixelRatio = 1;
  tester.platformDispatcher.textScaleFactorTestValue = systemTextScale;

  await tester.pumpWidget(
    MaterialApp(
      debugShowCheckedModeBanner: false,
      locale: const Locale('ar'),
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
            repository: _ArabicFixtureQuran(),
            progressRepository: QuranReadingProgressRepository(store),
            verseUserStateRepository: _EmptyVerseState(),
          ),
        ),
      ),
    ),
  );

  await _pumpUntilFound(
    tester,
    find.byWidgetPredicate(
      (widget) => widget is SelectableText && widget.data == _arabicFixture,
    ),
  );
}

void main() {
  tearDown(() {});

  testWidgets('T0313 reduced motion maps duration to zero', (tester) async {
    Duration? effective;
    await tester.pumpWidget(
      MaterialApp(
        home: MediaQuery(
          data: const MediaQueryData(disableAnimations: true),
          child: Builder(
            builder: (context) {
              effective = AppMotion.effectiveDuration(
                context,
                normal: const Duration(milliseconds: 300),
              );
              return const SizedBox();
            },
          ),
        ),
      ),
    );

    expect(effective, Duration.zero);
  });

  testWidgets('T0313 normal motion retains requested duration', (tester) async {
    Duration? effective;
    await tester.pumpWidget(
      MaterialApp(
        home: MediaQuery(
          data: const MediaQueryData(disableAnimations: false),
          child: Builder(
            builder: (context) {
              effective = AppMotion.effectiveDuration(
                context,
                normal: const Duration(milliseconds: 300),
              );
              return const SizedBox();
            },
          ),
        ),
      ),
    );

    expect(effective, const Duration(milliseconds: 300));
  });

  testWidgets('T0313 reduced motion removes Material route movement', (
    tester,
  ) async {
    await tester.pumpWidget(
      MaterialApp(
        theme: AppTheme.light(),
        home: MediaQuery(
          data: const MediaQueryData(disableAnimations: true),
          child: Builder(
            builder: (context) {
              final transitionBuilder = Theme.of(context)
                  .pageTransitionsTheme
                  .builders[TargetPlatform.android]!;
              const child = SizedBox(key: ValueKey('reduced-motion-child'));
              return transitionBuilder.buildTransitions<void>(
                MaterialPageRoute<void>(builder: (_) => child),
                context,
                const AlwaysStoppedAnimation<double>(0.5),
                const AlwaysStoppedAnimation<double>(0),
                child,
              );
            },
          ),
        ),
      ),
    );

    expect(find.byKey(const ValueKey('reduced-motion-child')), findsOneWidget);
    expect(find.byType(ScaleTransition), findsNothing);
    expect(find.byType(FadeTransition), findsNothing);
    expect(tester.takeException(), isNull);
  });

  test('T0313 every Flutter target uses the motion-aware route builder', () {
    final builders = AppTheme.light().pageTransitionsTheme.builders;
    for (final platform in TargetPlatform.values) {
      expect(
        builders[platform],
        isA<AppPageTransitionsBuilder>(),
        reason: 'missing reduced-motion route policy for $platform',
      );
    }
  });

  testWidgets(
    'T0314 320px Arabic diacritics survive 2.0x system and 1.6x Quran scale',
    (tester) async {
      final store = _MemoryPrivateStore();
      final repository = QuranReadingProgressRepository(store);
      await repository.save(
        const QuranReadingProgress(surah: 1, ayah: 1, quranScale: 1.6),
      );

      addTearDown(tester.view.resetPhysicalSize);
      addTearDown(tester.view.resetDevicePixelRatio);
      addTearDown(tester.platformDispatcher.clearTextScaleFactorTestValue);

      await _pumpReader(tester, store: store, systemTextScale: 2);
      final arabic = find.byWidgetPredicate(
        (widget) => widget is SelectableText && widget.data == _arabicFixture,
      );
      await tester.ensureVisible(arabic);
      await tester.pump();

      final widget = tester.widget<SelectableText>(arabic);
      expect(widget.textAlign, TextAlign.right);
      expect(widget.style?.height, greaterThanOrEqualTo(1.9));
      expect(widget.style?.fontSize, closeTo(38.4, 0.01));

      final rect = tester.getRect(arabic);
      expect(rect.left, greaterThanOrEqualTo(0));
      expect(rect.right, lessThanOrEqualTo(320));
      expect(tester.takeException(), isNull);
    },
  );

  testWidgets('T0314 Quran scale remains independent of system font scale', (
    tester,
  ) async {
    final store = _MemoryPrivateStore();
    final repository = QuranReadingProgressRepository(store);
    await repository.save(
      const QuranReadingProgress(surah: 1, ayah: 1, quranScale: 1.4),
    );

    addTearDown(tester.view.resetPhysicalSize);
    addTearDown(tester.view.resetDevicePixelRatio);
    addTearDown(tester.platformDispatcher.clearTextScaleFactorTestValue);

    await _pumpReader(tester, store: store, systemTextScale: 1);
    final arabic = find.byWidgetPredicate(
      (widget) => widget is SelectableText && widget.data == _arabicFixture,
    );
    final atOne = tester.widget<SelectableText>(arabic).style?.fontSize;

    tester.platformDispatcher.textScaleFactorTestValue = 2;
    await tester.pump();
    final atTwo = tester.widget<SelectableText>(arabic).style?.fontSize;

    expect(atOne, closeTo(33.6, 0.01));
    expect(atTwo, closeTo(33.6, 0.01));
    expect((await repository.load()).quranScale, closeTo(1.4, 0.001));
    expect(tester.takeException(), isNull);
  });

  testWidgets('T0314 corrupt Quran font persistence fails closed to default', (
    tester,
  ) async {
    final store = _MemoryPrivateStore();
    store.values[QuranReadingProgressRepository.storageKey] =
        '{"schemaVersion":1,"surah":1,"ayah":1,"quranScale":9}';

    addTearDown(tester.view.resetPhysicalSize);
    addTearDown(tester.view.resetDevicePixelRatio);
    addTearDown(tester.platformDispatcher.clearTextScaleFactorTestValue);

    await _pumpReader(tester, store: store, systemTextScale: 1);
    final arabic = find.byWidgetPredicate(
      (widget) => widget is SelectableText && widget.data == _arabicFixture,
    );
    final widget = tester.widget<SelectableText>(arabic);

    expect(widget.style?.fontSize, closeTo(24, 0.01));
    expect(
      store.values.containsKey(QuranReadingProgressRepository.storageKey),
      isFalse,
    );
    expect(tester.takeException(), isNull);
  });
}
