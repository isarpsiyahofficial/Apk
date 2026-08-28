/// Turkish preprocessing for the on-device Quran topic matcher.
///
/// The output is a search key, never user-facing religious text. Turkish
/// letters are folded to an ASCII matching form so queries such as `yalnızım`
/// and `yalnizim` converge without modifying any Quran/meal source content.
abstract final class TurkishTopicQueryNormalizer {
  static const Map<String, String> _slangAndTypos = <String, String>{
    'napcam': 'ne yapacagim',
    'napacagim': 'ne yapacagim',
    'napiyim': 'ne yapayim',
    'napayim': 'ne yapayim',
    'nolur': 'ne olur',
    'yalnizim': 'yalnizim',
  };

  static String normalize(String input) {
    if (input.trim().isEmpty) return '';

    var value = _turkishLowercase(input);
    value = _foldTurkishCharacters(value);
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
    // deterministically.
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
