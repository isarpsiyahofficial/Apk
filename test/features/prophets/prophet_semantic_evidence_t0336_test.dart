import 'package:flutter_test/flutter_test.dart';
import 'package:islami_hayat/core/content/content_governance.dart';
import 'package:islami_hayat/features/prophets/data/canonical_prophets.dart';
import 'package:islami_hayat/features/prophets/data/prophet_semantic_evidence_t0336.dart';
import 'package:islami_hayat/features/prophets/data/prophet_semantic_ownership_qa.dart';
import 'package:islami_hayat/features/prophets/data/verified_prophet_family_relations.dart';

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

  test('T0336 lineage slice is derived only from reviewed genealogy facts', () {
    expect(verifiedProphetFamilyGraphIsValid, isTrue);
    expect(verifiedProphetKinshipFacts, hasLength(2));
    expect(canonicalProphetFamilyLineageEvidenceT0336, hasLength(4));

    final coveredProphets = canonicalProphetFamilyLineageEvidenceT0336
        .map((claim) => claim.biographyProphetId)
        .toSet();
    expect(coveredProphets, {'musa', 'harun', 'zakariya', 'yahya'});

    for (final claim in canonicalProphetFamilyLineageEvidenceT0336) {
      expect(claim.subjectProphetId, claim.biographyProphetId);
      expect(claim.dimension, ProphetSemanticDimension.familyLineage);
      expect(claim.contextReference, isFalse);
      expect(claim.evidenceState, ProphetSemanticEvidenceState.verified);
      expect(claim.sourceIds, isNotEmpty);
      expect(claim.sourceClasses, {ReligiousSourceClass.quran});
      expect(
        claim.claimKey,
        startsWith('familyLineage:${claim.biographyProphetId}:'),
      );

      final matchingFact = verifiedProphetKinshipFacts.singleWhere(
        (fact) => claim.claimKey.endsWith(':${fact.id}'),
      );
      expect(
        claim.sourceIds,
        matchingFact.sources.map((source) => source.id).toList(),
      );
    }
  });

  test('current canonical T0336 evidence is internally valid', () {
    expect(canonicalProphetSemanticEvidenceT0336, hasLength(54));

    final result = qa.audit(
      claims: canonicalProphetSemanticEvidenceT0336,
      requireFull25Coverage: false,
    );

    expect(result.errors, isEmpty);
    expect(result.isValid, isTrue);
  });

  test('reviewed lineage bridge cannot falsely complete 25x8 release gate', () {
    final result = qa.audit(claims: canonicalProphetSemanticEvidenceT0336);

    expect(result.isValid, isFalse);
    final errors = result.errors.join('\n');
    expect(errors, contains('semantic cross-check coverage missing'));
    expect(errors, contains('event'));
    expect(errors, contains('hadith'));
    expect(errors, contains('chronology'));
    expect(errors, contains('geography'));
    expect(errors, contains('historicalDate'));

    // A prophet without an independently reviewed genealogy must still report
    // the lineage gap instead of receiving inferred ancestry.
    final adamError = result.errors.singleWhere(
      (error) => error.startsWith('adam: semantic cross-check coverage missing'),
    );
    expect(adamError, contains('familyLineage'));

    // Prophets covered by the conservative graph no longer report that one
    // dimension, while all remaining dimensions stay fail-closed.
    final musaError = result.errors.singleWhere(
      (error) => error.startsWith('musa: semantic cross-check coverage missing'),
    );
    expect(musaError, isNot(contains('familyLineage')));
    expect(musaError, contains('event'));
  });
}
