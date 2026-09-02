import 'package:flutter/material.dart';
import 'package:flutter_localizations/flutter_localizations.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:islami_hayat/core/theme/app_theme.dart';
import 'package:islami_hayat/features/notifications/domain/daily_verse_notification_t0291.dart';
import 'package:islami_hayat/features/notifications/domain/dhikr_reminder_t0293.dart';
import 'package:islami_hayat/l10n/app_localizations.dart';
import 'package:islami_hayat/shell/app_shell.dart';

Widget _app({
  required NotificationTapControllerT0291 controller,
  Future<bool> Function()? canEnterNewContent,
}) {
  return MaterialApp(
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
      notificationTapController: controller,
      canEnterNewContent: canEnterNewContent,
    ),
  );
}

void main() {
  test('dhikr parser accepts only the exact canonical local route', () {
    expect(
      isCanonicalDhikrReminderDeepLinkT0293('islami-hayat://dhikr'),
      isTrue,
    );

    for (final payload in const [
      'https://dhikr',
      'islami-hayat://quran',
      'islami-hayat://dhikr/extra',
      'islami-hayat://dhikr?count=33',
      'islami-hayat://dhikr#counter',
      'islami-hayat://user@dhikr',
      'islami-hayat://dhikr:443',
      'not a uri %',
    ]) {
      expect(
        isCanonicalDhikrReminderDeepLinkT0293(payload),
        isFalse,
        reason: payload,
      );
    }
  });

  testWidgets('dhikr notification tap opens dhikr through AppShell', (
    tester,
  ) async {
    final controller = NotificationTapControllerT0291();
    await tester.pumpWidget(_app(controller: controller));
    await tester.pump();

    controller.emit('islami-hayat://dhikr');
    await tester.pump();
    await tester.pump(const Duration(milliseconds: 50));

    final navigationBar = tester.widget<NavigationBar>(find.byType(NavigationBar));
    expect(navigationBar.selectedIndex, 3);
    expect(find.text('Sayaç'), findsOneWidget);
  });

  testWidgets('FREE offline gate blocks dhikr notification navigation', (
    tester,
  ) async {
    var guardCalls = 0;
    final controller = NotificationTapControllerT0291();
    await tester.pumpWidget(
      _app(
        controller: controller,
        canEnterNewContent: () async {
          guardCalls += 1;
          return false;
        },
      ),
    );
    await tester.pump();

    controller.emit('islami-hayat://dhikr');
    await tester.pump();
    await tester.pump(const Duration(milliseconds: 50));

    final navigationBar = tester.widget<NavigationBar>(find.byType(NavigationBar));
    expect(guardCalls, 1);
    expect(navigationBar.selectedIndex, 0);
    expect(find.text('Sayaç'), findsNothing);
  });

  testWidgets('tampered dhikr payload is ignored without invoking gate', (
    tester,
  ) async {
    var guardCalls = 0;
    final controller = NotificationTapControllerT0291();
    await tester.pumpWidget(
      _app(
        controller: controller,
        canEnterNewContent: () async {
          guardCalls += 1;
          return true;
        },
      ),
    );
    await tester.pump();

    controller.emit('islami-hayat://dhikr?count=33');
    await tester.pump();
    await tester.pump(const Duration(milliseconds: 50));

    final navigationBar = tester.widget<NavigationBar>(find.byType(NavigationBar));
    expect(guardCalls, 0);
    expect(navigationBar.selectedIndex, 0);
  });
}
