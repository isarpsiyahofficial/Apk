import 'package:islami_hayat/core/content/content_governance.dart';
import 'package:islami_hayat/features/dua/data/dua_content.dart';

enum DuaResearchStage {
  captured,
  sourceVerification,
  sourceVerified,
  rejected,
  editorialRewriteDrafted,
}

/// Research-only record for a dua discovered outside the trusted content set.
///
/// The captured text and claimed attribution are never convertible directly to
/// a published [DuaContent]. A separate decision is required first.
final class DuaResearchCandidate {
  const DuaResearchCandidate({
    required this.id,
    required this.discoveryOrigin,
    required this.capturedText,
    required this.stage,
    this.claimedAttribution,
    this.researchNote,
  });

  final String id;
  final String discoveryOrigin;
  final String capturedText;
  final String? claimedAttribution;
  final DuaResearchStage stage;
  final String? researchNote;

  bool get isValidResearchRecord =>
      id.trim().isNotEmpty &&
      discoveryOrigin.trim().isNotEmpty &&
      capturedText.trim().isNotEmpty;

  DuaResearchCandidate beginSourceVerification({String? note}) {
    if (!isValidResearchRecord || stage != DuaResearchStage.captured) {
      throw StateError('Dua candidate cannot enter source verification: $id');
    }
    return _copyWith(
      stage: DuaResearchStage.sourceVerification,
      researchNote: note,
    );
  }

  DuaResearchCandidate reject({required String reason}) {
    if (!isValidResearchRecord ||
        stage != DuaResearchStage.sourceVerification ||
        reason.trim().isEmpty) {
      throw StateError('Dua candidate cannot be rejected from this state: $id');
    }
    return _copyWith(
      stage: DuaResearchStage.rejected,
      researchNote: reason,
    );
  }

  /// Converts a source-verified candidate only into a *research-stage* Dua.
  /// It can never bypass religious/language review by becoming published here.
  DuaContent createSourceVerifiedResearchDraft({
    required DuaSourceStatus sourceStatus,
    required DuaLengthClass lengthClass,
    required Set<DuaCategory> categories,
    required LocalizedReligiousText verifiedText,
    required List<SourceReference> verifiedSources,
    required int version,
    required DateTime reviewedAt,
    String? hadithReference,
    String? hadithGrade,
    bool hasSourceDispute = false,
    LocalizedReligiousText? disputeNote,
    String? reviewer,
  }) {
    if (!isValidResearchRecord ||
        stage != DuaResearchStage.sourceVerification ||
        verifiedSources.isEmpty ||
        !verifiedText.isComplete) {
      throw StateError('Dua candidate has not passed source verification: $id');
    }

    final expectedClass = switch (sourceStatus) {
      DuaSourceStatus.quran => ReligiousSourceClass.quran,
      DuaSourceStatus.sahihHasanSunnah =>
        ReligiousSourceClass.sahihHasanHadith,
      DuaSourceStatus.classicalTraditional =>
        ReligiousSourceClass.classicalTraditional,
      DuaSourceStatus.generalEditorial => ReligiousSourceClass.meaningBasedDua,
    };
    if (!verifiedSources.any((source) => source.sourceClass == expectedClass)) {
      throw StateError('Verified source class does not match dua source status: $id');
    }

    return DuaContent(
      id: id,
      sourceStatus: sourceStatus,
      lengthClass: lengthClass,
      categories: categories,
      text: verifiedText,
      reviewStatus: ContentReviewStatus.research,
      version: version,
      lastReviewedAt: reviewedAt,
      sources: List<SourceReference>.unmodifiable(verifiedSources),
      hadithReference: hadithReference,
      hadithGrade: hadithGrade,
      hasSourceDispute: hasSourceDispute,
      disputeNote: disputeNote,
      reviewer: reviewer,
    );
  }

  /// Creates an unattributed editorial *draft* after source verification failed.
  ///
  /// The original claimed attribution is intentionally not copied. A fresh,
  /// complete TR/EN/AR editorial text and a meaning-based source record are
  /// mandatory. The returned record is `draft`, so it still cannot enter the
  /// production dataset until religious and language review happen elsewhere.
  DuaContent createGeneralEditorialRewriteDraft({
    required DuaLengthClass lengthClass,
    required Set<DuaCategory> categories,
    required LocalizedReligiousText rewrittenText,
    required SourceReference editorialSource,
    required int version,
    required DateTime draftedAt,
    String? reviewer,
  }) {
    if (!isValidResearchRecord ||
        stage != DuaResearchStage.sourceVerification ||
        !rewrittenText.isComplete ||
        categories.isEmpty ||
        editorialSource.sourceClass != ReligiousSourceClass.meaningBasedDua) {
      throw StateError('Dua candidate cannot become an editorial rewrite: $id');
    }

    return DuaContent(
      id: '$id-editorial',
      sourceStatus: DuaSourceStatus.generalEditorial,
      lengthClass: lengthClass,
      categories: categories,
      text: rewrittenText,
      reviewStatus: ContentReviewStatus.draft,
      version: version,
      lastReviewedAt: draftedAt,
      sources: [editorialSource],
      reviewer: reviewer,
    );
  }

  DuaResearchCandidate _copyWith({
    required DuaResearchStage stage,
    String? researchNote,
  }) => DuaResearchCandidate(
    id: id,
    discoveryOrigin: discoveryOrigin,
    capturedText: capturedText,
    claimedAttribution: claimedAttribution,
    stage: stage,
    researchNote: researchNote ?? this.researchNote,
  );
}
