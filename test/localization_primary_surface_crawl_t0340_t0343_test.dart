import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:islami_hayat/app.dart';
import 'package:islami_hayat/features/dhikr/presentation/dhikr_hub_page.dart';
import 'package:islami_hayat/features/profile/presentation/profile_page.dart';
import 'package:islami_hayat/features/prophets/presentation/revelation_journey_page.dart';
import 'package:islami_hayat/features/quran/presentation/quran_hub_page.dart';
import 'package:islami_hayat/features/shared/presentation/discover_page.dart';
import 'package:islami_hayat/features/today/presentation/today_page.dart';

void main() {
  const localeCases = <String, _LocaleCase>{
    'tr': _LocaleCase(
      locale: Locale('tr'),
      direction: TextDirection.ltr,
      labels: <String>['Bugün', 'Kur’an', 'Keşfet', 'Zikir', 'Ben'],
      revelationJourneyTitle: 'Vahiy Yolculuğu',
    ),
    'en': _LocaleCase(
      locale: Locale('en'),
      direction: TextDirection.ltr,
      labels: <String>['Today', 'Qur’an', 'Discover', 'Dhikr', 'Me'],
      revelationJourneyTitle: 'Revelation Journey',
    ),
    'ar': _LocaleCase(
      locale: Locale('ar'),
      direction: TextDirection.rtl,
      labels: <String>['اليوم', 'القرآن', 'اكتشف', 'الذكر', 'أنا'],
      revelationJourneyTitle: 'رحلة الوحي',
    ),
  };

  Future<void> pumpPhone(WidgetTester tester, Locale locale) async {
    tester.view.physicalSize = const Size(390, 844);
    tester.view.devicePixelRatio = 1;
    addTearDown(tester.view.resetPhysicalSize);
    addTearDown(tester.view.resetDevicePixelRatio);

    await tester.pumpWidget(IslamiHayatApp(locale: locale));
    await tester.pumpAndSettle();
  }

  Finder navigationLabel(String label) => find.descendant(
        of: find.byType(NavigationBar),
        matching: find.text(label),
      );

  for (final entry in localeCases.entries) {
    testWidgets('${entry.key} primary five-surface crawl is localized and safe',
        (tester) async {
      final localeCase = entry.value;
      await pumpPhone(tester, localeCase.locale);

      final directionality = tester.widget<Directionality>(
        find.byType(Directionality).first,
      );
      expect(directionality.textDirection, localeCase.direction);
      expect(find.byType(NavigationBar), findsOneWidget);

      // Scope navigation-copy assertions to the NavigationBar. Some localized
      // labels (for example Discover/Dhikr) legitimately appear again as
      // Today-page quick actions and must not be treated as duplicate leaks.
      for (final label in localeCase.labels) {
        expect(navigationLabel(label), findsOneWidget);
      }

      expect(find.byType(TodayPage), findsOneWidget);
      expect(tester.takeException(), isNull);

      await tester.tap(find.byKey(const ValueKey('nav-quran')));
      await tester.pumpAndSettle();
      expect(find.byType(QuranHubPage), findsOneWidget);
      expect(tester.takeException(), isNull);

      await tester.tap(find.byKey(const ValueKey('nav-discover')));
      await tester.pumpAndSettle();
      expect(find.byType(DiscoverPage), findsOneWidget);
      expect(find.text(localeCase.revelationJourneyTitle), findsOneWidget);
      expect(tester.takeException(), isNull);

      // T0344 deep-surface evidence begins with a real nested route rather
      // than counting the Discover card as coverage by visibility alone.
      await tester.tap(find.byKey(const ValueKey('discover-revelation-journey')));
      await tester.pumpAndSettle();
      expect(find.byType(RevelationJourneyPage), findsOneWidget);
      expect(
        tester.widget<Directionality>(find.byType(Directionality).first).textDirection,
        localeCase.direction,
      );
      expect(tester.takeException(), isNull);
      await tester.pageBack();
      await tester.pumpAndSettle();
      expect(find.byType(DiscoverPage), findsOneWidget);

      await tester.tap(find.byKey(const ValueKey('nav-dhikr')));
      await tester.pumpAndSettle();
      expect(find.byType(DhikrHubPage), findsOneWidget);
      expect(tester.takeException(), isNull);

      await tester.tap(find.byKey(const ValueKey('nav-profile')));
      await tester.pumpAndSettle();
      expect(find.byType(ProfilePage), findsOneWidget);
      expect(tester.takeException(), isNull);
    });
  }

  testWidgets('primary navigation labels do not leak between locales',
      (tester) async {
    for (final active in localeCases.entries) {
      await pumpPhone(tester, active.value.locale);

      for (final expected in active.value.labels) {
        expect(navigationLabel(expected), findsOneWidget);
      }

      for (final other in localeCases.entries) {
        if (other.key == active.key) continue;
        for (final forbidden in other.value.labels) {
          if (active.value.labels.contains(forbidden)) continue;
          expect(
            navigationLabel(forbidden),
            findsNothing,
            reason:
                '${active.key} navigation leaked ${other.key} label: $forbidden',
          );
        }
      }

      expect(tester.takeException(), isNull);
    }
  });

  testWidgets('Arabic primary crawl remains RTL on tablet navigation rail',
      (tester) async {
    tester.view.physicalSize = const Size(1024, 768);
    tester.view.devicePixelRatio = 1;
    addTearDown(tester.view.resetPhysicalSize);
    addTearDown(tester.view.resetDevicePixelRatio);

    await tester.pumpWidget(const IslamiHayatApp(locale: Locale('ar')));
    await tester.pumpAndSettle();

    expect(find.byType(NavigationRail), findsOneWidget);
    expect(
      tester.widget<Directionality>(find.byType(Directionality).first).textDirection,
      TextDirection.rtl,
    );

    for (final destination in const <String>[
      'quran',
      'discover',
      'dhikr',
      'profile',
      'today',
    ]) {
      await tester.tap(find.byKey(ValueKey('nav-$destination')).first);
      await tester.pumpAndSettle();
      expect(tester.takeException(), isNull);
    }
  });
}

class _LocaleCase {
  const _LocaleCase({
    required this.locale,
    required this.direction,
    required this.labels,
    required this.revelationJourneyTitle,
  });

  final Locale locale;
  final TextDirection direction;
  final List<String> labels;
  final String revelationJourneyTitle;
}
