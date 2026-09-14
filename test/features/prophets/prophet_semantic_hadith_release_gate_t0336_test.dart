import 'package:flutter_test/flutter_test.dart';
import 'package:islami_hayat/core/content/content_governance.dart';
import 'package:islami_hayat/features/prophets/data/canonical_prophets.dart';
import 'package:islami_hayat/features/prophets/data/prophet_hadith_evidence_t0336_batch32.dart';
import 'package:islami_hayat/features/prophets/data/prophet_hadith_evidence_t0336_batch33.dart';
import 'package:islami_hayat/features/prophets/data/prophet_hadith_evidence_t0336_batch34.dart';
import 'package:islami_hayat/features/prophets/data/prophet_hadith_evidence_t0336_batch35.dart';
import 'package:islami_hayat/features/prophets/data/prophet_hadith_evidence_t0336_batch36.dart';
import 'package:islami_hayat/features/prophets/data/prophet_hadith_evidence_t0336_batch37.dart';
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
      const expectedVerified = <String>{
        'adam',
        'ayyub',
        'dawud',
        'harun',
        'ibrahim',
        'idris',
        'isa',
        'lut',
        'muhammad',
        'musa',
        'nuh',
        'sulayman',
        'yahya',
        'yunus',
        'yusuf',
      };
      final expectedUnresolved = {...canonicalIds}..removeAll(expectedVerified);

      expect(hadith.verifiedCount, 15);
      expect(hadith.verifiedProphetIds.toSet(), expectedVerified);
      expect(hadith.unresolvedCount, 10);
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

    test('all admitted hadith evidence stays exact and owner-bound', () {
      final claims = <ProphetSemanticClaim>[
        ...canonicalProphetHadithEvidenceT0336,
        ...prophetHadithEvidenceT0336Batch32,
        ...prophetHadithEvidenceT0336Batch33,
        ...prophetHadithEvidenceT0336Batch34,
        ...prophetHadithEvidenceT0336Batch35,
        ...prophetHadithEvidenceT0336Batch36,
        ...prophetHadithEvidenceT0336Batch37,
      ];
      const expectedOwnerBySource = <String, String>{
        'sahih-muslim-854b-adam-friday': 'adam',
        'sahih-bukhari-3391-ayyub-blessing': 'ayyub',
        'sahih-bukhari-2072-dawud-manual-labour': 'dawud',
        'sahih-bukhari-3393-harun-night-journey': 'harun',
        'sahih-bukhari-3356-ibrahim-circumcision': 'ibrahim',
        'sahih-muslim-164a-idris-night-journey': 'idris',
        'sahih-bukhari-3442-isa-prophetic-succession': 'isa',
        'sahih-bukhari-3375-lut-support': 'lut',
        'sahih-bukhari-3410-musa-community': 'musa',
        'sahih-bukhari-3339-nuh-message-witness': 'nuh',
        'sahih-bukhari-3424-sulayman-inshaallah': 'sulayman',
        'sahih-muslim-164a-yahya-night-journey': 'yahya',
        'sahih-bukhari-3412-yunus-no-superiority': 'yunus',
        'sahih-bukhari-3390-yusuf-prophetic-lineage': 'yusuf',
        'sahih-muslim-1162e-muhammad-birth': 'muhammad',
        'sahih-bukhari-4449-muhammad-death': 'muhammad',
      };

      expect(claims, hasLength(expectedOwnerBySource.length));
      expect(
        claims.expand((claim) => claim.sourceIds).toSet(),
        expectedOwnerBySource.keys.toSet(),
      );
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
            biographyProphetId: 'muhammad',
            subjectProphetId: 'idris',
            dimension: ProphetSemanticDimension.hadith,
            claimKey: 'hadith:muhammad:borrowed-idris-report',
            sourceIds: ['sahih-muslim-164a-idris-night-journey'],
            sourceClasses: {ReligiousSourceClass.sahihHasanHadith},
          ),
          ProphetSemanticClaim(
            biographyProphetId: 'yusuf',
            subjectProphetId: 'muhammad',
            dimension: ProphetSemanticDimension.hadith,
            claimKey: 'hadith:yusuf:borrowed-muhammad-report',
            sourceIds: ['sahih-bukhari-4449-muhammad-death'],
            sourceClasses: {ReligiousSourceClass.sahihHasanHadith},
          ),
          ProphetSemanticClaim(
            biographyProphetId: 'isa',
            subjectProphetId: 'yahya',
            dimension: ProphetSemanticDimension.hadith,
            claimKey: 'hadith:isa:borrowed-yahya-report',
            sourceIds: ['sahih-muslim-164a-yahya-night-journey'],
            sourceClasses: {ReligiousSourceClass.sahihHasanHadith},
          ),
          ProphetSemanticClaim(
            biographyProphetId: 'ibrahim',
            subjectProphetId: 'lut',
            dimension: ProphetSemanticDimension.hadith,
            claimKey: 'hadith:ibrahim:borrowed-lut-report',
            sourceIds: ['sahih-bukhari-3375-lut-support'],
            sourceClasses: {ReligiousSourceClass.sahihHasanHadith},
          ),
        ],
      );
      expect(result.isValid, isFalse);
    });

    test('batch-34 to batch-37 builders reject owner/source tampering', () {
      expect(
        () => buildMusaHadithEvidenceT0336(biographyProphetId: 'harun'),
        throwsStateError,
      );
      expect(
        () => buildIsaHadithEvidenceT0336(subjectProphetId: 'muhammad'),
        throwsStateError,
      );
      expect(
        () => buildAyyubHadithEvidenceT0336(biographyProphetId: 'muhammad'),
        throwsStateError,
      );
      expect(
        () => buildSulaymanHadithEvidenceT0336(subjectProphetId: 'dawud'),
        throwsStateError,
      );
      expect(
        () => buildHarunHadithEvidenceT0336(subjectProphetId: 'musa'),
        throwsStateError,
      );
      expect(
        () => buildYunusHadithEvidenceT0336(biographyProphetId: 'muhammad'),
        throwsStateError,
      );
      expect(
        () => buildDawudHadithEvidenceT0336(subjectProphetId: 'sulayman'),
        throwsStateError,
      );
      expect(
        () => buildIdrisHadithEvidenceT0336(subjectProphetId: 'yahya'),
        throwsStateError,
      );
      expect(
        () => buildYahyaHadithEvidenceT0336(biographyProphetId: 'isa'),
        throwsStateError,
      );
      expect(
        () => buildLutHadithEvidenceT0336(subjectProphetId: 'ibrahim'),
        throwsStateError,
      );
      expect(
        () => buildHarunHadithEvidenceT0336(
          source: const SourceReference(
            id: 'sahih-bukhari-3393-harun-night-journey',
            title: 'Sahih al-Bukhari',
            sourceClass: ReligiousSourceClass.sahihHasanHadith,
            licenseId: 'REFERENCE-ONLY',
            locator: 'Sahih al-Bukhari 3394',
          ),
        ),
        throwsStateError,
      );
      expect(
        () => buildIdrisHadithEvidenceT0336(
          source: const SourceReference(
            id: 'sahih-muslim-164a-idris-night-journey',
            title: 'Sahih Muslim',
            sourceClass: ReligiousSourceClass.sahihHasanHadith,
            licenseId: 'REFERENCE-ONLY',
            locator: 'Sahih Muslim 164b',
          ),
        ),
        throwsStateError,
      );
      expect(
        () => buildLutHadithEvidenceT0336(
          source: const SourceReference(
            id: 'sahih-bukhari-3375-lut-support',
            title: 'Sahih al-Bukhari',
            sourceClass: ReligiousSourceClass.sahihHasanHadith,
            licenseId: 'UNKNOWN',
            locator: 'Sahih al-Bukhari 3375',
          ),
        ),
        throwsStateError,
      );
    });
  });
}
