import 'package:flutter_test/flutter_test.dart';
import 'package:islami_hayat/core/storage/secure_private_user_store.dart';
import 'package:islami_hayat/features/premium/domain/entitlement_state_machine.dart';
import 'package:islami_hayat/features/premium/domain/play_ownership_refresh_t0278.dart';
import 'package:islami_hayat/features/premium/domain/secure_entitlement_cache_t0277.dart';

final class _MemorySecureBackendT0278 implements SecureStorageBackend {
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

final class _GatewayT0278 implements PlayOwnershipRefreshGatewayT0278 {
  _GatewayT0278(this.snapshot);

  final PlayOwnershipSnapshotT0278 snapshot;
  bool shouldThrow = false;
  int calls = 0;

  @override
  Future<PlayOwnershipSnapshotT0278> queryVerifiedLifetimeProOwnership() async {
    calls += 1;
    if (shouldThrow) {
      throw StateError('temporary Play query or verification failure');
    }
    return snapshot;
  }
}

void main() {
  ({
    PlayOwnershipRefreshServiceT0278 service,
    SecureEntitlementCacheT0277 cache,
    _GatewayT0278 gateway,
  }) build(PlayOwnershipEvidenceT0278 evidence) {
    final backend = _MemorySecureBackendT0278();
    final cache = SecureEntitlementCacheT0277(
      store: SecurePrivateUserStore(backend: backend),
    );
    final gateway = _GatewayT0278(PlayOwnershipSnapshotT0278(evidence));
    return (
      service: PlayOwnershipRefreshServiceT0278(
        gateway: gateway,
        cache: cache,
      ),
      cache: cache,
      gateway: gateway,
    );
  }

  test('verified owned refresh produces verified PRO and refreshes secure cache',
      () async {
    final fixture = build(PlayOwnershipEvidenceT0278.verifiedOwned);

    final result = await fixture.service.refresh(
      current: const EntitlementState.cachedPro(),
      hasVerifiedInternetReachability: true,
    );

    expect(result.outcome, PlayOwnershipRefreshOutcomeT0278.verifiedOwned);
    expect(result.entitlement.isPro, isTrue);
    expect(
      result.entitlement.verification,
      EntitlementVerification.verifiedOnline,
    );
    expect((await fixture.cache.restoreOffline()).isPro, isTrue);
  });

  test('verified refund or revoke drops PRO and clears stale offline cache',
      () async {
    final fixture = build(
      PlayOwnershipEvidenceT0278.verifiedRevokedOrRefunded,
    );
    await fixture.cache.persistVerifiedPro(
      const EntitlementState.verifiedPro(),
    );

    final result = await fixture.service.refresh(
      current: const EntitlementState.cachedPro(),
      hasVerifiedInternetReachability: true,
    );

    expect(
      result.outcome,
      PlayOwnershipRefreshOutcomeT0278.revokedOrRefunded,
    );
    expect(result.entitlement.isFree, isTrue);
    expect((await fixture.cache.restoreOffline()).isFree, isTrue);
  });

  test('authoritative verified no-ownership also clears stale PRO cache',
      () async {
    final fixture = build(PlayOwnershipEvidenceT0278.verifiedNoOwnership);
    await fixture.cache.persistVerifiedPro(
      const EntitlementState.verifiedPro(),
    );

    final result = await fixture.service.refresh(
      current: const EntitlementState.cachedPro(),
      hasVerifiedInternetReachability: true,
    );

    expect(result.outcome, PlayOwnershipRefreshOutcomeT0278.noOwnership);
    expect(result.entitlement.isFree, isTrue);
    expect((await fixture.cache.restoreOffline()).isFree, isTrue);
  });

  test('offline refresh is skipped and never queries Play', () async {
    final fixture = build(
      PlayOwnershipEvidenceT0278.verifiedRevokedOrRefunded,
    );

    final result = await fixture.service.refresh(
      current: const EntitlementState.cachedPro(),
      hasVerifiedInternetReachability: false,
    );

    expect(result.outcome, PlayOwnershipRefreshOutcomeT0278.skippedOffline);
    expect(result.entitlement.isPro, isTrue);
    expect(fixture.gateway.calls, 0);
  });

  test('transient query or verification failure never fakes a revoke', () async {
    final fixture = build(PlayOwnershipEvidenceT0278.verifiedNoOwnership);
    fixture.gateway.shouldThrow = true;
    await fixture.cache.persistVerifiedPro(
      const EntitlementState.verifiedPro(),
    );

    final result = await fixture.service.refresh(
      current: const EntitlementState.cachedPro(),
      hasVerifiedInternetReachability: true,
    );

    expect(
      result.outcome,
      PlayOwnershipRefreshOutcomeT0278.transientFailure,
    );
    expect(result.entitlement.isPro, isTrue);
    expect((await fixture.cache.restoreOffline()).isPro, isTrue);
  });

  test('verified no-ownership keeps FREE user FREE', () async {
    final fixture = build(PlayOwnershipEvidenceT0278.verifiedNoOwnership);

    final result = await fixture.service.refresh(
      current: const EntitlementState.free(),
      hasVerifiedInternetReachability: true,
    );

    expect(result.entitlement.isFree, isTrue);
    expect((await fixture.cache.restoreOffline()).isFree, isTrue);
  });
}
