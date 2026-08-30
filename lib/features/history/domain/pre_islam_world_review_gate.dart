import '../data/pre_islam_world_context.dart';

enum HistoricalCertainty {
  established,
  strong,
  plausible,
  disputed,
  unknown,
}

class HistoryReviewEvidence {
  const HistoryReviewEvidence({
    required this.entryId,
    required this.reviewedContentSnapshot,
    required this.certainty,
    required this.supportingSourceIds,
    required this.factualReviewApproved,
    required this.trNativeReviewApproved,
    required this.enNativeReviewApproved,
    required this.arNativeReviewApproved,
    required this.reviewer,
    this.uncertaintyNote,
  });

  final String entryId;
  final String reviewedContentSnapshot;
  final HistoricalCertainty certainty;
  final List<String> supportingSourceIds;
  final bool factualReviewApproved;
  final bool trNativeReviewApproved;
  final bool enNativeReviewApproved;
  final bool arNativeReviewApproved;
  final String reviewer;
  final LocalizedHistorySummary? uncertaintyNote;
}

class PreIslamWorldReviewGate {
  const PreIslamWorldReviewGate({required this.sourceFamilies});

  /// Maps a source locator ID to an independent publication/work family.
  /// Chapters from the same monograph must use the same family ID.
  final Map<String, String> sourceFamilies;

  static String contentSnapshot(PreIslamWorldContextEntry entry) {
    return [
      entry.id,
      entry.title.tr,
      entry.title.en,
      entry.title.ar,
      entry.summary.tr,
      entry.summary.en,
      entry.summary.ar,
      ...entry.sourceIds,
    ].join('\u001f');
  }

  void requireProductionReady({
    required PreIslamWorldContextEntry entry,
    required List<HistorySourceLocator> sources,
    required HistoryReviewEvidence evidence,
  }) {
    if (entry.status != HistoryResearchStatus.reviewedForProduction) {
      throw StateError('Research-draft history content cannot enter production.');
    }
    if (evidence.entryId != entry.id ||
        evidence.reviewedContentSnapshot != contentSnapshot(entry)) {
      throw StateError('History review evidence does not match exact content.');
    }
    if (!evidence.factualReviewApproved ||
        !evidence.trNativeReviewApproved ||
        !evidence.enNativeReviewApproved ||
        !evidence.arNativeReviewApproved ||
        evidence.reviewer.trim().isEmpty) {
      throw StateError('History production requires factual and TR/EN/AR review.');
    }
    if (evidence.certainty == HistoricalCertainty.unknown) {
      throw StateError('Unknown historical claims cannot be published as facts.');
    }
    if ((evidence.certainty == HistoricalCertainty.plausible ||
            evidence.certainty == HistoricalCertainty.disputed) &&
        (evidence.uncertaintyNote == null ||
            !evidence.uncertaintyNote!.isComplete)) {
      throw StateError('Non-certain history claims require a TR/EN/AR caveat.');
    }

    final knownSourceIds = sources.map((source) => source.id).toSet();
    final evidenceSourceIds = evidence.supportingSourceIds.toSet();
    if (evidenceSourceIds.length != evidence.supportingSourceIds.length ||
        evidenceSourceIds.any((sourceId) => !knownSourceIds.contains(sourceId))) {
      throw StateError('History review evidence contains duplicate or unknown sources.');
    }
    if (evidenceSourceIds.any((sourceId) => !entry.sourceIds.contains(sourceId))) {
      throw StateError('Review sources must be attached to the reviewed history entry.');
    }

    final families = <String>{};
    for (final sourceId in evidenceSourceIds) {
      final family = sourceFamilies[sourceId];
      if (family == null || family.trim().isEmpty) {
        throw StateError('Every history source must have an independence family.');
      }
      families.add(family);
    }
    if (families.length < 2) {
      throw StateError('Production history requires two independent source families.');
    }
  }
}

const preIslamWorldSourceFamilies = <String, String>{
  'grasso_2023_ch1': 'grasso_2023_pre_islamic_arabia',
  'grasso_2023_ch3': 'grasso_2023_pre_islamic_arabia',
  'grasso_2023_ch4': 'grasso_2023_pre_islamic_arabia',
  'cambridge_history_islam_pre_islamic_arabia': 'new_cambridge_history_of_islam_v1',
  'hallaq_pre_islamic_near_east': 'hallaq_origins_evolution_islamic_law',
  'hawting_idolatry': 'hawting_idea_of_idolatry',
};
