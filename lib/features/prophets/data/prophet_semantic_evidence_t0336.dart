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

/// A source-backed `keyEvents` field with strong provenance is the canonical
/// biography's reviewed event summary. Unknown or weak-source event fields
/// never enter this list.
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

/// Geography coverage is admitted only when the T0194 geography field itself
/// is source-backed with strong provenance.
final List<ProphetSemanticClaim> canonicalProphetGeographyEvidenceT0336 =
    _sourceBackedSectionEvidence(
  section: ProphetBiographySectionKey.geography,
  dimension: ProphetSemanticDimension.geography,
);

/// Hadith coverage is narrower than general source-backed coverage: each claim
/// is tied to one exact sahih/hasan reference already admitted by T0194's
/// fail-closed provenance registry. Quran/history sources cannot be relabelled
/// as hadith evidence.
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

/// Exact civil/historical dates must never be synthesized from approximate
/// periods, lineage order, Quran narrative order or modern estimates. Until a
/// prophet has independently reviewed exact-date evidence, the date slot is
/// explicitly `unknown`. This creates one auditable record per canonical
/// prophet while deliberately contributing zero verified coverage.
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

/// Current canonical T0336 evidence surface. Full release coverage intentionally
/// remains false until every prophet has all eight independently verified
/// dimensions. `historicalDate` is deliberately represented as explicit
/// unknown rather than being synthesized from period, Quran, hadith, lineage or
/// approximate modern-history evidence.
final List<ProphetSemanticClaim> canonicalProphetSemanticEvidenceT0336 =
    List<ProphetSemanticClaim>.unmodifiable([
  ...canonicalProphetIdentityVerseEvidenceT0336,
  ...canonicalProphetFamilyLineageEvidenceT0336,
  ...canonicalProphetEventEvidenceT0336,
  ...canonicalProphetChronologyEvidenceT0336,
  ...canonicalProphetGeographyEvidenceT0336,
  ...canonicalProphetHadithEvidenceT0336,
  ...canonicalProphetHistoricalDateUnknownT0336,
]);