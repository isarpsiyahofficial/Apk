import '../content/content_integrity.dart';
import 'storage_boundaries.dart';

abstract interface class TrustedContentLoader {
  Future<String?> load(String datasetId);
}

/// Read-only trusted content adapter that verifies every bundled dataset before
/// returning it to presentation code.
///
/// Missing manifest entries and hash mismatches fail closed. This prevents a
/// corrupted Qur'an/meal/dua/history/prophet dataset from being rendered as if
/// it were reviewed production content.
final class IntegrityCheckedTrustedContentStore implements TrustedContentStore {
  IntegrityCheckedTrustedContentStore({
    required TrustedContentLoader loader,
    required Map<String, String> expectedSha256ByDataset,
  })  : _loader = loader,
        _expectedSha256ByDataset = Map.unmodifiable(expectedSha256ByDataset);

  final TrustedContentLoader _loader;
  final Map<String, String> _expectedSha256ByDataset;

  @override
  StorageDomain get domain => StorageDomain.trustedContent;

  @override
  Future<String?> read(String key) async {
    final datasetId = key.trim();
    if (datasetId.isEmpty) {
      throw ArgumentError.value(key, 'key', 'Dataset id cannot be empty.');
    }

    final expectedSha256 = _expectedSha256ByDataset[datasetId];
    if (expectedSha256 == null) {
      throw MissingContentManifestException(datasetId);
    }

    final content = await _loader.load(datasetId);
    if (content == null) {
      return null;
    }

    ContentIntegrity.requireValidSha256(
      datasetId: datasetId,
      content: content,
      expectedSha256: expectedSha256,
    );
    return content;
  }
}

final class MissingContentManifestException implements Exception {
  const MissingContentManifestException(this.datasetId);

  final String datasetId;

  @override
  String toString() =>
      'MissingContentManifestException: trusted dataset "$datasetId" has no release SHA-256 manifest entry.';
}
