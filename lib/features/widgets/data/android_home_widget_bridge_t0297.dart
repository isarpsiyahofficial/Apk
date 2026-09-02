import 'package:flutter/services.dart';
import 'package:flutter/foundation.dart';
import 'package:islami_hayat/features/widgets/domain/home_widget_content_t0297.dart';

final class AndroidHomeWidgetBridgeT0297 {
  AndroidHomeWidgetBridgeT0297({MethodChannel? channel})
      : _channel = channel ?? const MethodChannel('islami_hayat/home_widget');

  final MethodChannel _channel;

  Future<bool> persistSnapshot(HomeWidgetSnapshotT0297 snapshot) async {
    if (defaultTargetPlatform != TargetPlatform.android) {
      return false;
    }
    final result = await _channel.invokeMethod<bool>('updateWidget', <String, Object>{
      'languageCode': snapshot.languageCode,
      'verseArabic': snapshot.verse.arabic,
      'verseTranslation': snapshot.verse.translation,
      'duaText': snapshot.duaText,
      'proVisualsEnabled': snapshot.proVisualsEnabled,
    });
    return result ?? false;
  }
}
