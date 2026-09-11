import 'dart:async';

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

final class _BlockingPrivateUserStore implements PrivateUserStore {
  final Completer<String?> readCompleter = Completer<String?>();

  @override
  StorageDomain get domain => StorageDomain.privateUserData;

  @override
  Future<void> clear() async {}

  @override
  Future<void> delete(String key) async {}

  @override
  Future<String?> read(String key) => readCompleter.future;

  @override
  Future<void> write(String key, String value) async {}
}

final class _ThrowingPrivateUserStore implements PrivateUserStore {
  @override
  StorageDomain get domain => StorageDomain.privateUserData;

  @override
  Future<void> clear() async {}

  @override
  Future<void> delete(String key) async {}

  @override
  Future<String?> read(String key) async {
    throw StateError('fixture private-state read failure');
  }

  @override
  Future<void> write(String key, String value) async {}
}

SourceReference _source() => const SourceReference(
      id: 'quran-t0344-fixture',
      title: 'Quran T0344 fixture',
      sourceClass: ReligiousSourceClass.quran,
      licenseId: 'fixture-license',
    );

DuaContent _dua({
  required String id,
  required String tr,
  required String en,
  required String ar,
}) =>
    DuaContent(
      id: id,
      sourceStatus: DuaSourceStatus.quran,
      lengthClass: DuaLengthClass.short,
      categories: const <DuaCategory>{DuaCategory.morning},
      text: LocalizedReligiousText(tr: tr, en: en, ar: ar),
      reviewStatus: ContentReviewStatus.published,
      version: 1,
      lastReviewedAt: DateTime.utc(2026, 9, 11),
      sources: <SourceReference>[_source()],
    );

final _library = DuaLibraryRepository(<DuaContent>[
  _dua(
    id: 'localized-fixture',
    tr: 'Doğrulanmış yerel dua örneği',
    en: 'Verified local dua fixture',
    ar: 'دعاء محلي موثق للاختبار',
  ),
]);

Widget _app({
  required Locale locale,
  required PrivateUserStore store,
}) {
  return MaterialApp(
    locale: locale,
    supportedLocales: AppLocalizations.supportedLocales,
    localizationsDelegates: const <LocalizationsDelegate<dynamic>>[
      AppLocalizations.delegate,
      GlobalMaterialLocalizations.delegate,
      GlobalWidgetsLocalizations.delegate,
      GlobalCupertinoLocalizations.delegate,
    ],
    home: DuaLibraryPage(
      library: _library,
      userStateRepository: DuaUserStateRepository(store),
    ),
  );
}

void main() {
  const cases = <String, _LocaleCase>{
    'tr': _LocaleCase(
      locale: Locale('tr'),
      direction: TextDirection.ltr,
      title: 'Dualar',
      searchLabel: 'Dualarda ara',
      empty: 'Bu filtrelerde doğrulanmış dua bulunmuyor.',
      error:
          'Kişisel dua verileri okunamadı. Dini içerik değiştirilmedi.',
      fixtureText: 'Doğrulanmış yerel dua örneği',
    ),
    'en': _LocaleCase(
      locale: Locale('en'),
      direction: TextDirection.ltr,
      title: 'Duas',
      searchLabel: 'Search duas',
      empty: 'No verified dua matches these filters.',
      error:
          'Private dua data could not be read. Religious content was not changed.',
      fixtureText: 'Verified local dua fixture',
    ),
    'ar': _LocaleCase(
      locale: Locale('ar'),
      direction: TextDirection.rtl,
      title: 'الأدعية',
      searchLabel: 'البحث في الأدعية',
      empty: 'لا يوجد دعاء موثَّق يطابق هذه المرشحات.',
      error:
          'تعذّرت قراءة بيانات الأدعية الخاصة. لم يتغير المحتوى الديني.',
      fixtureText: 'دعاء محلي موثق للاختبار',
    ),
  };

  for (final entry in cases.entries) {
    testWidgets('${entry.key} dua happy path and empty state stay localized',
        (tester) async {
      final localeCase = entry.value;
      await tester.pumpWidget(
        _app(
          locale: localeCase.locale,
          store: _MemoryPrivateUserStore(),
        ),
      );
      await tester.pumpAndSettle();

      expect(find.byType(DuaLibraryPage), findsOneWidget);
      expect(find.text(localeCase.title), findsOneWidget);
      expect(find.text(localeCase.searchLabel), findsOneWidget);
      expect(find.text(localeCase.fixtureText), findsOneWidget);
      expect(
        Directionality.of(tester.element(find.byType(DuaLibraryPage))),
        localeCase.direction,
      );
      expect(tester.takeException(), isNull);

      await tester.enterText(
        find.byKey(const ValueKey('dua-search-field')),
        '__no_matching_dua__',
      );
      await tester.pump();

      expect(find.text(localeCase.empty), findsOneWidget);
      expect(find.text(localeCase.fixtureText), findsNothing);
      expect(tester.takeException(), isNull);
    });

    testWidgets('${entry.key} dua private-state error copy is localized',
        (tester) async {
      final localeCase = entry.value;
      await tester.pumpWidget(
        _app(
          locale: localeCase.locale,
          store: _ThrowingPrivateUserStore(),
        ),
      );
      await tester.pumpAndSettle();

      expect(find.byType(DuaLibraryPage), findsOneWidget);
      expect(find.text(localeCase.error), findsOneWidget);
      expect(
        Directionality.of(tester.element(find.byType(DuaLibraryPage))),
        localeCase.direction,
      );
      expect(tester.takeException(), isNull);
    });
  }

  testWidgets('Arabic dua loading state remains RTL and does not leak content',
      (tester) async {
    final store = _BlockingPrivateUserStore();
    await tester.pumpWidget(
      _app(locale: const Locale('ar'), store: store),
    );
    await tester.pump();

    expect(find.byType(DuaLibraryPage), findsOneWidget);
    expect(find.byType(CircularProgressIndicator), findsOneWidget);
    expect(find.byKey(const ValueKey('dua-search-field')), findsNothing);
    expect(
      Directionality.of(tester.element(find.byType(DuaLibraryPage))),
      TextDirection.rtl,
    );
    expect(tester.takeException(), isNull);

    store.readCompleter.complete(null);
    await tester.pumpAndSettle();
    expect(find.byType(CircularProgressIndicator), findsNothing);
    expect(find.byKey(const ValueKey('dua-search-field')), findsOneWidget);
    expect(tester.takeException(), isNull);
  });
}

final class _LocaleCase {
  const _LocaleCase({
    required this.locale,
    required this.direction,
    required this.title,
    required this.searchLabel,
    required this.empty,
    required this.error,
    required this.fixtureText,
  });

  final Locale locale;
  final TextDirection direction;
  final String title;
  final String searchLabel;
  final String empty;
  final String error;
  final String fixtureText;
}
