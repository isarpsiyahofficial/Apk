import 'history_event_contract.dart';

typedef HistoryChunkLoaderT0225 = List<HistoryEventRecord> Function();

class HistoryLazyChunkT0225 {
  const HistoryLazyChunkT0225({
    required this.id,
    required this.itemCount,
    required this.loader,
    this.minimumStartYearCe,
    this.unknownDatesOnly = false,
  }) : assert(itemCount > 0);

  final String id;
  final int itemCount;
  final int? minimumStartYearCe;
  final bool unknownDatesOnly;
  final HistoryChunkLoaderT0225 loader;
}

/// Incremental chronological source for T0225.
///
/// Chunks carry lightweight lower-bound chronology metadata. A page request
/// materialises only the chunks that can still contribute records before the
/// requested page boundary. Chunks whose records are all intentionally
/// date-unknown stay unloaded until dated records can no longer satisfy the
/// requested page. This prevents first-page access from forcing every history
/// dataset into memory.
class HistoryChunkedPageSourceT0225 {
  HistoryChunkedPageSourceT0225({required List<HistoryLazyChunkT0225> chunks})
      : _chunks = List<HistoryLazyChunkT0225>.unmodifiable(chunks) {
    if (_chunks.isEmpty) {
      throw ArgumentError('T0225 chunk source requires at least one chunk.');
    }
    final ids = <String>{};
    for (final chunk in _chunks) {
      if (chunk.id.trim().isEmpty || !ids.add(chunk.id)) {
        throw ArgumentError('T0225 chunk IDs must be unique and non-empty.');
      }
      if (chunk.unknownDatesOnly && chunk.minimumStartYearCe != null) {
        throw ArgumentError(
          'T0225 unknown-date chunk ${chunk.id} cannot declare a minimum year.',
        );
      }
      if (!chunk.unknownDatesOnly && chunk.minimumStartYearCe == null) {
        throw ArgumentError(
          'T0225 dated chunk ${chunk.id} must declare a conservative minimum year.',
        );
      }
    }
  }

  final List<HistoryLazyChunkT0225> _chunks;
  final Set<String> _loadedChunkIds = <String>{};
  final Set<String> _loadedEventIds = <String>{};
  final List<HistoryEventRecord> _orderedLoaded = <HistoryEventRecord>[];

  int get totalCount => _chunks.fold(0, (sum, chunk) => sum + chunk.itemCount);

  Set<String> get loadedChunkIds => Set<String>.unmodifiable(_loadedChunkIds);

  List<HistoryEventRecord> loadPage(int cursor, int limit) {
    if (cursor < 0 || limit < 0 || cursor + limit > totalCount) {
      throw RangeError('T0225 chunk page request is outside the canonical range.');
    }
    if (limit == 0) return const <HistoryEventRecord>[];

    final targetEnd = cursor + limit;
    _ensureCoverage(targetEnd);
    return List<HistoryEventRecord>.unmodifiable(
      _orderedLoaded.sublist(cursor, targetEnd),
    );
  }

  void _ensureCoverage(int targetEnd) {
    while (true) {
      final next = _nextUnloadedChunk();
      if (next == null) break;

      if (_orderedLoaded.length < targetEnd) {
        _loadChunk(next);
        continue;
      }

      final boundary = _orderedLoaded[targetEnd - 1];
      if (boundary.startYearCe == null) {
        _loadChunk(next);
        continue;
      }

      if (next.unknownDatesOnly) {
        break;
      }

      if (next.minimumStartYearCe! <= boundary.startYearCe!) {
        _loadChunk(next);
        continue;
      }
      break;
    }

    if (_orderedLoaded.length < targetEnd) {
      throw StateError(
        'T0225 chunk metadata declared $totalCount records but only '
        '${_orderedLoaded.length} could be loaded.',
      );
    }
  }

  HistoryLazyChunkT0225? _nextUnloadedChunk() {
    HistoryLazyChunkT0225? best;
    for (final chunk in _chunks) {
      if (_loadedChunkIds.contains(chunk.id)) continue;
      if (best == null || _precedes(chunk, best)) best = chunk;
    }
    return best;
  }

  bool _precedes(HistoryLazyChunkT0225 a, HistoryLazyChunkT0225 b) {
    if (a.unknownDatesOnly != b.unknownDatesOnly) return !a.unknownDatesOnly;
    if (!a.unknownDatesOnly) {
      final yearCompare = a.minimumStartYearCe!.compareTo(b.minimumStartYearCe!);
      if (yearCompare != 0) return yearCompare < 0;
    }
    return a.id.compareTo(b.id) < 0;
  }

  void _loadChunk(HistoryLazyChunkT0225 chunk) {
    final records = List<HistoryEventRecord>.of(chunk.loader(), growable: false);
    if (records.length != chunk.itemCount) {
      throw StateError(
        'T0225 chunk ${chunk.id} expected ${chunk.itemCount} records but loaded ${records.length}.',
      );
    }

    for (final event in records) {
      if (event.id.trim().isEmpty || !_loadedEventIds.add(event.id)) {
        throw StateError(
          'T0225 chunks require globally unique non-empty event IDs: ${event.id}',
        );
      }
      if (chunk.unknownDatesOnly) {
        if (event.startYearCe != null || event.endYearCe != null) {
          throw StateError(
            'T0225 unknown-date chunk ${chunk.id} contains a dated record: ${event.id}',
          );
        }
      } else {
        final startYear = event.startYearCe;
        if (startYear == null || startYear < chunk.minimumStartYearCe!) {
          throw StateError(
            'T0225 chunk ${chunk.id} violates its conservative minimum year at ${event.id}.',
          );
        }
      }
    }

    _loadedChunkIds.add(chunk.id);
    _orderedLoaded.addAll(records);
    _orderedLoaded.sort(_compareChronologically);
  }

  static int _compareChronologically(HistoryEventRecord a, HistoryEventRecord b) {
    final aYear = a.startYearCe;
    final bYear = b.startYearCe;
    if (aYear == null && bYear != null) return 1;
    if (aYear != null && bYear == null) return -1;
    if (aYear != null && bYear != null) {
      final startCompare = aYear.compareTo(bYear);
      if (startCompare != 0) return startCompare;
      final aEnd = a.endYearCe ?? aYear;
      final bEnd = b.endYearCe ?? bYear;
      final endCompare = aEnd.compareTo(bEnd);
      if (endCompare != 0) return endCompare;
    }
    return a.id.compareTo(b.id);
  }
}
