import 'package:flutter/material.dart';
import 'package:flutter_localizations/flutter_localizations.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:islami_hayat/core/storage/storage_boundaries.dart';
import 'package:islami_hayat/core/theme/app_theme.dart';
import 'package:islami_hayat/features/quran/data/quran_reading_progress_repository.dart';
import 'package:islami_hayat/features/quran/data/quran_search_repository.dart';
import 'package:islami_hayat/features/quran/data/quran_verse_user_state_repository.dart';
import 'package:islami_hayat/features/today/data/daily_verse_repository.dart';
import 'package:islami_hayat/features/today/domain/daily_prophet_learning.dart';
import 'package:islami_hayat/features/today/presentation/today_page.dart';
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

final class _FakeDailyVerseRepository implements DailyVerseDataSource {
  @override
  Future<DailyVerse> forDate({
    required DateTime date,
    required String languageCode,
  }) async {
    return const DailyVerse(
      address: QuranAddress(surah: 2, ayah: 286),
      arabic: 'لَا يُكَلِّفُ ٱللَّهُ نَفْسًا إِلَّا وُسْعَهَا',
      translation: 'Verified fixture',
      surahDisplayName: 'Al-Baqara',
    );
  }
}

final class _MemoryVerseStateRepository
    implements QuranVerseUserStateDataSource {
  @override
  Future<QuranVerseUserState> load() async =>
      const QuranVerseUserState.empty();

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

Widget _app({
  required Locale locale,
  required DateTime date,
  required ValueChanged<String> onOpenProphetStory,
  TextScaler textScaler = TextScaler.noScaling,
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
    builder: (context, child) {
      final media = MediaQuery.of(context);
      return MediaQuery(
        data: media.copyWith(textScaler: textScaler),
        child: child!,
      );
    },
    home: Scaffold(
      body: TodayPage(
        quranProgressRepository: QuranReadingProgressRepository(
          _MemoryPrivateStore(),
        ),
        verseUserStateRepository: _MemoryVerseStateRepository(),
        dailyVerseRepository: _FakeDailyVerseRepository(),
        now: () => date,
        onOpenProphetStory: onOpenProphetStory,
      ),
    ),
  );
}

void main() {
  testWidgets('T0204 Today flow renders source-backed suggestion and dispatches canonical id', (
    tester,
  ) async {
    final date = DateTime(2026, 8, 30);
    final expected = dailyProphetLearningForDate(date)!;
    String? opened;

    await tester.pumpWidget(
      _app(
        locale: const Locale('tr'),
        date: date,
        onOpenProphetStory: (id) => opened = id,
      ),
    );
    await tester.pumpAndSettle();

    expect(
      find.byKey(const ValueKey('daily-prophet-learning-card')),
      findsOneWidget,
    );
    expect(find.text('Bugün Ne Öğrenelim?'), findsOneWidget);
    expect(
      find.byKey(const ValueKey('daily-prophet-learning-source')),
      findsOneWidget,
    );

    await tester.ensureVisible(
      find.byKey(const ValueKey('daily-prophet-learning-open')),
    );
    await tester.tap(
      find.byKey(const ValueKey('daily-prophet-learning-open')),
    );
    await tester.pump();

    expect(opened, expected.prophetId);
  });

  testWidgets('T0204 Arabic Today integration remains RTL-safe at 320px and 1.6x text', (
    tester,
  ) async {
    tester.view.physicalSize = const Size(320, 760);
    tester.view.devicePixelRatio = 1;
    addTearDown(tester.view.resetPhysicalSize);
    addTearDown(tester.view.resetDevicePixelRatio);

    await tester.pumpWidget(
      _app(
        locale: const Locale('ar'),
        date: DateTime(2026, 8, 30),
        onOpenProphetStory: (_) {},
        textScaler: const TextScaler.linear(1.6),
      ),
    );
    await tester.pumpAndSettle();

    await tester.ensureVisible(
      find.byKey(const ValueKey('daily-prophet-learning-card')),
    );
    await tester.pump();

    expect(find.text('ماذا نتعلّم اليوم؟'), findsOneWidget);
    expect(find.textContaining('المصدر:'), findsOneWidget);
    expect(tester.takeException(), isNull);
  });
}