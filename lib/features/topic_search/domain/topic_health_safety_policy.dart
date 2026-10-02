enum TopicSafetyLocale { tr, en, ar }

/// Fixed, non-diagnostic safety copy for the high-risk illness topic.
///
/// This policy never inspects symptoms and never produces medical advice. It
/// only requires a professional-help disclaimer when a reviewed result contains
/// the canonical illness/spiritual-support theme from SPEC 226 and 520.
abstract final class TopicHealthSafetyPolicy {
  static const illnessThemeId = 'illness_spiritual_support';

  static bool requiresProfessionalHelpNotice(Iterable<String> themeIds) {
    return themeIds.contains(illnessThemeId);
  }

  static String? noticeFor(
    Iterable<String> themeIds, {
    required TopicSafetyLocale locale,
  }) {
    if (!requiresProfessionalHelpNotice(themeIds)) return null;

    return switch (locale) {
      TopicSafetyLocale.tr =>
        'Bu içerik yalnız manevi destek amaçlıdır; tıbbi tanı veya tedavi önerisi değildir, herhangi bir tıbbi sonuç ya da iyileşme garantisi vermez ve doktor ya da sağlık profesyoneli desteğinin yerini tutmaz.',
      TopicSafetyLocale.en =>
        'This content is for spiritual support only. It is not medical diagnosis or treatment advice, does not guarantee any medical outcome or recovery, and does not replace care from a doctor or qualified health professional.',
      TopicSafetyLocale.ar =>
        'هذا المحتوى للدعم الروحي فقط، وليس تشخيصًا طبيًا أو نصيحة علاجية، ولا يضمن أي نتيجة طبية أو شفاء، ولا يغني عن مراجعة الطبيب أو المختص الصحي المؤهل.',
    };
  }
}
