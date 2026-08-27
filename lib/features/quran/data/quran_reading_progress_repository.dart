import 'dart:convert';

import 'package:islami_hayat/core/storage/storage_boundaries.dart';
import 'package:islami_hayat/features/quran/data/canonical_quran_source.dart';

final class QuranReadingProgress {
  const QuranReadingProgress({
    required this.surah,
    required this.ayah,
    required this.quranScale,
  });

  factory QuranReadingProgress.initial() => const QuranReadingProgress(
        surah: 1,
        ayah: 1,
        quranScale: 1,
      );

  factory QuranReadingProgress.fromJson(Map<String, dynamic> json) {
    if (json['schemaVersion'] != 1) {
      throw const QuranReadingProgressFormatException(
        'Unsupported Quran reading progress schema.',
      );
    }

    final surah = json['surah'];
    final ayah = json['ayah'];
    final rawScale = json['quranScale'];
    if (surah is! int || ayah is! int || rawScale is! num) {
      throw const QuranReadingProgressFormatException(
        'Quran reading progress has invalid field types.',
      );
    }

    final scale = rawScale.toDouble();
    _validate(surah: surah, ayah: ayah, quranScale: scale);
    return QuranReadingProgress(
      surah: surah,
      ayah: ayah,
      quranScale: scale,
    );
  }

  final int surah;
  final int ayah;
  final double quranScale;

  Map<String, Object> toJson() => <String, Object>{
        'schemaVersion': 1,
        'surah': surah,
        'ayah': ayah,
        'quranScale': quranScale,
      };

  QuranReadingProgress copyWith({
    int? surah,
    int? ayah,
    double? quranScale,
  }) {
    final nextSurah = surah ?? this.surah;
    final nextAyah = ayah ?? this.ayah;
    final nextScale = quranScale ?? this.quranScale;
    _validate(
      surah: nextSurah,
      ayah: nextAyah,
      quranScale: nextScale,
    );
    return QuranReadingProgress(
      surah: nextSurah,
      ayah: nextAyah,
      quranScale: nextScale,
    );
  }

  static void _validate({
    required int surah,
    required int ayah,
    required double quranScale,
  }) {
    if (surah < 1 || surah > canonicalQuranSuraCount) {
      throw const QuranReadingProgressFormatException(
        'Quran reading progress has invalid surah.',
      );
    }
    final maxAyah = canonicalQuranAyahCountForSura(surah);
    if (ayah < 1 || ayah > maxAyah) {
      throw const QuranReadingProgressFormatException(
        'Quran reading progress has invalid ayah.',
      );
    }
    if (!quranScale.isFinite || quranScale < 0.8 || quranScale > 1.6) {
      throw const QuranReadingProgressFormatException(
        'Quran reading progress has invalid font scale.',
      );
    }
  }
}

final class QuranReadingProgressRepository {
  QuranReadingProgressRepository(this._store) {
    StorageBoundaryGuard.requirePrivateUserStore(_store);
  }

  static const String storageKey = 'quran.reading-progress.v1';

  final PrivateUserStore _store;

  /// Returns null when the user has never persisted a Quran reading position.
  /// Corrupted persisted data still fails closed by throwing a format exception.
  Future<QuranReadingProgress?> loadSaved() async {
    final encoded = await _store.read(storageKey);
    if (encoded == null) return null;
    return _decode(encoded);
  }

  Future<QuranReadingProgress> load() async {
    return await loadSaved() ?? QuranReadingProgress.initial();
  }

  QuranReadingProgress _decode(String encoded) {
    try {
      final decoded = jsonDecode(encoded);
      if (decoded is! Map<String, dynamic>) {
        throw const QuranReadingProgressFormatException(
          'Expected Quran progress JSON object.',
        );
      }
      return QuranReadingProgress.fromJson(decoded);
    } on FormatException catch (error) {
      throw QuranReadingProgressFormatException(
        'Invalid Quran progress JSON: ${error.message}',
      );
    }
  }

  Future<void> save(QuranReadingProgress progress) async {
    QuranReadingProgress.fromJson(progress.toJson());
    await _store.write(storageKey, jsonEncode(progress.toJson()));
  }

  Future<void> reset() => _store.delete(storageKey);
}

final class QuranReadingProgressFormatException implements Exception {
  const QuranReadingProgressFormatException(this.message);

  final String message;

  @override
  String toString() => 'QuranReadingProgressFormatException: $message';
}
