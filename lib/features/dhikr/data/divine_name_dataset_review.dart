import 'package:islami_hayat/features/dhikr/data/divine_name_entry.dart';

enum DivineNameReviewDecision { pending, approved, rejected }

/// Audit evidence for the exact Esmâ record version shown to users.
///
/// Production publication requires an independent religious/source decision
/// plus native TR, EN and AR editorial approvals. Evidence is bound to the
/// stable entry id and exact version so a changed record cannot reuse stale
/// language or religious review.
final class DivineNameDatasetReviewEvidence {
  const DivineNameDatasetReviewEvidence({
    required this.entryId,
    required this.contentVersion,
    required this.religiousReview,
    required this.turkishNativeReview,
    required this.englishNativeReview,
    required this.arabicNativeReview,
    required this.reviewedAt,
    required this.religiousReviewerId,
    required this.turkishReviewerId,
    required this.englishReviewerId,
    required this.arabicReviewerId,
  });

  final String entryId;
  final int contentVersion;
  final DivineNameReviewDecision religiousReview;
  final DivineNameReviewDecision turkishNativeReview;
  final DivineNameReviewDecision englishNativeReview;
  final DivineNameReviewDecision arabicNativeReview;
  final DateTime reviewedAt;
  final String religiousReviewerId;
  final String turkishReviewerId;
  final String englishReviewerId;
  final String arabicReviewerId;

  bool get isFullyApproved =>
      entryId.trim().isNotEmpty &&
      contentVersion > 0 &&
      religiousReview == DivineNameReviewDecision.approved &&
      turkishNativeReview == DivineNameReviewDecision.approved &&
      englishNativeReview == DivineNameReviewDecision.approved &&
      arabicNativeReview == DivineNameReviewDecision.approved &&
      religiousReviewerId.trim().isNotEmpty &&
      turkishReviewerId.trim().isNotEmpty &&
      englishReviewerId.trim().isNotEmpty &&
      arabicReviewerId.trim().isNotEmpty;
}

/// Final publication gate for T0137/D14 Esmâ records.
final class DivineNameDatasetReviewGate {
  const DivineNameDatasetReviewGate();

  List<DivineNameEntry> approve({
    required Iterable<DivineNameEntry> records,
    required Iterable<DivineNameDatasetReviewEvidence> evidence,
  }) {
    final byId = <String, DivineNameDatasetReviewEvidence>{};
    for (final item in evidence) {
      if (byId.containsKey(item.entryId)) {
        throw StateError('Duplicate Esma review evidence: ${item.entryId}');
      }
      byId[item.entryId] = item;
    }

    final approved = <DivineNameEntry>[];
    final seenIds = <String>{};
    for (final record in records) {
      if (!seenIds.add(record.id)) {
        throw StateError('Duplicate Esma content id during review: ${record.id}');
      }
      if (!record.canEnterProductionDataset) {
        throw StateError('Esma entry failed source/production gates: ${record.id}');
      }

      final review = byId[record.id];
      if (review == null ||
          !review.isFullyApproved ||
          review.contentVersion != record.version ||
          review.reviewedAt.isBefore(record.lastReviewedAt)) {
        throw StateError(
          'Esma entry is missing current complete TR/EN/AR + religious review: ${record.id}',
        );
      }
      approved.add(record);
    }

    if (approved.isEmpty) {
      throw StateError('Production Esma dataset cannot be empty.');
    }
    return List<DivineNameEntry>.unmodifiable(approved);
  }
}
