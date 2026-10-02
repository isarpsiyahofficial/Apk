import 'package:flutter_test/flutter_test.dart';
import 'package:islami_hayat/features/topic_search/domain/turkish_topic_query_normalizer.dart';

void main() {
  group('TurkishTopicQueryNormalizer', () {
    test('normalizes Turkish case and punctuation deterministically', () {
      expect(
        TurkishTopicQueryNormalizer.normalize('İÇİM DARALIYOR! Ne yapacağım?'),
        'icim daraliyor ne yapacagim',
      );
    });

    test('Turkish and ASCII spellings converge to the same search key', () {
      expect(
        TurkishTopicQueryNormalizer.normalize('Yalnızım, şükür ve bağışlanma'),
        TurkishTopicQueryNormalizer.normalize('yalnizim sukur ve bagislanma'),
      );
    });

    test('precomposed and decomposed dotted-I spellings converge', () {
      const decomposed = 'I\u0307çim daralıyor';
      expect(
        TurkishTopicQueryNormalizer.normalize(decomposed),
        TurkishTopicQueryNormalizer.normalize('İçim daralıyor'),
      );
      expect(
        TurkishTopicQueryNormalizer.normalize(decomposed),
        'icim daraliyor',
      );
    });

    test('expands common spoken Turkish forms required by the spec', () {
      expect(
        TurkishTopicQueryNormalizer.normalize('napcam napicam napiyim nolur'),
        'ne yapacagim ne yapacagim ne yapayim ne olur',
      );
    });

    test('normalizes conservative colloquial one-word forms', () {
      expect(
        TurkishTopicQueryNormalizer.normalize('bişey hiçbişey hiçbişeyim'),
        'bir sey hicbir sey hicbir seyim',
      );
    });

    test('collapses punctuation and whitespace without joining words', () {
      expect(
        TurkishTopicQueryNormalizer.normalize('borç...   aile / kaygı'),
        'borc aile kaygi',
      );
    });

    test('apostrophes remain word boundaries instead of joining tokens', () {
      expect(
        TurkishTopicQueryNormalizer.normalize("Kur'an'da sabır"),
        'kur an da sabir',
      );
    });

    test('empty or punctuation-only input stays empty', () {
      expect(TurkishTopicQueryNormalizer.normalize('   '), isEmpty);
      expect(TurkishTopicQueryNormalizer.normalize('?!...'), isEmpty);
    });

    test('does not contain Quran or meal source transformation concerns', () {
      // This layer is deliberately query-only. It must never be reused as a
      // source-text normalizer because SPEC 150-151 forbids automatic Quran
      // text mutation.
      expect(
        TurkishTopicQueryNormalizer.normalize('Kur’an metni değişmez'),
        'kur an metni degismez',
      );
    });
  });
}
