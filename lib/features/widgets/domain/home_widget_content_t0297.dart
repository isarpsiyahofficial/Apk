import 'package:islami_hayat/features/dua/data/dua_content.dart';
import 'package:islami_hayat/features/notifications/domain/notification_content_policy_t0296.dart';
import 'package:islami_hayat/features/today/data/daily_verse_repository.dart';

/// T0297 Android home-widget content contract.
///
/// Religious content itself is never a PRO-only value. PRO may only change the
/// visual presentation. The snapshot therefore carries reviewed/core content
/// plus a visual entitlement flag, while the religious payload remains the same.
final class HomeWidgetSnapshotT0297 {
  const HomeWidgetSnapshotT0297({
    required this.civilDateKey,
    required this.languageCode,
    required this.verse,
    required this.duaId,
    required this.duaText,
    required this.duaSourceStatus,
    required this.proVisualsEnabled,
  });

  /// Gregorian device-local civil date the religious daily selection belongs
  /// to. Native Android compares this key with its current local date and hides
  /// stale content rather than showing yesterday's ayet/dua indefinitely.
  final String civilDateKey;
  final String languageCode;
  final DailyVerse verse;
  final String duaId;
  final String duaText;
  final DuaSourceStatus duaSourceStatus;
  final bool proVisualsEnabled;

  NotificationContentExposureT0296 get contentExposure =>
      NotificationContentExposureT0296.teaserReferenceOnly;
}

abstract interface class HomeWidgetDailyDuaSourceT0297 {
  DuaContent forDate(DateTime civilDate);
}

final class HomeWidgetContentCoordinatorT0297 {
  const HomeWidgetContentCoordinatorT0297({
    required DailyVerseDataSource dailyVerseSource,
    required HomeWidgetDailyDuaSourceT0297 dailyDuaSource,
  })  : _dailyVerseSource = dailyVerseSource,
        _dailyDuaSource = dailyDuaSource;

  final DailyVerseDataSource _dailyVerseSource;
  final HomeWidgetDailyDuaSourceT0297 _dailyDuaSource;

  Future<HomeWidgetSnapshotT0297> buildSnapshot({
    required DateTime civilDate,
    required String languageCode,
    required bool hasLifetimePro,
  }) async {
    _validateLocale(languageCode);

    final verse = await _dailyVerseSource.forDate(
      date: civilDate,
      languageCode: languageCode,
    );
    final dua = _dailyDuaSource.forDate(civilDate);
    if (!dua.canEnterProductionDataset) {
      throw StateError('Home widget cannot expose non-production dua content.');
    }

    final duaText = switch (languageCode) {
      'tr' => dua.text.tr,
      'en' => dua.text.en,
      'ar' => dua.text.ar,
      _ => throw UnsupportedError('Unsupported home widget locale.'),
    };
    if (duaText.trim().isEmpty) {
      throw StateError('Home widget dua text cannot be empty.');
    }

    return HomeWidgetSnapshotT0297(
      civilDateKey: _civilDateKey(civilDate),
      languageCode: languageCode,
      verse: verse,
      duaId: dua.id,
      duaText: duaText,
      duaSourceStatus: dua.sourceStatus,
      proVisualsEnabled: hasLifetimePro,
    );
  }

  static String _civilDateKey(DateTime value) {
    String twoDigits(int part) => part.toString().padLeft(2, '0');
    return '${value.year.toString().padLeft(4, '0')}-${twoDigits(value.month)}-${twoDigits(value.day)}';
  }

  static void _validateLocale(String languageCode) {
    if (languageCode != 'tr' && languageCode != 'en' && languageCode != 'ar') {
      throw UnsupportedError('Unsupported home widget locale: $languageCode');
    }
  }
}
