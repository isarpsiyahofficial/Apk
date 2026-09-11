import 'package:flutter_test/flutter_test.dart';
import 'package:islami_hayat/core/content/content_governance.dart';
import 'package:islami_hayat/features/prophets/data/canonical_prophets.dart';
import 'package:islami_hayat/features/prophets/data/prophet_semantic_gap_manifest_t0336.dart';
import 'package:islami_hayat/features/prophets/data/prophet_semantic_ownership_qa.dart';

void main() {
  test('T0336 gap manifest exposes exactly 25 x 8 auditable slots', () {
    final manifest = canonicalProphetSemanticGapManifestT0336;

    expect(canonicalQuranNamedProphets, hasLength(25));
    expect(manifest.requiredSlotCount, 200);
    expect(manifest.slots, hasLength(200));
    expect(manifest.verifiedSlotCount + manifest.missingSlotCount, 200);
    expect(manifest.isReleaseComplete, isFalse);

    for (final identity in canonicalQuranNamedProphets) {
      for (final dimension in ProphetSemanticDimension.values) {
        expect(
          manifest.slotFor(identity.canonicalId, dimension).prophetId,
          identity.canonicalId,
        );
      }
    }
  });

  test('verified slots expose exact claim keys and source ids', () {
    final manifest = canonicalProphetSemanticGapManifestT0336;
    final adamIdentity =
        manifest.slotFor('adam', ProphetSemanticDimension.identity);
    final adamVerse =
        manifest.slotFor('adam', ProphetSemanticDimension.quranVerse);

    expect(adamIdentity.isVerified, isTrue);
    expect(adamIdentity.verifiedClaimKeys, contains('identity:adam'));
    expect(adamIdentity.sourceIds, contains('tanzil-uthmani-v1.1'));
    expect(adamIdentity.gapReason, isEmpty);

    expect(adamVerse.isVerified, isTrue);
    expect(adamVerse.sourceIds, contains('tanzil-uthmani-v1.1'));
  });

  test('missing historical dates remain explicit gaps instead of inferred facts', () {
    final manifest = canonicalProphetSemanticGapManifestT0336;

    for (final identity in canonicalQuranNamedProphets) {
      final date = manifest.slotFor(
        identity.canonicalId,
        ProphetSemanticDimension.historicalDate,
      );
      expect(date.isVerified, isFalse, reason: identity.canonicalId);
      expect(date.verifiedClaimKeys, isEmpty, reason: identity.canonicalId);
      expect(date.sourceIds, isEmpty, reason: identity.canonicalId);
      expect(date.gapReason, contains('No biography-owned'));
    }
  });

  test('pending or unknown evidence never converts a gap to verified', () {
    const unresolved = [
      ProphetSemanticClaim(
        biographyProphetId: 'adam',
        subjectProphetId: 'adam',
        dimension: ProphetSemanticDimension.historicalDate,
        claimKey: 'historicalDate:adam:unknown',
        sourceIds: [],
        evidenceState: ProphetSemanticEvidenceState.unknown,
      ),
      ProphetSemanticClaim(
        biographyProphetId: 'adam',
        subjectProphetId: 'adam',
        dimension: ProphetSemanticDimension.familyLineage,
        claimKey: 'familyLineage:adam:pending',
        sourceIds: [],
        evidenceState: ProphetSemanticEvidenceState.pendingReview,
      ),
    ];

    final manifest = buildProphetSemanticGapManifestT0336(claims: unresolved);

    expect(
      manifest.slotFor('adam', ProphetSemanticDimension.historicalDate).isVerified,
      isFalse,
    );
    expect(
      manifest.slotFor('adam', ProphetSemanticDimension.familyLineage).isVerified,
      isFalse,
    );
  });

  test('natural contextual mention cannot satisfy another prophets biography slot', () {
    const claims = [
      ProphetSemanticClaim(
        biographyProphetId: 'muhammad',
        subjectProphetId: 'musa',
        dimension: ProphetSemanticDimension.event,
        claimKey: 'event:muhammad:mentions-musa',
        sourceIds: ['tanzil-uthmani-v1.1'],
        sourceClasses: {ReligiousSourceClass.quran},
        contextReference: true,
      ),
    ];

    final manifest = buildProphetSemanticGapManifestT0336(claims: claims);

    expect(
      manifest.slotFor('muhammad', ProphetSemanticDimension.event).isVerified,
      isFalse,
    );
    expect(
      manifest.slotFor('musa', ProphetSemanticDimension.event).isVerified,
      isFalse,
    );
  });

  test('wrong event ownership fails closed before manifest generation', () {
    expect(
      () => buildProphetSemanticGapManifestT0336(
        claims: const [
          ProphetSemanticClaim(
            biographyProphetId: 'muhammad',
            subjectProphetId: 'yusuf',
            dimension: ProphetSemanticDimension.event,
            claimKey: 'yusuf_well_and_egypt',
            sourceIds: ['tanzil-uthmani-v1.1'],
            sourceClasses: {ReligiousSourceClass.quran},
          ),
        ],
      ),
      throwsStateError,
    );
  });

  test('a Quran source cannot be relabelled as verified hadith evidence', () {
    expect(
      () => buildProphetSemanticGapManifestT0336(
        claims: const [
          ProphetSemanticClaim(
            biographyProphetId: 'adam',
            subjectProphetId: 'adam',
            dimension: ProphetSemanticDimension.hadith,
            claimKey: 'hadith:adam:fake-class',
            sourceIds: ['tanzil-uthmani-v1.1'],
            sourceClasses: {ReligiousSourceClass.quran},
          ),
        ],
      ),
      throwsStateError,
    );
  });
}
