import 'package:flutter_test/flutter_test.dart';
import 'package:islami_hayat/features/prophets/data/canonical_prophets.dart';
import 'package:islami_hayat/features/prophets/data/prophet_semantic_evidence_t0336.dart';
import 'package:islami_hayat/features/prophets/data/prophet_semantic_ownership_qa.dart';

void main() {
  const qa = ProphetSemanticOwnershipQa();

  test('canonical registry contributes identity + Quran verse for all 25', () {
    expect(canonicalQuranNamedProphets, hasLength(25));
    expect(canonicalProphetIdentityVerseEvidenceT0336, hasLength(50));

    for (final identity in canonicalQuranNamedProphets) {
      final claims = canonicalProphetIdentityVerseEvidenceT0336
          .where((claim) => claim.biographyProphetId == identity.canonicalId)
          .toList(growable: false);
      expect(claims, hasLength(2), reason: identity.canonicalId);
      expect(
        claims.map((claim) => claim.dimension).toSet(),
        {
          ProphetSemanticDimension.identity,
          ProphetSemanticDimension.quranVerse,
        },
        reason: identity.canonicalId,
      );

      final verseClaim = claims.singleWhere(
        (claim) => claim.dimension == ProphetSemanticDimension.quranVerse,
      );
      expect(
        verseClaim.claimKey,
        contains(
          'q${identity.explicitNameReference.surah}_${identity.explicitNameReference.ayah}',
        ),
        reason: identity.canonicalId,
      );
    }
  });

  test('canonical identity/verse slice is internally valid', () {
    final result = qa.audit(
      claims: canonicalProphetIdentityVerseEvidenceT0336,
      requireFull25Coverage: false,
    );

    expect(result.errors, isEmpty);
    expect(result.isValid, isTrue);
  });

  test('identity/verse evidence cannot falsely complete 25x8 release gate', () {
    final result = qa.audit(
      claims: canonicalProphetIdentityVerseEvidenceT0336,
    );

    expect(result.isValid, isFalse);
    final errors = result.errors.join('\n');
    expect(errors, contains('semantic cross-check coverage missing'));
    expect(errors, contains('event'));
    expect(errors, contains('hadith'));
    expect(errors, contains('familyLineage'));
    expect(errors, contains('chronology'));
    expect(errors, contains('geography'));
    expect(errors, contains('historicalDate'));
  });
}
