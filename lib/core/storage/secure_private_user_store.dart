import 'package:flutter_secure_storage/flutter_secure_storage.dart';

import 'storage_boundaries.dart';

abstract interface class SecureStorageBackend {
  Future<String?> read(String key);
  Future<void> write(String key, String value);
  Future<void> delete(String key);
  Future<Map<String, String>> readAll();
}

final class FlutterSecureStorageBackend implements SecureStorageBackend {
  FlutterSecureStorageBackend({FlutterSecureStorage? storage})
      : _storage = storage ?? const FlutterSecureStorage();

  final FlutterSecureStorage _storage;

  @override
  Future<String?> read(String key) => _storage.read(key: key);

  @override
  Future<void> write(String key, String value) =>
      _storage.write(key: key, value: value);

  @override
  Future<void> delete(String key) => _storage.delete(key: key);

  @override
  Future<Map<String, String>> readAll() => _storage.readAll();
}

/// Production adapter for private mutable user data.
///
/// The default backend uses `flutter_secure_storage`, which delegates Android
/// secret protection to platform secure storage backed by Android Keystore.
/// Trusted religious source content is deliberately excluded from this store.
final class SecurePrivateUserStore implements PrivateUserStore {
  SecurePrivateUserStore({
    SecureStorageBackend? backend,
    this.namespace = 'islami_hayat.private.',
  }) : _backend = backend ?? FlutterSecureStorageBackend();

  final SecureStorageBackend _backend;
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
  Future<String?> read(String key) => _backend.read(_key(key));

  @override
  Future<void> write(String key, String value) =>
      _backend.write(_key(key), value);

  @override
  Future<void> delete(String key) => _backend.delete(_key(key));

  @override
  Future<void> clear() async {
    final all = await _backend.readAll();
    for (final key in all.keys.where((key) => key.startsWith(namespace))) {
      await _backend.delete(key);
    }
  }
}
