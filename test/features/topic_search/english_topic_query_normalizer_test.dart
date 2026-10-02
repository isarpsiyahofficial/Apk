import 'package:flutter_test/flutter_test.dart';
import 'package:islami_hayat/features/topic_search/domain/english_topic_query_normalizer.dart';

void main() {
  group('EnglishTopicQueryNormalizer', () {
    test('normalizes case punctuation and whitespace deterministically', () {
      expect(
        EnglishTopicQueryNormalizer.normalize(
          'I AM WORRIED... about FAMILY / and forgiveness!',
        ),
        'i am worried about family and forgiveness',
      );
    });

    test('corrects conservative exact-token typos from the English dictionary', () {
      expect(
        EnglishTopicQueryNormalizer.normalize(
          'anxeity lonley forgivness marrige prayr repentence',
        ),
        'anxiety lonely forgiveness marriage prayer repentance',
      );
    });

    test('covers common topic-search typo variants without fuzzy guessing', () {
      expect(
        EnglishTopicQueryNormalizer.normalize(
          'anxety famly lonliness patince peacful resiliance strugle worryed',
        ),
        'anxiety family loneliness patience peaceful resilience struggle worried',
      );
      expect(
        EnglishTopicQueryNormalizer.normalize('forgivenesss lonelyness'),
        'forgiveness loneliness',
      );
    });

    test('does not rewrite substrings inside otherwise valid words', () {
      expect(
        EnglishTopicQueryNormalizer.normalize('loneliness prayerful decision'),
        'loneliness prayerful decision',
      );
      expect(
        EnglishTopicQueryNormalizer.normalize('familylike struggling patiently'),
        'familylike struggling patiently',
      );
    });

    test('mobile-keyboard apostrophe variants converge without joining words', () {
      final variants = <String>[
        "I can't cope",
        'I can’t cope',
        'I can‘t cope',
        'I canʼt cope',
        'i cant cope',
      ];
      final normalized = variants
          .map(EnglishTopicQueryNormalizer.normalize)
          .toSet();
      expect(normalized, <String>{'i cant cope'});

      expect(
        EnglishTopicQueryNormalizer.normalize('God’s mercy'),
        EnglishTopicQueryNormalizer.normalize("god's mercy"),
      );
      expect(
        EnglishTopicQueryNormalizer.normalize('fear—hope'),
        'fear hope',
      );
    });

    test('empty or punctuation-only input stays empty', () {
      expect(EnglishTopicQueryNormalizer.normalize('   '), isEmpty);
      expect(EnglishTopicQueryNormalizer.normalize('?!...'), isEmpty);
    });

    test('remains a query-only layer and does not normalize governed text', () {
      // SPEC 150-151 forbids automatic Quran source mutation. This assertion
      // documents that the class produces a disposable search key only.
      expect(
        EnglishTopicQueryNormalizer.normalize('Qur’an source text stays exact'),
        'quran source text stays exact',
      );
    });
  });
}
