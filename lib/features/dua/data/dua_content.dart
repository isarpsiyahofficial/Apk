import 'package:islami_hayat/core/content/content_governance.dart';

enum DuaSourceStatus {
  quran,
  sahihHasanSunnah,
  classicalTraditional,
  generalEditorial,
}

enum DuaLengthClass { short, medium, long }

/// SPEC 238 category taxonomy. These values are content metadata only; they do
/// not imply that a special sourced dua exists for every category or occasion.
enum DuaCategory {
  morning,
  evening,
  night,
  distress,
  peace,
  repentance,
  seekingForgiveness,
  gratitude,
  patience,
  provision,
  debt,
  blessing,
  family,
  spouse,
  parents,
  children,
  spiritualSupportDuringIllness,
  fear,
  travel,
  protection,
  ramadan,
  friday,
  eid,
  religiousNights,
}

/// Semantic disclosure class consumed by presentation code. It deliberately
/// carries no user-visible string; labels must still come from localization.
enum DuaSourceDisclosure {
  quran,
  authenticatedSunnah,
  classicalTraditional,
  generalEditorial,
}

final class DuaContent {
  const DuaContent({
    required this.id,
    required this.sourceStatus,
    required this.lengthClass,
    required this.categories,
    required this.text,
    required this.reviewStatus,
    required this.version,
    required this.lastReviewedAt,
    required this.sources,
    this.hadithReference,
    this.hadithGrade,
    this.hasSourceDispute = false,
    this.disputeNote,
    this.reviewer,
  });

  final String id;
  final DuaSourceStatus sourceStatus;
  final DuaLengthClass lengthClass;
  final Set<DuaCategory> categories;
  final LocalizedReligiousText text;
  final ContentReviewStatus reviewStatus;
  final int version;
  final DateTime lastReviewedAt;
  final List<SourceReference> sources;
  final String? hadithReference;
  final String? hadithGrade;

  /// True only when the source/reliability assessment itself has a meaningful
  /// disagreement that the user needs to see. If true, a complete TR/EN/AR
  /// note is a production requirement.
  final bool hasSourceDispute;
  final LocalizedReligiousText? disputeNote;
  final String? reviewer;

  bool get requiresEditorialDisclaimer =>
      sourceStatus == DuaSourceStatus.generalEditorial;

  bool get requiresHadithMetadata =>
      sourceStatus == DuaSourceStatus.sahihHasanSunnah;

  DuaSourceDisclosure get disclosure => switch (sourceStatus) {
    DuaSourceStatus.quran => DuaSourceDisclosure.quran,
    DuaSourceStatus.sahihHasanSunnah =>
      DuaSourceDisclosure.authenticatedSunnah,
    DuaSourceStatus.classicalTraditional =>
      DuaSourceDisclosure.classicalTraditional,
    DuaSourceStatus.generalEditorial => DuaSourceDisclosure.generalEditorial,
  };

  bool get _hasHadithReference => hadithReference?.trim().isNotEmpty ?? false;
  bool get _hasHadithGrade => hadithGrade?.trim().isNotEmpty ?? false;

  bool get canEnterProductionDataset {
    if (id.trim().isEmpty ||
        version <= 0 ||
        categories.isEmpty ||
        reviewStatus != ContentReviewStatus.published ||
        !text.isComplete ||
        sources.isEmpty) {
      return false;
    }

    // Hadith metadata belongs only to a hadith-class dua. This prevents a
    // Quran, traditional or editorial dua from accidentally looking prophetic.
    if (!requiresHadithMetadata && (_hasHadithReference || _hasHadithGrade)) {
      return false;
    }

    if (requiresHadithMetadata && (!_hasHadithReference || !_hasHadithGrade)) {
      return false;
    }

    // SPEC 245: if a source disagreement exists, it must be disclosed in all
    // supported languages. Partial notes are treated as a publication error.
    if (hasSourceDispute && !(disputeNote?.isComplete ?? false)) {
      return false;
    }
    if (disputeNote != null && !disputeNote!.isComplete) {
      return false;
    }

    if (sourceStatus == DuaSourceStatus.quran &&
        !sources.any((source) => source.sourceClass == ReligiousSourceClass.quran)) {
      return false;
    }

    if (sourceStatus == DuaSourceStatus.sahihHasanSunnah &&
        !sources.any(
          (source) =>
              source.sourceClass == ReligiousSourceClass.sahihHasanHadith,
        )) {
      return false;
    }

    if (sourceStatus == DuaSourceStatus.classicalTraditional &&
        !sources.any(
          (source) =>
              source.sourceClass == ReligiousSourceClass.classicalTraditional,
        )) {
      return false;
    }

    if (sourceStatus == DuaSourceStatus.generalEditorial &&
        !sources.any(
          (source) => source.sourceClass == ReligiousSourceClass.meaningBasedDua,
        )) {
      return false;
    }

    return true;
  }

  ReligiousContentRecord toGovernedRecord() {
    if (!canEnterProductionDataset) {
      throw StateError('Dua content has not passed production gates: $id');
    }

    return ReligiousContentRecord(
      id: id,
      type: ContentType.dua,
      sourceStatus: switch (sourceStatus) {
        DuaSourceStatus.quran => ReligiousSourceClass.quran,
        DuaSourceStatus.sahihHasanSunnah =>
          ReligiousSourceClass.sahihHasanHadith,
        DuaSourceStatus.classicalTraditional =>
          ReligiousSourceClass.classicalTraditional,
        DuaSourceStatus.generalEditorial =>
          ReligiousSourceClass.meaningBasedDua,
      },
      version: version,
      reviewStatus: reviewStatus,
      certainty: switch (sourceStatus) {
        DuaSourceStatus.quran || DuaSourceStatus.sahihHasanSunnah =>
          CertaintyLevel.explicitSource,
        DuaSourceStatus.classicalTraditional => CertaintyLevel.traditional,
        DuaSourceStatus.generalEditorial => CertaintyLevel.stronglyAttested,
      },
      text: text,
      sources: List<SourceReference>.unmodifiable(sources),
      lastReviewedAt: lastReviewedAt,
      reviewer: reviewer,
    );
  }
}
