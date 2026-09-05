import 'package:islami_hayat/features/quran/data/canonical_quran_source.dart';
import 'package:islami_hayat/features/topic_search/data/quran_theme_taxonomy.dart';

enum QuranThemeMappingReviewStatus {
  awaitingExpertReview,
  approved,
  rejected,
}

final class QuranVerseReference {
  const QuranVerseReference(this.sura, this.ayah);

  final int sura;
  final int ayah;

  String get key => '$sura:$ayah';

  bool get existsInCanonicalQuran {
    if (sura < 1 || sura > canonicalQuranSuraCount) return false;
    if (ayah < 1) return false;
    return ayah <= canonicalQuranAyahCountForSura(sura);
  }
}

final class QuranThemeVerseMapping {
  const QuranThemeVerseMapping({
    required this.themeId,
    required this.verses,
    this.reviewStatus = QuranThemeMappingReviewStatus.awaitingExpertReview,
    this.reviewerId,
    this.reviewedAtUtc,
  });

  final String themeId;
  final List<QuranVerseReference> verses;
  final QuranThemeMappingReviewStatus reviewStatus;
  final String? reviewerId;
  final DateTime? reviewedAtUtc;

  bool get hasRequiredVerseCount => verses.length >= 3;

  bool get hasUniqueCanonicalReferences {
    final keys = <String>{};
    for (final verse in verses) {
      if (!verse.existsInCanonicalQuran || !keys.add(verse.key)) return false;
    }
    return true;
  }

  bool get hasExpertReviewEvidence =>
      reviewStatus == QuranThemeMappingReviewStatus.approved &&
      reviewerId != null &&
      reviewerId!.trim().isNotEmpty &&
      reviewedAtUtc != null;

  bool get isProductionReady {
    final theme = QuranThemeTaxonomy.byId(themeId);
    return theme != null &&
        theme.isProductionReady &&
        hasRequiredVerseCount &&
        hasUniqueCanonicalReferences &&
        hasExpertReviewEvidence;
  }
}

/// T0151 review candidates for every SPEC 214 theme.
///
/// These are verse-reference candidates only. They deliberately remain
/// `awaitingExpertReview`; therefore none can become a production religious
/// interpretation surface until both the taxonomy entry and the mapping have
/// explicit expert approval evidence. The canonical Quran dataset remains the
/// source of truth for verse identity and text; no Quran text is duplicated or
/// edited here.
abstract final class QuranThemeVerseCatalog {
  static const mappings = <QuranThemeVerseMapping>[
    QuranThemeVerseMapping(themeId: 'patience', verses: [QuranVerseReference(2, 153), QuranVerseReference(2, 155), QuranVerseReference(3, 200)]),
    QuranThemeVerseMapping(themeId: 'anxiety', verses: [QuranVerseReference(13, 28), QuranVerseReference(2, 286), QuranVerseReference(94, 5)]),
    QuranThemeVerseMapping(themeId: 'fear', verses: [QuranVerseReference(2, 38), QuranVerseReference(3, 175), QuranVerseReference(10, 62)]),
    QuranThemeVerseMapping(themeId: 'hope', verses: [QuranVerseReference(39, 53), QuranVerseReference(12, 87), QuranVerseReference(94, 5)]),
    QuranThemeVerseMapping(themeId: 'loneliness', verses: [QuranVerseReference(2, 186), QuranVerseReference(9, 40), QuranVerseReference(20, 46)]),
    QuranThemeVerseMapping(themeId: 'repentance', verses: [QuranVerseReference(66, 8), QuranVerseReference(25, 70), QuranVerseReference(39, 53)]),
    QuranThemeVerseMapping(themeId: 'forgiveness_from_god', verses: [QuranVerseReference(3, 135), QuranVerseReference(4, 110), QuranVerseReference(39, 53)]),
    QuranThemeVerseMapping(themeId: 'family', verses: [QuranVerseReference(16, 72), QuranVerseReference(25, 74), QuranVerseReference(66, 6)]),
    QuranThemeVerseMapping(themeId: 'parents', verses: [QuranVerseReference(17, 23), QuranVerseReference(17, 24), QuranVerseReference(31, 14)]),
    QuranThemeVerseMapping(themeId: 'marriage', verses: [QuranVerseReference(4, 1), QuranVerseReference(24, 32), QuranVerseReference(30, 21)]),
    QuranThemeVerseMapping(themeId: 'love_mercy', verses: [QuranVerseReference(3, 159), QuranVerseReference(30, 21), QuranVerseReference(48, 29)]),
    QuranThemeVerseMapping(themeId: 'anger', verses: [QuranVerseReference(3, 134), QuranVerseReference(7, 199), QuranVerseReference(42, 37)]),
    QuranThemeVerseMapping(themeId: 'forgiving_others', verses: [QuranVerseReference(3, 134), QuranVerseReference(24, 22), QuranVerseReference(42, 40)]),
    QuranThemeVerseMapping(themeId: 'justice', verses: [QuranVerseReference(4, 135), QuranVerseReference(5, 8), QuranVerseReference(16, 90)]),
    QuranThemeVerseMapping(themeId: 'injustice', verses: [QuranVerseReference(4, 40), QuranVerseReference(18, 49), QuranVerseReference(42, 42)]),
    QuranThemeVerseMapping(themeId: 'provision', verses: [QuranVerseReference(11, 6), QuranVerseReference(51, 58), QuranVerseReference(65, 3)]),
    QuranThemeVerseMapping(themeId: 'debt', verses: [QuranVerseReference(2, 280), QuranVerseReference(2, 282), QuranVerseReference(2, 283)]),
    QuranThemeVerseMapping(themeId: 'work', verses: [QuranVerseReference(9, 105), QuranVerseReference(53, 39), QuranVerseReference(62, 10)]),
    QuranThemeVerseMapping(themeId: 'decision', verses: [QuranVerseReference(3, 159), QuranVerseReference(42, 38), QuranVerseReference(65, 3)]),
    QuranThemeVerseMapping(themeId: 'trust_in_god', verses: [QuranVerseReference(3, 159), QuranVerseReference(8, 2), QuranVerseReference(65, 3)]),
    QuranThemeVerseMapping(themeId: 'illness_spiritual_support', verses: [QuranVerseReference(17, 82), QuranVerseReference(21, 83), QuranVerseReference(26, 80)]),
    QuranThemeVerseMapping(themeId: 'loss', verses: [QuranVerseReference(2, 155), QuranVerseReference(2, 156), QuranVerseReference(64, 11)]),
    QuranThemeVerseMapping(themeId: 'death', verses: [QuranVerseReference(3, 185), QuranVerseReference(21, 35), QuranVerseReference(62, 8)]),
    QuranThemeVerseMapping(themeId: 'gratitude', verses: [QuranVerseReference(2, 152), QuranVerseReference(14, 7), QuranVerseReference(31, 12)]),
    QuranThemeVerseMapping(themeId: 'supplication', verses: [QuranVerseReference(2, 186), QuranVerseReference(7, 55), QuranVerseReference(40, 60)]),
  ];

  static QuranThemeVerseMapping? byThemeId(String themeId) {
    for (final mapping in mappings) {
      if (mapping.themeId == themeId) return mapping;
    }
    return null;
  }

  static QuranThemeVerseMapping? productionMappingFor(String themeId) {
    final mapping = byThemeId(themeId);
    return mapping != null && mapping.isProductionReady ? mapping : null;
  }
}
