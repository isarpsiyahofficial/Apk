import 'package:flutter_test/flutter_test.dart';
import 'package:islami_hayat/core/content/content_governance.dart';
import 'package:islami_hayat/features/prophets/data/prophet_hadith_evidence_t0336_batch39.dart';
import 'package:islami_hayat/features/prophets/data/prophet_semantic_coverage_report_t0336.dart';
import 'package:islami_hayat/features/prophets/data/prophet_semantic_gap_manifest_t0336.dart';
import 'package:islami_hayat/features/prophets/data/prophet_semantic_ownership_qa.dart';
import 'package:islami_hayat/features/prophets/data/prophet_semantic_release_gate_t0336.dart';

void main() {
  group('T0336 hadith batch39 shared-report ownership', () {
    test('Ishaq and Yakub use exact distinct provenance ids for Bukhari 3390', () {
      expect(ishaqPropheticLineageHadithSourceT0336.title, 'Sahih al-Bukhari');
      expect(
        ishaqPropheticLineageHadithSourceT0336.locator,
        'Sahih al-Bukhari 3390',
      );
      expect(ishaqPropheticLineageHadithSourceT0336.licenseId, 'REFERENCE-ONLY');
      expect(
        yakubPropheticLineageHadithSourceT0336.locator,
        'Sahih al-Bukhari 3390',
      );
      expect(yakubPropheticLineageHadithSourceT0336.licenseId, 'REFERENCE-ONLY');
      expect(
        ishaqPropheticLineageHadithSourceT0336.id,
        isNot(yakubPropheticLineageHadithSourceT0336.id),
      );
    });

    test('shared hadith cannot be reassigned to another biography subject', () {
      expect(
        () => buildIshaqHadithEvidenceT0336(subjectProphetId: 'yusuf'),
        throwsStateError,
      );
      expect(
        () => buildYakubHadithEvidenceT0336(biographyProphetId: 'yusuf'),
        throwsStateError,
      );
    });

    test('source metadata tampering fails closed', () {
      expect(
        () => buildIshaqHadithEvidenceT0336(
          source: const SourceReference(
            id: 'sahih-bukhari-3390-ishaq-prophetic-lineage',
            title: 'Sahih al-Bukhari',
            sourceClass: ReligiousSourceClass.sahihHasanHadith,
            licenseId: 'REFERENCE-ONLY',
            locator: 'Sahih al-Bukhari 3389',
          ),
        ),
        throwsStateError,
      );
      expect(
        () => buildYakubHadithEvidenceT0336(
          source: const SourceReference(
            id: 'sahih-bukhari-3390-yakub-prophetic-lineage',
            title: 'Sahih al-Bukhari',
            sourceClass: ReligiousSourceClass.quran,
            licenseId: 'REFERENCE-ONLY',
            locator: 'Sahih al-Bukhari 3390',
          ),
        ),
        throwsStateError,
      );
    });

    test('canonical coverage admits both owners without dimension leakage', () {
      const expectedSources = <String, String>{
        'ishaq': 'sahih-bukhari-3390-ishaq-prophetic-lineage',
        'yakub': 'sahih-bukhari-3390-yakub-prophetic-lineage',
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

      for (final claim in prophetHadithEvidenceT0336Batch39) {
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
