import 'dart:io';

import 'package:flutter_test/flutter_test.dart';
import 'package:islami_hayat/features/history/data/historical_maps_t0223.dart';
import 'package:islami_hayat/features/history/data/history_t0220_inventory.dart';
import 'package:islami_hayat/features/history/data/pre_islam_world_context.dart';
import 'package:islami_hayat/features/history/domain/historical_map_asset_t0223.dart';

const _label = LocalizedHistorySummary(tr: 'TR', en: 'EN', ar: 'AR');
const _license = HistoricalMapLicense(
  licenseId: 'TEST-ORIGINAL',
  rightsStatement: 'Test-owned vector.',
  evidencePath: 'test/evidence.md',
  redistributionAllowed: true,
  aiGenerated: false,
);

void main() {
  final knownGeographies = historyT0220Inventory.events
      .expand((event) => event.geographies)
      .map((value) => value.id)
      .toSet();
  final knownSources = historyT0220Inventory.events
      .expand((event) => event.sourceIds)
      .toSet();
  final knownSource = knownSources.first;

  test('T0223 catalog contains only local source-backed schematic SVGs', () {
    expect(historicalMapCatalogT0223.assets, hasLength(2));

    for (final asset in historicalMapCatalogT0223.assets) {
      expect(asset.assetPath, startsWith('assets/history/maps/'));
      expect(asset.assetPath, endsWith('.svg'));
      expect(asset.assetPath, isNot(contains('://')));
      expect(asset.representation, HistoricalMapRepresentation.schematic);
      expect(asset.precisionNotice.isComplete, isTrue);
      expect(asset.license.isEligibleForBundling, isTrue);
      expect(asset.license.aiGenerated, isFalse);
      expect(asset.targetGeographyIds.every(knownGeographies.contains), isTrue);
      expect(asset.sourceIds.every(knownSources.contains), isTrue);

      final svg = File(asset.assetPath).readAsStringSync();
      expect(svg, contains('<svg'));
      expect(svg.toLowerCase(), isNot(contains('<script')));
      expect(svg.toLowerCase(), isNot(contains('<image')));
      expect(svg.toLowerCase(), isNot(contains('href=')));
    }
  });

  test('T0223 labels never present a schematic as an exact map', () {
    expect(
      historicalMapRepresentationLabel(HistoricalMapRepresentation.schematic, 'tr'),
      'Şematik harita',
    );
    expect(
      historicalMapRepresentationLabel(HistoricalMapRepresentation.schematic, 'en'),
      'Schematic map',
    );
    expect(
      historicalMapRepresentationLabel(HistoricalMapRepresentation.schematic, 'ar'),
      'خريطة تخطيطية',
    );
    expect(
      historicalMapCatalogT0223.assets.every(
        (asset) => !asset.precisionNotice.tr.toLowerCase().contains('kesin konum'),
      ),
      isTrue,
    );
  });

  test('T0223 map lookup uses event geography IDs rather than fuzzy names', () {
    final meccaEvent = historyT0220Inventory.events.firstWhere(
      (event) => event.geographies.any((value) => value.id == 'city:mecca'),
    );
    final matches = historicalMapCatalogT0223.forEvent(meccaEvent);
    expect(matches.map((value) => value.id), contains('history-map:hijaz-seerah-schematic'));
  });

  test('T0223 rejects remote, traversal and raster paths', () {
    HistoricalMapAsset build(String path) => HistoricalMapAsset.validated(
          id: 'map:test',
          assetPath: path,
          title: _label,
          representation: HistoricalMapRepresentation.schematic,
          precisionNotice: _label,
          targetGeographyIds: [knownGeographies.first],
          knownGeographyIds: knownGeographies,
          sourceIds: [knownSource],
          knownSourceIds: knownSources,
          license: _license,
        );

    expect(() => build('https://example.com/map.svg'), throwsStateError);
    expect(() => build('assets/history/maps/../map.svg'), throwsStateError);
    expect(() => build('assets/history/maps/map.png'), throwsStateError);
  });

  test('T0223 rejects AI, non-redistributable, unknown geography and source metadata', () {
    HistoricalMapAsset build({
      HistoricalMapLicense license = _license,
      List<String>? geographies,
      List<String>? sources,
    }) =>
        HistoricalMapAsset.validated(
          id: 'map:test',
          assetPath: 'assets/history/maps/test.svg',
          title: _label,
          representation: HistoricalMapRepresentation.schematic,
          precisionNotice: _label,
          targetGeographyIds: geographies ?? [knownGeographies.first],
          knownGeographyIds: knownGeographies,
          sourceIds: sources ?? [knownSource],
          knownSourceIds: knownSources,
          license: license,
        );

    expect(
      () => build(
        license: const HistoricalMapLicense(
          licenseId: 'AI',
          rightsStatement: 'generated',
          evidencePath: 'evidence',
          redistributionAllowed: true,
          aiGenerated: true,
        ),
      ),
      throwsStateError,
    );
    expect(
      () => build(
        license: const HistoricalMapLicense(
          licenseId: 'NO-REDIST',
          rightsStatement: 'restricted',
          evidencePath: 'evidence',
          redistributionAllowed: false,
          aiGenerated: false,
        ),
      ),
      throwsStateError,
    );
    expect(() => build(geographies: const ['region:invented']), throwsStateError);
    expect(() => build(sources: const ['source:invented']), throwsStateError);
  });

  test('T0223 catalog rejects duplicate IDs and duplicate local asset paths', () {
    HistoricalMapAsset asset(String id, String path) => HistoricalMapAsset.validated(
          id: id,
          assetPath: path,
          title: _label,
          representation: HistoricalMapRepresentation.approximateRegion,
          precisionNotice: _label,
          targetGeographyIds: [knownGeographies.first],
          knownGeographyIds: knownGeographies,
          sourceIds: [knownSource],
          knownSourceIds: knownSources,
          license: _license,
        );

    expect(
      () => HistoricalMapCatalog.validated([
        asset('same', 'assets/history/maps/a.svg'),
        asset('same', 'assets/history/maps/b.svg'),
      ]),
      throwsStateError,
    );
    expect(
      () => HistoricalMapCatalog.validated([
        asset('a', 'assets/history/maps/same.svg'),
        asset('b', 'assets/history/maps/same.svg'),
      ]),
      throwsStateError,
    );
  });
}
