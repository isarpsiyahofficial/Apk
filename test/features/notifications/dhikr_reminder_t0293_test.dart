import 'package:flutter_test/flutter_test.dart';
import 'package:islami_hayat/features/notifications/domain/daily_verse_notification_t0291.dart';
import 'package:islami_hayat/features/notifications/domain/dhikr_reminder_t0293.dart';
import 'package:islami_hayat/features/notifications/domain/notification_preferences.dart';

final class _Store implements NotificationPreferencesStore {
  _Store(this.value);
  NotificationPreferences value;

  @override
  Future<NotificationPreferences> load() async => value;

  @override
  Future<void> save(NotificationPreferences preferences) async => value = preferences;
}

final class _Scheduler implements LocalNotificationSchedulerT0291 {
  final scheduled = <LocalNotificationRequestT0291>[];
  final cancelled = <int>[];

  @override
  Future<void> schedule(LocalNotificationRequestT0291 request) async {
    scheduled.add(request);
  }

  @override
  Future<void> cancel(int id) async {
    cancelled.add(id);
  }
}

void main() {
  test('opt-out cancels dhikr reminder', () async {
    final scheduler = _Scheduler();
    final coordinator = DhikrReminderCoordinatorT0293(
      preferencesStore: _Store(const NotificationPreferences()),
      scheduler: scheduler,
    );

    await coordinator.syncForDate(
      civilDate: DateTime(2026, 9, 2),
      scheduledAt: DateTime(2026, 9, 2, 20),
      languageCode: 'tr',
    );

    expect(scheduler.cancelled, [dhikrReminderNotificationIdT0293]);
    expect(scheduler.scheduled, isEmpty);
  });

  test('enabled reminder carries no count, promise, or sacred text claim', () async {
    final scheduler = _Scheduler();
    final coordinator = DhikrReminderCoordinatorT0293(
      preferencesStore: _Store(
        const NotificationPreferences(dhikrReminder: true),
      ),
      scheduler: scheduler,
    );

    await coordinator.syncForDate(
      civilDate: DateTime(2026, 9, 2),
      scheduledAt: DateTime(2026, 9, 2, 20),
      languageCode: 'tr',
    );

    final request = scheduler.scheduled.single;
    expect(request.id, dhikrReminderNotificationIdT0293);
    expect(request.title, 'Zikir hatırlatıcısı');
    expect(request.payload, 'islami-hayat://dhikr');
    expect(request.body, isNot(contains(RegExp(r'\d'))));
    expect(request.body.toLowerCase(), isNot(contains('garanti')));
    expect(request.body.toLowerCase(), isNot(contains('sünnet')));
  });

  test('TR EN AR copies schedule and unsupported locale fails closed', () async {
    for (final languageCode in const ['tr', 'en', 'ar']) {
      final scheduler = _Scheduler();
      final coordinator = DhikrReminderCoordinatorT0293(
        preferencesStore: _Store(
          const NotificationPreferences(dhikrReminder: true),
        ),
        scheduler: scheduler,
      );
      await coordinator.syncForDate(
        civilDate: DateTime(2026, 9, 2),
        scheduledAt: DateTime(2026, 9, 2, 20),
        languageCode: languageCode,
      );
      expect(scheduler.scheduled, hasLength(1));
    }

    final coordinator = DhikrReminderCoordinatorT0293(
      preferencesStore: _Store(
        const NotificationPreferences(dhikrReminder: true),
      ),
      scheduler: _Scheduler(),
    );
    expect(
      () => coordinator.syncForDate(
        civilDate: DateTime(2026, 9, 2),
        scheduledAt: DateTime(2026, 9, 2, 20),
        languageCode: 'de',
      ),
      throwsUnsupportedError,
    );
  });

  test('stale-day schedule and invalid delivery hour fail closed', () async {
    final coordinator = DhikrReminderCoordinatorT0293(
      preferencesStore: _Store(
        const NotificationPreferences(dhikrReminder: true),
      ),
      scheduler: _Scheduler(),
    );

    expect(
      () => coordinator.syncForDate(
        civilDate: DateTime(2026, 9, 2),
        scheduledAt: DateTime(2026, 9, 3, 20),
        languageCode: 'en',
      ),
      throwsArgumentError,
    );

    expect(
      () => DhikrReminderOrchestratorT0293(
        coordinator: coordinator,
        now: () => DateTime(2026, 9, 2, 8),
        deliveryHour: 24,
      ).sync(
        languageCode: 'en',
        preferences: const NotificationPreferences(dhikrReminder: true),
      ),
      throwsStateError,
    );
  });

  test('orchestrator rolls over after delivery hour', () async {
    final scheduler = _Scheduler();
    final coordinator = DhikrReminderCoordinatorT0293(
      preferencesStore: _Store(
        const NotificationPreferences(dhikrReminder: true),
      ),
      scheduler: scheduler,
    );

    await DhikrReminderOrchestratorT0293(
      coordinator: coordinator,
      now: () => DateTime(2026, 9, 2, 20, 30),
    ).sync(
      languageCode: 'ar',
      preferences: const NotificationPreferences(dhikrReminder: true),
    );

    expect(scheduler.scheduled.single.scheduledAt, DateTime(2026, 9, 3, 20));
    expect(scheduler.scheduled.single.title, 'تذكير الذكر');
  });
}
