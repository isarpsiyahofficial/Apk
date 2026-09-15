import 'package:flutter/material.dart';
import 'package:flutter_localizations/flutter_localizations.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:islami_hayat/features/dua/data/dua_content.dart';
import 'package:islami_hayat/features/dua/data/dua_special_occasion_state.dart';
import 'package:islami_hayat/features/dua/presentation/dua_special_occasion_notice.dart';

Widget _host(Locale locale, DuaSpecialOccasionState state) => MaterialApp(
      locale: locale,
      supportedLocales: const [Locale('tr'), Locale('en'), Locale('ar')],
      localizationsDelegates: GlobalMaterialLocalizations.delegates,
      home: Scaffold(
        body: Directionality(
          textDirection:
              locale.languageCode == 'ar' ? TextDirection.rtl : TextDirection.ltr,
          child: DuaSpecialOccasionNotice(state: state),
        ),
      ),
    );

const _missing = DuaSpecialOccasionState(
  category: DuaCategory.religiousNights,
  status: DuaSpecialOccasionStatus.noAuthenticatedSpecialDuaInVerifiedLibrary,
  authenticatedSpecialDuas: [],
  otherVerifiedDuas: [],
);

const _available = DuaSpecialOccasionState(
  category: DuaCategory.eid,
  status: DuaSpecialOccasionStatus.authenticatedSpecialDuaAvailable,
  authenticatedSpecialDuas: [],
  otherVerifiedDuas: [],
);

void main() {
  testWidgets('TR explicitly scopes absence to the verified library', (tester) async {
    await tester.pumpWidget(_host(const Locale('tr'), _missing));

    expect(
      find.text('Doğrulanmış kütüphanede özel sahih dua yok'),
      findsOneWidget,
    );
    expect(find.byKey(const ValueKey('dua-special-occasion-honesty-notice')), findsOneWidget);
  });

  testWidgets('EN explicitly scopes absence to the verified library', (tester) async {
    await tester.pumpWidget(_host(const Locale('en'), _missing));

    expect(
      find.text('No authenticated special dua in the verified library'),
      findsOneWidget,
    );
  });

  testWidgets('AR renders the honesty notice in RTL host without overflow', (tester) async {
    tester.view.physicalSize = const Size(320, 800);
    tester.view.devicePixelRatio = 1;
    addTearDown(tester.view.resetPhysicalSize);
    addTearDown(tester.view.resetDevicePixelRatio);

    await tester.pumpWidget(_host(const Locale('ar'), _missing));

    expect(
      find.text('لا يوجد دعاء خاص ثابت في المكتبة الموثَّقة'),
      findsOneWidget,
    );
    expect(tester.takeException(), isNull);
  });

  testWidgets('notice is hidden when an authenticated special dua exists', (tester) async {
    await tester.pumpWidget(_host(const Locale('tr'), _available));

    expect(
      find.byKey(const ValueKey('dua-special-occasion-honesty-notice')),
      findsNothing,
    );
  });
}
