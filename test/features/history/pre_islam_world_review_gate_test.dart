import 'package:flutter_test/flutter_test.dart';
import 'package:islami_hayat/features/history/data/pre_islam_world_context.dart';
import 'package:islami_hayat/features/history/data/pre_islam_world_secondary_research.dart';
import 'package:islami_hayat/features/history/domain/pre_islam_world_review_gate.dart';

void main() {
  const gate = PreIslamWorldReviewGate(
    sourceFamilies: preIslamWorldSourceFamilies,
    allowedSupportingSourceIdsByEntry: preIslamWorldTopicResearchSources,
  );

  PreIslamWorldContextEntry entryById(String id) {
    return preIslamWorldContextDataset.entries.singleWhere(
      (entry) => entry.id == id,
    );
  }

  PreIslamWorldContextEntry promoted(PreIslamWorldContextEntry entry) {
    return PreIslamWorldContextEntry(
      id: entry.id,
      title: entry.title,
      summary: entry.summary,
      sourceIds: entry.sourceIds,
      status: HistoryResearchStatus.reviewedForProduction,
    );
  }

  HistoryReviewEvidence approvedEvidence(
    PreIslamWorldContextEntry entry, {
    HistoricalCertainty certainty = HistoricalCertainty.strong,
    List<String>? supportingSourceIds,
    bool arNativeReviewApproved = true,
    LocalizedHistorySummary? uncertaintyNote,
  }) {
    return HistoryReviewEvidence(
      entryId: entry.id,
      reviewedContentSnapshot: PreIslamWorldReviewGate.contentSnapshot(entry),
      certainty: certainty,
      supportingSourceIds: supportingSourceIds ??
          preIslamWorldTopicResearchSources[entry.id]!,
      factualReviewApproved: true,
      trNativeReviewApproved: true,
      enNativeReviewApproved: true,
      arNativeReviewApproved: arNativeReviewApproved,
      reviewer: 'history-editor-01',
      uncertaintyNote: uncertaintyNote,
    );
  }

  test('research drafts cannot be promoted merely because sources exist', () {
    final entry = entryById('mecca');

    expect(
      () => gate.requireProductionReady(
        entry: entry,
        sources: preIslamWorldIndependentResearch.sources,
        evidence: approvedEvidence(entry),
      ),
      throwsStateError,
    );
  });

  test('all 11 canonical topics can consume two-family research evidence', () {
    for (final draft in preIslamWorldContextDataset.entries) {
      final entry = promoted(draft);
      expect(
        () => gate.requireProductionReady(
          entry: entry,
          sources: preIslamWorldIndependentResearch.sources,
          evidence: approvedEvidence(entry),
        ),
        returnsNormally,
        reason: 'Independent evidence must be usable for ${entry.id}',
      );
    }
  });

  test('same-work chapters cannot satisfy the two-source production gate', () {
    final entry = promoted(entryById('south_arabia_yemen'));
    final evidence = approvedEvidence(
      entry,
      supportingSourceIds: const ['grasso_2023_ch3', 'grasso_2023_ch4'],
    );

    expect(
      () => gate.requireProductionReady(
        entry: entry,
        sources: preIslamWorldIndependentResearch.sources,
        evidence: evidence,
      ),
      throwsStateError,
    );
  });

  test('unapproved source cannot be substituted even when academically known', () {
    final entry = promoted(entryById('aksum'));
    final evidence = approvedEvidence(
      entry,
      supportingSourceIds: const [
        'grasso_2023_ch4',
        'hoyland_2001_arabia_arabs',
      ],
    );

    expect(
      () => gate.requireProductionReady(
        entry: entry,
        sources: preIslamWorldIndependentResearch.sources,
        evidence: evidence,
      ),
      throwsStateError,
    );
  });

  test('content edits invalidate previously reviewed evidence', () {
    final entry = promoted(entryById('mecca'));
    final evidence = HistoryReviewEvidence(
      entryId: entry.id,
      reviewedContentSnapshot:
          '${PreIslamWorldReviewGate.contentSnapshot(entry)}-stale',
      certainty: HistoricalCertainty.strong,
      supportingSourceIds: preIslamWorldTopicResearchSources[entry.id]!,
      factualReviewApproved: true,
      trNativeReviewApproved: true,
      enNativeReviewApproved: true,
      arNativeReviewApproved: true,
      reviewer: 'history-editor-01',
    );

    expect(
      () => gate.requireProductionReady(
        entry: entry,
        sources: preIslamWorldIndependentResearch.sources,
        evidence: evidence,
      ),
      throwsStateError,
    );
  });

  test('plausible or disputed claims require a complete TR EN AR caveat', () {
    final entry = promoted(entryById('mecca'));

    expect(
      () => gate.requireProductionReady(
        entry: entry,
        sources: preIslamWorldIndependentResearch.sources,
        evidence: approvedEvidence(
          entry,
          certainty: HistoricalCertainty.plausible,
        ),
      ),
      throwsStateError,
    );

    expect(
      () => gate.requireProductionReady(
        entry: entry,
        sources: preIslamWorldIndependentResearch.sources,
        evidence: approvedEvidence(
          entry,
          certainty: HistoricalCertainty.disputed,
          uncertaintyNote: const LocalizedHistorySummary(
            tr: 'Kaynaklar ve yorumlar ayrışmaktadır.',
            en: 'Sources and interpretations differ.',
            ar: 'تختلف المصادر والتفسيرات في هذه المسألة.',
          ),
        ),
      ),
      returnsNormally,
    );
  });

  test('unknown certainty and incomplete native review fail closed', () {
    final entry = promoted(entryById('mecca'));

    expect(
      () => gate.requireProductionReady(
        entry: entry,
        sources: preIslamWorldIndependentResearch.sources,
        evidence: approvedEvidence(
          entry,
          certainty: HistoricalCertainty.unknown,
        ),
      ),
      throwsStateError,
    );
    expect(
      () => gate.requireProductionReady(
        entry: entry,
        sources: preIslamWorldIndependentResearch.sources,
        evidence: approvedEvidence(entry, arNativeReviewApproved: false),
      ),
      throwsStateError,
    );
  });
}