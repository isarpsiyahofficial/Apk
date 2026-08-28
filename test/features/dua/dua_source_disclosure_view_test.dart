import 'package:flutter/material.dart';
import 'package:flutter_localizations/flutter_localizations.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:islami_hayat/core/content/content_governance.dart';
import 'package:islami_hayat/features/dua/data/dua_content.dart';
import 'package:islami_hayat/features/dua/presentation/dua_source_disclosure_view.dart';
import 'package:islami_hayat/l10n/app_localizations.dart';

const _text = LocalizedReligiousText(
  tr: 'Doğrulanmış dua metni',
  en: 'Verified dua text',
  ar: 'نص دعاء موثق',
);

const _dispute = LocalizedReligiousText(
  tr: 'Kaynak değerlendirmesinde görüş farklılığı vardır.',
  en: 'There is a difference of assessment regarding the source.',
  ar: 'يوجد اختلاف في تقييم المصدر.',
);

SourceReference _source(ReligiousSourceClass sourceClass) => SourceReference(
  id: 'fixture-source',
  title: 'Fixture source',
  sourceClass: sourceClass,
  licenseId: 'fixture-license',
);

DuaContent _dua(
  DuaSourceStatus sourceStatus, {
  bool disputed = false,
}) => DuaContent(
  id: 'fixture-dua',
  sourceStatus: sourceStatus,
  lengthClass: DuaLengthClass.short,
  categories: const {DuaCategory.morning},
  text: _text,
  reviewStatus: ContentReviewStatus.published,
  version: 1,
  lastReviewedAt: DateTime.utc(2026, 8, 28),
  sources: [
    _source(
      switch (sourceStatus) {
        DuaSourceStatus.quran => ReligiousSourceClass.quran,
        DuaSourceStatus.sahihHasanSunnah =>
          ReligiousSourceClass.sahihHasanHadith,
        DuaSourceStatus.classicalTraditional =>
          ReligiousSourceClass.classicalTraditional,
        DuaSourceStatus.generalEditorial => ReligiousSourceClass.meaningBasedDua,
      },
    ),
  ],
  hadithReference: sourceStatus == DuaSourceStatus.sahihHasanSunnah
      ? 'fixture:1'
      : null,
  hadithGrade: sourceStatus == DuaSourceStatus.sahihHasanSunnah
      ? 'sahih'
      : null,
  hasSourceDispute: disputed,
  disputeNote: disputed ? _dispute : null,
);

Widget _app({required Locale locale, required DuaContent dua}) => MaterialApp(
  locale: locale,
  supportedLocales: AppLocalizations.supportedLocales,
  localizationsDelegates: const [
    AppLocalizations.delegate,
    GlobalMaterialLocalizations.delegate,
    GlobalWidgetsLocalizations.delegate,
    GlobalCupertinoLocalizations.delegate,
  ],
  home: Scaffold(
    body: Padding(
      padding: const EdgeInsets.all(16),
      child: DuaSourceDisclosureView(dua: dua),
    ),
  ),
);

void main() {
  testWidgets('general editorial dua always shows non-Quran non-hadith warning', (
    tester,
  ) async {
    await tester.pumpWidget(
      _app(
        locale: const Locale('tr'),
        dua: _dua(DuaSourceStatus.generalEditorial),
      ),
    );
    await tester.pumpAndSettle();

    expect(find.text('Genel Dua'), findsOneWidget);
    expect(find.text('Bu metin ayet veya hadis değildir.'), findsOneWidget);
    expect(find.text('Kur’an Duası'), findsNothing);
  });

  testWidgets('Quran dua has source badge without editorial warning', (
    tester,
  ) async {
    await tester.pumpWidget(
      _app(
        locale: const Locale('en'),
        dua: _dua(DuaSourceStatus.quran),
      ),
    );
    await tester.pumpAndSettle();

    expect(find.text('Qur’an Dua'), findsOneWidget);
    expect(
      find.text('This text is not a Qur’an verse or hadith.'),
      findsNothing,
    );
  });

  testWidgets('Arabic disclosure is RTL and uses Arabic dispute note', (
    tester,
  ) async {
    await tester.binding.setSurfaceSize(const Size(320, 700));
    addTearDown(() => tester.binding.setSurfaceSize(null));

    await tester.pumpWidget(
      _app(
        locale: const Locale('ar'),
        dua: _dua(DuaSourceStatus.classicalTraditional, disputed: true),
      ),
    );
    await tester.pumpAndSettle();

    expect(find.text('دعاء كلاسيكي أو تقليدي'), findsOneWidget);
    expect(find.text('ملاحظة حول المصدر'), findsOneWidget);
    expect(find.text(_dispute.ar), findsOneWidget);

    final directionality = tester.widget<Directionality>(
      find.byType(Directionality).first,
    );
    expect(directionality.textDirection, TextDirection.rtl);
    expect(tester.takeException(), isNull);
  });

  testWidgets('Sunnah source has distinct localized badge', (tester) async {
    await tester.pumpWidget(
      _app(
        locale: const Locale('en'),
        dua: _dua(DuaSourceStatus.sahihHasanSunnah),
      ),
    );
    await tester.pumpAndSettle();

    expect(find.text('Authentic/Hasan Sunnah Dua'), findsOneWidget);
    expect(
      find.text('This text is not a Qur’an verse or hadith.'),
      findsNothing,
    );
  });
}
