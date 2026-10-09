import 'package:flutter/widgets.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:islami_hayat/features/share/domain/share_canvas_layout_t0242.dart';
import 'package:islami_hayat/features/share/domain/share_readability_t0247.dart';
import 'package:islami_hayat/features/share/presentation/share_layout_renderer_t0242.dart';
import 'package:islami_hayat/features/share/presentation/share_raster_exporter_t0242.dart';

void main() {
  const readabilityPolicy = ShareReadabilityPolicyT0247();
  final readableDecision = readabilityPolicy.evaluate(
    backgroundSamples: const [Color(0xFFF7F2E8)],
  );

  test('T0242 pins canonical export dimensions for all required formats', () {
    final story = ShareCanvasLayoutT0242.forFormat(
      ShareCanvasFormatT0242.instagramStory916,
    );
    final status = ShareCanvasLayoutT0242.forFormat(
      ShareCanvasFormatT0242.whatsappStatus916,
    );
    final post = ShareCanvasLayoutT0242.forFormat(
      ShareCanvasFormatT0242.instagramPost45,
    );
    final square = ShareCanvasLayoutT0242.forFormat(
      ShareCanvasFormatT0242.square11,
    );

    expect((story.pixelWidth, story.pixelHeight), (1080, 1920));
    expect((status.pixelWidth, status.pixelHeight), (1080, 1920));
    expect((post.pixelWidth, post.pixelHeight), (1080, 1350));
    expect((square.pixelWidth, square.pixelHeight), (1080, 1080));
    expect(story.aspectRatio, closeTo(9 / 16, 0.000001));
    expect(post.aspectRatio, closeTo(4 / 5, 0.000001));
    expect(square.aspectRatio, 1);
  });

  test('Story and WhatsApp Status keep distinct platform-safe profiles', () {
    final story = ShareCanvasLayoutT0242.forFormat(
      ShareCanvasFormatT0242.instagramStory916,
    );
    final status = ShareCanvasLayoutT0242.forFormat(
      ShareCanvasFormatT0242.whatsappStatus916,
    );

    expect(story.safeBottomFraction, greaterThan(status.safeBottomFraction));
    expect(story.safeTopFraction, greaterThan(status.safeTopFraction));
    story.validate();
    status.validate();
  });

  testWidgets('renderer preserves 9:16 geometry on compact preview', (
    tester,
  ) async {
    const boundaryKey = ValueKey('t0242-boundary');

    await tester.pumpWidget(
      const Directionality(
        textDirection: TextDirection.ltr,
        child: Center(
          child: SizedBox(
            width: 270,
            child: ShareLayoutRendererT0242(
              format: ShareCanvasFormatT0242.instagramStory916,
              repaintBoundaryKey: boundaryKey,
              background: SizedBox.expand(),
              content: SizedBox.expand(),
            ),
          ),
        ),
      ),
    );

    final size = tester.getSize(find.byKey(boundaryKey));
    expect(size.width, 270);
    expect(size.height, closeTo(480, 0.01));
    expect(tester.takeException(), isNull);
  });

  testWidgets('renderer uses directional padding under Arabic RTL', (
    tester,
  ) async {
    await tester.pumpWidget(
      const Directionality(
        textDirection: TextDirection.rtl,
        child: SizedBox(
          width: 320,
          child: ShareLayoutRendererT0242(
            format: ShareCanvasFormatT0242.square11,
            background: SizedBox.expand(),
            content: Text('نص عربي'),
          ),
        ),
      ),
    );

    final padding = tester.widget<Padding>(find.byType(Padding));
    expect(padding.padding, isA<EdgeInsetsDirectional>());
    expect(tester.takeException(), isNull);
  });

  testWidgets('device-side exporter emits exact PNG pixels for all formats', (
    tester,
  ) async {
    const exporter = ShareRasterExporterT0242();

    for (final format in ShareCanvasFormatT0242.values) {
      final boundaryKey = GlobalKey();
      await tester.pumpWidget(
        Directionality(
          textDirection: TextDirection.ltr,
          child: Center(
            child: SizedBox(
              width: 270,
              child: ShareLayoutRendererT0242(
                format: format,
                repaintBoundaryKey: boundaryKey,
                readabilityDecision: readableDecision,
                background: const ColoredBox(color: Color(0xFFF7F2E8)),
                content: const Center(child: Text('Verified runtime text')),
              ),
            ),
          ),
        ),
      );
      await tester.pump();

      final expected = ShareCanvasLayoutT0242.forFormat(format);
      // RenderRepaintBoundary.toImage / ui.Image.toByteData complete on the real
      // engine event loop. Running this native raster work outside FakeAsync
      // prevents a false 10-minute widget-test timeout while preserving the
      // full 1080px production export and PNG encoder path.
      final result = await tester.runAsync(
        () => exporter.exportPng(
          repaintBoundaryKey: boundaryKey,
          format: format,
          readabilityDecision: readableDecision,
        ),
      );
      expect(result, isNotNull);
      final raster = result!;

      expect(raster.format, format);
      expect(raster.pixelWidth, expected.pixelWidth);
      expect(raster.pixelHeight, expected.pixelHeight);
      expect(raster.pngBytes.length, greaterThan(8));
      expect(
        raster.pngBytes.take(8).toList(),
        <int>[137, 80, 78, 71, 13, 10, 26, 10],
      );
      expect(tester.takeException(), isNull);
    }
  });

  testWidgets('exporter fails closed when boundary is not mounted', (
    tester,
  ) async {
    const exporter = ShareRasterExporterT0242();
    final boundaryKey = GlobalKey();

    await tester.pumpWidget(const SizedBox());

    await expectLater(
      exporter.exportPng(
        repaintBoundaryKey: boundaryKey,
        format: ShareCanvasFormatT0242.instagramStory916,
        readabilityDecision: readableDecision,
      ),
      throwsA(
        isA<StateError>().having(
          (error) => error.message,
          'message',
          contains('not mounted'),
        ),
      ),
    );
  });

  testWidgets('exporter rejects a boundary with the wrong aspect ratio', (
    tester,
  ) async {
    const exporter = ShareRasterExporterT0242();
    final boundaryKey = GlobalKey();

    await tester.pumpWidget(
      Directionality(
        textDirection: TextDirection.ltr,
        child: Center(
          child: RepaintBoundary(
            key: boundaryKey,
            child: const SizedBox(width: 200, height: 200),
          ),
        ),
      ),
    );

    await expectLater(
      exporter.exportPng(
        repaintBoundaryKey: boundaryKey,
        format: ShareCanvasFormatT0242.instagramStory916,
        readabilityDecision: readableDecision,
      ),
      throwsA(
        isA<StateError>().having(
          (error) => error.message,
          'message',
          contains('aspect ratio'),
        ),
      ),
    );
  });

  test('all production layout profiles pass the fail-closed validator', () {
    for (final format in ShareCanvasFormatT0242.values) {
      expect(
        () => ShareCanvasLayoutT0242.forFormat(format).validate(),
        returnsNormally,
      );
    }
  });
}
