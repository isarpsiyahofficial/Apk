import 'package:islami_hayat/core/content/source_manifest.dart';

class VisualAssetCatalogT0240 {
  VisualAssetCatalogT0240._(this.entries);

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
    final localPaths = <String>{};
    final canvaSources = <String>{};
    for (final entry in entries) {
      if (!entry.canBeFinalReusableBackground) {
        throw StateError(
          'Visual asset ${entry.id} does not satisfy the reusable license gate.',
        );
      }
      if (!_canonicalIds.contains(entry.id)) {
        throw StateError('Unexpected T0240 visual asset id: ${entry.id}.');
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
      if (!_isExactCanvaSource(entry.sourceUrl)) {
        throw StateError(
          'Visual asset ${entry.id} is missing an exact HTTPS Canva source.',
        );
      }
      if (!canvaSources.add(entry.sourceUrl.toString())) {
        throw StateError('Duplicate Canva source: ${entry.sourceUrl}.');
      }

      final localAssetPath = entry.localAssetPath;
      if (localAssetPath == null || !_isSafeBundledBackground(localAssetPath)) {
        throw StateError(
          'Visual asset ${entry.id} is not bound to a safe local background asset.',
        );
      }
      if (!localPaths.add(localAssetPath)) {
        throw StateError('Duplicate local visual asset path: $localAssetPath.');
      }
    }

    if (!ids.containsAll(_canonicalIds)) {
      throw StateError('T0240 canonical Canva asset inventory is incomplete.');
    }

    return VisualAssetCatalogT0240._(entries);
  }

  static const requiredFinalAssetCount = 100;
  static const _localAssetPrefix = 'assets/share/backgrounds/';
  static final Set<String> _canonicalIds = Set<String>.unmodifiable(
    List<String>.generate(
      requiredFinalAssetCount,
      (index) => 'Canva-${(index + 1).toString().padLeft(3, '0')}',
    ),
  );

  final List<VisualAssetManifestEntry> entries;

  static bool _isExactCanvaSource(Uri uri) {
    final host = uri.host.toLowerCase();
    return uri.scheme == 'https' &&
        (host == 'canva.com' || host == 'www.canva.com') &&
        uri.pathSegments.isNotEmpty;
  }

  static bool _isSafeBundledBackground(String path) {
    if (!path.startsWith(_localAssetPrefix) ||
        path.contains('..') ||
        path.contains('://') ||
        path.startsWith('/')) {
      return false;
    }
    final relative = path.substring(_localAssetPrefix.length);
    if (relative.isEmpty || relative.contains('/')) {
      return false;
    }
    final lower = relative.toLowerCase();
    return lower.endsWith('.png') ||
        lower.endsWith('.jpg') ||
        lower.endsWith('.jpeg') ||
        lower.endsWith('.webp');
  }
}
