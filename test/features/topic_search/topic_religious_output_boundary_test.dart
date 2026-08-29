import 'package:flutter_test/flutter_test.dart';
import 'package:islami_hayat/features/topic_search/domain/topic_religious_output_boundary.dart';
import 'package:islami_hayat/features/topic_search/domain/topic_theme_confidence_gate.dart';

void main() {
  group('TopicReligiousOutputBoundary', () {
    test('allows only canonical theme IDs to leave a matched decision', () {
      final selection = TopicReligiousOutputBoundary.enforce(
        TopicThemeDecision.matchedThemes(const ['patience', 'anxiety']),
      );

      expect(selection.mayResolveReviewedVerses, isTrue);
      expect(selection.themeIds, const ['patience', 'anxiety']);
      expect(selection.clarificationCandidateIds, isEmpty);
    });

    test('fails closed when a matcher nominates an unknown theme ID', () {
      final selection = TopicReligiousOutputBoundary.enforce(
        TopicThemeDecision.matchedThemes(
          const ['patience', 'generated-religious-advice'],
        ),
      );

      expect(selection.mayResolveReviewedVerses, isFalse);
      expect(selection.themeIds, isEmpty);
      expect(selection.clarificationCandidateIds, isEmpty);
    });

    test('fails closed on duplicate theme IDs instead of resolving', () {
      final selection = TopicReligiousOutputBoundary.enforce(
        TopicThemeDecision.matchedThemes(const ['patience', 'patience']),
      );

      expect(selection.mayResolveReviewedVerses, isFalse);
      expect(selection.themeIds, isEmpty);
    });

    test('clarification candidates are IDs only and never resolve verses', () {
      final selection = TopicReligiousOutputBoundary.enforce(
        TopicThemeDecision.clarifyTheme(
          candidateThemeIds: const ['hope', 'repentance'],
        ),
      );

      expect(selection.mayResolveReviewedVerses, isFalse);
      expect(selection.themeIds, isEmpty);
      expect(selection.clarificationCandidateIds, const ['hope', 'repentance']);
    });

    test('unknown clarification candidate is removed by failing closed', () {
      final selection = TopicReligiousOutputBoundary.enforce(
        TopicThemeDecision.clarifyTheme(
          candidateThemeIds: const ['hope', 'leave-your-job'],
        ),
      );

      expect(selection.mayResolveReviewedVerses, isFalse);
      expect(selection.themeIds, isEmpty);
      expect(selection.clarificationCandidateIds, isEmpty);
    });
  });
}
