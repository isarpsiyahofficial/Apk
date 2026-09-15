import 'package:flutter/material.dart';
import 'package:flutter_localizations/flutter_localizations.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:islami_hayat/core/content/content_governance.dart';
import 'package:islami_hayat/core/storage/storage_boundaries.dart';
import 'package:islami_hayat/features/dhikr/data/dhikr_guide_entry.dart';
import 'package:islami_hayat/features/dhikr/data/dhikr_guide_preferences_repository.dart';
import 'package:islami_hayat/features/dhikr/presentation/dhikr_guide_preferences_view.dart';
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

SourceReference _source(
  ReligiousSourceClass sourceClass,
  String id,
) => SourceReference(
  id: id,
  title: 'Verified $id source',
  sourceClass: sourceClass,
  licenseId: 'license',
  locator: 'locator',
);

DhikrGuideEntry _entry({
  required String id,
  required ReligiousSourceClass countSourceClass,
  int count = 33,
}) => DhikrGuideEntry(
  id: id,
  arabic: 'سُبْحَانَ اللَّهِ',
  transliterationTr: 'Sübhânallah $id',
  transliterationEn: 'Subhanallah $id',
  meaning: const LocalizedReligiousText(
    tr: 'Anlam',
    en: 'Meaning',
    ar: 'المعنى',
  ),
  whyRecited: const LocalizedReligiousText(
    tr: 'Kaynak bağlamı.',
    en: 'Source context.',
    ar: 'سياق المصدر.',
  ),
  sources: [_source(ReligiousSourceClass.sahihHasanHadith, 'primary-$id')],
  reviewStatus: ContentReviewStatus.published,
  version: 1,
  lastReviewedAt: DateTime.utc(2026, 8, 28),
  recommendedCount: count,
  countSources: [_source(countSourceClass, 'count-$id')],
);

Widget _app({
  required Locale locale,
  required DhikrGuidePreferencesRepository repository,
  required List<DhikrGuideEntry> entries,
  double textScale = 1,
}) => MaterialApp(
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
      child: DhikrGuidePreferencesView(
        entries: entries,
        repository: repository,
      ),
    ),
  ),
);

void main() {
  test('preferences default to strong-source only and persist opt-ins', () async {
    final store = _MemoryStore();
    final repository = DhikrGuidePreferencesRepository(store);

    var state = await repository.load();
    expect(state.showTraditionalPractices, isFalse);
    expect(state.showEbcedHavasHistorical, isFalse);

    state = await repository.save(state.copyWith(showTraditionalPractices: true));
    expect(state.showTraditionalPractices, isTrue);
    expect((await repository.load()).showTraditionalPractices, isTrue);
    expect((await repository.load()).showEbcedHavasHistorical, isFalse);
  });

  test('corrupt or type-invalid local preference data fails closed', () async {
    final store = _MemoryStore();
    final repository = DhikrGuidePreferencesRepository(store);

    store.values['dhikr.guide.preferences.v1'] = '{broken';
    var state = await repository.load();
    expect(state.showTraditionalPractices, isFalse);
    expect(state.showEbcedHavasHistorical, isFalse);

    store.values['dhikr.guide.preferences.v1'] =
        '{"showTraditionalPractices":"yes","showEbcedHavasHistorical":1}';
    state = await repository.load();
    expect(state.showTraditionalPractices, isFalse);
    expect(state.showEbcedHavasHistorical, isFalse);
  });

  testWidgets('strong source is visible by default while traditional and ebced are hidden', (tester) async {
    final store = _MemoryStore();
    final entries = [
      _entry(id: 'strong', countSourceClass: ReligiousSourceClass.sahihHasanHadith),
      _entry(id: 'traditional', countSourceClass: ReligiousSourceClass.classicalTraditional),
      _entry(id: 'ebced', countSourceClass: ReligiousSourceClass.ebcedHavasTradition, count: 308),
    ];

    await tester.pumpWidget(_app(
      locale: const Locale('tr'),
      repository: DhikrGuidePreferencesRepository(store),
      entries: entries,
    ));
    await tester.pumpAndSettle();

    expect(find.textContaining('Sübhânallah strong'), findsOneWidget);
    expect(find.textContaining('Sübhânallah traditional'), findsNothing);
    expect(find.textContaining('Sübhânallah ebced'), findsNothing);
  });

  testWidgets('independent switches reveal traditional and ebced content', (tester) async {
    final store = _MemoryStore();
    final entries = [
      _entry(id: 'strong', countSourceClass: ReligiousSourceClass.sahihHasanHadith),
      _entry(id: 'traditional', countSourceClass: ReligiousSourceClass.classicalTraditional),
      _entry(id: 'ebced', countSourceClass: ReligiousSourceClass.ebcedHavasTradition, count: 308),
    ];

    await tester.pumpWidget(_app(
      locale: const Locale('en'),
      repository: DhikrGuidePreferencesRepository(store),
      entries: entries,
    ));
    await tester.pumpAndSettle();
    await tester.tap(find.byKey(const ValueKey('dhikr-content-preferences')));
    await tester.pumpAndSettle();

    await tester.tap(find.byKey(const ValueKey('show-traditional-practices')));
    await tester.pumpAndSettle();
    expect(find.textContaining('Subhanallah traditional'), findsOneWidget);
    expect(find.textContaining('Subhanallah ebced'), findsNothing);

    await tester.tap(find.byKey(const ValueKey('show-ebced-havas-historical')));
    await tester.pumpAndSettle();
    final restored = await DhikrGuidePreferencesRepository(store).load();
    expect(restored.showTraditionalPractices, isTrue);
    expect(restored.showEbcedHavasHistorical, isTrue);

    await tester.tap(find.byKey(const ValueKey('dhikr-content-preferences')));
    await tester.pumpAndSettle();
    await tester.drag(find.byType(ListView), const Offset(0, -500));
    await tester.pumpAndSettle();
    expect(find.textContaining('Subhanallah ebced'), findsOneWidget);
  });

  testWidgets('Arabic RTL settings remain usable at 320x640 and 1.6x font', (tester) async {
    tester.view.physicalSize = const Size(320, 640);
    tester.view.devicePixelRatio = 1;
    addTearDown(tester.view.resetPhysicalSize);
    addTearDown(tester.view.resetDevicePixelRatio);

    await tester.pumpWidget(_app(
      locale: const Locale('ar'),
      repository: DhikrGuidePreferencesRepository(_MemoryStore()),
      entries: [
        _entry(id: 'strong', countSourceClass: ReligiousSourceClass.sahihHasanHadith),
      ],
      textScale: 1.6,
    ));
    await tester.pumpAndSettle();

    expect(
      Directionality.of(
        tester.element(find.byType(DhikrGuidePreferencesView)),
      ),
      TextDirection.rtl,
    );
    await tester.tap(find.byKey(const ValueKey('dhikr-content-preferences')));
    await tester.pumpAndSettle();
    expect(find.text('إظهار الممارسات التقليدية'), findsOneWidget);
    expect(find.text('إظهار المعلومات التاريخية للأبجد/الخواص'), findsOneWidget);
    expect(tester.takeException(), isNull);
  });
}
