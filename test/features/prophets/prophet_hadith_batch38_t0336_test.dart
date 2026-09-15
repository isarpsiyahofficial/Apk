import 'package:flutter_test/flutter_test.dart';
import 'package:islami_hayat/core/content/content_governance.dart';
import 'package:islami_hayat/features/prophets/data/prophet_hadith_evidence_t0336_batch38.dart';
import 'package:islami_hayat/features/prophets/data/prophet_semantic_coverage_report_t0336.dart';
import 'package:islami_hayat/features/prophets/data/prophet_semantic_gap_manifest_t0336.dart';
import 'package:islami_hayat/features/prophets/data/prophet_semantic_ownership_qa.dart';
import 'package:islami_hayat/features/prophets/data/prophet_semantic_release_gate_t0336.dart';

void main() {
  group('T0336 hadith batch38 provenance', () {
    test('Ismail, Salih and Zakariya sources are exact reference-only sahih metadata', () {
      expect(ismailZamzamKabaHadithSourceT0336.title, 'Sahih al-Bukhari');
      expect(
        ismailZamzamKabaHadithSourceT0336.locator,
        'Sahih al-Bukhari 3364',
      );
      expect(ismailZamzamKabaHadithSourceT0336.licenseId, 'REFERENCE-ONLY');
      expect(
        ismailZamzamKabaHadithSourceT0336.sourceClass,
        ReligiousSourceClass.sahihHasanHadith,
      );

      expect(salihSheCamelHadithSourceT0336.title, 'Sahih al-Bukhari');
      expect(salihSheCamelHadithSourceT0336.locator, 'Sahih al-Bukhari 3377');
      expect(salihSheCamelHadithSourceT0336.licenseId, 'REFERENCE-ONLY');
      expect(
        salihSheCamelHadithSourceT0336.sourceClass,
        ReligiousSourceClass.sahihHasanHadith,
      );

      expect(zakariyaCarpenterHadithSourceT0336.title, 'Sahih Muslim');
      expect(zakariyaCarpenterHadithSourceT0336.locator, 'Sahih Muslim 2379');
      expect(zakariyaCarpenterHadithSourceT0336.licenseId, 'REFERENCE-ONLY');
      expect(
        zakariyaCarpenterHadithSourceT0336.sourceClass,
        ReligiousSourceClass.sahihHasanHadith,
      );
    });

    test('natural cross-mentions cannot transfer biography ownership', () {
      expect(
        () => buildIsmailHadithEvidenceT0336(subjectProphetId: 'ibrahim'),
        throwsStateError,
      );
      expect(
        () => buildSalihHadithEvidenceT0336(biographyProphetId: 'muhammad'),
        throwsStateError,
      );
      expect(
        () => buildZakariyaHadithEvidenceT0336(subjectProphetId: 'yahya'),
        throwsStateError,
      );
    });

    test('source metadata tampering fails closed', () {
      expect(
        () => buildIsmailHadithEvidenceT0336(
          source: const SourceReference(
            id: 'sahih-bukhari-3364-ismail-zamzam-kaba',
            title: 'Sahih al-Bukhari',
            sourceClass: ReligiousSourceClass.sahihHasanHadith,
            licenseId: 'REFERENCE-ONLY',
            locator: 'Sahih al-Bukhari 3365',
          ),
        ),
        throwsStateError,
      );
      expect(
        () => buildZakariyaHadithEvidenceT0336(
          source: const SourceReference(
            id: 'sahih-muslim-2379-zakariya-carpenter',
            title: 'Sahih Muslim',
            sourceClass: ReligiousSourceClass.sahihHasanHadith,
            licenseId: 'UNKNOWN',
            locator: 'Sahih Muslim 2379',
          ),
        ),
        throwsStateError,
      );
    });

    test('canonical coverage admits three owners without dimension leakage', () {
      const expectedSources = <String, String>{
        'ismail': 'sahih-bukhari-3364-ismail-zamzam-kaba',
        'salih': 'sahih-bukhari-3377-salih-she-camel',
        'zakariya': 'sahih-muslim-2379-zakariya-carpenter',
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

      for (final claim in prophetHadithEvidenceT0336Batch38) {
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
