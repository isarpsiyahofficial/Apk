import 'package:flutter_test/flutter_test.dart';
import 'package:islami_hayat/features/topic_search/domain/topic_crisis_safety_gate.dart';

void main() {
  group('TopicCrisisSafetyGate', () {
    test('TR explicit self-harm intent bypasses religious matching', () {
      final decision = TopicCrisisSafetyGate.evaluate(
        'Kendimi öldürmek istiyorum.',
        locale: TopicCrisisLocale.tr,
      );

      expect(decision.route, TopicCrisisRoute.showSafetySupport);
      expect(decision.mayContinueToReligiousMatching, isFalse);
      expect(decision.supportMessage, contains('ayet eşleştirmesiyle'));
      expect(decision.supportMessage, contains('acil yardım'));
      expect(decision.sourceId, TopicCrisisSafetyGate.sourceId);
      expect(decision.sourceUrl, TopicCrisisSafetyGate.sourceUrl);
    });

    test('EN explicit self-harm intent bypasses religious matching', () {
      final decision = TopicCrisisSafetyGate.evaluate(
        "I don't want to live anymore",
        locale: TopicCrisisLocale.en,
      );

      expect(decision.route, TopicCrisisRoute.showSafetySupport);
      expect(decision.mayContinueToReligiousMatching, isFalse);
      expect(decision.supportMessage, contains('local emergency services'));
      expect(decision.supportMessage, contains('someone you trust'));
    });

    test('AR explicit self-harm intent survives harakat/alef normalization', () {
      final decision = TopicCrisisSafetyGate.evaluate(
        'أُريدُ أن أَموتَ',
        locale: TopicCrisisLocale.ar,
      );

      expect(decision.route, TopicCrisisRoute.showSafetySupport);
      expect(decision.mayContinueToReligiousMatching, isFalse);
      expect(decision.supportMessage, contains('خدمات الطوارئ المحلية'));
      expect(decision.supportMessage, contains('شخصًا تثق به'));
    });

    test('ordinary distress may continue to theme matching', () {
      final decision = TopicCrisisSafetyGate.evaluate(
        'Çok kaygılıyım ve sabırla ilgili ayetlere bakmak istiyorum',
        locale: TopicCrisisLocale.tr,
      );

      expect(decision.route, TopicCrisisRoute.continueTopicMatching);
      expect(decision.mayContinueToReligiousMatching, isTrue);
      expect(decision.supportMessage, isNull);
      expect(decision.sourceId, isNull);
    });

    test('informational suicide-prevention query is not treated as intent', () {
      final decision = TopicCrisisSafetyGate.evaluate(
        'suicide prevention resources',
        locale: TopicCrisisLocale.en,
      );

      expect(decision.mayContinueToReligiousMatching, isTrue);
    });

    test('empty query never creates a crisis decision', () {
      final decision = TopicCrisisSafetyGate.evaluate(
        '   ',
        locale: TopicCrisisLocale.en,
      );

      expect(decision.mayContinueToReligiousMatching, isTrue);
    });
  });
}
