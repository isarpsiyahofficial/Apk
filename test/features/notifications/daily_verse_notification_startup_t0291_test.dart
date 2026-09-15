import 'package:flutter_test/flutter_test.dart';
import 'package:islami_hayat/features/notifications/data/daily_verse_notification_startup_t0291.dart';
import 'package:islami_hayat/features/notifications/domain/daily_verse_notification_t0291.dart';
import 'package:islami_hayat/features/notifications/domain/notification_preferences.dart';
import 'package:islami_hayat/features/quran/data/quran_search_repository.dart';
import 'package:islami_hayat/features/today/data/daily_verse_repository.dart';

void main() {
  test('T0291 startup reconciliation schedules enabled daily verse', () async {
    final scheduler = _Scheduler();
    final source = _Source();
    final store = _Store(
      const NotificationPreferences(
        dailyVerse: true,
        dailyVerseTime: NotificationTime(hour: 8, minute: 20),
      ),
    );
    final startup = _startup(
      store: store,
      scheduler: scheduler,
      source: source,
      now: DateTime(2026, 9, 10, 7),
    );

    await startup.reconcile(languageCode: 'en');

    expect(store.loadCount, 1);
    expect(source.languageCodes, ['en']);
    expect(scheduler.requests, hasLength(1));
    expect(
      scheduler.requests.single.scheduledAt,
      DateTime(2026, 9, 10, 8, 20),
    );
  });

  test('T0291 startup reconciliation cancels opt-out without reading verse', () async {
    final scheduler = _Scheduler();
    final source = _Source();
    final store = _Store(const NotificationPreferences(dailyVerse: false));
    final startup = _startup(
      store: store,
      scheduler: scheduler,
      source: source,
      now: DateTime(2026, 9, 10, 7),
    );

    await startup.reconcile(languageCode: 'tr');

    expect(source.languageCodes, isEmpty);
    expect(scheduler.requests, isEmpty);
    expect(scheduler.cancelled, [dailyVerseNotificationIdT0291]);
  });

  test('T0291 unsupported device locale falls back to Turkish safely', () async {
    final scheduler = _Scheduler();
    final source = _Source();
    final store = _Store(const NotificationPreferences(dailyVerse: true));
    final startup = _startup(
      store: store,
      scheduler: scheduler,
      source: source,
      now: DateTime(2026, 9, 10, 7),
    );

    await startup.reconcile(languageCode: 'de');

    expect(source.languageCodes, ['tr']);
    expect(scheduler.requests, hasLength(1));
  });

  test('T0291 preference read failure does not schedule stale defaults', () async {
    final scheduler = _Scheduler();
    final source = _Source();
    final store = _ThrowingStore();
    final startup = _startup(
      store: store,
      scheduler: scheduler,
      source: source,
      now: DateTime(2026, 9, 10, 7),
    );

    await expectLater(
      startup.reconcile(languageCode: 'tr'),
      throwsStateError,
    );

    expect(source.languageCodes, isEmpty);
    expect(scheduler.requests, isEmpty);
    expect(scheduler.cancelled, isEmpty);
  });
}

DailyVerseNotificationStartupT0291 _startup({
  required NotificationPreferencesStore store,
  required _Scheduler scheduler,
  required _Source source,
  required DateTime now,
}) {
  final coordinator = DailyVerseNotificationCoordinatorT0291(
    dailyVerseDataSource: source,
    preferencesStore: store,
    scheduler: scheduler,
  );
  return DailyVerseNotificationStartupT0291(
    preferencesStore: store,
    orchestrator: DailyVerseNotificationOrchestratorT0291(
      coordinator: coordinator,
      now: () => now,
    ),
  );
}

final class _Store implements NotificationPreferencesStore {
  _Store(this.preferences);

  final NotificationPreferences preferences;
  int loadCount = 0;

  @override
  Future<NotificationPreferences> load() async {
    loadCount += 1;
    return preferences;
  }

  @override
  Future<void> save(NotificationPreferences preferences) async {}
}

final class _ThrowingStore implements NotificationPreferencesStore {
  @override
  Future<NotificationPreferences> load() async =>
      throw StateError('tampered notification preference payload');

  @override
  Future<void> save(NotificationPreferences preferences) async {}
}

final class _Source implements DailyVerseDataSource {
  final List<String> languageCodes = <String>[];

  @override
  Future<DailyVerse> forDate({
    required DateTime date,
    required String languageCode,
  }) async {
    languageCodes.add(languageCode);
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
