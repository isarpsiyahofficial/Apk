/// English preprocessing for the on-device Quran topic matcher.
///
/// The output is a search key only. It must never be applied to Quran, meal,
/// dua, hadith, or other governed religious source text. Corrections are
/// deliberately conservative: only exact-token entries in the typo dictionary
/// are rewritten so valid user wording is not guessed into another meaning.
abstract final class EnglishTopicQueryNormalizer {
  static const Map<String, String> _commonTypos = <String, String>{
    'anxeity': 'anxiety',
    'anixety': 'anxiety',
    'anxius': 'anxious',
    'beleive': 'believe',
    'decison': 'decision',
    'forgivness': 'forgiveness',
    'gratful': 'grateful',
    'hopless': 'hopeless',
    'lonley': 'lonely',
    'marrige': 'marriage',
    'mercifull': 'merciful',
    'prayr': 'prayer',
    'repentence': 'repentance',
    'thankfull': 'thankful',
    'woried': 'worried',
  };

  static String normalize(String input) {
    if (input.trim().isEmpty) return '';

    var value = input.toLowerCase();

    // Apostrophes inside contractions are semantically non-essential for
    // matching. Removing them makes "can't" and "cant" converge while other
    // punctuation still acts as a word boundary.
    value = value.replaceAll("'", '').replaceAll('’', '');
    value = value.replaceAll(RegExp(r'[^a-z0-9\s]'), ' ');
    value = value.replaceAll(RegExp(r'\s+'), ' ').trim();
    if (value.isEmpty) return '';

    final normalizedTokens = <String>[];
    for (final token in value.split(' ')) {
      normalizedTokens.add(_commonTypos[token] ?? token);
    }

    return normalizedTokens.join(' ');
  }
}
