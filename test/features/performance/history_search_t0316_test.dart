import 'package:flutter_test/flutter_test.dart';
import 'package:islami_hayat/features/history/data/history_paged_store_t0225.dart';
import 'package:islami_hayat/features/search/domain/device_search_index_t0230.dart';

void main() {
  group('T0316 history/search performance', () {
    test('history first page stays lazy and fast', () {
      final before = historyChunkedPageSourceT0225.loadedChunkIds.length;
      final stopwatch = Stopwatch()..start();
      final page = historyChunkedPageSourceT0225.loadPage(0, 5);
      stopwatch.stop();

      expect(page, hasLength(5));
      expect(before, 0);
      expect(historyChunkedPageSourceT0225.loadedChunkIds.length, lessThan(7));
      expect(
        stopwatch.elapsed,
        lessThan(const Duration(seconds: 1)),
        reason: 'A five-row history page must not require full-corpus work.',
      );
    });

    test('large search corpus loads once and keeps repeated lookup bounded', () {
      var loaderCalls = 0;
      final documents = List<SearchDocumentT0230>.generate(
        12000,
        (index) => SearchDocumentT0230(
          id: 'synthetic:$index',
          searchableTexts: <String>[
            'common history document $index',
            if (index == 7319) 'rare-marker',
          ],
        ),
        growable: false,
      );
      final index = DeviceSearchIndexT0230(
        loader: () {
          loaderCalls += 1;
          return documents;
        },
      );

      // A blank query must remain allocation-light and must not materialise the
      // index at all.
      expect(index.search('   '), isEmpty);
      expect(index.isLoaded, isFalse);
      expect(loaderCalls, 0);

      final initialBuild = Stopwatch()..start();
      final first = index.search('common rare-marker');
      initialBuild.stop();

      expect(first, hasLength(1));
      expect(first.single.documentId, 'synthetic:7319');
      expect(loaderCalls, 1);
      expect(
        initialBuild.elapsed,
        lessThan(const Duration(seconds: 5)),
        reason: '12k device-local documents must index within the CI budget.',
      );

      final repeated = Stopwatch()..start();
      for (var iteration = 0; iteration < 100; iteration += 1) {
        final hits = index.search('common rare-marker', limit: 20);
        expect(hits, hasLength(1));
      }
      repeated.stop();

      expect(loaderCalls, 1);
      expect(
        repeated.elapsed,
        lessThan(const Duration(seconds: 2)),
        reason: 'Repeated searches must reuse the process-local index.',
      );
    });
  });
}
