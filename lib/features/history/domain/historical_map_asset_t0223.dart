import '../data/pre_islam_world_context.dart';
import 'history_event_contract.dart';

enum HistoricalMapRepresentation { approximateRegion, schematic }

class HistoricalMapLicense {
  const HistoricalMapLicense({
    required this.licenseId,
    required this.rightsStatement,
    required this.evidencePath,
    required this.redistributionAllowed,
    required this.aiGenerated,
  });

  final String licenseId;
  final String rightsStatement;
  final String evidencePath;
  final bool redistributionAllowed;
  final bool aiGenerated;

  bool get isEligibleForBundling =>
      licenseId.trim().isNotEmpty &&
      rightsStatement.trim().isNotEmpty &&
      evidencePath.trim().isNotEmpty &&
      redistributionAllowed &&
      !aiGenerated;
}

class HistoricalMapAsset {
  HistoricalMapAsset._({
    required this.id,
    required this.assetPath,
    required this.title,
    required this.representation,
    required this.precisionNotice,
    required this.targetGeographyIds,
    required this.sourceIds,
    required this.license,
  });

  factory HistoricalMapAsset.validated({
    required String id,
    required String assetPath,
    required LocalizedHistorySummary title,
    required HistoricalMapRepresentation representation,
    required LocalizedHistorySummary precisionNotice,
    required List<String> targetGeographyIds,
    required Set<String> knownGeographyIds,
    required List<String> sourceIds,
    required Set<String> knownSourceIds,
    required HistoricalMapLicense license,
  }) {
    final normalizedId = id.trim();
    final normalizedPath = assetPath.trim();
    if (normalizedId.isEmpty || !title.isComplete || !precisionNotice.isComplete) {
      throw StateError('T0223 map identity and TR/EN/AR labels are required.');
    }
    if (!_isLocalVectorPath(normalizedPath)) {
      throw StateError('T0223 maps must be bundled local SVG assets.');
    }
    if (!license.isEligibleForBundling) {
      throw StateError('T0223 map license/provenance is not eligible for bundling.');
    }

    final normalizedGeographies = targetGeographyIds.map((value) => value.trim()).toList(growable: false);
    if (normalizedGeographies.isEmpty ||
        normalizedGeographies.any((value) => value.isEmpty || !knownGeographyIds.contains(value)) ||
        normalizedGeographies.toSet().length != normalizedGeographies.length) {
      throw StateError('T0223 map geography links must be unique and known.');
    }

    final normalizedSources = sourceIds.map((value) => value.trim()).toList(growable: false);
    if (normalizedSources.isEmpty ||
        normalizedSources.any((value) => value.isEmpty || !knownSourceIds.contains(value)) ||
        normalizedSources.toSet().length != normalizedSources.length) {
      throw StateError('T0223 map source links must be unique and known.');
    }

    return HistoricalMapAsset._(
      id: normalizedId,
      assetPath: normalizedPath,
      title: title,
      representation: representation,
      precisionNotice: precisionNotice,
      targetGeographyIds: List.unmodifiable(normalizedGeographies),
      sourceIds: List.unmodifiable(normalizedSources),
      license: license,
    );
  }

  final String id;
  final String assetPath;
  final LocalizedHistorySummary title;
  final HistoricalMapRepresentation representation;
  final LocalizedHistorySummary precisionNotice;
  final List<String> targetGeographyIds;
  final List<String> sourceIds;
  final HistoricalMapLicense license;

  static bool _isLocalVectorPath(String path) =>
      path.startsWith('assets/history/maps/') &&
      path.toLowerCase().endsWith('.svg') &&
      !path.contains('://') &&
      !path.contains('..') &&
      !path.contains('\\');
}

class HistoricalMapCatalog {
  HistoricalMapCatalog._(this.assets);

  factory HistoricalMapCatalog.validated(List<HistoricalMapAsset> assets) {
    if (assets.isEmpty) {
      throw StateError('T0223 historical map catalog must not be empty.');
    }
    final ids = <String>{};
    final paths = <String>{};
    for (final asset in assets) {
      if (!ids.add(asset.id)) {
        throw StateError('T0223 historical map IDs must be unique.');
      }
      if (!paths.add(asset.assetPath)) {
        throw StateError('T0223 historical map asset paths must be unique.');
      }
    }
    return HistoricalMapCatalog._(List.unmodifiable(assets));
  }

  final List<HistoricalMapAsset> assets;

  List<HistoricalMapAsset> forEvent(HistoryEventRecord event) {
    final eventGeographies = event.geographies.map((value) => value.id).toSet();
    return List.unmodifiable(
      assets.where(
        (asset) => asset.targetGeographyIds.any(eventGeographies.contains),
      ),
    );
  }
}

String historicalMapRepresentationLabel(
  HistoricalMapRepresentation representation,
  String languageCode,
) {
  final language = languageCode.toLowerCase().split(RegExp('[-_]')).first;
  return switch ((representation, language)) {
    (HistoricalMapRepresentation.approximateRegion, 'tr') => 'Yaklaşık bölge haritası',
    (HistoricalMapRepresentation.approximateRegion, 'ar') => 'خريطة منطقة تقريبية',
    (HistoricalMapRepresentation.approximateRegion, _) => 'Approximate region map',
    (HistoricalMapRepresentation.schematic, 'tr') => 'Şematik harita',
    (HistoricalMapRepresentation.schematic, 'ar') => 'خريطة تخطيطية',
    (HistoricalMapRepresentation.schematic, _) => 'Schematic map',
  };
}
