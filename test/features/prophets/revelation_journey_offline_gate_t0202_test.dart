import 'package:flutter/material.dart';
import 'package:flutter_localizations/flutter_localizations.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:islami_hayat/core/storage/storage_boundaries.dart';
import 'package:islami_hayat/core/theme/app_theme.dart';
import 'package:islami_hayat/features/quran/data/quran_reading_progress_repository.dart';
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

void main() {
  testWidgets(
    'Discover journey prophet Quran target reuses AppShell FREE reachability gate',
    (tester) async {
      tester.view.physicalSize = const Size(390, 844);
      tester.view.devicePixelRatio = 1;
      addTearDown(tester.view.resetPhysicalSize);
      addTearDown(tester.view.resetDevicePixelRatio);

      final progressRepository = QuranReadingProgressRepository(
        _MemoryPrivateStore(),
      );
      var guardCalls = 0;

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
            canEnterNewContent: () async {
              guardCalls += 1;
              return guardCalls == 1;
            },
          ),
        ),
      );
      await tester.pumpAndSettle();

      await tester.tap(find.byKey(const ValueKey('nav-discover')));
      await tester.pumpAndSettle();
      expect(guardCalls, 1);

      await tester.tap(
        find.byKey(const ValueKey('discover-revelation-journey')),
      );
      await tester.pumpAndSettle();

      await tester.tap(find.byKey(const ValueKey('journey-filter-abrahamic')));
      await tester.pumpAndSettle();
      await tester.tap(find.byKey(const ValueKey('journey-prophet-ibrahim')));
      await tester.pumpAndSettle();

      expect(find.text('Doğrulanmış Kur’an referansları'), findsOneWidget);
      await tester.tap(find.byType(ListTile).first);
      await tester.pumpAndSettle();

      expect(guardCalls, 2);
      expect(await progressRepository.loadSaved(), isNull);
      expect(find.text('Doğrulanmış Kur’an referansları'), findsOneWidget);
      expect(tester.takeException(), isNull);
    },
  );
}
