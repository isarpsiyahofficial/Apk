import 'package:flutter_test/flutter_test.dart';
import 'package:islami_hayat/core/content/content_governance.dart';
import 'package:islami_hayat/features/prophets/data/canonical_prophets.dart';
import 'package:islami_hayat/features/prophets/data/prophet_hadith_evidence_t0336_batch32.dart';
import 'package:islami_hayat/features/prophets/data/prophet_semantic_evidence_t0336.dart';
import 'package:islami_hayat/features/prophets/data/prophet_semantic_gap_manifest_t0336.dart';
import 'package:islami_hayat/features/prophets/data/prophet_semantic_ownership_qa.dart';
import 'package:islami_hayat/features/prophets/data/prophet_semantic_release_backlog_t0336.dart';

void main() {
  group('T0336 hadith release gate', () {
    test('only source-reviewed hadith owners contribute verified coverage', () {
      final hadith = canonicalProphetSemanticReleaseBacklogT0336.singleWhere(
        (entry) => entry.dimension == ProphetSemanticDimension.hadith,
      );
      final canonicalIds = canonicalQuranNamedProphets
          .map((identity) => identity.canonicalId)
          .toSet();
      final expectedUnresolved = {...canonicalIds}
        ..remove('adam')
        ..remove('ibrahim')
        ..remove('muhammad');

      expect(hadith.verifiedCount, 3);
      expect(hadith.verifiedProphetIds.toSet(), {'adam', 'ibrahim', 'muhammad'});
      expect(hadith.unresolvedCount, 22);
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

    test('T0194 and batch-32 hadith evidence stays exact and owner-bound', () {
      final claims = <ProphetSemanticClaim>[
        ...canonicalProphetHadithEvidenceT0336,
        ...prophetHadithEvidenceT0336Batch32,
      ];
      expect(claims, hasLength(4));
      expect(
        claims.expand((claim) => claim.sourceIds).toSet(),
        {
          'sahih-muslim-854b-adam-friday',
          'sahih-bukhari-3356-ibrahim-circumcision',
          'sahih-muslim-1162e-muhammad-birth',
          'sahih-bukhari-4449-muhammad-death',
        },
      );

      final ibrahim = claims.singleWhere(
        (claim) => claim.sourceIds
            .contains('sahih-bukhari-3356-ibrahim-circumcision'),
      );
      expect(ibrahim.biographyProphetId, 'ibrahim');
      expect(ibrahim.subjectProphetId, 'ibrahim');

      for (final claim in claims) {
        expect(claim.biographyProphetId, claim.subjectProphetId);
        expect(claim.dimension, ProphetSemanticDimension.hadith);
        expect(claim.evidenceState, ProphetSemanticEvidenceState.verified);
        expect(claim.contextReference, isFalse);
        expect(claim.sourceClasses, {ReligiousSourceClass.sahihHasanHadith});
      }
    });

    test('hadith evidence cannot be borrowed as another prophet ownership', () {
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
          ProphetSemanticClaim(
            biographyProphetId: 'muhammad',
            subjectProphetId: 'adam',
            dimension: ProphetSemanticDimension.hadith,
            claimKey: 'hadith:muhammad:borrowed-adam-report',
            sourceIds: ['sahih-muslim-854b-adam-friday'],
            sourceClasses: {ReligiousSourceClass.sahihHasanHadith},
          ),
          ProphetSemanticClaim(
            biographyProphetId: 'muhammad',
            subjectProphetId: 'ibrahim',
            dimension: ProphetSemanticDimension.hadith,
            claimKey: 'hadith:muhammad:borrowed-ibrahim-report',
            sourceIds: ['sahih-bukhari-3356-ibrahim-circumcision'],
            sourceClasses: {ReligiousSourceClass.sahihHasanHadith},
          ),
        ],
      );

      expect(result.isValid, isFalse);
    });
  });
}
