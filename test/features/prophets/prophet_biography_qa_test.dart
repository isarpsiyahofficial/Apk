import 'package:flutter_test/flutter_test.dart';
import 'package:islami_hayat/core/content/content_governance.dart';
import 'package:islami_hayat/features/prophets/data/canonical_prophet_biographies.dart';
import 'package:islami_hayat/features/prophets/data/prophet_biography_qa.dart';
import 'package:islami_hayat/features/prophets/data/prophet_biography_t0194_dataset.dart';
import 'package:islami_hayat/features/prophets/data/prophet_content.dart';
import 'package:islami_hayat/features/prophets/data/prophet_timeline.dart';
import 'package:islami_hayat/features/prophets/data/verified_prophet_family_relations.dart';

void main() {
  const audit = ProphetBiographyQaAudit();

  test('canonical T0194 supplemented dataset passes T0207 structural QA', () {
    final muhammad = canonicalProphetBiographyT0194Dataset.singleWhere(
      (draft) => draft.identity.canonicalId == 'muhammad',
    );
    final period = muhammad.sections[ProphetBiographySectionKey.period]!;

    // This field is introduced by a late T0194 supplement. Keeping this
    // assertion here prevents the canonical QA from silently regressing to
    // the unsupplemented base drafts again.
    expect(period.status, ProphetBiographyFieldStatus.sourceBacked);
    expect(
      period.sources.any(
        (source) =>
            source.sourceClass == ReligiousSourceClass.modernHistoryArchaeology,
      ),
      isTrue,
    );
    expect(prophetBiographyT0194DraftHasTraceableProvenance(muhammad), isTrue);

    final result = audit.auditCanonicalResearchDataset();

    expect(result.errors, isEmpty);
    expect(result.isValid, isTrue);
  });

  test('rejects a source-backed biography sentence without a source', () {
    final first = canonicalProphetBiographyDrafts.first;
    final sections = Map<ProphetBiographySectionKey, ProphetBiographyField>.from(
      first.sections,
    );
    sections[ProphetBiographySectionKey.mainMessage] = const ProphetBiographyField(
      text: LocalizedReligiousText(tr: 'Kaynaklı.', en: 'Sourced.', ar: 'موثق.'),
      status: ProphetBiographyFieldStatus.sourceBacked,
      sources: [],
    );
    final invalidDraft = CanonicalProphetBiographyDraft(
      identity: first.identity,
      quranReferences: first.quranReferences,
      sections: sections,
    );

    final result = audit.audit(
      drafts: [invalidDraft],
      kinshipFacts: verifiedProphetKinshipFacts,
      chronology: mainApproximateProphetChronology,
    );

    expect(result.isValid, isFalse);
    expect(result.errors.any((e) => e.contains('has no source')), isTrue);
  });

  test('rejects an exact date that lacks exact-source certainty', () {
    final result = audit.audit(
      drafts: canonicalProphetBiographyDrafts,
      kinshipFacts: verifiedProphetKinshipFacts,
      chronology: mainApproximateProphetChronology,
      dateEvidenceByProphet: {
        'adam': [
          ProphetDateEvidence(
            label: const LocalizedReligiousText(
              tr: 'Kesin tarih',
              en: 'Exact date',
              ar: 'تاريخ قطعي',
            ),
            status: ProphetDateStatus.exact,
            certainty: CertaintyLevel.approximate,
            sources: [verifiedProphetKinshipFacts.first.sources.first],
            startYear: -4000,
            endYear: -4000,
          ),
        ],
      },
    );

    expect(result.isValid, isFalse);
    expect(result.errors.any((e) => e.contains('invalid prophet date evidence')), isTrue);
  });

  test('requires an explicit badge for every Israiliyat source', () {
    final first = canonicalProphetBiographyDrafts.first;
    final sections = Map<ProphetBiographySectionKey, ProphetBiographyField>.from(
      first.sections,
    );
    const israiliyatSource = SourceReference(
      id: 'qa-israiliyat-source',
      title: 'QA Israiliyat source',
      sourceClass: ReligiousSourceClass.israiliyat,
      licenseId: 'reference-only',
      locator: 'QA locator',
    );
    sections[ProphetBiographySectionKey.period] = const ProphetBiographyField(
      text: LocalizedReligiousText(
        tr: 'Geleneksel rivayet.',
        en: 'Traditional report.',
        ar: 'رواية تقليدية.',
      ),
      status: ProphetBiographyFieldStatus.sourceBacked,
      sources: [israiliyatSource],
    );
    final draft = CanonicalProphetBiographyDraft(
      identity: first.identity,
      quranReferences: first.quranReferences,
      sections: sections,
    );

    final missingBadge = audit.audit(
      drafts: [draft],
      kinshipFacts: verifiedProphetKinshipFacts,
      chronology: mainApproximateProphetChronology,
    );
    final withBadge = audit.audit(
      drafts: [draft],
      kinshipFacts: verifiedProphetKinshipFacts,
      chronology: mainApproximateProphetChronology,
      israiliyatBadgeSourceIds: const {'qa-israiliyat-source'},
    );

    expect(missingBadge.errors.any((e) => e.contains('no explicit badge evidence')), isTrue);
    expect(withBadge.errors.any((e) => e.contains('no explicit badge evidence')), isFalse);
  });

  test('rejects contradictory genealogy facts', () {
    final base = verifiedProphetKinshipFacts.last;
    final contradiction = VerifiedProphetKinshipFact(
      id: 'qa-yahya-zakariya-reversed',
      firstProphetId: base.secondProphetId,
      secondProphetId: base.firstProphetId,
      kind: VerifiedProphetKinshipKind.parentChild,
      certainty: base.certainty,
      sources: base.sources,
    );

    final result = audit.audit(
      drafts: canonicalProphetBiographyDrafts,
      kinshipFacts: [...verifiedProphetKinshipFacts, contradiction],
      chronology: mainApproximateProphetChronology,
    );

    expect(result.isValid, isFalse);
    expect(result.errors.any((e) => e.contains('contradictory genealogy facts')), isTrue);
  });

  test('rejects duplicate or contradictory timeline placement', () {
    final result = audit.audit(
      drafts: canonicalProphetBiographyDrafts,
      kinshipFacts: verifiedProphetKinshipFacts,
      chronology: [
        ...mainApproximateProphetChronology,
        mainApproximateProphetChronology.first,
      ],
    );

    expect(result.isValid, isFalse);
    expect(result.errors.any((e) => e.contains('timeline band order mismatch')), isTrue);
    expect(result.errors.any((e) => e.contains('multiple timeline bands')), isTrue);
  });
}
