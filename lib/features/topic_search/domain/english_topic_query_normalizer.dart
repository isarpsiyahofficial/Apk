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
    'anxety': 'anxiety',
    'anxius': 'anxious',
    'beleive': 'believe',
    'decison': 'decision',
    'famly': 'family',
    'forgivness': 'forgiveness',
    'forgivenesss': 'forgiveness',
    'gratful': 'grateful',
    'hopless': 'hopeless',
    'lonelyness': 'loneliness',
    'lonley': 'lonely',
    'lonliness': 'loneliness',
    'marrige': 'marriage',
    'mercifull': 'merciful',
    'patince': 'patience',
    'peacful': 'peaceful',
    'prayr': 'prayer',
    'repentence': 'repentance',
    'resiliance': 'resilience',
    'strugle': 'struggle',
    'thankfull': 'thankful',
    'woried': 'worried',
    'worryed': 'worried',
  };

  static String normalize(String input) {
    if (input.trim().isEmpty) return '';

    var value = input.toLowerCase();

    // Apostrophes inside contractions are semantically non-essential for
    // matching. Cover the common Unicode apostrophe forms emitted by mobile
    // keyboards so "can't", "can’t", "can‘t" and "canʼt" converge.
    value = value.replaceAll(RegExp("['’‘ʼ]"), '');
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
