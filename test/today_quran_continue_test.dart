import 'package:flutter/material.dart';
import 'package:flutter_localizations/flutter_localizations.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:islami_hayat/core/storage/storage_boundaries.dart';
import 'package:islami_hayat/core/theme/app_theme.dart';
import 'package:islami_hayat/features/quran/data/quran_reading_progress_repository.dart';
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

Widget _app({
  required Locale locale,
  required QuranReadingProgressRepository repository,
  VoidCallback? onContinue,
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
        quranProgressRepository: repository,
        onContinueQuran: onContinue,
      ),
    ),
  );
}

void main() {
  testWidgets('continue card stays hidden until a Quran position is saved', (
    tester,
  ) async {
    final repository = QuranReadingProgressRepository(_MemoryPrivateStore());

    await tester.pumpWidget(
      _app(locale: const Locale('tr'), repository: repository),
    );
    await tester.pumpAndSettle();

    expect(find.byKey(const ValueKey('continue-quran-card')), findsNothing);
  });

  testWidgets('saved Quran position appears and opens continue action', (
    tester,
  ) async {
    final repository = QuranReadingProgressRepository(_MemoryPrivateStore());
    await repository.save(
      const QuranReadingProgress(surah: 18, ayah: 10, quranScale: 1.2),
    );
    var opened = false;

    await tester.pumpWidget(
      _app(
        locale: const Locale('tr'),
        repository: repository,
        onContinue: () => opened = true,
      ),
    );
    await tester.pumpAndSettle();

    expect(find.byKey(const ValueKey('continue-quran-card')), findsOneWidget);
    expect(find.text('Kur’an’a Devam Et'), findsOneWidget);
    expect(find.text('Sure 18, Ayet 10'), findsOneWidget);

    await tester.ensureVisible(find.byKey(const ValueKey('continue-quran-card')));
    await tester.tap(find.byKey(const ValueKey('continue-quran-card')));
    await tester.pump();
    expect(opened, isTrue);
  });

  testWidgets('Arabic continue card is RTL and localized', (tester) async {
    final repository = QuranReadingProgressRepository(_MemoryPrivateStore());
    await repository.save(
      const QuranReadingProgress(surah: 2, ayah: 255, quranScale: 1),
    );

    await tester.pumpWidget(
      _app(locale: const Locale('ar'), repository: repository),
    );
    await tester.pumpAndSettle();

    final card = find.byKey(const ValueKey('continue-quran-card'));
    expect(card, findsOneWidget);
    expect(find.text('متابعة قراءة القرآن'), findsOneWidget);
    expect(find.text('السورة 2، الآية 255'), findsOneWidget);
    expect(Directionality.of(tester.element(card)), TextDirection.rtl);
  });
}
