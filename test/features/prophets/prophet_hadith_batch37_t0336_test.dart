import 'package:flutter_test/flutter_test.dart';
import 'package:islami_hayat/core/content/content_governance.dart';
import 'package:islami_hayat/features/prophets/data/prophet_hadith_evidence_t0336_batch37.dart';
import 'package:islami_hayat/features/prophets/data/prophet_semantic_coverage_report_t0336.dart';
import 'package:islami_hayat/features/prophets/data/prophet_semantic_gap_manifest_t0336.dart';
import 'package:islami_hayat/features/prophets/data/prophet_semantic_ownership_qa.dart';
import 'package:islami_hayat/features/prophets/data/prophet_semantic_release_gate_t0336.dart';

void main() {
  group('T0336 hadith batch37 provenance', () {
    test('Idris, Yahya and Lut sources are exact reference-only sahih metadata', () {
      expect(idrisNightJourneyHadithSourceT0336.title, 'Sahih Muslim');
      expect(idrisNightJourneyHadithSourceT0336.locator, 'Sahih Muslim 164a');
      expect(idrisNightJourneyHadithSourceT0336.licenseId, 'REFERENCE-ONLY');
      expect(
        idrisNightJourneyHadithSourceT0336.sourceClass,
        ReligiousSourceClass.sahihHasanHadith,
      );

      expect(yahyaNightJourneyHadithSourceT0336.title, 'Sahih Muslim');
      expect(yahyaNightJourneyHadithSourceT0336.locator, 'Sahih Muslim 164a');
      expect(yahyaNightJourneyHadithSourceT0336.licenseId, 'REFERENCE-ONLY');
      expect(
        yahyaNightJourneyHadithSourceT0336.sourceClass,
        ReligiousSourceClass.sahihHasanHadith,
      );

      expect(lutSupportHadithSourceT0336.title, 'Sahih al-Bukhari');
      expect(lutSupportHadithSourceT0336.locator, 'Sahih al-Bukhari 3375');
      expect(lutSupportHadithSourceT0336.licenseId, 'REFERENCE-ONLY');
      expect(
        lutSupportHadithSourceT0336.sourceClass,
        ReligiousSourceClass.sahihHasanHadith,
      );
    });

    test('shared-context mentions cannot transfer biography ownership', () {
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
    });

    test('source metadata tampering fails closed', () {
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

    test('canonical coverage admits the three owners without dimension leakage', () {
      const expectedSources = <String, String>{
        'idris': 'sahih-muslim-164a-idris-night-journey',
        'yahya': 'sahih-muslim-164a-yahya-night-journey',
        'lut': 'sahih-bukhari-3375-lut-support',
      };

      for (final entry in expectedSources.entries) {
        final row = canonicalProphetCoverageReportT0336.rowFor(entry.key);
        final slot = canonicalProphetSemanticGapManifestT0336.slotFor(
          entry.key,
          ProphetSemanticDimension.hadith,
        );
        expect(row.covered, contains(ProphetSemanticDimension.hadith));
        expect(slot.isVerified, isTrue);
        expect(slot.sourceIds, contains(entry.value));
        expect(slot.unresolvedClaimKeys, isEmpty);
      }

      for (final claim in prophetHadithEvidenceT0336Batch37) {
        expect(claim.dimension, ProphetSemanticDimension.hadith);
        expect(claim.dimension == ProphetSemanticDimension.familyLineage, isFalse);
        expect(claim.dimension == ProphetSemanticDimension.historicalDate, isFalse);
        expect(claim.dimension == ProphetSemanticDimension.geography, isFalse);
        expect(claim.dimension == ProphetSemanticDimension.chronology, isFalse);
      }

      expect(canonicalProphetSemanticReleaseGateT0336.isValid, isTrue);
      expect(canonicalProphetSemanticReleaseGateT0336.isReleaseComplete, isFalse);
    });
  });
}
