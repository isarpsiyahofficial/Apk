import 'package:flutter_test/flutter_test.dart';
import 'package:islami_hayat/features/topic_search/domain/topic_crisis_safety_gate.dart';

void main() {
  group('TopicCrisisSafetyGate', () {
    test('TR explicit self-harm intent blocks religious matching', () {
      final decision = TopicCrisisSafetyGate.evaluate(
        'Kendimi öldürmek istiyorum.',
        locale: TopicCrisisLocale.tr,
      );

      expect(decision.route, TopicCrisisRoute.showSafetySupport);
      expect(decision.mayContinueToReligiousMatching, isFalse);
      expect(decision.supportMessage, contains('ayet eşleştirmesiyle'));
      expect(decision.sourceId, TopicCrisisSafetyGate.sourceId);
      expect(decision.sourceUrl, TopicCrisisSafetyGate.sourceUrl);
    });

    test('EN explicit intent survives apostrophe normalization', () {
      final decision = TopicCrisisSafetyGate.evaluate(
        "I don't want to live anymore",
        locale: TopicCrisisLocale.en,
      );

      expect(decision.route, TopicCrisisRoute.showSafetySupport);
      expect(decision.mayContinueToReligiousMatching, isFalse);
      expect(decision.supportMessage, contains('religious ruling or verse match'));
    });

    test('AR explicit intent survives harakat normalization', () {
      final decision = TopicCrisisSafetyGate.evaluate(
        'أُريدُ أن أَموتَ',
        locale: TopicCrisisLocale.ar,
      );

      expect(decision.route, TopicCrisisRoute.showSafetySupport);
      expect(decision.mayContinueToReligiousMatching, isFalse);
      expect(decision.supportMessage, contains('بحكم ديني أو بمطابقة آية'));
    });

    test('TR implied first-person risk escalates instead of matching verses', () {
      final decision = TopicCrisisSafetyGate.evaluate(
        'Yaşamak için bir sebebim yok.',
        locale: TopicCrisisLocale.tr,
      );

      expect(decision.route, TopicCrisisRoute.showSafetySupport);
      expect(decision.mayContinueToReligiousMatching, isFalse);
    });

    test('EN WHO-style warning sign escalates instead of matching verses', () {
      final decision = TopicCrisisSafetyGate.evaluate(
        'Everyone would be better off without me.',
        locale: TopicCrisisLocale.en,
      );

      expect(decision.route, TopicCrisisRoute.showSafetySupport);
      expect(decision.mayContinueToReligiousMatching, isFalse);
    });

    test('AR implied risk escalates instead of matching verses', () {
      final decision = TopicCrisisSafetyGate.evaluate(
        'ليس لدي سبب للعيش',
        locale: TopicCrisisLocale.ar,
      );

      expect(decision.route, TopicCrisisRoute.showSafetySupport);
      expect(decision.mayContinueToReligiousMatching, isFalse);
    });

    test('future-intent variants cannot fall through to religious matching', () {
      final tr = TopicCrisisSafetyGate.evaluate(
        'Kendimi öldüreceğim.',
        locale: TopicCrisisLocale.tr,
      );
      final en = TopicCrisisSafetyGate.evaluate(
        "I'm going to kill myself.",
        locale: TopicCrisisLocale.en,
      );
      final ar = TopicCrisisSafetyGate.evaluate(
        'أفكر في قتل نفسي',
        locale: TopicCrisisLocale.ar,
      );

      expect(tr.mayContinueToReligiousMatching, isFalse);
      expect(en.mayContinueToReligiousMatching, isFalse);
      expect(ar.mayContinueToReligiousMatching, isFalse);
    });

    test('ordinary distress may continue to canonical topic matching', () {
      final decision = TopicCrisisSafetyGate.evaluate(
        'Çok kaygılıyım ve sabırla ilgili ayet arıyorum.',
        locale: TopicCrisisLocale.tr,
      );

      expect(decision.route, TopicCrisisRoute.continueTopicMatching);
      expect(decision.mayContinueToReligiousMatching, isTrue);
      expect(decision.supportMessage, isNull);
    });

    test('generic informational suicide query is not treated as personal intent', () {
      final decision = TopicCrisisSafetyGate.evaluate(
        'suicide prevention resources',
        locale: TopicCrisisLocale.en,
      );

      expect(decision.route, TopicCrisisRoute.continueTopicMatching);
    });

    test('third-person WHO warning-sign discussion does not false-positive', () {
      final decision = TopicCrisisSafetyGate.evaluate(
        'What does it mean when someone says they have no reason to live?',
        locale: TopicCrisisLocale.en,
      );

      expect(decision.route, TopicCrisisRoute.continueTopicMatching);
    });

    test('empty query remains fail-neutral and creates no support payload', () {
      final decision = TopicCrisisSafetyGate.evaluate(
        '   ',
        locale: TopicCrisisLocale.en,
      );

      expect(decision.route, TopicCrisisRoute.continueTopicMatching);
      expect(decision.supportMessage, isNull);
      expect(decision.sourceId, isNull);
      expect(decision.sourceUrl, isNull);
    });
  });
}
