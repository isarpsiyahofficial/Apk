import 'package:flutter_test/flutter_test.dart';
import 'package:islami_hayat/core/privacy/local_personal_data_reset_t0304.dart';
import 'package:islami_hayat/core/storage/storage_boundaries.dart';

void main() {
  test('reset clears every private-user key, including unknown future keys', () async {
    final store = _MemoryPrivateStore()
      ..values.addAll(<String, String>{
        'user.snapshot.v1': '{sensitive}',
        'privacy.questionHistory.enabled.v1': 'true',
        'privacy.questionHistory.entries.v1': '["question"]',
        'notification.preferences.v2': '{notification}',
        'quran.reflection.note.2:255': 'private note',
        'dhikr.history.v1': '[1,2,3]',
        'premium.entitlement.cache.v1': '{cached}',
        'future.private.key': 'must also disappear',
      });

    await LocalPersonalDataResetT0304(store).resetAll();

    expect(store.values, isEmpty);
    expect(store.clearCalls, 1);
  });

  test('constructor rejects a store outside the private-user boundary', () {
    expect(
      () => LocalPersonalDataResetT0304(_WrongDomainStore()),
      throwsStateError,
    );
  });
}

class _MemoryPrivateStore implements PrivateUserStore {
  final Map<String, String> values = <String, String>{};
  int clearCalls = 0;

  @override
  StorageDomain get domain => StorageDomain.privateUserData;

  @override
  Future<void> clear() async {
    clearCalls += 1;
    values.clear();
  }

  @override
  Future<void> delete(String key) async => values.remove(key);

  @override
  Future<String?> read(String key) async => values[key];

  @override
  Future<void> write(String key, String value) async => values[key] = value;
}

final class _WrongDomainStore extends _MemoryPrivateStore {
  @override
  StorageDomain get domain => StorageDomain.trustedContent;
}
