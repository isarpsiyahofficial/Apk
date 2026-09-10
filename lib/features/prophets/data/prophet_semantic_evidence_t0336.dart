import '../../../core/content/content_governance.dart';
import 'canonical_prophet_biographies.dart';
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
/// Other dimensions are admitted only by bridging independently reviewed data:
/// source-backed biography sections for event/period/geography and the verified
/// genealogy graph for family-lineage. Unknown/pending biography fields are
/// intentionally ignored and therefore remain release gaps.
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

List<ProphetSemanticClaim> _sourceBackedSectionEvidence({
  required ProphetBiographySectionKey section,
  required ProphetSemanticDimension dimension,
}) {
  final claims = <ProphetSemanticClaim>[];
  for (final draft in canonicalProphetBiographyDrafts) {
    final field = draft.sections[section];
    if (field == null ||
        field.status != ProphetBiographyFieldStatus.sourceBacked ||
        field.sources.isEmpty) {
      continue;
    }

    final sourceIds = List<String>.unmodifiable(
      field.sources.map((source) => source.id),
    );
    final sourceClasses = Set<ReligiousSourceClass>.unmodifiable(
      field.sources.map((source) => source.sourceClass),
    );

    claims.add(
      ProphetSemanticClaim(
        biographyProphetId: draft.identity.canonicalId,
        subjectProphetId: draft.identity.canonicalId,
        dimension: dimension,
        claimKey:
            '${dimension.name}:${draft.identity.canonicalId}:${section.name}',
        sourceIds: sourceIds,
        sourceClasses: sourceClasses,
      ),
    );
  }
  return List<ProphetSemanticClaim>.unmodifiable(claims);
}

/// A source-backed `keyEvents` field is the canonical biography's reviewed
/// event summary. Unknown event fields never enter this list.
final List<ProphetSemanticClaim> canonicalProphetEventEvidenceT0336 =
    _sourceBackedSectionEvidence(
  section: ProphetBiographySectionKey.keyEvents,
  dimension: ProphetSemanticDimension.event,
);

/// A source-backed `period` field contributes chronology only; it does not
/// automatically become an exact historical date.
final List<ProphetSemanticClaim> canonicalProphetChronologyEvidenceT0336 =
    _sourceBackedSectionEvidence(
  section: ProphetBiographySectionKey.period,
  dimension: ProphetSemanticDimension.chronology,
);

/// Geography coverage is admitted only when the canonical biography geography
/// field itself is source-backed.
final List<ProphetSemanticClaim> canonicalProphetGeographyEvidenceT0336 =
    _sourceBackedSectionEvidence(
  section: ProphetBiographySectionKey.geography,
  dimension: ProphetSemanticDimension.geography,
);

/// Current canonical T0336 evidence surface. Full release coverage intentionally
/// remains false until every prophet has all eight independently verified
/// dimensions; hadith and historicalDate in particular are not synthesized from
/// Quran/event/period evidence.
final List<ProphetSemanticClaim> canonicalProphetSemanticEvidenceT0336 =
    List<ProphetSemanticClaim>.unmodifiable([
  ...canonicalProphetIdentityVerseEvidenceT0336,
  ...canonicalProphetFamilyLineageEvidenceT0336,
  ...canonicalProphetEventEvidenceT0336,
  ...canonicalProphetChronologyEvidenceT0336,
  ...canonicalProphetGeographyEvidenceT0336,
]);
