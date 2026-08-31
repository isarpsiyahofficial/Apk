import 'package:flutter_test/flutter_test.dart';
import 'package:islami_hayat/features/search/domain/locale_search_normalizer_t0232.dart';
import 'package:islami_hayat/features/search/domain/universal_search_categories_t0231.dart';

void main() {
  group('normalizeSearchTextT0232', () {
    test('uses Turkish dotted and dotless I casing correctly', () {
      expect(
        normalizeSearchTextT0232('İSLAM IŞIK', locale: SearchLocaleT0232.tr),
        'islam ışık',
      );
      expect(
        normalizeSearchTextT0232('ISLAM', locale: SearchLocaleT0232.en),
        'islam',
      );
    });

    test('removes Arabic harakat and tatweel only in search form', () {
      const canonical = 'الرَّحْمَٰنُ';
      final normalized = normalizeSearchTextT0232(
        canonical,
        locale: SearchLocaleT0232.ar,
      );

      expect(normalized, 'الرحمن');
      expect(canonical, 'الرَّحْمَٰنُ');
    });

    test('normalizes common Arabic alif and hamza-seat variants', () {
      expect(
        normalizeSearchTextT0232('إِيمَان', locale: SearchLocaleT0232.ar),
        'ايمان',
      );
      expect(
        normalizeSearchTextT0232('آدَم', locale: SearchLocaleT0232.ar),
        'ادم',
      );
      expect(
        normalizeSearchTextT0232('مُؤْمِن', locale: SearchLocaleT0232.ar),
        'مومن',
      );
      expect(
        normalizeSearchTextT0232('شَيْء', locale: SearchLocaleT0232.ar),
        'شيء',
      );
    });

    test('normalizes punctuation to token boundaries', () {
      expect(
        normalizeSearchTextT0232(
          'Bedir—Medine, 624!',
          locale: SearchLocaleT0232.tr,
        ),
        'bedir—medine 624',
      );
      expect(
        normalizeSearchTextT0232(
          'مكة،المدينة؟',
          locale: SearchLocaleT0232.ar,
        ),
        'مكة المدينة',
      );
    });

    test('blank input stays blank', () {
      for (final locale in SearchLocaleT0232.values) {
        expect(normalizeSearchTextT0232('   ', locale: locale), '');
      }
    });
  });

  group('T0232 integration with T0231/T0230', () {
    test('unvocalized Arabic query matches vocalized indexed text', () {
      final index = UniversalSearchIndexT0231(
        normalizer: localeAwareSearchNormalizerT0232(SearchLocaleT0232.ar),
        loader: () => const [
          UniversalSearchDocumentT0231(
            category: UniversalSearchCategoryT0231.asma,
            stableId: 'ar-rahman',
            searchableTexts: ['الرَّحْمَٰنُ'],
          ),
        ],
      );

      final results = index.search('الرحمن');
      expect(results.totalCount, 1);
      expect(
        results.resultsFor(UniversalSearchCategoryT0231.asma).single.stableId,
        'ar-rahman',
      );
    });

    test('Arabic alif variant query and indexed form resolve identically', () {
      final index = UniversalSearchIndexT0231(
        normalizer: localeAwareSearchNormalizerT0232(SearchLocaleT0232.ar),
        loader: () => const [
          UniversalSearchDocumentT0231(
            category: UniversalSearchCategoryT0231.prophet,
            stableId: 'adam',
            searchableTexts: ['آدَم'],
          ),
        ],
      );

      expect(index.search('ادم').totalCount, 1);
      expect(index.search('آدم').totalCount, 1);
    });

    test('Turkish locale matches dotted/dotless-I without English leakage', () {
      final index = UniversalSearchIndexT0231(
        normalizer: localeAwareSearchNormalizerT0232(SearchLocaleT0232.tr),
        loader: () => const [
          UniversalSearchDocumentT0231(
            category: UniversalSearchCategoryT0231.history,
            stableId: 'islam-history',
            searchableTexts: ['İSLAM TARİHİ', 'IŞIK'],
          ),
        ],
      );

      expect(index.search('islam tarihi').totalCount, 1);
      expect(index.search('ışık').totalCount, 1);
      expect(index.search('isik').totalCount, 0);
    });
  });
}
