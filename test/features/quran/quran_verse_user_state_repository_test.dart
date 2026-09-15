import 'package:flutter_test/flutter_test.dart';
import 'package:islami_hayat/core/storage/storage_boundaries.dart';
import 'package:islami_hayat/core/storage/user_data_repository.dart';
import 'package:islami_hayat/features/quran/data/quran_verse_user_state_repository.dart';

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
  test('starts with no Quran favorites or bookmarks', () async {
    final repository = QuranVerseUserStateRepository(
      UserDataRepository(_MemoryPrivateStore()),
    );

    final state = await repository.load();

    expect(state.favoriteVerseIds, isEmpty);
    expect(state.bookmarkVerseIds, isEmpty);
  });

  test('favorite toggles on and off without changing bookmarks', () async {
    final store = _MemoryPrivateStore();
    final userDataRepository = UserDataRepository(store);
    final repository = QuranVerseUserStateRepository(userDataRepository);

    var state = await repository.toggleFavorite(surah: 2, ayah: 255);
    expect(state.isFavorite(surah: 2, ayah: 255), isTrue);
    expect(state.isBookmarked(surah: 2, ayah: 255), isFalse);

    state = await repository.toggleFavorite(surah: 2, ayah: 255);
    expect(state.isFavorite(surah: 2, ayah: 255), isFalse);

    final persisted = await userDataRepository.load();
    expect(persisted.favorites, isEmpty);
    expect(persisted.bookmarks, isEmpty);
  });

  test('bookmark and favorite can coexist for the same canonical verse', () async {
    final repository = QuranVerseUserStateRepository(
      UserDataRepository(_MemoryPrivateStore()),
    );

    await repository.toggleFavorite(surah: 18, ayah: 10);
    final state = await repository.toggleBookmark(surah: 18, ayah: 10);

    expect(state.isFavorite(surah: 18, ayah: 10), isTrue);
    expect(state.isBookmarked(surah: 18, ayah: 10), isTrue);
  });

  test('mutations preserve unrelated private user data', () async {
    final store = _MemoryPrivateStore();
    final userDataRepository = UserDataRepository(store);
    await userDataRepository.save(
      const UserDataSnapshot(
        favorites: <String>{},
        bookmarks: <String>{},
        notes: {'quran:1:1': 'not'},
        questionHistory: ['history'],
        dhikrTotals: {'subhanallah': 33},
        settings: {'locale': 'tr'},
        entitlementCache: {'state': 'pro'},
      ),
    );
    final repository = QuranVerseUserStateRepository(userDataRepository);

    await repository.toggleBookmark(surah: 1, ayah: 1);
    final persisted = await userDataRepository.load();

    expect(persisted.notes['quran:1:1'], 'not');
    expect(persisted.questionHistory, ['history']);
    expect(persisted.dhikrTotals['subhanallah'], 33);
    expect(persisted.settings['locale'], 'tr');
    expect(persisted.entitlementCache['state'], 'pro');
  });

  test('invalid Quran positions fail closed before persistence', () async {
    final repository = QuranVerseUserStateRepository(
      UserDataRepository(_MemoryPrivateStore()),
    );

    expect(
      () => repository.toggleFavorite(surah: 1, ayah: 8),
      throwsRangeError,
    );
    expect(
      () => quranVerseUserDataId(surah: 115, ayah: 1),
      throwsRangeError,
    );
  });

  test('non-Quran private favorites stay stored but are excluded from Quran state',
      () async {
    final store = _MemoryPrivateStore();
    final userDataRepository = UserDataRepository(store);
    await userDataRepository.save(
      const UserDataSnapshot(
        favorites: {'dua:morning', 'quran:2:255', 'quran:1:8'},
        bookmarks: {'history:event:1'},
        notes: <String, String>{},
        questionHistory: <String>[],
        dhikrTotals: <String, int>{},
        settings: <String, String>{},
        entitlementCache: <String, String>{},
      ),
    );

    final state = await QuranVerseUserStateRepository(userDataRepository).load();

    expect(state.favoriteVerseIds, {'quran:2:255'});
    expect(state.bookmarkVerseIds, isEmpty);
    final persisted = await userDataRepository.load();
    expect(persisted.favorites, contains('dua:morning'));
  });
}
