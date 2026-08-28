import 'package:islami_hayat/core/content/content_governance.dart';
import 'package:islami_hayat/features/dhikr/data/dhikr_target.dart';

/// A reviewed dhikr guide record.
///
/// SPEC 270 requires the Arabic wording, transliteration, meaning, source,
/// reason for reciting, and—when a recommended count is claimed—the count and
/// its source. A count therefore cannot enter the production dataset without
/// independent count-source metadata.
final class DhikrGuideEntry {
  const DhikrGuideEntry({
    required this.id,
    required this.arabic,
    required this.transliterationTr,
    required this.transliterationEn,
    required this.meaning,
    required this.whyRecited,
    required this.sources,
    required this.reviewStatus,
    required this.version,
    required this.lastReviewedAt,
    this.recommendedCount,
    this.countSources = const <SourceReference>[],
    this.reviewer,
  });

  final String id;
  final String arabic;
  final String transliterationTr;
  final String transliterationEn;
  final LocalizedReligiousText meaning;
  final LocalizedReligiousText whyRecited;
  final List<SourceReference> sources;
  final ContentReviewStatus reviewStatus;
  final int version;
  final DateTime lastReviewedAt;
  final int? recommendedCount;
  final List<SourceReference> countSources;
  final String? reviewer;

  bool get hasRecommendedCount => recommendedCount != null;

  bool get _hasCompleteCoreFields =>
      id.trim().isNotEmpty &&
      arabic.trim().isNotEmpty &&
      transliterationTr.trim().isNotEmpty &&
      transliterationEn.trim().isNotEmpty &&
      meaning.isComplete &&
      whyRecited.isComplete &&
      sources.isNotEmpty &&
      version > 0;

  bool get _hasAllowedPrimarySources => sources.every(_isAllowedDhikrSource);

  bool get _hasValidCountProvenance {
    if (!hasRecommendedCount) {
      return countSources.isEmpty;
    }

    final count = recommendedCount!;
    return count > 0 &&
        count <= DhikrTarget.maxCount &&
        countSources.isNotEmpty &&
        countSources.every(_isAllowedCountSource);
  }

  /// Production is fail-closed: draft/partial records and sourced-number claims
  /// with missing/weak provenance are rejected.
  bool get canEnterProductionDataset =>
      reviewStatus == ContentReviewStatus.published &&
      _hasCompleteCoreFields &&
      _hasAllowedPrimarySources &&
      _hasValidCountProvenance;

  DhikrTarget? toSourceBackedTarget() {
    if (!canEnterProductionDataset) {
      throw StateError('Dhikr guide entry has not passed production gates: $id');
    }
    if (!hasRecommendedCount) {
      return null;
    }

    final source = countSources.first;
    return DhikrTarget.sourceBacked(
      count: recommendedCount!,
      sourceId: source.id,
      sourceReference: _humanReadableSource(source),
    );
  }

  ReligiousContentRecord toGovernedRecord() {
    if (!canEnterProductionDataset) {
      throw StateError('Dhikr guide entry has not passed production gates: $id');
    }

    return ReligiousContentRecord(
      id: id,
      type: ContentType.dhikr,
      sourceStatus: sources.first.sourceClass,
      version: version,
      reviewStatus: reviewStatus,
      certainty: _certaintyFor(sources.first.sourceClass),
      text: LocalizedReligiousText(
        tr: '$arabic\n$transliterationTr\n${meaning.tr}',
        en: '$arabic\n$transliterationEn\n${meaning.en}',
        ar: '$arabic\n${meaning.ar}',
      ),
      sources: List<SourceReference>.unmodifiable(sources),
      lastReviewedAt: lastReviewedAt,
      reviewer: reviewer,
    );
  }

  static bool _isAllowedDhikrSource(SourceReference source) => switch (
        source.sourceClass
      ) {
        ReligiousSourceClass.quran ||
        ReligiousSourceClass.sahihHasanHadith ||
        ReligiousSourceClass.classicalTraditional ||
        ReligiousSourceClass.laterTradition =>
          source.id.trim().isNotEmpty &&
              source.title.trim().isNotEmpty &&
              source.licenseId.trim().isNotEmpty,
        _ => false,
      };

  /// A numeric religious recommendation is stricter than a general historical
  /// attribution. Later-tradition, disputed, unknown and ebced/havas sources do
  /// not qualify as a source-backed target here.
  static bool _isAllowedCountSource(SourceReference source) => switch (
        source.sourceClass
      ) {
        ReligiousSourceClass.quran ||
        ReligiousSourceClass.sahihHasanHadith ||
        ReligiousSourceClass.classicalTraditional =>
          source.id.trim().isNotEmpty &&
              source.title.trim().isNotEmpty &&
              source.licenseId.trim().isNotEmpty,
        _ => false,
      };

  static CertaintyLevel _certaintyFor(ReligiousSourceClass sourceClass) =>
      switch (sourceClass) {
        ReligiousSourceClass.quran || ReligiousSourceClass.sahihHasanHadith =>
          CertaintyLevel.explicitSource,
        ReligiousSourceClass.classicalTraditional ||
        ReligiousSourceClass.laterTradition =>
          CertaintyLevel.traditional,
        _ => CertaintyLevel.unknown,
      };

  static String _humanReadableSource(SourceReference source) {
    final locator = source.locator?.trim();
    if (locator == null || locator.isEmpty) {
      return source.title.trim();
    }
    return '${source.title.trim()} — $locator';
  }
}
