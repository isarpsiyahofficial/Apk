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

final class ProphetQuranReferenceValidator {
  const ProphetQuranReferenceValidator();

  ProphetQuranReferenceValidationResult validate({
    required Iterable<CanonicalProphetBiographyDraft> drafts,
    required CanonicalQuranDataset quran,
  }) {
    final seenProphetIds = <String>{};
    var referenceCount = 0;

    for (final draft in drafts) {
      final canonicalId = draft.identity.canonicalId.trim();
      if (canonicalId.isEmpty || !seenProphetIds.add(canonicalId)) {
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
        if (!seenReferences.add(reference.stableId)) {
          throw ProphetQuranReferenceValidationException(
            'Prophet $canonicalId has duplicate Quran reference ${reference.stableId}.',
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
    }

    if (seenProphetIds.isEmpty || referenceCount == 0) {
      throw const ProphetQuranReferenceValidationException(
        'Prophet Quran cross-validation received an empty dataset.',
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
    return validate(drafts: canonicalProphetBiographyDrafts, quran: quran);
  }
}

final class ProphetQuranReferenceValidationException implements Exception {
  const ProphetQuranReferenceValidationException(this.message);

  final String message;

  @override
  String toString() => 'ProphetQuranReferenceValidationException: $message';
}
