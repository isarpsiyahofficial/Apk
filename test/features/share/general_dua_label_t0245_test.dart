import 'package:flutter/material.dart';
import 'package:flutter_localizations/flutter_localizations.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:islami_hayat/core/content/content_governance.dart';
import 'package:islami_hayat/features/dua/data/dua_content.dart';
import 'package:islami_hayat/features/share/domain/runtime_religious_content_t0243.dart';
import 'package:islami_hayat/features/share/domain/share_canvas_layout_t0242.dart';
import 'package:islami_hayat/features/share/presentation/runtime_religious_share_card_t0243.dart';
import 'package:islami_hayat/l10n/app_localizations.dart';

DuaContent _editorialDua() => DuaContent(
  id: 'dua:editorial:t0245',
  sourceStatus: DuaSourceStatus.generalEditorial,
  lengthClass: DuaLengthClass.short,
  categories: const {DuaCategory.peace},
  text: const LocalizedReligiousText(
    tr: 'Allah’ım kalbimize huzur ver.',
    en: 'O Allah, grant peace to our hearts.',
    ar: 'اللهم ارزق قلوبنا السكينة.',
  ),
  reviewStatus: ContentReviewStatus.published,
  version: 1,
  lastReviewedAt: DateTime.utc(2026, 9, 1),
  sources: const [
    SourceReference(
      id: 'editorial:meaning:t0245',
      title: 'Editorial meaning review',
      sourceClass: ReligiousSourceClass.meaningBasedDua,
      licenseId: 'project-editorial',
    ),
  ],
  reviewer: 'religious-language-review',
);

ReligiousContentRecord _sunnahDua() => ReligiousContentRecord(
  id: 'dua:sunnah:t0245',
  type: ContentType.dua,
  sourceStatus: ReligiousSourceClass.sahihHasanHadith,
  version: 1,
  reviewStatus: ContentReviewStatus.published,
  certainty: CertaintyLevel.explicitSource,
  text: const LocalizedReligiousText(
    tr: 'Kaynaklı dua',
    en: 'Sourced dua',
    ar: 'دعاء مأثور',
  ),
  sources: const [
    SourceReference(
      id: 'hadith:t0245',
      title: 'Authenticated source',
      sourceClass: ReligiousSourceClass.sahihHasanHadith,
      licenseId: 'reviewed-reference',
    ),
  ],
  lastReviewedAt: DateTime.utc(2026, 9, 1),
);

Widget _app({required Locale locale, required RuntimeReligiousShareContentT0243 content}) {
  return MaterialApp(
    locale: locale,
    supportedLocales: AppLocalizations.supportedLocales,
    localizationsDelegates: const [
      AppLocalizations.delegate,
      GlobalMaterialLocalizations.delegate,
      GlobalWidgetsLocalizations.delegate,
      GlobalCupertinoLocalizations.delegate,
    ],
    home: Scaffold(
      body: SizedBox(
        width: 360,
        child: RuntimeReligiousShareCardT0243(
          format: ShareCanvasFormatT0242.instagramStory916,
          background: const SizedBox.expand(),
          content: content,
        ),
      ),
    ),
  );
}

void main() {
  test('T0245 derives General Dua requirement from governed editorial metadata', () {
    final content = RuntimeReligiousShareContentT0243.fromPublishedRecord(
      record: _editorialDua().toGovernedRecord(),
      locale: ShareContentLocaleT0243.tr,
    );

    expect(content.type, ContentType.dua);
    expect(content.sourceClass, ReligiousSourceClass.meaningBasedDua);
    expect(content.requiresGeneralDuaLabel, isTrue);
  });

  test('T0245 does not mislabel sourced Sunnah dua as General Dua', () {
    final content = RuntimeReligiousShareContentT0243.fromPublishedRecord(
      record: _sunnahDua(),
      locale: ShareContentLocaleT0243.en,
    );

    expect(content.requiresGeneralDuaLabel, isFalse);
  });

  test('T0245 fails closed when editorial classification lacks matching provenance', () {
    final tampered = ReligiousContentRecord(
      id: 'dua:tampered:t0245',
      type: ContentType.dua,
      sourceStatus: ReligiousSourceClass.meaningBasedDua,
      version: 1,
      reviewStatus: ContentReviewStatus.published,
      certainty: CertaintyLevel.stronglyAttested,
      text: const LocalizedReligiousText(
        tr: 'Genel dua',
        en: 'General dua',
        ar: 'دعاء عام',
      ),
      sources: const [
        SourceReference(
          id: 'mismatch:t0245',
          title: 'Mismatched source',
          sourceClass: ReligiousSourceClass.sahihHasanHadith,
          licenseId: 'reviewed-reference',
        ),
      ],
      lastReviewedAt: DateTime.utc(2026, 9, 1),
    );

    expect(
      () => RuntimeReligiousShareContentT0243.fromPublishedRecord(
        record: tampered,
        locale: ShareContentLocaleT0243.tr,
      ),
      throwsStateError,
    );
  });

  for (final fixture in <(Locale, String)>[
    (const Locale('tr'), 'Genel Dua'),
    (const Locale('en'), 'General Dua'),
    (const Locale('ar'), 'دعاء عام'),
  ]) {
    testWidgets('T0245 renders mandatory localized label for ${fixture.$1.languageCode}', (
      tester,
    ) async {
      final locale = fixture.$1;
      final content = RuntimeReligiousShareContentT0243.fromPublishedRecord(
        record: _editorialDua().toGovernedRecord(),
        locale: switch (locale.languageCode) {
          'en' => ShareContentLocaleT0243.en,
          'ar' => ShareContentLocaleT0243.ar,
          _ => ShareContentLocaleT0243.tr,
        },
      );

      await tester.pumpWidget(_app(locale: locale, content: content));
      await tester.pumpAndSettle();

      expect(
        find.byKey(const ValueKey('general-dua-label-t0245')),
        findsOneWidget,
      );
      expect(find.text(fixture.$2), findsOneWidget);
      expect(tester.takeException(), isNull);
    });
  }

  testWidgets('T0245 label cannot be hidden on an editorial share card', (tester) async {
    final content = RuntimeReligiousShareContentT0243.fromPublishedRecord(
      record: _editorialDua().toGovernedRecord(),
      locale: ShareContentLocaleT0243.en,
    );

    await tester.pumpWidget(
      _app(locale: const Locale('en'), content: content),
    );
    await tester.pumpAndSettle();

    final card = tester.widget<RuntimeReligiousShareCardT0243>(
      find.byType(RuntimeReligiousShareCardT0243),
    );
    expect(card.content.requiresGeneralDuaLabel, isTrue);
    expect(find.text('General Dua'), findsOneWidget);
  });
}
