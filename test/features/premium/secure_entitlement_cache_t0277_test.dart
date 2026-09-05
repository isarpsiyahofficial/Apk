import 'package:flutter_test/flutter_test.dart';
import 'package:islami_hayat/core/storage/secure_private_user_store.dart';
import 'package:islami_hayat/features/premium/domain/entitlement_state_machine.dart';
import 'package:islami_hayat/features/premium/domain/play_billing_product_catalog_t0274.dart';
import 'package:islami_hayat/features/premium/domain/secure_entitlement_cache_t0277.dart';

final class _MemorySecureBackendT0277 implements SecureStorageBackend {
  final Map<String, String> values = <String, String>{};
  bool throwOnRead = false;
  bool throwOnWrite = false;

  @override
  Future<void> delete(String key) async => values.remove(key);

  @override
  Future<String?> read(String key) async {
    if (throwOnRead) {
      throw StateError('secure read failed');
    }
    return values[key];
  }

  @override
  Future<Map<String, String>> readAll() async => Map.of(values);

  @override
  Future<void> write(String key, String value) async {
    if (throwOnWrite) {
      throw StateError('secure write failed');
    }
    values[key] = value;
  }
}

void main() {
  const namespacedKey =
      'islami_hayat.private.${SecureEntitlementCacheT0277.storageKey}';

  ({
    SecureEntitlementCacheT0277 cache,
    _MemorySecureBackendT0277 backend,
  }) build() {
    final backend = _MemorySecureBackendT0277();
    final store = SecurePrivateUserStore(backend: backend);
    return (
      cache: SecureEntitlementCacheT0277(store: store),
      backend: backend,
    );
  }

  test('online-verified PRO round-trips as cached PRO for offline startup',
      () async {
    final fixture = build();

    await fixture.cache.persistVerifiedPro(
      const EntitlementState.verifiedPro(),
    );
    final restored = await fixture.cache.restoreOffline();

    expect(restored.isPro, isTrue);
    expect(restored.verification, EntitlementVerification.cached);
    expect(
      fixture.backend.values[namespacedKey],
      contains(PlayBillingProductCatalogT0274.lifetimeProProductId),
    );
  });

  test('FREE entitlement can never create a PRO cache record', () async {
    final fixture = build();

    await expectLater(
      fixture.cache.persistVerifiedPro(const EntitlementState.free()),
      throwsStateError,
    );
    expect(fixture.backend.values[namespacedKey], isNull);
  });

  test('cached PRO cannot self-amplify into a newly verified cache record',
      () async {
    final fixture = build();

    await expectLater(
      fixture.cache.persistVerifiedPro(const EntitlementState.cachedPro()),
      throwsStateError,
    );
    expect(fixture.backend.values[namespacedKey], isNull);
  });

  test('missing cache fails closed to FREE', () async {
    final fixture = build();

    final restored = await fixture.cache.restoreOffline();

    expect(restored.isFree, isTrue);
  });

  test('corrupt cache fails closed to FREE', () async {
    final fixture = build();
    fixture.backend.values[namespacedKey] = '{not-json';

    final restored = await fixture.cache.restoreOffline();

    expect(restored.isFree, isTrue);
  });

  test('unknown schema fails closed to FREE', () async {
    final fixture = build();
    fixture.backend.values[namespacedKey] =
        '{"schema":2,"kind":"verified_lifetime_pro","productId":"islami_hayat_lifetime_pro","tier":"pro","verifiedOnline":true}';

    final restored = await fixture.cache.restoreOffline();

    expect(restored.isFree, isTrue);
  });

  test('wrong product fails closed to FREE', () async {
    final fixture = build();
    fixture.backend.values[namespacedKey] =
        '{"schema":1,"kind":"verified_lifetime_pro","productId":"monthly_pro","tier":"pro","verifiedOnline":true}';

    final restored = await fixture.cache.restoreOffline();

    expect(restored.isFree, isTrue);
  });

  test('record that is not explicitly verified online fails closed', () async {
    final fixture = build();
    fixture.backend.values[namespacedKey] =
        '{"schema":1,"kind":"verified_lifetime_pro","productId":"islami_hayat_lifetime_pro","tier":"pro","verifiedOnline":false}';

    final restored = await fixture.cache.restoreOffline();

    expect(restored.isFree, isTrue);
  });

  test('secure storage read failure never grants offline PRO', () async {
    final fixture = build();
    fixture.backend.throwOnRead = true;

    final restored = await fixture.cache.restoreOffline();

    expect(restored.isFree, isTrue);
  });

  test('secure storage write failure is surfaced and cannot fake persistence',
      () async {
    final fixture = build();
    fixture.backend.throwOnWrite = true;

    await expectLater(
      fixture.cache.persistVerifiedPro(
        const EntitlementState.verifiedPro(),
      ),
      throwsStateError,
    );
    expect(fixture.backend.values[namespacedKey], isNull);
  });

  test('clear removes a previously verified entitlement record', () async {
    final fixture = build();
    await fixture.cache.persistVerifiedPro(
      const EntitlementState.verifiedPro(),
    );

    await fixture.cache.clear();

    expect(fixture.backend.values[namespacedKey], isNull);
    expect((await fixture.cache.restoreOffline()).isFree, isTrue);
  });
}
