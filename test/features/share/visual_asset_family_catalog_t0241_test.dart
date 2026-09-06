import 'package:flutter_test/flutter_test.dart';
import 'package:islami_hayat/core/content/source_manifest.dart';
import 'package:islami_hayat/features/share/domain/visual_asset_catalog_t0240.dart';
import 'package:islami_hayat/features/share/domain/visual_asset_family_catalog_t0241.dart';

void main() {
  VisualAssetManifestEntry licensedEntry(int index) {
    return VisualAssetManifestEntry(
      id: 'visual-$index',
      title: 'Verified visual $index',
      sourceUrl: Uri.parse('https://www.canva.com/'),
      licenseId: 'CC0-1.0',
      retrievedAt: DateTime.utc(2026, 9, 1),
      sha256: index.toRadixString(16).padLeft(64, '0'),
      attribution: 'Exact underlying source recorded',
      licenseEvidenceUrl: Uri.parse(
        'https://creativecommons.org/publicdomain/zero/1.0/',
      ),
      canRedistributeInApp: true,
      canExportRepeatedly: true,
      isAiGenerated: false,
      isCanvaProContent: false,
      hasIndependentReusableLicense: true,
    );
  }

  VisualAssetCatalogT0240 assets() {
    return VisualAssetCatalogT0240.finalCatalog(
      List.generate(100, licensedEntry),
    );
  }

  List<VisualAssetFamilyTagT0241> validTags() {
    const families = <VisualAssetFamilyT0241>[
      VisualAssetFamilyT0241.warmMinimal,
      VisualAssetFamilyT0241.naturalTexture,
      VisualAssetFamilyT0241.nightSky,
      VisualAssetFamilyT0241.abstractArchitecture,
      VisualAssetFamilyT0241.typography,
      VisualAssetFamilyT0241.softGeometric,
      VisualAssetFamilyT0241.calmLight,
      VisualAssetFamilyT0241.watercolorBotanical,
    ];
    return List.generate(
      100,
      (index) => VisualAssetFamilyTagT0241(
        assetId: 'visual-$index',
        family: families[index % families.length],
      ),
    );
  }

  test('T0241 tags every final asset exactly once across several families', () {
    final catalog = VisualAssetFamilyCatalogT0241.forFinalAssets(
      assets: assets(),
      tags: validTags(),
    );

    expect(catalog.byAssetId, hasLength(100));
    expect(
      catalog.countByFamily.length,
      greaterThanOrEqualTo(
        VisualAssetFamilyCatalogT0241.minimumDistinctFamilyCount,
      ),
    );
  });

  test('missing family tag fails closed', () {
    final tags = validTags()..removeLast();

    expect(
      () => VisualAssetFamilyCatalogT0241.forFinalAssets(
        assets: assets(),
        tags: tags,
      ),
      throwsStateError,
    );
  });

  test('unknown asset family tag fails closed', () {
    final tags = validTags();
    tags[99] = const VisualAssetFamilyTagT0241(
      assetId: 'visual-unknown',
      family: VisualAssetFamilyT0241.calmLight,
    );

    expect(
      () => VisualAssetFamilyCatalogT0241.forFinalAssets(
        assets: assets(),
        tags: tags,
      ),
      throwsStateError,
    );
  });

  test('duplicate family tag for one asset fails closed', () {
    final tags = validTags()
      ..add(
        const VisualAssetFamilyTagT0241(
          assetId: 'visual-0',
          family: VisualAssetFamilyT0241.calmLight,
        ),
      );

    expect(
      () => VisualAssetFamilyCatalogT0241.forFinalAssets(
        assets: assets(),
        tags: tags,
      ),
      throwsStateError,
    );
  });

  test('single-tone and two-family catalogs cannot pass T0241', () {
    final singleTone = List.generate(
      100,
      (index) => VisualAssetFamilyTagT0241(
        assetId: 'visual-$index',
        family: VisualAssetFamilyT0241.warmMinimal,
      ),
    );
    final twoFamilies = List.generate(
      100,
      (index) => VisualAssetFamilyTagT0241(
        assetId: 'visual-$index',
        family: index.isEven
            ? VisualAssetFamilyT0241.warmMinimal
            : VisualAssetFamilyT0241.naturalTexture,
      ),
    );

    expect(
      () => VisualAssetFamilyCatalogT0241.forFinalAssets(
        assets: assets(),
        tags: singleTone,
      ),
      throwsStateError,
    );
    expect(
      () => VisualAssetFamilyCatalogT0241.forFinalAssets(
        assets: assets(),
        tags: twoFamilies,
      ),
      throwsStateError,
    );
  });
}
