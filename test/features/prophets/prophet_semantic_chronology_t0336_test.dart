import 'package:flutter_test/flutter_test.dart';
import 'package:islami_hayat/core/content/content_governance.dart';
import 'package:islami_hayat/features/prophets/data/canonical_prophets.dart';
import 'package:islami_hayat/features/prophets/data/prophet_semantic_coverage_report_t0336.dart';
import 'package:islami_hayat/features/prophets/data/prophet_semantic_evidence_t0336.dart';
import 'package:islami_hayat/features/prophets/data/prophet_semantic_ownership_qa.dart';
import 'package:islami_hayat/features/prophets/data/prophet_timeline.dart';

void main() {
  const qa = ProphetSemanticOwnershipQa();

  test('T0193 approximate timeline contributes chronology for all 25 prophets', () {
    expect(mainApproximateProphetChronologyIsValid, isTrue);
    expect(canonicalProphetTimelineChronologyEvidenceT0336, hasLength(25));

    final canonicalIds = canonicalQuranNamedProphets
        .map((identity) => identity.canonicalId)
        .toSet();
    final evidenceIds = canonicalProphetTimelineChronologyEvidenceT0336
        .map((claim) => claim.biographyProphetId)
        .toSet();
    expect(evidenceIds, canonicalIds);

    for (final band in mainApproximateProphetChronology) {
      for (final prophetId in band.prophetIds) {
        final claim = canonicalProphetTimelineChronologyEvidenceT0336.singleWhere(
          (entry) => entry.biographyProphetId == prophetId,
        );
        expect(claim.subjectProphetId, prophetId);
        expect(claim.dimension, ProphetSemanticDimension.chronology);
        expect(claim.contextReference, isFalse);
        expect(claim.evidenceState, ProphetSemanticEvidenceState.verified);
        expect(claim.explicitExactDateEvidence, isFalse);
        expect(
          claim.claimKey,
          'chronology:$prophetId:approximate_band_${band.order}',
        );
        expect(
          claim.sourceIds,
          band.sources.map((source) => source.id).toList(growable: false),
        );
        expect(
          claim.sourceClasses,
          band.sources.map((source) => source.sourceClass).toSet(),
        );
      }
    }
  });

  test('parallel chronology stays same-band without cross-ownership', () {
    for (final band in mainApproximateProphetChronology.where(
      (entry) => entry.kind == ProphetChronologyBandKind.parallel,
    )) {
      expect(band.prophetIds.length, greaterThanOrEqualTo(2));
      final claims = canonicalProphetTimelineChronologyEvidenceT0336
          .where((claim) => band.prophetIds.contains(claim.biographyProphetId))
          .toList(growable: false);
      expect(claims, hasLength(band.prophetIds.length));
      for (final claim in claims) {
        expect(claim.subjectProphetId, claim.biographyProphetId);
        expect(
          claim.claimKey,
          endsWith('approximate_band_${band.order}'),
        );
      }
    }
  });

  test('canonical coverage now has chronology for all 25 without exact dates', () {
    final report = canonicalProphetCoverageReportT0336;
    for (final row in report.rows) {
      expect(
        row.covered,
        contains(ProphetSemanticDimension.chronology),
        reason: row.prophetId,
      );
      expect(
        row.covered,
        isNot(contains(ProphetSemanticDimension.historicalDate)),
        reason: row.prophetId,
      );
    }
  });

  test('approximate chronology cannot be relabelled as verified exact date', () {
    final chronology = canonicalProphetTimelineChronologyEvidenceT0336.first;
    final result = qa.audit(
      requireFull25Coverage: false,
      claims: [
        ProphetSemanticClaim(
          biographyProphetId: chronology.biographyProphetId,
          subjectProphetId: chronology.subjectProphetId,
          dimension: ProphetSemanticDimension.historicalDate,
          claimKey: 'historicalDate:${chronology.biographyProphetId}:from_approximate_band',
          sourceIds: chronology.sourceIds,
          sourceClasses: chronology.sourceClasses,
        ),
      ],
    );

    expect(result.isValid, isFalse);
    expect(
      result.errors.join('\n'),
      contains('verified historicalDate requires explicit exact-date evidence'),
    );
  });

  test('exact-date opt-in is rejected outside verified historicalDate claims', () {
    final result = qa.audit(
      requireFull25Coverage: false,
      claims: const [
        ProphetSemanticClaim(
          biographyProphetId: 'muhammad',
          subjectProphetId: 'muhammad',
          dimension: ProphetSemanticDimension.chronology,
          claimKey: 'chronology:muhammad:bad_exact_flag',
          sourceIds: ['tdv-prophet-reference-family'],
          sourceClasses: {ReligiousSourceClass.earlyIslamicHistoryTafsir},
          explicitExactDateEvidence: true,
        ),
      ],
    );

    expect(result.isValid, isFalse);
    expect(
      result.errors.join('\n'),
      contains('explicit exact-date evidence is valid only for a verified historicalDate claim'),
    );
  });
}
