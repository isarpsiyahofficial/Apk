import 'package:flutter_test/flutter_test.dart';
import 'package:islami_hayat/features/topic_search/domain/arabic_topic_query_normalizer.dart';

void main() {
  group('ArabicTopicQueryNormalizer', () {
    test('removes harakat for comparison without changing word order', () {
      expect(
        ArabicTopicQueryNormalizer.normalize('الصَّبْرُ وَالتَّوَكُّلُ'),
        'الصبر والتوكل',
      );
    });

    test('removes Quranic combining marks used in copied query text', () {
      expect(
        ArabicTopicQueryNormalizer.normalize('رَبَّنَاۤ ٱهْدِنَا'),
        'ربنا اهدنا',
      );
    });

    test('removes tatweel and normalizes common alef variants', () {
      expect(
        ArabicTopicQueryNormalizer.normalize('آمَلُ إِلَى أَمَانٍ ٱلله'),
        'امل الى امان الله',
      );
      expect(
        ArabicTopicQueryNormalizer.normalize('التــــوبة'),
        'التوبة',
      );
    });

    test('Arabic and ASCII punctuation become stable word boundaries', () {
      expect(
        ArabicTopicQueryNormalizer.normalize('صبر، خوف؛ أمل؟ ودعاء!'),
        'صبر خوف امل ودعاء',
      );
      expect(
        ArabicTopicQueryNormalizer.normalize('صبر،توكل'),
        'صبر توكل',
      );
    });

    test('strips bidi controls while preserving logical RTL token order', () {
      const plain = 'الخوف والرجاء';
      const withControls = '\u2067الخوف\u2069 \u200Fوالرجاء\u200E';
      expect(
        ArabicTopicQueryNormalizer.normalize(withControls),
        ArabicTopicQueryNormalizer.normalize(plain),
      );
      expect(
        ArabicTopicQueryNormalizer.normalize(withControls),
        'الخوف والرجاء',
      );
    });

    test('Arabic Letter Mark cannot create a visually identical search key', () {
      const plain = 'الصبر والامل';
      const withArabicLetterMark = '\u061Cالصبر \u061Cوالأمل\u061C';
      expect(
        ArabicTopicQueryNormalizer.normalize(withArabicLetterMark),
        ArabicTopicQueryNormalizer.normalize(plain),
      );
    });

    test('zero-width and BOM controls are ignored for matching only', () {
      const plain = 'التوكل والرجاء';
      const withInvisibleControls =
          '\uFEFFالتو\u200Bكل \u200Cوالر\u200Dجاء\u2060';
      expect(
        ArabicTopicQueryNormalizer.normalize(withInvisibleControls),
        ArabicTopicQueryNormalizer.normalize(plain),
      );
    });

    test('directional override controls cannot reorder the comparison key', () {
      const plain = 'الخوف والرجاء';
      const withOverrides = '\u202Bالخوف\u202C \u202Eوالرجاء\u202C';
      expect(
        ArabicTopicQueryNormalizer.normalize(withOverrides),
        ArabicTopicQueryNormalizer.normalize(plain),
      );
    });

    test('keeps Arabic letters and Arabic-Indic digits intact', () {
      expect(
        ArabicTopicQueryNormalizer.normalize('دعاء ٣ مرات'),
        'دعاء ٣ مرات',
      );
    });

    test('does not over-normalize non-alef hamza or letter identity', () {
      expect(
        ArabicTopicQueryNormalizer.normalize('سؤال مؤمن بيئة'),
        'سؤال مؤمن بيئة',
      );
    });

    test('empty or punctuation-only input stays empty', () {
      expect(ArabicTopicQueryNormalizer.normalize('   '), isEmpty);
      expect(ArabicTopicQueryNormalizer.normalize('،؛؟!...'), isEmpty);
      expect(
        ArabicTopicQueryNormalizer.normalize('\u061C\u200F\u2067\u2069\uFEFF'),
        isEmpty,
      );
    });

    test('normalizer is query-only and canonical source remains external', () {
      // SPEC 150-151 forbids automatic Quran source mutation. This class only
      // returns a disposable comparison key and has no source-storage API.
      expect(
        ArabicTopicQueryNormalizer.normalize('إِنَّ مَعَ الْعُسْرِ يُسْرًا'),
        'ان مع العسر يسرا',
      );
    });
  });
}
