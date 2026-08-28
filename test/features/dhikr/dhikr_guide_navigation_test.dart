import 'package:flutter/material.dart';
import 'package:flutter_localizations/flutter_localizations.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:islami_hayat/core/content/content_governance.dart';
import 'package:islami_hayat/core/storage/storage_boundaries.dart';
import 'package:islami_hayat/features/dhikr/data/dhikr_counter_repository.dart';
import 'package:islami_hayat/features/dhikr/data/dhikr_guide_entry.dart';
import 'package:islami_hayat/features/dhikr/data/dhikr_history_repository.dart';
import 'package:islami_hayat/features/dhikr/presentation/dhikr_guide_page.dart';
import 'package:islami_hayat/l10n/app_localizations.dart';

final class _MemoryStore implements PrivateUserStore {
  final Map<String, String> values = {};

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

SourceReference _source() => const SourceReference(
      id: 'hadith:stable:33',
      title: 'Verified hadith source',
      sourceClass: ReligiousSourceClass.sahihHasanHadith,
      licenseId: 'source-license',
      locator: 'chapter 2, narration 7',
    );

DhikrGuideEntry _entry({
  ContentReviewStatus reviewStatus = ContentReviewStatus.published,
  int? recommendedCount = 33,
}) =>
    DhikrGuideEntry(
      id: 'dhikr:guide:1',
      arabic: 'سُبْحَانَ اللَّهِ',
      transliterationTr: 'Sübhânallah',
      transliterationEn: 'Subhanallah',
      meaning: const LocalizedReligiousText(
        tr: 'Allah eksikliklerden uzaktır.',
        en: 'Glory be to Allah.',
        ar: 'تنزيه الله عن كل نقص.',
      ),
      whyRecited: const LocalizedReligiousText(
        tr: 'Kaynağın bildirdiği bağlam için zikredilir.',
        en: 'Recited in the context supported by the cited source.',
        ar: 'يُذكر في السياق الذي يدل عليه المصدر المذكور.',
      ),
      sources: [_source()],
      reviewStatus: reviewStatus,
      version: 1,
      lastReviewedAt: DateTime.utc(2026, 8, 28),
      recommendedCount: recommendedCount,
      countSources: recommendedCount == null ? const [] : [_source()],
    );

Widget _app({
  required Locale locale,
  required List<DhikrGuideEntry> entries,
  double textScale = 1,
}) {
  final store = _MemoryStore();
  return MaterialApp(
    locale: locale,
    localizationsDelegates: const [
      AppLocalizations.delegate,
      GlobalMaterialLocalizations.delegate,
      GlobalWidgetsLocalizations.delegate,
      GlobalCupertinoLocalizations.delegate,
    ],
    supportedLocales: AppLocalizations.supportedLocales,
    builder: (context, child) => MediaQuery(
      data: MediaQuery.of(context).copyWith(
        textScaler: TextScaler.linear(textScale),
      ),
      child: child!,
    ),
    home: Scaffold(
      body: SafeArea(
        child: DhikrGuidePage(
          entries: entries,
          counterRepository: DhikrCounterRepository(store),
          historyRepository: DhikrHistoryRepository(store),
        ),
      ),
    ),
  );
}

void main() {
  testWidgets('one tap loads reviewed guide identity and sourced count into counter',
      (tester) async {
    await tester.pumpWidget(
      _app(locale: const Locale('tr'), entries: [_entry()]),
    );
    await tester.pumpAndSettle();

    expect(find.text('سُبْحَانَ اللَّهِ'), findsOneWidget);
    expect(find.text('Sübhânallah'), findsOneWidget);

    await tester.tap(find.byKey(const ValueKey('dhikr-start-dhikr:guide:1')));
    await tester.pumpAndSettle();

    expect(find.byKey(const ValueKey('guided-dhikr-arabic')), findsOneWidget);
    expect(find.byKey(const ValueKey('guided-dhikr-source-target')), findsOneWidget);
    expect(find.textContaining('Kaynaklı sayı: 33'), findsOneWidget);
    expect(find.byKey(const ValueKey('dhikr-counter-tap-area')), findsOneWidget);
  });

  testWidgets('guide without verified number starts counter without inventing target',
      (tester) async {
    await tester.pumpWidget(
      _app(
        locale: const Locale('en'),
        entries: [_entry(recommendedCount: null)],
      ),
    );
    await tester.pumpAndSettle();

    await tester.tap(find.byKey(const ValueKey('dhikr-start-dhikr:guide:1')));
    await tester.pumpAndSettle();

    expect(find.byKey(const ValueKey('guided-dhikr-no-target')), findsOneWidget);
    expect(find.textContaining('does not invent a target'), findsOneWidget);
  });

  testWidgets('unreviewed entries are not exposed as launchable religious content',
      (tester) async {
    await tester.pumpWidget(
      _app(
        locale: const Locale('en'),
        entries: [
          _entry(reviewStatus: ContentReviewStatus.religiousReview),
        ],
      ),
    );
    await tester.pumpAndSettle();

    expect(find.byKey(const ValueKey('dhikr-start-dhikr:guide:1')), findsNothing);
    expect(find.textContaining('Reviewed dhikr guide entries'), findsOneWidget);
  });

  testWidgets('Arabic RTL guide remains usable at 320x640 with 1.6x text',
      (tester) async {
    tester.view.physicalSize = const Size(320, 640);
    tester.view.devicePixelRatio = 1;
    addTearDown(tester.view.resetPhysicalSize);
    addTearDown(tester.view.resetDevicePixelRatio);

    await tester.pumpWidget(
      _app(
        locale: const Locale('ar'),
        entries: [_entry()],
        textScale: 1.6,
      ),
    );
    await tester.pumpAndSettle();

    expect(Directionality.of(tester.element(find.byType(DhikrGuidePage))), TextDirection.rtl);
    final start = find.byKey(const ValueKey('dhikr-start-dhikr:guide:1'));
    await tester.ensureVisible(start);
    await tester.tap(start);
    await tester.pumpAndSettle();

    expect(find.byKey(const ValueKey('guided-dhikr-arabic')), findsOneWidget);
    expect(find.byKey(const ValueKey('guided-dhikr-source-target')), findsOneWidget);
    expect(tester.takeException(), isNull);
  });

  testWidgets('guide renders on 1024x768 tablet without overflow', (tester) async {
    tester.view.physicalSize = const Size(1024, 768);
    tester.view.devicePixelRatio = 1;
    addTearDown(tester.view.resetPhysicalSize);
    addTearDown(tester.view.resetDevicePixelRatio);

    await tester.pumpWidget(
      _app(locale: const Locale('en'), entries: [_entry()]),
    );
    await tester.pumpAndSettle();

    expect(find.byKey(const ValueKey('dhikr-start-dhikr:guide:1')), findsOneWidget);
    expect(tester.takeException(), isNull);
  });
}
