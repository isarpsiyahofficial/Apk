import 'history_event_contract.dart';

typedef HistoryEventLoader = List<HistoryEventRecord> Function();

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
/// The canonical event list is not requested from [loader] until the first
/// page or index lookup. Once loaded, a deterministic chronological view and
/// stable-ID indexes are built once and reused. This is deliberately not a
/// text-search index; universal locale-aware search belongs to T0230–T0232.
class HistoryPagedIndexT0225 {
  HistoryPagedIndexT0225({required HistoryEventLoader loader}) : _loader = loader;

  final HistoryEventLoader _loader;

  List<HistoryEventRecord>? _ordered;
  Map<String, HistoryEventRecord>? _byId;
  Map<String, List<HistoryEventRecord>>? _byPersonId;
  Map<String, List<HistoryEventRecord>>? _byGeographyId;

  bool get isLoaded => _ordered != null;

  int get totalCount {
    _ensureLoaded();
    return _ordered!.length;
  }

  HistoryEventPage loadPage({int cursor = 0, int pageSize = 20}) {
    if (cursor < 0) {
      throw ArgumentError.value(cursor, 'cursor', 'must be >= 0');
    }
    if (pageSize < 1 || pageSize > 100) {
      throw ArgumentError.value(pageSize, 'pageSize', 'must be between 1 and 100');
    }

    _ensureLoaded();
    final ordered = _ordered!;
    if (cursor > ordered.length) {
      throw RangeError.range(cursor, 0, ordered.length, 'cursor');
    }

    final candidateEnd = cursor + pageSize;
    final end = candidateEnd < ordered.length ? candidateEnd : ordered.length;
    final items = List<HistoryEventRecord>.unmodifiable(ordered.sublist(cursor, end));
    final nextCursor = end < ordered.length ? end : null;
    return HistoryEventPage(
      items: items,
      totalCount: ordered.length,
      nextCursor: nextCursor,
    );
  }

  HistoryEventRecord? eventById(String eventId) {
    final normalized = eventId.trim();
    if (normalized.isEmpty) return null;
    _ensureLoaded();
    return _byId![normalized];
  }

  List<HistoryEventRecord> eventsForPerson(String personId) {
    final normalized = personId.trim();
    if (normalized.isEmpty) return const <HistoryEventRecord>[];
    _ensureLoaded();
    return _byPersonId![normalized] ?? const <HistoryEventRecord>[];
  }

  List<HistoryEventRecord> eventsForGeography(String geographyId) {
    final normalized = geographyId.trim();
    if (normalized.isEmpty) return const <HistoryEventRecord>[];
    _ensureLoaded();
    return _byGeographyId![normalized] ?? const <HistoryEventRecord>[];
  }

  void _ensureLoaded() {
    if (_ordered != null) return;

    final loaded = List<HistoryEventRecord>.of(_loader(), growable: false);
    if (loaded.isEmpty) {
      throw StateError('T0225 history loader must not return an empty event set.');
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
