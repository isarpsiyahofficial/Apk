import 'prophet_content.dart';

enum ProphetDeepLinkKind { quranVerse, dua, islamicHistory, map }

/// Typed internal navigation contract for SPEC 885–888 / T0202.
///
/// This layer deliberately does not guess a history event or map location from a
/// prophet name. History/map IDs must be supplied by their reviewed datasets;
/// absent targets stay absent instead of opening an invented destination.
final class ProphetDeepLink {
  const ProphetDeepLink._({
    required this.kind,
    required this.prophetId,
    required this.targetId,
    this.surah,
    this.ayah,
  });

  factory ProphetDeepLink.quranVerse({
    required String prophetId,
    required ProphetVerseReference verse,
  }) =>
      ProphetDeepLink._(
        kind: ProphetDeepLinkKind.quranVerse,
        prophetId: prophetId,
        targetId: verse.stableId,
        surah: verse.surah,
        ayah: verse.ayah,
      );

  factory ProphetDeepLink.dua({
    required String prophetId,
    required String duaId,
  }) =>
      ProphetDeepLink._(
        kind: ProphetDeepLinkKind.dua,
        prophetId: prophetId,
        targetId: duaId,
      );

  factory ProphetDeepLink.islamicHistory({
    required String prophetId,
    required String historyEventId,
  }) =>
      ProphetDeepLink._(
        kind: ProphetDeepLinkKind.islamicHistory,
        prophetId: prophetId,
        targetId: historyEventId,
      );

  factory ProphetDeepLink.map({
    required String prophetId,
    required String mapLocationId,
  }) =>
      ProphetDeepLink._(
        kind: ProphetDeepLinkKind.map,
        prophetId: prophetId,
        targetId: mapLocationId,
      );

  final ProphetDeepLinkKind kind;
  final String prophetId;
  final String targetId;
  final int? surah;
  final int? ayah;

  bool get isValid {
    if (prophetId.trim().isEmpty || targetId.trim().isEmpty) return false;
    switch (kind) {
      case ProphetDeepLinkKind.quranVerse:
        final verse = ProphetVerseReference(surah: surah ?? 0, ayah: ayah ?? 0);
        return verse.isValid && targetId == verse.stableId;
      case ProphetDeepLinkKind.dua:
      case ProphetDeepLinkKind.islamicHistory:
      case ProphetDeepLinkKind.map:
        return surah == null && ayah == null;
    }
  }

  Uri get uri {
    if (!isValid) {
      throw StateError('Invalid prophet deep link cannot be serialized.');
    }
    final pathSegments = switch (kind) {
      ProphetDeepLinkKind.quranVerse => <String>[
          'verse',
          surah.toString(),
          ayah.toString(),
        ],
      ProphetDeepLinkKind.dua => <String>[targetId],
      ProphetDeepLinkKind.islamicHistory => <String>[targetId],
      ProphetDeepLinkKind.map => <String>[targetId],
    };
    final host = switch (kind) {
      ProphetDeepLinkKind.quranVerse => 'quran',
      ProphetDeepLinkKind.dua => 'dua',
      ProphetDeepLinkKind.islamicHistory => 'history',
      ProphetDeepLinkKind.map => 'prophet-map',
    };
    return Uri(
      scheme: 'islami-hayat',
      host: host,
      pathSegments: pathSegments,
      queryParameters: <String, String>{'prophet': prophetId},
    );
  }
}

final class ProphetDeepLinkBundle {
  const ProphetDeepLinkBundle({
    required this.prophetId,
    required this.quranReferences,
    required this.duaReferences,
    this.historyEventIds = const <String>[],
    this.mapLocationIds = const <String>[],
  });

  factory ProphetDeepLinkBundle.fromProphetContent(
    ProphetContent content, {
    Iterable<String> verifiedHistoryEventIds = const <String>[],
    Iterable<String> verifiedMapLocationIds = const <String>[],
  }) =>
      ProphetDeepLinkBundle(
        prophetId: content.canonicalId,
        quranReferences: content.quranReferences,
        duaReferences: content.duaReferences,
        historyEventIds: verifiedHistoryEventIds.toList(growable: false),
        mapLocationIds: verifiedMapLocationIds.toList(growable: false),
      );

  final String prophetId;
  final List<ProphetVerseReference> quranReferences;
  final List<ProphetDuaReference> duaReferences;
  final List<String> historyEventIds;
  final List<String> mapLocationIds;

  List<String> audit() {
    final issues = <String>[];
    if (prophetId.trim().isEmpty) issues.add('missing prophet id');
    if (quranReferences.any((reference) => !reference.isValid)) {
      issues.add('invalid Quran reference');
    }
    if (duaReferences.any((reference) => !reference.isValid)) {
      issues.add('invalid dua reference');
    }
    if (historyEventIds.any((id) => id.trim().isEmpty)) {
      issues.add('invalid history event id');
    }
    if (mapLocationIds.any((id) => id.trim().isEmpty)) {
      issues.add('invalid map location id');
    }

    void checkDuplicates(Iterable<String> ids, String label) {
      final values = ids.toList(growable: false);
      if (values.toSet().length != values.length) {
        issues.add('duplicate $label target');
      }
    }

    checkDuplicates(quranReferences.map((reference) => reference.stableId), 'Quran');
    checkDuplicates(duaReferences.map((reference) => reference.duaId), 'dua');
    checkDuplicates(historyEventIds, 'history');
    checkDuplicates(mapLocationIds, 'map');
    return issues;
  }

  List<ProphetDeepLink> buildLinks() {
    final issues = audit();
    if (issues.isNotEmpty) {
      throw StateError('Invalid prophet deep-link bundle: ${issues.join(', ')}');
    }
    return <ProphetDeepLink>[
      for (final verse in quranReferences)
        ProphetDeepLink.quranVerse(prophetId: prophetId, verse: verse),
      for (final dua in duaReferences)
        ProphetDeepLink.dua(prophetId: prophetId, duaId: dua.duaId),
      for (final eventId in historyEventIds)
        ProphetDeepLink.islamicHistory(
          prophetId: prophetId,
          historyEventId: eventId,
        ),
      for (final locationId in mapLocationIds)
        ProphetDeepLink.map(prophetId: prophetId, mapLocationId: locationId),
    ];
  }
}

ProphetDeepLink? parseProphetDeepLink(Uri uri) {
  if (uri.scheme != 'islami-hayat') return null;
  final prophetId = uri.queryParameters['prophet']?.trim() ?? '';
  if (prophetId.isEmpty) return null;

  ProphetDeepLink? link;
  switch (uri.host) {
    case 'quran':
      if (uri.pathSegments.length != 3 || uri.pathSegments.first != 'verse') {
        return null;
      }
      final surah = int.tryParse(uri.pathSegments[1]);
      final ayah = int.tryParse(uri.pathSegments[2]);
      if (surah == null || ayah == null) return null;
      link = ProphetDeepLink.quranVerse(
        prophetId: prophetId,
        verse: ProphetVerseReference(surah: surah, ayah: ayah),
      );
    case 'dua':
      if (uri.pathSegments.length != 1) return null;
      link = ProphetDeepLink.dua(
        prophetId: prophetId,
        duaId: uri.pathSegments.single,
      );
    case 'history':
      if (uri.pathSegments.length != 1) return null;
      link = ProphetDeepLink.islamicHistory(
        prophetId: prophetId,
        historyEventId: uri.pathSegments.single,
      );
    case 'prophet-map':
      if (uri.pathSegments.length != 1) return null;
      link = ProphetDeepLink.map(
        prophetId: prophetId,
        mapLocationId: uri.pathSegments.single,
      );
    default:
      return null;
  }
  return link.isValid ? link : null;
}
