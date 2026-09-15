import 'package:islami_hayat/core/content/content_governance.dart';

/// Historical abjad/ebced metadata kept separate from devotional counts.
///
/// A value may be shown only after review and only with a source explicitly
/// classified as the ebced/havas tradition. It must never be promoted to a
/// Qur'an/hadith-backed or Sunnah-prescribed dhikr count.
final class EbcedValueMetadata {
  EbcedValueMetadata({
    required this.value,
    required this.source,
    required this.reviewStatus,
    required this.version,
    required this.lastReviewedAt,
    this.reviewer,
  }) {
    if (value <= 0 || version <= 0) {
      throw ArgumentError('Ebced value and version must be positive.');
    }
    if (source.sourceClass != ReligiousSourceClass.ebcedHavasTradition) {
      throw ArgumentError(
        'Ebced metadata must use the ebced/havas tradition source class.',
      );
    }
    if (!_isValidSource(source)) {
      throw ArgumentError('Ebced metadata contains invalid source metadata.');
    }
  }

  final int value;
  final SourceReference source;
  final ContentReviewStatus reviewStatus;
  final int version;
  final DateTime lastReviewedAt;
  final String? reviewer;

  bool get canBeDisplayed =>
      reviewStatus == ContentReviewStatus.published &&
      value > 0 &&
      version > 0 &&
      source.sourceClass == ReligiousSourceClass.ebcedHavasTradition &&
      _isValidSource(source);

  static bool _isValidSource(SourceReference source) =>
      source.id.trim().isNotEmpty &&
      source.title.trim().isNotEmpty &&
      source.licenseId.trim().isNotEmpty &&
      (source.locator?.trim().isNotEmpty ?? false);
}
