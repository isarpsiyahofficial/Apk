import 'dart:io';

import 'package:flutter_test/flutter_test.dart';

void main() {
  test('T0306 hardened manifest requests no sensitive device permissions', () {
    final manifest = File('android_hardening/AndroidManifest.xml').readAsStringSync();
    const forbidden = <String>[
      'android.permission.ACCESS_FINE_LOCATION',
      'android.permission.ACCESS_COARSE_LOCATION',
      'android.permission.RECORD_AUDIO',
      'android.permission.CAMERA',
      'android.permission.READ_CONTACTS',
      'android.permission.WRITE_CONTACTS',
      'android.permission.GET_ACCOUNTS',
    ];

    for (final permission in forbidden) {
      expect(manifest, isNot(contains(permission)), reason: permission);
    }
  });

  test('T0307 share production tree cannot import private notes or clipboard', () {
    final files = _dartFiles(Directory('lib/features/share'));
    expect(files, isNotEmpty);

    const forbidden = <String>[
      'quran_reflection_note_repository.dart',
      'QuestionHistoryPrivacyT0303',
      'Clipboard.setData',
      'ClipboardData(',
      'privateNote',
      'reflectionNotes',
    ];

    for (final file in files) {
      final source = file.readAsStringSync();
      for (final token in forbidden) {
        expect(
          source,
          isNot(contains(token)),
          reason: '${file.path} must not export private user data via $token',
        );
      }
    }
  });

  test('T0308 production Dart has no direct debug logging or embedded secrets', () {
    final files = _dartFiles(Directory('lib'));
    expect(files, isNotEmpty);

    final debugLogPatterns = <RegExp>[
      RegExp(r'\bdebugPrint\s*\('),
      RegExp(r'(^|[^A-Za-z0-9_])print\s*\('),
      RegExp(r'\bdeveloper\.log\s*\('),
    ];
    final secretPatterns = <RegExp>[
      RegExp(r'AIza[0-9A-Za-z_-]{30,}'),
      RegExp(r'\bsk-[A-Za-z0-9_-]{20,}'),
      RegExp(r'-----BEGIN (RSA |EC |OPENSSH )?PRIVATE KEY-----'),
      RegExp(r'\bgh[pousr]_[A-Za-z0-9]{30,}'),
    ];

    for (final file in files) {
      final source = file.readAsStringSync();
      for (final pattern in debugLogPatterns) {
        expect(
          pattern.hasMatch(source),
          isFalse,
          reason: '${file.path} contains a direct production debug-log call: $pattern',
        );
      }
      for (final pattern in secretPatterns) {
        expect(
          pattern.hasMatch(source),
          isFalse,
          reason: '${file.path} appears to contain embedded secret material: $pattern',
        );
      }
    }
  });
}

List<File> _dartFiles(Directory root) {
  if (!root.existsSync()) return const <File>[];
  final files = root
      .listSync(recursive: true, followLinks: false)
      .whereType<File>()
      .where((file) => file.path.endsWith('.dart'))
      .toList(growable: false);
  files.sort((a, b) => a.path.compareTo(b.path));
  return files;
}
