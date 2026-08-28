import 'dart:io';

import 'package:flutter_test/flutter_test.dart';

String _fold(String value) => value
    .toLowerCase()
    .replaceAll('ı', 'i')
    .replaceAll('ş', 's')
    .replaceAll('ğ', 'g')
    .replaceAll('ü', 'u')
    .replaceAll('ö', 'o')
    .replaceAll('ç', 'c');

Iterable<File> _productionDartFiles() sync* {
  final root = Directory('lib');
  if (!root.existsSync()) {
    throw StateError('Production lib directory is missing.');
  }
  for (final entity in root.listSync(recursive: true, followLinks: false)) {
    if (entity is File && entity.path.endsWith('.dart')) {
      yield entity;
    }
  }
}

void main() {
  test('production source tree contains no forbidden occult feature path', () {
    const forbiddenPathTokens = <String>[
      'vefk',
      'tilsim',
      'talisman',
      'love_binding',
      'love-binding',
      'ask_baglama',
      'ask-baglama',
      'divination',
      'fortune_telling',
      'fortune-telling',
      'fate_analysis',
      'fate-analysis',
      'occult_analysis',
      'occult-analysis',
    ];

    final violations = <String>[];
    for (final file in _productionDartFiles()) {
      final path = _fold(file.path.replaceAll('\\', '/'));
      for (final token in forbiddenPathTokens) {
        if (path.contains(token)) {
          violations.add('$path -> $token');
        }
      }
    }

    expect(
      violations,
      isEmpty,
      reason: 'SPEC 299–303 forbids implementing occult feature modules/routes.',
    );
  });

  test('production UI/routes expose no forbidden occult action or analysis', () {
    final forbidden = <RegExp>[
      RegExp(r"['\"]\s*/(?:vefk|tilsim|talisman)(?:/|['\"])", caseSensitive: false),
      RegExp(r"['\"]\s*/(?:ask[-_]?baglama|love[-_]?binding)(?:/|['\"])", caseSensitive: false),
      RegExp(r"['\"]\s*/(?:divination|fortune[-_]?telling|fate[-_]?analysis|occult[-_]?analysis)(?:/|['\"])", caseSensitive: false),
      RegExp(r'\b(?:vefk|tilsim|ask baglama|gayb analizi|kader analizi)\b', caseSensitive: false),
      RegExp(r'\b(?:love binding|fortune telling|fate analysis|occult name analysis|occult birth date analysis)\b', caseSensitive: false),
    ];

    final violations = <String>[];
    for (final file in _productionDartFiles()) {
      final source = _fold(file.readAsStringSync());
      for (final pattern in forbidden) {
        if (pattern.hasMatch(source)) {
          violations.add('${file.path} -> ${pattern.pattern}');
        }
      }
    }

    expect(
      violations,
      isEmpty,
      reason: 'Forbidden occult, coercive-love, unseen/fate and name/birth-date analysis paths must remain absent from production code.',
    );
  });
}
