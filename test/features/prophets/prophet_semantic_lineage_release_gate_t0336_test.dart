import 'package:flutter_test/flutter_test.dart';
import 'package:islami_hayat/core/content/content_governance.dart';
import 'package:islami_hayat/features/prophets/data/prophet_semantic_evidence_t0336.dart';
import 'package:islami_hayat/features/prophets/data/prophet_semantic_gap_manifest_t0336.dart';
import 'package:islami_hayat/features/prophets/data/prophet_semantic_ownership_qa.dart';
import 'package:islami_hayat/features/prophets/data/prophet_semantic_release_backlog_t0336.dart';
import 'package:islami_hayat/features/prophets/data/verified_prophet_family_relations.dart';

void main() {
  group('T0336 family-lineage release gate', () {
    test('verified and unresolved lineage owner sets stay exact', () {
      final lineage = canonicalProphetSemanticReleaseBacklogT0336.singleWhere(
        (entry) => entry.dimension == ProphetSemanticDimension.familyLineage,
      );

      const expectedVerified = <String>{
        'ibrahim',
        'ismail',
        'ishaq',
        'yakub',
        'yusuf',
        'musa',
        'harun',
        'dawud',
        'sulayman',
        'zakariya',
        'yahya',
      };
      const expectedUnresolved = <String>{
        'adam',
        'idris',
        'nuh',
        'hud',
        'salih',
        'lut',
        'ayyub',
        'shuayb',
        'ilyas',
        'alyasa',
        'yunus',
        'isa',
        'muhammad',
        'dhul_kifl',
      };

      expect(lineage.verifiedCount, 11);
      expect(lineage.unresolvedCount, 14);
      expect(lineage.verifiedProphetIds.toSet(), expectedVerified);
      expect(lineage.unresolvedProphetIds.toSet(), expectedUnresolved);
      expect(lineage.isComplete, isFalse);

      for (final prophetId in expectedUnresolved) {
        final slot = canonicalProphetSemanticGapManifestT0336.slotFor(
          prophetId,
          ProphetSemanticDimension.familyLineage,
        );
        expect(
          slot.hasExplicitUnresolvedEvidence,
          isTrue,
          reason: '$prophetId lineage must remain an explicit research gap',
        );
      }
    });

    test('admitted lineage facts stay Quran-backed and chronology-consistent', () {
      expect(verifiedProphetFamilyGraphIsValid, isTrue);
      expect(verifiedProphetFamilyChronologyIsConsistent, isTrue);
      expect(canonicalProphetFamilyLineageEvidenceT0336, hasLength(14));

      for (final claim in canonicalProphetFamilyLineageEvidenceT0336) {
        expect(claim.dimension, ProphetSemanticDimension.familyLineage);
        expect(claim.evidenceState, ProphetSemanticEvidenceState.verified);
        expect(claim.contextReference, isFalse);
        expect(claim.subjectProphetId, claim.biographyProphetId);
        expect(claim.sourceIds, isNotEmpty);
        expect(claim.sourceClasses, {ReligiousSourceClass.quran});
      }
    });

    test('natural family mention cannot transfer lineage ownership', () {
      const qa = ProphetSemanticOwnershipQa();
      final result = qa.audit(
        requireFull25Coverage: false,
        claims: const [
          ProphetSemanticClaim(
            biographyProphetId: 'muhammad',
            subjectProphetId: 'musa',
            dimension: ProphetSemanticDimension.familyLineage,
            claimKey: 'familyLineage:muhammad:borrowed-musa-harun',
            sourceIds: ['tanzil-uthmani-v1.1-q20-30'],
            sourceClasses: {ReligiousSourceClass.quran},
          ),
          ProphetSemanticClaim(
            biographyProphetId: 'isa',
            subjectProphetId: 'yahya',
            dimension: ProphetSemanticDimension.familyLineage,
            claimKey: 'familyLineage:isa:borrowed-zakariya-yahya',
            sourceIds: ['tanzil-uthmani-v1.1-q19-7'],
            sourceClasses: {ReligiousSourceClass.quran},
          ),
        ],
      );

      expect(result.isValid, isFalse);
    });
  });
}
