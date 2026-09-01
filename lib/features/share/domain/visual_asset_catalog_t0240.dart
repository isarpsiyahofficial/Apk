import 'package:islami_hayat/core/content/source_manifest.dart';

class VisualAssetCatalogT0240 {
  VisualAssetCatalogT0240._(this.entries);

  static const requiredFinalAssetCount = 100;

  final List<VisualAssetManifestEntry> entries;

  factory VisualAssetCatalogT0240.finalCatalog(
    Iterable<VisualAssetManifestEntry> candidates,
  ) {
    final entries = List<VisualAssetManifestEntry>.unmodifiable(candidates);

    if (entries.length != requiredFinalAssetCount) {
      throw StateError(
        'T0240 requires exactly $requiredFinalAssetCount final visual assets; '
        'received ${entries.length}.',
      );
    }

    final ids = <String>{};
    final hashes = <String>{};
    for (final entry in entries) {
      if (!entry.canBeFinalReusableBackground) {
        throw StateError(
          'Visual asset ${entry.id} does not satisfy the reusable license gate.',
        );
      }
      if (!ids.add(entry.id)) {
        throw StateError('Duplicate visual asset id: ${entry.id}.');
      }
      if (!hashes.add(entry.sha256.toLowerCase())) {
        throw StateError('Duplicate visual asset SHA-256: ${entry.sha256}.');
      }
      if (entry.licenseEvidenceUrl == null) {
        throw StateError(
          'Visual asset ${entry.id} is missing exact license evidence.',
        );
      }
    }

    return VisualAssetCatalogT0240._(entries);
  }
}