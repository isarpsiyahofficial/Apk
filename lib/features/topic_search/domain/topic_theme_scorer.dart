import 'dart:math' as math;

import '../data/quran_theme_taxonomy.dart';
import 'topic_fuzzy_matcher.dart';

/// A reviewed/search-index-owned set of normalized lexical signals for one
/// canonical Quran topic theme.
///
/// This model intentionally contains no verse text, tafsir, fatwa, or generated
/// religious explanation. It can only point to a theme ID already present in
/// [QuranThemeTaxonomy]. Callers are responsible for building these disposable
/// normalized signals from reviewed search metadata, never from mutating Quran,
/// meal, dua, hadith, or other governed source text.
class TopicThemeSignalSet {
  TopicThemeSignalSet({
    required this.themeId,
    required List<String> tokenSignals,
    List<List<String>> phraseSignals = const <List<String>>[],
  })  : tokenSignals = List.unmodifiable(
          tokenSignals.where((signal) => signal.trim().isNotEmpty).toSet(),
        ),
        phraseSignals = List.unmodifiable(
          phraseSignals
              .where((phrase) => phrase.isNotEmpty)
              .map((phrase) => List<String>.unmodifiable(phrase))
              .toList(growable: false),
        ) {
    if (QuranThemeTaxonomy.byId(themeId) == null) {
      throw ArgumentError.value(
        themeId,
        'themeId',
        'must reference a canonical Quran theme',
      );
    }
    if (this.tokenSignals.isEmpty && this.phraseSignals.isEmpty) {
      throw ArgumentError(
        'At least one normalized token or phrase signal is required.',
      );
    }
  }

  final String themeId;
  final List<String> tokenSignals;
  final List<List<String>> phraseSignals;
}

class TopicThemeScore {
  const TopicThemeScore({
    required this.themeId,
    required this.score,
    required this.exactTokenMatches,
    required this.fuzzyTokenMatches,
    required this.phraseMatches,
  });

  final String themeId;

  /// Bounded [0, 1] relevance score. It is lexical relevance only; it is not a
  /// religious certainty score and must not be described as divine guidance.
  final double score;
  final int exactTokenMatches;
  final int fuzzyTokenMatches;
  final int phraseMatches;
}

class TopicThemeScoringResult {
  const TopicThemeScoringResult(this.matches);

  /// Sorted descending by lexical score, then by stable theme ID. Multiple
  /// themes are intentionally retained because one user query may contain more
  /// than one topic (SPEC 219–220).
  final List<TopicThemeScore> matches;

  bool get isEmpty => matches.isEmpty;
  TopicThemeScore? get strongest => matches.isEmpty ? null : matches.first;
}

/// Pure on-device lexical scoring for canonical theme IDs.
///
/// This class does not select verses and cannot create interpretation. T0158
/// owns low-confidence clarification; T0159 owns reviewed verse presentation;
/// T0160 adds the final product-level interpretation/fatwa guard.
abstract final class TopicThemeScorer {
  static TopicThemeScoringResult score({
    required List<String> queryTokens,
    required List<TopicThemeSignalSet> themes,
    int maxThemes = 4,
    double minimumScore = 0.15,
  }) {
    if (maxThemes <= 0) {
      throw ArgumentError.value(maxThemes, 'maxThemes', 'must be positive');
    }
    if (minimumScore < 0 || minimumScore > 1) {
      throw ArgumentError.value(
        minimumScore,
        'minimumScore',
        'must be between 0 and 1',
      );
    }

    final disposableQuery = queryTokens
        .where((token) => token.trim().isNotEmpty)
        .toList(growable: false);
    if (disposableQuery.isEmpty || themes.isEmpty) {
      return const TopicThemeScoringResult(<TopicThemeScore>[]);
    }

    final themeIds = <String>{};
    for (final theme in themes) {
      if (!themeIds.add(theme.themeId)) {
        throw ArgumentError('Duplicate theme ID: ${theme.themeId}');
      }
    }

    final scored = <TopicThemeScore>[];
    for (final theme in themes) {
      final match = _scoreTheme(disposableQuery, theme);
      // A configured floor of zero must never turn a theme with no lexical
      // evidence into a candidate. Zero evidence means no match, not a weak
      // match; otherwise an unrelated canonical theme could leak into the
      // multi-theme result and later be mistaken for religious relevance.
      if (match.score > 0 && match.score >= minimumScore) scored.add(match);
    }

    scored.sort((left, right) {
      final scoreOrder = right.score.compareTo(left.score);
      if (scoreOrder != 0) return scoreOrder;
      return left.themeId.compareTo(right.themeId);
    });

    return TopicThemeScoringResult(
      List<TopicThemeScore>.unmodifiable(scored.take(maxThemes)),
    );
  }

  static TopicThemeScore _scoreTheme(
    List<String> queryTokens,
    TopicThemeSignalSet theme,
  ) {
    var exactTokenMatches = 0;
    var fuzzyTokenMatches = 0;
    var phraseMatches = 0;
    var tokenEvidence = 0.0;
    var phraseEvidence = 0.0;

    // Each query token contributes at most once to a theme. This prevents a
    // theme with a large synonym list from winning merely because it has more
    // metadata than another theme.
    for (final queryToken in queryTokens.toSet()) {
      var bestSimilarity = 0.0;
      var exact = false;
      for (final signal in theme.tokenSignals) {
        if (queryToken == signal) {
          bestSimilarity = 1;
          exact = true;
          break;
        }
        if (TopicFuzzyMatcher.tokenMatches(queryToken, signal)) {
          bestSimilarity = math.max(
            bestSimilarity,
            TopicFuzzyMatcher.similarity(queryToken, signal),
          );
        }
      }
      if (exact) {
        exactTokenMatches++;
        tokenEvidence += 1;
      } else if (bestSimilarity > 0) {
        fuzzyTokenMatches++;
        // Fuzzy evidence is deliberately weaker than an exact lexical hit.
        tokenEvidence += bestSimilarity * 0.7;
      }
    }

    for (final phrase in theme.phraseSignals) {
      final similarity = TopicFuzzyMatcher.phraseSimilarity(
        queryTokens,
        phrase,
      );
      if (similarity <= 0) continue;
      phraseMatches++;
      // Phrase evidence is useful but capped so it cannot turn one weak phrase
      // into artificial certainty.
      phraseEvidence = math.max(phraseEvidence, similarity * 0.9);
    }

    final evidence = tokenEvidence + phraseEvidence;
    if (evidence <= 0) {
      return TopicThemeScore(
        themeId: theme.themeId,
        score: 0,
        exactTokenMatches: 0,
        fuzzyTokenMatches: 0,
        phraseMatches: 0,
      );
    }

    // Normalize against the amount of unique query evidence, not the number of
    // synonyms attached to a theme. Phrase evidence adds one bounded channel.
    final denominator = queryTokens.toSet().length + 0.9;
    final normalized = (evidence / denominator).clamp(0.0, 1.0).toDouble();

    return TopicThemeScore(
      themeId: theme.themeId,
      score: normalized,
      exactTokenMatches: exactTokenMatches,
      fuzzyTokenMatches: fuzzyTokenMatches,
      phraseMatches: phraseMatches,
    );
  }
}
