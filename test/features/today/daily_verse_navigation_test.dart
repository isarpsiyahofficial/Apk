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

final class _FixedDailyVerseRepository implements DailyVerseDataSource {
  @override
  Future<DailyVerse> forDate({
    required DateTime date,
    required String languageCode,
  }) async {
    return DailyVerse(
      address: const QuranAddress(surah: 2, ayah: 286),
      arabic: 'نَصٌّ عَرَبِيٌّ مُخْتَبَرٌ',
      translation: languageCode == 'ar' ? null : 'Verified translation fixture',
      surahDisplayName: languageCode == 'ar' ? 'البقرة' : 'Al-Baqara',
    );
  }
}

void main() {
  testWidgets('daily verse stores exact position and opens Quran tab', (
    tester,
  ) async {
    final progressRepository = QuranReadingProgressRepository(
      _MemoryPrivateStore(),
    );

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
        home: AppShell(
          quranProgressRepository: progressRepository,
          dailyVerseRepository: _FixedDailyVerseRepository(),
          todayNow: () => DateTime(2026, 8, 28),
        ),
      ),
    );
    await tester.pumpAndSettle();

    final dailyCard = find.byKey(const ValueKey('daily-verse-card'));
    expect(dailyCard, findsOneWidget);
    await tester.tap(dailyCard);
    await tester.pumpAndSettle();

    final saved = await progressRepository.loadSaved();
    expect(saved, isNotNull);
    expect(saved!.surah, 2);
    expect(saved.ayah, 286);

    final quranDestination = tester.widget<NavigationDestination>(
      find.byKey(const ValueKey('nav-quran')),
    );
    expect(quranDestination.label, 'Kur’an');
    expect(find.byKey(const ValueKey('daily-verse-card')), findsNothing);
  });
}
