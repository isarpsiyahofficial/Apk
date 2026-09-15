import 'package:islami_hayat/core/content/content_governance.dart';
import 'package:islami_hayat/features/dhikr/data/dhikr_target.dart';

enum DhikrCountProvenance {
  /// A numeric practice directly tied to Qur'an or sahih/hasan Sunnah evidence.
  strongSource,

  /// A count reported in classical/tasawwuf or later traditional practice.
  traditional,

  /// Historical abjad/havas number. Informational only; never a Sunnah target.
  ebcedHavasHistorical,
}

/// A reviewed dhikr guide record.
///
/// SPEC 270 requires the Arabic wording, transliteration, meaning, source,
/// reason for reciting, and—when a recommended count is claimed—the count and
/// its source. T0141 additionally requires strong-source, traditional and
/// ebced/havas counts to remain distinct in both data and UI.
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

  DhikrCountProvenance? get countProvenance {
    if (!hasRecommendedCount || countSources.isEmpty) {
      return null;
    }
    final classes = countSources.map((source) => source.sourceClass).toSet();
    if (classes.every(
      (sourceClass) =>
          sourceClass == ReligiousSourceClass.quran ||
          sourceClass == ReligiousSourceClass.sahihHasanHadith,
    )) {
      return DhikrCountProvenance.strongSource;
    }
    if (classes.every(
      (sourceClass) =>
          sourceClass == ReligiousSourceClass.classicalTraditional ||
          sourceClass == ReligiousSourceClass.laterTradition,
    )) {
      return DhikrCountProvenance.traditional;
    }
    if (classes.length == 1 &&
        classes.single == ReligiousSourceClass.ebcedHavasTradition) {
      return DhikrCountProvenance.ebcedHavasHistorical;
    }
    return null;
  }

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
        countSources.every(_hasCompleteSourceMetadata) &&
        countProvenance != null;
  }

  /// Production is fail-closed: draft/partial records, mixed provenance and
  /// numeric claims with missing source metadata are rejected.
  bool get canEnterProductionDataset =>
      reviewStatus == ContentReviewStatus.published &&
      _hasCompleteCoreFields &&
      _hasAllowedPrimarySources &&
      _hasValidCountProvenance;

  /// Only Qur'an / sahih-hasan Sunnah backed counts become an automatic counter
  /// target. Traditional and ebced/havas numbers remain informational and must
  /// never be silently promoted into a Sunnah-style target.
  DhikrTarget? toSourceBackedTarget() {
    if (!canEnterProductionDataset) {
      throw StateError('Dhikr guide entry has not passed production gates: $id');
    }
    if (!hasRecommendedCount ||
        countProvenance != DhikrCountProvenance.strongSource) {
      return null;
    }

    final source = countSources.first;
    return DhikrTarget.sourceBacked(
      count: recommendedCount!,
      sourceId: source.id,
      sourceReference: _humanReadableSource(source),
    );
  }

  String? get countSourceReference {
    if (!canEnterProductionDataset || !hasRecommendedCount) {
      return null;
    }
    return countSources.map(_humanReadableSource).join(' · ');
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
          _hasCompleteSourceMetadata(source),
        _ => false,
      };

  static bool _hasCompleteSourceMetadata(SourceReference source) =>
      source.id.trim().isNotEmpty &&
      source.title.trim().isNotEmpty &&
      source.licenseId.trim().isNotEmpty &&
      (source.locator?.trim().isNotEmpty ?? false);

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
