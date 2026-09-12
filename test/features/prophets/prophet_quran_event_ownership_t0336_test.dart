import 'package:flutter_test/flutter_test.dart';
import 'package:islami_hayat/core/content/content_governance.dart';
import 'package:islami_hayat/features/prophets/data/prophet_semantic_evidence_t0336.dart';
import 'package:islami_hayat/features/prophets/data/prophet_semantic_ownership_qa.dart';

void main() {
  const qa = ProphetSemanticOwnershipQa();

  test('Quran-explicit event anchors preserve owner + exact source locators', () {
    expect(canonicalProphetQuranEventEvidenceT0336, hasLength(8));

    final expected = <String, (String, List<String>)>{
      'nuh_ark_and_flood': (
        'nuh',
        ['tanzil-uthmani-v1.1:q11:36-44'],
      ),
      'hud_aad_warning_and_judgment': (
        'hud',
        ['tanzil-uthmani-v1.1:q11:50-60'],
      ),
      'salih_she_camel_trial': (
        'salih',
        ['tanzil-uthmani-v1.1:q11:61-68'],
      ),
      'ibrahim_fire_trial': (
        'ibrahim',
        ['tanzil-uthmani-v1.1:q21:68-69'],
      ),
      'yusuf_well_and_egypt': (
        'yusuf',
        [
          'tanzil-uthmani-v1.1:q12:15',
          'tanzil-uthmani-v1.1:q12:21',
        ],
      ),
      'musa_exodus_pharaoh': (
        'musa',
        ['tanzil-uthmani-v1.1:q26:60-66'],
      ),
      'sulayman_ant_valley': (
        'sulayman',
        ['tanzil-uthmani-v1.1:q27:17-19'],
      ),
      'yunus_fish_episode': (
        'yunus',
        ['tanzil-uthmani-v1.1:q37:139-142'],
      ),
    };

    for (final claim in canonicalProphetQuranEventEvidenceT0336) {
      final pair = expected[claim.claimKey];
      expect(pair, isNotNull, reason: claim.claimKey);
      final expectedPair = pair!;
      expect(claim.biographyProphetId, expectedPair.$1, reason: claim.claimKey);
      expect(claim.subjectProphetId, expectedPair.$1, reason: claim.claimKey);
      expect(claim.dimension, ProphetSemanticDimension.event);
      expect(claim.contextReference, isFalse);
      expect(claim.evidenceState, ProphetSemanticEvidenceState.verified);
      expect(claim.sourceIds, expectedPair.$2);
      expect(claim.sourceClasses, {ReligiousSourceClass.quran});
    }

    final result = qa.audit(
      claims: canonicalProphetQuranEventEvidenceT0336,
      requireFull25Coverage: false,
    );
    expect(result.isValid, isTrue, reason: result.errors.join('\n'));
  });

  test('every Quran event fails closed when assigned to another biography', () {
    for (final original in canonicalProphetQuranEventEvidenceT0336) {
      final wrongBiography = original.biographyProphetId == 'muhammad'
          ? 'yusuf'
          : 'muhammad';
      final tampered = ProphetSemanticClaim(
        biographyProphetId: wrongBiography,
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

      expect(result.isValid, isFalse, reason: original.claimKey);
      expect(
        result.errors.any(
          (error) =>
              error.contains('fact belongs to ${original.subjectProphetId}') ||
              error.contains(
                'exclusive event belongs to ${original.subjectProphetId}',
              ),
        ),
        isTrue,
        reason: original.claimKey,
      );
    }
  });

  test('natural cross-reference does not transfer event coverage', () {
    final original = canonicalProphetQuranEventEvidenceT0336.singleWhere(
      (claim) => claim.claimKey == 'yusuf_well_and_egypt',
    );
    final contextual = ProphetSemanticClaim(
      biographyProphetId: 'muhammad',
      subjectProphetId: original.subjectProphetId,
      dimension: original.dimension,
      claimKey: original.claimKey,
      sourceIds: original.sourceIds,
      sourceClasses: original.sourceClasses,
      contextReference: true,
    );

    final result = qa.audit(
      claims: [contextual],
      requireFull25Coverage: false,
    );
    expect(result.isValid, isTrue, reason: result.errors.join('\n'));
  });

  test('exclusive event cannot be relabelled as chronology or date evidence', () {
    for (final original in canonicalProphetQuranEventEvidenceT0336) {
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

      expect(result.isValid, isFalse, reason: original.claimKey);
      expect(
        result.errors.any(
          (error) => error.contains('exclusive event must use the event dimension'),
        ),
        isTrue,
        reason: original.claimKey,
      );
    }
  });
}