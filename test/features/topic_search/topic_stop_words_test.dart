import 'package:flutter_test/flutter_test.dart';
import 'package:islami_hayat/features/topic_search/domain/topic_stop_words.dart';

void main() {
  group('TopicStopWords', () {
    test('filters Turkish function words without dropping negation or themes', () {
      expect(
        TopicStopWords.contentTokens(
          'ben bir kaygı icin dua ve sabır arıyorum değil',
          TopicQueryLanguage.tr,
        ),
        <String>['kaygı', 'dua', 'sabır', 'arıyorum', 'değil'],
      );
      expect(TopicStopWords.turkish, isNot(contains('değil')));
      expect(TopicStopWords.turkish, isNot(contains('sabır')));
    });

    test('filters English function words but preserves negation and themes', () {
      expect(
        TopicStopWords.contentTokens(
          'i am in anxiety and not without hope',
          TopicQueryLanguage.en,
        ),
        <String>['anxiety', 'not', 'without', 'hope'],
      );
      expect(TopicStopWords.english, isNot(contains('not')));
      expect(TopicStopWords.english, isNot(contains('no')));
      expect(TopicStopWords.english, isNot(contains('anxiety')));
    });

    test('filters normalized Arabic function words and preserves negation', () {
      expect(
        TopicStopWords.contentTokens(
          'انا في خوف و لا افقد الامل',
          TopicQueryLanguage.ar,
        ),
        <String>['خوف', 'لا', 'افقد', 'الامل'],
      );
      expect(TopicStopWords.arabic, isNot(contains('لا')));
      expect(TopicStopWords.arabic, isNot(contains('خوف')));
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

    test('empty normalized query yields no tokens', () {
      expect(
        TopicStopWords.contentTokens('   ', TopicQueryLanguage.tr),
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
