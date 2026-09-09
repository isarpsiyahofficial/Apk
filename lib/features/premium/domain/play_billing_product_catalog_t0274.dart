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

/// Exact store result required before the app may offer Lifetime PRO.
///
/// This intentionally contains only identifiers. Localized title/price copy is
/// display data from Google Play and must never decide entitlement identity.
final class PlayBillingCatalogEvidenceT0274 {
  const PlayBillingCatalogEvidenceT0274({
    required this.returnedProductIds,
    required this.notFoundProductIds,
  });

  final Set<String> returnedProductIds;
  final Set<String> notFoundProductIds;
}

final class PlayBillingProductCatalogT0274 {
  const PlayBillingProductCatalogT0274._();

  /// Permanent Google Play product ID for V1 Lifetime PRO.
  ///
  /// This is the only V1 billing identifier that can grant Lifetime PRO. It is
  /// deliberately isolated from localized UI copy, price text and campaign
  /// names so none of those can silently change entitlement identity.
  static const String lifetimeProProductId = 'islami_hayat_lifetime_pro';

  static const PlayBillingProductT0274 lifetimePro = PlayBillingProductT0274(
    id: lifetimeProProductId,
    entitlement: PlayProductEntitlementT0274.lifetimePro,
    kind: PlayOneTimeProductKindT0274.nonConsumable,
  );

  static const List<PlayBillingProductT0274> products = <PlayBillingProductT0274>[
    lifetimePro,
  ];

  /// Exact product IDs that may be sent to Google Play product-detail query.
  static Set<String> get queryProductIds =>
      Set<String>.unmodifiable(products.map((product) => product.id));

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

  /// Validates the result of the Google Play product-details query.
  ///
  /// The catalog fails closed when the canonical product is missing/not-found,
  /// when an unexpected product is returned, or when the same ID appears in
  /// both result sets. This protects later purchase code from substituting a
  /// monthly/subscription/test SKU for the permanent V1 entitlement.
  static PlayBillingProductT0274 requireExactStoreCatalog(
    PlayBillingCatalogEvidenceT0274 evidence,
  ) {
    final expected = queryProductIds;
    final overlap = evidence.returnedProductIds.intersection(
      evidence.notFoundProductIds,
    );
    if (overlap.isNotEmpty) {
      throw StateError('Google Play catalog evidence is contradictory.');
    }
    if (evidence.notFoundProductIds.isNotEmpty) {
      throw StateError('Canonical Google Play product is unavailable.');
    }
    if (evidence.returnedProductIds.length != expected.length ||
        !evidence.returnedProductIds.containsAll(expected) ||
        !expected.containsAll(evidence.returnedProductIds)) {
      throw StateError('Google Play catalog does not exactly match V1 catalog.');
    }
    return lifetimePro;
  }
}
