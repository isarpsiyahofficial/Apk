import 'package:islami_hayat/core/storage/secure_private_user_store.dart';
import 'package:islami_hayat/core/storage/user_data_repository.dart';
import 'package:islami_hayat/features/quran/data/canonical_quran_source.dart';

final class QuranVerseUserState {
  const QuranVerseUserState({
    required this.favoriteVerseIds,
    required this.bookmarkVerseIds,
  });

  const QuranVerseUserState.empty()
      : favoriteVerseIds = const <String>{},
        bookmarkVerseIds = const <String>{};

  final Set<String> favoriteVerseIds;
  final Set<String> bookmarkVerseIds;

  bool isFavorite({required int surah, required int ayah}) =>
      favoriteVerseIds.contains(quranVerseUserDataId(surah: surah, ayah: ayah));

  bool isBookmarked({required int surah, required int ayah}) =>
      bookmarkVerseIds.contains(quranVerseUserDataId(surah: surah, ayah: ayah));
}

String quranVerseUserDataId({required int surah, required int ayah}) {
  _validateQuranPosition(surah: surah, ayah: ayah);
  return 'quran:$surah:$ayah';
}

final class QuranVerseUserStateRepository {
  QuranVerseUserStateRepository([UserDataRepository? userDataRepository])
      : _userDataRepository = userDataRepository ??
            UserDataRepository(SecurePrivateUserStore());

  final UserDataRepository _userDataRepository;

  Future<QuranVerseUserState> load() async {
    final snapshot = await _userDataRepository.load();
    return QuranVerseUserState(
      favoriteVerseIds: Set<String>.unmodifiable(
        snapshot.favorites.where(_isCanonicalQuranVerseId),
      ),
      bookmarkVerseIds: Set<String>.unmodifiable(
        snapshot.bookmarks.where(_isCanonicalQuranVerseId),
      ),
    );
  }

  Future<QuranVerseUserState> toggleFavorite({
    required int surah,
    required int ayah,
  }) => _toggle(surah: surah, ayah: ayah, favorite: true);

  Future<QuranVerseUserState> toggleBookmark({
    required int surah,
    required int ayah,
  }) => _toggle(surah: surah, ayah: ayah, favorite: false);

  Future<QuranVerseUserState> _toggle({
    required int surah,
    required int ayah,
    required bool favorite,
  }) async {
    final id = quranVerseUserDataId(surah: surah, ayah: ayah);
    final snapshot = await _userDataRepository.load();
    final favorites = Set<String>.of(snapshot.favorites);
    final bookmarks = Set<String>.of(snapshot.bookmarks);
    final target = favorite ? favorites : bookmarks;

    if (!target.remove(id)) target.add(id);

    await _userDataRepository.save(
      UserDataSnapshot(
        favorites: favorites,
        bookmarks: bookmarks,
        notes: snapshot.notes,
        questionHistory: snapshot.questionHistory,
        dhikrTotals: snapshot.dhikrTotals,
        settings: snapshot.settings,
        entitlementCache: snapshot.entitlementCache,
      ),
    );

    return QuranVerseUserState(
      favoriteVerseIds: Set<String>.unmodifiable(
        favorites.where(_isCanonicalQuranVerseId),
      ),
      bookmarkVerseIds: Set<String>.unmodifiable(
        bookmarks.where(_isCanonicalQuranVerseId),
      ),
    );
  }
}

bool _isCanonicalQuranVerseId(String id) {
  final parts = id.split(':');
  if (parts.length != 3 || parts.first != 'quran') return false;
  final surah = int.tryParse(parts[1]);
  final ayah = int.tryParse(parts[2]);
  if (surah == null || ayah == null) return false;
  try {
    _validateQuranPosition(surah: surah, ayah: ayah);
    return true;
  } on RangeError {
    return false;
  }
}

void _validateQuranPosition({required int surah, required int ayah}) {
  if (surah < 1 || surah > canonicalQuranSuraCount) {
    throw RangeError.range(surah, 1, canonicalQuranSuraCount, 'surah');
  }
  final maxAyah = canonicalQuranAyahCountForSura(surah);
  if (ayah < 1 || ayah > maxAyah) {
    throw RangeError.range(ayah, 1, maxAyah, 'ayah');
  }
}
