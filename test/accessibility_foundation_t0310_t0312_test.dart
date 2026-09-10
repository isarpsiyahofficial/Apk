import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:islami_hayat/app.dart';
import 'package:islami_hayat/core/theme/app_theme.dart';

void main() {
  Future<void> pumpAccessibleApp(
    WidgetTester tester, {
    required Locale locale,
    Size size = const Size(360, 800),
    double textScaleFactor = 2,
  }) async {
    tester.view.physicalSize = size;
    tester.view.devicePixelRatio = 1;
    tester.platformDispatcher.textScaleFactorTestValue = textScaleFactor;

    addTearDown(tester.view.resetPhysicalSize);
    addTearDown(tester.view.resetDevicePixelRatio);
    addTearDown(tester.platformDispatcher.clearTextScaleFactorTestValue);

    await tester.pumpWidget(IslamiHayatApp(locale: locale));
    await tester.pumpAndSettle();
  }

  test('theme keeps common Material controls on a padded 48dp baseline', () {
    final theme = AppTheme.light();

    expect(theme.materialTapTargetSize, MaterialTapTargetSize.padded);
    expect(theme.visualDensity, VisualDensity.standard);

    const states = <WidgetState>{};
    expect(
      theme.iconButtonTheme.style?.minimumSize?.resolve(states),
      const Size(48, 48),
    );
    expect(
      theme.textButtonTheme.style?.minimumSize?.resolve(states),
      const Size(48, 48),
    );
    expect(
      theme.filledButtonTheme.style?.minimumSize?.resolve(states),
      const Size(48, 48),
    );
    expect(
      theme.outlinedButtonTheme.style?.minimumSize?.resolve(states),
      const Size(48, 48),
    );
    expect(
      theme.elevatedButtonTheme.style?.minimumSize?.resolve(states),
      const Size(48, 48),
    );
  });

  for (final locale in const <Locale>[
    Locale('tr'),
    Locale('en'),
    Locale('ar'),
  ]) {
    testWidgets(
      '${locale.languageCode} shell survives 2.0x font while traversing all five tabs',
      (tester) async {
        await pumpAccessibleApp(tester, locale: locale);

        expect(find.byType(NavigationBar), findsOneWidget);
        expect(tester.takeException(), isNull);

        for (final id in const <String>[
          'quran',
          'discover',
          'dhikr',
          'profile',
          'today',
        ]) {
          final destination = find.byKey(ValueKey('nav-$id'));
          expect(destination, findsOneWidget);
          await tester.tap(destination);
          await tester.pumpAndSettle();
          expect(
            tester.takeException(),
            isNull,
            reason: '${locale.languageCode} overflow/error on $id at 2.0x',
          );
        }
      },
    );
  }

  testWidgets('compact navigation destinations expose >=48dp hit regions',
      (tester) async {
    await pumpAccessibleApp(
      tester,
      locale: const Locale('tr'),
      textScaleFactor: 1,
    );

    for (final id in const <String>[
      'today',
      'quran',
      'discover',
      'dhikr',
      'profile',
    ]) {
      final rect = tester.getRect(find.byKey(ValueKey('nav-$id')));
      expect(rect.width, greaterThanOrEqualTo(48), reason: '$id width');
      expect(rect.height, greaterThanOrEqualTo(48), reason: '$id height');
    }
  });

  testWidgets('Arabic 2.0x accessibility run remains RTL', (tester) async {
    await pumpAccessibleApp(tester, locale: const Locale('ar'));

    final directionality = tester.widget<Directionality>(
      find.byType(Directionality).first,
    );
    expect(directionality.textDirection, TextDirection.rtl);
    expect(tester.takeException(), isNull);
  });
}
