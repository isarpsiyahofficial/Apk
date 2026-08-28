import 'package:flutter_test/flutter_test.dart';
import 'package:islami_hayat/core/storage/storage_boundaries.dart';
import 'package:islami_hayat/features/dhikr/data/dhikr_counter_repository.dart';

final class _MemoryStore implements PrivateUserStore {
  final Map<String, String> values = {};

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
  test('starts at zero and persists increments in private user storage', () async {
    final store = _MemoryStore();
    final repository = DhikrCounterRepository(store);

    final initial = await repository.load();
    expect(initial.count, 0);

    final one = await repository.increment(initial);
    expect(one.count, 1);
    expect((await repository.load()).count, 1);
  });

  test('reset only resets personal counter state', () async {
    final store = _MemoryStore();
    final repository = DhikrCounterRepository(store);
    var state = await repository.load();
    state = await repository.increment(state);
    state = await repository.increment(state);
    expect(state.count, 2);

    final reset = await repository.reset();
    expect(reset.count, 0);
    expect((await repository.load()).count, 0);
  });

  test('corrupted or impossible local values fail safely to zero', () async {
    final store = _MemoryStore();
    final repository = DhikrCounterRepository(store);

    store.values['dhikr.counter.v1'] = '{broken';
    expect((await repository.load()).count, 0);

    store.values['dhikr.counter.v1'] = '{"count":-4}';
    expect((await repository.load()).count, 0);

    store.values['dhikr.counter.v1'] = '{"count":"33"}';
    expect((await repository.load()).count, 0);
  });
}
