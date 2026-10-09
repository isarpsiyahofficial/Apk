import 'package:flutter_test/flutter_test.dart';
import 'package:islami_hayat/core/content/content_governance.dart';
import 'package:islami_hayat/features/dua/data/dua_content.dart';
import 'package:islami_hayat/features/dua/data/dua_library_repository.dart';
import 'package:islami_hayat/features/notifications/data/daily_dua_notification_startup_t0292.dart';
import 'package:islami_hayat/features/notifications/domain/daily_dua_notification_t0292.dart';
import 'package:islami_hayat/features/notifications/domain/daily_verse_notification_t0291.dart';
import 'package:islami_hayat/features/notifications/domain/notification_preferences.dart';

final class _Store implements NotificationPreferencesStore {
  _Store(this.value);
  NotificationPreferences value;
  @override
  Future<NotificationPreferences> load() async => value;
  @override
  Future<void> save(NotificationPreferences preferences) async => value = preferences;
}

final class _ThrowingStore implements NotificationPreferencesStore {
  @override
  Future<NotificationPreferences> load() =>
      Future<NotificationPreferences>.error(const FormatException('corrupt prefs'));
  @override
  Future<void> save(NotificationPreferences preferences) async {}
}

final class _Scheduler implements LocalNotificationSchedulerT0291 {
  final scheduled = <LocalNotificationRequestT0291>[];
  final cancelled = <int>[];
  @override
  Future<void> schedule(LocalNotificationRequestT0291 request) async => scheduled.add(request);
  @override
  Future<void> cancel(int id) async => cancelled.add(id);
}

DuaContent _reviewedDua(String id) => DuaContent(
      id: id,
      sourceStatus: DuaSourceStatus.quran,
      lengthClass: DuaLengthClass.short,
      categories: const {DuaCategory.morning},
      text: const LocalizedReligiousText(tr: 'TR', en: 'EN', ar: 'AR'),
      reviewStatus: ContentReviewStatus.published,
      version: 1,
      lastReviewedAt: DateTime.utc(2026, 8, 28),
      sources: const [
        SourceReference(
          id: 'quran-fixture',
          title: 'Quran fixture',
          sourceClass: ReligiousSourceClass.quran,
          licenseId: 'fixture-license',
        ),
      ],
    );

DailyDuaNotificationCoordinatorT0292 _coordinator({
  required NotificationPreferencesStore store,
  required _Scheduler scheduler,
}) =>
    DailyDuaNotificationCoordinatorT0292(
      dailyDuaDataSource: ReviewedDuaLibraryDailyDataSourceT0292(
        DuaLibraryRepository([_reviewedDua('dua-1')]),
      ),
      preferencesStore: store,
      scheduler: scheduler,
    );

void main() {
  test('opt-out cancels without reading daily dua dataset', () async {
    final scheduler = _Scheduler();
    final emptySource = ReviewedDuaLibraryDailyDataSourceT0292(
      DuaLibraryRepository(const []),
    );
    final coordinator = DailyDuaNotificationCoordinatorT0292(
      dailyDuaDataSource: emptySource,
      preferencesStore: _Store(const NotificationPreferences()),
      scheduler: scheduler,
    );

    await coordinator.syncForDate(
      civilDate: DateTime(2026, 9, 2),
      scheduledAt: DateTime(2026, 9, 2, 10),
      languageCode: 'tr',
    );

    expect(scheduler.cancelled, [dailyDuaNotificationIdT0292]);
    expect(scheduler.scheduled, isEmpty);
  });

  test('enabled daily dua schedules reviewed record without copying dua text', () async {
    final scheduler = _Scheduler();
    final coordinator = _coordinator(
      store: _Store(const NotificationPreferences(dailyDua: true)),
      scheduler: scheduler,
    );

    await coordinator.syncForDate(
      civilDate: DateTime(2026, 9, 2),
      scheduledAt: DateTime(2026, 9, 2, 10),
      languageCode: 'en',
    );

    final request = scheduler.scheduled.single;
    expect(request.id, dailyDuaNotificationIdT0292);
    expect(request.title, 'Dua of the day');
    expect(request.body, contains('Source class: Quran'));
    expect(request.body, isNot(contains('EN')));
    expect(request.payload, 'islami-hayat://dua/dua-1');
  });

  test('unsupported locale and stale-day schedules fail closed', () async {
    final coordinator = _coordinator(
      store: _Store(const NotificationPreferences(dailyDua: true)),
      scheduler: _Scheduler(),
    );

    expect(
      () => coordinator.syncForDate(
        civilDate: DateTime(2026, 9, 2),
        scheduledAt: DateTime(2026, 9, 2, 10),
        languageCode: 'de',
      ),
      throwsUnsupportedError,
    );
    expect(
      () => coordinator.syncForDate(
        civilDate: DateTime(2026, 9, 2),
        scheduledAt: DateTime(2026, 9, 3, 10),
        languageCode: 'tr',
      ),
      throwsArgumentError,
    );
  });

  test('orchestrator uses persisted daily dua hour and minute', () async {
    final scheduler = _Scheduler();
    final preferences = NotificationPreferences(
      dailyDua: true,
      dailyDuaTime: const NotificationTime(hour: 14, minute: 37),
    );
    final coordinator = _coordinator(
      store: _Store(preferences),
      scheduler: scheduler,
    );

    await DailyDuaNotificationOrchestratorT0292(
      coordinator: coordinator,
      now: () => DateTime(2026, 9, 2, 8),
    ).sync(languageCode: 'tr', preferences: preferences);

    expect(scheduler.scheduled.single.scheduledAt, DateTime(2026, 9, 2, 14, 37));
  });

  test('orchestrator rolls over after selected delivery minute', () async {
    final scheduler = _Scheduler();
    final preferences = NotificationPreferences(
      dailyDua: true,
      dailyDuaTime: const NotificationTime(hour: 10, minute: 15),
    );
    final coordinator = _coordinator(
      store: _Store(preferences),
      scheduler: scheduler,
    );

    await DailyDuaNotificationOrchestratorT0292(
      coordinator: coordinator,
      now: () => DateTime(2026, 9, 2, 10, 16),
    ).sync(languageCode: 'ar', preferences: preferences);

    expect(scheduler.scheduled.single.scheduledAt, DateTime(2026, 9, 3, 10, 15));
    expect(scheduler.scheduled.single.title, 'دعاء اليوم');
  });

  test('explicit test override validates both hour and minute', () async {
    final coordinator = _coordinator(
      store: _Store(const NotificationPreferences(dailyDua: true)),
      scheduler: _Scheduler(),
    );

    expect(
      () => DailyDuaNotificationOrchestratorT0292(
        coordinator: coordinator,
        now: () => DateTime(2026, 9, 2, 8),
        deliveryHour: 23,
        deliveryMinute: 60,
      ).sync(
        languageCode: 'tr',
        preferences: const NotificationPreferences(dailyDua: true),
      ),
      throwsStateError,
    );
  });

  test('startup reconciliation schedules persisted opt-in and locale fallback', () async {
    final scheduler = _Scheduler();
    final preferences = NotificationPreferences(
      dailyDua: true,
      dailyDuaTime: const NotificationTime(hour: 16, minute: 5),
    );
    final store = _Store(preferences);
    final startup = DailyDuaNotificationStartupT0292(
      preferencesStore: store,
      orchestrator: DailyDuaNotificationOrchestratorT0292(
        coordinator: _coordinator(store: store, scheduler: scheduler),
        now: () => DateTime(2026, 9, 2, 8),
      ),
    );

    await startup.reconcile(languageCode: 'de');

    final request = scheduler.scheduled.single;
    expect(request.scheduledAt, DateTime(2026, 9, 2, 16, 5));
    expect(request.title, 'Günün Duası');
  });

  test('startup opt-out cancels and corrupt preferences fail closed', () async {
    final scheduler = _Scheduler();
    final disabledStore = _Store(const NotificationPreferences(dailyDua: false));
    final disabledStartup = DailyDuaNotificationStartupT0292(
      preferencesStore: disabledStore,
      orchestrator: DailyDuaNotificationOrchestratorT0292(
        coordinator: _coordinator(store: disabledStore, scheduler: scheduler),
        now: () => DateTime(2026, 9, 2, 8),
      ),
    );

    await disabledStartup.reconcile(languageCode: 'en');
    expect(scheduler.cancelled, [dailyDuaNotificationIdT0292]);
    expect(scheduler.scheduled, isEmpty);

    final corruptStore = _ThrowingStore();
    final corruptScheduler = _Scheduler();
    final corruptStartup = DailyDuaNotificationStartupT0292(
      preferencesStore: corruptStore,
      orchestrator: DailyDuaNotificationOrchestratorT0292(
        coordinator: _coordinator(store: corruptStore, scheduler: corruptScheduler),
        now: () => DateTime(2026, 9, 2, 8),
      ),
    );

    await expectLater(
      corruptStartup.reconcile(languageCode: 'tr'),
      throwsFormatException,
    );
    expect(corruptScheduler.scheduled, isEmpty);
    expect(corruptScheduler.cancelled, isEmpty);
  });
}
