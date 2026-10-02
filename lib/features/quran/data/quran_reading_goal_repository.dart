import 'dart:convert';

import 'package:islami_hayat/core/storage/secure_private_user_store.dart';
import 'package:islami_hayat/core/storage/storage_boundaries.dart';

enum QuranReadingGoalUnit { ayahs, minutes }

final class QuranReadingGoal {
  const QuranReadingGoal({
    required this.enabled,
    required this.unit,
    required this.target,
  });

  const QuranReadingGoal.disabled()
    : enabled = false,
      unit = QuranReadingGoalUnit.ayahs,
      target = 5;

  final bool enabled;
  final QuranReadingGoalUnit unit;
  final int target;

  QuranReadingGoal copyWith({
    bool? enabled,
    QuranReadingGoalUnit? unit,
    int? target,
  }) {
    return QuranReadingGoal(
      enabled: enabled ?? this.enabled,
      unit: unit ?? this.unit,
      target: target ?? this.target,
    );
  }
}

abstract interface class QuranReadingGoalDataSource {
  Future<QuranReadingGoal> load();
  Future<void> save(QuranReadingGoal goal);
  Future<void> reset();
}

/// Stores an optional, private Quran reading preference only on the device.
///
/// This repository deliberately has no streak, overdue, missed-day or ranking
/// state. A reading goal is a convenience preference, not a compliance score.
final class QuranReadingGoalRepository implements QuranReadingGoalDataSource {
  QuranReadingGoalRepository([PrivateUserStore? store])
    : _store = store ?? SecurePrivateUserStore() {
    StorageBoundaryGuard.requirePrivateUserStore(_store);
  }

  static const String storageKey = 'quran.reading_goal.v1';
  static const int minAyahTarget = 1;
  static const int maxAyahTarget = 500;
  static const int minMinuteTarget = 1;
  static const int maxMinuteTarget = 240;

  final PrivateUserStore _store;

  @override
  Future<QuranReadingGoal> load() async {
    final raw = await _store.read(storageKey);
    if (raw == null) return const QuranReadingGoal.disabled();

    try {
      final json = jsonDecode(raw);
      if (json is! Map<String, dynamic>) {
        throw const QuranReadingGoalFormatException('Expected JSON object.');
      }
      if (json['schemaVersion'] != 1 || json['enabled'] is! bool) {
        throw const QuranReadingGoalFormatException('Invalid goal schema.');
      }
      final unitName = json['unit'];
      final target = json['target'];
      if (unitName is! String || target is! int) {
        throw const QuranReadingGoalFormatException('Invalid goal fields.');
      }
      final unit = QuranReadingGoalUnit.values.where(
        (candidate) => candidate.name == unitName,
      );
      if (unit.length != 1) {
        throw const QuranReadingGoalFormatException('Unknown goal unit.');
      }
      final result = QuranReadingGoal(
        enabled: json['enabled'] as bool,
        unit: unit.single,
        target: target,
      );
      _validate(result);
      return result;
    } on FormatException catch (error) {
      throw QuranReadingGoalFormatException(
        'Invalid stored JSON: ${error.message}',
      );
    }
  }

  @override
  Future<void> save(QuranReadingGoal goal) async {
    _validate(goal);
    await _store.write(
      storageKey,
      jsonEncode(<String, Object>{
        'schemaVersion': 1,
        'enabled': goal.enabled,
        'unit': goal.unit.name,
        'target': goal.target,
      }),
    );
  }

  @override
  Future<void> reset() => _store.delete(storageKey);

  static void _validate(QuranReadingGoal goal) {
    final (min, max) = switch (goal.unit) {
      QuranReadingGoalUnit.ayahs => (minAyahTarget, maxAyahTarget),
      QuranReadingGoalUnit.minutes => (minMinuteTarget, maxMinuteTarget),
    };
    if (goal.target < min || goal.target > max) {
      throw RangeError.range(goal.target, min, max, 'target');
    }
  }
}

final class QuranReadingGoalFormatException implements Exception {
  const QuranReadingGoalFormatException(this.message);

  final String message;

  @override
  String toString() => 'QuranReadingGoalFormatException: $message';
}
