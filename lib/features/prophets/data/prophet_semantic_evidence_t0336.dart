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

/// Quran-explicit event/state ownership anchors for the mandatory semantic gate.
///
/// These anchors have an explicit owner in their Quranic context and therefore
/// do not depend on prose name matching or later historical inference. For
/// prophets whose Quran passages give no extended narrative (notably Elyesa'
/// and Zulkifl), the anchor is deliberately limited to the explicit state the
/// verse supplies rather than inventing a biography event. These claims never
/// synthesize chronology, geography, genealogy or an exact historical date.
final List<ProphetSemanticClaim> canonicalProphetQuranEventEvidenceT0336 =
    List<ProphetSemanticClaim>.unmodifiable(const [
  ProphetSemanticClaim(
    biographyProphetId: 'adam',
    subjectProphetId: 'adam',
    dimension: ProphetSemanticDimension.event,
    claimKey: 'adam_tree_and_descent',
    sourceIds: ['tanzil-uthmani-v1.1:q2:35-36'],
    sourceClasses: {ReligiousSourceClass.quran},
  ),
  ProphetSemanticClaim(
    biographyProphetId: 'idris',
    subjectProphetId: 'idris',
    dimension: ProphetSemanticDimension.event,
    claimKey: 'idris_raised_to_high_station',
    sourceIds: ['tanzil-uthmani-v1.1:q19:56-57'],
    sourceClasses: {ReligiousSourceClass.quran},
  ),
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
    biographyProphetId: 'lut',
    subjectProphetId: 'lut',
    dimension: ProphetSemanticDimension.event,
    claimKey: 'lut_people_warning_and_rescue',
    sourceIds: ['tanzil-uthmani-v1.1:q7:80-84'],
    sourceClasses: {ReligiousSourceClass.quran},
  ),
  ProphetSemanticClaim(
    biographyProphetId: 'ismail',
    subjectProphetId: 'ismail',
    dimension: ProphetSemanticDimension.event,
    claimKey: 'ismail_prayer_and_zakat_instruction',
    sourceIds: ['tanzil-uthmani-v1.1:q19:54-55'],
    sourceClasses: {ReligiousSourceClass.quran},
  ),
  ProphetSemanticClaim(
    biographyProphetId: 'ishaq',
    subjectProphetId: 'ishaq',
    dimension: ProphetSemanticDimension.event,
    claimKey: 'ishaq_prophethood_glad_tidings',
    sourceIds: ['tanzil-uthmani-v1.1:q37:112-113'],
    sourceClasses: {ReligiousSourceClass.quran},
  ),
  ProphetSemanticClaim(
    biographyProphetId: 'yakub',
    subjectProphetId: 'yakub',
    dimension: ProphetSemanticDimension.event,
    claimKey: 'yakub_final_counsel_to_sons',
    sourceIds: ['tanzil-uthmani-v1.1:q2:132-133'],
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
    biographyProphetId: 'ayyub',
    subjectProphetId: 'ayyub',
    dimension: ProphetSemanticDimension.event,
    claimKey: 'ayyub_affliction_and_relief',
    sourceIds: ['tanzil-uthmani-v1.1:q21:83-84'],
    sourceClasses: {ReligiousSourceClass.quran},
  ),
  ProphetSemanticClaim(
    biographyProphetId: 'shuayb',
    subjectProphetId: 'shuayb',
    dimension: ProphetSemanticDimension.event,
    claimKey: 'shuayb_madyan_measure_weight',
    sourceIds: ['tanzil-uthmani-v1.1:q7:85-93'],
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
    biographyProphetId: 'harun',
    subjectProphetId: 'harun',
    dimension: ProphetSemanticDimension.event,
    claimKey: 'harun_rescue_and_book_with_musa',
    sourceIds: ['tanzil-uthmani-v1.1:q37:114-122'],
    sourceClasses: {ReligiousSourceClass.quran},
  ),
  ProphetSemanticClaim(
    biographyProphetId: 'dawud',
    subjectProphetId: 'dawud',
    dimension: ProphetSemanticDimension.event,
    claimKey: 'dawud_defeats_jalut',
    sourceIds: ['tanzil-uthmani-v1.1:q2:251'],
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
    biographyProphetId: 'ilyas',
    subjectProphetId: 'ilyas',
    dimension: ProphetSemanticDimension.event,
    claimKey: 'ilyas_baal_warning',
    sourceIds: ['tanzil-uthmani-v1.1:q37:123-132'],
    sourceClasses: {ReligiousSourceClass.quran},
  ),
  ProphetSemanticClaim(
    biographyProphetId: 'alyasa',
    subjectProphetId: 'alyasa',
    dimension: ProphetSemanticDimension.event,
    claimKey: 'alyasa_named_among_the_good',
    sourceIds: ['tanzil-uthmani-v1.1:q38:48'],
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
  ProphetSemanticClaim(
    biographyProphetId: 'zakariya',
    subjectProphetId: 'zakariya',
    dimension: ProphetSemanticDimension.event,
    claimKey: 'zakariya_prayer_yahya_sign',
    sourceIds: ['tanzil-uthmani-v1.1:q3:38-41'],
    sourceClasses: {ReligiousSourceClass.quran},
  ),
  ProphetSemanticClaim(
    biographyProphetId: 'yahya',
    subjectProphetId: 'yahya',
    dimension: ProphetSemanticDimension.event,
    claimKey: 'yahya_named_and_given_wisdom',
    sourceIds: ['tanzil-uthmani-v1.1:q19:7-15'],
    sourceClasses: {ReligiousSourceClass.quran},
  ),
  ProphetSemanticClaim(
    biographyProphetId: 'isa',
    subjectProphetId: 'isa',
    dimension: ProphetSemanticDimension.event,
    claimKey: 'isa_infant_speech',
    sourceIds: ['tanzil-uthmani-v1.1:q19:29-33'],
    sourceClasses: {ReligiousSourceClass.quran},
  ),
  ProphetSemanticClaim(
    biographyProphetId: 'muhammad',
    subjectProphetId: 'muhammad',
    dimension: ProphetSemanticDimension.event,
    claimKey: 'muhammad_messenger_with_believers',
    sourceIds: ['tanzil-uthmani-v1.1:q48:29'],
    sourceClasses: {ReligiousSourceClass.quran},
  ),
  ProphetSemanticClaim(
    biographyProphetId: 'dhul_kifl',
    subjectProphetId: 'dhul_kifl',
    dimension: ProphetSemanticDimension.event,
    claimKey: 'dhul_kifl_patience_and_mercy',
    sourceIds: ['tanzil-uthmani-v1.1:q21:85-86'],
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