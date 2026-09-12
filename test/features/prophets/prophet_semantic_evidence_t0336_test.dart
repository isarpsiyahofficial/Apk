import 'package:flutter_test/flutter_test.dart';
import 'package:islami_hayat/core/content/content_governance.dart';
import 'package:islami_hayat/features/prophets/data/canonical_prophet_biographies.dart';
import 'package:islami_hayat/features/prophets/data/canonical_prophets.dart';
import 'package:islami_hayat/features/prophets/data/prophet_biography_t0194_dataset.dart';
import 'package:islami_hayat/features/prophets/data/prophet_semantic_evidence_t0336.dart';
import 'package:islami_hayat/features/prophets/data/prophet_semantic_ownership_qa.dart';
import 'package:islami_hayat/features/prophets/data/verified_prophet_family_relations.dart';

void main() {
  const qa = ProphetSemanticOwnershipQa();
  const strongHistoricalSources = <ReligiousSourceClass>{
    ReligiousSourceClass.quran,
    ReligiousSourceClass.sahihHasanHadith,
    ReligiousSourceClass.earlyIslamicHistoryTafsir,
    ReligiousSourceClass.modernHistoryArchaeology,
  };

  Set<String> admissibleIds(ProphetBiographySectionKey key) =>
      canonicalProphetBiographyT0194Dataset
          .where((draft) {
            final field = draft.sections[key];
            if (field == null ||
                field.status != ProphetBiographyFieldStatus.sourceBacked ||
                field.sources.isEmpty) {
              return false;
            }
            return field.sources.every(
              (source) => strongHistoricalSources.contains(source.sourceClass),
            );
          })
          .map((draft) => draft.identity.canonicalId)
          .toSet();

  test('canonical registry contributes identity + Quran verse for all 25', () {
    expect(canonicalQuranNamedProphets, hasLength(25));
    expect(canonicalProphetIdentityVerseEvidenceT0336, hasLength(50));

    for (final identity in canonicalQuranNamedProphets) {
      final claims = canonicalProphetIdentityVerseEvidenceT0336
          .where((claim) => claim.biographyProphetId == identity.canonicalId)
          .toList(growable: false);
      expect(claims, hasLength(2), reason: identity.canonicalId);
      expect(
        claims.map((claim) => claim.dimension).toSet(),
        {
          ProphetSemanticDimension.identity,
          ProphetSemanticDimension.quranVerse,
        },
        reason: identity.canonicalId,
      );

      final verseClaim = claims.singleWhere(
        (claim) => claim.dimension == ProphetSemanticDimension.quranVerse,
      );
      expect(
        verseClaim.claimKey,
        contains(
          'q${identity.explicitNameReference.surah}_${identity.explicitNameReference.ayah}',
        ),
        reason: identity.canonicalId,
      );
    }
  });

  test('T0336 lineage slice is derived only from reviewed genealogy facts', () {
    expect(verifiedProphetFamilyGraphIsValid, isTrue);
    expect(verifiedProphetKinshipFacts, hasLength(2));
    expect(canonicalProphetFamilyLineageEvidenceT0336, hasLength(4));

    final coveredProphets = canonicalProphetFamilyLineageEvidenceT0336
        .map((claim) => claim.biographyProphetId)
        .toSet();
    expect(coveredProphets, {'musa', 'harun', 'zakariya', 'yahya'});

    for (final claim in canonicalProphetFamilyLineageEvidenceT0336) {
      expect(claim.subjectProphetId, claim.biographyProphetId);
      expect(claim.dimension, ProphetSemanticDimension.familyLineage);
      expect(claim.contextReference, isFalse);
      expect(claim.evidenceState, ProphetSemanticEvidenceState.verified);
      expect(claim.sourceIds, isNotEmpty);
      expect(claim.sourceClasses, {ReligiousSourceClass.quran});
      expect(
        claim.claimKey,
        startsWith('familyLineage:${claim.biographyProphetId}:'),
      );

      final matchingFact = verifiedProphetKinshipFacts.singleWhere(
        (fact) => claim.claimKey.endsWith(':${fact.id}'),
      );
      expect(
        claim.sourceIds,
        matchingFact.sources.map((source) => source.id).toList(),
      );
    }
  });

  test('T0336 source-backed bridges use provenance-checked T0194 dataset', () {
    expect(canonicalProphetBiographyT0194Dataset, hasLength(25));
    for (final draft in canonicalProphetBiographyT0194Dataset) {
      expect(draft.isStructurallyComplete, isTrue, reason: draft.identity.canonicalId);
      expect(
        prophetBiographyT0194DraftHasTraceableProvenance(draft),
        isTrue,
        reason: draft.identity.canonicalId,
      );
    }

    final cases = <(
      ProphetBiographySectionKey,
      ProphetSemanticDimension,
      List<ProphetSemanticClaim>
    )>[
      (
        ProphetBiographySectionKey.keyEvents,
        ProphetSemanticDimension.event,
        canonicalProphetEventEvidenceT0336,
      ),
      (
        ProphetBiographySectionKey.period,
        ProphetSemanticDimension.chronology,
        canonicalProphetChronologyEvidenceT0336,
      ),
      (
        ProphetBiographySectionKey.geography,
        ProphetSemanticDimension.geography,
        canonicalProphetGeographyEvidenceT0336,
      ),
    ];

    for (final entry in cases) {
      final expectedIds = admissibleIds(entry.$1);
      final actualIds = entry.$3.map((claim) => claim.biographyProphetId).toSet();
      expect(actualIds, expectedIds, reason: entry.$1.name);
      expect(entry.$3, hasLength(expectedIds.length), reason: entry.$1.name);

      for (final claim in entry.$3) {
        expect(claim.dimension, entry.$2);
        expect(claim.subjectProphetId, claim.biographyProphetId);
        expect(claim.evidenceState, ProphetSemanticEvidenceState.verified);
        expect(claim.contextReference, isFalse);
        expect(claim.sourceIds, isNotEmpty);
        expect(claim.sourceClasses, isNotEmpty);
        expect(claim.sourceClasses.difference(strongHistoricalSources), isEmpty);
        expect(claim.claimKey, startsWith('${entry.$2.name}:'));
      }
    }
  });

  test('unknown or weak-source biography fields never manufacture coverage', () {
    for (final draft in canonicalProphetBiographyT0194Dataset) {
      final checks = <(
        ProphetBiographySectionKey,
        List<ProphetSemanticClaim>
      )>[
        (ProphetBiographySectionKey.keyEvents, canonicalProphetEventEvidenceT0336),
        (ProphetBiographySectionKey.period, canonicalProphetChronologyEvidenceT0336),
        (ProphetBiographySectionKey.geography, canonicalProphetGeographyEvidenceT0336),
      ];

      for (final entry in checks) {
        final field = draft.sections[entry.$1]!;
        final admissible =
            field.status == ProphetBiographyFieldStatus.sourceBacked &&
                field.sources.isNotEmpty &&
                field.sources.every(
                  (source) => strongHistoricalSources.contains(source.sourceClass),
                );
        if (!admissible) {
          expect(
            entry.$2.where(
              (claim) => claim.biographyProphetId == draft.identity.canonicalId,
            ),
            isEmpty,
            reason: '${draft.identity.canonicalId}/${entry.$1.name}',
          );
        }
      }
    }
  });

  test('hadith bridge admits exactly T0194-reviewed hadith references', () {
    final expected = <String, String>{};
    for (final draft in canonicalProphetBiographyT0194Dataset) {
      for (final entry in draft.sections.entries) {
        if (entry.value.status != ProphetBiographyFieldStatus.sourceBacked) continue;
        for (final source in entry.value.sources) {
          if (source.sourceClass == ReligiousSourceClass.sahihHasanHadith) {
            expected[source.id] = draft.identity.canonicalId;
          }
        }
      }
    }

    expect(expected, isNotEmpty);
    expect(canonicalProphetHadithEvidenceT0336, hasLength(expected.length));
    for (final claim in canonicalProphetHadithEvidenceT0336) {
      expect(claim.dimension, ProphetSemanticDimension.hadith);
      expect(claim.sourceClasses, {ReligiousSourceClass.sahihHasanHadith});
      expect(claim.sourceIds, hasLength(1));
      expect(expected[claim.sourceIds.single], claim.biographyProphetId);
      expect(claim.subjectProphetId, claim.biographyProphetId);
    }
  });

  test('current canonical T0336 evidence is internally valid', () {
    expect(canonicalProphetSemanticEvidenceT0336.length, greaterThan(54));

    final result = qa.audit(
      claims: canonicalProphetSemanticEvidenceT0336,
      requireFull25Coverage: false,
    );

    expect(result.errors, isEmpty);
    expect(result.isValid, isTrue);
  });

  test('reviewed bridges cannot falsely complete 25x8 release gate', () {
    final historicalDateClaims = canonicalProphetSemanticEvidenceT0336
        .where(
          (claim) => claim.dimension == ProphetSemanticDimension.historicalDate,
        )
        .toList(growable: false);

    expect(historicalDateClaims, hasLength(25));
    expect(
      historicalDateClaims.where(
        (claim) => claim.evidenceState == ProphetSemanticEvidenceState.verified,
      ),
      isEmpty,
      reason: 'period/approximation evidence must not be promoted to exact dates',
    );
    expect(
      historicalDateClaims.every(
        (claim) =>
            claim.evidenceState == ProphetSemanticEvidenceState.unknown &&
            claim.sourceIds.isEmpty &&
            claim.sourceClasses.isEmpty &&
            claim.claimKey ==
                'historicalDate:${claim.biographyProphetId}:unknown',
      ),
      isTrue,
      reason: 'all 25 exact-date gaps must remain explicit unknown records',
    );

    final result = qa.audit(claims: canonicalProphetSemanticEvidenceT0336);

    expect(result.isValid, isFalse);
    final errors = result.errors.join('\n');
    expect(errors, contains('semantic cross-check coverage missing'));
    expect(errors, contains('historicalDate'));

    // A prophet without an independently reviewed genealogy must still report
    // the lineage gap instead of receiving inferred ancestry.
    final adamError = result.errors.singleWhere(
      (error) => error.startsWith('adam: semantic cross-check coverage missing'),
    );
    expect(adamError, contains('familyLineage'));

    // Prophets covered by the conservative graph no longer report that one
    // dimension, while unresolved dimensions remain fail-closed.
    final musaError = result.errors.singleWhere(
      (error) => error.startsWith('musa: semantic cross-check coverage missing'),
    );
    expect(musaError, isNot(contains('familyLineage')));
    expect(musaError, contains('historicalDate'));
  });
}
