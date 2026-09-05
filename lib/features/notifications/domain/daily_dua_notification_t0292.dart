import 'package:islami_hayat/features/dua/data/dua_content.dart';
import 'package:islami_hayat/features/dua/data/dua_library_repository.dart';
import 'package:islami_hayat/features/notifications/domain/daily_verse_notification_t0291.dart';
import 'package:islami_hayat/features/notifications/domain/notification_preferences.dart';

const int dailyDuaNotificationIdT0292 = 2902;
const int dailyDuaDefaultHourT0292 = 10;
const String notificationDuaDeepLinkHostT0292 = 'dua';

/// Daily-dua source backed only by a [DuaLibraryRepository].
///
/// The repository constructor rejects every record that has not passed the
/// production religious/source/language gates, so this selector cannot elevate
/// draft, partially reviewed, or source-incomplete content into a notification.
final class ReviewedDuaLibraryDailyDataSourceT0292 {
  const ReviewedDuaLibraryDailyDataSourceT0292(this.repository);

  final DuaLibraryRepository repository;

  DuaContent forDate(DateTime civilDate) {
    final records = repository.all;
    if (records.isEmpty) {
      throw StateError('Daily dua requires at least one production-approved dua.');
    }
    final day = DateTime.utc(civilDate.year, civilDate.month, civilDate.day)
        .difference(DateTime.utc(2000, 1, 1))
        .inDays;
    return records[day % records.length];
  }
}

final class DailyDuaNotificationCoordinatorT0292 {
  const DailyDuaNotificationCoordinatorT0292({
    required ReviewedDuaLibraryDailyDataSourceT0292 dailyDuaDataSource,
    required NotificationPreferencesStore preferencesStore,
    required LocalNotificationSchedulerT0291 scheduler,
  })  : _dailyDuaDataSource = dailyDuaDataSource,
        _preferencesStore = preferencesStore,
        _scheduler = scheduler;

  final ReviewedDuaLibraryDailyDataSourceT0292 _dailyDuaDataSource;
  final NotificationPreferencesStore _preferencesStore;
  final LocalNotificationSchedulerT0291 _scheduler;

  Future<void> syncForDate({
    required DateTime civilDate,
    required DateTime scheduledAt,
    required String languageCode,
    NotificationPreferences? preferencesOverride,
  }) async {
    final preferences = preferencesOverride ?? await _preferencesStore.load();
    if (!preferences.dailyDua) {
      await _scheduler.cancel(dailyDuaNotificationIdT0292);
      return;
    }

    _validateLocale(languageCode);
    _validateSchedule(civilDate: civilDate, scheduledAt: scheduledAt);

    final dua = _dailyDuaDataSource.forDate(civilDate);
    if (!dua.canEnterProductionDataset) {
      throw StateError('Daily dua source returned non-production content.');
    }

    final copy = _copyFor(languageCode, dua.sourceStatus);
    await _scheduler.schedule(
      LocalNotificationRequestT0291(
        id: dailyDuaNotificationIdT0292,
        scheduledAt: scheduledAt,
        title: copy.title,
        // Intentionally do not copy/truncate sacred or devotional text into
        // the OS notification surface. The user opens the reviewed local record.
        body: copy.body,
        payload: '$notificationDeepLinkSchemeT0291://'
            '$notificationDuaDeepLinkHostT0292/${Uri.encodeComponent(dua.id)}',
      ),
    );
  }

  static void _validateLocale(String languageCode) {
    if (languageCode != 'tr' && languageCode != 'en' && languageCode != 'ar') {
      throw UnsupportedError(
        'Unsupported daily dua notification locale: $languageCode',
      );
    }
  }

  static void _validateSchedule({
    required DateTime civilDate,
    required DateTime scheduledAt,
  }) {
    final sameCivilDay = civilDate.year == scheduledAt.year &&
        civilDate.month == scheduledAt.month &&
        civilDate.day == scheduledAt.day;
    if (!sameCivilDay) {
      throw ArgumentError.value(
        scheduledAt,
        'scheduledAt',
        'Daily dua notification must be scheduled for the same civil date.',
      );
    }
  }

  static _DailyDuaNotificationCopy _copyFor(
    String languageCode,
    DuaSourceStatus status,
  ) {
    final source = switch ((languageCode, status)) {
      ('tr', DuaSourceStatus.quran) => 'Kur’an',
      ('tr', DuaSourceStatus.sahihHasanSunnah) => 'kaynaklı sünnet',
      ('tr', DuaSourceStatus.classicalTraditional) => 'klasik/geleneksel kaynak',
      ('tr', DuaSourceStatus.generalEditorial) => 'Genel Dua',
      ('en', DuaSourceStatus.quran) => 'Quran',
      ('en', DuaSourceStatus.sahihHasanSunnah) => 'sourced Sunnah',
      ('en', DuaSourceStatus.classicalTraditional) => 'classical/traditional source',
      ('en', DuaSourceStatus.generalEditorial) => 'General Dua',
      ('ar', DuaSourceStatus.quran) => 'القرآن',
      ('ar', DuaSourceStatus.sahihHasanSunnah) => 'السنة الموثقة',
      ('ar', DuaSourceStatus.classicalTraditional) => 'مصدر كلاسيكي/تراثي',
      ('ar', DuaSourceStatus.generalEditorial) => 'دعاء عام',
      _ => throw UnsupportedError('Unsupported daily dua notification locale.'),
    };

    return switch (languageCode) {
      'ar' => _DailyDuaNotificationCopy(
          title: 'دعاء اليوم',
          body: 'افتح دعاء اليوم المراجع محليًا. التصنيف: $source',
        ),
      'en' => _DailyDuaNotificationCopy(
          title: 'Dua of the day',
          body: 'Open today’s locally reviewed dua. Source class: $source',
        ),
      _ => _DailyDuaNotificationCopy(
          title: 'Günün Duası',
          body: 'Bugünün yerelde doğrulanmış duasını aç. Kaynak sınıfı: $source',
        ),
    };
  }
}

final class DailyDuaNotificationOrchestratorT0292 {
  const DailyDuaNotificationOrchestratorT0292({
    required DailyDuaNotificationCoordinatorT0292 coordinator,
    DateTime Function()? now,
    this.deliveryHour = dailyDuaDefaultHourT0292,
  })  : _coordinator = coordinator,
        _now = now ?? DateTime.now;

  final DailyDuaNotificationCoordinatorT0292 _coordinator;
  final DateTime Function() _now;
  final int deliveryHour;

  Future<void> sync({
    required String languageCode,
    required NotificationPreferences preferences,
  }) async {
    if (deliveryHour < 0 || deliveryHour > 23) {
      throw StateError('Daily dua delivery hour must be between 0 and 23.');
    }

    final now = _now();
    var civilDate = DateTime(now.year, now.month, now.day);
    var scheduledAt = DateTime(
      civilDate.year,
      civilDate.month,
      civilDate.day,
      deliveryHour,
    );
    if (!scheduledAt.isAfter(now)) {
      civilDate = civilDate.add(const Duration(days: 1));
      scheduledAt = DateTime(
        civilDate.year,
        civilDate.month,
        civilDate.day,
        deliveryHour,
      );
    }

    await _coordinator.syncForDate(
      civilDate: civilDate,
      scheduledAt: scheduledAt,
      languageCode: languageCode,
      preferencesOverride: preferences,
    );
  }
}

final class _DailyDuaNotificationCopy {
  const _DailyDuaNotificationCopy({required this.title, required this.body});

  final String title;
  final String body;
}
