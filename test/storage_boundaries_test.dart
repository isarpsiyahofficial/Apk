import 'package:flutter_test/flutter_test.dart';
import 'package:islami_hayat/core/storage/storage_boundaries.dart';

final class _TrustedStore implements TrustedContentStore {
  @override
  StorageDomain get domain => StorageDomain.trustedContent;

  @override
  Future<String?> read(String key) async => null;
}

final class _PrivateStore implements PrivateUserStore {
  @override
  StorageDomain get domain => StorageDomain.privateUserData;

  @override
  Future<void> clear() async {}

  @override
  Future<void> delete(String key) async {}

  @override
  Future<String?> read(String key) async => null;

  @override
  Future<void> write(String key, String value) async {}
}

void main() {
  test('trusted religious content store is a read-only contract', () {
    final store = _TrustedStore();
    expect(store.domain, StorageDomain.trustedContent);
    expect(
      () => StorageBoundaryGuard.requireTrustedContentStore(store),
      returnsNormally,
    );
  });

  test('private user state is isolated in its own mutable domain', () {
    final store = _PrivateStore();
    expect(store.domain, StorageDomain.privateUserData);
    expect(
      () => StorageBoundaryGuard.requirePrivateUserStore(store),
      returnsNormally,
    );
  });
}
