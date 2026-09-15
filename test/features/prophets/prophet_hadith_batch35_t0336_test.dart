import 'package:flutter_test/flutter_test.dart';
import 'package:islami_hayat/core/content/content_governance.dart';
import 'package:islami_hayat/features/prophets/data/prophet_hadith_evidence_t0336_batch35.dart';
import 'package:islami_hayat/features/prophets/data/prophet_semantic_coverage_report_t0336.dart';
import 'package:islami_hayat/features/prophets/data/prophet_semantic_gap_manifest_t0336.dart';
import 'package:islami_hayat/features/prophets/data/prophet_semantic_ownership_qa.dart';
import 'package:islami_hayat/features/prophets/data/prophet_semantic_release_gate_t0336.dart';

void main() {
  group('T0336 hadith batch35 provenance', () {
    test('Ayyub and Sulayman sources are exact reference-only sahih metadata', () {
      expect(ayyubBlessingHadithSourceT0336.title, 'Sahih al-Bukhari');
      expect(
        ayyubBlessingHadithSourceT0336.locator,
        'Sahih al-Bukhari 3391',
      );
      expect(ayyubBlessingHadithSourceT0336.licenseId, 'REFERENCE-ONLY');
      expect(
        ayyubBlessingHadithSourceT0336.sourceClass,
        ReligiousSourceClass.sahihHasanHadith,
      );

      expect(sulaymanInshaAllahHadithSourceT0336.title, 'Sahih al-Bukhari');
      expect(
        sulaymanInshaAllahHadithSourceT0336.locator,
        'Sahih al-Bukhari 3424',
      );
      expect(sulaymanInshaAllahHadithSourceT0336.licenseId, 'REFERENCE-ONLY');
      expect(
        sulaymanInshaAllahHadithSourceT0336.sourceClass,
        ReligiousSourceClass.sahihHasanHadith,
      );
    });

    test('ownership and source metadata tampering fail closed', () {
      expect(
        () => buildAyyubHadithEvidenceT0336(biographyProphetId: 'muhammad'),
        throwsStateError,
      );
      expect(
        () => buildSulaymanHadithEvidenceT0336(subjectProphetId: 'dawud'),
        throwsStateError,
        reason:
            'Dawud is a natural family/context reference but the hadith fact remains Sulayman-owned',
      );
      expect(
        () => buildAyyubHadithEvidenceT0336(
          source: const SourceReference(
            id: 'sahih-bukhari-3391-ayyub-blessing',
            title: 'Sahih al-Bukhari',
            sourceClass: ReligiousSourceClass.sahihHasanHadith,
            licenseId: 'REFERENCE-ONLY',
            locator: 'Sahih al-Bukhari 3392',
          ),
        ),
        throwsStateError,
      );
      expect(
        () => buildSulaymanHadithEvidenceT0336(
          source: const SourceReference(
            id: 'sahih-bukhari-3424-sulayman-inshaallah',
            title: 'Sahih al-Bukhari',
            sourceClass: ReligiousSourceClass.sahihHasanHadith,
            licenseId: 'UNKNOWN',
            locator: 'Sahih al-Bukhari 3424',
          ),
        ),
        throwsStateError,
      );
    });

    test('canonical coverage and manifest admit exact hadith ownership only', () {
      final expectedSources = <String, String>{
        'ayyub': 'sahih-bukhari-3391-ayyub-blessing',
        'sulayman': 'sahih-bukhari-3424-sulayman-inshaallah',
      };

      for (final entry in expectedSources.entries) {
        final coverage = canonicalProphetCoverageReportT0336.rowFor(entry.key);
        final slot = canonicalProphetSemanticGapManifestT0336.slotFor(
          entry.key,
          ProphetSemanticDimension.hadith,
        );

        expect(coverage.covered, contains(ProphetSemanticDimension.hadith));
        expect(slot.isVerified, isTrue);
        expect(slot.sourceIds, contains(entry.value));
        expect(slot.unresolvedClaimKeys, isEmpty);
      }
    });

    test('hadith evidence cannot silently promote other semantic dimensions', () {
      for (final claim in prophetHadithEvidenceT0336Batch35) {
        expect(claim.dimension, ProphetSemanticDimension.hadith);
        expect(
          claim.dimension == ProphetSemanticDimension.familyLineage,
          isFalse,
        );
        expect(
          claim.dimension == ProphetSemanticDimension.historicalDate,
          isFalse,
        );
        expect(
          claim.dimension == ProphetSemanticDimension.geography,
          isFalse,
        );
        expect(
          claim.dimension == ProphetSemanticDimension.chronology,
          isFalse,
        );
      }

      expect(canonicalProphetSemanticReleaseGateT0336.isValid, isTrue);
      expect(canonicalProphetSemanticReleaseGateT0336.isReleaseComplete, isFalse);
    });
  });
}
