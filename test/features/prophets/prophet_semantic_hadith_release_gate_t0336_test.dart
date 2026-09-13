import 'package:flutter_test/flutter_test.dart';
import 'package:islami_hayat/core/content/content_governance.dart';
import 'package:islami_hayat/features/prophets/data/canonical_prophets.dart';
import 'package:islami_hayat/features/prophets/data/prophet_hadith_evidence_t0336_batch32.dart';
import 'package:islami_hayat/features/prophets/data/prophet_hadith_evidence_t0336_batch33.dart';
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
        ..remove('nuh')
        ..remove('yusuf')
        ..remove('muhammad');

      expect(hadith.verifiedCount, 5);
      expect(
        hadith.verifiedProphetIds.toSet(),
        {'adam', 'ibrahim', 'nuh', 'yusuf', 'muhammad'},
      );
      expect(hadith.unresolvedCount, 20);
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

    test('T0194 and batch hadith evidence stays exact and owner-bound', () {
      final claims = <ProphetSemanticClaim>[
        ...canonicalProphetHadithEvidenceT0336,
        ...prophetHadithEvidenceT0336Batch32,
        ...prophetHadithEvidenceT0336Batch33,
      ];
      expect(claims, hasLength(6));
      expect(
        claims.expand((claim) => claim.sourceIds).toSet(),
        {
          'sahih-muslim-854b-adam-friday',
          'sahih-bukhari-3356-ibrahim-circumcision',
          'sahih-bukhari-3339-nuh-message-witness',
          'sahih-bukhari-3390-yusuf-prophetic-lineage',
          'sahih-muslim-1162e-muhammad-birth',
          'sahih-bukhari-4449-muhammad-death',
        },
      );

      final expectedOwnerBySource = <String, String>{
        'sahih-muslim-854b-adam-friday': 'adam',
        'sahih-bukhari-3356-ibrahim-circumcision': 'ibrahim',
        'sahih-bukhari-3339-nuh-message-witness': 'nuh',
        'sahih-bukhari-3390-yusuf-prophetic-lineage': 'yusuf',
        'sahih-muslim-1162e-muhammad-birth': 'muhammad',
        'sahih-bukhari-4449-muhammad-death': 'muhammad',
      };

      for (final claim in claims) {
        expect(claim.sourceIds, hasLength(1));
        expect(
          claim.biographyProphetId,
          expectedOwnerBySource[claim.sourceIds.single],
        );
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
          ProphetSemanticClaim(
            biographyProphetId: 'muhammad',
            subjectProphetId: 'nuh',
            dimension: ProphetSemanticDimension.hadith,
            claimKey: 'hadith:muhammad:borrowed-nuh-report',
            sourceIds: ['sahih-bukhari-3339-nuh-message-witness'],
            sourceClasses: {ReligiousSourceClass.sahihHasanHadith},
          ),
          ProphetSemanticClaim(
            biographyProphetId: 'muhammad',
            subjectProphetId: 'yusuf',
            dimension: ProphetSemanticDimension.hadith,
            claimKey: 'hadith:muhammad:borrowed-yusuf-report',
            sourceIds: ['sahih-bukhari-3390-yusuf-prophetic-lineage'],
            sourceClasses: {ReligiousSourceClass.sahihHasanHadith},
          ),
        ],
      );

      expect(result.isValid, isFalse);
    });
  });
}