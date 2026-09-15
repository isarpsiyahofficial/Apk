import 'dart:convert';

import 'package:islami_hayat/core/storage/storage_boundaries.dart';

final class DhikrHistoryEntry {
  const DhikrHistoryEntry({required this.occurredAt, required this.count});

  final DateTime occurredAt;
  final int count;

  Map<String, Object> toJson() => {
        'occurredAt': occurredAt.toUtc().toIso8601String(),
        'count': count,
      };
}

final class DhikrHistorySummary {
  const DhikrHistorySummary({
    required this.todayTotal,
    required this.lastSevenDaysTotal,
    required this.currentStreakDays,
    required this.entries,
  });

  final int todayTotal;
  final int lastSevenDaysTotal;
  final int currentStreakDays;
  final List<DhikrHistoryEntry> entries;
}

final class DhikrHistoryRepository {
  DhikrHistoryRepository(this._store, {DateTime Function()? now})
      : _now = now ?? DateTime.now;

  static const _storageKey = 'dhikr.history.v1';
  static const _maxEntries = 365;
  static const _maxSessionCount = 999999999;

  final PrivateUserStore _store;
  final DateTime Function() _now;

  Future<List<DhikrHistoryEntry>> load() async {
    StorageBoundaryGuard.requirePrivateUserStore(_store);
    final raw = await _store.read(_storageKey);
    if (raw == null || raw.trim().isEmpty) return const [];

    try {
      final decoded = jsonDecode(raw);
      if (decoded is! List) return const [];
      final entries = <DhikrHistoryEntry>[];
      for (final item in decoded) {
        if (item is! Map<String, dynamic>) return const [];
        final count = item['count'];
        final occurredAtRaw = item['occurredAt'];
        if (count is! int ||
            count <= 0 ||
            count > _maxSessionCount ||
            occurredAtRaw is! String) {
          return const [];
        }
        final occurredAt = DateTime.tryParse(occurredAtRaw);
        if (occurredAt == null) return const [];
        entries.add(DhikrHistoryEntry(occurredAt: occurredAt, count: count));
      }
      entries.sort((a, b) => b.occurredAt.compareTo(a.occurredAt));
      return List.unmodifiable(entries.take(_maxEntries));
    } on FormatException {
      return const [];
    }
  }

  Future<List<DhikrHistoryEntry>> recordSession({
    required int count,
    DateTime? occurredAt,
  }) async {
    StorageBoundaryGuard.requirePrivateUserStore(_store);
    if (count <= 0 || count > _maxSessionCount) {
      throw ArgumentError.value(count, 'count', 'must be between 1 and $_maxSessionCount');
    }
    final entries = [...await load()];
    entries.add(DhikrHistoryEntry(occurredAt: occurredAt ?? _now(), count: count));
    entries.sort((a, b) => b.occurredAt.compareTo(a.occurredAt));
    final bounded = entries.take(_maxEntries).toList(growable: false);
    await _store.write(_storageKey, jsonEncode(bounded.map((e) => e.toJson()).toList()));
    return List.unmodifiable(bounded);
  }

  Future<DhikrHistorySummary> summary({DateTime? now}) async {
    final localNow = now ?? _now();
    final today = _dateOnly(localNow);
    final entries = await load();
    var todayTotal = 0;
    var weeklyTotal = 0;
    final activeDays = <DateTime>{};

    for (final entry in entries) {
      final day = _dateOnly(entry.occurredAt.toLocal());
      if (day == today) todayTotal += entry.count;
      final age = today.difference(day).inDays;
      if (age >= 0 && age < 7) weeklyTotal += entry.count;
      if (day.isBefore(today) || day == today) activeDays.add(day);
    }

    var streak = 0;
    var cursor = today;
    while (activeDays.contains(cursor)) {
      streak += 1;
      cursor = cursor.subtract(const Duration(days: 1));
    }

    return DhikrHistorySummary(
      todayTotal: todayTotal,
      lastSevenDaysTotal: weeklyTotal,
      currentStreakDays: streak,
      entries: entries,
    );
  }

  Future<void> clear() async {
    StorageBoundaryGuard.requirePrivateUserStore(_store);
    await _store.delete(_storageKey);
  }

  static DateTime _dateOnly(DateTime value) => DateTime(value.year, value.month, value.day);
}
