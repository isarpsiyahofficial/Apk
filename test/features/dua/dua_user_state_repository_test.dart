import 'package:flutter_test/flutter_test.dart';
import 'package:islami_hayat/core/storage/storage_boundaries.dart';
import 'package:islami_hayat/features/dua/data/dua_user_state_repository.dart';

final class _MemoryPrivateUserStore implements PrivateUserStore {
  final Map<String, String> _data = <String, String>{};

  @override
  StorageDomain get domain => StorageDomain.privateUserData;

  @override
  Future<void> clear() async => _data.clear();

  @override
  Future<void> delete(String key) async => _data.remove(key);

  @override
  Future<String?> read(String key) async => _data[key];

  @override
  Future<void> write(String key, String value) async => _data[key] = value;
}

void main() {
  test('favorites toggle and persist locally', () async {
    final store = _MemoryPrivateUserStore();
    final repository = DuaUserStateRepository(store);

    var state = await repository.toggleFavorite('dua-1');
    expect(state.favoriteIds, {'dua-1'});

    state = await DuaUserStateRepository(store).load();
    expect(state.favoriteIds, {'dua-1'});

    state = await repository.toggleFavorite('dua-1');
    expect(state.favoriteIds, isEmpty);
  });

  test('history is most-recent first and deduplicated', () async {
    final repository = DuaUserStateRepository(_MemoryPrivateUserStore());

    await repository.recordOpened('dua-1');
    await repository.recordOpened('dua-2');
    final state = await repository.recordOpened('dua-1');

    expect(state.historyIds, ['dua-1', 'dua-2']);
  });

  test('history is capped without touching favorites', () async {
    final repository = DuaUserStateRepository(_MemoryPrivateUserStore());
    await repository.toggleFavorite('dua-favorite');

    for (var i = 0; i < DuaUserStateRepository.maxHistoryItems + 5; i++) {
      await repository.recordOpened('dua-$i');
    }

    final state = await repository.load();
    expect(state.historyIds.length, DuaUserStateRepository.maxHistoryItems);
    expect(state.historyIds.first, 'dua-104');
    expect(state.favoriteIds, contains('dua-favorite'));
  });

  test('clearHistory preserves favorites', () async {
    final repository = DuaUserStateRepository(_MemoryPrivateUserStore());
    await repository.toggleFavorite('dua-1');
    await repository.recordOpened('dua-2');

    await repository.clearHistory();
    final state = await repository.load();

    expect(state.favoriteIds, {'dua-1'});
    expect(state.historyIds, isEmpty);
  });

  test('corrupt or wrong-schema local state fails closed', () async {
    final store = _MemoryPrivateUserStore();
    await store.write(DuaUserStateRepository.storageKey, '{not-json');
    final repository = DuaUserStateRepository(store);

    expect(repository.load(), throwsA(isA<DuaUserStateFormatException>()));

    await store.write(
      DuaUserStateRepository.storageKey,
      '{"schemaVersion":2,"favoriteIds":[],"historyIds":[]}',
    );
    expect(repository.load(), throwsA(isA<DuaUserStateFormatException>()));
  });

  test('empty ids are rejected', () async {
    final repository = DuaUserStateRepository(_MemoryPrivateUserStore());

    expect(() => repository.toggleFavorite(' '), throwsArgumentError);
    expect(() => repository.recordOpened(''), throwsArgumentError);
  });
}
