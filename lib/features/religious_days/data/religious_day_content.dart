import '../../../core/content/content_governance.dart';

enum ReligiousDayEvidenceKind {
  quranBasis,
  hadithBasis,
  strongReport,
  disputedReport,
  tradition,
  specificWorship,
  generalWorship,
}

enum SpecificWorshipStatus {
  establishedByStrongSource,
  noSpecificPracticeEstablished,
  traditionalOnly,
  disputed,
}

class ReligiousDayEvidenceSection {
  const ReligiousDayEvidenceSection({
    required this.kind,
    required this.text,
    required this.certainty,
    required this.sources,
  });

  final ReligiousDayEvidenceKind kind;
  final LocalizedReligiousText text;
  final CertaintyLevel certainty;
  final List<SourceReference> sources;

  bool get hasCompleteSourceMetadata => sources.isNotEmpty && sources.every((source) {
        return source.id.trim().isNotEmpty &&
            source.title.trim().isNotEmpty &&
            source.licenseId.trim().isNotEmpty &&
            (source.locator?.trim().isNotEmpty ?? false);
      });
}

class ReligiousDayContent {
  const ReligiousDayContent({
    required this.record,
    required this.title,
    required this.whatIsIt,
    required this.history,
    required this.evidence,
    required this.specificWorshipStatus,
    this.reviewedEvidenceKinds = const {},
  });

  static const Set<ReligiousDayEvidenceKind> requiredReviewedEvidenceKinds = {
    ReligiousDayEvidenceKind.quranBasis,
    ReligiousDayEvidenceKind.hadithBasis,
    ReligiousDayEvidenceKind.strongReport,
    ReligiousDayEvidenceKind.disputedReport,
    ReligiousDayEvidenceKind.tradition,
    ReligiousDayEvidenceKind.specificWorship,
    ReligiousDayEvidenceKind.generalWorship,
  };

  final ReligiousContentRecord record;
  final LocalizedReligiousText title;
  final LocalizedReligiousText whatIsIt;
  final LocalizedReligiousText history;
  final List<ReligiousDayEvidenceSection> evidence;
  final SpecificWorshipStatus specificWorshipStatus;

  /// Records which required SPEC 306 evidence areas were deliberately reviewed.
  ///
  /// A reviewed area may legitimately have no evidence section (for example,
  /// no Quran-specific basis or no established day-specific worship). Keeping
  /// review coverage separate from evidence prevents "not researched" from
  /// being silently treated as "none exists".
  final Set<ReligiousDayEvidenceKind> reviewedEvidenceKinds;

  Iterable<ReligiousDayEvidenceSection> sectionsOf(
    ReligiousDayEvidenceKind kind,
  ) => evidence.where((section) => section.kind == kind);

  bool hasReviewedEvidenceKind(ReligiousDayEvidenceKind kind) =>
      reviewedEvidenceKinds.contains(kind);

  bool get hasCompleteRequiredReviewCoverage =>
      reviewedEvidenceKinds.containsAll(requiredReviewedEvidenceKinds);

  bool get canEnterProductionDataset {
    if (record.type != ContentType.religiousDay ||
        !record.canEnterProductionDataset ||
        (record.reviewer?.trim().isEmpty ?? true) ||
        !title.isComplete ||
        !whatIsIt.isComplete ||
        !history.isComplete ||
        evidence.isEmpty ||
        !hasCompleteRequiredReviewCoverage) {
      return false;
    }

    if (evidence.any((section) =>
        !section.text.isComplete || !section.hasCompleteSourceMetadata)) {
      return false;
    }

    if (evidence.any((section) => !hasReviewedEvidenceKind(section.kind))) {
      return false;
    }

    if (!_sourceClassesMatchEvidenceKinds()) return false;
    if (!_specificWorshipClaimIsSafe()) return false;

    return true;
  }

  bool _sourceClassesMatchEvidenceKinds() {
    for (final section in evidence) {
      final classes = section.sources.map((source) => source.sourceClass).toSet();
      switch (section.kind) {
        case ReligiousDayEvidenceKind.quranBasis:
          if (classes.any((value) => value != ReligiousSourceClass.quran)) {
            return false;
          }
        case ReligiousDayEvidenceKind.hadithBasis:
        case ReligiousDayEvidenceKind.strongReport:
          if (classes.any(
            (value) => value != ReligiousSourceClass.sahihHasanHadith,
          )) {
            return false;
          }
        case ReligiousDayEvidenceKind.disputedReport:
          if (section.certainty != CertaintyLevel.disputed ||
              classes.any((value) => value != ReligiousSourceClass.disputed)) {
            return false;
          }
        case ReligiousDayEvidenceKind.tradition:
          const allowed = {
            ReligiousSourceClass.classicalTraditional,
            ReligiousSourceClass.laterTradition,
          };
          if (classes.any((value) => !allowed.contains(value))) return false;
        case ReligiousDayEvidenceKind.specificWorship:
          if (classes.contains(ReligiousSourceClass.unknown)) return false;
        case ReligiousDayEvidenceKind.generalWorship:
          const allowed = {
            ReligiousSourceClass.quran,
            ReligiousSourceClass.sahihHasanHadith,
          };
          if (classes.any((value) => !allowed.contains(value))) return false;
      }
    }
    return true;
  }

  bool _specificWorshipClaimIsSafe() {
    final specific = sectionsOf(ReligiousDayEvidenceKind.specificWorship).toList();

    switch (specificWorshipStatus) {
      case SpecificWorshipStatus.establishedByStrongSource:
        if (specific.isEmpty) return false;
        return specific.every((section) {
          final sourceClasses = section.sources.map((source) => source.sourceClass);
          return (section.certainty == CertaintyLevel.explicitSource ||
                  section.certainty == CertaintyLevel.stronglyAttested) &&
              sourceClasses.every((value) =>
                  value == ReligiousSourceClass.quran ||
                  value == ReligiousSourceClass.sahihHasanHadith);
        });
      case SpecificWorshipStatus.noSpecificPracticeEstablished:
        return specific.isEmpty;
      case SpecificWorshipStatus.traditionalOnly:
        if (specific.isEmpty) return false;
        return specific.every((section) => section.sources.every((source) =>
            source.sourceClass == ReligiousSourceClass.classicalTraditional ||
            source.sourceClass == ReligiousSourceClass.laterTradition));
      case SpecificWorshipStatus.disputed:
        return specific.isNotEmpty &&
            specific.every((section) =>
                section.certainty == CertaintyLevel.disputed &&
                section.sources.every(
                  (source) => source.sourceClass == ReligiousSourceClass.disputed,
                ));
    }
  }
}
