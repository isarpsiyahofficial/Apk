import 'dart:collection';

import 'package:islami_hayat/features/dhikr/data/divine_name_dataset_review.dart';
import 'package:islami_hayat/features/dhikr/data/divine_name_entry.dart';

/// Fail-closed production boundary for Esmâü'l-Hüsnâ guide records.
///
/// A partially reviewed collection must never degrade into a partially visible
/// production guide. Every record must pass source/content governance and the
/// exact-version religious + native TR/EN/AR review gate before it is exposed.
final class DivineNameRepository {
  DivineNameRepository({
    required Iterable<DivineNameEntry> entries,
    required Iterable<DivineNameDatasetReviewEvidence> reviewEvidence,
  }) : _entries = const DivineNameDatasetReviewGate().approve(
          records: entries,
          evidence: reviewEvidence,
        );

  final List<DivineNameEntry> _entries;

  UnmodifiableListView<DivineNameEntry> get entries =>
      UnmodifiableListView<DivineNameEntry>(_entries);

  DivineNameEntry? findById(String id) {
    final normalized = id.trim();
    if (normalized.isEmpty) return null;
    for (final entry in _entries) {
      if (entry.id == normalized) return entry;
    }
    return null;
  }
}
