import 'package:flutter/widgets.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:islami_hayat/features/quran/data/canonical_quran_source.dart';
import 'package:islami_hayat/features/share/domain/runtime_religious_content_t0243.dart';
import 'package:islami_hayat/features/share/domain/share_canvas_layout_t0242.dart';
import 'package:islami_hayat/features/share/domain/share_readability_t0247.dart';
import 'package:islami_hayat/features/share/presentation/long_quran_share_t0248.dart';
import 'package:islami_hayat/features/share/presentation/share_raster_exporter_t0242.dart';

void main() {
  TestWidgetsFlutterBinding.ensureInitialized();

  late RuntimeReligiousShareContentT0243 longestAyah;

  setUpAll(() async {
    final dataset = await CanonicalQuranAssetLoader().load();
    longestAyah = RuntimeReligiousShareContentT0243.fromCanonicalQuranDataset(
      dataset: dataset,
      sura: 2,
      ayah: 282,
    );
  });

  testWidgets(
    'canonical Arabic Quran raster export is lossless and exact in every release format',
    (tester) async {
      const paginator = QuranLongTextPaginatorT0248();
      const exporter = ShareRasterExporterT0242();
      const readabilityPolicy = ShareReadabilityPolicyT0247();
      final readabilityDecision = readabilityPolicy.evaluate(
        backgroundSamples: const <Color>[Color(0xFFF7F2E8)],
      );

      for (final format in ShareCanvasFormatT0242.values) {
        final layout = ShareCanvasLayoutT0242.forFormat(format)..validate();
        final pages = paginator.paginate(
          content: longestAyah,
          format: format,
          textDirection: TextDirection.rtl,
        );

        expect(pages, isNotEmpty, reason: format.name);
        expect(
          pages.map((page) => page.text).join(),
          longestAyah.text,
          reason: '${format.name} must preserve canonical Quran text exactly',
        );

        for (final page in pages) {
          final boundaryKey = GlobalKey();
          await tester.pumpWidget(
            Directionality(
              textDirection: TextDirection.rtl,
              child: Center(
                child: SizedBox(
                  width: 270,
                  child: RepaintBoundary(
                    key: boundaryKey,
                    child: QuranSharePageCardT0248(
                      format: format,
                      background: const ColoredBox(
                        color: Color(0xFFF7F2E8),
                      ),
                      content: longestAyah,
                      page: page,
                      readabilityDecision: readabilityDecision,
                    ),
                  ),
                ),
              ),
            ),
          );
          await tester.pump();

          final textFinder = find.byKey(
            ValueKey('t0248-quran-page-text-${page.pageIndex}'),
          );
          final sourceFinder = find.byKey(
            ValueKey('t0248-locked-source-${page.pageIndex}'),
          );
          expect(textFinder, findsOneWidget, reason: format.name);
          expect(sourceFinder, findsOneWidget, reason: format.name);
          expect(find.text(page.text), findsOneWidget, reason: format.name);
          expect(find.text('Quran 2:282'), findsOneWidget, reason: format.name);

          final raster = await tester.runAsync(
            () => exporter.exportPng(
              repaintBoundaryKey: boundaryKey,
              format: format,
              readabilityDecision: readabilityDecision,
            ),
          );
          expect(raster, isNotNull, reason: format.name);
          expect(raster!.pixelWidth, layout.pixelWidth, reason: format.name);
          expect(raster.pixelHeight, layout.pixelHeight, reason: format.name);
          expect(
            raster.pngBytes.take(8).toList(),
            <int>[137, 80, 78, 71, 13, 10, 26, 10],
            reason: format.name,
          );
          expect(tester.takeException(), isNull, reason: format.name);
        }
      }
    },
  );
}
