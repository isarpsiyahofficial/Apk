import 'package:flutter_test/flutter_test.dart';
import 'package:islami_hayat/core/content/content_governance.dart';
import 'package:islami_hayat/features/prophets/data/canonical_prophets.dart';
import 'package:islami_hayat/features/prophets/data/prophet_hadith_evidence_t0336_batch32.dart';
import 'package:islami_hayat/features/prophets/data/prophet_hadith_evidence_t0336_batch33.dart';
import 'package:islami_hayat/features/prophets/data/prophet_hadith_evidence_t0336_batch34.dart';
import 'package:islami_hayat/features/prophets/data/prophet_hadith_evidence_t0336_batch35.dart';
import 'package:islami_hayat/features/prophets/data/prophet_hadith_evidence_t0336_batch36.dart';
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
        ..remove('ayyub')
        ..remove('dawud')
        ..remove('harun')
        ..remove('ibrahim')
        ..remove('nuh')
        ..remove('yusuf')
        ..remove('yunus')
        ..remove('musa')
        ..remove('isa')
        ..remove('sulayman')
        ..remove('muhammad');

      expect(hadith.verifiedCount, 12);
      expect(
        hadith.verifiedProphetIds.toSet(),
        {
          'adam',
          'ayyub',
          'dawud',
          'harun',
          'ibrahim',
          'nuh',
          'yusuf',
          'yunus',
          'musa',
          'isa',
          'sulayman',
          'muhammad',
        },
      );
      expect(hadith.unresolvedCount, 13);
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
        ...prophetHadithEvidenceT0336Batch34,
        ...prophetHadithEvidenceT0336Batch35,
        ...prophetHadithEvidenceT0336Batch36,
      ];
      expect(claims, hasLength(13));
      expect(
        claims.expand((claim) => claim.sourceIds).toSet(),
        {
          'sahih-muslim-854b-adam-friday',
          'sahih-bukhari-3391-ayyub-blessing',
          'sahih-bukhari-2072-dawud-manual-labour',
          'sahih-bukhari-3393-harun-night-journey',
          'sahih-bukhari-3356-ibrahim-circumcision',
          'sahih-bukhari-3339-nuh-message-witness',
          'sahih-bukhari-3390-yusuf-prophetic-lineage',
          'sahih-bukhari-3412-yunus-no-superiority',
          'sahih-bukhari-3410-musa-community',
          'sahih-bukhari-3442-isa-prophetic-succession',
          'sahih-bukhari-3424-sulayman-inshaallah',
          'sahih-muslim-1162e-muhammad-birth',
          'sahih-bukhari-4449-muhammad-death',
        },
      );

      final expectedOwnerBySource = <String, String>{
        'sahih-muslim-854b-adam-friday': 'adam',
        'sahih-bukhari-3391-ayyub-blessing': 'ayyub',
        'sahih-bukhari-2072-dawud-manual-labour': 'dawud',
        'sahih-bukhari-3393-harun-night-journey': 'harun',
        'sahih-bukhari-3356-ibrahim-circumcision': 'ibrahim',
        'sahih-bukhari-3339-nuh-message-witness': 'nuh',
        'sahih-bukhari-3390-yusuf-prophetic-lineage': 'yusuf',
        'sahih-bukhari-3412-yunus-no-superiority': 'yunus',
        'sahih-bukhari-3410-musa-community': 'musa',
        'sahih-bukhari-3442-isa-prophetic-succession': 'isa',
        'sahih-bukhari-3424-sulayman-inshaallah': 'sulayman',
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
            subjectProphetId: 'ayyub',
            dimension: ProphetSemanticDimension.hadith,
            claimKey: 'hadith:muhammad:borrowed-ayyub-report',
            sourceIds: ['sahih-bukhari-3391-ayyub-blessing'],
            sourceClasses: {ReligiousSourceClass.sahihHasanHadith},
          ),
          ProphetSemanticClaim(
            biographyProphetId: 'muhammad',
            subjectProphetId: 'dawud',
            dimension: ProphetSemanticDimension.hadith,
            claimKey: 'hadith:muhammad:borrowed-dawud-report',
            sourceIds: ['sahih-bukhari-2072-dawud-manual-labour'],
            sourceClasses: {ReligiousSourceClass.sahihHasanHadith},
          ),
          ProphetSemanticClaim(
            biographyProphetId: 'muhammad',
            subjectProphetId: 'harun',
            dimension: ProphetSemanticDimension.hadith,
            claimKey: 'hadith:muhammad:borrowed-harun-report',
            sourceIds: ['sahih-bukhari-3393-harun-night-journey'],
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
          ProphetSemanticClaim(
            biographyProphetId: 'muhammad',
            subjectProphetId: 'yunus',
            dimension: ProphetSemanticDimension.hadith,
            claimKey: 'hadith:muhammad:borrowed-yunus-report',
            sourceIds: ['sahih-bukhari-3412-yunus-no-superiority'],
            sourceClasses: {ReligiousSourceClass.sahihHasanHadith},
          ),
          ProphetSemanticClaim(
            biographyProphetId: 'muhammad',
            subjectProphetId: 'musa',
            dimension: ProphetSemanticDimension.hadith,
            claimKey: 'hadith:muhammad:borrowed-musa-report',
            sourceIds: ['sahih-bukhari-3410-musa-community'],
            sourceClasses: {ReligiousSourceClass.sahihHasanHadith},
          ),
          ProphetSemanticClaim(
            biographyProphetId: 'muhammad',
            subjectProphetId: 'isa',
            dimension: ProphetSemanticDimension.hadith,
            claimKey: 'hadith:muhammad:borrowed-isa-report',
            sourceIds: ['sahih-bukhari-3442-isa-prophetic-succession'],
            sourceClasses: {ReligiousSourceClass.sahihHasanHadith},
          ),
          ProphetSemanticClaim(
            biographyProphetId: 'muhammad',
            subjectProphetId: 'sulayman',
            dimension: ProphetSemanticDimension.hadith,
            claimKey: 'hadith:muhammad:borrowed-sulayman-report',
            sourceIds: ['sahih-bukhari-3424-sulayman-inshaallah'],
            sourceClasses: {ReligiousSourceClass.sahihHasanHadith},
          ),
        ],
      );

      expect(result.isValid, isFalse);
    });

    test('batch-34 to batch-36 builders reject owner/source tampering', () {
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
        () => buildYunusHadithEvidenceT0336(
          source: const SourceReference(
            id: 'sahih-bukhari-3412-yunus-no-superiority',
            title: 'Sahih al-Bukhari',
            sourceClass: ReligiousSourceClass.sahihHasanHadith,
            licenseId: 'REFERENCE-ONLY',
            locator: 'Sahih al-Bukhari 3413',
          ),
        ),
        throwsStateError,
      );
      expect(
        () => buildDawudHadithEvidenceT0336(
          source: const SourceReference(
            id: 'sahih-bukhari-2072-dawud-manual-labour',
            title: 'Sahih al-Bukhari',
            sourceClass: ReligiousSourceClass.sahihHasanHadith,
            licenseId: 'REFERENCE-ONLY',
            locator: 'Sahih al-Bukhari 2073',
          ),
        ),
        throwsStateError,
      );
    });
  });
}
