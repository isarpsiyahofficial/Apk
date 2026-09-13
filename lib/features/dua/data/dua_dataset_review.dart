import 'dua_content.dart';

enum DuaReviewDecision { pending, approved, rejected }

/// Immutable evidence that a dua record has completed the native TR/EN/AR
/// editorial pass and the separate religious/source review required by
/// SPEC 585–589 / TODO T0129.
///
/// Reviewer identifiers are audit labels only. They must not contain email,
/// account or other private data.
final class DuaDatasetReviewEvidence {
  const DuaDatasetReviewEvidence({
    required this.duaId,
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

  final String duaId;
  final int contentVersion;
  final DuaReviewDecision religiousReview;
  final DuaReviewDecision turkishNativeReview;
  final DuaReviewDecision englishNativeReview;
  final DuaReviewDecision arabicNativeReview;
  final DateTime reviewedAt;
  final String religiousReviewerId;
  final String turkishReviewerId;
  final String englishReviewerId;
  final String arabicReviewerId;

  bool get isFullyApproved =>
      duaId.trim().isNotEmpty &&
      contentVersion > 0 &&
      religiousReview == DuaReviewDecision.approved &&
      turkishNativeReview == DuaReviewDecision.approved &&
      englishNativeReview == DuaReviewDecision.approved &&
      arabicNativeReview == DuaReviewDecision.approved &&
      religiousReviewerId.trim().isNotEmpty &&
      turkishReviewerId.trim().isNotEmpty &&
      englishReviewerId.trim().isNotEmpty &&
      arabicReviewerId.trim().isNotEmpty;
}

/// Final T0129 publication gate.
///
/// A record is returned only if the normal production/source gates pass and a
/// matching review entry approves the exact same content id + version. A review
/// for an older version can never authorize edited religious text. The review
/// evidence must also be at least as recent as the record's own review marker;
/// this closes the failure path where content is re-reviewed/edited without a
/// corresponding version bump and stale TR/EN/AR + religious evidence remains.
final class DuaDatasetReviewGate {
  const DuaDatasetReviewGate();

  List<DuaContent> approve({
    required Iterable<DuaContent> records,
    required Iterable<DuaDatasetReviewEvidence> evidence,
  }) {
    final byId = <String, DuaDatasetReviewEvidence>{};
    for (final entry in evidence) {
      if (byId.containsKey(entry.duaId)) {
        throw StateError('Duplicate dua review evidence: ${entry.duaId}');
      }
      byId[entry.duaId] = entry;
    }

    final approved = <DuaContent>[];
    final seenIds = <String>{};
    for (final record in records) {
      if (!seenIds.add(record.id)) {
        throw StateError('Duplicate dua content id during review: ${record.id}');
      }
      if (!record.canEnterProductionDataset) {
        throw StateError('Dua failed source/production gates: ${record.id}');
      }

      final review = byId[record.id];
      if (review == null ||
          !review.isFullyApproved ||
          review.contentVersion != record.version ||
          review.reviewedAt.isBefore(record.lastReviewedAt)) {
        throw StateError(
          'Dua is missing current complete TR/EN/AR + religious review: ${record.id}',
        );
      }
      approved.add(record);
    }

    return List<DuaContent>.unmodifiable(approved);
  }
}
