enum QuranThemeReviewStatus { awaitingExpertReview, approved, rejected }

class QuranThemeDefinition {
  const QuranThemeDefinition({
    required this.id,
    required this.labelTr,
    required this.labelEn,
    required this.labelAr,
    this.reviewStatus = QuranThemeReviewStatus.awaitingExpertReview,
  });

  final String id;
  final String labelTr;
  final String labelEn;
  final String labelAr;
  final QuranThemeReviewStatus reviewStatus;

  bool get isProductionReady => reviewStatus == QuranThemeReviewStatus.approved;
}

/// Canonical V1 theme taxonomy from SPEC 213–215.
///
/// These entries intentionally carry no verse mappings. T0151 is responsible
/// for attaching manually verified verse sets after expert review. Keeping the
/// taxonomy and verse associations separate prevents an unreviewed keyword
/// list from becoming a religious interpretation surface by accident.
abstract final class QuranThemeTaxonomy {
  static const themes = <QuranThemeDefinition>[
    QuranThemeDefinition(id: 'patience', labelTr: 'Sabır', labelEn: 'Patience', labelAr: 'الصبر'),
    QuranThemeDefinition(id: 'anxiety', labelTr: 'Kaygı', labelEn: 'Anxiety', labelAr: 'القلق'),
    QuranThemeDefinition(id: 'fear', labelTr: 'Korku', labelEn: 'Fear', labelAr: 'الخوف'),
    QuranThemeDefinition(id: 'hope', labelTr: 'Ümit', labelEn: 'Hope', labelAr: 'الرجاء'),
    QuranThemeDefinition(id: 'loneliness', labelTr: 'Yalnızlık', labelEn: 'Loneliness', labelAr: 'الوحدة'),
    QuranThemeDefinition(id: 'repentance', labelTr: 'Tövbe', labelEn: 'Repentance', labelAr: 'التوبة'),
    QuranThemeDefinition(id: 'forgiveness_from_god', labelTr: 'Bağışlanma', labelEn: 'Forgiveness', labelAr: 'المغفرة'),
    QuranThemeDefinition(id: 'family', labelTr: 'Aile', labelEn: 'Family', labelAr: 'الأسرة'),
    QuranThemeDefinition(id: 'parents', labelTr: 'Anne-baba', labelEn: 'Parents', labelAr: 'الوالدان'),
    QuranThemeDefinition(id: 'marriage', labelTr: 'Evlilik', labelEn: 'Marriage', labelAr: 'الزواج'),
    QuranThemeDefinition(id: 'love_mercy', labelTr: 'Sevgi ve merhamet', labelEn: 'Love and mercy', labelAr: 'المودة والرحمة'),
    QuranThemeDefinition(id: 'anger', labelTr: 'Öfke', labelEn: 'Anger', labelAr: 'الغضب'),
    QuranThemeDefinition(id: 'forgiving_others', labelTr: 'Affetme', labelEn: 'Forgiving others', labelAr: 'العفو'),
    QuranThemeDefinition(id: 'justice', labelTr: 'Adalet', labelEn: 'Justice', labelAr: 'العدل'),
    QuranThemeDefinition(id: 'injustice', labelTr: 'Haksızlık', labelEn: 'Injustice', labelAr: 'الظلم'),
    QuranThemeDefinition(id: 'provision', labelTr: 'Rızık', labelEn: 'Provision', labelAr: 'الرزق'),
    QuranThemeDefinition(id: 'debt', labelTr: 'Borç', labelEn: 'Debt', labelAr: 'الدَّين'),
    QuranThemeDefinition(id: 'work', labelTr: 'Çalışma', labelEn: 'Work', labelAr: 'العمل'),
    QuranThemeDefinition(id: 'decision', labelTr: 'Karar', labelEn: 'Decision-making', labelAr: 'اتخاذ القرار'),
    QuranThemeDefinition(id: 'trust_in_god', labelTr: 'Tevekkül', labelEn: 'Trust in God', labelAr: 'التوكل على الله'),
    QuranThemeDefinition(id: 'illness_spiritual_support', labelTr: 'Hastalıkta manevi destek', labelEn: 'Spiritual support during illness', labelAr: 'الدعم الروحي عند المرض'),
    QuranThemeDefinition(id: 'loss', labelTr: 'Kayıp', labelEn: 'Loss', labelAr: 'الفقد'),
    QuranThemeDefinition(id: 'death', labelTr: 'Ölüm', labelEn: 'Death', labelAr: 'الموت'),
    QuranThemeDefinition(id: 'gratitude', labelTr: 'Şükür', labelEn: 'Gratitude', labelAr: 'الشكر'),
    QuranThemeDefinition(id: 'supplication', labelTr: 'Dua', labelEn: 'Supplication', labelAr: 'الدعاء'),
  ];

  static QuranThemeDefinition? byId(String id) {
    for (final theme in themes) {
      if (theme.id == id) return theme;
    }
    return null;
  }
}
