import 'package:flutter_test/flutter_test.dart';
import 'package:islami_hayat/features/notifications/domain/daily_verse_notification_t0291.dart';
import 'package:islami_hayat/features/notifications/domain/notification_preferences.dart';
import 'package:islami_hayat/features/notifications/domain/religious_day_reminder_t0294.dart';
import 'package:islami_hayat/features/religious_days/data/religious_date_metadata.dart';

void main() {
  group('T0294 religious-day reminder', () {
    test('opt-out cancels without reading religious-date source', () async {
      final store = _Store(
        const NotificationPreferences(religiousDay: false),
      );
      final scheduler = _Scheduler();
      final source = _ObservationSource(null);
      final coordinator = ReligiousDayReminderCoordinatorT0294(
        preferencesStore: store,
        scheduler: scheduler,
        observationSource: source,
      );

      await coordinator.sync(
        now: DateTime(2026, 9, 2, 8),
        languageCode: 'tr',
        countryCode: 'TR',
      );

      expect(source.calls, 0);
      expect(
        scheduler.cancelled,
        contains(religiousDayNotificationIdT0294),
      );
      expect(scheduler.requests, isEmpty);
    });

    test('confirmed same-jurisdiction official date schedules locally', () async {
      final sourceMetadata = ReligiousDateSourceMetadata(
        id: 'tr-official-test',
        title: 'Official local calendar test fixture',
        jurisdiction: 'Türkiye',
        countryCode: 'TR',
        kind: ReligiousDateSourceKind.nationalReligiousAuthority,
        url: Uri.parse('https://example.org/official-calendar'),
        retrievedAt: DateTime.utc(2026, 9, 1),
      );
      final observation = ReligiousDateObservation(
        contentId: 'verified-observance',
        hijriYear: 1448,
        hijriMonth: 1,
        hijriDay: 10,
        gregorianDate: DateTime(2026, 9, 4),
        source: sourceMetadata,
        status: ReligiousDateVerificationStatus.confirmed,
        verifiedAt: DateTime.utc(2026, 9, 1, 1),
        sourcePublicationLocator: 'official-calendar:1448-01-10',
        sourcePublicationUrl: Uri.parse(
          'https://example.org/official-calendar/1448-01-10',
        ),
      );
      final scheduler = _Scheduler();
      final coordinator = ReligiousDayReminderCoordinatorT0294(
        preferencesStore: _Store(
          const NotificationPreferences(religiousDay: true),
        ),
        scheduler: scheduler,
        observationSource: _ObservationSource(observation),
      );

      await coordinator.sync(
        now: DateTime(2026, 9, 2, 8),
        languageCode: 'en',
        countryCode: 'TR',
      );

      expect(scheduler.requests, hasLength(1));
      final request = scheduler.requests.single;
      expect(request.id, religiousDayNotificationIdT0294);
      expect(request.scheduledAt, DateTime(2026, 9, 4, 9));
      expect(
        request.payload,
        'islami-hayat://religious-day/verified-observance',
      );
      expect(request.body, contains('verified local date source'));
    });

    test('provisional observation is cancelled fail-closed', () async {
      final scheduler = _Scheduler();
      final coordinator = ReligiousDayReminderCoordinatorT0294(
        preferencesStore: _Store(
          const NotificationPreferences(religiousDay: true),
        ),
        scheduler: scheduler,
        observationSource: _ObservationSource(
          _observation(
            status: ReligiousDateVerificationStatus.provisional,
            countryCode: 'TR',
          ),
        ),
      );

      await coordinator.sync(
        now: DateTime(2026, 9, 2, 8),
        languageCode: 'tr',
        countryCode: 'TR',
      );

      expect(scheduler.requests, isEmpty);
      expect(
        scheduler.cancelled,
        contains(religiousDayNotificationIdT0294),
      );
    });

    test('country mismatch never promotes another jurisdiction date', () async {
      final scheduler = _Scheduler();
      final coordinator = ReligiousDayReminderCoordinatorT0294(
        preferencesStore: _Store(
          const NotificationPreferences(religiousDay: true),
        ),
        scheduler: scheduler,
        observationSource: _ObservationSource(
          _observation(
            status: ReligiousDateVerificationStatus.confirmed,
            countryCode: 'SA',
          ),
        ),
      );

      await coordinator.sync(
        now: DateTime(2026, 9, 2, 8),
        languageCode: 'ar',
        countryCode: 'TR',
      );

      expect(scheduler.requests, isEmpty);
      expect(
        scheduler.cancelled,
        contains(religiousDayNotificationIdT0294),
      );
    });

    test('unrelated HTTPS evidence never schedules a reminder', () async {
      final scheduler = _Scheduler();
      final coordinator = ReligiousDayReminderCoordinatorT0294(
        preferencesStore: _Store(
          const NotificationPreferences(religiousDay: true),
        ),
        scheduler: scheduler,
        observationSource: _ObservationSource(
          _observation(
            status: ReligiousDateVerificationStatus.confirmed,
            countryCode: 'TR',
            publicationUrl: Uri.parse('https://unrelated.example/date'),
          ),
        ),
      );

      await coordinator.sync(
        now: DateTime(2026, 9, 2, 8),
        languageCode: 'tr',
        countryCode: 'TR',
      );

      expect(scheduler.requests, isEmpty);
      expect(
        scheduler.cancelled,
        contains(religiousDayNotificationIdT0294),
      );
    });

    test('missing observation and stale date both cancel', () async {
      for (final observation in <ReligiousDateObservation?>[
        null,
        _observation(
          status: ReligiousDateVerificationStatus.confirmed,
          countryCode: 'TR',
          gregorianDate: DateTime(2026, 9, 1),
        ),
      ]) {
        final scheduler = _Scheduler();
        final coordinator = ReligiousDayReminderCoordinatorT0294(
          preferencesStore: _Store(
            const NotificationPreferences(religiousDay: true),
          ),
          scheduler: scheduler,
          observationSource: _ObservationSource(observation),
        );
        await coordinator.sync(
          now: DateTime(2026, 9, 2, 8),
          languageCode: 'tr',
          countryCode: 'TR',
        );
        expect(scheduler.requests, isEmpty);
        expect(
          scheduler.cancelled,
          contains(religiousDayNotificationIdT0294),
        );
      }
    });

    test('unsupported locale fails before a notification is scheduled', () async {
      final scheduler = _Scheduler();
      final coordinator = ReligiousDayReminderCoordinatorT0294(
        preferencesStore: _Store(
          const NotificationPreferences(religiousDay: true),
        ),
        scheduler: scheduler,
        observationSource: _ObservationSource(
          _observation(
            status: ReligiousDateVerificationStatus.confirmed,
            countryCode: 'TR',
          ),
        ),
      );

      await expectLater(
        coordinator.sync(
          now: DateTime(2026, 9, 2, 8),
          languageCode: 'de',
          countryCode: 'TR',
        ),
        throwsA(isA<UnsupportedError>()),
      );
      expect(scheduler.requests, isEmpty);
    });
  });
}

ReligiousDateObservation _observation({
  required ReligiousDateVerificationStatus status,
  required String countryCode,
  DateTime? gregorianDate,
  Uri? publicationUrl,
}) {
  final source = ReligiousDateSourceMetadata(
    id: '${countryCode.toLowerCase()}-fixture',
    title: 'Official local calendar test fixture',
    jurisdiction: countryCode,
    countryCode: countryCode,
    kind: ReligiousDateSourceKind.nationalReligiousAuthority,
    url: Uri.parse('https://example.org/official-calendar'),
    retrievedAt: DateTime.utc(2026, 9, 1),
  );
  return ReligiousDateObservation(
    contentId: 'observance',
    hijriYear: 1448,
    hijriMonth: 1,
    hijriDay: 10,
    gregorianDate: gregorianDate ?? DateTime(2026, 9, 4),
    source: source,
    status: status,
    verifiedAt: DateTime.utc(2026, 9, 1, 1),
    sourcePublicationLocator: 'official-calendar:1448-01-10',
    sourcePublicationUrl: publicationUrl ??
        Uri.parse('https://example.org/official-calendar/1448-01-10'),
  );
}

final class _Store implements NotificationPreferencesStore {
  _Store(this.preferences);

  final NotificationPreferences preferences;

  @override
  Future<NotificationPreferences> load() async => preferences;

  @override
  Future<void> save(NotificationPreferences preferences) async {}
}

final class _ObservationSource implements ReligiousDayObservationSourceT0294 {
  _ObservationSource(this.observation);

  final ReligiousDateObservation? observation;
  int calls = 0;

  @override
  Future<ReligiousDateObservation?> nextObservation({
    required DateTime now,
    required String countryCode,
  }) async {
    calls += 1;
    return observation;
  }
}

final class _Scheduler implements LocalNotificationSchedulerT0291 {
  final List<LocalNotificationRequestT0291> requests = [];
  final List<int> cancelled = [];

  @override
  Future<void> cancel(int id) async => cancelled.add(id);

  @override
  Future<void> schedule(LocalNotificationRequestT0291 request) async {
    requests.add(request);
  }
}
