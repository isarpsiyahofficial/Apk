import 'package:flutter_test/flutter_test.dart';
import 'package:islami_hayat/features/notifications/domain/daily_verse_notification_t0291.dart';
import 'package:islami_hayat/features/notifications/domain/notification_preferences.dart';
import 'package:islami_hayat/features/quran/data/quran_search_repository.dart';
import 'package:islami_hayat/features/today/data/daily_verse_repository.dart';

void main() {
  test('T0291 before 09:00 schedules the current civil day at 09:00', () async {
    final scheduler = _Scheduler();
    final source = _DailyVerseSource();
    final orchestrator = _orchestrator(
      scheduler: scheduler,
      source: source,
      now: DateTime(2026, 9, 2, 8, 15),
    );

    await orchestrator.sync(
      languageCode: 'tr',
      preferences: const NotificationPreferences(dailyVerse: true),
    );

    expect(source.requestedDates, [DateTime(2026, 9, 2)]);
    expect(scheduler.requests, hasLength(1));
    expect(scheduler.requests.single.scheduledAt, DateTime(2026, 9, 2, 9));
    expect(scheduler.requests.single.payload, 'islami-hayat://quran/3/159');
  });

  test('T0291 at/after 09:00 rolls to next civil day instead of stale schedule',
      () async {
    final scheduler = _Scheduler();
    final source = _DailyVerseSource();
    final orchestrator = _orchestrator(
      scheduler: scheduler,
      source: source,
      now: DateTime(2026, 9, 2, 9),
    );

    await orchestrator.sync(
      languageCode: 'en',
      preferences: const NotificationPreferences(dailyVerse: true),
    );

    expect(source.requestedDates, [DateTime(2026, 9, 3)]);
    expect(scheduler.requests.single.scheduledAt, DateTime(2026, 9, 3, 9));
  });

  test('T0291 opt-out cancels without reading religious content', () async {
    final scheduler = _Scheduler();
    final source = _DailyVerseSource();
    final orchestrator = _orchestrator(
      scheduler: scheduler,
      source: source,
      now: DateTime(2026, 9, 2, 7),
    );

    await orchestrator.sync(
      languageCode: 'ar',
      preferences: const NotificationPreferences(dailyVerse: false),
    );

    expect(source.requestedDates, isEmpty);
    expect(scheduler.requests, isEmpty);
    expect(scheduler.cancelled, [dailyVerseNotificationIdT0291]);
  });

  test('T0291 rejects invalid delivery hour before touching content', () async {
    final scheduler = _Scheduler();
    final source = _DailyVerseSource();
    final coordinator = DailyVerseNotificationCoordinatorT0291(
      dailyVerseDataSource: source,
      preferencesStore: _Store(),
      scheduler: scheduler,
    );
    final orchestrator = DailyVerseNotificationOrchestratorT0291(
      coordinator: coordinator,
      now: () => DateTime(2026, 9, 2, 7),
      deliveryHour: 24,
    );

    await expectLater(
      orchestrator.sync(
        languageCode: 'tr',
        preferences: const NotificationPreferences(dailyVerse: true),
      ),
      throwsStateError,
    );
    expect(source.requestedDates, isEmpty);
    expect(scheduler.requests, isEmpty);
  });
}

DailyVerseNotificationOrchestratorT0291 _orchestrator({
  required _Scheduler scheduler,
  required _DailyVerseSource source,
  required DateTime now,
}) {
  final coordinator = DailyVerseNotificationCoordinatorT0291(
    dailyVerseDataSource: source,
    preferencesStore: _Store(),
    scheduler: scheduler,
  );
  return DailyVerseNotificationOrchestratorT0291(
    coordinator: coordinator,
    now: () => now,
  );
}

final class _Store implements NotificationPreferencesStore {
  @override
  Future<NotificationPreferences> load() async =>
      const NotificationPreferences();

  @override
  Future<void> save(NotificationPreferences preferences) async {}
}

final class _DailyVerseSource implements DailyVerseDataSource {
  final List<DateTime> requestedDates = <DateTime>[];

  @override
  Future<DailyVerse> forDate({
    required DateTime date,
    required String languageCode,
  }) async {
    requestedDates.add(DateTime(date.year, date.month, date.day));
    return const DailyVerse(
      address: QuranAddress(surah: 3, ayah: 159),
      arabic: 'canonical-source-only',
      translation: 'verified-translation',
      surahDisplayName: 'Ali Imran',
    );
  }
}

final class _Scheduler implements LocalNotificationSchedulerT0291 {
  final List<LocalNotificationRequestT0291> requests =
      <LocalNotificationRequestT0291>[];
  final List<int> cancelled = <int>[];

  @override
  Future<void> cancel(int id) async => cancelled.add(id);

  @override
  Future<void> schedule(LocalNotificationRequestT0291 request) async =>
      requests.add(request);
}
