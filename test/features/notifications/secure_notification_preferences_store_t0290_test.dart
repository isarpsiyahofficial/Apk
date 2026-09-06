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
  });

  test('T0290 notification preferences round-trip through private store', () async {
    final backend = _MemoryPrivateStore();
    final store = SecureNotificationPreferencesStore(backend);
    const expected = NotificationPreferences(
      dailyVerse: true,
      dailyDua: false,
      dhikrReminder: true,
      religiousDay: false,
    );

    await store.save(expected);
    final actual = await store.load();

    expect(actual.dailyVerse, expected.dailyVerse);
    expect(actual.dailyDua, expected.dailyDua);
    expect(actual.dhikrReminder, expected.dhikrReminder);
    expect(actual.religiousDay, expected.religiousDay);
    expect(
      backend.values.keys,
      contains(SecureNotificationPreferencesStore.storageKey),
    );
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
