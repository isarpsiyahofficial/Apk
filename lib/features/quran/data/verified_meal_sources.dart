class VerifiedMealSource {
  const VerifiedMealSource({
    required this.locale,
    required this.translationKey,
    required this.publisher,
    required this.version,
    required this.canonicalSha256,
    required this.surahCount,
    required this.ayahCount,
  });

  final String locale;
  final String translationKey;
  final String publisher;
  final String version;
  final String canonicalSha256;
  final int surahCount;
  final int ayahCount;

  void validate({
    required String actualTranslationKey,
    required String actualVersion,
    required String actualSha256,
    required int actualSurahCount,
    required int actualAyahCount,
  }) {
    if (actualTranslationKey != translationKey) {
      throw StateError('Unexpected translation key for $locale');
    }
    if (actualVersion != version) {
      throw StateError('Unexpected translation version for $locale');
    }
    if (actualSha256.toLowerCase() != canonicalSha256) {
      throw StateError('Meal SHA-256 mismatch for $locale');
    }
    if (actualSurahCount != surahCount || actualAyahCount != ayahCount) {
      throw StateError('Incomplete meal dataset for $locale');
    }
  }
}

abstract final class VerifiedMealSources {
  static const turkish = VerifiedMealSource(
    locale: 'tr',
    translationKey: 'turkish_rwwad',
    publisher: 'Rowad Tercüme Merkezi',
    version: 'V1.0.4',
    canonicalSha256: 'a0c001b1e690cc022351d55b9951a7410fde4a6266638766c553fa91f401b1b7',
    surahCount: 114,
    ayahCount: 6236,
  );

  static const english = VerifiedMealSource(
    locale: 'en',
    translationKey: 'english_rwwad',
    publisher: 'Rowwad Translation Center',
    version: 'V1.0.19',
    canonicalSha256: '24c81ccfa5818e417b96f3b457955d34308a95d006a65c894ac69eaba580a3c0',
    surahCount: 114,
    ayahCount: 6236,
  );

  static const all = <VerifiedMealSource>[turkish, english];

  static VerifiedMealSource forLocale(String languageCode) {
    return switch (languageCode) {
      'tr' => turkish,
      'en' => english,
      _ => throw UnsupportedError('No verified bundled meal for $languageCode'),
    };
  }
}
