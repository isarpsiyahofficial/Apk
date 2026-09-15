import 'package:flutter_test/flutter_test.dart';
import 'package:islami_hayat/core/storage/storage_boundaries.dart';
import 'package:islami_hayat/features/notifications/data/secure_notification_preferences_store.dart';
import 'package:islami_hayat/features/notifications/domain/notification_preferences.dart';

final class _MemoryPrivateStore implements PrivateUserStore {
  _MemoryPrivateStore({this.overrideDomain = StorageDomain.privateUserData});

  final StorageDomain overrideDomain;
  final Map<String, String> values = <String, String>{};

  @override
  StorageDomain get domain => overrideDomain;

  @override
  Future<String?> read(String key) async => values[key];

  @override
  Future<void> write(String key, String value) async {
    values[key] = value;
  }

  @override
  Future<void> delete(String key) async {
    values.remove(key);
  }

  @override
  Future<void> clear() async {
    values.clear();
  }
}

void main() {
  test('T0290 missing persisted settings fail closed to all-off defaults', () async {
    final store = SecureNotificationPreferencesStore(_MemoryPrivateStore());

    final preferences = await store.load();

    expect(preferences.dailyVerse, isFalse);
    expect(preferences.dailyDua, isFalse);
    expect(preferences.dhikrReminder, isFalse);
    expect(preferences.religiousDay, isFalse);
    expect(preferences.dailyVerseTime, dailyVerseDefaultTime);
    expect(preferences.dailyDuaTime, dailyDuaDefaultTime);
    expect(preferences.dhikrReminderTime, dhikrReminderDefaultTime);
    expect(preferences.religiousDayTime, religiousDayDefaultTime);
  });

  test('T0290 toggles and per-category times round-trip through private store', () async {
    final backend = _MemoryPrivateStore();
    final store = SecureNotificationPreferencesStore(backend);
    const expected = NotificationPreferences(
      dailyVerse: true,
      dailyDua: false,
      dhikrReminder: true,
      religiousDay: false,
      dailyVerseTime: NotificationTime(hour: 7, minute: 35),
      dailyDuaTime: NotificationTime(hour: 11, minute: 5),
      dhikrReminderTime: NotificationTime(hour: 21, minute: 45),
      religiousDayTime: NotificationTime(hour: 8, minute: 10),
    );

    await store.save(expected);
    final actual = await store.load();

    expect(actual.dailyVerse, expected.dailyVerse);
    expect(actual.dailyDua, expected.dailyDua);
    expect(actual.dhikrReminder, expected.dhikrReminder);
    expect(actual.religiousDay, expected.religiousDay);
    expect(actual.dailyVerseTime, expected.dailyVerseTime);
    expect(actual.dailyDuaTime, expected.dailyDuaTime);
    expect(actual.dhikrReminderTime, expected.dhikrReminderTime);
    expect(actual.religiousDayTime, expected.religiousDayTime);
    expect(
      backend.values.keys,
      contains(SecureNotificationPreferencesStore.storageKey),
    );
    expect(backend.values[SecureNotificationPreferencesStore.storageKey],
        contains('"schemaVersion":2'));
  });

  test('T0290 v1 persisted toggles migrate with safe default times', () async {
    final backend = _MemoryPrivateStore();
    backend.values[SecureNotificationPreferencesStore.storageKey] =
        '{"schemaVersion":1,"dailyVerse":true,"dailyDua":false,"dhikrReminder":true,"religiousDay":false}';
    final store = SecureNotificationPreferencesStore(backend);

    final actual = await store.load();

    expect(actual.dailyVerse, isTrue);
    expect(actual.dhikrReminder, isTrue);
    expect(actual.dailyVerseTime, dailyVerseDefaultTime);
    expect(actual.dailyDuaTime, dailyDuaDefaultTime);
    expect(actual.dhikrReminderTime, dhikrReminderDefaultTime);
    expect(actual.religiousDayTime, religiousDayDefaultTime);
  });

  test('T0290 malformed persisted JSON is rejected instead of enabling alerts', () async {
    final backend = _MemoryPrivateStore();
    backend.values[SecureNotificationPreferencesStore.storageKey] = '{broken';
    final store = SecureNotificationPreferencesStore(backend);

    await expectLater(store.load(), throwsA(isA<FormatException>()));
  });

  test('T0290 unsupported schema is rejected', () async {
    final backend = _MemoryPrivateStore();
    backend.values[SecureNotificationPreferencesStore.storageKey] =
        '{"schemaVersion":99,"dailyVerse":true,"dailyDua":true,"dhikrReminder":true,"religiousDay":true}';
    final store = SecureNotificationPreferencesStore(backend);

    await expectLater(store.load(), throwsA(isA<FormatException>()));
  });

  test('T0290 v2 rejects missing, extra, and invalid time fields', () async {
    final invalidRecords = <String>[
      '{"schemaVersion":2,"dailyVerse":true,"dailyDua":false,"dhikrReminder":false,"religiousDay":false,"dailyVerseTime":540,"dailyDuaTime":600,"dhikrReminderTime":1200}',
      '{"schemaVersion":2,"dailyVerse":true,"dailyDua":false,"dhikrReminder":false,"religiousDay":false,"dailyVerseTime":540,"dailyDuaTime":600,"dhikrReminderTime":1200,"religiousDayTime":540,"unexpected":true}',
      '{"schemaVersion":2,"dailyVerse":true,"dailyDua":false,"dhikrReminder":false,"religiousDay":false,"dailyVerseTime":1440,"dailyDuaTime":600,"dhikrReminderTime":1200,"religiousDayTime":540}',
      '{"schemaVersion":2,"dailyVerse":true,"dailyDua":false,"dhikrReminder":false,"religiousDay":false,"dailyVerseTime":"09:00","dailyDuaTime":600,"dhikrReminderTime":1200,"religiousDayTime":540}',
    ];

    for (final record in invalidRecords) {
      final backend = _MemoryPrivateStore();
      backend.values[SecureNotificationPreferencesStore.storageKey] = record;
      final store = SecureNotificationPreferencesStore(backend);
      await expectLater(store.load(), throwsA(isA<FormatException>()));
    }
  });

  test('T0290 refuses a non-private storage domain', () {
    final wrongStore = _MemoryPrivateStore(
      overrideDomain: StorageDomain.trustedContent,
    );

    expect(
      () => SecureNotificationPreferencesStore(wrongStore),
      throwsA(isA<StateError>()),
    );
  });
}
