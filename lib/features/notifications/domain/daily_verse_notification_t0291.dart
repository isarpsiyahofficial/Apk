import 'package:islami_hayat/features/notifications/domain/notification_preferences.dart';
import 'package:islami_hayat/features/today/data/daily_verse_repository.dart';

const int dailyVerseNotificationIdT0291 = 2901;

final class LocalNotificationRequestT0291 {
  const LocalNotificationRequestT0291({
    required this.id,
    required this.scheduledAt,
    required this.title,
    required this.body,
    required this.payload,
  });

  final int id;
  final DateTime scheduledAt;
  final String title;
  final String body;
  final String payload;
}

abstract interface class LocalNotificationSchedulerT0291 {
  Future<void> schedule(LocalNotificationRequestT0291 request);

  Future<void> cancel(int id);
}

final class DailyVerseNotificationCoordinatorT0291 {
  const DailyVerseNotificationCoordinatorT0291({
    required DailyVerseDataSource dailyVerseDataSource,
    required NotificationPreferencesStore preferencesStore,
    required LocalNotificationSchedulerT0291 scheduler,
  })  : _dailyVerseDataSource = dailyVerseDataSource,
        _preferencesStore = preferencesStore,
        _scheduler = scheduler;

  final DailyVerseDataSource _dailyVerseDataSource;
  final NotificationPreferencesStore _preferencesStore;
  final LocalNotificationSchedulerT0291 _scheduler;

  Future<void> syncForDate({
    required DateTime civilDate,
    required DateTime scheduledAt,
    required String languageCode,
  }) async {
    final preferences = await _preferencesStore.load();
    if (!preferences.dailyVerse) {
      await _scheduler.cancel(dailyVerseNotificationIdT0291);
      return;
    }

    _validateLocale(languageCode);
    _validateSchedule(civilDate: civilDate, scheduledAt: scheduledAt);

    final verse = await _dailyVerseDataSource.forDate(
      date: civilDate,
      languageCode: languageCode,
    );

    final copy = _copyFor(languageCode, verse.sourceLabel);
    await _scheduler.schedule(
      LocalNotificationRequestT0291(
        id: dailyVerseNotificationIdT0291,
        scheduledAt: scheduledAt,
        title: copy.title,
        body: copy.body,
        payload: 'islami-hayat://quran/${verse.address.surah}/${verse.address.ayah}',
      ),
    );
  }

  static void _validateLocale(String languageCode) {
    if (languageCode != 'tr' && languageCode != 'en' && languageCode != 'ar') {
      throw UnsupportedError(
        'Unsupported daily verse notification locale: $languageCode',
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
        'Daily verse notification must be scheduled for the same civil date.',
      );
    }
  }

  static _DailyVerseNotificationCopy _copyFor(
    String languageCode,
    String sourceLabel,
  ) =>
      switch (languageCode) {
        'ar' => _DailyVerseNotificationCopy(
            title: 'آية اليوم',
            body: 'افتح آية اليوم من مصدر القرآن الموثّق: $sourceLabel',
          ),
        'en' => _DailyVerseNotificationCopy(
            title: 'Verse of the day',
            body: 'Open today’s verse from the verified Quran source: $sourceLabel',
          ),
        _ => _DailyVerseNotificationCopy(
            title: 'Günün Ayeti',
            body: 'Bugünün ayetini doğrulanmış Kur’an kaynağından aç: $sourceLabel',
          ),
      };
}

final class _DailyVerseNotificationCopy {
  const _DailyVerseNotificationCopy({
    required this.title,
    required this.body,
  });

  final String title;
  final String body;
}
