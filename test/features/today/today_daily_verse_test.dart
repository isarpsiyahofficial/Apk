import 'package:flutter/material.dart';
import 'package:flutter_localizations/flutter_localizations.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:islami_hayat/core/storage/storage_boundaries.dart';
import 'package:islami_hayat/core/theme/app_theme.dart';
import 'package:islami_hayat/features/quran/data/quran_reading_progress_repository.dart';
import 'package:islami_hayat/features/quran/data/quran_search_repository.dart';
import 'package:islami_hayat/features/quran/data/quran_verse_user_state_repository.dart';
import 'package:islami_hayat/features/today/data/daily_verse_repository.dart';
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
  _FakeDailyVerseRepository({this.fail = false});

  final bool fail;

  @override
  Future<DailyVerse> forDate({
    required DateTime date,
    required String languageCode,
  }) async {
    if (fail) throw StateError('unverified source');
    return DailyVerse(
      address: const QuranAddress(surah: 2, ayah: 286),
      arabic: 'نَصٌّ عَرَبِيٌّ مُخْتَبَرٌ',
      translation: languageCode == 'ar' ? null : 'Verified translation fixture',
      surahDisplayName: languageCode == 'ar' ? 'البقرة' : 'Al-Baqara',
    );
  }
}

final class _MemoryVerseStateRepository
    implements QuranVerseUserStateDataSource {
  QuranVerseUserState _state = const QuranVerseUserState.empty();

  @override
  Future<QuranVerseUserState> load() async => _state;

  @override
  Future<QuranVerseUserState> toggleBookmark({
    required int surah,
    required int ayah,
  }) async => _state;

  @override
  Future<QuranVerseUserState> toggleFavorite({
    required int surah,
    required int ayah,
  }) async {
    final id = quranVerseUserDataId(surah: surah, ayah: ayah);
    final favorites = Set<String>.of(_state.favoriteVerseIds);
    if (!favorites.remove(id)) favorites.add(id);
    _state = QuranVerseUserState(
      favoriteVerseIds: Set<String>.unmodifiable(favorites),
      bookmarkVerseIds: _state.bookmarkVerseIds,
    );
    return _state;
  }
}

Widget _app({
  required Locale locale,
  required DailyVerseDataSource dailyVerseRepository,
  QuranVerseUserStateDataSource? verseUserStateRepository,
  Future<void> Function(QuranAddress address)? onOpenDailyVerse,
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
      body: TodayPage(
        quranProgressRepository: QuranReadingProgressRepository(
          _MemoryPrivateStore(),
        ),
        verseUserStateRepository:
            verseUserStateRepository ?? _MemoryVerseStateRepository(),
        dailyVerseRepository: dailyVerseRepository,
        now: () => DateTime(2026, 8, 28, 21, 15),
        onOpenDailyVerse: onOpenDailyVerse,
      ),
    ),
  );
}

void main() {
  testWidgets('daily verse renders Arabic, meal and locked source label', (
    tester,
  ) async {
    await tester.pumpWidget(
      _app(
        locale: const Locale('tr'),
        dailyVerseRepository: _FakeDailyVerseRepository(),
      ),
    );
    await tester.pumpAndSettle();

    expect(find.byKey(const ValueKey('daily-verse-card')), findsOneWidget);
    expect(find.byKey(const ValueKey('daily-verse-arabic')), findsOneWidget);
    expect(find.text('Verified translation fixture'), findsOneWidget);
    expect(find.text('Al-Baqara · 2:286'), findsOneWidget);
  });

  testWidgets('daily verse tap passes the exact canonical address', (
    tester,
  ) async {
    QuranAddress? opened;
    await tester.pumpWidget(
      _app(
        locale: const Locale('tr'),
        dailyVerseRepository: _FakeDailyVerseRepository(),
        onOpenDailyVerse: (address) async => opened = address,
      ),
    );
    await tester.pumpAndSettle();

    await tester.tap(find.byKey(const ValueKey('daily-verse-card')));
    await tester.pump();

    expect(opened, isNotNull);
    expect(opened!.key, '2:286');
  });

  testWidgets('daily verse favorite toggles exact canonical verse locally', (
    tester,
  ) async {
    final verseState = _MemoryVerseStateRepository();
    await tester.pumpWidget(
      _app(
        locale: const Locale('tr'),
        dailyVerseRepository: _FakeDailyVerseRepository(),
        verseUserStateRepository: verseState,
      ),
    );
    await tester.pumpAndSettle();

    final favoriteButton = find.byKey(const ValueKey('daily-verse-favorite'));
    expect(favoriteButton, findsOneWidget);
    expect(find.byIcon(Icons.favorite_border), findsOneWidget);

    await tester.tap(favoriteButton);
    await tester.pumpAndSettle();

    expect(find.byIcon(Icons.favorite), findsOneWidget);
    final saved = await verseState.load();
    expect(saved.isFavorite(surah: 2, ayah: 286), isTrue);

    await tester.tap(favoriteButton);
    await tester.pumpAndSettle();

    expect(find.byIcon(Icons.favorite_border), findsOneWidget);
    expect((await verseState.load()).isFavorite(surah: 2, ayah: 286), isFalse);
  });

  testWidgets('Arabic daily verse is RTL-safe on a 320px phone and has no fake meal', (
    tester,
  ) async {
    tester.view.physicalSize = const Size(320, 760);
    tester.view.devicePixelRatio = 1;
    addTearDown(tester.view.resetPhysicalSize);
    addTearDown(tester.view.resetDevicePixelRatio);

    await tester.pumpWidget(
      _app(
        locale: const Locale('ar'),
        dailyVerseRepository: _FakeDailyVerseRepository(),
      ),
    );
    await tester.pumpAndSettle();

    final card = find.byKey(const ValueKey('daily-verse-card'));
    expect(card, findsOneWidget);
    expect(Directionality.of(tester.element(card)), TextDirection.rtl);
    expect(find.text('البقرة · 2:286'), findsOneWidget);
    expect(find.text('Verified translation fixture'), findsNothing);
    expect(tester.takeException(), isNull);
  });

  testWidgets('daily verse source failure fails closed instead of rendering unverified text', (
    tester,
  ) async {
    await tester.pumpWidget(
      _app(
        locale: const Locale('en'),
        dailyVerseRepository: _FakeDailyVerseRepository(fail: true),
      ),
    );
    await tester.pumpAndSettle();

    expect(find.byKey(const ValueKey('daily-verse-arabic')), findsNothing);
    expect(find.text('Verified translation fixture'), findsNothing);
  });
}
