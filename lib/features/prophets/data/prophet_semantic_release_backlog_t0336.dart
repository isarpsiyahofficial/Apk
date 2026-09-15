import 'canonical_prophets.dart';
import 'prophet_semantic_gap_manifest_t0336.dart';
import 'prophet_semantic_ownership_qa.dart';

/// Deterministic editorial backlog for the mandatory T0336 25 x 8 release gate.
///
/// This view never upgrades pending/unknown material to verified evidence. It
/// simply projects the canonical gap manifest into per-dimension queues so the
/// remaining religious/historical research cannot be hidden by aggregate counts.
final class ProphetSemanticDimensionBacklogT0336 {
  const ProphetSemanticDimensionBacklogT0336({
    required this.dimension,
    required this.verifiedProphetIds,
    required this.unresolvedProphetIds,
  });

  final ProphetSemanticDimension dimension;
  final List<String> verifiedProphetIds;
  final List<String> unresolvedProphetIds;

  int get verifiedCount => verifiedProphetIds.length;
  int get unresolvedCount => unresolvedProphetIds.length;
  bool get isComplete => unresolvedProphetIds.isEmpty;
}

List<ProphetSemanticDimensionBacklogT0336>
    buildProphetSemanticReleaseBacklogT0336({
  ProphetSemanticGapManifestT0336? manifest,
}) {
  final resolvedManifest = manifest ?? canonicalProphetSemanticGapManifestT0336;
  if (resolvedManifest.slots.length != resolvedManifest.requiredSlotCount ||
      resolvedManifest.silentlyMissingSlotCount != 0) {
    throw StateError(
      'T0336 release backlog requires a complete explicit 25x8 manifest',
    );
  }

  final canonicalIds = canonicalQuranNamedProphets
      .map((identity) => identity.canonicalId)
      .toSet();
  final result = <ProphetSemanticDimensionBacklogT0336>[];

  for (final dimension in ProphetSemanticDimension.values) {
    final dimensionSlots = resolvedManifest.slots
        .where((slot) => slot.dimension == dimension)
        .toList(growable: false);
    if (dimensionSlots.length != canonicalIds.length ||
        dimensionSlots.map((slot) => slot.prophetId).toSet().length !=
            canonicalIds.length) {
      throw StateError(
        'T0336 release backlog has malformed ${dimension.name} coverage',
      );
    }

    final verified = dimensionSlots
        .where((slot) => slot.isVerified)
        .map((slot) => slot.prophetId)
        .toList()
      ..sort();
    final unresolved = dimensionSlots
        .where((slot) => !slot.isVerified)
        .map((slot) => slot.prophetId)
        .toList()
      ..sort();

    result.add(
      ProphetSemanticDimensionBacklogT0336(
        dimension: dimension,
        verifiedProphetIds: List<String>.unmodifiable(verified),
        unresolvedProphetIds: List<String>.unmodifiable(unresolved),
      ),
    );
  }

  return List<ProphetSemanticDimensionBacklogT0336>.unmodifiable(result);
}

final List<ProphetSemanticDimensionBacklogT0336>
    canonicalProphetSemanticReleaseBacklogT0336 =
    buildProphetSemanticReleaseBacklogT0336();
