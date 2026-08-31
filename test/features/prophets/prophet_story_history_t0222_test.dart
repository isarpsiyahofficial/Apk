import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:islami_hayat/features/history/domain/biography_timeline_link_t0222.dart';
import 'package:islami_hayat/features/prophets/presentation/prophet_story_page.dart';

Widget _app({required Locale locale, required String prophetId}) {
  return MaterialApp(
    locale: locale,
    supportedLocales: const [Locale('tr'), Locale('en'), Locale('ar')],
    home: ProphetStoryPage(prophetId: prophetId),
  );
}

void main() {
  group('T0222 ProphetStoryPage history timeline', () {
    testWidgets('Muhammad biography renders exact linked history events in TR',
        (tester) async {
      await tester.binding.setSurfaceSize(const Size(390, 844));
      addTearDown(() => tester.binding.setSurfaceSize(null));

      await tester.pumpWidget(
        _app(locale: const Locale('tr'), prophetId: 'muhammad'),
      );
      await tester.pumpAndSettle();

      final linked = historyBiographyTimelineT0222.eventsForBiography(
        'prophet:muhammad',
      );
      expect(linked, isNotEmpty);

      await tester.scrollUntilVisible(
        find.byKey(const ValueKey('prophet-story-history-title')),
        300,
      );
      expect(find.text('Tarih kronolojisinde'), findsOneWidget);

      for (final event in linked.take(2)) {
        await tester.scrollUntilVisible(
          find.byKey(ValueKey('prophet-history-event-${event.id}')),
          250,
        );
        expect(
          find.byKey(ValueKey('prophet-history-event-${event.id}')),
          findsOneWidget,
        );
      }
      expect(tester.takeException(), isNull);
    });

    testWidgets('biography without exact event link does not render timeline UI',
        (tester) async {
      await tester.binding.setSurfaceSize(const Size(390, 844));
      addTearDown(() => tester.binding.setSurfaceSize(null));

      await tester.pumpWidget(
        _app(locale: const Locale('en'), prophetId: 'ibrahim'),
      );
      await tester.pumpAndSettle();

      expect(
        historyBiographyTimelineT0222.eventsForBiography('prophet:ibrahim'),
        isEmpty,
      );
      expect(
        find.byKey(const ValueKey('prophet-story-history-title')),
        findsNothing,
      );
      expect(tester.takeException(), isNull);
    });

    testWidgets('Arabic timeline stays RTL-safe with large font on narrow phone',
        (tester) async {
      await tester.binding.setSurfaceSize(const Size(360, 800));
      addTearDown(() => tester.binding.setSurfaceSize(null));

      await tester.pumpWidget(
        MediaQuery(
          data: const MediaQueryData(textScaler: TextScaler.linear(1.6)),
          child: _app(locale: const Locale('ar'), prophetId: 'muhammad'),
        ),
      );
      await tester.pumpAndSettle();

      await tester.scrollUntilVisible(
        find.byKey(const ValueKey('prophet-story-history-title')),
        300,
      );
      expect(find.text('في التسلسل التاريخي'), findsOneWidget);
      expect(
        Directionality.of(
          tester.element(find.byKey(const ValueKey('prophet-story-history-title'))),
        ),
        TextDirection.rtl,
      );
      expect(tester.takeException(), isNull);
    });

    testWidgets('wide tablet keeps biography content bounded and timeline visible',
        (tester) async {
      await tester.binding.setSurfaceSize(const Size(1280, 800));
      addTearDown(() => tester.binding.setSurfaceSize(null));

      await tester.pumpWidget(
        _app(locale: const Locale('en'), prophetId: 'muhammad'),
      );
      await tester.pumpAndSettle();

      await tester.scrollUntilVisible(
        find.byKey(const ValueKey('prophet-story-history-title')),
        300,
      );
      expect(find.text('In the history timeline'), findsOneWidget);
      final constrained = tester.widgetList<ConstrainedBox>(
        find.byType(ConstrainedBox),
      );
      expect(
        constrained.any((box) => box.constraints.maxWidth == 760),
        isTrue,
      );
      expect(tester.takeException(), isNull);
    });
  });
}
