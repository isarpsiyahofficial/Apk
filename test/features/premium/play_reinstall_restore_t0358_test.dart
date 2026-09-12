import 'package:flutter_test/flutter_test.dart';
import 'package:islami_hayat/core/storage/secure_private_user_store.dart';
import 'package:islami_hayat/features/premium/domain/entitlement_state_machine.dart';
import 'package:islami_hayat/features/premium/domain/play_billing_product_catalog_t0274.dart';
import 'package:islami_hayat/features/premium/domain/play_restore_purchases_t0276.dart';
import 'package:islami_hayat/features/premium/domain/secure_entitlement_cache_t0277.dart';

final class _FreshInstallSecureBackend implements SecureStorageBackend {
  final Map<String, String> values = <String, String>{};

  @override
  Future<void> delete(String key) async => values.remove(key);

  @override
  Future<String?> read(String key) async => values[key];

  @override
  Future<Map<String, String>> readAll() async => Map.of(values);

  @override
  Future<void> write(String key, String value) async {
    values[key] = value;
  }
}

void main() {
  const machine = PlayRestorePurchasesStateMachineT0276();
  const productId = PlayBillingProductCatalogT0274.lifetimeProProductId;
  const evidence = 'restore-evidence-sha256:fresh-install';

  PlayRestoreOwnershipSnapshotT0276 verifiedOwnership() {
    return PlayRestoreOwnershipSnapshotT0276(
      ownedProductIds: const [productId],
      verificationEvidenceFingerprintsByProductId: const {
        productId: evidence,
      },
    );
  }

  test('fresh install starts FREE when no secure entitlement cache exists', () async {
    final backend = _FreshInstallSecureBackend();
    final cache = SecureEntitlementCacheT0277(
      store: SecurePrivateUserStore(backend: backend),
    );

    final restoredOffline = await cache.restoreOffline();

    expect(restoredOffline.isFree, isTrue);
    expect(backend.values, isEmpty);
  });

  test('fresh install restores Lifetime PRO only after verified Play ownership', () async {
    final initial = machine.begin(const PlayRestoreStateT0276.idle());

    final candidate = machine.handleOwnershipSnapshot(
      initial,
      verifiedOwnership(),
    );

    expect(candidate.entitlement.isFree, isTrue);
    expect(candidate.grantsPro, isFalse);
    expect(candidate.phase, PlayRestorePhaseT0276.awaitingVerification);

    final restored = machine.markVerifiedRestore(
      candidate,
      productId: productId,
      verificationEvidenceFingerprint: evidence,
    );

    expect(restored.phase, PlayRestorePhaseT0276.restored);
    expect(restored.entitlement.isPro, isTrue);
    expect(
      restored.entitlement.verification,
      EntitlementVerification.verifiedOnline,
    );
    expect(restored.grantsPro, isTrue);
  });

  test('fresh install unrelated ownership cannot restore Lifetime PRO', () {
    final initial = machine.begin(const PlayRestoreStateT0276.idle());

    final state = machine.handleOwnershipSnapshot(
      initial,
      PlayRestoreOwnershipSnapshotT0276(
        ownedProductIds: const ['legacy_monthly_or_unrelated_product'],
      ),
    );

    expect(state.phase, PlayRestorePhaseT0276.nothingToRestore);
    expect(state.entitlement.isFree, isTrue);
    expect(state.grantsPro, isFalse);
  });

  test('verified reinstall restore can seed only the secure offline PRO cache', () async {
    final backend = _FreshInstallSecureBackend();
    final cache = SecureEntitlementCacheT0277(
      store: SecurePrivateUserStore(backend: backend),
    );
    final initial = machine.begin(const PlayRestoreStateT0276.idle());
    final candidate = machine.handleOwnershipSnapshot(
      initial,
      verifiedOwnership(),
    );
    final restored = machine.markVerifiedRestore(
      candidate,
      productId: productId,
      verificationEvidenceFingerprint: evidence,
    );

    await cache.persistVerifiedPro(restored.entitlement);
    final offline = await cache.restoreOffline();

    expect(offline.isPro, isTrue);
    expect(offline.verification, EntitlementVerification.cached);
  });
}
