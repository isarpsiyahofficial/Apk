import 'package:flutter_test/flutter_test.dart';
import 'package:islami_hayat/features/notifications/data/religious_day_reminder_startup_t0294.dart';
import 'package:islami_hayat/features/notifications/domain/daily_verse_notification_t0291.dart';
import 'package:islami_hayat/features/notifications/domain/notification_preferences.dart';
import 'package:islami_hayat/features/notifications/domain/religious_day_reminder_t0294.dart';

final class _Store implements NotificationPreferencesStore {
  const _Store(this.value);
  final NotificationPreferences value;
  @override
  Future<NotificationPreferences> load() async => value;
  @override
  Future<void> save(NotificationPreferences preferences) async {}
}

final class _ThrowingStore implements NotificationPreferencesStore {
  @override
  Future<NotificationPreferences> load() =>
      Future<NotificationPreferences>.error(const FormatException('corrupt'));
  @override
  Future<void> save(NotificationPreferences preferences) async {}
}

final class _Scheduler implements LocalNotificationSchedulerT0291 {
  final scheduled = <LocalNotificationRequestT0291>[];
  final cancelled = <int>[];
  @override
  Future<void> cancel(int id) async => cancelled.add(id);
  @override
  Future<void> schedule(LocalNotificationRequestT0291 request) async =>
      scheduled.add(request);
}

ReligiousDayReminderStartupT0294 _startup(
  NotificationPreferencesStore store,
  _Scheduler scheduler,
) {
  return ReligiousDayReminderStartupT0294(
    preferencesStore: store,
    coordinator: ReligiousDayReminderCoordinatorT0294(
      preferencesStore: store,
      scheduler: scheduler,
      observationSource: const EmptyReligiousDayObservationSourceT0294(),
    ),
  );
}

void main() {
  test('unsupported locale falls back but empty verified source stays closed', () async {
    final scheduler = _Scheduler();
    await _startup(
      const _Store(NotificationPreferences(religiousDay: true)),
      scheduler,
    ).reconcile(
      now: DateTime(2026, 9, 10, 9),
      languageCode: 'de',
      countryCode: 'TR',
    );

    expect(scheduler.scheduled, isEmpty);
    expect(scheduler.cancelled, [religiousDayNotificationIdT0294]);
  });

  test('persisted opt-out cancels locally at startup', () async {
    final scheduler = _Scheduler();
    await _startup(
      const _Store(NotificationPreferences(religiousDay: false)),
      scheduler,
    ).reconcile(
      now: DateTime(2026, 9, 10, 9),
      languageCode: 'ar',
      countryCode: 'TR',
    );

    expect(scheduler.scheduled, isEmpty);
    expect(scheduler.cancelled, [religiousDayNotificationIdT0294]);
  });

  test('corrupt persisted settings have no scheduler side effect', () async {
    final scheduler = _Scheduler();
    await expectLater(
      _startup(_ThrowingStore(), scheduler).reconcile(
        now: DateTime(2026, 9, 10, 9),
        languageCode: 'tr',
        countryCode: 'TR',
      ),
      throwsFormatException,
    );
    expect(scheduler.scheduled, isEmpty);
    expect(scheduler.cancelled, isEmpty);
  });
}
