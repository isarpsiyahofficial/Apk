import 'package:flutter_test/flutter_test.dart';
import 'package:islami_hayat/core/storage/storage_boundaries.dart';
import 'package:islami_hayat/core/storage/user_data_repository.dart';

final class _MemoryPrivateStore implements PrivateUserStore {
  final Map<String, String> values = <String, String>{};

  @override
  StorageDomain get domain => StorageDomain.privateUserData;

  @override
  Future<void> clear() async => values.clear();

  @override
  Future<void> delete(String key) async => values.remove(key);

  @override
  Future<String?> read(String key) async => values[key];

  @override
  Future<void> write(String key, String value) async => values[key] = value;
}

void main() {
  test('empty repository loads a stable v1 user-data snapshot', () async {
    final repository = UserDataRepository(_MemoryPrivateStore());
    final snapshot = await repository.load();

    expect(snapshot.favorites, isEmpty);
    expect(snapshot.bookmarks, isEmpty);
    expect(snapshot.notes, isEmpty);
    expect(snapshot.questionHistory, isEmpty);
    expect(snapshot.dhikrTotals, isEmpty);
    expect(snapshot.settings, isEmpty);
    expect(snapshot.entitlementCache, isEmpty);
  });

  test('all private user domains round-trip through one versioned snapshot',
      () async {
    final store = _MemoryPrivateStore();
    final repository = UserDataRepository(store);
    const snapshot = UserDataSnapshot(
      favorites: {'quran:2:255'},
      bookmarks: {'quran:18:10'},
      notes: {'quran:2:255': 'Tefekkür notu'},
      questionHistory: ['Sabır konusunda ne okuyabilirim?'],
      dhikrTotals: {'subhanallah': 33},
      settings: {'locale': 'tr', 'questionHistoryEnabled': 'true'},
      entitlementCache: {'state': 'free'},
    );

    await repository.save(snapshot);
    final restored = await repository.load();

    expect(restored.favorites, snapshot.favorites);
    expect(restored.bookmarks, snapshot.bookmarks);
    expect(restored.notes, snapshot.notes);
    expect(restored.questionHistory, snapshot.questionHistory);
    expect(restored.dhikrTotals, snapshot.dhikrTotals);
    expect(restored.settings, snapshot.settings);
    expect(restored.entitlementCache, snapshot.entitlementCache);
  });

  test('corrupt private snapshot is rejected instead of silently misread',
      () async {
    final store = _MemoryPrivateStore();
    final repository = UserDataRepository(store);
    store.values[UserDataRepository.storageKey] = '{broken json';

    expect(
      repository.load(),
      throwsA(isA<UserDataFormatException>()),
    );
  });

  test('reset removes only the versioned user snapshot', () async {
    final store = _MemoryPrivateStore();
    final repository = UserDataRepository(store);
    await repository.save(UserDataSnapshot.empty());
    store.values['unrelated'] = 'keep';

    await repository.reset();

    expect(store.values[UserDataRepository.storageKey], isNull);
    expect(store.values['unrelated'], 'keep');
  });
}
