import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:islami_hayat/core/content/content_governance.dart';
import 'package:islami_hayat/features/dhikr/data/divine_name_entry.dart';
import 'package:islami_hayat/features/dhikr/presentation/divine_name_guide_page.dart';

void main() {
  DivineNameEntry entry({
    ContentReviewStatus reviewStatus = ContentReviewStatus.published,
  }) {
    return DivineNameEntry(
      id: 'esma:ui:test',
      arabic: 'اسم عربي تجريبي',
      transliterationTr: 'Deneme adı',
      transliterationEn: 'Test name',
      meaning: const LocalizedReligiousText(
        tr: 'Türkçe anlam testi.',
        en: 'English meaning test.',
        ar: 'اختبار المعنى بالعربية.',
      ),
      whyRecited: const LocalizedReligiousText(
        tr: 'Türkçe açıklama testi.',
        en: 'English explanation test.',
        ar: 'اختبار الشرح بالعربية.',
      ),
      sources: const [
        SourceReference(
          id: 'quran:test:1',
          title: 'Pinned Quran source',
          sourceClass: ReligiousSourceClass.quran,
          licenseId: 'quran-license',
          locator: 'surah:ayah',
        ),
      ],
      reviewStatus: reviewStatus,
      version: 1,
      lastReviewedAt: DateTime.utc(2026, 8, 28),
    );
  }

  Future<void> pumpGuide(
    WidgetTester tester, {
    required Locale locale,
    required Size size,
    required double textScale,
    required List<DivineNameEntry> entries,
  }) async {
    tester.view.physicalSize = size;
    tester.view.devicePixelRatio = 1;
    addTearDown(tester.view.resetPhysicalSize);
    addTearDown(tester.view.resetDevicePixelRatio);

    await tester.pumpWidget(
      MediaQuery(
        data: MediaQueryData(
          size: size,
          textScaler: TextScaler.linear(textScale),
        ),
        child: MaterialApp(
          locale: locale,
          supportedLocales: const [Locale('tr'), Locale('en'), Locale('ar')],
          home: DivineNameGuidePage(entries: entries),
        ),
      ),
    );
    await tester.pumpAndSettle();
  }

  testWidgets('published entry renders meaning, reason and explicit source',
      (tester) async {
    await pumpGuide(
      tester,
      locale: const Locale('tr'),
      size: const Size(390, 844),
      textScale: 1,
      entries: [entry()],
    );

    expect(find.text('Deneme adı'), findsOneWidget);
    expect(find.text('Türkçe anlam testi.'), findsOneWidget);
    expect(find.text('Türkçe açıklama testi.'), findsOneWidget);
    expect(find.textContaining('Pinned Quran source'), findsOneWidget);
    expect(tester.takeException(), isNull);
  });

  testWidgets('unreviewed content is fail-closed and never rendered',
      (tester) async {
    await pumpGuide(
      tester,
      locale: const Locale('tr'),
      size: const Size(390, 844),
      textScale: 1,
      entries: [entry(reviewStatus: ContentReviewStatus.languageReview)],
    );

    expect(find.byKey(const ValueKey('divine-name-empty-state')), findsOneWidget);
    expect(find.text('Deneme adı'), findsNothing);
    expect(tester.takeException(), isNull);
  });

  testWidgets('Arabic RTL narrow phone with large font does not overflow',
      (tester) async {
    await pumpGuide(
      tester,
      locale: const Locale('ar'),
      size: const Size(320, 640),
      textScale: 1.6,
      entries: [entry()],
    );

    expect(find.text('اختبار المعنى بالعربية.'), findsOneWidget);
    expect(find.text('اختبار الشرح بالعربية.'), findsOneWidget);
    expect(Directionality.of(tester.element(find.byType(Scaffold))), TextDirection.rtl);
    expect(tester.takeException(), isNull);
  });

  testWidgets('tablet layout stays bounded and readable', (tester) async {
    await pumpGuide(
      tester,
      locale: const Locale('en'),
      size: const Size(1024, 768),
      textScale: 1,
      entries: [entry()],
    );

    final cardSize = tester.getSize(find.byType(Card));
    expect(cardSize.width, lessThanOrEqualTo(760));
    expect(find.text('English meaning test.'), findsOneWidget);
    expect(tester.takeException(), isNull);
  });
}
