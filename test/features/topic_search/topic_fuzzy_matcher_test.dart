import 'package:flutter_test/flutter_test.dart';
import 'package:islami_hayat/features/topic_search/domain/topic_fuzzy_matcher.dart';

void main() {
  group('TopicFuzzyMatcher', () {
    test('Levenshtein works on Unicode code points', () {
      expect(TopicFuzzyMatcher.levenshteinDistance('sabır', 'sabir'), 1);
      expect(TopicFuzzyMatcher.levenshteinDistance('خوف', 'خوف'), 0);
      expect(TopicFuzzyMatcher.levenshteinDistance('', 'dua'), 3);
    });

    test('accepts conservative one-edit fuzzy matches on longer tokens', () {
      expect(TopicFuzzyMatcher.tokenMatches('anxiety', 'anxity'), isTrue);
      expect(TopicFuzzyMatcher.tokenMatches('yalnizim', 'yalnizm'), isTrue);
      expect(TopicFuzzyMatcher.tokenMatches('التوكل', 'التوكل'), isTrue);
    });

    test('does not fuzzily merge short negation-like words', () {
      expect(TopicFuzzyMatcher.tokenMatches('لا', 'ما'), isFalse);
      expect(TopicFuzzyMatcher.tokenMatches('no', 'go'), isFalse);
      expect(TopicFuzzyMatcher.tokenMatches('mi', 'mı'), isFalse);
    });

    test('rejects distant words and invalid similarity thresholds', () {
      expect(TopicFuzzyMatcher.tokenMatches('anxiety', 'marriage'), isFalse);
      expect(
        () => TopicFuzzyMatcher.tokenMatches(
          'hope',
          'cope',
          minimumSimilarity: 1.1,
        ),
        throwsArgumentError,
      );
    });

    test('builds contiguous token n-grams without reordering words', () {
      expect(
        TopicFuzzyMatcher.tokenNgrams(<String>['aile', 'icinde', 'sabır']),
        <String>{'aile\u001Ficinde', 'icinde\u001Fsabır'},
      );
      expect(
        TopicFuzzyMatcher.tokenNgrams(<String>['الخوف', 'والرجاء']),
        <String>{'الخوف\u001Fوالرجاء'},
      );
    });

    test('phrase similarity rewards shared contiguous phrases', () {
      final close = TopicFuzzyMatcher.phraseSimilarity(
        <String>['aile', 'icinde', 'sabır'],
        <String>['aile', 'icinde', 'sabır', 'dua'],
      );
      final unrelated = TopicFuzzyMatcher.phraseSimilarity(
        <String>['aile', 'icinde', 'sabır'],
        <String>['borc', 'odeme', 'kaygı'],
      );

      expect(close, greaterThan(unrelated));
      expect(close, greaterThan(0));
      expect(unrelated, 0);
    });

    test('single-token phrase fallback is Unicode-safe', () {
      expect(
        TopicFuzzyMatcher.phraseSimilarity(
          <String>['الرجاء'],
          <String>['الرجاء'],
        ),
        1,
      );
      expect(
        TopicFuzzyMatcher.phraseSimilarity(<String>['hope'], <String>[]),
        0,
      );
    });

    test('invalid n-gram size fails closed', () {
      expect(
        () => TopicFuzzyMatcher.tokenNgrams(<String>['hope'], size: 0),
        throwsArgumentError,
      );
    });
  });
}
