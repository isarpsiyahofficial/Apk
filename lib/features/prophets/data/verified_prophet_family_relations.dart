import '../../../core/content/content_governance.dart';
import 'canonical_prophets.dart';
import 'prophet_content.dart';
import 'prophet_timeline.dart';

/// T0198 — fail-closed prophet family/genealogy graph.
///
/// Only relations stated explicitly enough by a trusted source enter this graph.
/// No sibling, parent, ancestor or descendant relation is inferred transitively.
enum VerifiedProphetKinshipKind {
  parentChild,
  siblings,
  ancestorDescendant,
}

class VerifiedProphetKinshipFact {
  const VerifiedProphetKinshipFact({
    required this.id,
    required this.firstProphetId,
    required this.secondProphetId,
    required this.kind,
    required this.certainty,
    required this.sources,
  });

  /// Stable audit identifier for the exact relationship claim.
  final String id;

  /// For [VerifiedProphetKinshipKind.parentChild], the first prophet is the
  /// parent. For [VerifiedProphetKinshipKind.ancestorDescendant], the first is
  /// the ancestor. Sibling relations are undirected.
  final String firstProphetId;
  final String secondProphetId;
  final VerifiedProphetKinshipKind kind;
  final CertaintyLevel certainty;
  final List<SourceReference> sources;

  bool get isValid {
    if (id.trim().isEmpty ||
        firstProphetId.trim().isEmpty ||
        secondProphetId.trim().isEmpty ||
        firstProphetId == secondProphetId ||
        certainty != CertaintyLevel.explicitSource ||
        sources.isEmpty) {
      return false;
    }

    final canonicalIds = canonicalQuranNamedProphets
        .map((entry) => entry.canonicalId)
        .toSet();
    if (!canonicalIds.contains(firstProphetId) ||
        !canonicalIds.contains(secondProphetId)) {
      return false;
    }

    return _isReviewedFamilyClaim(this);
  }

  List<ProphetFamilyRelation> asRelations() {
    if (!isValid) {
      throw StateError('Unverified prophet family fact: $id');
    }

    return switch (kind) {
      VerifiedProphetKinshipKind.parentChild => [
          ProphetFamilyRelation(
            relatedPersonId: secondProphetId,
            type: ProphetRelationType.child,
            certainty: certainty,
            sources: sources,
          ),
          ProphetFamilyRelation(
            relatedPersonId: firstProphetId,
            type: ProphetRelationType.parent,
            certainty: certainty,
            sources: sources,
          ),
        ],
      VerifiedProphetKinshipKind.siblings => [
          ProphetFamilyRelation(
            relatedPersonId: secondProphetId,
            type: ProphetRelationType.sibling,
            certainty: certainty,
            sources: sources,
          ),
          ProphetFamilyRelation(
            relatedPersonId: firstProphetId,
            type: ProphetRelationType.sibling,
            certainty: certainty,
            sources: sources,
          ),
        ],
      VerifiedProphetKinshipKind.ancestorDescendant => [
          ProphetFamilyRelation(
            relatedPersonId: secondProphetId,
            type: ProphetRelationType.descendant,
            certainty: certainty,
            sources: sources,
          ),
          ProphetFamilyRelation(
            relatedPersonId: firstProphetId,
            type: ProphetRelationType.ancestor,
            certainty: certainty,
            sources: sources,
          ),
        ],
    };
  }
}

const _musaHarunSiblingSource = SourceReference(
  id: 'tanzil-uthmani-v1.1-q20-30',
  title: 'Tanzil Project — Uthmani Quran Text v1.1',
  sourceClass: ReligiousSourceClass.quran,
  licenseId: 'CC-BY-3.0',
  locator: 'Quran 20:30',
);

const _zakariyaYahyaParentSource = SourceReference(
  id: 'tanzil-uthmani-v1.1-q19-7',
  title: 'Tanzil Project — Uthmani Quran Text v1.1',
  sourceClass: ReligiousSourceClass.quran,
  licenseId: 'CC-BY-3.0',
  locator: 'Quran 19:7',
);

const _ibrahimIsmailIshaqParentSource = SourceReference(
  id: 'tanzil-uthmani-v1.1-q14-39',
  title: 'Tanzil Project — Uthmani Quran Text v1.1',
  sourceClass: ReligiousSourceClass.quran,
  licenseId: 'CC-BY-3.0',
  locator: 'Quran 14:39',
);

const _dawudSulaymanParentSource = SourceReference(
  id: 'tanzil-uthmani-v1.1-q38-30',
  title: 'Tanzil Project — Uthmani Quran Text v1.1',
  sourceClass: ReligiousSourceClass.quran,
  licenseId: 'CC-BY-3.0',
  locator: 'Quran 38:30',
);

/// Intentionally conservative reviewed facts.
///
/// Quran 20:30 explicitly identifies Harun as Musa's brother; Quran 19:7
/// gives Zakariya glad tidings of a son named Yahya; Quran 14:39 records
/// Ibrahim thanking Allah for granting him Ismail and Ishaq; and Quran 38:30
/// states that Sulayman was granted to Dawud. The latter parent/child reading
/// is independently cross-checked against Diyanet Kur'an Yolu tafsir before
/// entering this reviewed graph. Other commonly repeated genealogies remain
/// outside this graph until their exact relationship and source class are
/// independently reviewed.
const verifiedProphetKinshipFacts = <VerifiedProphetKinshipFact>[
  VerifiedProphetKinshipFact(
    id: 'musa-harun-siblings-q20-30',
    firstProphetId: 'musa',
    secondProphetId: 'harun',
    kind: VerifiedProphetKinshipKind.siblings,
    certainty: CertaintyLevel.explicitSource,
    sources: [_musaHarunSiblingSource],
  ),
  VerifiedProphetKinshipFact(
    id: 'zakariya-yahya-parent-child-q19-7',
    firstProphetId: 'zakariya',
    secondProphetId: 'yahya',
    kind: VerifiedProphetKinshipKind.parentChild,
    certainty: CertaintyLevel.explicitSource,
    sources: [_zakariyaYahyaParentSource],
  ),
  VerifiedProphetKinshipFact(
    id: 'ibrahim-ismail-parent-child-q14-39',
    firstProphetId: 'ibrahim',
    secondProphetId: 'ismail',
    kind: VerifiedProphetKinshipKind.parentChild,
    certainty: CertaintyLevel.explicitSource,
    sources: [_ibrahimIsmailIshaqParentSource],
  ),
  VerifiedProphetKinshipFact(
    id: 'ibrahim-ishaq-parent-child-q14-39',
    firstProphetId: 'ibrahim',
    secondProphetId: 'ishaq',
    kind: VerifiedProphetKinshipKind.parentChild,
    certainty: CertaintyLevel.explicitSource,
    sources: [_ibrahimIsmailIshaqParentSource],
  ),
  VerifiedProphetKinshipFact(
    id: 'dawud-sulayman-parent-child-q38-30',
    firstProphetId: 'dawud',
    secondProphetId: 'sulayman',
    kind: VerifiedProphetKinshipKind.parentChild,
    certainty: CertaintyLevel.explicitSource,
    sources: [_dawudSulaymanParentSource],
  ),
];

List<ProphetFamilyRelation> verifiedFamilyRelationsFor(String canonicalId) {
  final canonicalIds = canonicalQuranNamedProphets
      .map((entry) => entry.canonicalId)
      .toSet();
  if (!canonicalIds.contains(canonicalId)) {
    throw ArgumentError.value(canonicalId, 'canonicalId', 'Unknown prophet id');
  }

  final result = <ProphetFamilyRelation>[];
  for (final fact in verifiedProphetKinshipFacts) {
    if (!fact.isValid) continue;
    if (fact.firstProphetId == canonicalId) {
      result.add(fact.asRelations().first);
    } else if (fact.secondProphetId == canonicalId) {
      result.add(fact.asRelations().last);
    }
  }
  return List.unmodifiable(result);
}

bool get verifiedProphetFamilyGraphIsValid =>
    verifiedProphetFamilyGraphIsValidFor(verifiedProphetKinshipFacts);

/// Cross-checks reviewed family direction against the separately governed
/// approximate chronology bands without promoting those bands to exact dates.
/// Parent/ancestor must precede child/descendant; siblings may share a band.
bool get verifiedProphetFamilyChronologyIsConsistent =>
    verifiedProphetFamilyChronologyIsConsistentFor(verifiedProphetKinshipFacts);

bool verifiedProphetFamilyChronologyIsConsistentFor(
  Iterable<VerifiedProphetKinshipFact> facts,
) {
  if (!mainApproximateProphetChronologyIsValid) return false;

  final orderByProphet = <String, int>{};
  for (final band in mainApproximateProphetChronology) {
    for (final prophetId in band.prophetIds) {
      orderByProphet[prophetId] = band.order;
    }
  }

  for (final fact in facts) {
    if (!fact.isValid) return false;
    final firstOrder = orderByProphet[fact.firstProphetId];
    final secondOrder = orderByProphet[fact.secondProphetId];
    if (firstOrder == null || secondOrder == null) return false;

    switch (fact.kind) {
      case VerifiedProphetKinshipKind.parentChild:
      case VerifiedProphetKinshipKind.ancestorDescendant:
        if (firstOrder >= secondOrder) return false;
      case VerifiedProphetKinshipKind.siblings:
        if (firstOrder != secondOrder) return false;
    }
  }
  return true;
}

/// Audits a complete candidate graph rather than only validating facts in
/// isolation. This prevents individually plausible records from forming a
/// contradictory genealogy when composed together.
bool verifiedProphetFamilyGraphIsValidFor(
  Iterable<VerifiedProphetKinshipFact> facts,
) {
  final factList = List<VerifiedProphetKinshipFact>.unmodifiable(facts);
  if (factList.isEmpty || factList.any((fact) => !fact.isValid)) {
    return false;
  }

  final ids = factList.map((fact) => fact.id).toList();
  if (ids.toSet().length != ids.length) return false;

  final pairs = <String>{};
  final directedEdges = <String, Set<String>>{};
  for (final fact in factList) {
    final pair = [fact.firstProphetId, fact.secondProphetId]..sort();
    final pairKey = '${pair[0]}|${pair[1]}';

    // A canonical pair may carry only one reviewed relationship claim. This
    // rejects sibling-vs-parent, reversed parent-child and duplicate claims.
    if (!pairs.add(pairKey)) return false;

    final relations = fact.asRelations();
    if (relations.length != 2 || relations.any((relation) => !relation.isValid)) {
      return false;
    }

    if (fact.kind == VerifiedProphetKinshipKind.parentChild ||
        fact.kind == VerifiedProphetKinshipKind.ancestorDescendant) {
      directedEdges
          .putIfAbsent(fact.firstProphetId, () => <String>{})
          .add(fact.secondProphetId);
    }
  }

  return !_containsDirectedAncestryCycle(directedEdges);
}

bool _containsDirectedAncestryCycle(Map<String, Set<String>> edges) {
  final visiting = <String>{};
  final visited = <String>{};

  bool visit(String node) {
    if (visiting.contains(node)) return true;
    if (visited.contains(node)) return false;

    visiting.add(node);
    for (final next in edges[node] ?? const <String>{}) {
      if (visit(next)) return true;
    }
    visiting.remove(node);
    visited.add(node);
    return false;
  }

  for (final node in edges.keys) {
    if (visit(node)) return true;
  }
  return false;
}

bool _isReviewedFamilyClaim(VerifiedProphetKinshipFact fact) {
  if (fact.sources.length != 1) return false;

  return switch (fact.id) {
    'musa-harun-siblings-q20-30' =>
      fact.firstProphetId == 'musa' &&
          fact.secondProphetId == 'harun' &&
          fact.kind == VerifiedProphetKinshipKind.siblings &&
          _sameSource(fact.sources.single, _musaHarunSiblingSource),
    'zakariya-yahya-parent-child-q19-7' =>
      fact.firstProphetId == 'zakariya' &&
          fact.secondProphetId == 'yahya' &&
          fact.kind == VerifiedProphetKinshipKind.parentChild &&
          _sameSource(fact.sources.single, _zakariyaYahyaParentSource),
    'ibrahim-ismail-parent-child-q14-39' =>
      fact.firstProphetId == 'ibrahim' &&
          fact.secondProphetId == 'ismail' &&
          fact.kind == VerifiedProphetKinshipKind.parentChild &&
          _sameSource(fact.sources.single, _ibrahimIsmailIshaqParentSource),
    'ibrahim-ishaq-parent-child-q14-39' =>
      fact.firstProphetId == 'ibrahim' &&
          fact.secondProphetId == 'ishaq' &&
          fact.kind == VerifiedProphetKinshipKind.parentChild &&
          _sameSource(fact.sources.single, _ibrahimIsmailIshaqParentSource),
    'dawud-sulayman-parent-child-q38-30' =>
      fact.firstProphetId == 'dawud' &&
          fact.secondProphetId == 'sulayman' &&
          fact.kind == VerifiedProphetKinshipKind.parentChild &&
          _sameSource(fact.sources.single, _dawudSulaymanParentSource),
    _ => false,
  };
}

bool _sameSource(SourceReference actual, SourceReference reviewed) {
  return actual.id == reviewed.id &&
      actual.title == reviewed.title &&
      actual.sourceClass == reviewed.sourceClass &&
      actual.licenseId == reviewed.licenseId &&
      actual.locator == reviewed.locator;
}
