import 'package:flutter_test/flutter_test.dart';
import 'package:islami_hayat/core/storage/storage_boundaries.dart';
import 'package:islami_hayat/features/quran/data/quran_reading_progress_repository.dart';

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
  test('missing progress returns stable Quran start position', () async {
    final repository = QuranReadingProgressRepository(_MemoryPrivateStore());

    final progress = await repository.load();

    expect(progress.surah, 1);
    expect(progress.ayah, 1);
    expect(progress.quranScale, 1);
  });

  test('valid last-read position and Quran font scale round-trip', () async {
    final store = _MemoryPrivateStore();
    final repository = QuranReadingProgressRepository(store);
    const progress = QuranReadingProgress(
      surah: 18,
      ayah: 10,
      quranScale: 1.3,
    );

    await repository.save(progress);
    final restored = await repository.load();

    expect(restored.surah, 18);
    expect(restored.ayah, 10);
    expect(restored.quranScale, 1.3);
  });

  test('canonical Quran boundaries reject impossible ayah positions', () {
    expect(
      () => const QuranReadingProgress(
        surah: 1,
        ayah: 8,
        quranScale: 1,
      ).copyWith(),
      throwsA(isA<QuranReadingProgressFormatException>()),
    );
    expect(
      () => const QuranReadingProgress(
        surah: 114,
        ayah: 7,
        quranScale: 1,
      ).copyWith(),
      throwsA(isA<QuranReadingProgressFormatException>()),
    );
  });

  test('font scale is constrained to reader accessibility contract', () {
    expect(
      () => QuranReadingProgress.initial().copyWith(quranScale: 0.7),
      throwsA(isA<QuranReadingProgressFormatException>()),
    );
    expect(
      () => QuranReadingProgress.initial().copyWith(quranScale: 1.7),
      throwsA(isA<QuranReadingProgressFormatException>()),
    );
  });

  test('corrupt stored progress is fail-closed instead of silently used', () async {
    final store = _MemoryPrivateStore();
    final repository = QuranReadingProgressRepository(store);
    store.values[QuranReadingProgressRepository.storageKey] =
        '{"schemaVersion":1,"surah":2,"ayah":287,"quranScale":1.0}';

    expect(
      repository.load(),
      throwsA(isA<QuranReadingProgressFormatException>()),
    );
  });

  test('reset removes only Quran progress record', () async {
    final store = _MemoryPrivateStore();
    final repository = QuranReadingProgressRepository(store);
    await repository.save(QuranReadingProgress.initial());
    store.values['unrelated'] = 'keep';

    await repository.reset();

    expect(store.values[QuranReadingProgressRepository.storageKey], isNull);
    expect(store.values['unrelated'], 'keep');
  });
}
