import '../../../core/content/content_governance.dart';
import 'canonical_prophets.dart';
import 'prophet_semantic_ownership_qa.dart';
import 'verified_prophet_family_relations.dart';

/// Canonical-data-backed slices of the v1.2 T0336 semantic release gate.
///
/// Every one of the 25 canonical identities already has an explicit Quran name
/// anchor in [canonicalQuranNamedProphets]. Those exact structured references
/// can safely satisfy the `identity` and `quranVerse` dimensions without
/// inventing biography detail.
///
/// The family-lineage slice is deliberately narrower: it is derived only from
/// [verifiedProphetKinshipFacts], whose individual relation claims and composed
/// graph are already fail-closed reviewed. A missing genealogy is therefore not
/// guessed merely to increase coverage. The remaining event/hadith/chronology/
/// geography/date dimensions stay outside this registry until their own
/// reviewed evidence is attached.
final List<ProphetSemanticClaim> canonicalProphetIdentityVerseEvidenceT0336 =
    List<ProphetSemanticClaim>.unmodifiable(
  canonicalQuranNamedProphets.expand((identity) {
    final reference = identity.explicitNameReference;
    final verseKey = 'q${reference.surah}_${reference.ayah}';
    return <ProphetSemanticClaim>[
      ProphetSemanticClaim(
        biographyProphetId: identity.canonicalId,
        subjectProphetId: identity.canonicalId,
        dimension: ProphetSemanticDimension.identity,
        claimKey: 'identity:${identity.canonicalId}',
        sourceIds: const ['tanzil-uthmani-v1.1'],
        sourceClasses: const {ReligiousSourceClass.quran},
      ),
      ProphetSemanticClaim(
        biographyProphetId: identity.canonicalId,
        subjectProphetId: identity.canonicalId,
        dimension: ProphetSemanticDimension.quranVerse,
        claimKey: 'quranVerse:${identity.canonicalId}_$verseKey',
        sourceIds: const ['tanzil-uthmani-v1.1'],
        sourceClasses: const {ReligiousSourceClass.quran},
      ),
    ];
  }),
);

/// T0336 lineage evidence is generated only from the independently reviewed
/// genealogy graph. Each endpoint receives its own biography-owned lineage
/// claim; mentioning the related prophet does not transfer event ownership.
final List<ProphetSemanticClaim> canonicalProphetFamilyLineageEvidenceT0336 =
    List<ProphetSemanticClaim>.unmodifiable(
  verifiedProphetKinshipFacts.expand((fact) {
    if (!fact.isValid) {
      throw StateError('T0336 received unverified family fact: ${fact.id}');
    }

    final sourceIds = List<String>.unmodifiable(
      fact.sources.map((source) => source.id),
    );
    final sourceClasses = Set<ReligiousSourceClass>.unmodifiable(
      fact.sources.map((source) => source.sourceClass),
    );

    ProphetSemanticClaim claimFor(String prophetId) => ProphetSemanticClaim(
          biographyProphetId: prophetId,
          subjectProphetId: prophetId,
          dimension: ProphetSemanticDimension.familyLineage,
          claimKey: 'familyLineage:$prophetId:${fact.id}',
          sourceIds: sourceIds,
          sourceClasses: sourceClasses,
        );

    return <ProphetSemanticClaim>[
      claimFor(fact.firstProphetId),
      claimFor(fact.secondProphetId),
    ];
  }),
);

/// Current canonical T0336 evidence surface. Full release coverage intentionally
/// remains false until every prophet has all eight independently verified
/// dimensions.
final List<ProphetSemanticClaim> canonicalProphetSemanticEvidenceT0336 =
    List<ProphetSemanticClaim>.unmodifiable([
  ...canonicalProphetIdentityVerseEvidenceT0336,
  ...canonicalProphetFamilyLineageEvidenceT0336,
]);
