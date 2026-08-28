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
    expect(initial.vibrationEnabled, isFalse);
    expect(initial.soundEnabled, isFalse);

    final one = await repository.increment(initial);
    expect(one.count, 1);
    expect((await repository.load()).count, 1);
  });

  test('feedback preferences are independent opt-ins and persist', () async {
    final store = _MemoryStore();
    final repository = DhikrCounterRepository(store);
    var state = await repository.load();

    state = await repository.setFeedbackPreferences(
      state,
      vibrationEnabled: true,
    );
    expect(state.vibrationEnabled, isTrue);
    expect(state.soundEnabled, isFalse);

    state = await repository.setFeedbackPreferences(
      state,
      soundEnabled: true,
    );
    expect(state.vibrationEnabled, isTrue);
    expect(state.soundEnabled, isTrue);

    final restored = await repository.load();
    expect(restored.vibrationEnabled, isTrue);
    expect(restored.soundEnabled, isTrue);
  });

  test('legacy counter state keeps feedback disabled by default', () async {
    final store = _MemoryStore();
    final repository = DhikrCounterRepository(store);
    store.values['dhikr.counter.v1'] = '{"count":12}';

    final state = await repository.load();
    expect(state.count, 12);
    expect(state.vibrationEnabled, isFalse);
    expect(state.soundEnabled, isFalse);
  });

  test('reset preserves feedback preferences', () async {
    final store = _MemoryStore();
    final repository = DhikrCounterRepository(store);
    var state = await repository.load();
    state = await repository.setFeedbackPreferences(
      state,
      vibrationEnabled: true,
      soundEnabled: true,
    );
    state = await repository.increment(state);
    expect(state.count, 1);

    final reset = await repository.reset();
    expect(reset.count, 0);
    expect(reset.vibrationEnabled, isTrue);
    expect(reset.soundEnabled, isTrue);
  });

  test('corrupted or impossible local values fail safely to defaults', () async {
    final store = _MemoryStore();
    final repository = DhikrCounterRepository(store);

    store.values['dhikr.counter.v1'] = '{broken';
    var state = await repository.load();
    expect(state.count, 0);
    expect(state.vibrationEnabled, isFalse);
    expect(state.soundEnabled, isFalse);

    store.values['dhikr.counter.v1'] =
        '{"count":-4,"vibrationEnabled":true,"soundEnabled":true}';
    state = await repository.load();
    expect(state.count, 0);
    expect(state.vibrationEnabled, isFalse);
    expect(state.soundEnabled, isFalse);

    store.values['dhikr.counter.v1'] =
        '{"count":3,"vibrationEnabled":"yes","soundEnabled":1}';
    state = await repository.load();
    expect(state.count, 3);
    expect(state.vibrationEnabled, isFalse);
    expect(state.soundEnabled, isFalse);
  });
}
