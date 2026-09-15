import 'package:flutter/material.dart';
import 'package:flutter_localizations/flutter_localizations.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:islami_hayat/core/content/content_governance.dart';
import 'package:islami_hayat/core/storage/storage_boundaries.dart';
import 'package:islami_hayat/features/dua/data/dua_content.dart';
import 'package:islami_hayat/features/dua/data/dua_library_repository.dart';
import 'package:islami_hayat/features/dua/data/dua_user_state_repository.dart';
import 'package:islami_hayat/features/dua/presentation/dua_library_page.dart';
import 'package:islami_hayat/l10n/app_localizations.dart';

final class _MemoryPrivateUserStore implements PrivateUserStore {
  final Map<String, String> data = <String, String>{};

  @override
  StorageDomain get domain => StorageDomain.privateUserData;

  @override
  Future<void> clear() async => data.clear();

  @override
  Future<void> delete(String key) async => data.remove(key);

  @override
  Future<String?> read(String key) async => data[key];

  @override
  Future<void> write(String key, String value) async => data[key] = value;
}

SourceReference _source() => const SourceReference(
      id: 'quran-fixture',
      title: 'Quran fixture',
      sourceClass: ReligiousSourceClass.quran,
      licenseId: 'fixture-license',
    );

DuaContent _dua({
  required String id,
  required String tr,
  required String en,
  required String ar,
  required Set<DuaCategory> categories,
}) => DuaContent(
      id: id,
      sourceStatus: DuaSourceStatus.quran,
      lengthClass: DuaLengthClass.short,
      categories: categories,
      text: LocalizedReligiousText(tr: tr, en: en, ar: ar),
      reviewStatus: ContentReviewStatus.published,
      version: 1,
      lastReviewedAt: DateTime.utc(2026, 8, 28),
      sources: [_source()],
    );

Widget _app({required Locale locale, required DuaUserStateRepository state}) {
  final library = DuaLibraryRepository([
    _dua(
      id: 'morning',
      tr: 'Sabah için doğrulanmış test duası',
      en: 'Verified morning test dua',
      ar: 'دعاء صباحي موثق للاختبار',
      categories: const {DuaCategory.morning},
    ),
    _dua(
      id: 'travel',
      tr: 'Yolculuk için doğrulanmış test duası',
      en: 'Verified travel test dua',
      ar: 'دعاء سفر موثق للاختبار',
      categories: const {DuaCategory.travel},
    ),
  ]);

  return MaterialApp(
    locale: locale,
    supportedLocales: AppLocalizations.supportedLocales,
    localizationsDelegates: const [
      AppLocalizations.delegate,
      GlobalMaterialLocalizations.delegate,
      GlobalWidgetsLocalizations.delegate,
      GlobalCupertinoLocalizations.delegate,
    ],
    home: DuaLibraryPage(library: library, userStateRepository: state),
  );
}

void main() {
  testWidgets('library renders search category and collection controls', (tester) async {
    final state = DuaUserStateRepository(_MemoryPrivateUserStore());
    await tester.pumpWidget(_app(locale: const Locale('tr'), state: state));
    await tester.pumpAndSettle();

    expect(find.byKey(const ValueKey('dua-search-field')), findsOneWidget);
    expect(find.byKey(const ValueKey('dua-category-filter')), findsOneWidget);
    expect(find.byKey(const ValueKey('dua-view-filter')), findsOneWidget);
    expect(find.text('Tümü'), findsOneWidget);
    expect(find.text('Favoriler'), findsOneWidget);
    expect(find.text('Geçmiş'), findsOneWidget);
    expect(find.byKey(const ValueKey('dua-morning')), findsOneWidget);
    expect(find.byKey(const ValueKey('dua-travel')), findsOneWidget);
    expect(tester.takeException(), isNull);
  });

  testWidgets('search field filters the verified local library', (tester) async {
    final state = DuaUserStateRepository(_MemoryPrivateUserStore());
    await tester.pumpWidget(_app(locale: const Locale('en'), state: state));
    await tester.pumpAndSettle();

    await tester.enterText(find.byKey(const ValueKey('dua-search-field')), 'travel');
    await tester.pump();

    expect(find.byKey(const ValueKey('dua-travel')), findsOneWidget);
    expect(find.byKey(const ValueKey('dua-morning')), findsNothing);
    expect(tester.takeException(), isNull);
  });

  testWidgets('Arabic narrow screen stays RTL and usable', (tester) async {
    tester.view.physicalSize = const Size(320, 720);
    tester.view.devicePixelRatio = 1;
    addTearDown(tester.view.resetPhysicalSize);
    addTearDown(tester.view.resetDevicePixelRatio);

    final state = DuaUserStateRepository(_MemoryPrivateUserStore());
    await tester.pumpWidget(_app(locale: const Locale('ar'), state: state));
    await tester.pumpAndSettle();

    expect(
      Directionality.of(tester.element(find.byType(DuaLibraryPage))),
      TextDirection.rtl,
    );
    expect(find.byKey(const ValueKey('dua-search-field')), findsOneWidget);
    expect(find.byKey(const ValueKey('dua-view-filter')), findsOneWidget);
    expect(tester.takeException(), isNull);
  });
}
