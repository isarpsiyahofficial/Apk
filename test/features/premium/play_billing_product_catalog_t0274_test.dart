import 'package:flutter_test/flutter_test.dart';
import 'package:islami_hayat/features/premium/domain/play_billing_product_catalog_t0274.dart';

void main() {
  group('T0274 Play Billing product catalog', () {
    test('Lifetime PRO product ID is stable and Play-compatible', () {
      const productId = PlayBillingProductCatalogT0274.lifetimeProProductId;

      expect(productId, 'islami_hayat_lifetime_pro');
      expect(productId.length, lessThanOrEqualTo(40));
      expect(RegExp(r'^[a-z0-9][a-z0-9_.]*$').hasMatch(productId), isTrue);
      expect(productId.startsWith('android.test'), isFalse);
    });

    test('catalog contains exactly one V1 non-consumable Lifetime PRO product', () {
      expect(PlayBillingProductCatalogT0274.products, hasLength(1));
      expect(
        PlayBillingProductCatalogT0274.queryProductIds,
        <String>{'islami_hayat_lifetime_pro'},
      );

      final product = PlayBillingProductCatalogT0274.lifetimePro;
      expect(product.id, 'islami_hayat_lifetime_pro');
      expect(product.entitlement, PlayProductEntitlementT0274.lifetimePro);
      expect(product.kind, PlayOneTimeProductKindT0274.nonConsumable);
    });

    test('known Lifetime PRO product resolves to the canonical catalog entry', () {
      final product = PlayBillingProductCatalogT0274.requireKnownProduct(
        'islami_hayat_lifetime_pro',
      );

      expect(identical(product, PlayBillingProductCatalogT0274.lifetimePro), isTrue);
      expect(
        PlayBillingProductCatalogT0274.isLifetimeProProduct(product.id),
        isTrue,
      );
    });

    test('exact Play result resolves only the canonical Lifetime PRO product', () {
      final product = PlayBillingProductCatalogT0274.requireExactStoreCatalog(
        const PlayBillingCatalogEvidenceT0274(
          returnedProductIds: <String>{'islami_hayat_lifetime_pro'},
          notFoundProductIds: <String>{},
        ),
      );

      expect(identical(product, PlayBillingProductCatalogT0274.lifetimePro), isTrue);
    });

    test('unknown or subscription-like IDs fail closed', () {
      expect(
        () => PlayBillingProductCatalogT0274.requireKnownProduct(
          'islami_hayat_monthly_pro',
        ),
        throwsStateError,
      );
      expect(
        PlayBillingProductCatalogT0274.isLifetimeProProduct(
          'islami_hayat_monthly_pro',
        ),
        isFalse,
      );
      expect(
        () => PlayBillingProductCatalogT0274.requireExactStoreCatalog(
          const PlayBillingCatalogEvidenceT0274(
            returnedProductIds: <String>{'islami_hayat_monthly_pro'},
            notFoundProductIds: <String>{},
          ),
        ),
        throwsStateError,
      );
    });

    test('missing/not-found canonical product fails closed', () {
      expect(
        () => PlayBillingProductCatalogT0274.requireExactStoreCatalog(
          const PlayBillingCatalogEvidenceT0274(
            returnedProductIds: <String>{},
            notFoundProductIds: <String>{'islami_hayat_lifetime_pro'},
          ),
        ),
        throwsStateError,
      );
      expect(
        () => PlayBillingProductCatalogT0274.requireExactStoreCatalog(
          const PlayBillingCatalogEvidenceT0274(
            returnedProductIds: <String>{},
            notFoundProductIds: <String>{},
          ),
        ),
        throwsStateError,
      );
    });

    test('unexpected or contradictory store evidence fails closed', () {
      expect(
        () => PlayBillingProductCatalogT0274.requireExactStoreCatalog(
          const PlayBillingCatalogEvidenceT0274(
            returnedProductIds: <String>{
              'islami_hayat_lifetime_pro',
              'islami_hayat_monthly_pro',
            },
            notFoundProductIds: <String>{},
          ),
        ),
        throwsStateError,
      );
      expect(
        () => PlayBillingProductCatalogT0274.requireExactStoreCatalog(
          const PlayBillingCatalogEvidenceT0274(
            returnedProductIds: <String>{'islami_hayat_lifetime_pro'},
            notFoundProductIds: <String>{'islami_hayat_lifetime_pro'},
          ),
        ),
        throwsStateError,
      );
    });

    test('query product ID set cannot be mutated by callers', () {
      final ids = PlayBillingProductCatalogT0274.queryProductIds;
      expect(
        () => ids.add('islami_hayat_monthly_pro'),
        throwsUnsupportedError,
      );
      expect(
        PlayBillingProductCatalogT0274.queryProductIds,
        <String>{'islami_hayat_lifetime_pro'},
      );
    });
  });
}
