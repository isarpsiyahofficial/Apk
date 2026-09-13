import 'package:flutter_test/flutter_test.dart';
import 'package:islami_hayat/core/storage/storage_boundaries.dart';
import 'package:islami_hayat/core/storage/user_data_repository.dart';
import 'package:islami_hayat/features/quran/data/quran_reflection_note_repository.dart';

final class _MemoryPrivateStore implements PrivateUserStore {
  final Map<String, String> values = <String, String>{};

  @override
  StorageDomain get domain => StorageDomain.privateUserData;

  @override
  Future<void> clear() async => values.clear();

  @override
  Future<void> delete(String key) async => values.remove(key);

  @override
  Future<String?> read(String key) async => values[key];

  @override
  Future<void> write(String key, String value) async => values[key] = value;
}

void main() {
  test('reflection note round-trips only through private user data', () async {
    final store = _MemoryPrivateStore();
    final userDataRepository = UserDataRepository(store);
    final repository = QuranReflectionNoteRepository(userDataRepository);

    await repository.saveNote(
      surah: 2,
      ayah: 255,
      text: 'Bu ayet üzerine kişisel tefekkür notum.',
    );

    expect(
      await repository.loadNote(surah: 2, ayah: 255),
      'Bu ayet üzerine kişisel tefekkür notum.',
    );
    final snapshot = await userDataRepository.load();
    expect(snapshot.notes['quran:2:255'], isNotNull);
  });

  test('editing a note preserves unrelated private user domains', () async {
    final store = _MemoryPrivateStore();
    final userDataRepository = UserDataRepository(store);
    await userDataRepository.save(
      const UserDataSnapshot(
        favorites: {'quran:2:255'},
        bookmarks: {'quran:18:10'},
        notes: {'quran:1:1': 'old'},
        questionHistory: ['history'],
        dhikrTotals: {'subhanallah': 33},
        settings: {'locale': 'tr'},
        entitlementCache: {'state': 'pro'},
      ),
    );
    final repository = QuranReflectionNoteRepository(userDataRepository);

    await repository.saveNote(surah: 1, ayah: 1, text: 'new');
    final snapshot = await userDataRepository.load();

    expect(snapshot.notes['quran:1:1'], 'new');
    expect(snapshot.favorites, {'quran:2:255'});
    expect(snapshot.bookmarks, {'quran:18:10'});
    expect(snapshot.questionHistory, ['history']);
    expect(snapshot.dhikrTotals['subhanallah'], 33);
    expect(snapshot.entitlementCache['state'], 'pro');
  });

  test('delete removes only the selected Quran note', () async {
    final store = _MemoryPrivateStore();
    final userDataRepository = UserDataRepository(store);
    final repository = QuranReflectionNoteRepository(userDataRepository);
    await repository.saveNote(surah: 1, ayah: 1, text: 'first');
    await repository.saveNote(surah: 2, ayah: 255, text: 'second');

    await repository.deleteNote(surah: 1, ayah: 1);

    expect(await repository.loadNote(surah: 1, ayah: 1), isNull);
    expect(await repository.loadNote(surah: 2, ayah: 255), 'second');
  });

  test('blank save is treated as delete and invalid verse fails closed', () async {
    final repository = QuranReflectionNoteRepository(
      UserDataRepository(_MemoryPrivateStore()),
    );
    await repository.saveNote(surah: 1, ayah: 1, text: 'temporary');
    await repository.saveNote(surah: 1, ayah: 1, text: '   ');
    expect(await repository.loadNote(surah: 1, ayah: 1), isNull);

    expect(
      repository.saveNote(surah: 1, ayah: 8, text: 'invalid'),
      throwsRangeError,
    );
  });
}
