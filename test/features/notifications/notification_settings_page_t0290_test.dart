import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:islami_hayat/features/notifications/domain/notification_preferences.dart';
import 'package:islami_hayat/features/notifications/presentation/notification_settings_page.dart';
import 'package:islami_hayat/l10n/app_localizations.dart';

final class _FakeStore implements NotificationPreferencesStore {
  _FakeStore({
    this.value = const NotificationPreferences(),
    this.failLoad = false,
    this.failSave = false,
  });

  NotificationPreferences value;
  bool failLoad;
  bool failSave;
  int saveCount = 0;

  @override
  Future<NotificationPreferences> load() async {
    if (failLoad) throw StateError('load failed');
    return value;
  }

  @override
  Future<void> save(NotificationPreferences preferences) async {
    saveCount += 1;
    if (failSave) throw StateError('save failed');
    value = preferences;
  }
}

Widget _app({
  Locale locale = const Locale('tr'),
  NotificationPreferences initial = const NotificationPreferences(),
  NotificationPreferencesStore? store,
  ValueChanged<NotificationPreferences>? onChanged,
  Future<bool> Function(NotificationCategory category)? onEnableRequested,
}) {
  return MaterialApp(
    locale: locale,
    localizationsDelegates: AppLocalizations.localizationsDelegates,
    supportedLocales: AppLocalizations.supportedLocales,
    home: NotificationSettingsPage(
      initialPreferences: initial,
      store: store,
      onChanged: onChanged,
      onEnableRequested: onEnableRequested,
    ),
  );
}

void main() {
  testWidgets('T0290 defaults every notification category to opt-in off', (
    tester,
  ) async {
    await tester.pumpWidget(_app());

    final switches = tester.widgetList<SwitchListTile>(
      find.byType(SwitchListTile),
    );
    expect(switches, hasLength(4));
    expect(switches.every((tile) => !tile.value), isTrue);
    expect(find.text('Günün Ayeti'), findsOneWidget);
    expect(find.text('Günün Duası'), findsOneWidget);
    expect(find.text('Zikir Hatırlatması'), findsOneWidget);
    expect(find.text('Dini Günler'), findsOneWidget);
    expect(find.textContaining('ezan veya namaz vakti'), findsOneWidget);
  });

  testWidgets('T0290 categories change independently', (tester) async {
    NotificationPreferences? latest;
    await tester.pumpWidget(_app(onChanged: (value) => latest = value));

    await tester.tap(find.text('Günün Ayeti'));
    await tester.pump();

    expect(latest, isNotNull);
    expect(latest!.dailyVerse, isTrue);
    expect(latest!.dailyDua, isFalse);
    expect(latest!.dhikrReminder, isFalse);
    expect(latest!.religiousDay, isFalse);

    await tester.tap(find.text('Dini Günler'));
    await tester.pump();

    expect(latest!.dailyVerse, isTrue);
    expect(latest!.religiousDay, isTrue);
    expect(latest!.dailyDua, isFalse);
    expect(latest!.dhikrReminder, isFalse);
  });

  testWidgets('T0290 secure-store contract persists explicit choices', (
    tester,
  ) async {
    final store = _FakeStore(
      value: const NotificationPreferences(dailyDua: true),
    );
    await tester.pumpWidget(_app(store: store));
    await tester.pumpAndSettle();

    var values = tester
        .widgetList<SwitchListTile>(find.byType(SwitchListTile))
        .map((tile) => tile.value)
        .toList();
    expect(values, [false, true, false, false]);

    await tester.tap(find.text('Günün Ayeti'));
    await tester.pumpAndSettle();
    expect(store.saveCount, 1);
    expect(store.value.dailyVerse, isTrue);
    expect(store.value.dailyDua, isTrue);

    await tester.pumpWidget(_app(store: store));
    await tester.pumpAndSettle();
    values = tester
        .widgetList<SwitchListTile>(find.byType(SwitchListTile))
        .map((tile) => tile.value)
        .toList();
    expect(values, [true, true, false, false]);
  });

  testWidgets('T0291 denied runtime permission keeps opt-in off and unsaved', (
    tester,
  ) async {
    final store = _FakeStore();
    var permissionRequests = 0;
    await tester.pumpWidget(
      _app(
        store: store,
        onEnableRequested: (category) async {
          permissionRequests += 1;
          expect(category, NotificationCategory.dailyVerse);
          return false;
        },
      ),
    );
    await tester.pumpAndSettle();

    await tester.tap(find.text('Günün Ayeti'));
    await tester.pumpAndSettle();

    final firstSwitch = tester.widget<SwitchListTile>(
      find.byType(SwitchListTile).first,
    );
    expect(firstSwitch.value, isFalse);
    expect(permissionRequests, 1);
    expect(store.saveCount, 0);
    expect(
      find.byKey(const Key('notification-permission-error')),
      findsOneWidget,
    );
  });

  testWidgets('T0291 granted runtime permission persists explicit opt-in', (
    tester,
  ) async {
    final store = _FakeStore();
    await tester.pumpWidget(
      _app(
        store: store,
        onEnableRequested: (_) async => true,
      ),
    );
    await tester.pumpAndSettle();

    await tester.tap(find.text('Günün Ayeti'));
    await tester.pumpAndSettle();

    expect(store.saveCount, 1);
    expect(store.value.dailyVerse, isTrue);
    expect(
      find.byKey(const Key('notification-permission-error')),
      findsNothing,
    );
  });

  testWidgets('T0290 load failure fails closed to all categories off', (
    tester,
  ) async {
    await tester.pumpWidget(
      _app(
        initial: const NotificationPreferences(
          dailyVerse: true,
          dailyDua: true,
          dhikrReminder: true,
          religiousDay: true,
        ),
        store: _FakeStore(failLoad: true),
      ),
    );
    await tester.pumpAndSettle();

    final values = tester
        .widgetList<SwitchListTile>(find.byType(SwitchListTile))
        .map((tile) => tile.value)
        .toList();
    expect(values, [false, false, false, false]);
    expect(find.byKey(const Key('notification-storage-error')), findsOneWidget);
  });

  testWidgets('T0290 save failure reverts unsaved opt-in', (tester) async {
    final store = _FakeStore(failSave: true);
    await tester.pumpWidget(_app(store: store));
    await tester.pumpAndSettle();

    await tester.tap(find.text('Günün Ayeti'));
    await tester.pumpAndSettle();

    final firstSwitch = tester.widget<SwitchListTile>(
      find.byType(SwitchListTile).first,
    );
    expect(firstSwitch.value, isFalse);
    expect(store.saveCount, 1);
    expect(find.byKey(const Key('notification-storage-error')), findsOneWidget);
  });

  testWidgets(
    'T0290 Arabic is RTL and religious-day source condition is visible',
    (tester) async {
      tester.view.physicalSize = const Size(360, 800);
      tester.view.devicePixelRatio = 1;
      addTearDown(tester.view.resetPhysicalSize);
      addTearDown(tester.view.resetDevicePixelRatio);

      await tester.pumpWidget(_app(locale: const Locale('ar')));

      expect(
        Directionality.of(tester.element(find.text('الإشعارات'))),
        TextDirection.rtl,
      );
      expect(find.textContaining('مصدر موثوق'), findsOneWidget);
      expect(tester.takeException(), isNull);
    },
  );

  testWidgets('T0290 large font remains scrollable without overflow', (
    tester,
  ) async {
    tester.view.physicalSize = const Size(320, 640);
    tester.view.devicePixelRatio = 1;
    tester.platformDispatcher.textScaleFactorTestValue = 1.6;
    addTearDown(tester.view.resetPhysicalSize);
    addTearDown(tester.view.resetDevicePixelRatio);
    addTearDown(tester.platformDispatcher.clearTextScaleFactorTestValue);

    await tester.pumpWidget(_app(locale: const Locale('en')));
    final footnote = find.textContaining('adhan or prayer-time');
    await tester.scrollUntilVisible(
      footnote,
      240,
      scrollable: find.byType(Scrollable).last,
    );
    await tester.pumpAndSettle();

    expect(footnote, findsOneWidget);
    expect(tester.takeException(), isNull);
  });
}
