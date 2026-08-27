import 'package:flutter_test/flutter_test.dart';
import 'package:islami_hayat/features/quran/data/verified_meal_sources.dart';

void main() {
  test('pins verified Turkish and English QuranEnc meal contracts', () {
    expect(VerifiedMealSources.all, hasLength(2));

    expect(VerifiedMealSources.turkish.translationKey, 'turkish_rwwad');
    expect(VerifiedMealSources.turkish.version, 'V1.0.4');
    expect(VerifiedMealSources.turkish.surahCount, 114);
    expect(VerifiedMealSources.turkish.ayahCount, 6236);

    expect(VerifiedMealSources.english.translationKey, 'english_rwwad');
    expect(VerifiedMealSources.english.version, 'V1.0.19');
    expect(VerifiedMealSources.english.surahCount, 114);
    expect(VerifiedMealSources.english.ayahCount, 6236);
  });

  test('accepts the exact verified Turkish contract', () {
    final source = VerifiedMealSources.turkish;
    expect(
      () => source.validate(
        actualTranslationKey: source.translationKey,
        actualVersion: source.version,
        actualSha256: source.canonicalSha256,
        actualSurahCount: source.surahCount,
        actualAyahCount: source.ayahCount,
      ),
      returnsNormally,
    );
  });

  test('fails closed on meal hash, version or coverage mismatch', () {
    final source = VerifiedMealSources.english;

    expect(
      () => source.validate(
        actualTranslationKey: source.translationKey,
        actualVersion: source.version,
        actualSha256: '0' * 64,
        actualSurahCount: source.surahCount,
        actualAyahCount: source.ayahCount,
      ),
      throwsStateError,
    );
    expect(
      () => source.validate(
        actualTranslationKey: source.translationKey,
        actualVersion: 'V0',
        actualSha256: source.canonicalSha256,
        actualSurahCount: source.surahCount,
        actualAyahCount: source.ayahCount,
      ),
      throwsStateError,
    );
    expect(
      () => source.validate(
        actualTranslationKey: source.translationKey,
        actualVersion: source.version,
        actualSha256: source.canonicalSha256,
        actualSurahCount: 114,
        actualAyahCount: 6235,
      ),
      throwsStateError,
    );
  });

  test('does not silently fall back for unsupported meal locales', () {
    expect(() => VerifiedMealSources.forLocale('ar'), throwsUnsupportedError);
  });
}
