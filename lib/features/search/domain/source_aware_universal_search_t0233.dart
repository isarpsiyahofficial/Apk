import 'device_search_index_t0230.dart';
import 'search_source_badge_t0233.dart';
import 'universal_search_categories_t0231.dart';

typedef SourceAwareSearchDocumentLoaderT0233 =
    List<SourceAwareSearchDocumentT0233> Function();

class SourceAwareSearchDocumentT0233 {
  const SourceAwareSearchDocumentT0233({
    required this.category,
    required this.stableId,
    required this.searchableTexts,
    required this.sourceBadge,
  });

  final UniversalSearchCategoryT0231 category;
  final String stableId;
  final List<String> searchableTexts;
  final SearchSourceBadgeT0233 sourceBadge;
}

class SourceAwareSearchHitT0233 {
  const SourceAwareSearchHitT0233({
    required this.category,
    required this.stableId,
    required this.score,
    required this.sourceBadge,
  });

  final UniversalSearchCategoryT0231 category;
  final String stableId;
  final int score;
  final SearchSourceBadgeT0233 sourceBadge;
}

class SourceAwareCategorizedResultsT0233 {
  const SourceAwareCategorizedResultsT0233(this.byCategory);

  final Map<UniversalSearchCategoryT0231, List<SourceAwareSearchHitT0233>>
      byCategory;

  int get totalCount => byCategory.values.fold<int>(
        0,
        (sum, hits) => sum + hits.length,
      );

  List<SourceAwareSearchHitT0233> resultsFor(
    UniversalSearchCategoryT0231 category,
  ) => byCategory[category] ?? const <SourceAwareSearchHitT0233>[];
}

/// T0233 adds mandatory source/reliability metadata to T0231 search hits.
///
/// This layer is intentionally fail-closed: every indexed religious/search
/// result must carry a badge backed by at least one stable source ID. Search
/// ranking never changes provenance or certainty.
class SourceAwareUniversalSearchIndexT0233 {
  SourceAwareUniversalSearchIndexT0233({
    required SourceAwareSearchDocumentLoaderT0233 loader,
    SearchTextNormalizerT0230 normalizer = basicSearchNormalizerT0230,
  }) : _loader = loader {
    _index = UniversalSearchIndexT0231(
      loader: _loadIntoUniversalIndex,
      normalizer: normalizer,
    );
  }

  final SourceAwareSearchDocumentLoaderT0233 _loader;
  late final UniversalSearchIndexT0231 _index;

  Map<String, SearchSourceBadgeT0233>? _badgeByCompositeId;

  bool get isLoaded => _index.isLoaded;

  SourceAwareCategorizedResultsT0233 search(
    String query, {
    int limit = 50,
  }) {
    final results = _index.search(query, limit: limit);
    if (results.totalCount == 0) {
      return SourceAwareCategorizedResultsT0233(
        Map<UniversalSearchCategoryT0231, List<SourceAwareSearchHitT0233>>.unmodifiable(
          {
            for (final category in UniversalSearchCategoryT0231.values)
              category: const <SourceAwareSearchHitT0233>[],
          },
        ),
      );
    }

    final grouped = <UniversalSearchCategoryT0231, List<SourceAwareSearchHitT0233>>{
      for (final category in UniversalSearchCategoryT0231.values)
        category: <SourceAwareSearchHitT0233>[],
    };

    for (final category in UniversalSearchCategoryT0231.values) {
      for (final hit in results.resultsFor(category)) {
        final compositeId = _compositeId(category, hit.stableId);
        final badge = _badgeByCompositeId?[compositeId];
        if (badge == null) {
          throw StateError('T0233 search hit has no source badge: $compositeId');
        }
        grouped[category]!.add(
          SourceAwareSearchHitT0233(
            category: category,
            stableId: hit.stableId,
            score: hit.score,
            sourceBadge: badge,
          ),
        );
      }
    }

    return SourceAwareCategorizedResultsT0233(
      Map<UniversalSearchCategoryT0231, List<SourceAwareSearchHitT0233>>.unmodifiable(
        grouped.map(
          (category, hits) => MapEntry(
            category,
            List<SourceAwareSearchHitT0233>.unmodifiable(hits),
          ),
        ),
      ),
    );
  }

  List<UniversalSearchDocumentT0231> _loadIntoUniversalIndex() {
    final loaded = List<SourceAwareSearchDocumentT0233>.of(
      _loader(),
      growable: false,
    );
    if (loaded.isEmpty) {
      throw StateError('T0233 source-aware search loader must not be empty.');
    }

    final badges = <String, SearchSourceBadgeT0233>{};
    final documents = <UniversalSearchDocumentT0231>[];
    for (final document in loaded) {
      final stableId = document.stableId.trim();
      if (stableId.isEmpty) {
        throw StateError('T0233 source-aware search requires a stable ID.');
      }
      final compositeId = _compositeId(document.category, stableId);
      if (badges.containsKey(compositeId)) {
        throw StateError('T0233 duplicate category/stable ID: $compositeId');
      }
      badges[compositeId] = document.sourceBadge;
      documents.add(
        UniversalSearchDocumentT0231(
          category: document.category,
          stableId: stableId,
          searchableTexts: document.searchableTexts,
        ),
      );
    }

    _badgeByCompositeId = Map<String, SearchSourceBadgeT0233>.unmodifiable(badges);
    return List<UniversalSearchDocumentT0231>.unmodifiable(documents);
  }

  static String _compositeId(
    UniversalSearchCategoryT0231 category,
    String stableId,
  ) => '${category.stableKey}:${stableId.trim()}';
}
