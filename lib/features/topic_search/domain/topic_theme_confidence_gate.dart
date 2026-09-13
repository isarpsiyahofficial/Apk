import '../data/quran_theme_taxonomy.dart';
import 'topic_theme_scorer.dart';

enum TopicThemeDecisionKind { matchedThemes, clarifyTheme }

class TopicThemeDecision {
  const TopicThemeDecision._({
    required this.kind,
    required this.themeIds,
    required this.clarificationCandidateIds,
  });

  factory TopicThemeDecision.matchedThemes(List<String> themeIds) {
    if (themeIds.isEmpty) {
      throw ArgumentError('Matched theme decision requires at least one theme.');
    }
    _requireCanonicalUniqueIds(themeIds, 'themeIds');
    return TopicThemeDecision._(
      kind: TopicThemeDecisionKind.matchedThemes,
      themeIds: List<String>.unmodifiable(themeIds),
      clarificationCandidateIds: const <String>[],
    );
  }

  factory TopicThemeDecision.clarifyTheme({
    List<String> candidateThemeIds = const <String>[],
  }) {
    _requireCanonicalUniqueIds(candidateThemeIds, 'candidateThemeIds');
    return TopicThemeDecision._(
      kind: TopicThemeDecisionKind.clarifyTheme,
      themeIds: const <String>[],
      clarificationCandidateIds:
          List<String>.unmodifiable(candidateThemeIds),
    );
  }

  final TopicThemeDecisionKind kind;

  /// Canonical theme IDs that may continue to the reviewed verse-mapping layer.
  /// This is always empty for a clarification decision.
  final List<String> themeIds;

  /// Optional canonical choices that UI may present for explicit user
  /// clarification. These IDs are suggestions only and must never trigger verse
  /// display while [kind] is [TopicThemeDecisionKind.clarifyTheme].
  final List<String> clarificationCandidateIds;

  bool get mayResolveVerses => kind == TopicThemeDecisionKind.matchedThemes;

  static void _requireCanonicalUniqueIds(List<String> ids, String name) {
    final seen = <String>{};
    for (final id in ids) {
      if (QuranThemeTaxonomy.byId(id) == null) {
        throw ArgumentError.value(id, name, 'must contain canonical theme IDs');
      }
      if (!seen.add(id)) {
        throw ArgumentError.value(id, name, 'must not contain duplicate IDs');
      }
    }
  }
}

/// Fail-closed confidence policy for topic matching.
///
/// SPEC 221 requires low-confidence queries to clarify the topic instead of
/// guessing verses. This gate therefore returns no resolvable theme IDs unless
/// the strongest lexical score clears [minimumConfidence]. It still allows a
/// small list of candidate theme IDs to be shown as clarification choices.
abstract final class TopicThemeConfidenceGate {
  static TopicThemeDecision decide(
    TopicThemeScoringResult scoring, {
    double minimumConfidence = 0.30,
    double includedThemeRatio = 0.65,
    int maxClarificationCandidates = 3,
  }) {
    if (!minimumConfidence.isFinite ||
        minimumConfidence < 0 ||
        minimumConfidence > 1) {
      throw ArgumentError.value(
        minimumConfidence,
        'minimumConfidence',
        'must be a finite value between 0 and 1',
      );
    }
    if (!includedThemeRatio.isFinite ||
        includedThemeRatio <= 0 ||
        includedThemeRatio > 1) {
      throw ArgumentError.value(
        includedThemeRatio,
        'includedThemeRatio',
        'must be a finite value greater than 0 and at most 1',
      );
    }
    if (maxClarificationCandidates <= 0) {
      throw ArgumentError.value(
        maxClarificationCandidates,
        'maxClarificationCandidates',
        'must be positive',
      );
    }

    if (scoring.matches.isEmpty) {
      return TopicThemeDecision.clarifyTheme();
    }

    // TopicThemeScorer produces canonical, bounded and deterministically sorted
    // results. Treat any hand-built/corrupted result that violates that contract
    // as untrusted. T0158 is a safety boundary: malformed lexical evidence must
    // never be repaired optimistically into a verse-bearing theme decision.
    if (!_isTrustedScoringResult(scoring.matches)) {
      return TopicThemeDecision.clarifyTheme();
    }

    final strongest = scoring.matches.first;
    if (strongest.score < minimumConfidence) {
      return TopicThemeDecision.clarifyTheme(
        candidateThemeIds: scoring.matches
            .take(maxClarificationCandidates)
            .map((match) => match.themeId)
            .toList(growable: false),
      );
    }

    final relativeFloor = strongest.score * includedThemeRatio;
    final confidentThemes = scoring.matches
        .where(
          (match) =>
              match.score >= minimumConfidence && match.score >= relativeFloor,
        )
        .map((match) => match.themeId)
        .toList(growable: false);

    // Defensive fallback. With a valid sorted scorer result the strongest
    // match should always survive, but fail closed if a malformed result is ever
    // supplied rather than allowing an empty theme list to reach verse mapping.
    if (confidentThemes.isEmpty) {
      return TopicThemeDecision.clarifyTheme(
        candidateThemeIds: <String>[strongest.themeId],
      );
    }

    return TopicThemeDecision.matchedThemes(confidentThemes);
  }

  static bool _isTrustedScoringResult(List<TopicThemeScore> matches) {
    final ids = <String>{};
    TopicThemeScore? previous;

    for (final match in matches) {
      if (QuranThemeTaxonomy.byId(match.themeId) == null ||
          !ids.add(match.themeId) ||
          !match.score.isFinite ||
          match.score <= 0 ||
          match.score > 1 ||
          match.exactTokenMatches < 0 ||
          match.fuzzyTokenMatches < 0 ||
          match.phraseMatches < 0 ||
          match.exactTokenMatches +
                  match.fuzzyTokenMatches +
                  match.phraseMatches <=
              0) {
        return false;
      }

      if (previous != null) {
        if (match.score > previous.score) return false;
        if (match.score == previous.score &&
            match.themeId.compareTo(previous.themeId) < 0) {
          return false;
        }
      }
      previous = match;
    }

    return true;
  }
}
