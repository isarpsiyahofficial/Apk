import 'package:flutter/material.dart';
import 'package:flutter_localizations/flutter_localizations.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:islami_hayat/core/storage/storage_boundaries.dart';
import 'package:islami_hayat/core/theme/app_theme.dart';
import 'package:islami_hayat/features/quran/data/quran_reading_progress_repository.dart';
import 'package:islami_hayat/features/quran/data/quran_search_repository.dart';
import 'package:islami_hayat/features/today/data/daily_verse_repository.dart';
import 'package:islami_hayat/l10n/app_localizations.dart';
import 'package:islami_hayat/shell/app_shell.dart';

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

final class _YunusStoryDailyVerseRepository implements DailyVerseDataSource {
  @override
  Future<DailyVerse> forDate({
    required DateTime date,
    required String languageCode,
  }) async {
    return DailyVerse(
      address: const QuranAddress(surah: 21, ayah: 87),
      arabic: 'وَذَا النُّونِ إِذ ذَّهَبَ مُغَاضِبًا',
      translation: languageCode == 'ar' ? null : 'Reviewed test fixture',
      surahDisplayName: languageCode == 'ar' ? 'الأنبياء' : 'Al-Anbiya',
    );
  }
}

Widget _app({required Future<bool> Function() guard}) {
  return MaterialApp(
    locale: const Locale('tr'),
    theme: AppTheme.light(),
    supportedLocales: AppLocalizations.supportedLocales,
    localizationsDelegates: const [
      AppLocalizations.delegate,
      GlobalMaterialLocalizations.delegate,
      GlobalWidgetsLocalizations.delegate,
      GlobalCupertinoLocalizations.delegate,
    ],
    home: AppShell(
      quranProgressRepository: QuranReadingProgressRepository(
        _MemoryPrivateStore(),
      ),
      dailyVerseRepository: _YunusStoryDailyVerseRepository(),
      todayNow: () => DateTime(2026, 9, 7),
      canEnterNewContent: guard,
    ),
  );
}

Future<Finder> _storyAction(WidgetTester tester) async {
  final action = find.byKey(
    const ValueKey('daily-verse-prophet-story-yunus'),
  );
  expect(action, findsOneWidget);
  await tester.ensureVisible(action);
  await tester.pumpAndSettle();
  return action;
}

void main() {
  testWidgets(
    'T0203 exact daily verse story action opens reviewed prophet story through AppShell',
    (tester) async {
      tester.view.physicalSize = const Size(390, 844);
      tester.view.devicePixelRatio = 1;
      addTearDown(tester.view.resetPhysicalSize);
      addTearDown(tester.view.resetDevicePixelRatio);

      var guardCalls = 0;
      await tester.pumpWidget(
        _app(
          guard: () async {
            guardCalls += 1;
            return true;
          },
        ),
      );
      await tester.pumpAndSettle();

      final action = await _storyAction(tester);
      await tester.tap(action);
      await tester.pumpAndSettle();

      expect(guardCalls, 1);
      expect(
        find.byKey(const ValueKey('prophet-story-quran-links-title')),
        findsOneWidget,
      );
      expect(find.text('Yunus'), findsWidgets);
      expect(tester.takeException(), isNull);
    },
  );

  testWidgets(
    'T0203 FREE offline gate blocks daily verse story navigation fail closed',
    (tester) async {
      tester.view.physicalSize = const Size(390, 844);
      tester.view.devicePixelRatio = 1;
      addTearDown(tester.view.resetPhysicalSize);
      addTearDown(tester.view.resetDevicePixelRatio);

      var guardCalls = 0;
      await tester.pumpWidget(
        _app(
          guard: () async {
            guardCalls += 1;
            return false;
          },
        ),
      );
      await tester.pumpAndSettle();

      final action = await _storyAction(tester);
      await tester.tap(action);
      await tester.pumpAndSettle();

      expect(guardCalls, 1);
      expect(
        find.byKey(const ValueKey('prophet-story-quran-links-title')),
        findsNothing,
      );
      expect(
        find.byKey(const ValueKey('daily-verse-prophet-story-yunus')),
        findsOneWidget,
      );
      expect(tester.takeException(), isNull);
    },
  );
}
