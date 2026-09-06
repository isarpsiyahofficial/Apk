enum QuranThemeReviewStatus { awaitingExpertReview, approved, rejected }

enum QuranThemeReviewKind {
  religiousExpert,
  nativeTurkish,
  nativeEnglish,
  nativeArabic,
}

enum QuranThemeReviewDecision { pending, approved, rejected }

final class QuranThemeReviewEvidence {
  const QuranThemeReviewEvidence({
    required this.themeId,
    required this.taxonomyRevision,
    required this.kind,
    required this.decision,
    required this.reviewerId,
    required this.reviewedAtUtc,
  });

  final String themeId;
  final int taxonomyRevision;
  final QuranThemeReviewKind kind;
  final QuranThemeReviewDecision decision;
  final String reviewerId;

  /// ISO-8601 UTC timestamp. Kept as text so the canonical taxonomy can stay
  /// const and review evidence can be audited without runtime parsing.
  final String reviewedAtUtc;

  bool get hasReviewerIdentity => reviewerId.trim().isNotEmpty;

  bool get hasUtcTimestamp {
    final parsed = DateTime.tryParse(reviewedAtUtc);
    return parsed != null && parsed.isUtc;
  }

  bool approves({required String expectedThemeId, required int expectedRevision}) =>
      themeId == expectedThemeId &&
      taxonomyRevision == expectedRevision &&
      decision == QuranThemeReviewDecision.approved &&
      hasReviewerIdentity &&
      hasUtcTimestamp;
}

class QuranThemeDefinition {
  const QuranThemeDefinition({
    required this.id,
    required this.labelTr,
    required this.labelEn,
    required this.labelAr,
    this.reviewStatus = QuranThemeReviewStatus.awaitingExpertReview,
    this.taxonomyRevision = QuranThemeTaxonomy.revision,
    this.reviewEvidence = const <QuranThemeReviewEvidence>[],
  });

  final String id;
  final String labelTr;
  final String labelEn;
  final String labelAr;
  final QuranThemeReviewStatus reviewStatus;
  final int taxonomyRevision;
  final List<QuranThemeReviewEvidence> reviewEvidence;

  bool get hasCompleteReviewEvidence {
    if (taxonomyRevision != QuranThemeTaxonomy.revision) return false;

    final seen = <QuranThemeReviewKind>{};
    for (final evidence in reviewEvidence) {
      if (!seen.add(evidence.kind)) return false;
      if (!evidence.approves(expectedThemeId: id, expectedRevision: taxonomyRevision)) {
        return false;
      }
    }

    return seen.length == QuranThemeReviewKind.values.length &&
        seen.containsAll(QuranThemeReviewKind.values);
  }

  /// Production consumers must not treat a manually flipped enum as review.
  /// A theme is releasable only when the current taxonomy revision has
  /// independent religious-expert and TR/EN/AR native-language approvals.
  bool get isProductionReady =>
      reviewStatus == QuranThemeReviewStatus.approved && hasCompleteReviewEvidence;
}

/// Canonical V1 theme taxonomy from SPEC 213–215.
///
/// These entries intentionally carry no production approval evidence. T0151
/// owns verse mappings, while this taxonomy remains fail-closed until the
/// religious expert and all three native-language reviewers approve the exact
/// taxonomy revision. This prevents a bare enum change from publishing a new
/// religious interpretation surface.
abstract final class QuranThemeTaxonomy {
  static const int revision = 1;

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