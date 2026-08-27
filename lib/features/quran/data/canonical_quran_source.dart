import 'dart:convert';

import 'package:flutter/services.dart';
import 'package:islami_hayat/core/content/content_integrity.dart';

const _ayahCounts = <int>[
  7, 286, 200, 176, 120, 165, 206, 75, 129, 109, 123, 111, 43, 52, 99,
  128, 111, 110, 98, 135, 112, 78, 118, 64, 77, 227, 93, 88, 69, 60, 34,
  30, 73, 54, 45, 83, 182, 88, 75, 85, 54, 53, 89, 59, 37, 35, 38, 29,
  18, 45, 60, 49, 62, 55, 78, 96, 29, 22, 24, 13, 14, 11, 11, 18, 12,
  12, 30, 52, 52, 44, 28, 28, 20, 56, 40, 31, 50, 40, 46, 42, 29, 19,
  36, 25, 22, 17, 19, 26, 30, 20, 15, 21, 11, 8, 8, 19, 5, 8, 8, 11,
  11, 8, 3, 9, 5, 4, 7, 3, 6, 3, 5, 4, 5, 6,
];

const canonicalQuranAyahCount = 6236;
const canonicalQuranSuraCount = 114;
const canonicalQuranAssetPath = 'assets/quran/source/quran-uthmani.txt';
const canonicalQuranManifestPath =
    'assets/quran/source/quran-uthmani.manifest.json';

final class QuranAyah {
  const QuranAyah({
    required this.sura,
    required this.ayah,
    required this.arabic,
  });

  final int sura;
  final int ayah;
  final String arabic;

  String get key => '$sura:$ayah';
}

final class CanonicalQuranDataset {
  CanonicalQuranDataset._({
    required this.ayahs,
    required this.sha256,
    required this.sourceVersion,
  });

  final List<QuranAyah> ayahs;
  final String sha256;
  final String sourceVersion;

  QuranAyah ayah(int sura, int ayah) {
    if (sura < 1 || sura > canonicalQuranSuraCount) {
      throw RangeError.range(sura, 1, canonicalQuranSuraCount, 'sura');
    }
    final maxAyah = _ayahCounts[sura - 1];
    if (ayah < 1 || ayah > maxAyah) {
      throw RangeError.range(ayah, 1, maxAyah, 'ayah');
    }
    var offset = 0;
    for (var index = 0; index < sura - 1; index++) {
      offset += _ayahCounts[index];
    }
    return ayahs[offset + ayah - 1];
  }

  static CanonicalQuranDataset parse({
    required Uint8List sourceBytes,
    required Map<String, dynamic> manifest,
  }) {
    _validateManifestShape(manifest);

    final expectedSha = manifest['sha256'] as String;
    ContentIntegrity.requireValidByteSha256(
      datasetId: 'quran-uthmani-v1.1',
      bytes: sourceBytes,
      expectedSha256: expectedSha,
    );

    if (sourceBytes.length != manifest['bytes']) {
      throw const CanonicalQuranException('Source byte length mismatch.');
    }

    final source = utf8.decode(sourceBytes, allowMalformed: false);
    final lines = const LineSplitter().convert(source);
    if (lines.length < canonicalQuranAyahCount) {
      throw const CanonicalQuranException(
        'Canonical source contains fewer than 6236 Quran records.',
      );
    }

    final quranLines = lines.take(canonicalQuranAyahCount).toList(growable: false);
    final footer = lines.skip(canonicalQuranAyahCount).toList(growable: false);
    if (footer.length != manifest['footer_lines']) {
      throw const CanonicalQuranException('Attribution footer length mismatch.');
    }
    for (final line in footer) {
      if (line.isNotEmpty && !line.startsWith('#')) {
        throw const CanonicalQuranException(
          'Unexpected content after the canonical Quran records.',
        );
      }
    }

    final parsed = <QuranAyah>[];
    var expectedSura = 1;
    var expectedAyah = 1;

    for (var index = 0; index < quranLines.length; index++) {
      final line = quranLines[index];
      final firstPipe = line.indexOf('|');
      final secondPipe = firstPipe < 0 ? -1 : line.indexOf('|', firstPipe + 1);
      if (firstPipe <= 0 || secondPipe <= firstPipe + 1) {
        throw CanonicalQuranException('Malformed Quran record at line ${index + 1}.');
      }

      final sura = int.tryParse(line.substring(0, firstPipe));
      final ayah = int.tryParse(line.substring(firstPipe + 1, secondPipe));
      final arabic = line.substring(secondPipe + 1);
      if (sura == null || ayah == null || arabic.trim().isEmpty) {
        throw CanonicalQuranException('Invalid Quran record at line ${index + 1}.');
      }
      if (sura != expectedSura || ayah != expectedAyah) {
        throw CanonicalQuranException(
          'Unexpected Quran order at line ${index + 1}: '
          'found $sura:$ayah, expected $expectedSura:$expectedAyah.',
        );
      }

      parsed.add(QuranAyah(sura: sura, ayah: ayah, arabic: arabic));

      if (expectedAyah == _ayahCounts[expectedSura - 1]) {
        expectedSura++;
        expectedAyah = 1;
      } else {
        expectedAyah++;
      }
    }

    if (parsed.length != canonicalQuranAyahCount || expectedSura != 115) {
      throw const CanonicalQuranException('Canonical Quran structure is incomplete.');
    }

    return CanonicalQuranDataset._(
      ayahs: List.unmodifiable(parsed),
      sha256: expectedSha,
      sourceVersion: manifest['source_version'] as String,
    );
  }

  static void _validateManifestShape(Map<String, dynamic> manifest) {
    final required = <String, Object>{
      'source': 'Tanzil Project',
      'text_family': 'Uthmani',
      'source_version': '1.1',
      'layout': 'sura|ayah|text',
      'surahs': canonicalQuranSuraCount,
      'ayahs': canonicalQuranAyahCount,
    };
    for (final entry in required.entries) {
      if (manifest[entry.key] != entry.value) {
        throw CanonicalQuranException(
          'Pinned Quran manifest mismatch for ${entry.key}.',
        );
      }
    }
    if (manifest['bytes'] is! int || manifest['footer_lines'] is! int) {
      throw const CanonicalQuranException('Pinned Quran manifest is incomplete.');
    }
    final sha = manifest['sha256'];
    if (sha is! String || !RegExp(r'^[0-9a-f]{64}$').hasMatch(sha)) {
      throw const CanonicalQuranException('Pinned Quran SHA-256 is invalid.');
    }
  }
}

final class CanonicalQuranAssetLoader {
  CanonicalQuranAssetLoader({AssetBundle? bundle}) : bundle = bundle ?? rootBundle;

  final AssetBundle bundle;

  Future<CanonicalQuranDataset> load() async {
    final sourceData = await bundle.load(canonicalQuranAssetPath);
    final manifestText = await bundle.loadString(canonicalQuranManifestPath);
    final manifestValue = jsonDecode(manifestText);
    if (manifestValue is! Map<String, dynamic>) {
      throw const CanonicalQuranException('Quran manifest root is invalid.');
    }
    return CanonicalQuranDataset.parse(
      sourceBytes: sourceData.buffer.asUint8List(
        sourceData.offsetInBytes,
        sourceData.lengthInBytes,
      ),
      manifest: manifestValue,
    );
  }
}

final class CanonicalQuranException implements Exception {
  const CanonicalQuranException(this.message);

  final String message;

  @override
  String toString() => 'CanonicalQuranException: $message';
}
