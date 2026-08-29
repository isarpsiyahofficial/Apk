import 'package:flutter_test/flutter_test.dart';
import 'package:islami_hayat/features/topic_search/domain/topic_theme_scorer.dart';

void main() {
  group('TopicThemeScorer', () {
    final themes = <TopicThemeSignalSet>[
      TopicThemeSignalSet(
        themeId: 'patience',
        tokenSignals: const ['sabir', 'dayanmak'],
        phraseSignals: const [
          ['sabirli', 'olmak'],
        ],
      ),
      TopicThemeSignalSet(
        themeId: 'anxiety',
        tokenSignals: const ['kaygi', 'endise'],
        phraseSignals: const [
          ['icim', 'daraliyor'],
        ],
      ),
      TopicThemeSignalSet(
        themeId: 'trust_in_god',
        tokenSignals: const ['tevekkul'],
      ),
    ];

    test('returns multiple matching canonical themes', () {
      final result = TopicThemeScorer.score(
        queryTokens: const ['kaygi', 'sabir'],
        themes: themes,
      );

      expect(
        result.matches.map((match) => match.themeId),
        containsAll(<String>['anxiety', 'patience']),
      );
      expect(result.matches.length, 2);
      expect(result.matches.every((match) => match.score > 0), isTrue);
    });

    test('exact lexical evidence outranks fuzzy evidence', () {
      final result = TopicThemeScorer.score(
        queryTokens: const ['kaygi', 'sabirr'],
        themes: themes,
      );

      expect(result.matches.first.themeId, 'anxiety');
      final patience = result.matches.singleWhere(
        (match) => match.themeId == 'patience',
      );
      expect(patience.fuzzyTokenMatches, 1);
      expect(patience.exactTokenMatches, 0);
    });

    test('phrase overlap contributes without becoming certainty', () {
      final result = TopicThemeScorer.score(
        queryTokens: const ['icim', 'daraliyor'],
        themes: themes,
      );

      expect(result.matches.single.themeId, 'anxiety');
      expect(result.matches.single.phraseMatches, 1);
      expect(result.matches.single.score, lessThan(1));
    });

    test('unrelated query produces no theme rather than a guessed theme', () {
      final result = TopicThemeScorer.score(
        queryTokens: const ['otomobil', 'motor'],
        themes: themes,
      );

      expect(result.isEmpty, isTrue);
      expect(result.strongest, isNull);
    });

    test('maxThemes bounds multi-theme output deterministically', () {
      final result = TopicThemeScorer.score(
        queryTokens: const ['kaygi', 'sabir', 'tevekkul'],
        themes: themes,
        maxThemes: 2,
      );

      expect(result.matches.length, 2);
      expect(
        result.matches.map((match) => match.themeId),
        orderedEquals(<String>['anxiety', 'patience']),
      );
    });

    test('duplicate theme IDs fail closed', () {
      expect(
        () => TopicThemeScorer.score(
          queryTokens: const ['sabir'],
          themes: <TopicThemeSignalSet>[
            TopicThemeSignalSet(
              themeId: 'patience',
              tokenSignals: const ['sabir'],
            ),
            TopicThemeSignalSet(
              themeId: 'patience',
              tokenSignals: const ['dayanmak'],
            ),
          ],
        ),
        throwsArgumentError,
      );
    });

    test('unknown theme IDs cannot enter scoring index', () {
      expect(
        () => TopicThemeSignalSet(
          themeId: 'invented_religious_interpretation',
          tokenSignals: const ['uydurma'],
        ),
        throwsArgumentError,
      );
    });

    test('empty signal sets fail closed', () {
      expect(
        () => TopicThemeSignalSet(
          themeId: 'patience',
          tokenSignals: const <String>[],
        ),
        throwsArgumentError,
      );
    });

    test('invalid scoring configuration fails closed', () {
      expect(
        () => TopicThemeScorer.score(
          queryTokens: const ['sabir'],
          themes: themes,
          maxThemes: 0,
        ),
        throwsArgumentError,
      );
      expect(
        () => TopicThemeScorer.score(
          queryTokens: const ['sabir'],
          themes: themes,
          minimumScore: 1.1,
        ),
        throwsArgumentError,
      );
    });
  });
}
