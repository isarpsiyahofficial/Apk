import 'dart:convert';

import 'package:islami_hayat/core/storage/storage_boundaries.dart';

final class DhikrCounterState {
  const DhikrCounterState({
    required this.count,
    this.vibrationEnabled = false,
    this.soundEnabled = false,
  });

  final int count;
  final bool vibrationEnabled;
  final bool soundEnabled;

  DhikrCounterState copyWith({
    int? count,
    bool? vibrationEnabled,
    bool? soundEnabled,
  }) =>
      DhikrCounterState(
        count: count ?? this.count,
        vibrationEnabled: vibrationEnabled ?? this.vibrationEnabled,
        soundEnabled: soundEnabled ?? this.soundEnabled,
      );
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
      final vibrationEnabled = decoded['vibrationEnabled'];
      final soundEnabled = decoded['soundEnabled'];
      return DhikrCounterState(
        count: value,
        vibrationEnabled:
            vibrationEnabled is bool ? vibrationEnabled : false,
        soundEnabled: soundEnabled is bool ? soundEnabled : false,
      );
    } on FormatException {
      return const DhikrCounterState(count: 0);
    }
  }

  Future<DhikrCounterState> increment(DhikrCounterState current) async {
    StorageBoundaryGuard.requirePrivateUserStore(_store);
    final nextCount =
        current.count >= _maxCount ? _maxCount : current.count + 1;
    final next = current.copyWith(count: nextCount);
    await _persist(next);
    return next;
  }

  Future<DhikrCounterState> setFeedbackPreferences(
    DhikrCounterState current, {
    bool? vibrationEnabled,
    bool? soundEnabled,
  }) async {
    StorageBoundaryGuard.requirePrivateUserStore(_store);
    final next = current.copyWith(
      vibrationEnabled: vibrationEnabled,
      soundEnabled: soundEnabled,
    );
    await _persist(next);
    return next;
  }

  Future<DhikrCounterState> reset() async {
    StorageBoundaryGuard.requirePrivateUserStore(_store);
    final current = await load();
    final next = current.copyWith(count: 0);
    await _persist(next);
    return next;
  }

  Future<void> _persist(DhikrCounterState state) => _store.write(
        _storageKey,
        jsonEncode({
          'count': state.count,
          'vibrationEnabled': state.vibrationEnabled,
          'soundEnabled': state.soundEnabled,
        }),
      );
}
