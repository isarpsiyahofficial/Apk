import 'package:in_app_purchase/in_app_purchase.dart';

import '../domain/play_billing_product_catalog_t0274.dart';

final class PlayStoreCatalogSnapshotT0359 {
  const PlayStoreCatalogSnapshotT0359({
    required this.returnedProductIds,
    required this.notFoundProductIds,
  });

  final Set<String> returnedProductIds;
  final Set<String> notFoundProductIds;
}

abstract interface class PlayStoreSdkT0359 {
  Future<bool> isAvailable();

  Future<PlayStoreCatalogSnapshotT0359> queryProducts(Set<String> productIds);

  Future<bool> buyNonConsumable({required String productId});

  Future<void> restorePurchases();
}

/// Official `in_app_purchase` adapter. Product details are cached only after an
/// exact store query; a purchase cannot be launched for a fabricated SKU.
final class OfficialInAppPurchaseSdkT0359 implements PlayStoreSdkT0359 {
  OfficialInAppPurchaseSdkT0359({InAppPurchase? inAppPurchase})
      : _inAppPurchase = inAppPurchase ?? InAppPurchase.instance;

  final InAppPurchase _inAppPurchase;
  final Map<String, ProductDetails> _queriedProducts = <String, ProductDetails>{};

  @override
  Future<bool> isAvailable() => _inAppPurchase.isAvailable();

  @override
  Future<PlayStoreCatalogSnapshotT0359> queryProducts(
    Set<String> productIds,
  ) async {
    final response = await _inAppPurchase.queryProductDetails(productIds);
    if (response.error != null) {
      throw StateError('Google Play product query failed.');
    }

    _queriedProducts
      ..clear()
      ..addEntries(
        response.productDetails.map((product) => MapEntry(product.id, product)),
      );

    return PlayStoreCatalogSnapshotT0359(
      returnedProductIds: Set<String>.unmodifiable(
        response.productDetails.map((product) => product.id),
      ),
      notFoundProductIds: Set<String>.unmodifiable(response.notFoundIDs),
    );
  }

  @override
  Future<bool> buyNonConsumable({required String productId}) async {
    PlayBillingProductCatalogT0274.requireKnownProduct(productId);
    final product = _queriedProducts[productId];
    if (product == null) {
      throw StateError(
        'Lifetime PRO product must be loaded from the exact Play catalog before purchase.',
      );
    }

    return _inAppPurchase.buyNonConsumable(
      purchaseParam: PurchaseParam(productDetails: product),
    );
  }

  @override
  Future<void> restorePurchases() => _inAppPurchase.restorePurchases();
}

/// Fail-closed entry point for the V1 one-time Lifetime PRO Play product.
///
/// This layer intentionally does not grant entitlement. Purchase/restore
/// callbacks still have to pass the existing verification state machines before
/// PRO can be persisted. The store bridge only proves that the canonical
/// non-consumable SKU exists and launches/query-restores through the real SDK.
final class GooglePlayLifetimeProStoreT0359 {
  GooglePlayLifetimeProStoreT0359({required PlayStoreSdkT0359 sdk}) : _sdk = sdk;

  final PlayStoreSdkT0359 _sdk;
  bool _catalogReady = false;

  bool get catalogReady => _catalogReady;

  Future<void> loadExactCatalog() async {
    _catalogReady = false;
    if (!await _sdk.isAvailable()) {
      throw StateError('Google Play billing is unavailable.');
    }

    final snapshot = await _sdk.queryProducts(
      PlayBillingProductCatalogT0274.queryProductIds,
    );
    PlayBillingProductCatalogT0274.requireExactStoreCatalog(
      PlayBillingCatalogEvidenceT0274(
        returnedProductIds: snapshot.returnedProductIds,
        notFoundProductIds: snapshot.notFoundProductIds,
      ),
    );
    _catalogReady = true;
  }

  Future<void> startLifetimeProPurchase() async {
    if (!_catalogReady) {
      throw StateError('Exact Google Play catalog must be loaded first.');
    }

    final launched = await _sdk.buyNonConsumable(
      productId: PlayBillingProductCatalogT0274.lifetimeProProductId,
    );
    if (!launched) {
      throw StateError('Google Play did not launch the Lifetime PRO purchase flow.');
    }
  }

  Future<void> restorePurchases() async {
    if (!await _sdk.isAvailable()) {
      throw StateError('Google Play billing is unavailable.');
    }
    await _sdk.restorePurchases();
  }
}
