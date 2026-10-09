import '../data/prophet_deep_links.dart';

/// T0202 relationship-level authorization for prophet cross-module deep links.
///
/// A syntactically valid destination is not enough: the exact target must be
/// declared by the reviewed bundle for the same prophet. This prevents a valid
/// dua, verse, history event or map target belonging to one prophet from being
/// rebound to another prophet by changing only the `prophet` query parameter.
final class ProphetDeepLinkAuthorization {
  ProphetDeepLinkAuthorization(Iterable<ProphetDeepLinkBundle> bundles)
      : _bundles = {
          for (final bundle in bundles) bundle.prophetId: bundle,
        } {
    if (_bundles.length != bundles.length) {
      throw StateError('Duplicate prophet deep-link authorization bundle.');
    }
    for (final bundle in _bundles.values) {
      final issues = bundle.audit();
      if (issues.isNotEmpty) {
        throw StateError(
          'Invalid prophet deep-link authorization bundle: ${issues.join(', ')}',
        );
      }
    }
  }

  final Map<String, ProphetDeepLinkBundle> _bundles;

  bool authorizes(ProphetDeepLink link) {
    if (!link.isValid) return false;
    final bundle = _bundles[link.prophetId];
    if (bundle == null) return false;

    return switch (link.kind) {
      ProphetDeepLinkKind.quranVerse => bundle.quranReferences.any(
          (reference) =>
              reference.stableId == link.targetId &&
              reference.surah == link.surah &&
              reference.ayah == link.ayah,
        ),
      ProphetDeepLinkKind.dua => bundle.duaReferences.any(
          (reference) => reference.duaId == link.targetId,
        ),
      ProphetDeepLinkKind.islamicHistory =>
        bundle.historyEventIds.contains(link.targetId),
      ProphetDeepLinkKind.map => bundle.mapLocationIds.contains(link.targetId),
    };
  }

  void requireAuthorized(ProphetDeepLink link) {
    if (!authorizes(link)) {
      throw StateError('Unauthorized prophet deep-link target.');
    }
  }
}