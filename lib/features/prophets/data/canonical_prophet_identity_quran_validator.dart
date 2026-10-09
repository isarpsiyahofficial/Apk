import '../../quran/data/canonical_quran_source.dart';
import 'canonical_prophets.dart';

final class CanonicalProphetIdentityQuranValidationResult {
  const CanonicalProphetIdentityQuranValidationResult({
    required this.identityCount,
    required this.validatedAnchorCount,
  });

  final int identityCount;
  final int validatedAnchorCount;
}

/// Fail-closed T0191 validation for the canonical 25-name registry.
///
/// Structural verse coordinates are not sufficient evidence that an identity
/// anchor actually names the intended prophet. This validator resolves each
/// anchor against the pinned Quran dataset and requires the Arabic verse to
/// contain the prophet's name (or an explicitly documented grammatical Quran
/// surface form).
final class CanonicalProphetIdentityQuranValidator {
  const CanonicalProphetIdentityQuranValidator();

  static const _quranSurfaceFormOverrides = <String, Set<String>>{
    // Quran 21:85 uses the accusative/genitive surface form "ذا الكفل" while
    // the canonical Arabic display name is the nominative "ذو الكفل".
    'dhul_kifl': {'ذا الكفل'},
  };

  CanonicalProphetIdentityQuranValidationResult validate({
    required Iterable<CanonicalProphetIdentity> identities,
    required CanonicalQuranDataset quran,
  }) {
    final seenIds = <String>{};
    var validatedAnchorCount = 0;

    for (final identity in identities) {
      if (!identity.isValid || !seenIds.add(identity.canonicalId)) {
        throw CanonicalProphetIdentityQuranValidationException(
          'Invalid or duplicate canonical prophet identity: ${identity.canonicalId}',
        );
      }

      final reference = identity.explicitNameReference;
      final QuranAyah ayah;
      try {
        ayah = quran.ayah(reference.surah, reference.ayah);
      } on RangeError {
        throw CanonicalProphetIdentityQuranValidationException(
          '${identity.canonicalId} points outside the pinned Quran dataset: ${reference.stableId}',
        );
      }

      final normalizedVerse = _normalizeArabic(ayah.arabic);
      final expectedForms = <String>{
        identity.arabicName,
        ...?_quranSurfaceFormOverrides[identity.canonicalId],
      }.map(_normalizeArabic).where((value) => value.isNotEmpty);

      if (!expectedForms.any(normalizedVerse.contains)) {
        throw CanonicalProphetIdentityQuranValidationException(
          '${identity.canonicalId} anchor ${reference.stableId} does not explicitly contain the canonical Arabic name.',
        );
      }
      validatedAnchorCount++;
    }

    if (seenIds.length != 25 || validatedAnchorCount != 25) {
      throw CanonicalProphetIdentityQuranValidationException(
        'T0191 requires exactly 25 Quran-named canonical identities; found ${seenIds.length}.',
      );
    }

    return CanonicalProphetIdentityQuranValidationResult(
      identityCount: seenIds.length,
      validatedAnchorCount: validatedAnchorCount,
    );
  }

  Future<CanonicalProphetIdentityQuranValidationResult> validateBundled({
    CanonicalQuranAssetLoader? loader,
  }) async {
    final quran = await (loader ?? CanonicalQuranAssetLoader()).load();
    return validate(identities: canonicalQuranNamedProphets, quran: quran);
  }

  static String _normalizeArabic(String value) {
    // Tanzil's Uthmani text can omit an ordinary display-spelling letter in
    // favour of a Quranic orthographic mark. Preserve only forms that actually
    // replace that letter before stripping recitation marks: dagger alif and
    // small high yeh (for example Salih 11:61 and Ibrahim 2:124).
    //
    // Do not promote every small Quranic sign into a full letter. For example
    // Dawud 2:251 already contains the ordinary waw plus a small-waw recitation
    // sign; converting that sign too would fabricate a duplicate letter.
    // Quran source bytes themselves are never changed.
    return value
        .replaceAll('\u0670', 'ا')
        .replaceAll('\u06E7', 'ي')
        .replaceAll(RegExp(r'[\u0610-\u061A\u064B-\u065F\u06D6-\u06ED]'), '')
        .replaceAll('\u0640', '')
        .replaceAll(RegExp('[أإآٱ]'), 'ا')
        .replaceAll('ء', '')
        .replaceAll(RegExp(r'\s+'), ' ')
        .trim();
  }
}

final class CanonicalProphetIdentityQuranValidationException implements Exception {
  const CanonicalProphetIdentityQuranValidationException(this.message);

  final String message;

  @override
  String toString() =>
      'CanonicalProphetIdentityQuranValidationException: $message';
}
