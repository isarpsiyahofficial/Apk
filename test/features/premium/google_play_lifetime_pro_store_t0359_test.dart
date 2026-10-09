import 'package:flutter_test/flutter_test.dart';
import 'package:islami_hayat/features/premium/domain/play_billing_product_catalog_t0274.dart';
import 'package:islami_hayat/features/premium/platform/google_play_lifetime_pro_store_t0359.dart';

void main() {
  group('GooglePlayLifetimeProStoreT0359', () {
    test('exact canonical catalog enables one-time purchase launch', () async {
      final sdk = _FakePlayStoreSdk();
      final store = GooglePlayLifetimeProStoreT0359(sdk: sdk);

      await store.loadExactCatalog();
      await store.startLifetimeProPurchase();

      expect(store.catalogReady, isTrue);
      expect(sdk.queryCalls, 1);
      expect(
        sdk.lastQueriedIds,
        PlayBillingProductCatalogT0274.queryProductIds,
      );
      expect(sdk.buyCalls, 1);
      expect(
        sdk.lastPurchasedId,
        PlayBillingProductCatalogT0274.lifetimeProProductId,
      );
    });

    test('purchase fails closed before exact catalog is loaded', () async {
      final sdk = _FakePlayStoreSdk();
      final store = GooglePlayLifetimeProStoreT0359(sdk: sdk);

      await expectLater(store.startLifetimeProPurchase(), throwsStateError);
      expect(sdk.buyCalls, 0);
    });

    test('missing canonical product keeps purchase disabled', () async {
      final sdk = _FakePlayStoreSdk(
        returnedProductIds: const <String>{},
        notFoundProductIds: const <String>{
          PlayBillingProductCatalogT0274.lifetimeProProductId,
        },
      );
      final store = GooglePlayLifetimeProStoreT0359(sdk: sdk);

      await expectLater(store.loadExactCatalog(), throwsStateError);
      expect(store.catalogReady, isFalse);
      expect(sdk.buyCalls, 0);
    });

    test('unexpected SKU substitution is rejected', () async {
      final sdk = _FakePlayStoreSdk(
        returnedProductIds: const <String>{'monthly_pro'},
      );
      final store = GooglePlayLifetimeProStoreT0359(sdk: sdk);

      await expectLater(store.loadExactCatalog(), throwsStateError);
      expect(store.catalogReady, isFalse);
    });

    test('billing unavailable fails purchase catalog and restore', () async {
      final sdk = _FakePlayStoreSdk(available: false);
      final store = GooglePlayLifetimeProStoreT0359(sdk: sdk);

      await expectLater(store.loadExactCatalog(), throwsStateError);
      await expectLater(store.restorePurchases(), throwsStateError);
      expect(sdk.restoreCalls, 0);
    });

    test('SDK refusal to launch purchase is explicit failure', () async {
      final sdk = _FakePlayStoreSdk(launchPurchase: false);
      final store = GooglePlayLifetimeProStoreT0359(sdk: sdk);

      await store.loadExactCatalog();
      await expectLater(store.startLifetimeProPurchase(), throwsStateError);
      expect(sdk.buyCalls, 1);
    });

    test('restore delegates to real-store boundary without granting PRO', () async {
      final sdk = _FakePlayStoreSdk();
      final store = GooglePlayLifetimeProStoreT0359(sdk: sdk);

      await store.restorePurchases();

      expect(sdk.restoreCalls, 1);
      expect(store.catalogReady, isFalse);
    });
  });
}

final class _FakePlayStoreSdk implements PlayStoreSdkT0359 {
  _FakePlayStoreSdk({
    this.available = true,
    Set<String>? returnedProductIds,
    this.notFoundProductIds = const <String>{},
    this.launchPurchase = true,
  }) : returnedProductIds = returnedProductIds ??
            const <String>{
              PlayBillingProductCatalogT0274.lifetimeProProductId,
            };

  final bool available;
  final Set<String> returnedProductIds;
  final Set<String> notFoundProductIds;
  final bool launchPurchase;

  int queryCalls = 0;
  int buyCalls = 0;
  int restoreCalls = 0;
  Set<String>? lastQueriedIds;
  String? lastPurchasedId;

  @override
  Future<bool> isAvailable() async => available;

  @override
  Future<PlayStoreCatalogSnapshotT0359> queryProducts(
    Set<String> productIds,
  ) async {
    queryCalls += 1;
    lastQueriedIds = Set<String>.from(productIds);
    return PlayStoreCatalogSnapshotT0359(
      returnedProductIds: returnedProductIds,
      notFoundProductIds: notFoundProductIds,
    );
  }

  @override
  Future<bool> buyNonConsumable({required String productId}) async {
    buyCalls += 1;
    lastPurchasedId = productId;
    return launchPurchase;
  }

  @override
  Future<void> restorePurchases() async {
    restoreCalls += 1;
  }
}
