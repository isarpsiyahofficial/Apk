/// Storage boundaries are intentionally explicit so immutable religious source
/// data can never be overwritten by user state.
enum StorageDomain {
  /// Versioned, source-reviewed and integrity-checked application content.
  trustedContent,

  /// Private mutable state such as bookmarks, notes, dhikr counters and history.
  privateUserData,
}

abstract interface class TrustedContentStore {
  StorageDomain get domain;

  /// Reads a release-versioned trusted record. Implementations must be read-only.
  Future<String?> read(String key);
}

abstract interface class PrivateUserStore {
  StorageDomain get domain;

  Future<String?> read(String key);
  Future<void> write(String key, String value);
  Future<void> delete(String key);
  Future<void> clear();
}

/// Guard used by concrete storage adapters before they are allowed into the
/// production dependency graph.
final class StorageBoundaryGuard {
  const StorageBoundaryGuard._();

  static void requireTrustedContentStore(TrustedContentStore store) {
    if (store.domain != StorageDomain.trustedContent) {
      throw StateError('Trusted content store has an invalid storage domain.');
    }
  }

  static void requirePrivateUserStore(PrivateUserStore store) {
    if (store.domain != StorageDomain.privateUserData) {
      throw StateError('Private user store has an invalid storage domain.');
    }
  }
}
