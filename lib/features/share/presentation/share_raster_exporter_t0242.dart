import 'dart:typed_data';
import 'dart:ui' as ui;

import 'package:flutter/rendering.dart';
import 'package:flutter/widgets.dart';
import 'package:islami_hayat/features/share/domain/share_canvas_layout_t0242.dart';
import 'package:islami_hayat/features/share/domain/share_motion_policy_t0252.dart';
import 'package:islami_hayat/features/share/domain/share_readability_t0247.dart';

class ShareRasterExportResultT0242 {
  const ShareRasterExportResultT0242({
    required this.format,
    required this.pngBytes,
    required this.pixelWidth,
    required this.pixelHeight,
  });

  final ShareCanvasFormatT0242 format;
  final Uint8List pngBytes;
  final int pixelWidth;
  final int pixelHeight;
}

class ShareRasterExporterT0242 {
  const ShareRasterExporterT0242();

  Future<ShareRasterExportResultT0242> exportPng({
    required GlobalKey repaintBoundaryKey,
    required ShareCanvasFormatT0242 format,
    required ShareReadabilityDecisionT0247 readabilityDecision,
    ShareExportModeT0252 exportMode = ShareExportModeT0252.stillImage,
  }) async {
    // T0252 is enforced at the production export boundary, not only in the UI
    // or in a standalone feature-policy test. V1 is intentionally still-image
    // only; a forged/direct Reels export request must fail before raster work.
    ShareMotionPolicyT0252.v1.requireExportAllowed(exportMode);

    // T0247 is an export gate, not only a preview hint. Every production raster
    // export must carry the exact readability decision that was used by the
    // renderer, and an unreadable candidate must fail before any PNG bytes are
    // produced.
    readabilityDecision.requireExportable();

    final layout = ShareCanvasLayoutT0242.forFormat(format)..validate();
    final context = repaintBoundaryKey.currentContext;
    if (context == null) {
      throw StateError('T0242 export boundary is not mounted.');
    }

    final renderObject = context.findRenderObject();
    if (renderObject is! RenderRepaintBoundary) {
      throw StateError('T0242 export key must point to a RepaintBoundary.');
    }

    final logicalSize = renderObject.size;
    if (!logicalSize.width.isFinite ||
        !logicalSize.height.isFinite ||
        logicalSize.width <= 0 ||
        logicalSize.height <= 0) {
      throw StateError('T0242 export boundary must have a finite positive size.');
    }

    final widthRatio = layout.pixelWidth / logicalSize.width;
    final heightRatio = layout.pixelHeight / logicalSize.height;
    const ratioTolerance = 0.0001;
    if ((widthRatio - heightRatio).abs() > ratioTolerance) {
      throw StateError(
        'T0242 export boundary aspect ratio does not match the canonical format.',
      );
    }

    final image = await renderObject.toImage(pixelRatio: widthRatio);
    try {
      if (image.width != layout.pixelWidth || image.height != layout.pixelHeight) {
        throw StateError(
          'T0242 raster output must exactly match the canonical pixel dimensions.',
        );
      }

      final byteData = await image.toByteData(format: ui.ImageByteFormat.png);
      if (byteData == null || byteData.lengthInBytes == 0) {
        throw StateError('T0242 PNG encoder returned an empty result.');
      }

      return ShareRasterExportResultT0242(
        format: format,
        pngBytes: byteData.buffer.asUint8List(
          byteData.offsetInBytes,
          byteData.lengthInBytes,
        ),
        pixelWidth: image.width,
        pixelHeight: image.height,
      );
    } finally {
      image.dispose();
    }
  }
}
