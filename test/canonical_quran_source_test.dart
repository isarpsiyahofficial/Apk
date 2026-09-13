import 'dart:convert';
import 'dart:typed_data';

import 'package:flutter_test/flutter_test.dart';
import 'package:islami_hayat/core/content/content_integrity.dart';
import 'package:islami_hayat/features/quran/data/canonical_quran_source.dart';

const _counts = <int>[
  7, 286, 200, 176, 120, 165, 206, 75, 129, 109, 123, 111, 43, 52, 99,
  128, 111, 110, 98, 135, 112, 78, 118, 64, 77, 227, 93, 88, 69, 60, 34,
  30, 73, 54, 45, 83, 182, 88, 75, 85, 54, 53, 89, 59, 37, 35, 38, 29,
  18, 45, 60, 49, 62, 55, 78, 96, 29, 22, 24, 13, 14, 11, 11, 18, 12,
  12, 30, 52, 52, 44, 28, 28, 20, 56, 40, 31, 50, 40, 46, 42, 29, 19,
  36, 25, 22, 17, 19, 26, 30, 20, 15, 21, 11, 8, 8, 19, 5, 8, 8, 11,
  11, 8, 3, 9, 5, 4, 7, 3, 6, 3, 5, 4, 5, 6,
];

Uint8List _sourceBytes() {
  final buffer = StringBuffer();
  for (var sura = 1; sura <= _counts.length; sura++) {
    for (var ayah = 1; ayah <= _counts[sura - 1]; ayah++) {
      buffer.writeln('$sura|$ayah|آية $sura:$ayah');
    }
  }
  buffer
    ..writeln()
    ..writeln('# Tanzil Quran Text')
    ..writeln('# License: Creative Commons Attribution 3.0');
  return Uint8List.fromList(utf8.encode(buffer.toString()));
}

Map<String, dynamic> _manifest(Uint8List bytes) => <String, dynamic>{
      'source': 'Tanzil Project',
      'text_family': 'Uthmani',
      'source_version': '1.1',
      'layout': 'sura|ayah|text',
      'surahs': 114,
      'ayahs': 6236,
      'footer_lines': 3,
      'bytes': bytes.length,
      'sha256': ContentIntegrity.sha256Bytes(bytes),
    };

void main() {
  test('parses exactly 114 suras and 6236 ordered ayahs', () {
    final bytes = _sourceBytes();
    final dataset = CanonicalQuranDataset.parse(
      sourceBytes: bytes,
      manifest: _manifest(bytes),
    );

    expect(dataset.ayahs, hasLength(6236));
    expect(dataset.ayah(1, 1).key, '1:1');
    expect(dataset.ayah(1, 7).key, '1:7');
    expect(dataset.ayah(2, 286).key, '2:286');
    expect(dataset.ayah(114, 6).key, '114:6');
  });

  test('fails closed when one exact source byte changes', () {
    final bytes = _sourceBytes();
    final manifest = _manifest(bytes);
    final tampered = Uint8List.fromList(bytes);
    tampered[20] = tampered[20] == 65 ? 66 : 65;

    expect(
      () => CanonicalQuranDataset.parse(
        sourceBytes: tampered,
        manifest: manifest,
      ),
      throwsA(isA<ContentIntegrityException>()),
    );
  });

  test('fails closed when the pinned source length is wrong', () {
    final bytes = _sourceBytes();
    final manifest = _manifest(bytes)..['bytes'] = bytes.length + 1;

    expect(
      () => CanonicalQuranDataset.parse(
        sourceBytes: bytes,
        manifest: manifest,
      ),
      throwsA(isA<CanonicalQuranException>()),
    );
  });

  test('fails closed on unexpected non-license footer content', () {
    final bytes = _sourceBytes();
    final source = utf8.decode(bytes).replaceFirst(
          '# Tanzil Quran Text',
          'unexpected extra content',
        );
    final changed = Uint8List.fromList(utf8.encode(source));

    expect(
      () => CanonicalQuranDataset.parse(
        sourceBytes: changed,
        manifest: _manifest(changed),
      ),
      throwsA(isA<CanonicalQuranException>()),
    );
  });

  test('rejects invalid sura and ayah lookup', () {
    final bytes = _sourceBytes();
    final dataset = CanonicalQuranDataset.parse(
      sourceBytes: bytes,
      manifest: _manifest(bytes),
    );

    expect(() => dataset.ayah(0, 1), throwsRangeError);
    expect(() => dataset.ayah(1, 8), throwsRangeError);
    expect(() => dataset.ayah(115, 1), throwsRangeError);
  });
}
