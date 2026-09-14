import 'dart:io';

/// T0334 release audit for prohibited guaranteed-outcome religious claims.
///
/// This guard is intentionally conservative: a hit is a release-blocking
/// finding that must be reviewed or removed. It is not a religious-content
/// classifier and it never upgrades content authenticity.
final class ForbiddenReligiousClaimAuditT0334 {
  const ForbiddenReligiousClaimAuditT0334._();

  static const List<String> _blockedFragments = <String>[
    // Turkish
    'kesin para getirir',
    'para getirir',
    'kesin zengin eder',
    'zengin eder',
    'kesin âşık eder',
    'âşık eder',
    'asik eder',
    'kişiyi sana bağlar',
    'kisiyi sana baglar',
    'kesin şifa verir',
    'şifa garantisi',
    'hastalığı iyileştirir',
    'hastaligi iyilestirir',
    'sonucu garanti eder',
    'allah sana bunu söyledi',
    'allah sana bunu soyledi',
    'allah’ın cevabı',
    "allah'ın cevabı",
    'bu ayet senin kesin cevabın',

    // English
    'guarantees money',
    'brings money',
    'will make you rich',
    'guarantees wealth',
    'will make them love you',
    'makes them love you',
    'binds a person to you',
    'guarantees healing',
    'healing guarantee',
    'cures the disease',
    'guarantees the outcome',
    'god told you this',
    "allah's answer",
    'this verse is your definite answer',

    // Arabic
    'يضمن المال',
    'يجلب المال حتما',
    'يجلب المال حتمًا',
    'يجعله يحبك حتما',
    'يجعله يحبك حتمًا',
    'يربط الشخص بك',
    'يضمن الشفاء',
    'ضمان الشفاء',
    'يشفي المرض حتما',
    'يشفي المرض حتمًا',
    'يضمن النتيجة',
    'الله قال لك هذا',
    'هذا جواب الله لك',
  ];

  static bool containsForbiddenClaim(String value) {
    final normalized = _normalize(value);
    return _blockedFragments.any(normalized.contains);
  }

  static List<ForbiddenReligiousClaimFinding> auditDirectories(
    Iterable<String> directoryPaths, {
    Iterable<String> excludedPaths = const <String>[],
  }) {
    final excluded = excludedPaths.map(_normalizePath).toSet();
    final findings = <ForbiddenReligiousClaimFinding>[];

    for (final directoryPath in directoryPaths) {
      final directory = Directory(directoryPath);
      if (!directory.existsSync()) {
        throw StateError(
          'T0334 audit directory does not exist: $directoryPath',
        );
      }

      final files = directory
          .listSync(recursive: true, followLinks: false)
          .whereType<File>()
          .where((file) => file.path.endsWith('.dart'))
          .toList()
        ..sort((a, b) => a.path.compareTo(b.path));

      for (final file in files) {
        final normalizedPath = _normalizePath(file.path);
        if (excluded.any(
          (path) => normalizedPath == path || normalizedPath.endsWith('/$path'),
        )) {
          continue;
        }

        final lines = file.readAsLinesSync();
        for (var index = 0; index < lines.length; index += 1) {
          final line = lines[index];
          final normalizedLine = _normalize(line);
          for (final fragment in _blockedFragments) {
            if (normalizedLine.contains(fragment)) {
              findings.add(
                ForbiddenReligiousClaimFinding(
                  path: normalizedPath,
                  line: index + 1,
                  matchedFragment: fragment,
                ),
              );
            }
          }
        }
      }
    }

    return List<ForbiddenReligiousClaimFinding>.unmodifiable(findings);
  }

  static void requireClean(
    Iterable<String> directoryPaths, {
    Iterable<String> excludedPaths = const <String>[],
  }) {
    final findings = auditDirectories(
      directoryPaths,
      excludedPaths: excludedPaths,
    );
    if (findings.isEmpty) return;

    final detail = findings
        .map(
          (finding) =>
              '${finding.path}:${finding.line} (${finding.matchedFragment})',
        )
        .join(', ');
    throw StateError('T0334 prohibited religious claim(s) found: $detail');
  }

  static String _normalize(String value) {
    return value.toLowerCase().replaceAll(RegExp(r'\s+'), ' ').trim();
  }

  static String _normalizePath(String value) => value.replaceAll('\\', '/');
}

final class ForbiddenReligiousClaimFinding {
  const ForbiddenReligiousClaimFinding({
    required this.path,
    required this.line,
    required this.matchedFragment,
  });

  final String path;
  final int line;
  final String matchedFragment;

  @override
  bool operator ==(Object other) {
    return other is ForbiddenReligiousClaimFinding &&
        other.path == path &&
        other.line == line &&
        other.matchedFragment == matchedFragment;
  }

  @override
  int get hashCode => Object.hash(path, line, matchedFragment);
}
