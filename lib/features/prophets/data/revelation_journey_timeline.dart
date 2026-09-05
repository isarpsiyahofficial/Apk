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
          source.sourceClass != ReligiousSourceClass.israiliyat &&
          source.sourceClass != ReligiousSourceClass.laterTradition &&
          source.sourceClass != ReligiousSourceClass.disputed &&
          source.sourceClass != ReligiousSourceClass.unknown,
    );
  }
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

bool get revelationJourneyTimelineIsValid {
  final timeline = buildRevelationJourneyTimeline();
  if (!mainApproximateProphetChronologyIsValid || timeline.isEmpty) return false;
  if (timeline.any((segment) => !segment.isValid)) return false;

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

  final flattened = timeline
      .expand((segment) => segment.prophetIds)
      .toList(growable: false);
  final canonicalIds = canonicalQuranNamedProphets
      .map((entry) => entry.canonicalId)
      .toSet();

  if (flattened.length != 25 ||
      flattened.toSet().length != 25 ||
      flattened.toSet().difference(canonicalIds).isNotEmpty ||
      canonicalIds.difference(flattened.toSet()).isNotEmpty) {
    return false;
  }

  return RevelationJourneyPeriod.values.every(
    (period) => timeline.any((segment) => segment.period == period),
  );
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
