import '../../../core/content/content_governance.dart';
import 'canonical_prophets.dart';
import 'prophet_timeline.dart';

/// T0197 — user-facing Revelation Journey timeline domain model.
///
/// The model intentionally derives from the already-audited T0193 chronology
/// instead of introducing a second independent ordering. It supports period
/// browsing and parallel lanes while refusing exact dates that are not present
/// in reliable source material.
enum RevelationJourneyPeriod {
  firstProphets,
  abrahamic,
  israelite,
  isa,
  muhammad,
}

/// Only source families capable of supporting a broad chronology/navigation
/// statement may drive a Revelation Journey segment. Application-wide source
/// classes such as meaning-based dua, classical devotional practice or
/// ebced/havas are valid elsewhere but are never chronology evidence.
const Set<ReligiousSourceClass> revelationJourneySourceClassAllowlist = {
  ReligiousSourceClass.quran,
  ReligiousSourceClass.sahihHasanHadith,
  ReligiousSourceClass.earlyIslamicHistoryTafsir,
  ReligiousSourceClass.modernHistoryArchaeology,
};

class RevelationJourneySegment {
  const RevelationJourneySegment({
    required this.order,
    required this.period,
    required this.prophetIds,
    required this.isParallel,
    required this.certainty,
    required this.sources,
  });

  final int order;
  final RevelationJourneyPeriod period;
  final List<String> prophetIds;
  final bool isParallel;
  final CertaintyLevel certainty;
  final List<SourceReference> sources;

  bool get isValid {
    if (order <= 0 || prophetIds.isEmpty) return false;
    if (prophetIds.toSet().length != prophetIds.length) return false;
    if (isParallel && prophetIds.length < 2) return false;
    if (!isParallel && prophetIds.length != 1) return false;
    if (certainty != CertaintyLevel.approximate) return false;
    if (sources.isEmpty) return false;
    return sources.every(
      (source) =>
          source.id.trim().isNotEmpty &&
          source.title.trim().isNotEmpty &&
          source.licenseId.trim().isNotEmpty &&
          (source.locator?.trim().isNotEmpty ?? false) &&
          revelationJourneySourceClassAllowlist.contains(source.sourceClass),
    );
  }
}

class RevelationJourneyAuditResult {
  const RevelationJourneyAuditResult({
    required this.isValid,
    required this.errors,
  });

  final bool isValid;
  final List<String> errors;
}

List<RevelationJourneySegment> buildRevelationJourneyTimeline() {
  return mainApproximateProphetChronology
      .map(
        (band) => RevelationJourneySegment(
          order: band.order,
          period: _periodForOrder(band.order),
          prophetIds: List.unmodifiable(band.prophetIds),
          isParallel: band.kind == ProphetChronologyBandKind.parallel,
          certainty: band.certainty,
          sources: List.unmodifiable(band.sources),
        ),
      )
      .toList(growable: false);
}

List<RevelationJourneySegment> revelationJourneyForPeriod(
  RevelationJourneyPeriod period,
) =>
    buildRevelationJourneyTimeline()
        .where((segment) => segment.period == period)
        .toList(growable: false);

/// Whole-timeline failure-path audit for T0197.
///
/// This is intentionally separate from [RevelationJourneySegment.isValid]: a
/// collection can contain individually valid segments while still duplicating
/// a prophet, omitting a canonical prophet, reusing an order, skipping an order
/// or placing a segment under a browse period inconsistent with the canonical
/// broad chronology.
RevelationJourneyAuditResult auditRevelationJourneyTimeline(
  Iterable<RevelationJourneySegment> segments,
) {
  final timeline = segments.toList(growable: false);
  final errors = <String>[];

  if (timeline.isEmpty) {
    errors.add('timeline must not be empty');
    return RevelationJourneyAuditResult(
      isValid: false,
      errors: List.unmodifiable(errors),
    );
  }

  for (final segment in timeline) {
    if (!segment.isValid) {
      errors.add('segment ${segment.order} is invalid');
    }
  }

  final ordered = [...timeline]..sort((a, b) => a.order.compareTo(b.order));
  for (var index = 0; index < ordered.length; index++) {
    final expectedOrder = index + 1;
    final segment = ordered[index];
    if (segment.order != expectedOrder) {
      errors.add(
        'timeline order must be contiguous: expected $expectedOrder, got ${segment.order}',
      );
    }
    final expectedPeriod = _periodForOrder(segment.order);
    if (segment.period != expectedPeriod) {
      errors.add(
        'segment ${segment.order} has period ${segment.period.name}; '
        'expected ${expectedPeriod.name}',
      );
    }
  }

  final flattened = ordered
      .expand((segment) => segment.prophetIds)
      .toList(growable: false);
  final flattenedSet = flattened.toSet();
  final canonicalIds = canonicalQuranNamedProphets
      .map((entry) => entry.canonicalId)
      .toSet();

  if (flattenedSet.length != flattened.length) {
    errors.add('timeline contains duplicate prophet ids');
  }
  final missing = canonicalIds.difference(flattenedSet);
  if (missing.isNotEmpty) {
    errors.add('timeline is missing canonical prophets: ${missing.join(',')}');
  }
  final unknown = flattenedSet.difference(canonicalIds);
  if (unknown.isNotEmpty) {
    errors.add('timeline contains non-canonical prophet ids: ${unknown.join(',')}');
  }
  if (flattened.length != canonicalIds.length) {
    errors.add(
      'timeline must contain exactly ${canonicalIds.length} canonical prophets',
    );
  }

  for (final period in RevelationJourneyPeriod.values) {
    if (!ordered.any((segment) => segment.period == period)) {
      errors.add('timeline has no segment for period ${period.name}');
    }
  }

  return RevelationJourneyAuditResult(
    isValid: errors.isEmpty,
    errors: List.unmodifiable(errors),
  );
}

bool get revelationJourneyTimelineIsValid {
  if (!mainApproximateProphetChronologyIsValid) return false;

  final timeline = buildRevelationJourneyTimeline();
  final audit = auditRevelationJourneyTimeline(timeline);
  if (!audit.isValid) return false;

  for (var index = 0; index < timeline.length; index++) {
    final segment = timeline[index];
    final sourceBand = mainApproximateProphetChronology[index];
    if (segment.order != sourceBand.order ||
        segment.isParallel !=
            (sourceBand.kind == ProphetChronologyBandKind.parallel) ||
        !_sameIds(segment.prophetIds, sourceBand.prophetIds)) {
      return false;
    }
  }

  return true;
}

RevelationJourneyPeriod _periodForOrder(int order) {
  if (order <= 5) return RevelationJourneyPeriod.firstProphets;
  if (order <= 11) return RevelationJourneyPeriod.abrahamic;
  if (order <= 20) return RevelationJourneyPeriod.israelite;
  if (order == 21) return RevelationJourneyPeriod.isa;
  return RevelationJourneyPeriod.muhammad;
}

bool _sameIds(List<String> left, List<String> right) {
  if (left.length != right.length) return false;
  for (var index = 0; index < left.length; index++) {
    if (left[index] != right[index]) return false;
  }
  return true;
}
