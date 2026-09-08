import 'dart:typed_data';

import 'package:flutter/foundation.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:islami_hayat/features/share/domain/share_canvas_layout_t0242.dart';
import 'package:islami_hayat/features/share/platform/android_share_sheet_t0251.dart';

void main() {
  group('T0251 Android share request policy', () {
    test('Instagram Story accepts only canonical 9:16 Story output', () {
      final request = SharePngRequestT0251(
        pngBytes: _png(),
        format: ShareCanvasFormatT0242.instagramStory916,
        destination: ShareDestinationT0251.instagramStory,
      );
      expect(request.format, ShareCanvasFormatT0242.instagramStory916);

      expect(
        () => SharePngRequestT0251(
          pngBytes: _png(),
          format: ShareCanvasFormatT0242.square11,
          destination: ShareDestinationT0251.instagramStory,
        ),
        throwsStateError,
      );
    });

    test('WhatsApp accepts Status/Post outputs but not Instagram Story preset', () {
      for (final format in <ShareCanvasFormatT0242>[
        ShareCanvasFormatT0242.whatsappStatus916,
        ShareCanvasFormatT0242.instagramPost45,
        ShareCanvasFormatT0242.square11,
      ]) {
        expect(
          () => SharePngRequestT0251(
            pngBytes: _png(),
            format: format,
            destination: ShareDestinationT0251.whatsapp,
          ),
          returnsNormally,
        );
      }

      expect(
        () => SharePngRequestT0251(
          pngBytes: _png(),
          format: ShareCanvasFormatT0242.instagramStory916,
          destination: ShareDestinationT0251.whatsapp,
        ),
        throwsStateError,
      );
    });

    test('invalid signature and oversized payload fail closed', () {
      expect(
        () => SharePngRequestT0251(
          pngBytes: Uint8List.fromList(List<int>.filled(16, 0)),
          format: ShareCanvasFormatT0242.square11,
          destination: ShareDestinationT0251.general,
        ),
        throwsStateError,
      );

      final oversized = Uint8List(SharePngRequestT0251.maxPngBytes + 1)
        ..setRange(0, 8, _png().take(8));
      expect(
        () => SharePngRequestT0251(
          pngBytes: oversized,
          format: ShareCanvasFormatT0242.square11,
          destination: ShareDestinationT0251.general,
        ),
        throwsStateError,
      );
    });

    test('native launched status is propagated with exact target arguments', () async {
      final gateway = _FakeGatewayT0251('launched');
      final result = await AndroidShareSheetBridgeT0251(
        gateway: gateway,
        platform: TargetPlatform.android,
      ).sharePng(
        SharePngRequestT0251(
          pngBytes: _png(),
          format: ShareCanvasFormatT0242.whatsappStatus916,
          destination: ShareDestinationT0251.whatsapp,
        ),
      );

      expect(result, ShareLaunchStatusT0251.launched);
      expect(gateway.lastArguments?['format'], 'whatsappStatus916');
      expect(gateway.lastArguments?['destination'], 'whatsapp');
      expect(gateway.lastArguments?['pngBytes'], isA<Uint8List>());
    });

    test('missing target package does not silently fall back to general share', () async {
      final result = await AndroidShareSheetBridgeT0251(
        gateway: _FakeGatewayT0251('package_unavailable'),
        platform: TargetPlatform.android,
      ).sharePng(
        SharePngRequestT0251(
          pngBytes: _png(),
          format: ShareCanvasFormatT0242.instagramStory916,
          destination: ShareDestinationT0251.instagramStory,
        ),
      );

      expect(result, ShareLaunchStatusT0251.packageUnavailable);
    });

    test('unknown native result fails closed', () {
      final bridge = AndroidShareSheetBridgeT0251(
        gateway: _FakeGatewayT0251('maybe'),
        platform: TargetPlatform.android,
      );

      expect(
        () => bridge.sharePng(
          SharePngRequestT0251(
            pngBytes: _png(),
            format: ShareCanvasFormatT0242.square11,
            destination: ShareDestinationT0251.general,
          ),
        ),
        throwsStateError,
      );
    });

    test('non-Android platform fails before native gateway invocation', () {
      final gateway = _FakeGatewayT0251('launched');
      final bridge = AndroidShareSheetBridgeT0251(
        gateway: gateway,
        platform: TargetPlatform.iOS,
      );

      expect(
        () => bridge.sharePng(
          SharePngRequestT0251(
            pngBytes: _png(),
            format: ShareCanvasFormatT0242.square11,
            destination: ShareDestinationT0251.general,
          ),
        ),
        throwsUnsupportedError,
      );
      expect(gateway.lastArguments, isNull);
    });
  });
}

final class _FakeGatewayT0251 implements AndroidShareNativeGatewayT0251 {
  _FakeGatewayT0251(this.result);

  final String? result;
  Map<String, Object>? lastArguments;

  @override
  Future<String?> sharePng(Map<String, Object> arguments) async {
    lastArguments = arguments;
    return result;
  }
}

Uint8List _png() => Uint8List.fromList(<int>[
      0x89,
      0x50,
      0x4E,
      0x47,
      0x0D,
      0x0A,
      0x1A,
      0x0A,
      0x00,
    ]);
