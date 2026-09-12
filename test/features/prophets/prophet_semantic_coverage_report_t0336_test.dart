import 'package:flutter_test/flutter_test.dart';
import 'package:islami_hayat/core/content/content_governance.dart';
import 'package:islami_hayat/features/prophets/data/canonical_prophets.dart';
import 'package:islami_hayat/features/prophets/data/prophet_semantic_coverage_report_t0336.dart';
import 'package:islami_hayat/features/prophets/data/prophet_semantic_evidence_t0336.dart';
import 'package:islami_hayat/features/prophets/data/prophet_semantic_ownership_qa.dart';

void main() {
  test('T0336 coverage report enumerates all 25 canonical prophets and 200 slots', () {
    final report = canonicalProphetCoverageReportT0336;

    expect(canonicalQuranNamedProphets, hasLength(25));
    expect(report.rows, hasLength(25));
    expect(report.requiredClaimSlots, 200);
    expect(report.coveredClaimSlots + report.missingClaimSlots, 200);
    expect(report.isReleaseComplete, isFalse);

    expect(
      report.rows.map((row) => row.prophetId).toSet(),
      canonicalQuranNamedProphets.map((identity) => identity.canonicalId).toSet(),
    );
  });

  test('historical dates remain missing until independently verified evidence exists', () {
    final report = canonicalProphetCoverageReportT0336;

    for (final row in report.rows) {
      expect(
        row.missing,
        contains(ProphetSemanticDimension.historicalDate),
        reason: row.prophetId,
      );
    }
  });

  test('reviewed lineage preserves ten claims across nine unique coverage slots', () {
    final report = canonicalProphetCoverageReportT0336;
    final lineageCovered = report.rows
        .where(
          (row) => row.covered.contains(ProphetSemanticDimension.familyLineage),
        )
        .map((row) => row.prophetId)
        .toSet();

    expect(canonicalProphetFamilyLineageEvidenceT0336, hasLength(10));
    expect(lineageCovered, hasLength(9));
    expect(lineageCovered, {
      'musa',
      'harun',
      'zakariya',
      'yahya',
      'ibrahim',
      'ismail',
      'ishaq',
      'dawud',
      'sulayman',
    });

    final ibrahimClaims = canonicalProphetFamilyLineageEvidenceT0336
        .where((claim) => claim.biographyProphetId == 'ibrahim')
        .toList(growable: false);
    expect(ibrahimClaims, hasLength(2));
    expect(
      ibrahimClaims.map((claim) => claim.claimKey).toSet(),
      {
        'familyLineage:ibrahim:ibrahim-ismail-parent-child-q14-39',
        'familyLineage:ibrahim:ibrahim-ishaq-parent-child-q14-39',
      },
    );
  });

  test('identity and Quran verse are covered for every canonical prophet', () {
    final report = canonicalProphetCoverageReportT0336;

    for (final row in report.rows) {
      expect(row.covered, contains(ProphetSemanticDimension.identity));
      expect(row.covered, contains(ProphetSemanticDimension.quranVerse));
    }
  });

  test('unknown and contextual claims cannot inflate release coverage', () {
    final adamBase = canonicalProphetSemanticEvidenceT0336
        .where((claim) => claim.biographyProphetId == 'adam')
        .toList(growable: false);
    final claims = <ProphetSemanticClaim>[
      ...adamBase,
      const ProphetSemanticClaim(
        biographyProphetId: 'adam',
        subjectProphetId: 'adam',
        dimension: ProphetSemanticDimension.historicalDate,
        claimKey: 'historicalDate:adam:pending',
        sourceIds: [],
        evidenceState: ProphetSemanticEvidenceState.pendingReview,
      ),
      const ProphetSemanticClaim(
        biographyProphetId: 'adam',
        subjectProphetId: 'musa',
        dimension: ProphetSemanticDimension.event,
        claimKey: 'event:adam:context-musa',
        sourceIds: ['tanzil-uthmani-v1.1'],
        contextReference: true,
        evidenceState: ProphetSemanticEvidenceState.pendingReview,
      ),
    ];

    final report = buildCanonicalProphetCoverageReportT0336(claims: claims);
    final adam = report.rowFor('adam');

    expect(adam.covered, isNot(contains(ProphetSemanticDimension.historicalDate)));
    expect(adam.covered, contains(ProphetSemanticDimension.identity));
    expect(adam.covered, contains(ProphetSemanticDimension.quranVerse));
  });

  test('non-canonical ownership fails closed in coverage reporting', () {
    expect(
      () => buildCanonicalProphetCoverageReportT0336(
        claims: const [
          ProphetSemanticClaim(
            biographyProphetId: 'adam',
            subjectProphetId: 'not-a-prophet',
            dimension: ProphetSemanticDimension.event,
            claimKey: 'event:adam:bad-owner',
            sourceIds: ['tanzil-uthmani-v1.1'],
            sourceClasses: {ReligiousSourceClass.quran},
          ),
        ],
      ),
      throwsStateError,
    );
  });

  test('wrong prophet event ownership fails before it can inflate coverage', () {
    expect(
      () => buildCanonicalProphetCoverageReportT0336(
        claims: const [
          ProphetSemanticClaim(
            biographyProphetId: 'muhammad',
            subjectProphetId: 'yusuf',
            dimension: ProphetSemanticDimension.event,
            claimKey: 'yusuf_well_and_egypt',
            sourceIds: ['tanzil-uthmani-v1.1'],
            sourceClasses: {ReligiousSourceClass.quran},
          ),
        ],
      ),
      throwsStateError,
    );
  });
}
