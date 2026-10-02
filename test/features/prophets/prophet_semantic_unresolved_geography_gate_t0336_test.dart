import 'package:flutter_test/flutter_test.dart';
import 'package:islami_hayat/core/content/content_governance.dart';
import 'package:islami_hayat/features/prophets/data/prophet_semantic_evidence_t0336.dart';
import 'package:islami_hayat/features/prophets/data/prophet_semantic_gap_manifest_t0336.dart';
import 'package:islami_hayat/features/prophets/data/prophet_semantic_ownership_qa.dart';
import 'package:islami_hayat/features/prophets/data/prophet_semantic_release_backlog_t0336.dart';

void main() {
  group('T0336 unresolved geography release gate', () {
    test('verified and unresolved geography owner sets stay exact', () {
      final geography = canonicalProphetSemanticReleaseBacklogT0336.singleWhere(
        (entry) => entry.dimension == ProphetSemanticDimension.geography,
      );

      const expectedVerified = <String>{
        'salih',
        'lut',
        'hud',
        'harun',
        'nuh',
        'ibrahim',
        'ismail',
        'yusuf',
        'shuayb',
        'musa',
        'isa',
        'muhammad',
        'yakub',
        'yunus',
        'ayyub',
        'sulayman',
        'zakariya',
        'dawud',
      };
      const expectedUnresolved = <String>{
        'adam',
        'idris',
        'ishaq',
        'ilyas',
        'alyasa',
        'yahya',
        'dhul_kifl',
      };

      expect(geography.verifiedCount, 18);
      expect(geography.unresolvedCount, 7);
      expect(geography.verifiedProphetIds.toSet(), expectedVerified);
      expect(geography.unresolvedProphetIds.toSet(), expectedUnresolved);
      expect(geography.isComplete, isFalse);

      for (final prophetId in expectedUnresolved) {
        final slot = canonicalProphetSemanticGapManifestT0336.slotFor(
          prophetId,
          ProphetSemanticDimension.geography,
        );
        expect(
          slot.hasExplicitUnresolvedEvidence,
          isTrue,
          reason: '$prophetId must remain explicit rather than becoming a silent gap',
        );
      }
    });

    test('all admitted geography evidence remains Quran-owned and self-owned', () {
      expect(canonicalProphetGeographyEvidenceT0336, hasLength(18));
      for (final claim in canonicalProphetGeographyEvidenceT0336) {
        expect(claim.dimension, ProphetSemanticDimension.geography);
        expect(claim.evidenceState, ProphetSemanticEvidenceState.verified);
        expect(claim.contextReference, isFalse);
        expect(claim.subjectProphetId, claim.biographyProphetId);
        expect(claim.sourceIds, isNotEmpty);
        expect(claim.sourceClasses, {ReligiousSourceClass.quran});
      }
    });

    test('an unresolved geography cannot be promoted by cross-owner evidence', () {
      const qa = ProphetSemanticOwnershipQa();
      final result = qa.audit(
        requireFull25Coverage: false,
        claims: const [
          ProphetSemanticClaim(
            biographyProphetId: 'yahya',
            subjectProphetId: 'zakariya',
            dimension: ProphetSemanticDimension.geography,
            claimKey: 'geography:yahya:borrowed-sanctuary',
            sourceIds: [
              'tanzil-uthmani-v1.1-zakariya-q3-38-39-sanctuary-geography',
            ],
            sourceClasses: {ReligiousSourceClass.quran},
          ),
          ProphetSemanticClaim(
            biographyProphetId: 'ishaq',
            subjectProphetId: 'ibrahim',
            dimension: ProphetSemanticDimension.geography,
            claimKey: 'geography:ishaq:borrowed-kaaba',
            sourceIds: [
              'tanzil-uthmani-v1.1-ibrahim-q2-127-kaaba-geography',
            ],
            sourceClasses: {ReligiousSourceClass.quran},
          ),
        ],
      );

      expect(result.isValid, isFalse);
    });
  });
}
