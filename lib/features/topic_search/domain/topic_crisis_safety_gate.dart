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

/// High-confidence self-harm escalation gate for SPEC 227.
///
/// This gate must run before religious theme scoring. It is deliberately small
/// and conservative: it catches explicit first-person self-harm/death intent in
/// TR/EN/AR, returns no religious theme, verse, fatwa, or spiritual judgement,
/// and shows fixed help-seeking guidance. It runs fully on-device and does not
/// transmit the raw query.
///
/// Guidance is based on WHO suicide-prevention help guidance: seek immediate
/// emergency help when in danger, tell a trusted person, and contact a health
/// professional or crisis service. The app does not hard-code one country's
/// crisis number because UI language is not a reliable location signal.
abstract final class TopicCrisisSafetyGate {
  static const sourceId = 'who-suicide-help-guidance';
  static const sourceUrl =
      'https://www.who.int/news-room/questions-and-answers/item/suicide';

  static const _trExplicitIntent = <String>{
    'olmek istiyorum',
    'yasamak istemiyorum',
    'kendimi oldurmek istiyorum',
    'kendime zarar vermek istiyorum',
    'hayatima son vermek istiyorum',
  };

  static const _enExplicitIntent = <String>{
    'i want to die',
    'i do not want to live',
    'i dont want to live',
    'i want to kill myself',
    'i want to hurt myself',
    'i want to end my life',
  };

  // Arabic normalizer removes harakat/tatweel and folds alef variants.
  static const _arExplicitIntent = <String>{
    'اريد ان اموت',
    'لا اريد ان اعيش',
    'اريد ان اقتل نفسي',
    'اريد ان اوذي نفسي',
    'اريد انهاء حياتي',
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

    if (normalized.isEmpty || !_containsExplicitIntent(normalized, locale)) {
      return const TopicCrisisSafetyDecision.continueMatching();
    }

    return TopicCrisisSafetyDecision.showSupport(
      supportMessage: _supportMessage(locale),
      sourceId: sourceId,
      sourceUrl: sourceUrl,
    );
  }

  static bool _containsExplicitIntent(String normalized, TopicCrisisLocale locale) {
    final phrases = switch (locale) {
      TopicCrisisLocale.tr => _trExplicitIntent,
      TopicCrisisLocale.en => _enExplicitIntent,
      TopicCrisisLocale.ar => _arExplicitIntent,
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
