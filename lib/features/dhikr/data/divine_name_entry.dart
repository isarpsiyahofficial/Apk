import 'package:islami_hayat/core/content/content_governance.dart';
import 'package:islami_hayat/features/dhikr/data/ebced_value.dart';

/// Source-governed entry for the Esmâü'l-Hüsnâ guide.
///
/// This model intentionally does not infer devotional promises or recommended
/// counts. It carries the reviewed name, transliteration, meaning, contextual
/// explanation and explicit Qur'an / sahih-hasan hadith links. Optional ebced
/// metadata is a separate historical/math field and never a devotional count.
final class DivineNameEntry {
  DivineNameEntry({
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
    this.reviewer,
    this.ebced,
  }) {
    _validateShape();
  }

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
  final String? reviewer;
  final EbcedValueMetadata? ebced;

  bool get hasPrimaryReligiousLink => sources.any(
        (source) =>
            source.sourceClass == ReligiousSourceClass.quran ||
            source.sourceClass == ReligiousSourceClass.sahihHasanHadith,
      );

  EbcedValueMetadata? get publishedEbced =>
      ebced?.canBeDisplayed == true ? ebced : null;

  bool get canEnterProductionDataset =>
      id.trim().isNotEmpty &&
      arabic.trim().isNotEmpty &&
      transliterationTr.trim().isNotEmpty &&
      transliterationEn.trim().isNotEmpty &&
      meaning.isComplete &&
      whyRecited.isComplete &&
      reviewStatus == ContentReviewStatus.published &&
      version > 0 &&
      sources.isNotEmpty &&
      sources.every(_isValidSource) &&
      hasPrimaryReligiousLink;

  ReligiousContentRecord toGovernedRecord() {
    if (!canEnterProductionDataset) {
      throw StateError('Unreviewed Esma entry cannot enter production: $id');
    }

    final primary = sources.firstWhere(
      (source) =>
          source.sourceClass == ReligiousSourceClass.quran ||
          source.sourceClass == ReligiousSourceClass.sahihHasanHadith,
    );
    return ReligiousContentRecord(
      id: id,
      type: ContentType.divineName,
      sourceStatus: primary.sourceClass,
      version: version,
      reviewStatus: reviewStatus,
      certainty: CertaintyLevel.explicitSource,
      text: meaning,
      sources: List.unmodifiable(sources),
      lastReviewedAt: lastReviewedAt,
      reviewer: reviewer,
    );
  }

  void _validateShape() {
    if (id.trim().isEmpty ||
        arabic.trim().isEmpty ||
        transliterationTr.trim().isEmpty ||
        transliterationEn.trim().isEmpty ||
        !meaning.isComplete ||
        !whyRecited.isComplete ||
        version <= 0) {
      throw ArgumentError('Divine name entry has incomplete required fields.');
    }
    if (sources.any((source) => !_isValidSource(source))) {
      throw ArgumentError('Divine name entry contains invalid source metadata.');
    }
  }

  static bool _isValidSource(SourceReference source) =>
      source.id.trim().isNotEmpty &&
      source.title.trim().isNotEmpty &&
      source.licenseId.trim().isNotEmpty &&
      (source.locator?.trim().isNotEmpty ?? false) &&
      source.sourceClass != ReligiousSourceClass.unknown;
}
