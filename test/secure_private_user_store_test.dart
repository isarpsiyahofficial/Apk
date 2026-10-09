import 'package:flutter_test/flutter_test.dart';
import 'package:islami_hayat/core/storage/secure_private_user_store.dart';
import 'package:islami_hayat/core/storage/storage_boundaries.dart';

final class _MemorySecureBackend implements SecureStorageBackend {
  final Map<String, String> values = <String, String>{};

  @override
  Future<void> delete(String key) async => values.remove(key);

  @override
  Future<String?> read(String key) async => values[key];

  @override
  Future<Map<String, String>> readAll() async => Map.of(values);

  @override
  Future<void> write(String key, String value) async => values[key] = value;
}

void main() {
  test('private store namespaces and round-trips mutable user data', () async {
    final backend = _MemorySecureBackend();
    final store = SecurePrivateUserStore(backend: backend);

    expect(store.domain, StorageDomain.privateUserData);
    await store.write('bookmark.2.255', 'true');

    expect(await store.read('bookmark.2.255'), 'true');
    expect(backend.values['islami_hayat.private.bookmark.2.255'], 'true');
  });

  test('clear deletes only Islami Hayat private namespace', () async {
    final backend = _MemorySecureBackend();
    backend.values['other_app.key'] = 'keep';
    final store = SecurePrivateUserStore(backend: backend);

    await store.write('note.1', 'private note');
    await store.write('dhikr.today', '33');
    await store.clear();

    expect(await store.read('note.1'), isNull);
    expect(await store.read('dhikr.today'), isNull);
    expect(backend.values['other_app.key'], 'keep');
  });

  test('empty keys are rejected before reaching secure storage', () async {
    final store = SecurePrivateUserStore(backend: _MemorySecureBackend());

    expect(() => store.read('   '), throwsArgumentError);
  });
}
