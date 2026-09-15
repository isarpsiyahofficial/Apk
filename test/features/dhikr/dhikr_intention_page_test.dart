import 'package:flutter/material.dart';
import 'package:flutter_localizations/flutter_localizations.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:islami_hayat/core/content/content_governance.dart';
import 'package:islami_hayat/features/dhikr/data/dhikr_intention_category.dart';
import 'package:islami_hayat/features/dhikr/data/divine_name_entry.dart';
import 'package:islami_hayat/features/dhikr/presentation/dhikr_intention_page.dart';

void main() {
  DivineNameEntry divineName({
    ContentReviewStatus reviewStatus = ContentReviewStatus.published,
  }) {
    return DivineNameEntry(
      id: 'esma:intention:test',
      arabic: 'اسم عربي تجريبي',
      transliterationTr: 'Deneme adı',
      transliterationEn: 'Test name',
      meaning: const LocalizedReligiousText(
        tr: 'Türkçe anlam.',
        en: 'English meaning.',
        ar: 'المعنى بالعربية.',
      ),
      whyRecited: const LocalizedReligiousText(
        tr: 'Türkçe açıklama.',
        en: 'English explanation.',
        ar: 'الشرح بالعربية.',
      ),
      sources: const [
        SourceReference(
          id: 'quran:intention:test',
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

  DhikrIntentionSuggestion suggestion({
    ContentReviewStatus reviewStatus = ContentReviewStatus.published,
  }) {
    return DhikrIntentionSuggestion(
      id: 'intent:ui:test',
      categoryId: DhikrIntentionCategoryId.provisionAndBlessing,
      divineNameId: 'esma:intention:test',
      basis: DhikrIntentionBasis.divineNameMeaning,
      rationale: const LocalizedReligiousText(
        tr: 'Bu öneri yalnız anlam bağlantısını açıklar.',
        en: 'This suggestion only explains the meaning connection.',
        ar: 'يشرح هذا الاقتراح صلة المعنى فقط.',
      ),
      reviewStatus: reviewStatus,
      version: 1,
    );
  }

  Future<void> pumpPage(
    WidgetTester tester, {
    required Locale locale,
    required Size size,
    required double textScale,
    required List<DhikrIntentionSuggestion> suggestions,
    required List<DivineNameEntry> divineNames,
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
          localizationsDelegates: const [
            GlobalMaterialLocalizations.delegate,
            GlobalWidgetsLocalizations.delegate,
            GlobalCupertinoLocalizations.delegate,
          ],
          home: DhikrIntentionPage(
            suggestions: suggestions,
            divineNames: divineNames,
          ),
        ),
      ),
    );
    await tester.pumpAndSettle();
  }

  testWidgets('renders four required categories without unreviewed claims',
      (tester) async {
    await pumpPage(
      tester,
      locale: const Locale('tr'),
      size: const Size(390, 844),
      textScale: 1,
      suggestions: const [],
      divineNames: const [],
    );

    expect(find.text('Rızık ve bereket'), findsOneWidget);
    await tester.drag(find.byType(ListView), const Offset(0, -700));
    await tester.pumpAndSettle();
    expect(find.text('Kolaylık ve çıkış yolu'), findsOneWidget);
    expect(tester.takeException(), isNull);
  });

  testWidgets('published suggestion renders with explicit no-guarantee copy',
      (tester) async {
    await pumpPage(
      tester,
      locale: const Locale('tr'),
      size: const Size(390, 844),
      textScale: 1,
      suggestions: [suggestion()],
      divineNames: [divineName()],
    );

    expect(find.text('Deneme adı'), findsOneWidget);
    expect(
      find.text('Bu öneri yalnız anlam bağlantısını açıklar.'),
      findsOneWidget,
    );
    expect(
      find.text(
        'Bu ilişki anlam/dayanak bağlantısıdır; sonuç garantisi değildir.',
      ),
      findsOneWidget,
    );
    expect(tester.takeException(), isNull);
  });

  testWidgets('review-incomplete suggestion and Esma fail closed',
      (tester) async {
    await pumpPage(
      tester,
      locale: const Locale('tr'),
      size: const Size(390, 844),
      textScale: 1,
      suggestions: [suggestion(reviewStatus: ContentReviewStatus.languageReview)],
      divineNames: [divineName(reviewStatus: ContentReviewStatus.languageReview)],
    );

    expect(find.text('Deneme adı'), findsNothing);
    expect(
      find.byKey(
        const ValueKey('intention-empty-provisionAndBlessing'),
      ),
      findsOneWidget,
    );
    expect(tester.takeException(), isNull);
  });

  testWidgets('Arabic RTL narrow phone with large font stays usable',
      (tester) async {
    await pumpPage(
      tester,
      locale: const Locale('ar'),
      size: const Size(320, 640),
      textScale: 1.6,
      suggestions: const [],
      divineNames: const [],
    );

    expect(find.text('الرزق والبركة'), findsOneWidget);
    expect(
      Directionality.of(tester.element(find.byType(Scaffold))),
      TextDirection.rtl,
    );
    expect(tester.takeException(), isNull);
  });

  testWidgets('tablet category cards remain bounded', (tester) async {
    await pumpPage(
      tester,
      locale: const Locale('en'),
      size: const Size(1024, 768),
      textScale: 1,
      suggestions: const [],
      divineNames: const [],
    );

    final firstCard = tester.getSize(find.byType(Card).first);
    expect(firstCard.width, lessThanOrEqualTo(760));
    expect(find.text('Provision and blessing'), findsOneWidget);
    expect(tester.takeException(), isNull);
  });
}
