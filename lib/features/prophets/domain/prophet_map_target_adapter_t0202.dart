import '../data/prophet_content.dart';
import '../data/prophet_deep_links.dart';
import '../data/prophet_map_markers.dart';

/// Stable, reviewed Prophet -> Map destination.
///
/// [targetId] is an engineering identifier owned by the reviewed map dataset;
/// it is never inferred from translated place names. The geography must pass
/// the T0199 map gate before a target can exist.
final class ProphetMapTargetT0202 {
  ProphetMapTargetT0202._({
    required this.prophetId,
    required this.targetId,
    required this.geography,
    required this.marker,
  });

  factory ProphetMapTargetT0202.validated({
    required String prophetId,
    required String targetId,
    required ProphetGeography geography,
  }) {
    final normalizedProphetId = prophetId.trim();
    final normalizedTargetId = targetId.trim();
    if (normalizedProphetId.isEmpty || normalizedTargetId.isEmpty) {
      throw StateError('T0202 map target requires stable prophet and target IDs.');
    }

    final marker = mapMarkerFromGeography(geography);
    if (marker == null || !marker.isValid) {
      throw StateError('T0202 map target requires T0199-reviewed geography.');
    }

    return ProphetMapTargetT0202._(
      prophetId: normalizedProphetId,
      targetId: normalizedTargetId,
      geography: geography,
      marker: marker,
    );
  }

  final String prophetId;
  final String targetId;
  final ProphetGeography geography;
  final ProphetMapMarker marker;
}

/// Exact-ID resolver for Prophet -> Map deep links.
///
/// Cross-prophet reuse, duplicate stable IDs and invalid geography are rejected
/// fail-closed. There is deliberately no fallback search by place label.
final class ProphetMapTargetAdapterT0202 {
  ProphetMapTargetAdapterT0202(Iterable<ProphetMapTargetT0202> targets)
      : _targets = _validatedIndex(targets);

  final Map<String, ProphetMapTargetT0202> _targets;

  static String _key(String prophetId, String targetId) =>
      '${prophetId.trim()}\u0000${targetId.trim()}';

  static Map<String, ProphetMapTargetT0202> _validatedIndex(
    Iterable<ProphetMapTargetT0202> targets,
  ) {
    final result = <String, ProphetMapTargetT0202>{};
    for (final target in targets) {
      final key = _key(target.prophetId, target.targetId);
      if (result.containsKey(key)) {
        throw StateError('Duplicate T0202 prophet map target.');
      }
      result[key] = target;
    }
    return Map.unmodifiable(result);
  }

  ProphetMapTargetT0202? resolve(ProphetDeepLink link) {
    if (!link.isValid || link.kind != ProphetDeepLinkKind.map) return null;
    return _targets[_key(link.prophetId, link.targetId)];
  }

  bool canOpen(ProphetDeepLink link) => resolve(link) != null;

  Future<bool> open(
    ProphetDeepLink link, {
    required Future<void> Function(ProphetMapTargetT0202 target) onOpen,
  }) async {
    final target = resolve(link);
    if (target == null) return false;
    await onOpen(target);
    return true;
  }
}
