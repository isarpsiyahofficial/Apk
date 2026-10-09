import 'arabic_topic_query_normalizer.dart';
import 'english_topic_query_normalizer.dart';
import 'turkish_topic_query_normalizer.dart';

/// Language-specific stop-word filtering for topic-search queries.
///
/// This is a query-only utility. It must never be used to rewrite Quran, meal,
/// dua, hadith, or other governed religious source text. Lists are deliberately
/// conservative: negations and theme-bearing words are retained because
/// removing them could invert or erase the user's meaning.
enum TopicQueryLanguage { tr, en, ar }

abstract final class TopicStopWords {
  /// Every entry is stored in the exact comparison form produced by
  /// [TurkishTopicQueryNormalizer]. Do not add dotted/dotless or accented
  /// variants that the normalizer itself can never emit.
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
    'mu',
    've',
    'veya',
    'ya',
  };

  /// Every entry is stored in the exact comparison form produced by
  /// [EnglishTopicQueryNormalizer]. Mobile contractions are included only when
  /// their normalized form is meaning-neutral (`I'm` -> `im`). Negations such
  /// as `can't` -> `cant` are deliberately not stop words.
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
    'im',
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

  /// Normalizes a raw user query with the language-specific preprocessing
  /// contract and then removes only the conservative stop-word set.
  ///
  /// This is the preferred product entry point. It prevents raw spelling,
  /// Turkish character folding, English mobile apostrophes, Arabic harakat,
  /// tatweel or bidi controls from bypassing stop-word filtering.
  static List<String> contentTokensFromRawQuery(
    String rawQuery,
    TopicQueryLanguage language,
  ) {
    final normalizedQuery = switch (language) {
      TopicQueryLanguage.tr => TurkishTopicQueryNormalizer.normalize(rawQuery),
      TopicQueryLanguage.en => EnglishTopicQueryNormalizer.normalize(rawQuery),
      TopicQueryLanguage.ar => ArabicTopicQueryNormalizer.normalize(rawQuery),
    };
    return contentTokens(normalizedQuery, language);
  }

  /// Filters a query that has already passed through its language normalizer.
  /// Empty tokens are ignored and the remaining logical token order is kept.
  ///
  /// Prefer [contentTokensFromRawQuery] for user input so callers cannot skip
  /// the locale normalizer accidentally.
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
