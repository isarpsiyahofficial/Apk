import 'dua_content.dart';

/// Read-only, device-local view over production-approved dua content.
///
/// The repository never invents, translates or rewrites religious text. It
/// rejects the whole supplied dataset if any record has not passed the
/// production gates in [DuaContent]. This keeps search/filter results from
/// accidentally surfacing research or partially reviewed material.
final class DuaLibraryRepository {
  DuaLibraryRepository(Iterable<DuaContent> records)
      : _records = List<DuaContent>.unmodifiable(_validate(records));

  final List<DuaContent> _records;

  List<DuaContent> get all => _records;

  List<DuaContent> byCategory(DuaCategory category) =>
      List<DuaContent>.unmodifiable(
        _records.where((record) => record.categories.contains(category)),
      );

  List<DuaContent> search({
    required String query,
    required String languageCode,
    DuaCategory? category,
  }) {
    final normalizedQuery = _normalize(query, languageCode);
    final candidates = category == null ? _records : byCategory(category);

    if (normalizedQuery.isEmpty) {
      return List<DuaContent>.unmodifiable(candidates);
    }

    return List<DuaContent>.unmodifiable(
      candidates.where((record) {
        final localizedText = switch (languageCode) {
          'tr' => record.text.tr,
          'en' => record.text.en,
          'ar' => record.text.ar,
          _ => throw UnsupportedError(
              'Unsupported dua search locale: $languageCode',
            ),
        };
        return _normalize(localizedText, languageCode).contains(normalizedQuery);
      }),
    );
  }

  DuaContent? byId(String id) {
    for (final record in _records) {
      if (record.id == id) return record;
    }
    return null;
  }

  static List<DuaContent> _validate(Iterable<DuaContent> records) {
    final result = <DuaContent>[];
    final ids = <String>{};

    for (final record in records) {
      if (!record.canEnterProductionDataset) {
        throw StateError(
          'Dua library rejected non-production content: ${record.id}',
        );
      }
      if (!ids.add(record.id)) {
        throw StateError('Dua library rejected duplicate id: ${record.id}');
      }
      result.add(record);
    }

    return result;
  }

  static String _normalize(String value, String languageCode) {
    var normalized = value.trim().toLowerCase();

    if (languageCode == 'ar') {
      // Search-only normalization. Source text itself is never mutated.
      normalized = normalized
          .replaceAll('\u0640', '')
          .replaceAll(RegExp(r'[\u064B-\u065F\u0670]'), '')
          .replaceAll(RegExp(r'[أإآٱ]'), 'ا');
    }

    return normalized.replaceAll(RegExp(r'\s+'), ' ');
  }
}
