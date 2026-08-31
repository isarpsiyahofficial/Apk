import 'package:flutter_test/flutter_test.dart';
import 'package:islami_hayat/core/content/content_governance.dart';
import 'package:islami_hayat/features/search/domain/locale_search_normalizer_t0232.dart';
import 'package:islami_hayat/features/search/domain/search_source_badge_t0233.dart';
import 'package:islami_hayat/features/search/domain/source_aware_universal_search_t0233.dart';
import 'package:islami_hayat/features/search/domain/universal_search_categories_t0231.dart';

void main() {
  group('SearchSourceBadgeT0233', () {
    test('keeps source class and certainty as separate localized labels', () {
      final badge = SearchSourceBadgeT0233(
        sourceClass: ReligiousSourceClass.sahihHasanHadith,
        certainty: CertaintyLevel.stronglyAttested,
        sourceIds: const ['hadith:bukhari:1'],
      );

      expect(badge.sourceLabel(SearchLocaleT0232.tr), 'Sahih-Hasen Sünnet');
      expect(badge.sourceLabel(SearchLocaleT0232.en), 'Sahih-Hasan Sunnah');
      expect(badge.sourceLabel(SearchLocaleT0232.ar), 'السنة الصحيحة أو الحسنة');
      expect(
        badge.reliabilityLabel(SearchLocaleT0232.tr),
        'Güçlü biçimde doğrulanmış',
      );
      expect(badge.isWarning, isFalse);
    });

    test('disputed and unknown provenance remain visible warnings', () {
      final disputed = SearchSourceBadgeT0233(
        sourceClass: ReligiousSourceClass.disputed,
        certainty: CertaintyLevel.disputed,
        sourceIds: const ['source:disputed:1'],
      );
      final unknown = SearchSourceBadgeT0233(
        sourceClass: ReligiousSourceClass.unknown,
        certainty: CertaintyLevel.unknown,
        sourceIds: const ['source:unverified:1'],
      );

      expect(disputed.isWarning, isTrue);
      expect(disputed.sourceLabel(SearchLocaleT0232.tr), 'İhtilaflı kaynak');
      expect(unknown.isWarning, isTrue);
      expect(unknown.sourceLabel(SearchLocaleT0232.en), 'Source unverified');
      expect(unknown.sourceLabel(SearchLocaleT0232.ar), 'المصدر غير موثّق');
    });

    test('rejects missing and duplicate stable source IDs', () {
      expect(
        () => SearchSourceBadgeT0233(
          sourceClass: ReligiousSourceClass.quran,
          certainty: CertaintyLevel.explicitSource,
          sourceIds: const [],
        ),
        throwsStateError,
      );
      expect(
        () => SearchSourceBadgeT0233(
          sourceClass: ReligiousSourceClass.quran,
          certainty: CertaintyLevel.explicitSource,
          sourceIds: const ['quran:tanzil', ' quran:tanzil '],
        ),
        throwsStateError,
      );
    });
  });

  group('SourceAwareUniversalSearchIndexT0233', () {
    test('returns badge metadata on search hits without changing ranking', () {
      final index = SourceAwareUniversalSearchIndexT0233(
        loader: () => [
          SourceAwareSearchDocumentT0233(
            category: UniversalSearchCategoryT0231.verse,
            stableId: '2:286',
            searchableTexts: const ['Allah hiç kimseye gücünün yettiğinden fazlasını yüklemez'],
            sourceBadge: SearchSourceBadgeT0233(
              sourceClass: ReligiousSourceClass.quran,
              certainty: CertaintyLevel.explicitSource,
              sourceIds: const ['quran:tanzil-uthmani-v1.1'],
            ),
          ),
          SourceAwareSearchDocumentT0233(
            category: UniversalSearchCategoryT0231.history,
            stableId: 'battle-badr',
            searchableTexts: const ['Bedir savaşı Medine 624'],
            sourceBadge: SearchSourceBadgeT0233(
              sourceClass: ReligiousSourceClass.earlyIslamicHistoryTafsir,
              certainty: CertaintyLevel.stronglyAttested,
              sourceIds: const ['history:badr:source-1'],
            ),
          ),
        ],
        normalizer: (text) => normalizeSearchTextT0232(
          text,
          locale: SearchLocaleT0232.tr,
        ),
      );

      expect(index.isLoaded, isFalse);
      final result = index.search('Bedir');
      expect(index.isLoaded, isTrue);
      expect(result.totalCount, 1);
      final hit = result.resultsFor(UniversalSearchCategoryT0231.history).single;
      expect(hit.stableId, 'battle-badr');
      expect(
        hit.sourceBadge.sourceLabel(SearchLocaleT0232.tr),
        'Erken İslam tarihi / tefsir',
      );
      expect(
        hit.sourceBadge.reliabilityLabel(SearchLocaleT0232.tr),
        'Güçlü biçimde doğrulanmış',
      );
    });

    test('keeps source-aware index lazy for empty query', () {
      var loads = 0;
      final index = SourceAwareUniversalSearchIndexT0233(
        loader: () {
          loads += 1;
          return [
            SourceAwareSearchDocumentT0233(
              category: UniversalSearchCategoryT0231.dua,
              stableId: 'dua-1',
              searchableTexts: const ['dua'],
              sourceBadge: SearchSourceBadgeT0233(
                sourceClass: ReligiousSourceClass.meaningBasedDua,
                certainty: CertaintyLevel.explicitSource,
                sourceIds: const ['dua:editorial:1'],
              ),
            ),
          ];
        },
      );

      expect(index.search('   ').totalCount, 0);
      expect(loads, 0);
      expect(index.isLoaded, isFalse);
    });

    test('rejects empty datasets and duplicate category/stable IDs', () {
      final empty = SourceAwareUniversalSearchIndexT0233(loader: () => const []);
      expect(() => empty.search('x'), throwsStateError);

      final duplicate = SourceAwareUniversalSearchIndexT0233(
        loader: () => [
          for (var i = 0; i < 2; i++)
            SourceAwareSearchDocumentT0233(
              category: UniversalSearchCategoryT0231.dhikr,
              stableId: 'dhikr-1',
              searchableTexts: const ['subhanallah'],
              sourceBadge: SearchSourceBadgeT0233(
                sourceClass: ReligiousSourceClass.sahihHasanHadith,
                certainty: CertaintyLevel.stronglyAttested,
                sourceIds: ['hadith:$i'],
              ),
            ),
        ],
      );
      expect(() => duplicate.search('subhanallah'), throwsStateError);
    });

    test('does not promote traditional/ebced provenance in search results', () {
      final index = SourceAwareUniversalSearchIndexT0233(
        loader: () => [
          SourceAwareSearchDocumentT0233(
            category: UniversalSearchCategoryT0231.asma,
            stableId: 'ar-razzaq',
            searchableTexts: const ['Er-Rezzak rızık'],
            sourceBadge: SearchSourceBadgeT0233(
              sourceClass: ReligiousSourceClass.ebcedHavasTradition,
              certainty: CertaintyLevel.traditional,
              sourceIds: const ['tradition:abjad:razzaq'],
            ),
          ),
        ],
      );

      final badge = index
          .search('rezzak')
          .resultsFor(UniversalSearchCategoryT0231.asma)
          .single
          .sourceBadge;
      expect(badge.sourceLabel(SearchLocaleT0232.tr), 'Ebced-Havas geleneği');
      expect(badge.reliabilityLabel(SearchLocaleT0232.tr), 'Geleneksel aktarım');
      expect(badge.sourceClass, ReligiousSourceClass.ebcedHavasTradition);
      expect(badge.certainty, CertaintyLevel.traditional);
    });
  });
}
