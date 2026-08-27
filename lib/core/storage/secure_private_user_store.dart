import 'package:flutter_secure_storage/flutter_secure_storage.dart';

import 'storage_boundaries.dart';

/// Production adapter for private mutable user data.
///
/// `flutter_secure_storage` delegates Android secrets to platform secure
/// storage backed by Android Keystore. Religious source content must never be
/// written through this adapter; it is reserved for bookmarks, notes, counters,
/// history and entitlement cache material.
final class SecurePrivateUserStore implements PrivateUserStore {
  SecurePrivateUserStore({
    FlutterSecureStorage? storage,
    this.namespace = 'islami_hayat.private.',
  }) : _storage = storage ?? const FlutterSecureStorage();

  final FlutterSecureStorage _storage;
  final String namespace;

  @override
  StorageDomain get domain => StorageDomain.privateUserData;

  String _key(String key) {
    final normalized = key.trim();
    if (normalized.isEmpty) {
      throw ArgumentError.value(key, 'key', 'Storage key cannot be empty.');
    }
    return '$namespace$normalized';
  }

  @override
  Future<String?> read(String key) => _storage.read(key: _key(key));

  @override
  Future<void> write(String key, String value) =>
      _storage.write(key: _key(key), value: value);

  @override
  Future<void> delete(String key) => _storage.delete(key: _key(key));

  @override
  Future<void> clear() async {
    final all = await _storage.readAll();
    for (final key in all.keys.where((key) => key.startsWith(namespace))) {
      await _storage.delete(key: key);
    }
  }
}
