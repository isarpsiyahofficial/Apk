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

    test('unknown matched theme is rejected before it can reach output boundary', () {
      expect(
        () => TopicThemeDecision.matchedThemes(
          const ['patience', 'generated-religious-advice'],
        ),
        throwsArgumentError,
      );
    });

    test('duplicate matched theme is rejected before verse resolution', () {
      expect(
        () => TopicThemeDecision.matchedThemes(const ['patience', 'patience']),
        throwsArgumentError,
      );
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

    test('unknown clarification candidate is rejected before output boundary', () {
      expect(
        () => TopicThemeDecision.clarifyTheme(
          candidateThemeIds: const ['hope', 'leave-your-job'],
        ),
        throwsArgumentError,
      );
    });

    test('algorithm payload itself rejects generated advice disguised as an ID', () {
      expect(
        () => TopicAlgorithmThemeSelection.matched(
          const ['patience', 'quit-your-job-because-this-verse-says-so'],
        ),
        throwsArgumentError,
      );
    });

    test('algorithm payload itself rejects duplicate canonical IDs', () {
      expect(
        () => TopicAlgorithmThemeSelection.matched(
          const ['patience', 'patience'],
        ),
        throwsArgumentError,
      );
    });

    test('algorithm payload cannot create an empty resolving selection', () {
      expect(
        () => TopicAlgorithmThemeSelection.matched(const <String>[]),
        throwsArgumentError,
      );
    });

    test('direct clarification payload rejects non-canonical decision text', () {
      expect(
        () => TopicAlgorithmThemeSelection.clarify(
          candidateThemeIds: const ['hope', 'this-is-a-fatwa'],
        ),
        throwsArgumentError,
      );
    });
  });
}
