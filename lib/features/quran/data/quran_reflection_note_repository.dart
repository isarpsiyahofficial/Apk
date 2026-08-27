import 'package:islami_hayat/core/storage/secure_private_user_store.dart';
import 'package:islami_hayat/core/storage/user_data_repository.dart';
import 'package:islami_hayat/features/quran/data/quran_verse_user_state_repository.dart';

abstract interface class QuranReflectionNoteDataSource {
  Future<String?> loadNote({required int surah, required int ayah});

  Future<void> saveNote({
    required int surah,
    required int ayah,
    required String text,
  });

  Future<void> deleteNote({required int surah, required int ayah});
}

final class QuranReflectionNoteRepository
    implements QuranReflectionNoteDataSource {
  QuranReflectionNoteRepository([UserDataRepository? userDataRepository])
      : _userDataRepository = userDataRepository ??
            UserDataRepository(SecurePrivateUserStore());

  final UserDataRepository _userDataRepository;

  @override
  Future<String?> loadNote({required int surah, required int ayah}) async {
    final id = quranVerseUserDataId(surah: surah, ayah: ayah);
    final snapshot = await _userDataRepository.load();
    return snapshot.notes[id];
  }

  @override
  Future<void> saveNote({
    required int surah,
    required int ayah,
    required String text,
  }) async {
    final id = quranVerseUserDataId(surah: surah, ayah: ayah);
    final snapshot = await _userDataRepository.load();
    final notes = Map<String, String>.of(snapshot.notes);
    if (text.trim().isEmpty) {
      notes.remove(id);
    } else {
      notes[id] = text;
    }
    await _saveWithNotes(snapshot, notes);
  }

  @override
  Future<void> deleteNote({required int surah, required int ayah}) async {
    final id = quranVerseUserDataId(surah: surah, ayah: ayah);
    final snapshot = await _userDataRepository.load();
    final notes = Map<String, String>.of(snapshot.notes)..remove(id);
    await _saveWithNotes(snapshot, notes);
  }

  Future<void> _saveWithNotes(
    UserDataSnapshot snapshot,
    Map<String, String> notes,
  ) {
    return _userDataRepository.save(
      UserDataSnapshot(
        favorites: snapshot.favorites,
        bookmarks: snapshot.bookmarks,
        notes: notes,
        questionHistory: snapshot.questionHistory,
        dhikrTotals: snapshot.dhikrTotals,
        settings: snapshot.settings,
        entitlementCache: snapshot.entitlementCache,
      ),
    );
  }
}
