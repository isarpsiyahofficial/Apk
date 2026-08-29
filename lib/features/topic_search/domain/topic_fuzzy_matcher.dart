import 'dart:math' as math;

/// Lightweight, fully on-device fuzzy helpers for normalized topic queries.
///
/// Callers must pass disposable normalized query/theme tokens only. This class
/// never reads or rewrites Quran, meal, dua, hadith, or other governed source
/// text. Short tokens are exact-only so negations such as Arabic `لا` cannot be
/// fuzzily confused with another two-letter word.
abstract final class TopicFuzzyMatcher {
  static int levenshteinDistance(String left, String right) {
    if (left == right) return 0;

    final leftRunes = left.runes.toList(growable: false);
    final rightRunes = right.runes.toList(growable: false);
    if (leftRunes.isEmpty) return rightRunes.length;
    if (rightRunes.isEmpty) return leftRunes.length;

    // Keep the working row on the shorter side for bounded mobile memory use.
    final a = leftRunes.length <= rightRunes.length ? leftRunes : rightRunes;
    final b = leftRunes.length <= rightRunes.length ? rightRunes : leftRunes;

    var previous = List<int>.generate(a.length + 1, (index) => index);
    var current = List<int>.filled(a.length + 1, 0);

    for (var row = 1; row <= b.length; row++) {
      current[0] = row;
      for (var column = 1; column <= a.length; column++) {
        final substitutionCost = b[row - 1] == a[column - 1] ? 0 : 1;
        current[column] = math.min(
          math.min(
            current[column - 1] + 1,
            previous[column] + 1,
          ),
          previous[column - 1] + substitutionCost,
        );
      }
      final swap = previous;
      previous = current;
      current = swap;
    }

    return previous[a.length];
  }

  static double similarity(String left, String right) {
    if (left == right) return 1;
    final leftLength = left.runes.length;
    final rightLength = right.runes.length;
    final longest = math.max(leftLength, rightLength);
    if (longest == 0) return 1;

    return 1 - (levenshteinDistance(left, right) / longest);
  }

  static bool tokenMatches(
    String queryToken,
    String candidateToken, {
    double minimumSimilarity = 0.8,
  }) {
    if (minimumSimilarity < 0 || minimumSimilarity > 1) {
      throw ArgumentError.value(
        minimumSimilarity,
        'minimumSimilarity',
        'must be between 0 and 1',
      );
    }
    if (queryToken.isEmpty || candidateToken.isEmpty) return false;
    if (queryToken == candidateToken) return true;

    final shortestLength = math.min(
      queryToken.runes.length,
      candidateToken.runes.length,
    );

    // Exact-only below four Unicode code points. This is intentionally strict
    // for negations and high-information short words across TR/EN/AR.
    if (shortestLength < 4) return false;

    return similarity(queryToken, candidateToken) >= minimumSimilarity;
  }

  static Set<String> tokenNgrams(List<String> tokens, {int size = 2}) {
    if (size <= 0) {
      throw ArgumentError.value(size, 'size', 'must be greater than zero');
    }
    if (tokens.length < size) return const <String>{};

    final grams = <String>{};
    for (var index = 0; index <= tokens.length - size; index++) {
      grams.add(tokens.sublist(index, index + size).join('\u001F'));
    }
    return grams;
  }

  /// Jaccard similarity of contiguous token n-grams. This measures phrase
  /// overlap without inventing semantic meaning or scoring themes itself.
  static double phraseSimilarity(
    List<String> queryTokens,
    List<String> candidateTokens, {
    int ngramSize = 2,
  }) {
    final queryGrams = tokenNgrams(queryTokens, size: ngramSize);
    final candidateGrams = tokenNgrams(candidateTokens, size: ngramSize);

    if (queryGrams.isEmpty && candidateGrams.isEmpty) {
      return _shortPhraseSimilarity(queryTokens, candidateTokens);
    }
    if (queryGrams.isEmpty || candidateGrams.isEmpty) return 0;

    final intersection = queryGrams.intersection(candidateGrams).length;
    final union = queryGrams.union(candidateGrams).length;
    return union == 0 ? 0 : intersection / union;
  }

  static double _shortPhraseSimilarity(
    List<String> queryTokens,
    List<String> candidateTokens,
  ) {
    if (queryTokens.isEmpty && candidateTokens.isEmpty) return 1;
    if (queryTokens.length != 1 || candidateTokens.length != 1) return 0;
    return similarity(queryTokens.single, candidateTokens.single);
  }
}
