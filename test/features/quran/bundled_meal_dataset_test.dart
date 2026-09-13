import 'dart:convert';
import 'dart:typed_data';

import 'package:crypto/crypto.dart';
import 'package:flutter/services.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:islami_hayat/features/quran/data/bundled_meal_dataset.dart';
import 'package:islami_hayat/features/quran/data/verified_meal_sources.dart';

void main() {
  TestWidgetsFlutterBinding.ensureInitialized();

  test('loads a byte-pinned complete ordered meal dataset', () async {
    final raw = _buildDataset();
    final source = _testSource(raw);
    final loader = BundledMealDatasetLoader(
      bytesLoader: (_) async => ByteData.sublistView(Uint8List.fromList(raw)),
    );

    final dataset = await loader.loadSource(source);

    expect(dataset.verses, hasLength(6236));
    expect(dataset.verse(1, 1).translation, 'meal-1-1');
    expect(dataset.verse(114, 6123).translation, 'meal-114-6123');
  });

  test('fails closed when one byte changes', () async {
    final raw = _buildDataset();
    final source = _testSource(raw);
    final tampered = Uint8List.fromList(raw)..[raw.length - 2] ^= 1;
    final loader = BundledMealDatasetLoader(
      bytesLoader: (_) async => ByteData.sublistView(tampered),
    );

    expect(loader.loadSource(source), throwsStateError);
  });

  test('fails closed for wrong source key even with matching bytes', () async {
    final raw = _buildDataset(translationKey: 'wrong_key');
    final source = VerifiedMealSource(
      locale: 'xx',
      translationKey: 'expected_key',
      publisher: 'Test',
      version: 'V1',
      canonicalSha256: sha256.convert(raw).toString(),
      surahCount: 114,
      ayahCount: 6236,
    );
    final loader = BundledMealDatasetLoader(
      bytesLoader: (_) async => ByteData.sublistView(Uint8List.fromList(raw)),
    );

    expect(loader.loadSource(source), throwsStateError);
  });

  test('fails closed for duplicate or non-contiguous locators', () async {
    final raw = _buildDataset(breakOrdering: true);
    final source = _testSource(raw);
    final loader = BundledMealDatasetLoader(
      bytesLoader: (_) async => ByteData.sublistView(Uint8List.fromList(raw)),
    );

    expect(loader.loadSource(source), throwsStateError);
  });
}

List<int> _buildDataset({
  String translationKey = 'test_key',
  bool breakOrdering = false,
}) {
  final verses = <Map<String, Object?>>[];
  // Synthetic test data intentionally distributes 6236 rows across all 114
  // surahs. Runtime authenticity is guaranteed by the pinned canonical SHA;
  // QuranEnc source verification separately checks the true per-surah counts.
  var remaining = 6236;
  for (var surah = 1; surah <= 114; surah++) {
    final count = surah == 114 ? remaining : 1;
    for (var ayah = 1; ayah <= count; ayah++) {
      verses.add({
        'sura': surah,
        'aya': breakOrdering && surah == 2 ? 2 : ayah,
        'translation': 'meal-$surah-$ayah',
        'footnotes': null,
      });
    }
    remaining -= count;
  }
  final dataset = {
    'translation_key': translationKey,
    'publisher': 'Test',
    'source': 'QuranEnc.com',
    'version': 'V1',
    'verses': verses,
  };
  return utf8.encode(
    '${jsonEncode(_sortForCanonicalJson(dataset))}\n',
  );
}

VerifiedMealSource _testSource(List<int> raw) => VerifiedMealSource(
      locale: 'xx',
      translationKey: 'test_key',
      publisher: 'Test',
      version: 'V1',
      canonicalSha256: sha256.convert(raw).toString(),
      surahCount: 114,
      ayahCount: 6236,
    );

Map<String, dynamic> _sortForCanonicalJson(Map<String, dynamic> input) {
  // Dart jsonEncode preserves insertion order. Re-create the exact alphabetical
  // top-level order emitted by the Python verifier with sort_keys=True.
  return {
    'publisher': input['publisher'],
    'source': input['source'],
    'translation_key': input['translation_key'],
    'version': input['version'],
    'verses': input['verses'],
  };
}
