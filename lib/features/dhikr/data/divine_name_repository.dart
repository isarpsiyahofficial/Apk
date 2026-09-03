import 'dart:collection';

import 'package:islami_hayat/features/dhikr/data/divine_name_entry.dart';

/// Fail-closed production boundary for Esmâü'l-Hüsnâ guide records.
///
/// A partially reviewed collection must never degrade into a partially visible
/// production guide. Every record must independently satisfy the source,
/// localization and religious-review contract in [DivineNameEntry].
final class DivineNameRepository {
  DivineNameRepository({required Iterable<DivineNameEntry> entries})
      : _entries = List<DivineNameEntry>.unmodifiable(entries) {
    _validateProductionDataset();
  }

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

  void _validateProductionDataset() {
    if (_entries.isEmpty) {
      throw StateError('Production Esma dataset cannot be empty.');
    }

    final seenIds = <String>{};
    for (final entry in _entries) {
      if (!entry.canEnterProductionDataset) {
        throw StateError(
          'Unreviewed or weakly sourced Esma entry in production dataset: '
          '${entry.id}',
        );
      }
      if (!seenIds.add(entry.id)) {
        throw StateError('Duplicate Esma entry id in production dataset: ${entry.id}');
      }
    }
  }
}
