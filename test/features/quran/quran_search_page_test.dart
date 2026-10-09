import 'package:flutter/material.dart';
import 'package:flutter_localizations/flutter_localizations.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:islami_hayat/features/quran/data/quran_search_repository.dart';
import 'package:islami_hayat/features/quran/presentation/quran_search_page.dart';
import 'package:islami_hayat/l10n/app_localizations.dart';

void main() {
  testWidgets('searches selected locale and opens exact result', (tester) async {
    final repository = _FakeQuranSearchRepository();
    QuranSearchResult? opened;

    await tester.pumpWidget(
      _testApp(
        locale: const Locale('tr'),
        child: QuranSearchPage(
          repository: repository,
          onOpenVerse: (result) => opened = result,
        ),
      ),
    );

    await tester.enterText(
      find.byKey(const ValueKey('quran-search-field')),
      'Bakara',
    );
    await tester.tap(find.byKey(const ValueKey('quran-search-submit')));
    await tester.pumpAndSettle();

    expect(repository.lastLanguageCode, 'tr');
    expect(repository.lastQuery, 'Bakara');
    expect(find.text('Al-Baqara'), findsOneWidget);
    expect(find.byKey(const ValueKey('quran-search-result-2:255')), findsOneWidget);

    await tester.tap(find.byKey(const ValueKey('quran-search-result-2:255')));
    expect(opened?.surah, 2);
    expect(opened?.ayah, 255);
  });

  testWidgets('Arabic search stays RTL-safe on a 320px phone', (tester) async {
    tester.view.devicePixelRatio = 1;
    tester.view.physicalSize = const Size(320, 700);
    addTearDown(tester.view.resetPhysicalSize);
    addTearDown(tester.view.resetDevicePixelRatio);

    final repository = _FakeQuranSearchRepository();
    await tester.pumpWidget(
      _testApp(
        locale: const Locale('ar'),
        child: QuranSearchPage(
          repository: repository,
          onOpenVerse: (_) {},
        ),
      ),
    );

    await tester.enterText(
      find.byKey(const ValueKey('quran-search-field')),
      'البقرة',
    );
    await tester.testTextInput.receiveAction(TextInputAction.search);
    await tester.pumpAndSettle();

    final resultCard = find.byKey(const ValueKey('quran-search-result-2:255'));
    expect(repository.lastLanguageCode, 'ar');
    expect(tester.takeException(), isNull);
    expect(resultCard, findsOneWidget);
    expect(
      find.descendant(of: resultCard, matching: find.text('البقرة')),
      findsOneWidget,
    );
    expect(Directionality.of(tester.element(find.byType(QuranSearchPage))), TextDirection.rtl);
  });
}

Widget _testApp({required Locale locale, required Widget child}) {
  return MaterialApp(
    locale: locale,
    supportedLocales: AppLocalizations.supportedLocales,
    localizationsDelegates: const [
      AppLocalizations.delegate,
      GlobalMaterialLocalizations.delegate,
      GlobalWidgetsLocalizations.delegate,
      GlobalCupertinoLocalizations.delegate,
    ],
    home: Scaffold(body: SafeArea(child: child)),
  );
}

final class _FakeQuranSearchRepository implements QuranSearchDataSource {
  String? lastLanguageCode;
  String? lastQuery;

  @override
  QuranAddress? parseAddress(String input) =>
      input.trim() == '2:255' ? const QuranAddress(surah: 2, ayah: 255) : null;

  @override
  Future<List<QuranSearchResult>> search({
    required String languageCode,
    required String query,
    int limit = 50,
  }) async {
    lastLanguageCode = languageCode;
    lastQuery = query;
    return [
      QuranSearchResult(
        surah: 2,
        ayah: 255,
        arabic: 'اللَّهُ لَا إِلَٰهَ إِلَّا هُوَ',
        translation: languageCode == 'ar' ? null : 'Verified translation fixture',
        surahDisplayName: languageCode == 'ar' ? 'البقرة' : 'Al-Baqara',
      ),
    ];
  }
}
