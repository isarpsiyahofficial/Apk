import 'device_search_index_t0230.dart';

typedef UniversalSearchDocumentLoaderT0231 =
    List<UniversalSearchDocumentT0231> Function();

enum UniversalSearchCategoryT0231 {
  verse('verse'),
  dua('dua'),
  dhikr('dhikr'),
  asma('asma'),
  prophet('prophet'),
  history('history'),
  person('person'),
  religiousDay('religious-day');

  const UniversalSearchCategoryT0231(this.stableKey);

  final String stableKey;
}

class UniversalSearchDocumentT0231 {
  const UniversalSearchDocumentT0231({
    required this.category,
    required this.stableId,
    required this.searchableTexts,
  });

  final UniversalSearchCategoryT0231 category;
  final String stableId;
  final List<String> searchableTexts;
}

class UniversalSearchHitT0231 {
  const UniversalSearchHitT0231({
    required this.category,
    required this.stableId,
    required this.score,
  });

  final UniversalSearchCategoryT0231 category;
  final String stableId;
  final int score;
}

class CategorizedSearchResultsT0231 {
  CategorizedSearchResultsT0231._(this.byCategory);

  final Map<UniversalSearchCategoryT0231, List<UniversalSearchHitT0231>>
      byCategory;

  int get totalCount => byCategory.values.fold<int>(
        0,
        (sum, hits) => sum + hits.length,
      );

  List<UniversalSearchCategoryT0231> get nonEmptyCategories =>
      UniversalSearchCategoryT0231.values
          .where((category) => byCategory[category]!.isNotEmpty)
          .toList(growable: false);

  List<UniversalSearchHitT0231> resultsFor(
    UniversalSearchCategoryT0231 category,
  ) => byCategory[category]!;

  static CategorizedSearchResultsT0231 empty() {
    return CategorizedSearchResultsT0231._(
      Map<UniversalSearchCategoryT0231, List<UniversalSearchHitT0231>>.unmodifiable(
        {
          for (final category in UniversalSearchCategoryT0231.values)
            category: const <UniversalSearchHitT0231>[],
        },
      ),
    );
  }
}

/// T0231 universal-search categorization layer.
///
/// The underlying token index remains the device-local T0230 index. T0231 adds
/// a typed, stable category contract for the eight product result families
/// required by SPEC 71 without introducing network search or fuzzy identity
/// matching. Locale/Arabic normalization stays delegated to T0232 through the
/// injected T0230 normalizer.
class UniversalSearchIndexT0231 {
  UniversalSearchIndexT0231({
    required UniversalSearchDocumentLoaderT0231 loader,
    SearchTextNormalizerT0230 normalizer = basicSearchNormalizerT0230,
  }) : _loader = loader {
    _index = DeviceSearchIndexT0230(
      loader: _loadIntoDeviceIndex,
      normalizer: normalizer,
    );
  }

  final UniversalSearchDocumentLoaderT0231 _loader;
  late final DeviceSearchIndexT0230 _index;

  Map<String, UniversalSearchDocumentT0231>? _metadataByIndexId;

  bool get isLoaded => _index.isLoaded;

  int get documentCount => _index.documentCount;

  CategorizedSearchResultsT0231 search(String query, {int limit = 50}) {
    if (limit < 1 || limit > 100) {
      throw ArgumentError.value(limit, 'limit', 'must be between 1 and 100');
    }

    final hits = _index.search(query, limit: limit);
    if (hits.isEmpty) return CategorizedSearchResultsT0231.empty();

    final grouped = <UniversalSearchCategoryT0231, List<UniversalSearchHitT0231>>{
      for (final category in UniversalSearchCategoryT0231.values)
        category: <UniversalSearchHitT0231>[],
    };

    for (final hit in hits) {
      final metadata = _metadataByIndexId![hit.documentId];
      if (metadata == null) {
        throw StateError(
          'T0231 index hit has no category metadata: ${hit.documentId}',
        );
      }
      grouped[metadata.category]!.add(
        UniversalSearchHitT0231(
          category: metadata.category,
          stableId: metadata.stableId,
          score: hit.score,
        ),
      );
    }

    return CategorizedSearchResultsT0231._(
      Map<UniversalSearchCategoryT0231, List<UniversalSearchHitT0231>>.unmodifiable(
        grouped.map(
          (category, values) => MapEntry(
            category,
            List<UniversalSearchHitT0231>.unmodifiable(values),
          ),
        ),
      ),
    );
  }

  UniversalSearchDocumentT0231? documentById(
    UniversalSearchCategoryT0231 category,
    String stableId,
  ) {
    final normalizedId = stableId.trim();
    if (normalizedId.isEmpty) return null;
    final indexId = _indexId(category, normalizedId);
    final document = _index.documentById(indexId);
    if (document == null) return null;
    return _metadataByIndexId![indexId];
  }

  List<SearchDocumentT0230> _loadIntoDeviceIndex() {
    final loaded = List<UniversalSearchDocumentT0231>.of(
      _loader(),
      growable: false,
    );
    if (loaded.isEmpty) {
      throw StateError('T0231 universal search loader must not be empty.');
    }

    final metadataByIndexId = <String, UniversalSearchDocumentT0231>{};
    final searchDocuments = <SearchDocumentT0230>[];

    for (final document in loaded) {
      final stableId = document.stableId.trim();
      if (stableId.isEmpty) {
        throw StateError('T0231 universal search requires non-empty stable IDs.');
      }
      if (document.searchableTexts.isEmpty) {
        throw StateError(
          'T0231 ${document.category.stableKey}:$stableId has no searchable text.',
        );
      }

      final indexId = _indexId(document.category, stableId);
      if (metadataByIndexId.containsKey(indexId)) {
        throw StateError('T0231 duplicate category/stable ID: $indexId');
      }

      metadataByIndexId[indexId] = UniversalSearchDocumentT0231(
        category: document.category,
        stableId: stableId,
        searchableTexts: List<String>.unmodifiable(document.searchableTexts),
      );
      searchDocuments.add(
        SearchDocumentT0230(
          id: indexId,
          searchableTexts: document.searchableTexts,
        ),
      );
    }

    _metadataByIndexId =
        Map<String, UniversalSearchDocumentT0231>.unmodifiable(metadataByIndexId);
    return List<SearchDocumentT0230>.unmodifiable(searchDocuments);
  }

  static String _indexId(
    UniversalSearchCategoryT0231 category,
    String stableId,
  ) => '${category.stableKey}:$stableId';
}
