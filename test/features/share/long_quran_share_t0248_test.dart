import 'package:flutter/widgets.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:islami_hayat/features/quran/data/canonical_quran_source.dart';
import 'package:islami_hayat/features/share/domain/runtime_religious_content_t0243.dart';
import 'package:islami_hayat/features/share/domain/share_canvas_layout_t0242.dart';
import 'package:islami_hayat/features/share/domain/share_text_preferences_t0246.dart';
import 'package:islami_hayat/features/share/presentation/long_quran_share_t0248.dart';

void main() {
  TestWidgetsFlutterBinding.ensureInitialized();

  late RuntimeReligiousShareContentT0243 longestAyah;

  setUpAll(() async {
    final dataset = await CanonicalQuranAssetLoader().load();
    longestAyah = RuntimeReligiousShareContentT0243.fromCanonicalQuranAyah(
      dataset.ayah(2, 282),
    );
  });

  testWidgets('T0248 preserves the longest canonical ayah byte-for-byte', (
    tester,
  ) async {
    const paginator = QuranLongTextPaginatorT0248();

    for (final format in ShareCanvasFormatT0242.values) {
      final pages = paginator.paginate(
        content: longestAyah,
        format: format,
        textDirection: TextDirection.rtl,
      );

      expect(pages, isNotEmpty, reason: format.name);
      expect(
        pages.map((page) => page.text).join(),
        longestAyah.text,
        reason: '${format.name} must not truncate or rewrite Quran text',
      );
      expect(
        pages.every((page) => !page.text.contains('…')),
        isTrue,
        reason: '${format.name} must not introduce ellipsis',
      );
      for (var index = 0; index < pages.length; index++) {
        expect(pages[index].pageIndex, index);
        expect(pages[index].pageCount, pages.length);
      }
    }
  });

  testWidgets('T0248 square long ayah falls back to compact multi-card', (
    tester,
  ) async {
    const paginator = QuranLongTextPaginatorT0248();

    final pages = paginator.paginate(
      content: longestAyah,
      format: ShareCanvasFormatT0242.square11,
      textDirection: TextDirection.rtl,
      requestedPreferences: const ShareTextPreferencesT0246(
        fontSizePreset: ShareFontSizePresetT0246.large,
      ),
    );

    expect(pages.length, greaterThan(1));
    expect(
      pages.every(
        (page) =>
            page.textPreferences.fontSizePreset ==
            ShareFontSizePresetT0246.compact,
      ),
      isTrue,
    );
    expect(pages.map((page) => page.text).join(), longestAyah.text);
  });

  testWidgets('T0248 every generated card keeps the locked Quran source', (
    tester,
  ) async {
    const paginator = QuranLongTextPaginatorT0248();
    final pages = paginator.paginate(
      content: longestAyah,
      format: ShareCanvasFormatT0242.square11,
      textDirection: TextDirection.rtl,
    );

    for (final page in pages) {
      await tester.pumpWidget(
        Directionality(
          textDirection: TextDirection.rtl,
          child: SizedBox(
            width: 360,
            child: QuranSharePageCardT0248(
              format: ShareCanvasFormatT0242.square11,
              background: const SizedBox.expand(),
              content: longestAyah,
              page: page,
            ),
          ),
        ),
      );

      expect(find.text('Quran 2:282'), findsOneWidget);
      expect(
        find.byKey(ValueKey('t0248-locked-source-${page.pageIndex}')),
        findsOneWidget,
      );
      expect(find.text(page.text), findsOneWidget);
      expect(tester.takeException(), isNull);
    }
  });

  testWidgets('T0248 rejects invalid page coordinates before rendering', (
    tester,
  ) async {
    const invalidPage = QuranSharePageT0248(
      text: 'x',
      textPreferences: ShareTextPreferencesT0246(),
      pageIndex: 1,
      pageCount: 1,
    );

    await tester.pumpWidget(
      Directionality(
        textDirection: TextDirection.rtl,
        child: SizedBox(
          width: 360,
          child: QuranSharePageCardT0248(
            format: ShareCanvasFormatT0242.square11,
            background: const SizedBox.expand(),
            content: longestAyah,
            page: invalidPage,
          ),
        ),
      ),
    );

    expect(tester.takeException(), isA<StateError>());
  });
}
