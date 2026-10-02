import 'package:flutter_test/flutter_test.dart';
import 'package:islami_hayat/core/content/content_governance.dart';
import 'package:islami_hayat/features/prophets/data/prophet_hadith_evidence_t0336_batch33.dart';
import 'package:islami_hayat/features/prophets/data/prophet_semantic_coverage_report_t0336.dart';
import 'package:islami_hayat/features/prophets/data/prophet_semantic_gap_manifest_t0336.dart';
import 'package:islami_hayat/features/prophets/data/prophet_semantic_ownership_qa.dart';
import 'package:islami_hayat/features/prophets/data/prophet_semantic_release_gate_t0336.dart';

void main() {
  group('T0336 hadith batch33 provenance', () {
    test('Nuh and Yusuf sources are exact reference-only sahih metadata', () {
      expect(nuhMessageWitnessHadithSourceT0336.title, 'Sahih al-Bukhari');
      expect(nuhMessageWitnessHadithSourceT0336.locator, 'Sahih al-Bukhari 3339');
      expect(nuhMessageWitnessHadithSourceT0336.licenseId, 'REFERENCE-ONLY');
      expect(
        nuhMessageWitnessHadithSourceT0336.sourceClass,
        ReligiousSourceClass.sahihHasanHadith,
      );

      expect(yusufLineageHadithSourceT0336.title, 'Sahih al-Bukhari');
      expect(yusufLineageHadithSourceT0336.locator, 'Sahih al-Bukhari 3390');
      expect(yusufLineageHadithSourceT0336.licenseId, 'REFERENCE-ONLY');
      expect(
        yusufLineageHadithSourceT0336.sourceClass,
        ReligiousSourceClass.sahihHasanHadith,
      );
    });

    test('ownership and source metadata tampering fail closed', () {
      expect(
        () => buildNuhHadithEvidenceT0336(biographyProphetId: 'muhammad'),
        throwsStateError,
      );
      expect(
        () => buildYusufHadithEvidenceT0336(subjectProphetId: 'muhammad'),
        throwsStateError,
      );
      expect(
        () => buildYusufHadithEvidenceT0336(
          source: const SourceReference(
            id: 'sahih-bukhari-3390-yusuf-prophetic-lineage',
            title: 'Sahih al-Bukhari',
            sourceClass: ReligiousSourceClass.sahihHasanHadith,
            licenseId: 'REFERENCE-ONLY',
            locator: 'Sahih al-Bukhari 3391',
          ),
        ),
        throwsStateError,
      );
    });

    test('canonical T0336 views admit only the hadith dimension', () {
      for (final prophetId in const <String>['nuh', 'yusuf']) {
        final coverage = canonicalProphetCoverageReportT0336.rowFor(prophetId);
        final slot = canonicalProphetSemanticGapManifestT0336.slotFor(
          prophetId,
          ProphetSemanticDimension.hadith,
        );

        expect(coverage.covered, contains(ProphetSemanticDimension.hadith));
        expect(slot.isVerified, isTrue);
        expect(slot.sourceIds, isNotEmpty);
      }

      final yusufHadith = prophetHadithEvidenceT0336Batch33.singleWhere(
        (claim) => claim.biographyProphetId == 'yusuf',
      );
      expect(yusufHadith.dimension, ProphetSemanticDimension.hadith);
      expect(
        yusufHadith.dimension == ProphetSemanticDimension.familyLineage,
        isFalse,
      );
      expect(canonicalProphetSemanticReleaseGateT0336.isValid, isTrue);
      expect(canonicalProphetSemanticReleaseGateT0336.isReleaseComplete, isFalse);
    });
  });
}
