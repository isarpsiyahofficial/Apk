import 'package:flutter/foundation.dart';
import 'package:flutter/services.dart';
import 'package:islami_hayat/features/widgets/domain/home_widget_content_t0297.dart';

/// Persistence boundary for the Android home-widget snapshot.
///
/// Keeping the sink abstract lets runtime synchronization be failure-path tested
/// without pretending a MethodChannel call succeeded on a non-Android host.
abstract interface class HomeWidgetSnapshotSinkT0297 {
  Future<bool> persistSnapshot(HomeWidgetSnapshotT0297 snapshot);
}

final class AndroidHomeWidgetBridgeT0297 implements HomeWidgetSnapshotSinkT0297 {
  AndroidHomeWidgetBridgeT0297({MethodChannel? channel})
      : _channel = channel ?? const MethodChannel('islami_hayat/home_widget');

  final MethodChannel _channel;

  @override
  Future<bool> persistSnapshot(HomeWidgetSnapshotT0297 snapshot) async {
    if (defaultTargetPlatform != TargetPlatform.android) {
      return false;
    }
    final result = await _channel.invokeMethod<bool>('updateWidget', <String, Object>{
      'civilDateKey': snapshot.civilDateKey,
      'languageCode': snapshot.languageCode,
      'verseArabic': snapshot.verse.arabic,
      'verseTranslation': snapshot.verse.translation ?? '',
      'duaText': snapshot.duaText,
      'proVisualsEnabled': snapshot.proVisualsEnabled,
    });
    return result ?? false;
  }
}
