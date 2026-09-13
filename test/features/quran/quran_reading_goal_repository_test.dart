import 'package:flutter_test/flutter_test.dart';
import 'package:islami_hayat/core/storage/storage_boundaries.dart';
import 'package:islami_hayat/features/quran/data/quran_reading_goal_repository.dart';

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
  group('QuranReadingGoalRepository', () {
    test('defaults disabled with no streak or missed-day state', () async {
      final store = _MemoryPrivateStore();
      final repository = QuranReadingGoalRepository(store);

      final goal = await repository.load();
      expect(goal.enabled, isFalse);
      expect(goal.unit, QuranReadingGoalUnit.ayahs);
      expect(goal.target, 5);
      expect(store.values.keys, isNot(contains('streak')));
      expect(store.values.keys, isNot(contains('missed')));
      expect(store.values.keys, isNot(contains('overdue')));
    });

    test('round-trips optional ayah and minute goals locally', () async {
      final store = _MemoryPrivateStore();
      final repository = QuranReadingGoalRepository(store);

      await repository.save(
        const QuranReadingGoal(
          enabled: true,
          unit: QuranReadingGoalUnit.ayahs,
          target: 12,
        ),
      );
      var loaded = await repository.load();
      expect(loaded.enabled, isTrue);
      expect(loaded.unit, QuranReadingGoalUnit.ayahs);
      expect(loaded.target, 12);

      await repository.save(
        const QuranReadingGoal(
          enabled: true,
          unit: QuranReadingGoalUnit.minutes,
          target: 20,
        ),
      );
      loaded = await repository.load();
      expect(loaded.unit, QuranReadingGoalUnit.minutes);
      expect(loaded.target, 20);
    });

    test('rejects unreasonable targets instead of storing corrupt preferences', () async {
      final repository = QuranReadingGoalRepository(_MemoryPrivateStore());

      expect(
        () => repository.save(
          const QuranReadingGoal(
            enabled: true,
            unit: QuranReadingGoalUnit.ayahs,
            target: 0,
          ),
        ),
        throwsRangeError,
      );
      expect(
        () => repository.save(
          const QuranReadingGoal(
            enabled: true,
            unit: QuranReadingGoalUnit.minutes,
            target: 241,
          ),
        ),
        throwsRangeError,
      );
    });

    test('corrupt goal data fails closed and reset restores disabled default', () async {
      final store = _MemoryPrivateStore();
      final repository = QuranReadingGoalRepository(store);
      await store.write(QuranReadingGoalRepository.storageKey, '{bad json');

      expect(
        () => repository.load(),
        throwsA(isA<QuranReadingGoalFormatException>()),
      );

      await repository.reset();
      final reset = await repository.load();
      expect(reset.enabled, isFalse);
    });
  });
}
