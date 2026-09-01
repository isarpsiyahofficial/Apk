import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:islami_hayat/features/notifications/presentation/notification_settings_page.dart';
import 'package:islami_hayat/l10n/app_localizations.dart';

Widget _app({
  Locale locale = const Locale('tr'),
  NotificationPreferences initial = const NotificationPreferences(),
  ValueChanged<NotificationPreferences>? onChanged,
}) {
  return MaterialApp(
    locale: locale,
    localizationsDelegates: AppLocalizations.localizationsDelegates,
    supportedLocales: AppLocalizations.supportedLocales,
    home: NotificationSettingsPage(
      initialPreferences: initial,
      onChanged: onChanged,
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

  testWidgets('T0290 preserves explicit initial choices', (tester) async {
    await tester.pumpWidget(
      _app(
        initial: const NotificationPreferences(
          dailyDua: true,
          dhikrReminder: true,
        ),
      ),
    );

    final values = tester
        .widgetList<SwitchListTile>(find.byType(SwitchListTile))
        .map((tile) => tile.value)
        .toList();
    expect(values, [false, true, true, false]);
  });

  testWidgets('T0290 Arabic is RTL and religious-day source condition is visible', (
    tester,
  ) async {
    tester.view.physicalSize = const Size(360, 800);
    tester.view.devicePixelRatio = 1;
    addTearDown(tester.view.resetPhysicalSize);
    addTearDown(tester.view.resetDevicePixelRatio);

    await tester.pumpWidget(_app(locale: const Locale('ar')));

    expect(Directionality.of(tester.element(find.text('الإشعارات'))), TextDirection.rtl);
    expect(find.textContaining('مصدر موثوق'), findsOneWidget);
    expect(tester.takeException(), isNull);
  });

  testWidgets('T0290 large font remains scrollable without overflow', (tester) async {
    tester.view.physicalSize = const Size(320, 640);
    tester.view.devicePixelRatio = 1;
    tester.platformDispatcher.textScaleFactorTestValue = 1.6;
    addTearDown(tester.view.resetPhysicalSize);
    addTearDown(tester.view.resetDevicePixelRatio);
    addTearDown(tester.platformDispatcher.clearTextScaleFactorTestValue);

    await tester.pumpWidget(_app(locale: const Locale('en')));
    await tester.drag(find.byType(ListView), const Offset(0, -500));
    await tester.pump();

    expect(find.textContaining('adhan or prayer-time'), findsOneWidget);
    expect(tester.takeException(), isNull);
  });
}
