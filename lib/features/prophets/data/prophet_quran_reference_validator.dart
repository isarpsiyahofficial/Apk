import '../../quran/data/canonical_quran_source.dart';
import 'canonical_prophet_biographies.dart';

final class ProphetQuranReferenceValidationResult {
  const ProphetQuranReferenceValidationResult({
    required this.prophetCount,
    required this.referenceCount,
  });

  final int prophetCount;
  final int referenceCount;
}

/// T0206 fail-closed cross validation between the canonical prophet biography
/// Quran-reference lists and the pinned canonical ayah database.
///
/// A `ProphetVerseReference` only performs a cheap structural check. This
/// validator is the authoritative dataset boundary: every reference must
/// resolve to the exact pinned ayah, each biography must retain its explicit
/// Quran-name anchor, duplicates are rejected, and the production cross-check
/// must cover exactly the 25 Quran-named canonical prophets.
final class ProphetQuranReferenceValidator {
  const ProphetQuranReferenceValidator();

  ProphetQuranReferenceValidationResult validate({
    required Iterable<CanonicalProphetBiographyDraft> drafts,
    required CanonicalQuranDataset quran,
    bool requireCanonicalSet = false,
  }) {
    final seenProphetIds = <String>{};
    var referenceCount = 0;

    for (final draft in drafts) {
      final canonicalId = draft.identity.canonicalId.trim();
      if (!draft.identity.isValid ||
          canonicalId.isEmpty ||
          !seenProphetIds.add(canonicalId)) {
        throw ProphetQuranReferenceValidationException(
          'Invalid or duplicate canonical prophet id: $canonicalId',
        );
      }
      if (draft.quranReferences.isEmpty) {
        throw ProphetQuranReferenceValidationException(
          'Prophet $canonicalId has no Quran references.',
        );
      }

      final seenReferences = <String>{};
      for (final reference in draft.quranReferences) {
        if (!reference.isValid || !seenReferences.add(reference.stableId)) {
          throw ProphetQuranReferenceValidationException(
            'Prophet $canonicalId has an invalid or duplicate Quran reference ${reference.stableId}.',
          );
        }

        final QuranAyah ayah;
        try {
          ayah = quran.ayah(reference.surah, reference.ayah);
        } on RangeError {
          throw ProphetQuranReferenceValidationException(
            'Prophet $canonicalId points outside the canonical Quran dataset: ${reference.stableId}.',
          );
        }

        if (ayah.sura != reference.surah ||
            ayah.ayah != reference.ayah ||
            ayah.key != reference.stableId ||
            ayah.arabic.trim().isEmpty) {
          throw ProphetQuranReferenceValidationException(
            'Canonical Quran lookup mismatch for $canonicalId at ${reference.stableId}.',
          );
        }
        referenceCount++;
      }

      final identityAnchor = draft.identity.explicitNameReference.stableId;
      if (!seenReferences.contains(identityAnchor)) {
        throw ProphetQuranReferenceValidationException(
          'Prophet $canonicalId is missing its explicit-name Quran anchor $identityAnchor.',
        );
      }
    }

    if (seenProphetIds.isEmpty || referenceCount == 0) {
      throw const ProphetQuranReferenceValidationException(
        'Prophet Quran cross-validation received an empty dataset.',
      );
    }
    if (requireCanonicalSet && seenProphetIds.length != 25) {
      throw ProphetQuranReferenceValidationException(
        'T0206 requires exactly 25 canonical prophet biographies; found ${seenProphetIds.length}.',
      );
    }

    return ProphetQuranReferenceValidationResult(
      prophetCount: seenProphetIds.length,
      referenceCount: referenceCount,
    );
  }

  Future<ProphetQuranReferenceValidationResult> validateBundledCanonicalDrafts({
    CanonicalQuranAssetLoader? loader,
  }) async {
    final quran = await (loader ?? CanonicalQuranAssetLoader()).load();
    return validate(
      drafts: canonicalProphetBiographyDrafts,
      quran: quran,
      requireCanonicalSet: true,
    );
  }
}

final class ProphetQuranReferenceValidationException implements Exception {
  const ProphetQuranReferenceValidationException(this.message);

  final String message;

  @override
  String toString() => 'ProphetQuranReferenceValidationException: $message';
}
