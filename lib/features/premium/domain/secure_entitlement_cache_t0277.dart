import 'dart:convert';

import '../../../core/storage/secure_private_user_store.dart';
import 'entitlement_state_machine.dart';
import 'play_billing_product_catalog_t0274.dart';

/// Keystore-backed cache boundary for a previously verified Lifetime PRO grant.
///
/// Only an entitlement that was verified online may create or refresh this
/// record. Offline startup never upgrades an arbitrary local value to
/// `verifiedOnline`; a valid record is restored as `cached` PRO instead.
/// Missing, malformed, stale-schema, or wrong-product records fail closed to
/// FREE.
final class SecureEntitlementCacheT0277 {
  SecureEntitlementCacheT0277({SecurePrivateUserStore? store})
      : _store = store ?? SecurePrivateUserStore();

  static const String storageKey = 'premium.entitlement.v1';
  static const int schemaVersion = 1;
  static const String recordKind = 'verified_lifetime_pro';

  final SecurePrivateUserStore _store;

  Future<void> persistVerifiedPro(EntitlementState entitlement) async {
    if (!entitlement.isPro ||
        entitlement.verification != EntitlementVerification.verifiedOnline) {
      throw StateError(
        'Only an online-verified PRO entitlement may be cached.',
      );
    }

    await _store.write(
      storageKey,
      jsonEncode(<String, Object>{
        'schema': schemaVersion,
        'kind': recordKind,
        'productId': PlayBillingProductCatalogT0274.lifetimeProProductId,
        'tier': 'pro',
        'verifiedOnline': true,
      }),
    );
  }

  Future<EntitlementState> restoreOffline() async {
    try {
      final raw = await _store.read(storageKey);
      if (raw == null || raw.trim().isEmpty) {
        return const EntitlementState.free();
      }

      final decoded = jsonDecode(raw);
      if (decoded is! Map<String, dynamic> || !_isTrustedRecord(decoded)) {
        return const EntitlementState.free();
      }

      return const EntitlementState.cachedPro();
    } on Object {
      return const EntitlementState.free();
    }
  }

  Future<void> clear() => _store.delete(storageKey);

  bool _isTrustedRecord(Map<String, dynamic> record) {
    return record['schema'] == schemaVersion &&
        record['kind'] == recordKind &&
        record['productId'] ==
            PlayBillingProductCatalogT0274.lifetimeProProductId &&
        record['tier'] == 'pro' &&
        record['verifiedOnline'] == true;
  }
}
