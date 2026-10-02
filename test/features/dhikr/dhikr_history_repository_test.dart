import 'package:flutter_test/flutter_test.dart';
import 'package:islami_hayat/core/storage/storage_boundaries.dart';
import 'package:islami_hayat/features/dhikr/data/dhikr_history_repository.dart';

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
  test('records local-only history and computes daily weekly and streak summary', () async {
    final store = _MemoryStore();
    final now = DateTime(2026, 8, 28, 12);
    final repository = DhikrHistoryRepository(store, now: () => now);

    await repository.recordSession(count: 33, occurredAt: DateTime(2026, 8, 28, 8));
    await repository.recordSession(count: 100, occurredAt: DateTime(2026, 8, 27, 21));
    await repository.recordSession(count: 5, occurredAt: DateTime(2026, 8, 26, 7));
    await repository.recordSession(count: 9, occurredAt: DateTime(2026, 8, 20, 7));

    final summary = await repository.summary();
    expect(summary.todayTotal, 33);
    expect(summary.lastSevenDaysTotal, 138);
    expect(summary.currentStreakDays, 3);
    expect(summary.entries, hasLength(4));
    expect(store.values.keys, contains('dhikr.history.v1'));
  });

  test('streak does not manufacture missed days', () async {
    final repository = DhikrHistoryRepository(
      _MemoryStore(),
      now: () => DateTime(2026, 8, 28, 12),
    );
    await repository.recordSession(count: 10, occurredAt: DateTime(2026, 8, 28));
    await repository.recordSession(count: 10, occurredAt: DateTime(2026, 8, 26));

    final summary = await repository.summary();
    expect(summary.currentStreakDays, 1);
  });

  test('future sessions are excluded from today weekly and streak calculations', () async {
    final repository = DhikrHistoryRepository(
      _MemoryStore(),
      now: () => DateTime(2026, 8, 28, 12),
    );
    await repository.recordSession(count: 10, occurredAt: DateTime(2026, 8, 29));

    final summary = await repository.summary();
    expect(summary.todayTotal, 0);
    expect(summary.lastSevenDaysTotal, 0);
    expect(summary.currentStreakDays, 0);
  });

  test('corrupt history fails closed instead of producing misleading statistics', () async {
    final store = _MemoryStore();
    final repository = DhikrHistoryRepository(store);

    store.values['dhikr.history.v1'] = '[{"count":-1,"occurredAt":"2026-08-28T00:00:00Z"}]';
    expect(await repository.load(), isEmpty);

    store.values['dhikr.history.v1'] = '{broken';
    expect(await repository.load(), isEmpty);
  });

  test('invalid session counts are rejected', () async {
    final repository = DhikrHistoryRepository(_MemoryStore());
    expect(() => repository.recordSession(count: 0), throwsArgumentError);
    expect(() => repository.recordSession(count: -3), throwsArgumentError);
  });

  test('history is bounded to 365 newest entries and can be cleared', () async {
    final store = _MemoryStore();
    final repository = DhikrHistoryRepository(store);
    for (var i = 0; i < 370; i++) {
      await repository.recordSession(
        count: 1,
        occurredAt: DateTime(2026, 1, 1).add(Duration(hours: i)),
      );
    }

    expect(await repository.load(), hasLength(365));
    await repository.clear();
    expect(await repository.load(), isEmpty);
  });
}
