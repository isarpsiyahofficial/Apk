enum PlayProductEntitlementT0274 {
  lifetimePro,
}

enum PlayOneTimeProductKindT0274 {
  nonConsumable,
}

final class PlayBillingProductT0274 {
  const PlayBillingProductT0274({
    required this.id,
    required this.entitlement,
    required this.kind,
  });

  final String id;
  final PlayProductEntitlementT0274 entitlement;
  final PlayOneTimeProductKindT0274 kind;
}

final class PlayBillingProductCatalogT0274 {
  const PlayBillingProductCatalogT0274._();

  /// Permanent Google Play product ID for V1 Lifetime PRO.
  ///
  /// Google Play product IDs cannot be renamed or reused after creation, so
  /// this value is intentionally isolated from localized UI copy and pricing.
  static const String lifetimeProProductId = 'islami_hayat_lifetime_pro';

  static const PlayBillingProductT0274 lifetimePro = PlayBillingProductT0274(
    id: lifetimeProProductId,
    entitlement: PlayProductEntitlementT0274.lifetimePro,
    kind: PlayOneTimeProductKindT0274.nonConsumable,
  );

  static const List<PlayBillingProductT0274> products = <PlayBillingProductT0274>[
    lifetimePro,
  ];

  static PlayBillingProductT0274 requireKnownProduct(String productId) {
    for (final product in products) {
      if (product.id == productId) {
        return product;
      }
    }
    throw StateError('Unknown Google Play product ID.');
  }

  static bool isLifetimeProProduct(String productId) {
    return productId == lifetimeProProductId;
  }
}
