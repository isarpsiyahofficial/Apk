import 'package:flutter/rendering.dart';
import 'package:flutter/widgets.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:islami_hayat/features/quran/data/canonical_quran_source.dart';
import 'package:islami_hayat/features/share/domain/runtime_religious_content_t0243.dart';
import 'package:islami_hayat/features/share/domain/share_canvas_layout_t0242.dart';
import 'package:islami_hayat/features/share/presentation/long_quran_share_t0248.dart';

void main() {
  TestWidgetsFlutterBinding.ensureInitialized();

  Future<RuntimeReligiousShareContentT0243> arabicLongAyah() async {
    final dataset = await CanonicalQuranAssetLoader().load();
    return RuntimeReligiousShareContentT0243.fromCanonicalQuranAyah(
      dataset.ayah(2, 282),
    );
  }

  testWidgets(
    'T0249 Arabic pagination preserves RTL words and exact canonical text',
    (tester) async {
      final content = await arabicLongAyah();
      const paginator = QuranLongTextPaginatorT0248();

      for (final format in ShareCanvasFormatT0242.values) {
        final pages = paginator.paginate(
          content: content,
          format: format,
          textDirection: TextDirection.rtl,
        );

        expect(pages, isNotEmpty, reason: format.name);
        expect(
          pages.map((page) => page.text).join(),
          content.text,
          reason: '${format.name} must preserve canonical Arabic exactly',
        );

        for (var index = 0; index < pages.length - 1; index++) {
          expect(
            RegExp(r'\s$').hasMatch(pages[index].text),
            isTrue,
            reason: '${format.name} page $index must end at a word boundary',
          );
          expect(
            RegExp(r'^\s').hasMatch(pages[index + 1].text),
            isFalse,
            reason: '${format.name} next page must start with the next word',
          );
        }
      }
    },
  );

  testWidgets(
    'T0249 Arabic page text renders RTL without truncation in every format',
    (tester) async {
      final content = await arabicLongAyah();
      const paginator = QuranLongTextPaginatorT0248();

      for (final format in ShareCanvasFormatT0242.values) {
        final pages = paginator.paginate(
          content: content,
          format: format,
          textDirection: TextDirection.rtl,
        );

        for (final page in pages) {
          await tester.pumpWidget(
            Directionality(
              textDirection: TextDirection.rtl,
              child: Align(
                alignment: Alignment.topLeft,
                child: SizedBox(
                  width: 360,
                  child: QuranSharePageCardT0248(
                    format: format,
                    background: const SizedBox.expand(),
                    content: content,
                    page: page,
                  ),
                ),
              ),
            ),
          );

          final textFinder = find.byKey(
            ValueKey('t0248-quran-page-text-${page.pageIndex}'),
          );
          expect(textFinder, findsOneWidget);
          final paragraph = tester.renderObject<RenderParagraph>(textFinder);
          expect(paragraph.textDirection, TextDirection.rtl);
          expect(paragraph.maxLines, isNull);
          expect(paragraph.overflow, TextOverflow.clip);
          expect(tester.takeException(), isNull, reason: format.name);
        }
      }
    },
  );

  testWidgets(
    'T0249 Arabic text and locked source remain inside format safe areas',
    (tester) async {
      final content = await arabicLongAyah();
      const paginator = QuranLongTextPaginatorT0248();

      for (final format in ShareCanvasFormatT0242.values) {
        final layout = ShareCanvasLayoutT0242.forFormat(format)..validate();
        final pages = paginator.paginate(
          content: content,
          format: format,
          textDirection: TextDirection.rtl,
        );

        for (final page in pages) {
          await tester.pumpWidget(
            Directionality(
              textDirection: TextDirection.rtl,
              child: Align(
                alignment: Alignment.topLeft,
                child: SizedBox(
                  width: 360,
                  child: QuranSharePageCardT0248(
                    format: format,
                    background: const SizedBox.expand(),
                    content: content,
                    page: page,
                  ),
                ),
              ),
            ),
          );

          final canvas = tester.getRect(find.byType(AspectRatio));
          final text = tester.getRect(
            find.byKey(ValueKey('t0248-quran-page-text-${page.pageIndex}')),
          );
          final source = tester.getRect(
            find.byKey(ValueKey('t0248-locked-source-${page.pageIndex}')),
          );
          final safeLeft = canvas.left +
              (canvas.width * layout.safeHorizontalFraction);
          final safeRight = canvas.right -
              (canvas.width * layout.safeHorizontalFraction);
          final safeTop = canvas.top + (canvas.height * layout.safeTopFraction);
          final safeBottom = canvas.bottom -
              (canvas.height * layout.safeBottomFraction);

          for (final rect in <Rect>[text, source]) {
            expect(rect.left, greaterThanOrEqualTo(safeLeft - 0.5));
            expect(rect.right, lessThanOrEqualTo(safeRight + 0.5));
            expect(rect.top, greaterThanOrEqualTo(safeTop - 0.5));
            expect(rect.bottom, lessThanOrEqualTo(safeBottom + 0.5));
          }
          expect(tester.takeException(), isNull, reason: format.name);
        }
      }
    },
  );
}
