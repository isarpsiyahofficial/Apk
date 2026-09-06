import 'package:flutter_test/flutter_test.dart';
import 'package:islami_hayat/features/search/domain/device_search_index_t0230.dart';

void main() {
  group('DeviceSearchIndexT0230', () {
    const documents = <SearchDocumentT0230>[
      SearchDocumentT0230(
        id: 'history:badir',
        searchableTexts: ['Bedir Gazvesi', 'Medine', '624'],
      ),
      SearchDocumentT0230(
        id: 'prophet:muhammad',
        searchableTexts: ['Muhammed', 'Hz. Muhammed', 'Mekke Medine'],
      ),
      SearchDocumentT0230(
        id: 'dua:travel',
        searchableTexts: ['Yolculuk duası', 'travel prayer'],
      ),
    ];

    test('is lazy, device-local and loads source documents only once', () {
      var loaderCalls = 0;
      final index = DeviceSearchIndexT0230(
        loader: () {
          loaderCalls += 1;
          return documents;
        },
      );

      expect(index.isLoaded, isFalse);
      expect(loaderCalls, 0);

      expect(index.search('medine'), isNotEmpty);
      expect(index.isLoaded, isTrue);
      expect(loaderCalls, 1);

      index.search('dua');
      index.documentById('history:badir');
      expect(loaderCalls, 1);
    });

    test('AND token lookup is deterministic and does not invent partial matches', () {
      final index = DeviceSearchIndexT0230(loader: () => documents);

      final hit = index.search('mekke medine');
      expect(hit, hasLength(1));
      expect(hit.single.documentId, 'prophet:muhammad');

      expect(index.search('mekke yolculuk'), isEmpty);
      expect(index.search('does-not-exist'), isEmpty);
    });

    test('exact phrase receives a higher score than token-only match', () {
      final index = DeviceSearchIndexT0230(
        loader: () => const [
          SearchDocumentT0230(id: 'a', searchableTexts: ['mekke medine']),
          SearchDocumentT0230(id: 'b', searchableTexts: ['mekke tarih medine']),
        ],
      );

      final hits = index.search('mekke medine');
      expect(hits, hasLength(2));
      expect(hits.first.documentId, 'a');
      expect(hits.first.score, greaterThan(hits.last.score));
    });

    test('blank query returns empty without forcing dataset load', () {
      var loaderCalls = 0;
      final index = DeviceSearchIndexT0230(
        loader: () {
          loaderCalls += 1;
          return documents;
        },
      );

      expect(index.search('   '), isEmpty);
      expect(loaderCalls, 0);
      expect(index.isLoaded, isFalse);
    });

    test('invalid limits fail closed', () {
      final index = DeviceSearchIndexT0230(loader: () => documents);
      expect(() => index.search('dua', limit: 0), throwsArgumentError);
      expect(() => index.search('dua', limit: 101), throwsArgumentError);
    });

    test('duplicate, blank and textless documents fail closed', () {
      final duplicate = DeviceSearchIndexT0230(
        loader: () => const [
          SearchDocumentT0230(id: 'same', searchableTexts: ['one']),
          SearchDocumentT0230(id: 'same', searchableTexts: ['two']),
        ],
      );
      expect(() => duplicate.search('one'), throwsStateError);

      final blankId = DeviceSearchIndexT0230(
        loader: () => const [
          SearchDocumentT0230(id: ' ', searchableTexts: ['one']),
        ],
      );
      expect(() => blankId.search('one'), throwsStateError);

      final noText = DeviceSearchIndexT0230(
        loader: () => const [
          SearchDocumentT0230(id: 'empty', searchableTexts: []),
        ],
      );
      expect(() => noText.search('one'), throwsStateError);

      final normalizedEmpty = DeviceSearchIndexT0230(
        loader: () => const [
          SearchDocumentT0230(id: 'empty-text', searchableTexts: ['   ']),
        ],
      );
      expect(() => normalizedEmpty.search('one'), throwsStateError);
    });

    test('empty source dataset fails closed on first real access', () {
      final index = DeviceSearchIndexT0230(loader: () => const []);
      expect(() => index.search('anything'), throwsStateError);
    });

    test('normalization is injectable for the future T0232 locale layer', () {
      final index = DeviceSearchIndexT0230(
        loader: () => const [
          SearchDocumentT0230(id: 'arabic', searchableTexts: ['إسلام']),
        ],
        normalizer: (value) => value
            .trim()
            .replaceAll('إ', 'ا')
            .replaceAll(RegExp(r'\s+'), ' '),
      );

      expect(index.search('اسلام').single.documentId, 'arabic');
    });

    test('document lookup requires an exact stable ID', () {
      final index = DeviceSearchIndexT0230(loader: () => documents);

      expect(index.documentById('history:badir')?.id, 'history:badir');
      expect(index.documentById('history:badi'), isNull);
      expect(index.documentById(''), isNull);
    });
  });
}
