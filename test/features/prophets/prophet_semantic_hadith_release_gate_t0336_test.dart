import 'package:flutter_test/flutter_test.dart';
import 'package:islami_hayat/core/content/content_governance.dart';
import 'package:islami_hayat/features/prophets/data/canonical_prophets.dart';
import 'package:islami_hayat/features/prophets/data/prophet_semantic_evidence_t0336.dart';
import 'package:islami_hayat/features/prophets/data/prophet_semantic_gap_manifest_t0336.dart';
import 'package:islami_hayat/features/prophets/data/prophet_semantic_ownership_qa.dart';
import 'package:islami_hayat/features/prophets/data/prophet_semantic_release_backlog_t0336.dart';

void main() {
  group('T0336 hadith release gate', () {
    test('only admitted T0194 hadith owner contributes verified coverage', () {
      final hadith = canonicalProphetSemanticReleaseBacklogT0336.singleWhere(
        (entry) => entry.dimension == ProphetSemanticDimension.hadith,
      );
      final canonicalIds = canonicalQuranNamedProphets
          .map((identity) => identity.canonicalId)
          .toSet();
      final expectedUnresolved = {...canonicalIds}..remove('muhammad');

      expect(hadith.verifiedCount, 1);
      expect(hadith.verifiedProphetIds.toSet(), {'muhammad'});
      expect(hadith.unresolvedCount, 24);
      expect(hadith.unresolvedProphetIds.toSet(), expectedUnresolved);
      expect(hadith.isComplete, isFalse);

      for (final prophetId in expectedUnresolved) {
        final slot = canonicalProphetSemanticGapManifestT0336.slotFor(
          prophetId,
          ProphetSemanticDimension.hadith,
        );
        expect(
          slot.hasExplicitUnresolvedEvidence,
          isTrue,
          reason: '$prophetId hadith must remain explicit pending research',
        );
      }
    });

    test('admitted hadith evidence stays exact, strong and Muhammad-owned', () {
      final claims = canonicalProphetHadithEvidenceT0336;
      expect(claims, hasLength(2));
      expect(
        claims.expand((claim) => claim.sourceIds).toSet(),
        {
          'sahih-muslim-1162e-muhammad-birth',
          'sahih-bukhari-4449-muhammad-death',
        },
      );

      for (final claim in claims) {
        expect(claim.biographyProphetId, 'muhammad');
        expect(claim.subjectProphetId, 'muhammad');
        expect(claim.dimension, ProphetSemanticDimension.hadith);
        expect(claim.evidenceState, ProphetSemanticEvidenceState.verified);
        expect(claim.contextReference, isFalse);
        expect(claim.sourceClasses, {ReligiousSourceClass.sahihHasanHadith});
      }
    });

    test('hadith mentioning another prophet cannot be borrowed as ownership', () {
      const qa = ProphetSemanticOwnershipQa();
      final result = qa.audit(
        requireFull25Coverage: false,
        claims: const [
          ProphetSemanticClaim(
            biographyProphetId: 'yusuf',
            subjectProphetId: 'muhammad',
            dimension: ProphetSemanticDimension.hadith,
            claimKey: 'hadith:yusuf:borrowed-muhammad-report',
            sourceIds: ['sahih-bukhari-4449-muhammad-death'],
            sourceClasses: {ReligiousSourceClass.sahihHasanHadith},
          ),
        ],
      );

      expect(result.isValid, isFalse);
    });
  });
}
