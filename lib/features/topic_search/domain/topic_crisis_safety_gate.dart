import 'arabic_topic_query_normalizer.dart';
import 'english_topic_query_normalizer.dart';
import 'turkish_topic_query_normalizer.dart';

enum TopicCrisisLocale { tr, en, ar }
enum TopicCrisisRoute { continueTopicMatching, showSafetySupport }

class TopicCrisisSafetyDecision {
  const TopicCrisisSafetyDecision._({
    required this.route,
    this.supportMessage,
    this.sourceId,
    this.sourceUrl,
  });

  const TopicCrisisSafetyDecision.continueMatching()
      : this._(route: TopicCrisisRoute.continueTopicMatching);

  const TopicCrisisSafetyDecision.showSupport({
    required String supportMessage,
    required String sourceId,
    required String sourceUrl,
  }) : this._(
          route: TopicCrisisRoute.showSafetySupport,
          supportMessage: supportMessage,
          sourceId: sourceId,
          sourceUrl: sourceUrl,
        );

  final TopicCrisisRoute route;
  final String? supportMessage;
  final String? sourceId;
  final String? sourceUrl;

  bool get mayContinueToReligiousMatching =>
      route == TopicCrisisRoute.continueTopicMatching;
}

/// Self-harm escalation gate for SPEC 227.
///
/// This gate must run before religious theme scoring. It catches explicit
/// first-person self-harm/death intent and a deliberately small set of
/// high-signal implied-risk statements in TR/EN/AR. A match returns no
/// religious theme, verse, fatwa, or spiritual judgement and instead routes to
/// fixed help-seeking guidance. It runs fully on-device and does not transmit
/// the raw query.
///
/// The implied-risk phrases mirror warning-sign language in WHO suicide
/// guidance (for example, having no reason to live or believing others would be
/// better off without the person). Generic informational discussion of suicide
/// is intentionally not enough to trigger this gate.
abstract final class TopicCrisisSafetyGate {
  static const sourceId = 'who-suicide-help-guidance';
  static const sourceUrl =
      'https://www.who.int/news-room/questions-and-answers/item/suicide';

  static const _trRiskSignals = <String>{
    'olmek istiyorum',
    'yasamak istemiyorum',
    'kendimi oldurmek istiyorum',
    'kendime zarar vermek istiyorum',
    'hayatima son vermek istiyorum',
    'kendimi oldurmeyi dusunuyorum',
    'hayatima son vermeyi dusunuyorum',
    'kendimi oldurecegim',
    'kendime zarar verebilirim',
    'yasamak icin bir sebebim yok',
    'ben olmasam herkes daha iyi olur',
  };

  static const _enRiskSignals = <String>{
    'i want to die',
    'i do not want to live',
    'i dont want to live',
    'i want to kill myself',
    'i want to hurt myself',
    'i want to end my life',
    'im going to kill myself',
    'i am going to kill myself',
    'i might hurt myself',
    'im thinking about killing myself',
    'i am thinking about killing myself',
    'i have no reason to live',
    'everyone would be better off without me',
  };

  // Arabic normalizer removes harakat/tatweel and folds alef variants.
  static const _arRiskSignals = <String>{
    'اريد ان اموت',
    'لا اريد ان اعيش',
    'اريد ان اقتل نفسي',
    'اريد ان اوذي نفسي',
    'اريد انهاء حياتي',
    'افكر في الانتحار',
    'افكر في قتل نفسي',
    'قد اوذي نفسي',
    'ليس لدي سبب للعيش',
    'سيكون الجميع افضل بدوني',
  };

  static TopicCrisisSafetyDecision evaluate(
    String rawQuery, {
    required TopicCrisisLocale locale,
  }) {
    final normalized = switch (locale) {
      TopicCrisisLocale.tr => TurkishTopicQueryNormalizer.normalize(rawQuery),
      TopicCrisisLocale.en => EnglishTopicQueryNormalizer.normalize(rawQuery),
      TopicCrisisLocale.ar => ArabicTopicQueryNormalizer.normalize(rawQuery),
    };

    if (normalized.isEmpty || !_containsRiskSignal(normalized, locale)) {
      return const TopicCrisisSafetyDecision.continueMatching();
    }

    return TopicCrisisSafetyDecision.showSupport(
      supportMessage: _supportMessage(locale),
      sourceId: sourceId,
      sourceUrl: sourceUrl,
    );
  }

  static bool _containsRiskSignal(String normalized, TopicCrisisLocale locale) {
    final phrases = switch (locale) {
      TopicCrisisLocale.tr => _trRiskSignals,
      TopicCrisisLocale.en => _enRiskSignals,
      TopicCrisisLocale.ar => _arRiskSignals,
    };

    final padded = ' $normalized ';
    return phrases.any((phrase) => padded.contains(' $phrase '));
  }

  static String _supportMessage(TopicCrisisLocale locale) {
    return switch (locale) {
      TopicCrisisLocale.tr =>
        'Bunu dini bir hüküm veya ayet eşleştirmesiyle yanıtlamayacağız. Kendine zarar verme tehliken varsa bulunduğun yerdeki acil yardım hizmetlerine şimdi ulaş. Mümkünse yalnız kalma; güvendiğin birine ne yaşadığını söyle ve bir doktor, ruh sağlığı uzmanı veya kriz destek hizmetinden yardım iste.',
      TopicCrisisLocale.en =>
        'We will not answer this with a religious ruling or verse match. If you may be in immediate danger of harming yourself, contact local emergency services now. If possible, do not stay alone; tell someone you trust what you are going through and seek help from a doctor, mental-health professional, or crisis service.',
      TopicCrisisLocale.ar =>
        'لن نجيب عن هذا بحكم ديني أو بمطابقة آية. إذا كنت في خطر مباشر من إيذاء نفسك، فاتصل بخدمات الطوارئ المحلية الآن. إن أمكن، لا تبق وحدك؛ أخبر شخصًا تثق به بما تمر به واطلب المساعدة من طبيب أو مختص في الصحة النفسية أو خدمة دعم للأزمات.',
    };
  }
}
