import '../domain/historical_map_asset_t0223.dart';
import 'history_t0220_inventory.dart';
import 'pre_islam_world_context.dart';

const _mapLicense = HistoricalMapLicense(
  licenseId: 'PROJECT-ORIGINAL-T0223',
  rightsStatement: 'Original schematic vector authored for this repository; no third-party map geometry or raster artwork embedded.',
  evidencePath: 'docs/HISTORY_T0223_MAP_POLICY.md',
  redistributionAllowed: true,
  aiGenerated: false,
);

LocalizedHistorySummary _text(String tr, String en, String ar) =>
    LocalizedHistorySummary(tr: tr, en: en, ar: ar);

Set<String> _knownGeographyIds() => historyT0220Inventory.events
    .expand((event) => event.geographies)
    .map((geography) => geography.id)
    .toSet();

Set<String> _knownSourceIds() => historyT0220Inventory.events
    .expand((event) => event.sourceIds)
    .toSet();

List<String> _sourcesForGeographies(Set<String> geographyIds) {
  final sources = <String>{};
  for (final event in historyT0220Inventory.events) {
    if (event.geographies.any((geography) => geographyIds.contains(geography.id))) {
      sources.addAll(event.sourceIds);
    }
  }
  if (sources.isEmpty) {
    throw StateError('T0223 map target has no source-backed T0220 event.');
  }
  final sorted = sources.toList()..sort();
  return List.unmodifiable(sorted);
}

HistoricalMapAsset _schematic({
  required String id,
  required String path,
  required LocalizedHistorySummary title,
  required Set<String> geographies,
}) =>
    HistoricalMapAsset.validated(
      id: id,
      assetPath: path,
      title: title,
      representation: HistoricalMapRepresentation.schematic,
      precisionNotice: _text(
        'Şematiktir; ölçek, sınır ve konum kesinliği iddiası taşımaz.',
        'Schematic; it does not claim exact scale, borders, or positional precision.',
        'خريطة تخطيطية؛ لا تدّعي دقة المقياس أو الحدود أو المواضع.',
      ),
      targetGeographyIds: geographies.toList()..sort(),
      knownGeographyIds: _knownGeographyIds(),
      sourceIds: _sourcesForGeographies(geographies),
      knownSourceIds: _knownSourceIds(),
      license: _mapLicense,
    );

class T0223CanonicalMapGate {
  const T0223CanonicalMapGate._();

  static const _expectedPaths = <String, String>{
    'history-map:hijaz-seerah-schematic':
        'assets/history/maps/hijaz-seerah-schematic.svg',
    'history-map:abyssinia-context-schematic':
        'assets/history/maps/abyssinia-context-schematic.svg',
  };

  static const _expectedGeographies = <String, Set<String>>{
    'history-map:hijaz-seerah-schematic': {'city:mecca', 'city:medina'},
    'history-map:abyssinia-context-schematic': {'region:abyssinia'},
  };

  static void validate(HistoricalMapCatalog catalog) {
    final actualIds = catalog.assets.map((asset) => asset.id).toSet();
    if (actualIds.length != _expectedPaths.length ||
        !actualIds.containsAll(_expectedPaths.keys)) {
      throw StateError(
        'T0223 canonical map catalog must contain exactly the governed map IDs.',
      );
    }

    for (final asset in catalog.assets) {
      final expectedPath = _expectedPaths[asset.id];
      final expectedGeographies = _expectedGeographies[asset.id];
      if (expectedPath == null || expectedGeographies == null) {
        throw StateError('T0223 encountered an ungoverned canonical map.');
      }
      if (asset.assetPath != expectedPath) {
        throw StateError('T0223 canonical map asset path drift detected.');
      }
      if (asset.representation != HistoricalMapRepresentation.schematic) {
        throw StateError('T0223 canonical maps must remain explicitly schematic.');
      }
      if (asset.license.licenseId != _mapLicense.licenseId ||
          !asset.license.isEligibleForBundling) {
        throw StateError('T0223 canonical map license/provenance drift detected.');
      }

      final actualGeographies = asset.targetGeographyIds.toSet();
      if (actualGeographies.length != expectedGeographies.length ||
          !actualGeographies.containsAll(expectedGeographies)) {
        throw StateError('T0223 canonical map geography drift detected.');
      }

      final expectedSources = _sourcesForGeographies(expectedGeographies).toSet();
      final actualSources = asset.sourceIds.toSet();
      if (actualSources.length != expectedSources.length ||
          !actualSources.containsAll(expectedSources)) {
        throw StateError('T0223 canonical map source provenance drift detected.');
      }
    }
  }
}

HistoricalMapCatalog _buildHistoricalMapCatalogT0223() {
  final catalog = HistoricalMapCatalog.validated([
    _schematic(
      id: 'history-map:hijaz-seerah-schematic',
      path: 'assets/history/maps/hijaz-seerah-schematic.svg',
      title: _text(
        'Hicaz siyer bağlamı',
        'Hijaz seerah context',
        'سياق السيرة في الحجاز',
      ),
      geographies: const {'city:mecca', 'city:medina'},
    ),
    _schematic(
      id: 'history-map:abyssinia-context-schematic',
      path: 'assets/history/maps/abyssinia-context-schematic.svg',
      title: _text(
        'Habeşistan hicreti bağlamı',
        'Abyssinia migration context',
        'سياق الهجرة إلى الحبشة',
      ),
      geographies: const {'region:abyssinia'},
    ),
  ]);
  T0223CanonicalMapGate.validate(catalog);
  return catalog;
}

final historicalMapCatalogT0223 = _buildHistoricalMapCatalogT0223();
