import 'package:flutter_test/flutter_test.dart';
import 'package:islami_hayat/features/topic_search/domain/arabic_topic_query_normalizer.dart';
import 'package:islami_hayat/features/topic_search/domain/english_topic_query_normalizer.dart';
import 'package:islami_hayat/features/topic_search/domain/topic_stop_words.dart';
import 'package:islami_hayat/features/topic_search/domain/turkish_topic_query_normalizer.dart';

void main() {
  group('TopicStopWords', () {
    test('filters Turkish function words without dropping negation or themes', () {
      expect(
        TopicStopWords.contentTokensFromRawQuery(
          'Ben bir kaygı için dua ve sabır arıyorum değil mi?',
          TopicQueryLanguage.tr,
        ),
        <String>['kaygi', 'dua', 'sabir', 'ariyorum', 'degil'],
      );
      expect(TopicStopWords.turkish, isNot(contains('degil')));
      expect(TopicStopWords.turkish, isNot(contains('sabir')));
    });

    test('Turkish stop-word entries are canonical normalizer outputs', () {
      for (final token in TopicStopWords.turkish) {
        expect(
          TurkishTopicQueryNormalizer.normalize(token),
          token,
          reason: 'Non-canonical Turkish stop-word: $token',
        );
      }
      expect(TopicStopWords.turkish, isNot(contains('mı')));
      expect(TopicStopWords.turkish, isNot(contains('mü')));
      expect(TopicStopWords.turkish, containsAll(<String>['mi', 'mu']));
    });

    test('filters English function words but preserves negation and themes', () {
      expect(
        TopicStopWords.contentTokensFromRawQuery(
          'I am in anxety and I’m not without hope.',
          TopicQueryLanguage.en,
        ),
        <String>['anxiety', 'im', 'not', 'without', 'hope'],
      );
      expect(TopicStopWords.english, isNot(contains('not')));
      expect(TopicStopWords.english, isNot(contains('no')));
      expect(TopicStopWords.english, isNot(contains('anxiety')));
    });

    test('English stop-word entries are canonical normalizer outputs', () {
      for (final token in TopicStopWords.english) {
        expect(
          EnglishTopicQueryNormalizer.normalize(token),
          token,
          reason: 'Non-canonical English stop-word: $token',
        );
      }
    });

    test('filters normalized Arabic function words and preserves negation', () {
      expect(
        TopicStopWords.contentTokensFromRawQuery(
          'أَنَا فِي خَوْفٍ، وَ لَا أَفْقِدُ الأَمَل',
          TopicQueryLanguage.ar,
        ),
        <String>['خوف', 'لا', 'افقد', 'الامل'],
      );
      expect(TopicStopWords.arabic, isNot(contains('لا')));
      expect(TopicStopWords.arabic, isNot(contains('خوف')));
    });

    test('Arabic stop-word entries are canonical normalizer outputs', () {
      for (final token in TopicStopWords.arabic) {
        expect(
          ArabicTopicQueryNormalizer.normalize(token),
          token,
          reason: 'Non-canonical Arabic stop-word: $token',
        );
      }
    });

    test('raw-query entry point neutralizes invisible Arabic format controls', () {
      expect(
        TopicStopWords.contentTokensFromRawQuery(
          'انا\u2067 في\u2069 صبر و توكل',
          TopicQueryLanguage.ar,
        ),
        <String>['صبر', 'توكل'],
      );
    });

    test('keeps token order and ignores repeated whitespace', () {
      expect(
        TopicStopWords.contentTokens(
          'hope   and   patience',
          TopicQueryLanguage.en,
        ),
        <String>['hope', 'patience'],
      );
    });

    test('empty raw or normalized query yields no tokens', () {
      expect(
        TopicStopWords.contentTokensFromRawQuery('   ', TopicQueryLanguage.tr),
        isEmpty,
      );
      expect(
        TopicStopWords.contentTokens('', TopicQueryLanguage.ar),
        isEmpty,
      );
    });

    test('sets are separate for TR EN and AR', () {
      expect(TopicStopWords.turkish, contains('ve'));
      expect(TopicStopWords.english, contains('and'));
      expect(TopicStopWords.arabic, contains('و'));
      expect(TopicStopWords.turkish, isNot(contains('and')));
      expect(TopicStopWords.english, isNot(contains('و')));
    });
  });
}
