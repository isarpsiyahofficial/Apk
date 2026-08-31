import 'package:flutter_test/flutter_test.dart';
import 'package:islami_hayat/features/search/domain/universal_search_categories_t0231.dart';

void main() {
  group('UniversalSearchIndexT0231', () {
    const documents = <UniversalSearchDocumentT0231>[
      UniversalSearchDocumentT0231(
        category: UniversalSearchCategoryT0231.verse,
        stableId: '2:255',
        searchableTexts: ['Ayetel Kürsi', 'Bakara 255', 'Allah'],
      ),
      UniversalSearchDocumentT0231(
        category: UniversalSearchCategoryT0231.dua,
        stableId: 'travel',
        searchableTexts: ['Yolculuk duası', 'Allah yolculuk'],
      ),
      UniversalSearchDocumentT0231(
        category: UniversalSearchCategoryT0231.dhikr,
        stableId: 'subhanallah',
        searchableTexts: ['Sübhanallah', 'Allah tesbih'],
      ),
      UniversalSearchDocumentT0231(
        category: UniversalSearchCategoryT0231.asma,
        stableId: 'ar-rahman',
        searchableTexts: ['Er-Rahman', 'Rahman Allah'],
      ),
      UniversalSearchDocumentT0231(
        category: UniversalSearchCategoryT0231.prophet,
        stableId: 'muhammad',
        searchableTexts: ['Hz. Muhammed', 'Muhammed peygamber'],
      ),
      UniversalSearchDocumentT0231(
        category: UniversalSearchCategoryT0231.history,
        stableId: 'badir',
        searchableTexts: ['Bedir Gazvesi', 'Medine 624'],
      ),
      UniversalSearchDocumentT0231(
        category: UniversalSearchCategoryT0231.person,
        stableId: 'ibn-sina',
        searchableTexts: ['İbn Sina', 'hekim bilim'],
      ),
      UniversalSearchDocumentT0231(
        category: UniversalSearchCategoryT0231.religiousDay,
        stableId: 'laylat-al-qadr',
        searchableTexts: ['Kadir Gecesi', 'Ramazan gece'],
      ),
    ];

    test('covers exactly the eight SPEC 71 result families', () {
      expect(
        UniversalSearchCategoryT0231.values.map((value) => value.stableKey),
        orderedEquals(const [
          'verse',
          'dua',
          'dhikr',
          'asma',
          'prophet',
          'history',
          'person',
          'religious-day',
        ]),
      );
    });

    test('is lazy and categorizes one universal query deterministically', () {
      var loaderCalls = 0;
      final index = UniversalSearchIndexT0231(
        loader: () {
          loaderCalls += 1;
          return documents;
        },
      );

      expect(index.isLoaded, isFalse);
      expect(loaderCalls, 0);

      final results = index.search('Allah');

      expect(index.isLoaded, isTrue);
      expect(loaderCalls, 1);
      expect(results.totalCount, 4);
      expect(
        results.nonEmptyCategories,
        orderedEquals(const [
          UniversalSearchCategoryT0231.verse,
          UniversalSearchCategoryT0231.dua,
          UniversalSearchCategoryT0231.dhikr,
          UniversalSearchCategoryT0231.asma,
        ]),
      );
      expect(results.resultsFor(UniversalSearchCategoryT0231.history), isEmpty);

      index.search('medine');
      expect(loaderCalls, 1);
    });

    test('returns stable typed IDs without exposing internal composite IDs', () {
      final index = UniversalSearchIndexT0231(loader: () => documents);

      final results = index.search('İbn Sina');
      final hit = results.resultsFor(UniversalSearchCategoryT0231.person).single;

      expect(hit.category, UniversalSearchCategoryT0231.person);
      expect(hit.stableId, 'ibn-sina');
      expect(hit.stableId, isNot(contains('person:')));
    });

    test('same stable ID may exist in different categories without collision', () {
      final index = UniversalSearchIndexT0231(
        loader: () => const [
          UniversalSearchDocumentT0231(
            category: UniversalSearchCategoryT0231.prophet,
            stableId: 'muhammad',
            searchableTexts: ['Muhammed'],
          ),
          UniversalSearchDocumentT0231(
            category: UniversalSearchCategoryT0231.person,
            stableId: 'muhammad',
            searchableTexts: ['Muhammed kişi'],
          ),
        ],
      );

      final results = index.search('Muhammed');
      expect(results.totalCount, 2);
      expect(
        results.resultsFor(UniversalSearchCategoryT0231.prophet).single.stableId,
        'muhammad',
      );
      expect(
        results.resultsFor(UniversalSearchCategoryT0231.person).single.stableId,
        'muhammad',
      );
    });

    test('blank query remains lazy and returns all categories as empty', () {
      var loaderCalls = 0;
      final index = UniversalSearchIndexT0231(
        loader: () {
          loaderCalls += 1;
          return documents;
        },
      );

      final results = index.search('   ');
      expect(results.totalCount, 0);
      expect(results.nonEmptyCategories, isEmpty);
      expect(loaderCalls, 0);
      expect(index.isLoaded, isFalse);
      for (final category in UniversalSearchCategoryT0231.values) {
        expect(results.resultsFor(category), isEmpty);
      }
    });

    test('exact typed lookup is category-safe', () {
      final index = UniversalSearchIndexT0231(loader: () => documents);

      expect(
        index.documentById(UniversalSearchCategoryT0231.history, 'badir')?.stableId,
        'badir',
      );
      expect(
        index.documentById(UniversalSearchCategoryT0231.dua, 'badir'),
        isNull,
      );
      expect(
        index.documentById(UniversalSearchCategoryT0231.history, '   '),
        isNull,
      );
    });

    test('rejects duplicate IDs inside one category', () {
      final index = UniversalSearchIndexT0231(
        loader: () => const [
          UniversalSearchDocumentT0231(
            category: UniversalSearchCategoryT0231.dua,
            stableId: 'travel',
            searchableTexts: ['one'],
          ),
          UniversalSearchDocumentT0231(
            category: UniversalSearchCategoryT0231.dua,
            stableId: 'travel',
            searchableTexts: ['two'],
          ),
        ],
      );

      expect(() => index.search('one'), throwsStateError);
    });

    test('rejects empty datasets, IDs and searchable fields fail-closed', () {
      expect(
        () => UniversalSearchIndexT0231(loader: () => const []).documentCount,
        throwsStateError,
      );
      expect(
        () => UniversalSearchIndexT0231(
          loader: () => const [
            UniversalSearchDocumentT0231(
              category: UniversalSearchCategoryT0231.verse,
              stableId: ' ',
              searchableTexts: ['text'],
            ),
          ],
        ).documentCount,
        throwsStateError,
      );
      expect(
        () => UniversalSearchIndexT0231(
          loader: () => const [
            UniversalSearchDocumentT0231(
              category: UniversalSearchCategoryT0231.verse,
              stableId: '2:255',
              searchableTexts: [],
            ),
          ],
        ).documentCount,
        throwsStateError,
      );
    });

    test('enforces bounded universal result limit', () {
      final index = UniversalSearchIndexT0231(loader: () => documents);

      expect(() => index.search('allah', limit: 0), throwsArgumentError);
      expect(() => index.search('allah', limit: 101), throwsArgumentError);
      expect(index.search('allah', limit: 2).totalCount, 2);
    });
  });
}
