import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:islami_hayat/features/notifications/domain/notification_preferences.dart';
import 'package:islami_hayat/features/notifications/presentation/notification_settings_page.dart';
import 'package:islami_hayat/l10n/app_localizations.dart';

Widget _app({
  Locale locale = const Locale('tr'),
  NotificationPreferences initial = const NotificationPreferences(),
}) {
  return MaterialApp(
    locale: locale,
    localizationsDelegates: AppLocalizations.localizationsDelegates,
    supportedLocales: AppLocalizations.supportedLocales,
    home: NotificationSettingsPage(initialPreferences: initial),
  );
}

void main() {
  testWidgets('T0290 enabled category exposes its localized time picker', (
    tester,
  ) async {
    await tester.pumpWidget(
      _app(
        initial: const NotificationPreferences(
          dailyVerse: true,
          dailyVerseTime: NotificationTime(hour: 7, minute: 35),
        ),
      ),
    );

    final control = find.byKey(const Key('notification-time-dailyVerse'));
    expect(control, findsOneWidget);
    expect(find.text('Hatırlatma saati'), findsOneWidget);

    await tester.tap(control);
    await tester.pumpAndSettle();

    expect(find.byType(TimePickerDialog), findsOneWidget);
    expect(tester.takeException(), isNull);
  });

  testWidgets('T0290 disabled categories keep time controls out of the layout', (
    tester,
  ) async {
    await tester.pumpWidget(_app());

    expect(find.byKey(const Key('notification-time-dailyVerse')), findsNothing);
    expect(find.byKey(const Key('notification-time-dailyDua')), findsNothing);
    expect(find.byKey(const Key('notification-time-dhikrReminder')), findsNothing);
    expect(find.byKey(const Key('notification-time-religiousDay')), findsNothing);
  });

  testWidgets('T0290 Arabic RTL time control survives tablet landscape', (
    tester,
  ) async {
    tester.view.physicalSize = const Size(1200, 800);
    tester.view.devicePixelRatio = 1;
    tester.platformDispatcher.textScaleFactorTestValue = 1.3;
    addTearDown(tester.view.resetPhysicalSize);
    addTearDown(tester.view.resetDevicePixelRatio);
    addTearDown(tester.platformDispatcher.clearTextScaleFactorTestValue);

    await tester.pumpWidget(
      _app(
        locale: const Locale('ar'),
        initial: const NotificationPreferences(
          religiousDay: true,
          religiousDayTime: NotificationTime(hour: 8, minute: 10),
        ),
      ),
    );

    final control = find.byKey(const Key('notification-time-religiousDay'));
    expect(control, findsOneWidget);
    expect(find.text('وقت التذكير'), findsOneWidget);
    expect(Directionality.of(tester.element(control)), TextDirection.rtl);
    expect(tester.takeException(), isNull);
  });
}
