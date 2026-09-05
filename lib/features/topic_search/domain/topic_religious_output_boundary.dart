import '../data/quran_theme_taxonomy.dart';
import 'topic_theme_confidence_gate.dart';

/// The only algorithm-owned payload allowed to leave topic classification.
///
/// It intentionally contains canonical theme IDs only. There is no field for
/// tafsir, fatwa, advice, life decisions, generated religious explanation, or
/// user-question text. Reviewed verse resolution and fixed UI copy live after
/// this boundary and cannot be synthesized by the matcher.
final class TopicAlgorithmThemeSelection {
  const TopicAlgorithmThemeSelection._({
    required this.kind,
    required this.themeIds,
    required this.clarificationCandidateIds,
  });

  factory TopicAlgorithmThemeSelection.matched(List<String> themeIds) {
    if (themeIds.isEmpty) {
      throw ArgumentError('Matched selection requires at least one theme ID.');
    }
    _requireCanonicalUniqueIds(themeIds, 'themeIds');
    return TopicAlgorithmThemeSelection._(
      kind: TopicThemeDecisionKind.matchedThemes,
      themeIds: List<String>.unmodifiable(themeIds),
      clarificationCandidateIds: const <String>[],
    );
  }

  factory TopicAlgorithmThemeSelection.clarify({
    List<String> candidateThemeIds = const <String>[],
  }) {
    _requireCanonicalUniqueIds(candidateThemeIds, 'candidateThemeIds');
    return TopicAlgorithmThemeSelection._(
      kind: TopicThemeDecisionKind.clarifyTheme,
      themeIds: const <String>[],
      clarificationCandidateIds:
          List<String>.unmodifiable(candidateThemeIds),
    );
  }

  final TopicThemeDecisionKind kind;
  final List<String> themeIds;
  final List<String> clarificationCandidateIds;

  bool get mayResolveReviewedVerses =>
      kind == TopicThemeDecisionKind.matchedThemes && themeIds.isNotEmpty;

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

/// Fail-closed product boundary for SPEC 216–218 and 225.
///
/// The lexical matcher/confidence gate may only nominate canonical theme IDs.
/// Unknown, duplicated, or structurally inconsistent output is downgraded to a
/// non-resolving clarification state. This prevents future algorithm changes
/// from smuggling generated religious interpretation or decisions into verse
/// resolution through an ungoverned payload.
abstract final class TopicReligiousOutputBoundary {
  static TopicAlgorithmThemeSelection enforce(TopicThemeDecision decision) {
    final canonicalIds = QuranThemeTaxonomy.themes
        .map((theme) => theme.id)
        .toSet();

    if (decision.kind == TopicThemeDecisionKind.matchedThemes) {
      if (!decision.mayResolveVerses ||
          decision.themeIds.isEmpty ||
          decision.clarificationCandidateIds.isNotEmpty ||
          !_allUniqueCanonical(decision.themeIds, canonicalIds)) {
        return TopicAlgorithmThemeSelection.clarify();
      }
      return TopicAlgorithmThemeSelection.matched(decision.themeIds);
    }

    if (decision.mayResolveVerses || decision.themeIds.isNotEmpty) {
      return TopicAlgorithmThemeSelection.clarify();
    }

    if (!_allUniqueCanonical(
      decision.clarificationCandidateIds,
      canonicalIds,
    )) {
      return TopicAlgorithmThemeSelection.clarify();
    }

    return TopicAlgorithmThemeSelection.clarify(
      candidateThemeIds: decision.clarificationCandidateIds,
    );
  }

  static bool _allUniqueCanonical(
    Iterable<String> ids,
    Set<String> canonicalIds,
  ) {
    final seen = <String>{};
    for (final id in ids) {
      if (!canonicalIds.contains(id) || !seen.add(id)) return false;
    }
    return true;
  }
}
