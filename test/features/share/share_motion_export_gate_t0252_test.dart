import 'package:flutter/widgets.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:islami_hayat/features/share/domain/share_canvas_layout_t0242.dart';
import 'package:islami_hayat/features/share/domain/share_motion_policy_t0252.dart';
import 'package:islami_hayat/features/share/domain/share_readability_t0247.dart';
import 'package:islami_hayat/features/share/presentation/share_raster_exporter_t0242.dart';

void main() {
  const readabilityPolicy = ShareReadabilityPolicyT0247();
  final readableDecision = readabilityPolicy.evaluate(
    backgroundSamples: const [Color(0xFFF7F2E8)],
  );

  test('T0252 production raster boundary rejects a direct Reels export request', () async {
    const exporter = ShareRasterExporterT0242();

    await expectLater(
      exporter.exportPng(
        repaintBoundaryKey: GlobalKey(),
        format: ShareCanvasFormatT0242.instagramStory916,
        readabilityDecision: readableDecision,
        exportMode: ShareExportModeT0252.reelsMotion,
      ),
      throwsA(
        isA<StateError>().having(
          (error) => error.message,
          'message',
          contains('Reels motion export is disabled in V1'),
        ),
      ),
    );
  });
}
