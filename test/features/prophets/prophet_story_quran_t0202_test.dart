import 'package:flutter/material.dart';
import 'package:flutter_localizations/flutter_localizations.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:islami_hayat/features/prophets/data/prophet_biography_t0194_dataset.dart';
import 'package:islami_hayat/features/prophets/data/prophet_content.dart';
import 'package:islami_hayat/features/prophets/presentation/prophet_story_page.dart';

Widget _app({
  required Locale locale,
  required String prophetId,
  required Future<void> Function(ProphetVerseReference verse) onOpen,
  double textScale = 1,
}) {
  return MaterialApp(
    locale: locale,
    supportedLocales: const <Locale>[
      Locale('tr'),
      Locale('en'),
      Locale('ar'),
    ],
    localizationsDelegates: const <LocalizationsDelegate<dynamic>>[
      GlobalMaterialLocalizations.delegate,
      GlobalWidgetsLocalizations.delegate,
      GlobalCupertinoLocalizations.delegate,
    ],
    builder: (context, child) {
      final mediaQuery = MediaQuery.of(context);
      return MediaQuery(
        data: mediaQuery.copyWith(textScaler: TextScaler.linear(textScale)),
        child: child!,
      );
    },
    home: ProphetStoryPage(
      prophetId: prophetId,
      onOpenQuranVerse: onOpen,
    ),
  );
}

void main() {
  group('T0202 ProphetStoryPage Quran links', () {
    final biography = canonicalProphetBiographyT0194Dataset.firstWhere(
      (entry) => entry.quranReferences.isNotEmpty,
    );
    final prophetId = biography.identity.canonicalId;
    final firstVerse = biography.quranReferences.first;

    testWidgets('reviewed biography exposes exact verse reference and dispatches it',
        (tester) async {
      await tester.binding.setSurfaceSize(const Size(390, 844));
      addTearDown(() => tester.binding.setSurfaceSize(null));
      ProphetVerseReference? opened;

      await tester.pumpWidget(
        _app(
          locale: const Locale('tr'),
          prophetId: prophetId,
          onOpen: (verse) async => opened = verse,
        ),
      );
      await tester.pumpAndSettle();

      expect(
        find.byKey(const ValueKey('prophet-story-quran-links-title')),
        findsOneWidget,
      );
      final target = find.byKey(
        ValueKey('prophet-story-quran-${firstVerse.stableId}'),
      );
      expect(target, findsOneWidget);

      await tester.tap(target);
      await tester.pump();
      expect(opened?.stableId, firstVerse.stableId);
      expect(tester.takeException(), isNull);
    });

    testWidgets('Quran action is absent when no destination callback is available',
        (tester) async {
      await tester.binding.setSurfaceSize(const Size(390, 844));
      addTearDown(() => tester.binding.setSurfaceSize(null));

      await tester.pumpWidget(
        MaterialApp(
          home: ProphetStoryPage(prophetId: prophetId),
        ),
      );
      await tester.pumpAndSettle();

      expect(
        find.byKey(const ValueKey('prophet-story-quran-links-title')),
        findsNothing,
      );
      expect(tester.takeException(), isNull);
    });

    testWidgets('Arabic Quran links stay RTL-safe at 1.6x on narrow phone',
        (tester) async {
      await tester.binding.setSurfaceSize(const Size(360, 800));
      addTearDown(() => tester.binding.setSurfaceSize(null));

      await tester.pumpWidget(
        _app(
          locale: const Locale('ar'),
          prophetId: prophetId,
          textScale: 1.6,
          onOpen: (_) async {},
        ),
      );
      await tester.pumpAndSettle();

      final title = find.byKey(const ValueKey('prophet-story-quran-links-title'));
      expect(title, findsOneWidget);
      expect(Directionality.of(tester.element(title)), TextDirection.rtl);
      expect(tester.takeException(), isNull);
    });
  });
}
