/// Turkish preprocessing for the on-device Quran topic matcher.
///
/// The output is a search key, never user-facing religious text. Turkish
/// letters are folded to an ASCII matching form so queries such as `yalnızım`
/// and `yalnizim` converge without modifying any Quran/meal source content.
///
/// Corrections are deliberately conservative and exact-token based. This
/// normalizer must never infer religious meaning or rewrite governed source
/// content; it only makes user-entered search wording more tolerant.
abstract final class TurkishTopicQueryNormalizer {
  static const Map<String, String> _slangAndTypos = <String, String>{
    'napcam': 'ne yapacagim',
    'napicam': 'ne yapacagim',
    'napacagim': 'ne yapacagim',
    'napiyim': 'ne yapayim',
    'napayim': 'ne yapayim',
    'nolur': 'ne olur',
    'bisey': 'bir sey',
    'biseyler': 'bir seyler',
    'hicbisey': 'hicbir sey',
    'hicbiseyim': 'hicbir seyim',
    'yalnizim': 'yalnizim',
  };

  static String normalize(String input) {
    if (input.trim().isEmpty) return '';

    var value = _turkishLowercase(input);
    value = _foldTurkishCharacters(value);

    // Unicode text copied from browsers/editors may represent capital dotted I
    // as `I` + COMBINING DOT ABOVE instead of the precomposed `İ`. Remove the
    // combining mark only in this query key; source religious text is never
    // passed through this layer.
    value = value.replaceAll('\u0307', '');

    // Apostrophes are separators in Turkish proper-name/suffix spelling. Using
    // a space avoids accidentally joining words while all other punctuation
    // follows the same deterministic boundary rule.
    value = value.replaceAll(RegExp(r'[^a-z0-9\s]'), ' ');
    value = value.replaceAll(RegExp(r'\s+'), ' ').trim();
    if (value.isEmpty) return '';

    final normalizedTokens = <String>[];
    for (final token in value.split(' ')) {
      final replacement = _slangAndTypos[token];
      if (replacement == null) {
        normalizedTokens.add(token);
      } else {
        normalizedTokens.addAll(replacement.split(' '));
      }
    }

    return normalizedTokens.join(' ');
  }

  static String _turkishLowercase(String input) {
    // Dart lowercasing is locale-independent. Handle Turkish dotted/dotless I
    // before calling toLowerCase so both native and ASCII spellings normalize
    // deterministically. A decomposed `I` + combining-dot sequence is handled
    // after lowercasing by normalize().
    return input.replaceAll('İ', 'i').replaceAll('I', 'ı').toLowerCase();
  }

  static String _foldTurkishCharacters(String input) {
    return input
        .replaceAll('ç', 'c')
        .replaceAll('ğ', 'g')
        .replaceAll('ı', 'i')
        .replaceAll('ö', 'o')
        .replaceAll('ş', 's')
        .replaceAll('ü', 'u');
  }
}
