import '../../../core/content/content_governance.dart';
import 'canonical_prophet_biographies.dart';
import 'canonical_prophets.dart';
import 'prophet_biography_t0194_dataset.dart';
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
/// the provenance-checked T0194 working biography dataset for
/// event/period/geography/hadith and the verified genealogy graph for
/// family-lineage. Unknown/pending biography fields are intentionally ignored
/// for verified coverage, but may be carried as explicit unresolved evidence so
/// editorial uncertainty remains machine-readable instead of being guessed.
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

/// Quran-explicit event ownership anchors for the mandatory semantic gate.
///
/// These events have an explicit owner in their Quranic context and therefore
/// do not depend on prose name matching or later historical inference. The
/// application ships the pinned Tanzil Uthmani source; these claims establish
/// event ownership only and never synthesize chronology, geography or an exact
/// historical date from the verses.
final List<ProphetSemanticClaim> canonicalProphetQuranEventEvidenceT0336 =
    List<ProphetSemanticClaim>.unmodifiable(const [
  ProphetSemanticClaim(
    biographyProphetId: 'nuh',
    subjectProphetId: 'nuh',
    dimension: ProphetSemanticDimension.event,
    claimKey: 'nuh_ark_and_flood',
    sourceIds: ['tanzil-uthmani-v1.1:q11:36-44'],
    sourceClasses: {ReligiousSourceClass.quran},
  ),
  ProphetSemanticClaim(
    biographyProphetId: 'hud',
    subjectProphetId: 'hud',
    dimension: ProphetSemanticDimension.event,
    claimKey: 'hud_aad_warning_and_judgment',
    sourceIds: ['tanzil-uthmani-v1.1:q11:50-60'],
    sourceClasses: {ReligiousSourceClass.quran},
  ),
  ProphetSemanticClaim(
    biographyProphetId: 'salih',
    subjectProphetId: 'salih',
    dimension: ProphetSemanticDimension.event,
    claimKey: 'salih_she_camel_trial',
    sourceIds: ['tanzil-uthmani-v1.1:q11:61-68'],
    sourceClasses: {ReligiousSourceClass.quran},
  ),
  ProphetSemanticClaim(
    biographyProphetId: 'ibrahim',
    subjectProphetId: 'ibrahim',
    dimension: ProphetSemanticDimension.event,
    claimKey: 'ibrahim_fire_trial',
    sourceIds: ['tanzil-uthmani-v1.1:q21:68-69'],
    sourceClasses: {ReligiousSourceClass.quran},
  ),
  ProphetSemanticClaim(
    biographyProphetId: 'yusuf',
    subjectProphetId: 'yusuf',
    dimension: ProphetSemanticDimension.event,
    claimKey: 'yusuf_well_and_egypt',
    sourceIds: [
      'tanzil-uthmani-v1.1:q12:15',
      'tanzil-uthmani-v1.1:q12:21',
    ],
    sourceClasses: {ReligiousSourceClass.quran},
  ),
  ProphetSemanticClaim(
    biographyProphetId: 'musa',
    subjectProphetId: 'musa',
    dimension: ProphetSemanticDimension.event,
    claimKey: 'musa_exodus_pharaoh',
    sourceIds: ['tanzil-uthmani-v1.1:q26:60-66'],
    sourceClasses: {ReligiousSourceClass.quran},
  ),
  ProphetSemanticClaim(
    biographyProphetId: 'sulayman',
    subjectProphetId: 'sulayman',
    dimension: ProphetSemanticDimension.event,
    claimKey: 'sulayman_ant_valley',
    sourceIds: ['tanzil-uthmani-v1.1:q27:17-19'],
    sourceClasses: {ReligiousSourceClass.quran},
  ),
  ProphetSemanticClaim(
    biographyProphetId: 'yunus',
    subjectProphetId: 'yunus',
    dimension: ProphetSemanticDimension.event,
    claimKey: 'yunus_fish_episode',
    sourceIds: ['tanzil-uthmani-v1.1:q37:139-142'],
    sourceClasses: {ReligiousSourceClass.quran},
  ),
]);

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

const _t0336StrongHistoricalSourceClasses = <ReligiousSourceClass>{
  ReligiousSourceClass.quran,
  ReligiousSourceClass.sahihHasanHadith,
  ReligiousSourceClass.earlyIslamicHistoryTafsir,
  ReligiousSourceClass.modernHistoryArchaeology,
};

bool _hasOnlyStrongHistoricalSources(ProphetBiographyField field) =>
    field.sources.isNotEmpty &&
    field.sources.every(
      (source) => _t0336StrongHistoricalSourceClasses.contains(source.sourceClass),
    );

Iterable<CanonicalProphetBiographyDraft> get _t0336BiographyDrafts sync* {
  for (final draft in canonicalProphetBiographyT0194Dataset) {
    if (!draft.isStructurallyComplete ||
        !prophetBiographyT0194DraftHasTraceableProvenance(draft)) {
      throw StateError(
        'T0336 received biography without T0194 provenance: '
        '${draft.identity.canonicalId}',
      );
    }
    yield draft;
  }
}

List<ProphetSemanticClaim> _sourceBackedSectionEvidence({
  required ProphetBiographySectionKey section,
  required ProphetSemanticDimension dimension,
}) {
  final claims = <ProphetSemanticClaim>[];
  for (final draft in _t0336BiographyDrafts) {
    final field = draft.sections[section];
    if (field == null ||
        field.status != ProphetBiographyFieldStatus.sourceBacked ||
        !_hasOnlyStrongHistoricalSources(field)) {
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

final List<ProphetSemanticClaim> canonicalProphetEventEvidenceT0336 =
    _sourceBackedSectionEvidence(
  section: ProphetBiographySectionKey.keyEvents,
  dimension: ProphetSemanticDimension.event,
);

final List<ProphetSemanticClaim> canonicalProphetChronologyEvidenceT0336 =
    _sourceBackedSectionEvidence(
  section: ProphetBiographySectionKey.period,
  dimension: ProphetSemanticDimension.chronology,
);

final List<ProphetSemanticClaim> canonicalProphetGeographyEvidenceT0336 =
    _sourceBackedSectionEvidence(
  section: ProphetBiographySectionKey.geography,
  dimension: ProphetSemanticDimension.geography,
);

final List<ProphetSemanticClaim> canonicalProphetHadithEvidenceT0336 =
    List<ProphetSemanticClaim>.unmodifiable(
  _t0336BiographyDrafts.expand((draft) sync* {
    for (final entry in draft.sections.entries) {
      final field = entry.value;
      if (field.status != ProphetBiographyFieldStatus.sourceBacked) continue;
      for (final source in field.sources) {
        if (source.sourceClass != ReligiousSourceClass.sahihHasanHadith) {
          continue;
        }
        yield ProphetSemanticClaim(
          biographyProphetId: draft.identity.canonicalId,
          subjectProphetId: draft.identity.canonicalId,
          dimension: ProphetSemanticDimension.hadith,
          claimKey:
              'hadith:${draft.identity.canonicalId}:${entry.key.name}:${source.id}',
          sourceIds: <String>[source.id],
          sourceClasses: const {ReligiousSourceClass.sahihHasanHadith},
        );
      }
    }
  }),
);

final List<ProphetSemanticClaim> canonicalProphetHistoricalDateUnknownT0336 =
    List<ProphetSemanticClaim>.unmodifiable(
  canonicalQuranNamedProphets.map(
    (identity) => ProphetSemanticClaim(
      biographyProphetId: identity.canonicalId,
      subjectProphetId: identity.canonicalId,
      dimension: ProphetSemanticDimension.historicalDate,
      claimKey: 'historicalDate:${identity.canonicalId}:unknown',
      sourceIds: const <String>[],
      evidenceState: ProphetSemanticEvidenceState.unknown,
    ),
  ),
);

final List<ProphetSemanticClaim> canonicalProphetSemanticEvidenceT0336 =
    List<ProphetSemanticClaim>.unmodifiable([
  ...canonicalProphetIdentityVerseEvidenceT0336,
  ...canonicalProphetQuranEventEvidenceT0336,
  ...canonicalProphetFamilyLineageEvidenceT0336,
  ...canonicalProphetEventEvidenceT0336,
  ...canonicalProphetChronologyEvidenceT0336,
  ...canonicalProphetGeographyEvidenceT0336,
  ...canonicalProphetHadithEvidenceT0336,
  ...canonicalProphetHistoricalDateUnknownT0336,
]);