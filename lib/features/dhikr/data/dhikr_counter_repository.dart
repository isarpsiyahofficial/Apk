import 'dart:convert';

import 'package:islami_hayat/core/storage/storage_boundaries.dart';

final class DhikrCounterState {
  const DhikrCounterState({required this.count});

  final int count;

  DhikrCounterState copyWith({int? count}) =>
      DhikrCounterState(count: count ?? this.count);
}

final class DhikrCounterRepository {
  DhikrCounterRepository(this._store);

  static const _storageKey = 'dhikr.counter.v1';
  static const _maxCount = 999999999;

  final PrivateUserStore _store;

  Future<DhikrCounterState> load() async {
    StorageBoundaryGuard.requirePrivateUserStore(_store);
    final raw = await _store.read(_storageKey);
    if (raw == null || raw.trim().isEmpty) {
      return const DhikrCounterState(count: 0);
    }

    try {
      final decoded = jsonDecode(raw);
      if (decoded is! Map<String, dynamic>) {
        return const DhikrCounterState(count: 0);
      }
      final value = decoded['count'];
      if (value is! int || value < 0 || value > _maxCount) {
        return const DhikrCounterState(count: 0);
      }
      return DhikrCounterState(count: value);
    } on FormatException {
      return const DhikrCounterState(count: 0);
    }
  }

  Future<DhikrCounterState> increment(DhikrCounterState current) async {
    StorageBoundaryGuard.requirePrivateUserStore(_store);
    final nextCount = current.count >= _maxCount ? _maxCount : current.count + 1;
    final next = current.copyWith(count: nextCount);
    await _store.write(_storageKey, jsonEncode({'count': next.count}));
    return next;
  }

  Future<DhikrCounterState> reset() async {
    StorageBoundaryGuard.requirePrivateUserStore(_store);
    const next = DhikrCounterState(count: 0);
    await _store.write(_storageKey, jsonEncode({'count': 0}));
    return next;
  }
}
