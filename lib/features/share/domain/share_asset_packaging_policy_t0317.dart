import 'package:islami_hayat/features/share/domain/visual_asset_catalog_t0240.dart';

enum ShareAssetCodecT0317 {
  webpLossy,
  webpLossless,
  pngLossless,
  avifExperimental,
}

class ShareAssetPackagingPlanT0317 {
  const ShareAssetPackagingPlanT0317({
    required this.assetId,
    required this.localAssetPath,
    required this.codec,
    required this.religiousTextBakedIn,
  });

  final String assetId;
  final String localAssetPath;
  final ShareAssetCodecT0317 codec;
  final bool religiousTextBakedIn;
}

class ShareAssetPackagingPolicyT0317 {
  const ShareAssetPackagingPolicyT0317._();

  static void requireReleaseReady(
    VisualAssetCatalogT0240 catalog,
    Iterable<ShareAssetPackagingPlanT0317> plans,
  ) {
    final planList = List<ShareAssetPackagingPlanT0317>.unmodifiable(plans);
    if (catalog.entries.length != VisualAssetCatalogT0240.requiredFinalAssetCount ||
        planList.length != VisualAssetCatalogT0240.requiredFinalAssetCount) {
      throw StateError('T0317 requires exactly 100 catalog assets and 100 packaging plans.');
    }

    final plansById = <String, ShareAssetPackagingPlanT0317>{};
    final paths = <String>{};
    for (final plan in planList) {
      if (plansById.putIfAbsent(plan.assetId, () => plan) != plan) {
        throw StateError('Duplicate T0317 packaging plan id: ${plan.assetId}.');
      }
      if (!paths.add(plan.localAssetPath)) {
        throw StateError('Duplicate T0317 packaged path: ${plan.localAssetPath}.');
      }
      if (plan.religiousTextBakedIn) {
        throw StateError(
          'Religious text must be rendered from verified runtime content, never baked into a share background.',
        );
      }
      _requireCodecMatchesPath(plan);
    }

    for (final entry in catalog.entries) {
      final plan = plansById[entry.id];
      if (plan == null) {
        throw StateError('Missing T0317 packaging plan for ${entry.id}.');
      }
      if (entry.localAssetPath != plan.localAssetPath) {
        throw StateError('T0317 path mismatch for ${entry.id}.');
      }
    }
  }

  static void _requireCodecMatchesPath(ShareAssetPackagingPlanT0317 plan) {
    final path = plan.localAssetPath.toLowerCase();
    if (!path.startsWith('assets/share/backgrounds/')) {
      throw StateError('T0317 share background must stay inside the bundled background directory.');
    }

    switch (plan.codec) {
      case ShareAssetCodecT0317.webpLossy:
      case ShareAssetCodecT0317.webpLossless:
        if (!path.endsWith('.webp')) {
          throw StateError('WebP packaging plan requires a .webp asset.');
        }
      case ShareAssetCodecT0317.pngLossless:
        if (!path.endsWith('.png')) {
          throw StateError('PNG lossless packaging plan requires a .png asset.');
        }
      case ShareAssetCodecT0317.avifExperimental:
        throw StateError(
          'AVIF is not a V1 release codec until the complete Android device matrix proves decode support; use WebP or justified PNG lossless.',
        );
    }
  }
}