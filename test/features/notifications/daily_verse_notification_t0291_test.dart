import 'package:flutter_test/flutter_test.dart';
import 'package:islami_hayat/features/notifications/domain/daily_verse_notification_t0291.dart';
import 'package:islami_hayat/features/notifications/domain/notification_preferences.dart';
import 'package:islami_hayat/features/quran/data/quran_search_repository.dart';
import 'package:islami_hayat/features/today/data/daily_verse_repository.dart';

final class _PreferencesStore implements NotificationPreferencesStore {
  _PreferencesStore(this.preferences);

  NotificationPreferences preferences;

  @override
  Future<NotificationPreferences> load() async => preferences;

  @override
  Future<void> save(NotificationPreferences preferences) async {
    this.preferences = preferences;
  }
}

final class _DailyVerseSource implements DailyVerseDataSource {
  int calls = 0;

  @override
  Future<DailyVerse> forDate({
    required DateTime date,
    required String languageCode,
  }) async {
    calls += 1;
    return const DailyVerse(
      address: QuranAddress(surah: 3, ayah: 159),
      arabic: 'trusted-arabic-from-canonical-source',
      translation: 'trusted-translation',
      surahDisplayName: 'Âl-i İmrân',
    );
  }
}

final class _Scheduler implements LocalNotificationSchedulerT0291 {
  final List<LocalNotificationRequestT0291> scheduled = [];
  final List<int> cancelled = [];

  @override
  Future<void> cancel(int id) async {
    cancelled.add(id);
  }

  @override
  Future<void> schedule(LocalNotificationRequestT0291 request) async {
    scheduled.add(request);
  }
}

void main() {
  test('T0291 opt-out cancels and never reads daily verse content', () async {
    final source = _DailyVerseSource();
    final scheduler = _Scheduler();
    final coordinator = DailyVerseNotificationCoordinatorT0291(
      dailyVerseDataSource: source,
      preferencesStore: _PreferencesStore(const NotificationPreferences()),
      scheduler: scheduler,
    );

    await coordinator.syncForDate(
      civilDate: DateTime(2026, 9, 2),
      scheduledAt: DateTime(2026, 9, 2, 9),
      languageCode: 'tr',
    );

    expect(source.calls, 0);
    expect(scheduler.scheduled, isEmpty);
    expect(scheduler.cancelled, [dailyVerseNotificationIdT0291]);
  });

  test('T0291 opt-in schedules canonical source deep-link without copied sacred text', () async {
    final source = _DailyVerseSource();
    final scheduler = _Scheduler();
    final coordinator = DailyVerseNotificationCoordinatorT0291(
      dailyVerseDataSource: source,
      preferencesStore: _PreferencesStore(
        const NotificationPreferences(dailyVerse: true),
      ),
      scheduler: scheduler,
    );

    await coordinator.syncForDate(
      civilDate: DateTime(2026, 9, 2),
      scheduledAt: DateTime(2026, 9, 2, 9),
      languageCode: 'tr',
    );

    expect(source.calls, 1);
    expect(scheduler.cancelled, isEmpty);
    expect(scheduler.scheduled, hasLength(1));
    final request = scheduler.scheduled.single;
    expect(request.id, dailyVerseNotificationIdT0291);
    expect(request.payload, 'islami-hayat://quran/3/159');
    expect(request.title, 'Günün Ayeti');
    expect(request.body, contains('Âl-i İmrân · 3:159'));
    expect(request.body, isNot(contains('trusted-arabic-from-canonical-source')));
    expect(request.body, isNot(contains('trusted-translation')));
  });

  test('T0291 EN and AR copy keeps verified source label', () async {
    for (final locale in ['en', 'ar']) {
      final scheduler = _Scheduler();
      final coordinator = DailyVerseNotificationCoordinatorT0291(
        dailyVerseDataSource: _DailyVerseSource(),
        preferencesStore: _PreferencesStore(
          const NotificationPreferences(dailyVerse: true),
        ),
        scheduler: scheduler,
      );

      await coordinator.syncForDate(
        civilDate: DateTime(2026, 9, 2),
        scheduledAt: DateTime(2026, 9, 2, 9),
        languageCode: locale,
      );

      expect(scheduler.scheduled.single.body, contains('3:159'));
      expect(scheduler.scheduled.single.payload, 'islami-hayat://quran/3/159');
    }
  });

  test('T0291 rejects unsupported locale before reading religious content', () async {
    final source = _DailyVerseSource();
    final coordinator = DailyVerseNotificationCoordinatorT0291(
      dailyVerseDataSource: source,
      preferencesStore: _PreferencesStore(
        const NotificationPreferences(dailyVerse: true),
      ),
      scheduler: _Scheduler(),
    );

    await expectLater(
      coordinator.syncForDate(
        civilDate: DateTime(2026, 9, 2),
        scheduledAt: DateTime(2026, 9, 2, 9),
        languageCode: 'de',
      ),
      throwsA(isA<UnsupportedError>()),
    );
    expect(source.calls, 0);
  });

  test('T0291 rejects cross-day schedule to prevent stale daily verse', () async {
    final source = _DailyVerseSource();
    final coordinator = DailyVerseNotificationCoordinatorT0291(
      dailyVerseDataSource: source,
      preferencesStore: _PreferencesStore(
        const NotificationPreferences(dailyVerse: true),
      ),
      scheduler: _Scheduler(),
    );

    await expectLater(
      coordinator.syncForDate(
        civilDate: DateTime(2026, 9, 2),
        scheduledAt: DateTime(2026, 9, 3, 9),
        languageCode: 'tr',
      ),
      throwsA(isA<ArgumentError>()),
    );
    expect(source.calls, 0);
  });
}
