import 'dart:typed_data';

import 'package:flutter/foundation.dart';
import 'package:flutter/services.dart';
import 'package:islami_hayat/features/share/domain/share_canvas_layout_t0242.dart';

enum ShareDestinationT0251 {
  instagramStory,
  whatsapp,
  general,
}

enum ShareLaunchStatusT0251 {
  launched,
  packageUnavailable,
}

final class SharePngRequestT0251 {
  SharePngRequestT0251({
    required this.pngBytes,
    required this.format,
    required this.destination,
  }) {
    validate();
  }

  static const int maxPngBytes = 16 * 1024 * 1024;
  static const List<int> _pngSignature = <int>[
    0x89,
    0x50,
    0x4E,
    0x47,
    0x0D,
    0x0A,
    0x1A,
    0x0A,
  ];

  final Uint8List pngBytes;
  final ShareCanvasFormatT0242 format;
  final ShareDestinationT0251 destination;

  void validate() {
    if (pngBytes.length < _pngSignature.length ||
        pngBytes.length > maxPngBytes) {
      throw StateError('T0251 requires a bounded PNG payload.');
    }
    for (var index = 0; index < _pngSignature.length; index += 1) {
      if (pngBytes[index] != _pngSignature[index]) {
        throw StateError('T0251 share payload must be a PNG file.');
      }
    }

    switch (destination) {
      case ShareDestinationT0251.instagramStory:
        if (format != ShareCanvasFormatT0242.instagramStory916) {
          throw StateError(
            'T0251 Instagram Story target accepts only the canonical 9:16 Story export.',
          );
        }
        return;
      case ShareDestinationT0251.whatsapp:
        if (format == ShareCanvasFormatT0242.instagramStory916) {
          throw StateError(
            'T0251 WhatsApp target must use Status 9:16, 4:5 or 1:1 output.',
          );
        }
        return;
      case ShareDestinationT0251.general:
        return;
    }
  }

  Map<String, Object> toChannelArguments() => <String, Object>{
        'pngBytes': pngBytes,
        'format': format.name,
        'destination': destination.name,
      };
}

abstract interface class AndroidShareNativeGatewayT0251 {
  Future<String?> sharePng(Map<String, Object> arguments);
}

final class MethodChannelAndroidShareNativeGatewayT0251
    implements AndroidShareNativeGatewayT0251 {
  MethodChannelAndroidShareNativeGatewayT0251({MethodChannel? channel})
      : _channel = channel ?? const MethodChannel('islami_hayat/share_t0251');

  final MethodChannel _channel;

  @override
  Future<String?> sharePng(Map<String, Object> arguments) =>
      _channel.invokeMethod<String>('sharePng', arguments);
}

final class AndroidShareSheetBridgeT0251 {
  AndroidShareSheetBridgeT0251({
    AndroidShareNativeGatewayT0251? gateway,
    TargetPlatform? platform,
  })  : _gateway = gateway ?? MethodChannelAndroidShareNativeGatewayT0251(),
        _platform = platform ?? defaultTargetPlatform;

  final AndroidShareNativeGatewayT0251 _gateway;
  final TargetPlatform _platform;

  Future<ShareLaunchStatusT0251> sharePng(SharePngRequestT0251 request) async {
    request.validate();
    if (_platform != TargetPlatform.android) {
      throw UnsupportedError('T0251 Android share sheet is Android-only.');
    }

    final result = await _gateway.sharePng(request.toChannelArguments());
    return switch (result) {
      'launched' => ShareLaunchStatusT0251.launched,
      'package_unavailable' => ShareLaunchStatusT0251.packageUnavailable,
      _ => throw StateError('T0251 native share bridge returned an invalid status.'),
    };
  }
}
