import 'package:flutter_test/flutter_test.dart';
import 'package:islami_hayat/features/prophets/data/canonical_prophets.dart';
import 'package:islami_hayat/features/prophets/data/prophet_semantic_gap_manifest_t0336.dart';
import 'package:islami_hayat/features/prophets/data/prophet_semantic_ownership_qa.dart';
import 'package:islami_hayat/features/prophets/data/prophet_semantic_unresolved_t0336.dart';

void main() {
  test('every canonical 25x8 slot has a verified or explicit unresolved record', () {
    final claims = canonicalProphetSemanticEvidenceWithUnresolvedT0336;

    for (final identity in canonicalQuranNamedProphets) {
      for (final dimension in ProphetSemanticDimension.values) {
        final records = claims.where(
          (claim) =>
              claim.biographyProphetId == identity.canonicalId &&
              claim.subjectProphetId == identity.canonicalId &&
              claim.dimension == dimension &&
              !claim.contextReference,
        );
        expect(
          records,
          isNotEmpty,
          reason: '${identity.canonicalId}/${dimension.name}',
        );
      }
    }
  });

  test('generated unresolved records are pending, sourceless and never verified', () {
    final generated = canonicalProphetSemanticEvidenceWithUnresolvedT0336.where(
      (claim) => claim.claimKey.endsWith(':pending-semantic-review'),
    );

    expect(generated, isNotEmpty);
    for (final claim in generated) {
      expect(claim.evidenceState, ProphetSemanticEvidenceState.pendingReview);
      expect(claim.sourceIds, isEmpty);
      expect(claim.sourceClasses, isEmpty);
      expect(claim.contextReference, isFalse);
      expect(claim.subjectProphetId, claim.biographyProphetId);
    }
  });

  test('unresolved materialization cannot inflate verified release coverage', () {
    final manifest = canonicalProphetSemanticGapManifestT0336;

    expect(manifest.requiredSlotCount, 200);
    expect(manifest.silentlyMissingSlotCount, 0);
    expect(manifest.explicitlyUnresolvedSlotCount, manifest.missingSlotCount);
    expect(manifest.isReleaseComplete, isFalse);
    expect(manifest.missingSlotCount, greaterThan(0));
  });

  test('existing historical-date unknown records are not duplicated as pending', () {
    final historicalDateRecords = canonicalProphetSemanticEvidenceWithUnresolvedT0336
        .where(
          (claim) => claim.dimension == ProphetSemanticDimension.historicalDate,
        )
        .toList(growable: false);

    expect(historicalDateRecords, hasLength(25));
    for (final claim in historicalDateRecords) {
      expect(claim.evidenceState, ProphetSemanticEvidenceState.unknown);
      expect(claim.claimKey, endsWith(':unknown'));
    }
  });

  test('ownership QA accepts unresolved metadata without treating it as coverage', () {
    const qa = ProphetSemanticOwnershipQa();
    final relaxed = qa.audit(
      claims: canonicalProphetSemanticEvidenceWithUnresolvedT0336,
      requireFull25Coverage: false,
    );
    final strict = qa.audit(
      claims: canonicalProphetSemanticEvidenceWithUnresolvedT0336,
    );

    expect(relaxed.isValid, isTrue);
    expect(strict.isValid, isFalse);
    expect(
      strict.errors.join('\n'),
      contains('semantic cross-check coverage missing'),
    );
  });
}
