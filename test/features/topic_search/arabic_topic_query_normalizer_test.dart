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

    test('keeps Arabic letters and Arabic-Indic digits intact', () {
      expect(
        ArabicTopicQueryNormalizer.normalize('دعاء ٣ مرات'),
        'دعاء ٣ مرات',
      );
    });

    test('empty or punctuation-only input stays empty', () {
      expect(ArabicTopicQueryNormalizer.normalize('   '), isEmpty);
      expect(ArabicTopicQueryNormalizer.normalize('،؛؟!...'), isEmpty);
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
