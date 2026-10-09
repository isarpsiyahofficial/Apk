import 'package:flutter_test/flutter_test.dart';
import 'package:islami_hayat/features/topic_search/domain/topic_theme_confidence_gate.dart';
import 'package:islami_hayat/features/topic_search/domain/topic_theme_scorer.dart';

void main() {
  group('TopicThemeConfidenceGate', () {
    test('low-confidence score asks for clarification and blocks verse resolution',
        () {
      const scoring = TopicThemeScoringResult(<TopicThemeScore>[
        TopicThemeScore(
          themeId: 'anxiety',
          score: 0.22,
          exactTokenMatches: 0,
          fuzzyTokenMatches: 1,
          phraseMatches: 0,
        ),
        TopicThemeScore(
          themeId: 'fear',
          score: 0.18,
          exactTokenMatches: 0,
          fuzzyTokenMatches: 1,
          phraseMatches: 0,
        ),
      ]);

      final decision = TopicThemeConfidenceGate.decide(scoring);

      expect(decision.kind, TopicThemeDecisionKind.clarifyTheme);
      expect(decision.mayResolveVerses, isFalse);
      expect(decision.themeIds, isEmpty);
      expect(
        decision.clarificationCandidateIds,
        orderedEquals(<String>['anxiety', 'fear']),
      );
    });

    test('no lexical match asks for clarification without inventing a theme', () {
      const scoring = TopicThemeScoringResult(<TopicThemeScore>[]);

      final decision = TopicThemeConfidenceGate.decide(scoring);

      expect(decision.kind, TopicThemeDecisionKind.clarifyTheme);
      expect(decision.themeIds, isEmpty);
      expect(decision.clarificationCandidateIds, isEmpty);
      expect(decision.mayResolveVerses, isFalse);
    });

    test('strong single theme may continue to reviewed verse mapping', () {
      const scoring = TopicThemeScoringResult(<TopicThemeScore>[
        TopicThemeScore(
          themeId: 'patience',
          score: 0.62,
          exactTokenMatches: 1,
          fuzzyTokenMatches: 0,
          phraseMatches: 0,
        ),
      ]);

      final decision = TopicThemeConfidenceGate.decide(scoring);

      expect(decision.kind, TopicThemeDecisionKind.matchedThemes);
      expect(decision.themeIds, orderedEquals(<String>['patience']));
      expect(decision.clarificationCandidateIds, isEmpty);
      expect(decision.mayResolveVerses, isTrue);
    });

    test('multiple sufficiently strong related themes are retained', () {
      const scoring = TopicThemeScoringResult(<TopicThemeScore>[
        TopicThemeScore(
          themeId: 'anxiety',
          score: 0.62,
          exactTokenMatches: 1,
          fuzzyTokenMatches: 0,
          phraseMatches: 0,
        ),
        TopicThemeScore(
          themeId: 'patience',
          score: 0.48,
          exactTokenMatches: 1,
          fuzzyTokenMatches: 0,
          phraseMatches: 0,
        ),
        TopicThemeScore(
          themeId: 'work',
          score: 0.31,
          exactTokenMatches: 1,
          fuzzyTokenMatches: 0,
          phraseMatches: 0,
        ),
      ]);

      final decision = TopicThemeConfidenceGate.decide(scoring);

      expect(
        decision.themeIds,
        orderedEquals(<String>['anxiety', 'patience']),
      );
      expect(decision.mayResolveVerses, isTrue);
    });

    test('clarification candidate count is bounded', () {
      const scoring = TopicThemeScoringResult(<TopicThemeScore>[
        TopicThemeScore(
          themeId: 'anxiety',
          score: 0.20,
          exactTokenMatches: 0,
          fuzzyTokenMatches: 1,
          phraseMatches: 0,
        ),
        TopicThemeScore(
          themeId: 'fear',
          score: 0.19,
          exactTokenMatches: 0,
          fuzzyTokenMatches: 1,
          phraseMatches: 0,
        ),
        TopicThemeScore(
          themeId: 'loss',
          score: 0.18,
          exactTokenMatches: 0,
          fuzzyTokenMatches: 1,
          phraseMatches: 0,
        ),
      ]);

      final decision = TopicThemeConfidenceGate.decide(
        scoring,
        maxClarificationCandidates: 2,
      );

      expect(
        decision.clarificationCandidateIds,
        orderedEquals(<String>['anxiety', 'fear']),
      );
    });

    test('non-canonical scoring result fails closed without clarification IDs', () {
      const scoring = TopicThemeScoringResult(<TopicThemeScore>[
        TopicThemeScore(
          themeId: 'invented-theme',
          score: 0.90,
          exactTokenMatches: 1,
          fuzzyTokenMatches: 0,
          phraseMatches: 0,
        ),
      ]);

      final decision = TopicThemeConfidenceGate.decide(scoring);

      expect(decision.kind, TopicThemeDecisionKind.clarifyTheme);
      expect(decision.mayResolveVerses, isFalse);
      expect(decision.themeIds, isEmpty);
      expect(decision.clarificationCandidateIds, isEmpty);
    });

    test('NaN or infinite scores fail closed instead of becoming confident', () {
      for (final invalidScore in <double>[double.nan, double.infinity]) {
        final scoring = TopicThemeScoringResult(<TopicThemeScore>[
          TopicThemeScore(
            themeId: 'anxiety',
            score: invalidScore,
            exactTokenMatches: 1,
            fuzzyTokenMatches: 0,
            phraseMatches: 0,
          ),
        ]);

        final decision = TopicThemeConfidenceGate.decide(scoring);

        expect(decision.kind, TopicThemeDecisionKind.clarifyTheme);
        expect(decision.mayResolveVerses, isFalse);
        expect(decision.clarificationCandidateIds, isEmpty);
      }
    });

    test('positive score without lexical evidence fails closed', () {
      const scoring = TopicThemeScoringResult(<TopicThemeScore>[
        TopicThemeScore(
          themeId: 'anxiety',
          score: 0.90,
          exactTokenMatches: 0,
          fuzzyTokenMatches: 0,
          phraseMatches: 0,
        ),
      ]);

      final decision = TopicThemeConfidenceGate.decide(scoring);

      expect(decision.kind, TopicThemeDecisionKind.clarifyTheme);
      expect(decision.mayResolveVerses, isFalse);
      expect(decision.clarificationCandidateIds, isEmpty);
    });

    test('duplicate or unsorted scoring results fail closed', () {
      const duplicate = TopicThemeScoringResult(<TopicThemeScore>[
        TopicThemeScore(
          themeId: 'anxiety',
          score: 0.70,
          exactTokenMatches: 1,
          fuzzyTokenMatches: 0,
          phraseMatches: 0,
        ),
        TopicThemeScore(
          themeId: 'anxiety',
          score: 0.60,
          exactTokenMatches: 1,
          fuzzyTokenMatches: 0,
          phraseMatches: 0,
        ),
      ]);
      const unsorted = TopicThemeScoringResult(<TopicThemeScore>[
        TopicThemeScore(
          themeId: 'fear',
          score: 0.40,
          exactTokenMatches: 1,
          fuzzyTokenMatches: 0,
          phraseMatches: 0,
        ),
        TopicThemeScore(
          themeId: 'anxiety',
          score: 0.70,
          exactTokenMatches: 1,
          fuzzyTokenMatches: 0,
          phraseMatches: 0,
        ),
      ]);

      for (final scoring in <TopicThemeScoringResult>[duplicate, unsorted]) {
        final decision = TopicThemeConfidenceGate.decide(scoring);
        expect(decision.kind, TopicThemeDecisionKind.clarifyTheme);
        expect(decision.mayResolveVerses, isFalse);
        expect(decision.clarificationCandidateIds, isEmpty);
      }
    });

    test('matched and clarification decisions enforce canonical unique IDs', () {
      expect(
        () => TopicThemeDecision.matchedThemes(const <String>[]),
        throwsArgumentError,
      );
      expect(
        () => TopicThemeDecision.matchedThemes(
          const <String>['invented-theme'],
        ),
        throwsArgumentError,
      );
      expect(
        () => TopicThemeDecision.matchedThemes(
          const <String>['anxiety', 'anxiety'],
        ),
        throwsArgumentError,
      );
      expect(
        () => TopicThemeDecision.clarifyTheme(
          candidateThemeIds: const <String>['invented-theme'],
        ),
        throwsArgumentError,
      );
    });

    test('invalid gate configuration fails closed', () {
      const scoring = TopicThemeScoringResult(<TopicThemeScore>[]);

      expect(
        () => TopicThemeConfidenceGate.decide(
          scoring,
          minimumConfidence: 1.1,
        ),
        throwsArgumentError,
      );
      expect(
        () => TopicThemeConfidenceGate.decide(
          scoring,
          minimumConfidence: double.nan,
        ),
        throwsArgumentError,
      );
      expect(
        () => TopicThemeConfidenceGate.decide(
          scoring,
          includedThemeRatio: 0,
        ),
        throwsArgumentError,
      );
      expect(
        () => TopicThemeConfidenceGate.decide(
          scoring,
          includedThemeRatio: double.infinity,
        ),
        throwsArgumentError,
      );
      expect(
        () => TopicThemeConfidenceGate.decide(
          scoring,
          maxClarificationCandidates: 0,
        ),
        throwsArgumentError,
      );
    });
  });
}
