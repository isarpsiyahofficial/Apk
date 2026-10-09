import 'dart:convert';

import 'package:crypto/crypto.dart';
import 'package:flutter/services.dart';
import 'package:islami_hayat/features/quran/data/verified_meal_sources.dart';

class MealVerse {
  const MealVerse({
    required this.surah,
    required this.ayah,
    required this.translation,
    this.footnotes,
  });

  final int surah;
  final int ayah;
  final String translation;
  final String? footnotes;
}

class BundledMealDataset {
  const BundledMealDataset({
    required this.source,
    required this.verses,
  });

  final VerifiedMealSource source;
  final List<MealVerse> verses;

  MealVerse verse(int surah, int ayah) {
    return verses.firstWhere(
      (item) => item.surah == surah && item.ayah == ayah,
      orElse: () => throw StateError('Missing meal verse $surah:$ayah'),
    );
  }
}

typedef MealAssetBytesLoader = Future<ByteData> Function(String assetPath);

class BundledMealDatasetLoader {
  BundledMealDatasetLoader({
    AssetBundle? bundle,
    MealAssetBytesLoader? bytesLoader,
  }) : _bytesLoader = bytesLoader ?? (bundle ?? rootBundle).load;

  final MealAssetBytesLoader _bytesLoader;

  static String assetPathFor(VerifiedMealSource source) {
    return 'assets/quran/meals/${source.translationKey}.json';
  }

  Future<BundledMealDataset> loadForLocale(String languageCode) async {
    final source = VerifiedMealSources.forLocale(languageCode);
    return loadSource(source);
  }

  Future<BundledMealDataset> loadSource(VerifiedMealSource source) async {
    final rawData = await _bytesLoader(assetPathFor(source));
    final bytes = rawData.buffer.asUint8List(
      rawData.offsetInBytes,
      rawData.lengthInBytes,
    );
    final actualSha = sha256.convert(bytes).toString();
    if (actualSha != source.canonicalSha256) {
      throw StateError('Meal SHA-256 mismatch for ${source.locale}');
    }

    final dynamic decoded;
    try {
      decoded = jsonDecode(utf8.decode(bytes));
    } on Object catch (error) {
      throw StateError('Invalid meal JSON for ${source.locale}: $error');
    }
    if (decoded is! Map<String, dynamic>) {
      throw StateError('Meal dataset root must be an object');
    }

    final translationKey = decoded['translation_key'];
    final version = decoded['version'];
    final rows = decoded['verses'];
    if (translationKey is! String || version is! String || rows is! List) {
      throw StateError('Meal dataset metadata is incomplete');
    }

    final verses = <MealVerse>[];
    final seen = <String>{};
    final seenSurahs = <int>{};
    for (final row in rows) {
      if (row is! Map<String, dynamic>) {
        throw StateError('Meal verse row must be an object');
      }
      final surah = row['sura'];
      final ayah = row['aya'];
      final translation = row['translation'];
      final footnotes = row['footnotes'];
      if (surah is! int || ayah is! int || translation is! String) {
        throw StateError('Meal verse locator/text is invalid');
      }
      if (translation.trim().isEmpty) {
        throw StateError('Meal verse $surah:$ayah is empty');
      }
      if (footnotes != null && footnotes is! String) {
        throw StateError('Meal footnotes $surah:$ayah are invalid');
      }
      final locator = '$surah:$ayah';
      if (!seen.add(locator)) {
        throw StateError('Duplicate meal verse $locator');
      }
      seenSurahs.add(surah);
      verses.add(
        MealVerse(
          surah: surah,
          ayah: ayah,
          translation: translation,
          footnotes: footnotes as String?,
        ),
      );
    }

    source.validate(
      actualTranslationKey: translationKey,
      actualVersion: version,
      actualSha256: actualSha,
      actualSurahCount: seenSurahs.length,
      actualAyahCount: verses.length,
    );

    _validateCanonicalOrdering(verses);
    return BundledMealDataset(source: source, verses: List.unmodifiable(verses));
  }

  static void _validateCanonicalOrdering(List<MealVerse> verses) {
    var previousSurah = 0;
    var previousAyah = 0;
    for (final verse in verses) {
      if (verse.surah < 1 || verse.surah > 114 || verse.ayah < 1) {
        throw StateError('Meal locator is out of range');
      }
      if (verse.surah == previousSurah) {
        if (verse.ayah != previousAyah + 1) {
          throw StateError('Meal ayah order is not contiguous');
        }
      } else {
        if (verse.surah != previousSurah + 1 || verse.ayah != 1) {
          throw StateError('Meal surah order is not contiguous');
        }
      }
      previousSurah = verse.surah;
      previousAyah = verse.ayah;
    }
  }
}
