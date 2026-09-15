import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:islami_hayat/core/storage/storage_boundaries.dart';
import 'package:islami_hayat/features/profile/presentation/privacy_controls_page_t0303_t0304.dart';
import 'package:islami_hayat/l10n/app_localizations.dart';

Widget _app(_MemoryPrivateStore store, {Locale locale = const Locale('tr')}) {
  return MaterialApp(
    locale: locale,
    localizationsDelegates: AppLocalizations.localizationsDelegates,
    supportedLocales: AppLocalizations.supportedLocales,
    home: PrivacyControlsPageT0303T0304(store: store),
  );
}

void main() {
  testWidgets('question history is visibly opt-in off and can be enabled', (tester) async {
    final store = _MemoryPrivateStore();
    await tester.pumpWidget(_app(store));
    await tester.pumpAndSettle();

    expect(find.text('Soru geçmişini kaydet'), findsOneWidget);
    var tile = tester.widget<SwitchListTile>(find.byType(SwitchListTile));
    expect(tile.value, isFalse);

    await tester.tap(find.text('Soru geçmişini kaydet'));
    await tester.pumpAndSettle();

    tile = tester.widget<SwitchListTile>(find.byType(SwitchListTile));
    expect(tile.value, isTrue);
    expect(store.values['privacy.questionHistory.enabled.v1'], 'true');
  });

  testWidgets('reset confirmation clears the full private namespace', (tester) async {
    final store = _MemoryPrivateStore()
      ..values['privacy.questionHistory.enabled.v1'] = 'true'
      ..values['private.note'] = 'sensitive';
    await tester.pumpWidget(_app(store));
    await tester.pumpAndSettle();

    await tester.tap(find.text('Tüm yerel kişisel verileri sıfırla'));
    await tester.pumpAndSettle();
    expect(find.textContaining('kalıcı olarak siler'), findsOneWidget);

    await tester.tap(find.text('Yerel verileri sıfırla'));
    await tester.pumpAndSettle();

    expect(store.values, isEmpty);
    expect(store.clearCalls, 1);
    expect(find.text('Yerel kişisel veriler sıfırlandı.'), findsOneWidget);
  });

  testWidgets('Arabic privacy page is RTL and survives large text on narrow phone', (tester) async {
    tester.view.physicalSize = const Size(360, 800);
    tester.view.devicePixelRatio = 1;
    addTearDown(tester.view.resetPhysicalSize);
    addTearDown(tester.view.resetDevicePixelRatio);

    final store = _MemoryPrivateStore();
    await tester.pumpWidget(
      MediaQuery(
        data: const MediaQueryData(textScaler: TextScaler.linear(1.6)),
        child: _app(store, locale: const Locale('ar')),
      ),
    );
    await tester.pumpAndSettle();

    expect(Directionality.of(tester.element(find.byType(ListView))), TextDirection.rtl);
    expect(find.text('حفظ سجل الأسئلة'), findsOneWidget);
    expect(tester.takeException(), isNull);
  });
}

final class _MemoryPrivateStore implements PrivateUserStore {
  final Map<String, String> values = <String, String>{};
  int clearCalls = 0;

  @override
  StorageDomain get domain => StorageDomain.privateUserData;

  @override
  Future<void> clear() async {
    clearCalls += 1;
    values.clear();
  }

  @override
  Future<void> delete(String key) async => values.remove(key);

  @override
  Future<String?> read(String key) async => values[key];

  @override
  Future<void> write(String key, String value) async => values[key] = value;
}
