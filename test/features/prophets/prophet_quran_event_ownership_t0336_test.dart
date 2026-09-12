import 'package:flutter_test/flutter_test.dart';
import 'package:islami_hayat/core/content/content_governance.dart';
import 'package:islami_hayat/features/prophets/data/prophet_semantic_evidence_t0336.dart';
import 'package:islami_hayat/features/prophets/data/prophet_semantic_ownership_qa.dart';

void main() {
  const qa = ProphetSemanticOwnershipQa();

  test('Quran-explicit event anchors preserve owner + exact source locators', () {
    expect(canonicalProphetQuranEventEvidenceT0336, hasLength(19));

    final expected = <String, (String, List<String>)>{
      'adam_tree_and_descent': (
        'adam',
        ['tanzil-uthmani-v1.1:q2:35-36'],
      ),
      'idris_raised_to_high_station': (
        'idris',
        ['tanzil-uthmani-v1.1:q19:56-57'],
      ),
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
      'lut_people_warning_and_rescue': (
        'lut',
        ['tanzil-uthmani-v1.1:q7:80-84'],
      ),
      'ismail_prayer_and_zakat_instruction': (
        'ismail',
        ['tanzil-uthmani-v1.1:q19:54-55'],
      ),
      'yusuf_well_and_egypt': (
        'yusuf',
        [
          'tanzil-uthmani-v1.1:q12:15',
          'tanzil-uthmani-v1.1:q12:21',
        ],
      ),
      'ayyub_affliction_and_relief': (
        'ayyub',
        ['tanzil-uthmani-v1.1:q21:83-84'],
      ),
      'shuayb_madyan_measure_weight': (
        'shuayb',
        ['tanzil-uthmani-v1.1:q7:85-93'],
      ),
      'musa_exodus_pharaoh': (
        'musa',
        ['tanzil-uthmani-v1.1:q26:60-66'],
      ),
      'dawud_defeats_jalut': (
        'dawud',
        ['tanzil-uthmani-v1.1:q2:251'],
      ),
      'sulayman_ant_valley': (
        'sulayman',
        ['tanzil-uthmani-v1.1:q27:17-19'],
      ),
      'ilyas_baal_warning': (
        'ilyas',
        ['tanzil-uthmani-v1.1:q37:123-132'],
      ),
      'yunus_fish_episode': (
        'yunus',
        ['tanzil-uthmani-v1.1:q37:139-142'],
      ),
      'zakariya_prayer_yahya_sign': (
        'zakariya',
        ['tanzil-uthmani-v1.1:q3:38-41'],
      ),
      'yahya_named_and_given_wisdom': (
        'yahya',
        ['tanzil-uthmani-v1.1:q19:7-15'],
      ),
      'isa_infant_speech': (
        'isa',
        ['tanzil-uthmani-v1.1:q19:29-33'],
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

    expect(
      expected.keys.toSet(),
      canonicalProphetQuranEventEvidenceT0336.map((e) => e.claimKey).toSet(),
    );

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

  test('every Quran event fails closed when subject ownership is forged', () {
    for (final original in canonicalProphetQuranEventEvidenceT0336) {
      final wrongSubject = original.subjectProphetId == 'muhammad'
          ? 'yusuf'
          : 'muhammad';
      final tampered = ProphetSemanticClaim(
        biographyProphetId: original.biographyProphetId,
        subjectProphetId: wrongSubject,
        dimension: original.dimension,
        claimKey: original.claimKey,
        sourceIds: original.sourceIds,
        sourceClasses: original.sourceClasses,
        contextReference: true,
      );

      final result = qa.audit(
        claims: [tampered],
        requireFull25Coverage: false,
      );

      expect(result.isValid, isFalse, reason: original.claimKey);
      expect(
        result.errors.any(
          (error) => error.contains(
            'exclusive event subject must be ${original.subjectProphetId}',
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
      for (final wrongDimension in const [
        ProphetSemanticDimension.chronology,
        ProphetSemanticDimension.historicalDate,
        ProphetSemanticDimension.geography,
        ProphetSemanticDimension.hadith,
        ProphetSemanticDimension.familyLineage,
      ]) {
        final tampered = ProphetSemanticClaim(
          biographyProphetId: original.biographyProphetId,
          subjectProphetId: original.subjectProphetId,
          dimension: wrongDimension,
          claimKey: original.claimKey,
          sourceIds: original.sourceIds,
          sourceClasses: original.sourceClasses,
        );

        final result = qa.audit(
          claims: [tampered],
          requireFull25Coverage: false,
        );

        expect(
          result.isValid,
          isFalse,
          reason: '${original.claimKey}/${wrongDimension.name}',
        );
        expect(
          result.errors.any(
            (error) =>
                error.contains('exclusive event must use the event dimension'),
          ),
          isTrue,
          reason: '${original.claimKey}/${wrongDimension.name}',
        );
      }
    }
  });
}
