import 'package:flutter_test/flutter_test.dart';
import 'package:islami_hayat/features/history/data/history_paged_store_t0225.dart';
import 'package:islami_hayat/features/history/data/history_t0220_inventory.dart';
import 'package:islami_hayat/features/history/domain/history_chunked_page_source_t0225.dart';
import 'package:islami_hayat/features/history/domain/history_event_contract.dart';

int _compareChronologically(HistoryEventRecord a, HistoryEventRecord b) {
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

void main() {
  group('HistoryChunkedPageSourceT0225', () {
    test('production metadata count matches canonical T0220 inventory', () {
      expect(
        historyChunkedPageSourceT0225.totalCount,
        historyT0220Inventory.events.length,
      );
    });

    test('first production page does not materialise every history chunk', () {
      final canonical = List<HistoryEventRecord>.of(historyT0220Inventory.events)
        ..sort(_compareChronologically);

      final first = historyChunkedPageSourceT0225.loadPage(0, 5);

      expect(
        first.map((event) => event.id),
        canonical.take(5).map((event) => event.id),
      );
      expect(
        historyChunkedPageSourceT0225.loadedChunkIds,
        isNot(contains('t0212-muhammad-relative-chronology')),
      );
      expect(historyChunkedPageSourceT0225.loadedChunkIds.length, lessThan(7));
    });

    test('full traversal remains identical to canonical chronological inventory', () {
      final canonical = List<HistoryEventRecord>.of(historyT0220Inventory.events)
        ..sort(_compareChronologically);

      final all = historyChunkedPageSourceT0225.loadPage(
        0,
        historyChunkedPageSourceT0225.totalCount,
      );

      expect(
        all.map((event) => event.id),
        canonical.map((event) => event.id),
      );
      expect(historyChunkedPageSourceT0225.loadedChunkIds, hasLength(7));
    });

    test('wrong chunk count fails closed when the chunk is first requested', () {
      final seed = historyT0220Inventory.events.first;
      final source = HistoryChunkedPageSourceT0225(
        chunks: <HistoryLazyChunkT0225>[
          HistoryLazyChunkT0225(
            id: 'broken-count',
            itemCount: 2,
            minimumStartYearCe: -10000,
            loader: () => <HistoryEventRecord>[seed],
          ),
        ],
      );

      expect(() => source.loadPage(0, 1), throwsStateError);
    });

    test('minimum-year metadata cannot hide an earlier record', () {
      final dated = historyT0220Inventory.events.firstWhere(
        (event) => event.startYearCe != null,
      );
      final source = HistoryChunkedPageSourceT0225(
        chunks: <HistoryLazyChunkT0225>[
          HistoryLazyChunkT0225(
            id: 'invalid-lower-bound',
            itemCount: 1,
            minimumStartYearCe: dated.startYearCe! + 1,
            loader: () => <HistoryEventRecord>[dated],
          ),
        ],
      );

      expect(() => source.loadPage(0, 1), throwsStateError);
    });
  });
}
