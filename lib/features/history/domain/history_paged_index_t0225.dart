import 'history_event_contract.dart';

typedef HistoryEventLoader = List<HistoryEventRecord> Function();
typedef HistoryPageLoader = List<HistoryEventRecord> Function(int cursor, int limit);

class HistoryEventPage {
  const HistoryEventPage({
    required this.items,
    required this.totalCount,
    required this.nextCursor,
  });

  final List<HistoryEventRecord> items;
  final int totalCount;
  final int? nextCursor;

  bool get hasMore => nextCursor != null;
}

/// Device-local, lazy history access layer for T0225.
///
/// Page reads can use a bounded [pageLoader] without materialising the complete
/// history inventory. Stable-ID/person/geography indexes are built only when an
/// index lookup is requested. The legacy [loader] path remains available for
/// callers that cannot provide a paged source yet, but production should prefer
/// [pageLoader] + [totalCount]. Universal locale-aware text search belongs to
/// T0230–T0232.
class HistoryPagedIndexT0225 {
  HistoryPagedIndexT0225({
    HistoryEventLoader? loader,
    HistoryPageLoader? pageLoader,
    int? totalCount,
  })  : _loader = loader,
        _pageLoader = pageLoader,
        _declaredTotalCount = totalCount {
    final hasPagedSource = pageLoader != null || totalCount != null;
    if (hasPagedSource && (pageLoader == null || totalCount == null)) {
      throw ArgumentError('T0225 paged source requires both pageLoader and totalCount.');
    }
    if (loader == null && pageLoader == null) {
      throw ArgumentError('T0225 requires a loader or a paged source.');
    }
    if (totalCount != null && totalCount < 1) {
      throw ArgumentError.value(totalCount, 'totalCount', 'must be >= 1');
    }
  }

  final HistoryEventLoader? _loader;
  final HistoryPageLoader? _pageLoader;
  final int? _declaredTotalCount;

  List<HistoryEventRecord>? _ordered;
  Map<String, HistoryEventRecord>? _byId;
  Map<String, List<HistoryEventRecord>>? _byPersonId;
  Map<String, List<HistoryEventRecord>>? _byGeographyId;
  bool _hasLoadedPage = false;

  bool get isLoaded => _hasLoadedPage || _ordered != null;
  bool get isIndexLoaded => _ordered != null;

  int get totalCount {
    if (_declaredTotalCount != null) return _declaredTotalCount;
    _ensureIndexesLoaded();
    return _ordered!.length;
  }

  HistoryEventPage loadPage({int cursor = 0, int pageSize = 20}) {
    if (cursor < 0) {
      throw ArgumentError.value(cursor, 'cursor', 'must be >= 0');
    }
    if (pageSize < 1 || pageSize > 100) {
      throw ArgumentError.value(pageSize, 'pageSize', 'must be between 1 and 100');
    }

    final count = totalCount;
    if (cursor > count) {
      throw RangeError.range(cursor, 0, count, 'cursor');
    }
    final end = (cursor + pageSize) < count ? cursor + pageSize : count;
    final expectedLength = end - cursor;

    final List<HistoryEventRecord> items;
    if (_pageLoader != null) {
      final loaded = List<HistoryEventRecord>.of(
        _pageLoader(cursor, expectedLength),
        growable: false,
      );
      _validatePage(loaded, expectedLength, cursor);
      items = loaded;
    } else {
      _ensureIndexesLoaded();
      items = _ordered!.sublist(cursor, end);
    }

    _hasLoadedPage = true;
    return HistoryEventPage(
      items: List<HistoryEventRecord>.unmodifiable(items),
      totalCount: count,
      nextCursor: end < count ? end : null,
    );
  }

  HistoryEventRecord? eventById(String eventId) {
    final normalized = eventId.trim();
    if (normalized.isEmpty) return null;
    _ensureIndexesLoaded();
    return _byId![normalized];
  }

  List<HistoryEventRecord> eventsForPerson(String personId) {
    final normalized = personId.trim();
    if (normalized.isEmpty) return const <HistoryEventRecord>[];
    _ensureIndexesLoaded();
    return _byPersonId![normalized] ?? const <HistoryEventRecord>[];
  }

  List<HistoryEventRecord> eventsForGeography(String geographyId) {
    final normalized = geographyId.trim();
    if (normalized.isEmpty) return const <HistoryEventRecord>[];
    _ensureIndexesLoaded();
    return _byGeographyId![normalized] ?? const <HistoryEventRecord>[];
  }

  void _validatePage(
    List<HistoryEventRecord> loaded,
    int expectedLength,
    int cursor,
  ) {
    if (loaded.length != expectedLength) {
      throw StateError(
        'T0225 paged source returned ${loaded.length} items for cursor $cursor; expected $expectedLength.',
      );
    }
    final ids = <String>{};
    for (final event in loaded) {
      if (event.id.trim().isEmpty || !ids.add(event.id)) {
        throw StateError('T0225 page requires unique non-empty event IDs: ${event.id}');
      }
    }
    for (var index = 1; index < loaded.length; index++) {
      if (_compareChronologically(loaded[index - 1], loaded[index]) > 0) {
        throw StateError('T0225 paged source must return chronological pages.');
      }
    }
  }

  void _ensureIndexesLoaded() {
    if (_ordered != null) return;

    final loaded = _loader != null
        ? List<HistoryEventRecord>.of(_loader(), growable: false)
        : _loadAllPagesForIndex();
    if (loaded.isEmpty) {
      throw StateError('T0225 history source must not return an empty event set.');
    }

    final byId = <String, HistoryEventRecord>{};
    final byPersonId = <String, List<HistoryEventRecord>>{};
    final byGeographyId = <String, List<HistoryEventRecord>>{};

    for (final event in loaded) {
      if (event.id.trim().isEmpty || byId.containsKey(event.id)) {
        throw StateError(
          'T0225 history index requires unique non-empty event IDs: ${event.id}',
        );
      }
      byId[event.id] = event;

      for (final person in event.people) {
        final personId = person.id.trim();
        if (personId.isEmpty) {
          throw StateError('T0225 cannot index an empty person ID for ${event.id}.');
        }
        byPersonId.putIfAbsent(personId, () => <HistoryEventRecord>[]).add(event);
      }

      for (final geography in event.geographies) {
        final geographyId = geography.id.trim();
        if (geographyId.isEmpty) {
          throw StateError('T0225 cannot index an empty geography ID for ${event.id}.');
        }
        byGeographyId.putIfAbsent(geographyId, () => <HistoryEventRecord>[]).add(event);
      }
    }

    loaded.sort(_compareChronologically);
    _ordered = List<HistoryEventRecord>.unmodifiable(loaded);
    _byId = Map<String, HistoryEventRecord>.unmodifiable(byId);
    _byPersonId = Map<String, List<HistoryEventRecord>>.unmodifiable(
      byPersonId.map(
        (key, value) => MapEntry(
          key,
          List<HistoryEventRecord>.unmodifiable(value..sort(_compareChronologically)),
        ),
      ),
    );
    _byGeographyId = Map<String, List<HistoryEventRecord>>.unmodifiable(
      byGeographyId.map(
        (key, value) => MapEntry(
          key,
          List<HistoryEventRecord>.unmodifiable(value..sort(_compareChronologically)),
        ),
      ),
    );
  }

  List<HistoryEventRecord> _loadAllPagesForIndex() {
    final count = _declaredTotalCount!;
    final all = <HistoryEventRecord>[];
    const batchSize = 100;
    for (var cursor = 0; cursor < count; cursor += batchSize) {
      final remaining = count - cursor;
      final limit = remaining < batchSize ? remaining : batchSize;
      final page = List<HistoryEventRecord>.of(
        _pageLoader!(cursor, limit),
        growable: false,
      );
      _validatePage(page, limit, cursor);
      all.addAll(page);
    }
    return all;
  }

  static int _compareChronologically(HistoryEventRecord a, HistoryEventRecord b) {
    final aYear = a.startYearCe;
    final bYear = b.startYearCe;
    if (aYear == null && bYear != null) return 1;
    if (aYear != null && bYear == null) return -1;
    if (aYear != null && bYear != null) {
      final startCompare = aYear.compareTo(bYear);
      if (startCompare != 0) return startCompare;
      final endCompare = a.endYearCe!.compareTo(b.endYearCe!);
      if (endCompare != 0) return endCompare;
    }
    return a.id.compareTo(b.id);
  }
}
