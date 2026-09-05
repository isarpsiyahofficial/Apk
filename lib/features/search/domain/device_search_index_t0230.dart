typedef SearchDocumentLoaderT0230 = List<SearchDocumentT0230> Function();
typedef SearchTextNormalizerT0230 = String Function(String value);

class SearchDocumentT0230 {
  const SearchDocumentT0230({
    required this.id,
    required this.searchableTexts,
  });

  final String id;
  final List<String> searchableTexts;
}

class SearchHitT0230 {
  const SearchHitT0230({
    required this.documentId,
    required this.score,
  });

  final String documentId;
  final int score;
}

/// Device-local inverted search index introduced by T0230.
///
/// No network/API dependency exists in this layer. Documents are loaded lazily
/// on first search/index access and indexed once per process. Locale-specific
/// and Arabic normalization deliberately remains injectable so T0232 can own
/// those semantics without rebuilding the storage contract.
class DeviceSearchIndexT0230 {
  DeviceSearchIndexT0230({
    required SearchDocumentLoaderT0230 loader,
    SearchTextNormalizerT0230 normalizer = basicSearchNormalizerT0230,
  })  : _loader = loader,
        _normalizer = normalizer;

  final SearchDocumentLoaderT0230 _loader;
  final SearchTextNormalizerT0230 _normalizer;

  Map<String, SearchDocumentT0230>? _documentsById;
  Map<String, Set<String>>? _documentIdsByToken;
  Map<String, String>? _normalizedCorpusById;

  bool get isLoaded => _documentsById != null;

  int get documentCount {
    _ensureLoaded();
    return _documentsById!.length;
  }

  SearchDocumentT0230? documentById(String id) {
    final normalizedId = id.trim();
    if (normalizedId.isEmpty) return null;
    _ensureLoaded();
    return _documentsById![normalizedId];
  }

  List<SearchHitT0230> search(String query, {int limit = 20}) {
    if (limit < 1 || limit > 100) {
      throw ArgumentError.value(limit, 'limit', 'must be between 1 and 100');
    }

    final normalizedQuery = _normalizer(query);
    if (normalizedQuery.isEmpty) return const <SearchHitT0230>[];

    final queryTokens = _tokens(normalizedQuery).toSet();
    if (queryTokens.isEmpty) return const <SearchHitT0230>[];

    _ensureLoaded();

    Set<String>? candidateIds;
    for (final token in queryTokens) {
      final ids = _documentIdsByToken![token];
      if (ids == null || ids.isEmpty) {
        return const <SearchHitT0230>[];
      }
      candidateIds = candidateIds == null
          ? Set<String>.of(ids)
          : candidateIds.intersection(ids);
      if (candidateIds.isEmpty) {
        return const <SearchHitT0230>[];
      }
    }

    final hits = <SearchHitT0230>[];
    for (final id in candidateIds!) {
      final corpus = _normalizedCorpusById![id]!;
      var score = queryTokens.length * 10;
      if (corpus.contains(normalizedQuery)) {
        score += 20;
      }
      if (corpus == normalizedQuery) {
        score += 20;
      }
      hits.add(SearchHitT0230(documentId: id, score: score));
    }

    hits.sort((a, b) {
      final scoreCompare = b.score.compareTo(a.score);
      if (scoreCompare != 0) return scoreCompare;
      return a.documentId.compareTo(b.documentId);
    });

    return List<SearchHitT0230>.unmodifiable(hits.take(limit));
  }

  void _ensureLoaded() {
    if (_documentsById != null) return;

    final loaded = List<SearchDocumentT0230>.of(_loader(), growable: false);
    if (loaded.isEmpty) {
      throw StateError('T0230 search loader must not return an empty document set.');
    }

    final documentsById = <String, SearchDocumentT0230>{};
    final documentIdsByToken = <String, Set<String>>{};
    final normalizedCorpusById = <String, String>{};

    for (final document in loaded) {
      final id = document.id.trim();
      if (id.isEmpty || documentsById.containsKey(id)) {
        throw StateError(
          'T0230 search index requires unique non-empty document IDs: ${document.id}',
        );
      }
      if (document.searchableTexts.isEmpty) {
        throw StateError('T0230 search document $id has no searchable text.');
      }

      final normalizedFields = document.searchableTexts
          .map(_normalizer)
          .where((value) => value.isNotEmpty)
          .toList(growable: false);
      if (normalizedFields.isEmpty) {
        throw StateError('T0230 search document $id normalizes to empty text.');
      }

      final corpus = normalizedFields.join(' ');
      final tokens = _tokens(corpus).toSet();
      if (tokens.isEmpty) {
        throw StateError('T0230 search document $id has no indexable token.');
      }

      documentsById[id] = document;
      normalizedCorpusById[id] = corpus;
      for (final token in tokens) {
        documentIdsByToken.putIfAbsent(token, () => <String>{}).add(id);
      }
    }

    _documentsById = Map<String, SearchDocumentT0230>.unmodifiable(documentsById);
    _normalizedCorpusById = Map<String, String>.unmodifiable(normalizedCorpusById);
    _documentIdsByToken = Map<String, Set<String>>.unmodifiable(
      documentIdsByToken.map(
        (token, ids) => MapEntry(token, Set<String>.unmodifiable(ids)),
      ),
    );
  }

  static Iterable<String> _tokens(String normalizedText) sync* {
    for (final token in normalizedText.split(' ')) {
      final trimmed = token.trim();
      if (trimmed.isNotEmpty) yield trimmed;
    }
  }
}

String basicSearchNormalizerT0230(String value) {
  return value
      .trim()
      .toLowerCase()
      .replaceAll(RegExp(r'\s+'), ' ');
}
