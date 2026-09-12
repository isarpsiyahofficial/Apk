import 'package:flutter_test/flutter_test.dart';
import 'package:islami_hayat/core/content/content_governance.dart';
import 'package:islami_hayat/features/prophets/data/prophet_semantic_evidence_t0336.dart';
import 'package:islami_hayat/features/prophets/data/prophet_semantic_ownership_qa.dart';

void main() {
  const qa = ProphetSemanticOwnershipQa();

  test('Quran-explicit event anchors preserve owner + exact source locator', () {
    expect(canonicalProphetQuranEventEvidenceT0336, hasLength(4));

    final expected = <String, (String, String)>{
      'yusuf_well_and_egypt': ('yusuf', 'tanzil-uthmani-v1.1:q12:15'),
      'ibrahim_fire_trial': ('ibrahim', 'tanzil-uthmani-v1.1:q21:68-69'),
      'musa_exodus_pharaoh': ('musa', 'tanzil-uthmani-v1.1:q26:63'),
      'yunus_fish_episode': ('yunus', 'tanzil-uthmani-v1.1:q37:142'),
    };

    for (final claim in canonicalProphetQuranEventEvidenceT0336) {
      final pair = expected[claim.claimKey];
      expect(pair, isNotNull, reason: claim.claimKey);
      expect(claim.biographyProphetId, pair!.$1, reason: claim.claimKey);
      expect(claim.subjectProphetId, pair.$1, reason: claim.claimKey);
      expect(claim.dimension, ProphetSemanticDimension.event);
      expect(claim.contextReference, isFalse);
      expect(claim.evidenceState, ProphetSemanticEvidenceState.verified);
      expect(claim.sourceIds, [pair.$2]);
      expect(claim.sourceClasses, {ReligiousSourceClass.quran});
    }

    final result = qa.audit(
      claims: canonicalProphetQuranEventEvidenceT0336,
      requireFull25Coverage: false,
    );
    expect(result.isValid, isTrue, reason: result.errors.join('\n'));
  });

  test('Yusuf well event assigned to Muhammad biography fails closed', () {
    final original = canonicalProphetQuranEventEvidenceT0336.singleWhere(
      (claim) => claim.claimKey == 'yusuf_well_and_egypt',
    );
    final tampered = ProphetSemanticClaim(
      biographyProphetId: 'muhammad',
      subjectProphetId: original.subjectProphetId,
      dimension: original.dimension,
      claimKey: original.claimKey,
      sourceIds: original.sourceIds,
      sourceClasses: original.sourceClasses,
    );

    final result = qa.audit(
      claims: [tampered],
      requireFull25Coverage: false,
    );

    expect(result.isValid, isFalse);
    expect(
      result.errors.any(
        (error) =>
            error.contains('fact belongs to yusuf') ||
            error.contains('exclusive event belongs to yusuf'),
      ),
      isTrue,
    );
  });

  test('exclusive event cannot be relabelled as chronology or date evidence', () {
    final original = canonicalProphetQuranEventEvidenceT0336.singleWhere(
      (claim) => claim.claimKey == 'musa_exodus_pharaoh',
    );
    final tampered = ProphetSemanticClaim(
      biographyProphetId: original.biographyProphetId,
      subjectProphetId: original.subjectProphetId,
      dimension: ProphetSemanticDimension.historicalDate,
      claimKey: original.claimKey,
      sourceIds: original.sourceIds,
      sourceClasses: original.sourceClasses,
    );

    final result = qa.audit(
      claims: [tampered],
      requireFull25Coverage: false,
    );

    expect(result.isValid, isFalse);
    expect(
      result.errors.any(
        (error) => error.contains('exclusive event must use the event dimension'),
      ),
      isTrue,
    );
  });
}
