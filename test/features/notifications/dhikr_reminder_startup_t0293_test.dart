import 'package:flutter_test/flutter_test.dart';
import 'package:islami_hayat/features/notifications/data/dhikr_reminder_startup_t0293.dart';
import 'package:islami_hayat/features/notifications/domain/daily_verse_notification_t0291.dart';
import 'package:islami_hayat/features/notifications/domain/dhikr_reminder_t0293.dart';
import 'package:islami_hayat/features/notifications/domain/notification_preferences.dart';

final class _Store implements NotificationPreferencesStore {
  _Store(this.value);

  NotificationPreferences value;

  @override
  Future<NotificationPreferences> load() async => value;

  @override
  Future<void> save(NotificationPreferences preferences) async {
    value = preferences;
  }
}

final class _ThrowingStore implements NotificationPreferencesStore {
  @override
  Future<NotificationPreferences> load() =>
      Future<NotificationPreferences>.error(
        const FormatException('corrupt notification preferences'),
      );

  @override
  Future<void> save(NotificationPreferences preferences) async {}
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

DhikrReminderStartupT0293 _startup({
  required NotificationPreferencesStore store,
  required _Scheduler scheduler,
  required DateTime now,
}) {
  final coordinator = DhikrReminderCoordinatorT0293(
    preferencesStore: store,
    scheduler: scheduler,
  );
  return DhikrReminderStartupT0293(
    preferencesStore: store,
    orchestrator: DhikrReminderOrchestratorT0293(
      coordinator: coordinator,
      now: () => now,
    ),
  );
}

void main() {
  test('startup restores persisted opt-in and selected minute', () async {
    final scheduler = _Scheduler();
    final store = _Store(
      const NotificationPreferences(
        dhikrReminder: true,
        dhikrReminderTime: NotificationTime(hour: 18, minute: 40),
      ),
    );

    await _startup(
      store: store,
      scheduler: scheduler,
      now: DateTime(2026, 9, 10, 7, 58),
    ).reconcile(languageCode: 'tr');

    final request = scheduler.scheduled.single;
    expect(request.id, dhikrReminderNotificationIdT0293);
    expect(request.scheduledAt, DateTime(2026, 9, 10, 18, 40));
    expect(request.payload, 'islami-hayat://dhikr');
    expect(scheduler.cancelled, isEmpty);
  });

  test('unsupported device locale falls back to Turkish copy', () async {
    final scheduler = _Scheduler();
    final store = _Store(
      const NotificationPreferences(
        dhikrReminder: true,
        dhikrReminderTime: NotificationTime(hour: 19, minute: 5),
      ),
    );

    await _startup(
      store: store,
      scheduler: scheduler,
      now: DateTime(2026, 9, 10, 8),
    ).reconcile(languageCode: 'de');

    final request = scheduler.scheduled.single;
    expect(request.title, 'Zikir hatırlatıcısı');
    expect(request.scheduledAt, DateTime(2026, 9, 10, 19, 5));
  });

  test('persisted opt-out cancels without scheduling', () async {
    final scheduler = _Scheduler();
    final store = _Store(const NotificationPreferences(dhikrReminder: false));

    await _startup(
      store: store,
      scheduler: scheduler,
      now: DateTime(2026, 9, 10, 8),
    ).reconcile(languageCode: 'en');

    expect(scheduler.cancelled, [dhikrReminderNotificationIdT0293]);
    expect(scheduler.scheduled, isEmpty);
  });

  test('corrupt persisted preferences fail closed with no scheduler side effect',
      () async {
    final scheduler = _Scheduler();
    final store = _ThrowingStore();

    await expectLater(
      _startup(
        store: store,
        scheduler: scheduler,
        now: DateTime(2026, 9, 10, 8),
      ).reconcile(languageCode: 'ar'),
      throwsFormatException,
    );

    expect(scheduler.scheduled, isEmpty);
    expect(scheduler.cancelled, isEmpty);
  });
}
