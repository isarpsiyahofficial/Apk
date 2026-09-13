import 'canonical_prophets.dart';
import 'prophet_content.dart';

enum ProphetReviewDecision { pending, approved, rejected }

/// Audit evidence for TODO T0205 / SPEC 891–894.
///
/// This object records review state only. It is intentionally not populated by
/// automated tests: native-language and religious review must come from real
/// editorial evidence. Reviewer ids are non-private audit labels.
final class ProphetDatasetReviewEvidence {
  const ProphetDatasetReviewEvidence({
    required this.canonicalId,
    required this.contentVersion,
    required this.religiousReview,
    required this.turkishNativeReview,
    required this.englishNativeReview,
    required this.arabicNativeReview,
    required this.terminologyReview,
    required this.reviewedAt,
    required this.religiousReviewerId,
    required this.turkishReviewerId,
    required this.englishReviewerId,
    required this.arabicReviewerId,
    required this.terminologyReviewerId,
  });

  final String canonicalId;
  final int contentVersion;
  final ProphetReviewDecision religiousReview;
  final ProphetReviewDecision turkishNativeReview;
  final ProphetReviewDecision englishNativeReview;
  final ProphetReviewDecision arabicNativeReview;
  final ProphetReviewDecision terminologyReview;
  final DateTime reviewedAt;
  final String religiousReviewerId;
  final String turkishReviewerId;
  final String englishReviewerId;
  final String arabicReviewerId;
  final String terminologyReviewerId;

  bool get isFullyApproved =>
      canonicalId.trim().isNotEmpty &&
      contentVersion > 0 &&
      religiousReview == ProphetReviewDecision.approved &&
      turkishNativeReview == ProphetReviewDecision.approved &&
      englishNativeReview == ProphetReviewDecision.approved &&
      arabicNativeReview == ProphetReviewDecision.approved &&
      terminologyReview == ProphetReviewDecision.approved &&
      religiousReviewerId.trim().isNotEmpty &&
      turkishReviewerId.trim().isNotEmpty &&
      englishReviewerId.trim().isNotEmpty &&
      arabicReviewerId.trim().isNotEmpty &&
      terminologyReviewerId.trim().isNotEmpty;
}

/// Fail-closed publication gate for prophet biography language review.
///
/// In addition to exact version-bound review evidence, the displayed TR/EN/AR
/// names must match the canonical identity registry. This prevents a biography
/// supplement from silently drifting into a different transliteration or an
/// English/Biblical alias while the canonical navigation identity remains
/// unchanged.
final class ProphetDatasetReviewGate {
  const ProphetDatasetReviewGate();

  List<ProphetContent> approve({
    required Iterable<ProphetContent> records,
    required Iterable<ProphetDatasetReviewEvidence> evidence,
    Iterable<CanonicalProphetIdentity> canonicalIdentities =
        canonicalQuranNamedProphets,
  }) {
    final identitiesById = <String, CanonicalProphetIdentity>{};
    for (final identity in canonicalIdentities) {
      if (!identity.isValid || identitiesById.containsKey(identity.canonicalId)) {
        throw StateError('Invalid or duplicate canonical prophet identity: ${identity.canonicalId}');
      }
      identitiesById[identity.canonicalId] = identity;
    }

    final evidenceById = <String, ProphetDatasetReviewEvidence>{};
    for (final entry in evidence) {
      if (evidenceById.containsKey(entry.canonicalId)) {
        throw StateError('Duplicate prophet review evidence: ${entry.canonicalId}');
      }
      evidenceById[entry.canonicalId] = entry;
    }

    final approved = <ProphetContent>[];
    final seenIds = <String>{};
    for (final record in records) {
      if (!seenIds.add(record.canonicalId)) {
        throw StateError('Duplicate prophet content id during review: ${record.canonicalId}');
      }
      if (!record.canEnterProductionDataset) {
        throw StateError('Prophet failed source/production gates: ${record.canonicalId}');
      }

      final canonical = identitiesById[record.canonicalId];
      if (canonical == null) {
        throw StateError('Unknown canonical prophet identity: ${record.canonicalId}');
      }
      if (!_sameLocalizedName(record, canonical)) {
        throw StateError('Prophet terminology differs from canonical registry: ${record.canonicalId}');
      }

      final review = evidenceById[record.canonicalId];
      if (review == null ||
          !review.isFullyApproved ||
          review.contentVersion != record.record.version ||
          review.reviewedAt.isBefore(record.record.lastReviewedAt)) {
        throw StateError(
          'Prophet is missing current TR/EN/AR + religious + terminology review: ${record.canonicalId}',
        );
      }
      approved.add(record);
    }

    return List<ProphetContent>.unmodifiable(approved);
  }

  bool _sameLocalizedName(
    ProphetContent record,
    CanonicalProphetIdentity canonical,
  ) =>
      record.name.tr == canonical.name.tr &&
      record.name.en == canonical.name.en &&
      record.name.ar == canonical.name.ar &&
      record.arabicName == canonical.arabicName;
}
