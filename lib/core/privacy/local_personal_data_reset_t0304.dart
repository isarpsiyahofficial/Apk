import '../storage/storage_boundaries.dart';

/// Single fail-closed boundary for deleting all mutable local user state.
///
/// This intentionally clears the entire [PrivateUserStore] namespace rather
/// than a hand-maintained list of keys, so newly-added notes/history/settings
/// cannot silently survive a user-requested reset.
final class LocalPersonalDataResetT0304 {
  LocalPersonalDataResetT0304(this._store) {
    StorageBoundaryGuard.requirePrivateUserStore(_store);
  }

  final PrivateUserStore _store;

  Future<void> resetAll() => _store.clear();
}
