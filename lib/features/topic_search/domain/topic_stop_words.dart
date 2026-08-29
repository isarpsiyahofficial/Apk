/// Language-specific stop-word filtering for normalized topic-search queries.
///
/// This is a query-only utility. It must never be used to rewrite Quran, meal,
/// dua, hadith, or other governed religious source text. Lists are deliberately
/// conservative: negations and theme-bearing words are retained because
/// removing them could invert or erase the user's meaning.
enum TopicQueryLanguage { tr, en, ar }

abstract final class TopicStopWords {
  static const Set<String> turkish = <String>{
    'acaba',
    'ama',
    'ben',
    'beni',
    'benim',
    'bir',
    'bu',
    'da',
    'de',
    'gibi',
    'icin',
    'ile',
    'mi',
    'mı',
    'mu',
    'mü',
    've',
    'veya',
    'ya',
  };

  static const Set<String> english = <String>{
    'a',
    'am',
    'an',
    'and',
    'are',
    'be',
    'do',
    'does',
    'for',
    'i',
    'in',
    'is',
    'me',
    'my',
    'of',
    'on',
    'or',
    'the',
    'to',
    'with',
  };

  /// Arabic entries are stored in the same comparison form produced by
  /// [ArabicTopicQueryNormalizer] (for example `إلى` -> `الى`).
  static const Set<String> arabic = <String>{
    'انا',
    'او',
    'الى',
    'ان',
    'عن',
    'على',
    'في',
    'ما',
    'ماذا',
    'مع',
    'من',
    'هذا',
    'هذه',
    'هل',
    'هو',
    'هي',
    'و',
  };

  static Set<String> forLanguage(TopicQueryLanguage language) {
    return switch (language) {
      TopicQueryLanguage.tr => turkish,
      TopicQueryLanguage.en => english,
      TopicQueryLanguage.ar => arabic,
    };
  }

  /// Filters a query that has already passed through its language normalizer.
  /// Empty tokens are ignored and the remaining logical token order is kept.
  static List<String> contentTokens(
    String normalizedQuery,
    TopicQueryLanguage language,
  ) {
    if (normalizedQuery.trim().isEmpty) return const <String>[];

    final stopWords = forLanguage(language);
    return normalizedQuery
        .split(RegExp(r'\s+'))
        .where((token) => token.isNotEmpty && !stopWords.contains(token))
        .toList(growable: false);
  }
}
