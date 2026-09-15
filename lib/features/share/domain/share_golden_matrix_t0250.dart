import 'package:islami_hayat/features/share/domain/share_canvas_layout_t0242.dart';
import 'package:islami_hayat/features/share/domain/visual_asset_catalog_t0240.dart';

class ShareGoldenCaseT0250 {
  const ShareGoldenCaseT0250({
    required this.assetId,
    required this.assetPath,
    required this.format,
    required this.pixelWidth,
    required this.pixelHeight,
  });

  final String assetId;
  final String assetPath;
  final ShareCanvasFormatT0242 format;
  final int pixelWidth;
  final int pixelHeight;

  String get goldenKey => '${assetId}_${format.name}_${pixelWidth}x$pixelHeight';
}

class ShareGoldenResultT0250 {
  const ShareGoldenResultT0250({
    required this.goldenKey,
    required this.pixelWidth,
    required this.pixelHeight,
    required this.safeAreaPassed,
    required this.readabilityPassed,
    required this.goldenMatched,
  });

  final String goldenKey;
  final int pixelWidth;
  final int pixelHeight;
  final bool safeAreaPassed;
  final bool readabilityPassed;
  final bool goldenMatched;
}

class ShareGoldenMatrixT0250 {
  ShareGoldenMatrixT0250._(this.cases);

  factory ShareGoldenMatrixT0250.forFinalCatalog(
    VisualAssetCatalogT0240 catalog,
  ) {
    final cases = <ShareGoldenCaseT0250>[];
    for (final entry in catalog.entries) {
      final assetPath = entry.localAssetPath;
      if (assetPath == null) {
        throw StateError('T0250 requires a bundled path for ${entry.id}.');
      }
      for (final format in ShareCanvasFormatT0242.values) {
        final layout = ShareCanvasLayoutT0242.forFormat(format)..validate();
        cases.add(
          ShareGoldenCaseT0250(
            assetId: entry.id,
            assetPath: assetPath,
            format: format,
            pixelWidth: layout.pixelWidth,
            pixelHeight: layout.pixelHeight,
          ),
        );
      }
    }

    if (cases.length != requiredCaseCount) {
      throw StateError(
        'T0250 requires exactly $requiredCaseCount asset/format cases; '
        'received ${cases.length}.',
      );
    }
    final uniqueKeys = cases.map((testCase) => testCase.goldenKey).toSet();
    if (uniqueKeys.length != requiredCaseCount) {
      throw StateError('T0250 golden case keys must be unique.');
    }
    return ShareGoldenMatrixT0250._(List.unmodifiable(cases));
  }

  static const requiredAssetCount = 100;
  static const formatsPerAsset = 4;
  static const requiredCaseCount = requiredAssetCount * formatsPerAsset;

  final List<ShareGoldenCaseT0250> cases;

  void requireCompleteResults(Iterable<ShareGoldenResultT0250> results) {
    final byKey = <String, ShareGoldenResultT0250>{};
    for (final result in results) {
      if (byKey.containsKey(result.goldenKey)) {
        throw StateError('Duplicate T0250 golden result: ${result.goldenKey}.');
      }
      byKey[result.goldenKey] = result;
    }

    if (byKey.length != requiredCaseCount) {
      throw StateError(
        'T0250 requires $requiredCaseCount golden results; received ${byKey.length}.',
      );
    }

    for (final testCase in cases) {
      final result = byKey[testCase.goldenKey];
      if (result == null) {
        throw StateError('Missing T0250 golden result: ${testCase.goldenKey}.');
      }
      if (result.pixelWidth != testCase.pixelWidth ||
          result.pixelHeight != testCase.pixelHeight) {
        throw StateError('T0250 pixel dimensions changed: ${testCase.goldenKey}.');
      }
      if (!result.safeAreaPassed) {
        throw StateError('T0250 safe-area failure: ${testCase.goldenKey}.');
      }
      if (!result.readabilityPassed) {
        throw StateError('T0250 readability failure: ${testCase.goldenKey}.');
      }
      if (!result.goldenMatched) {
        throw StateError('T0250 golden mismatch: ${testCase.goldenKey}.');
      }
    }
  }
}
