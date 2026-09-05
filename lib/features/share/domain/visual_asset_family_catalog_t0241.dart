import 'package:islami_hayat/features/share/domain/visual_asset_catalog_t0240.dart';

enum VisualAssetFamilyT0241 {
  warmMinimal,
  naturalTexture,
  nightSky,
  abstractArchitecture,
  typography,
  softGeometric,
  calmLight,
  watercolorBotanical,
}

class VisualAssetFamilyTagT0241 {
  const VisualAssetFamilyTagT0241({
    required this.assetId,
    required this.family,
  });

  final String assetId;
  final VisualAssetFamilyT0241 family;
}

class VisualAssetFamilyCatalogT0241 {
  VisualAssetFamilyCatalogT0241._({
    required this.byAssetId,
    required this.countByFamily,
  });

  factory VisualAssetFamilyCatalogT0241.forFinalAssets({
    required VisualAssetCatalogT0240 assets,
    required Iterable<VisualAssetFamilyTagT0241> tags,
  }) {
    final assetIds = assets.entries.map((entry) => entry.id).toSet();
    final byAssetId = <String, VisualAssetFamilyT0241>{};
    final countByFamily = <VisualAssetFamilyT0241, int>{};

    for (final tag in tags) {
      final assetId = tag.assetId.trim();
      if (assetId.isEmpty) {
        throw StateError('T0241 visual family tag requires a non-empty asset id.');
      }
      if (!assetIds.contains(assetId)) {
        throw StateError('T0241 family tag references unknown asset: $assetId.');
      }
      if (byAssetId.containsKey(assetId)) {
        throw StateError('Duplicate T0241 family tag for asset: $assetId.');
      }
      byAssetId[assetId] = tag.family;
      countByFamily.update(tag.family, (count) => count + 1, ifAbsent: () => 1);
    }

    final missingAssetIds = assetIds.difference(byAssetId.keys.toSet());
    if (missingAssetIds.isNotEmpty) {
      throw StateError(
        'T0241 requires every final asset to have exactly one visual family tag; '
        'missing ${missingAssetIds.length}.',
      );
    }
    if (byAssetId.length != assetIds.length) {
      throw StateError('T0241 visual family coverage does not match final assets.');
    }
    if (countByFamily.length < minimumDistinctFamilyCount) {
      throw StateError(
        'T0241 requires at least $minimumDistinctFamilyCount distinct visual '
        'families to prevent a single-tone asset set.',
      );
    }

    return VisualAssetFamilyCatalogT0241._(
      byAssetId: Map.unmodifiable(byAssetId),
      countByFamily: Map.unmodifiable(countByFamily),
    );
  }

  static const minimumDistinctFamilyCount = 3;

  final Map<String, VisualAssetFamilyT0241> byAssetId;
  final Map<VisualAssetFamilyT0241, int> countByFamily;
}
