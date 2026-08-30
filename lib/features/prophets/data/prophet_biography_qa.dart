import '../../../core/content/content_governance.dart';
import 'canonical_prophet_biographies.dart';
import 'prophet_content.dart';
import 'prophet_timeline.dart';
import 'verified_prophet_family_relations.dart';

final class ProphetBiographyQaResult {
  const ProphetBiographyQaResult({required this.errors});

  final List<String> errors;

  bool get isValid => errors.isEmpty;
}

final class ProphetBiographyQaAudit {
  const ProphetBiographyQaAudit();

  ProphetBiographyQaResult audit({
    required Iterable<CanonicalProphetBiographyDraft> drafts,
    required Iterable<VerifiedProphetKinshipFact> kinshipFacts,
    required Iterable<ProphetChronologyBand> chronology,
    Map<String, List<ProphetDateEvidence>> dateEvidenceByProphet = const {},
    Set<String> israiliyatBadgeSourceIds = const {},
  }) {
    final errors = <String>[];
    final draftList = drafts.toList(growable: false);
    final chronologyList = chronology.toList(growable: false);
    final kinshipList = kinshipFacts.toList(growable: false);

    _auditBiographySources(
      draftList,
      israiliyatBadgeSourceIds,
      errors,
    );
    _auditDateEvidence(dateEvidenceByProphet, errors);
    _auditKinship(kinshipList, errors);
    _auditTimeline(chronologyList, kinshipList, errors);

    return ProphetBiographyQaResult(errors: List.unmodifiable(errors));
  }

  ProphetBiographyQaResult auditCanonicalResearchDataset() => audit(
        drafts: canonicalProphetBiographyDrafts,
        kinshipFacts: verifiedProphetKinshipFacts,
        chronology: mainApproximateProphetChronology,
      );

  void _auditBiographySources(
    List<CanonicalProphetBiographyDraft> drafts,
    Set<String> israiliyatBadgeSourceIds,
    List<String> errors,
  ) {
    for (final draft in drafts) {
      final prophetId = draft.identity.canonicalId;
      for (final entry in draft.sections.entries) {
        final field = entry.value;
        final fieldId = entry.key.name;
        if (field.status == ProphetBiographyFieldStatus.sourceBacked &&
            field.sources.isEmpty) {
          errors.add('$prophetId/$fieldId: source-backed biography sentence has no source');
        }

        for (final source in field.sources) {
          if (source.id.trim().isEmpty ||
              source.title.trim().isEmpty ||
              source.licenseId.trim().isEmpty ||
              (source.locator?.trim().isEmpty ?? true)) {
            errors.add('$prophetId/$fieldId: incomplete source metadata');
          }
          if (source.sourceClass == ReligiousSourceClass.israiliyat &&
              !israiliyatBadgeSourceIds.contains(source.id)) {
            errors.add('$prophetId/$fieldId: Israiliyat source ${source.id} has no explicit badge evidence');
          }
        }
      }
    }
  }

  void _auditDateEvidence(
    Map<String, List<ProphetDateEvidence>> evidenceByProphet,
    List<String> errors,
  ) {
    for (final entry in evidenceByProphet.entries) {
      for (final evidence in entry.value) {
        if (!evidence.isValid) {
          errors.add('${entry.key}: invalid prophet date evidence (${evidence.status.name})');
          continue;
        }
        if (evidence.status == ProphetDateStatus.exact &&
            (evidence.startYear == null ||
                evidence.endYear == null ||
                evidence.startYear != evidence.endYear ||
                evidence.certainty != CertaintyLevel.explicitSource)) {
          errors.add('${entry.key}: exact date lacks exact-source evidence');
        }
      }
    }
  }

  void _auditKinship(
    List<VerifiedProphetKinshipFact> facts,
    List<String> errors,
  ) {
    final seenIds = <String>{};
    final seenPairs = <String, VerifiedProphetKinshipFact>{};
    final parentEdges = <String, Set<String>>{};

    for (final fact in facts) {
      if (!fact.isValid) {
        errors.add('${fact.id}: invalid verified kinship fact');
        continue;
      }
      if (!seenIds.add(fact.id)) {
        errors.add('${fact.id}: duplicate kinship fact id');
      }

      final unordered = [fact.firstProphetId, fact.secondProphetId]..sort();
      final pairKey = '${unordered[0]}|${unordered[1]}';
      final previous = seenPairs[pairKey];
      if (previous != null &&
          (previous.kind != fact.kind ||
              previous.firstProphetId != fact.firstProphetId ||
              previous.secondProphetId != fact.secondProphetId)) {
        errors.add('$pairKey: contradictory genealogy facts');
      } else {
        seenPairs[pairKey] = fact;
      }

      if (fact.kind == VerifiedProphetKinshipKind.parentChild ||
          fact.kind == VerifiedProphetKinshipKind.ancestorDescendant) {
        parentEdges
            .putIfAbsent(fact.firstProphetId, () => <String>{})
            .add(fact.secondProphetId);
      }
    }

    for (final node in parentEdges.keys) {
      if (_hasDirectedCycle(node, parentEdges, <String>{}, <String>{})) {
        errors.add('genealogy graph contains a directed ancestry cycle at $node');
        break;
      }
    }
  }

  bool _hasDirectedCycle(
    String node,
    Map<String, Set<String>> edges,
    Set<String> visiting,
    Set<String> visited,
  ) {
    if (visiting.contains(node)) return true;
    if (visited.contains(node)) return false;

    visiting.add(node);
    for (final child in edges[node] ?? const <String>{}) {
      if (_hasDirectedCycle(child, edges, visiting, visited)) return true;
    }
    visiting.remove(node);
    visited.add(node);
    return false;
  }

  void _auditTimeline(
    List<ProphetChronologyBand> chronology,
    List<VerifiedProphetKinshipFact> facts,
    List<String> errors,
  ) {
    final prophetOrder = <String, int>{};
    var expectedOrder = 1;
    for (final band in chronology) {
      if (!band.isValid) {
        errors.add('timeline band ${band.order}: invalid chronology band');
      }
      if (band.order != expectedOrder) {
        errors.add('timeline band order mismatch: expected $expectedOrder, got ${band.order}');
      }
      expectedOrder++;
      for (final prophetId in band.prophetIds) {
        if (prophetOrder.containsKey(prophetId)) {
          errors.add('$prophetId: appears in multiple timeline bands');
        } else {
          prophetOrder[prophetId] = band.order;
        }
      }
    }

    for (final fact in facts) {
      if (!fact.isValid) continue;
      if (fact.kind != VerifiedProphetKinshipKind.parentChild &&
          fact.kind != VerifiedProphetKinshipKind.ancestorDescendant) {
        continue;
      }
      final olderOrder = prophetOrder[fact.firstProphetId];
      final youngerOrder = prophetOrder[fact.secondProphetId];
      if (olderOrder == null || youngerOrder == null) continue;
      if (olderOrder > youngerOrder) {
        errors.add(
          '${fact.id}: genealogy contradicts timeline (${fact.firstProphetId} after ${fact.secondProphetId})',
        );
      }
    }
  }
}
