import '../../../core/content/content_governance.dart';
import 'locale_search_normalizer_t0232.dart';

/// Search-result source/reliability presentation contract for T0233.
///
/// This model deliberately keeps source provenance and certainty separate.
/// A traditional/disputed source must never be promoted to a stronger label
/// merely because it appears in search results.
class SearchSourceBadgeT0233 {
  SearchSourceBadgeT0233({
    required this.sourceClass,
    required this.certainty,
    required List<String> sourceIds,
  }) : sourceIds = List<String>.unmodifiable(
          sourceIds.map((id) => id.trim()).toList(growable: false),
        ) {
    if (this.sourceIds.isEmpty || this.sourceIds.any((id) => id.isEmpty)) {
      throw StateError('T0233 source badge requires non-empty source IDs.');
    }
    if (this.sourceIds.toSet().length != this.sourceIds.length) {
      throw StateError('T0233 source badge contains duplicate source IDs.');
    }
    if (sourceClass == ReligiousSourceClass.unknown &&
        certainty != CertaintyLevel.unknown) {
      throw StateError(
        'T0233 an unverified source cannot carry a verified certainty label.',
      );
    }
  }

  final ReligiousSourceClass sourceClass;
  final CertaintyLevel certainty;
  final List<String> sourceIds;

  /// True when the result must be presented with visible caution styling in
  /// addition to its textual source and reliability labels.
  ///
  /// SPEC 288–295 requires traditional/Ebced material to remain visibly
  /// distinct from default reliable religious content. SPEC 553 also forbids
  /// conveying reliability by color alone, so callers must still render the
  /// localized [sourceLabel] and [reliabilityLabel] text.
  bool get isWarning =>
      sourceClass == ReligiousSourceClass.classicalTraditional ||
      sourceClass == ReligiousSourceClass.israiliyat ||
      sourceClass == ReligiousSourceClass.laterTradition ||
      sourceClass == ReligiousSourceClass.ebcedHavasTradition ||
      sourceClass == ReligiousSourceClass.disputed ||
      sourceClass == ReligiousSourceClass.unknown ||
      certainty == CertaintyLevel.approximate ||
      certainty == CertaintyLevel.traditional ||
      certainty == CertaintyLevel.disputed ||
      certainty == CertaintyLevel.unknown;

  String sourceLabel(SearchLocaleT0232 locale) => switch (locale) {
        SearchLocaleT0232.tr => _sourceLabelTr,
        SearchLocaleT0232.en => _sourceLabelEn,
        SearchLocaleT0232.ar => _sourceLabelAr,
      };

  String reliabilityLabel(SearchLocaleT0232 locale) => switch (locale) {
        SearchLocaleT0232.tr => _certaintyLabelTr,
        SearchLocaleT0232.en => _certaintyLabelEn,
        SearchLocaleT0232.ar => _certaintyLabelAr,
      };

  String get _sourceLabelTr => switch (sourceClass) {
        ReligiousSourceClass.quran => 'Kur’an',
        ReligiousSourceClass.sahihHasanHadith => 'Sahih-Hasen Sünnet',
        ReligiousSourceClass.earlyIslamicHistoryTafsir => 'Erken İslam tarihi / tefsir',
        ReligiousSourceClass.meaningBasedDua => 'Anlam temelli dua',
        ReligiousSourceClass.classicalTraditional => 'Tasavvufî-Geleneksel',
        ReligiousSourceClass.israiliyat => 'İsrâiliyat rivayeti',
        ReligiousSourceClass.laterTradition => 'Sonraki dönem geleneği',
        ReligiousSourceClass.modernHistoryArchaeology => 'Modern tarih / arkeoloji',
        ReligiousSourceClass.ebcedHavasTradition => 'Ebced-Havas geleneği',
        ReligiousSourceClass.disputed => 'İhtilaflı kaynak',
        ReligiousSourceClass.unknown => 'Kaynağı doğrulanamadı',
      };

  String get _sourceLabelEn => switch (sourceClass) {
        ReligiousSourceClass.quran => 'Qur’an',
        ReligiousSourceClass.sahihHasanHadith => 'Sahih-Hasan Sunnah',
        ReligiousSourceClass.earlyIslamicHistoryTafsir => 'Early Islamic history / tafsir',
        ReligiousSourceClass.meaningBasedDua => 'Meaning-based dua',
        ReligiousSourceClass.classicalTraditional => 'Classical-Traditional',
        ReligiousSourceClass.israiliyat => 'Isra’iliyyat report',
        ReligiousSourceClass.laterTradition => 'Later tradition',
        ReligiousSourceClass.modernHistoryArchaeology => 'Modern history / archaeology',
        ReligiousSourceClass.ebcedHavasTradition => 'Abjad-Havas tradition',
        ReligiousSourceClass.disputed => 'Disputed source',
        ReligiousSourceClass.unknown => 'Source unverified',
      };

  String get _sourceLabelAr => switch (sourceClass) {
        ReligiousSourceClass.quran => 'القرآن',
        ReligiousSourceClass.sahihHasanHadith => 'السنة الصحيحة أو الحسنة',
        ReligiousSourceClass.earlyIslamicHistoryTafsir => 'التاريخ الإسلامي المبكر / التفسير',
        ReligiousSourceClass.meaningBasedDua => 'دعاء قائم على المعنى',
        ReligiousSourceClass.classicalTraditional => 'تراث كلاسيكي وتقليدي',
        ReligiousSourceClass.israiliyat => 'رواية من الإسرائيليات',
        ReligiousSourceClass.laterTradition => 'تراث متأخر',
        ReligiousSourceClass.modernHistoryArchaeology => 'التاريخ الحديث / علم الآثار',
        ReligiousSourceClass.ebcedHavasTradition => 'تقليد الأبجد والخواص',
        ReligiousSourceClass.disputed => 'مصدر مختلف فيه',
        ReligiousSourceClass.unknown => 'المصدر غير موثّق',
      };

  String get _certaintyLabelTr => switch (certainty) {
        CertaintyLevel.explicitSource => 'Açık kaynak',
        CertaintyLevel.stronglyAttested => 'Güçlü biçimde doğrulanmış',
        CertaintyLevel.approximate => 'Yaklaşık / bağlamsal',
        CertaintyLevel.traditional => 'Geleneksel aktarım',
        CertaintyLevel.disputed => 'İhtilaflı',
        CertaintyLevel.unknown => 'Kesinlik bilinmiyor',
      };

  String get _certaintyLabelEn => switch (certainty) {
        CertaintyLevel.explicitSource => 'Explicit source',
        CertaintyLevel.stronglyAttested => 'Strongly attested',
        CertaintyLevel.approximate => 'Approximate / contextual',
        CertaintyLevel.traditional => 'Traditional transmission',
        CertaintyLevel.disputed => 'Disputed',
        CertaintyLevel.unknown => 'Certainty unknown',
      };

  String get _certaintyLabelAr => switch (certainty) {
        CertaintyLevel.explicitSource => 'مصدر صريح',
        CertaintyLevel.stronglyAttested => 'ثابت بدرجة قوية',
        CertaintyLevel.approximate => 'تقريبي / سياقي',
        CertaintyLevel.traditional => 'نقل تقليدي',
        CertaintyLevel.disputed => 'مختلف فيه',
        CertaintyLevel.unknown => 'درجة اليقين غير معروفة',
      };
}
