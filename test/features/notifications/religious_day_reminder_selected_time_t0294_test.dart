import 'package:flutter_test/flutter_test.dart';
import 'package:islami_hayat/features/notifications/domain/daily_verse_notification_t0291.dart';
import 'package:islami_hayat/features/notifications/domain/notification_preferences.dart';
import 'package:islami_hayat/features/notifications/domain/religious_day_reminder_t0294.dart';
import 'package:islami_hayat/features/religious_days/data/religious_date_metadata.dart';

final class _Store implements NotificationPreferencesStore {
  const _Store(this.value);
  final NotificationPreferences value;
  @override
  Future<NotificationPreferences> load() async => value;
  @override
  Future<void> save(NotificationPreferences preferences) async {}
}

final class _Scheduler implements LocalNotificationSchedulerT0291 {
  final requests = <LocalNotificationRequestT0291>[];
  @override
  Future<void> cancel(int id) async {}
  @override
  Future<void> schedule(LocalNotificationRequestT0291 request) async {
    requests.add(request);
  }
}

final class _Source implements ReligiousDayObservationSourceT0294 {
  _Source(this.observation);
  final ReligiousDateObservation observation;
  @override
  Future<ReligiousDateObservation?> nextObservation({
    required DateTime now,
    required String countryCode,
  }) async => observation;
}

void main() {
  test('T0294 schedules confirmed local date at persisted selected minute', () async {
    final authority = ReligiousDateSourceMetadata(
      id: 'tr-test-authority',
      title: 'Official test authority',
      jurisdiction: 'Türkiye',
      countryCode: 'TR',
      kind: ReligiousDateSourceKind.nationalReligiousAuthority,
      url: Uri.parse('https://official.example/calendar'),
      retrievedAt: DateTime.utc(2026, 9, 1),
    );
    final observation = ReligiousDateObservation(
      contentId: 'verified-observance',
      hijriYear: 1448,
      hijriMonth: 4,
      hijriDay: 1,
      gregorianDate: DateTime(2026, 9, 20),
      source: authority,
      status: ReligiousDateVerificationStatus.confirmed,
      verifiedAt: DateTime.utc(2026, 9, 2),
      sourcePublicationLocator: 'calendar:1448-04-01',
      sourcePublicationUrl: Uri.parse('https://official.example/calendar/1448'),
    );
    final scheduler = _Scheduler();
    final coordinator = ReligiousDayReminderCoordinatorT0294(
      preferencesStore: const _Store(
        NotificationPreferences(
          religiousDay: true,
          religiousDayTime: NotificationTime(hour: 7, minute: 35),
        ),
      ),
      scheduler: scheduler,
      observationSource: _Source(observation),
    );

    await coordinator.sync(
      now: DateTime(2026, 9, 10, 8),
      languageCode: 'tr',
      countryCode: 'TR',
    );

    expect(scheduler.requests.single.scheduledAt, DateTime(2026, 9, 20, 7, 35));
  });
}
