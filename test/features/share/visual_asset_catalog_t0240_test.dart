import 'package:flutter_test/flutter_test.dart';
import 'package:islami_hayat/core/content/source_manifest.dart';
import 'package:islami_hayat/features/share/domain/visual_asset_catalog_t0240.dart';

void main() {
  VisualAssetManifestEntry licensedEntry(int index) {
    final hex = index.toRadixString(16).padLeft(64, '0');
    return VisualAssetManifestEntry(
      id: 'visual-$index',
      title: 'Verified visual $index',
      sourceUrl: Uri.parse('https://www.canva.com/'),
      licenseId: 'CC0-1.0',
      retrievedAt: DateTime.utc(2026, 9, 1),
      sha256: hex,
      attribution: 'Exact underlying source recorded',
      licenseEvidenceUrl: Uri.parse('https://creativecommons.org/publicdomain/zero/1.0/'),
      canRedistributeInApp: true,
      canExportRepeatedly: true,
      isAiGenerated: false,
      isCanvaProContent: false,
      hasIndependentReusableLicense: true,
    );
  }

  test('final T0240 catalog requires exactly 100 verified assets', () {
    final entries = List.generate(100, licensedEntry);

    final catalog = VisualAssetCatalogT0240.finalCatalog(entries);

    expect(catalog.entries, hasLength(100));
  });

  test('99 otherwise valid assets cannot be promoted to final catalog', () {
    final entries = List.generate(99, licensedEntry);

    expect(
      () => VisualAssetCatalogT0240.finalCatalog(entries),
      throwsStateError,
    );
  });

  test('generic Canva Free content without independent reuse rights fails', () {
    final entries = List.generate(100, licensedEntry);
    entries[42] = VisualAssetManifestEntry(
      id: 'visual-42',
      title: 'Canva Free only',
      sourceUrl: Uri.parse('https://www.canva.com/'),
      licenseId: 'canva-free',
      retrievedAt: DateTime.utc(2026, 9, 1),
      sha256: 42.toRadixString(16).padLeft(64, '0'),
      attribution: 'Canva source recorded',
      licenseEvidenceUrl: Uri.parse('https://www.canva.com/policies/content-license-agreement/'),
      canRedistributeInApp: true,
      canExportRepeatedly: true,
      isAiGenerated: false,
      isCanvaProContent: false,
    );

    expect(
      () => VisualAssetCatalogT0240.finalCatalog(entries),
      throwsStateError,
    );
  });

  test('duplicate ids and hashes fail closed', () {
    final duplicateId = List.generate(100, licensedEntry);
    duplicateId[99] = VisualAssetManifestEntry(
      id: duplicateId[0].id,
      title: 'Duplicate id',
      sourceUrl: Uri.parse('https://www.canva.com/'),
      licenseId: 'CC0-1.0',
      retrievedAt: DateTime.utc(2026, 9, 1),
      sha256: duplicateId[99].sha256,
      attribution: 'Exact underlying source recorded',
      licenseEvidenceUrl: Uri.parse('https://creativecommons.org/publicdomain/zero/1.0/'),
      canRedistributeInApp: true,
      canExportRepeatedly: true,
      isAiGenerated: false,
      isCanvaProContent: false,
      hasIndependentReusableLicense: true,
    );

    expect(
      () => VisualAssetCatalogT0240.finalCatalog(duplicateId),
      throwsStateError,
    );

    final duplicateHash = List.generate(100, licensedEntry);
    duplicateHash[99] = VisualAssetManifestEntry(
      id: duplicateHash[99].id,
      title: 'Duplicate hash',
      sourceUrl: Uri.parse('https://www.canva.com/'),
      licenseId: 'CC0-1.0',
      retrievedAt: DateTime.utc(2026, 9, 1),
      sha256: duplicateHash[0].sha256,
      attribution: 'Exact underlying source recorded',
      licenseEvidenceUrl: Uri.parse('https://creativecommons.org/publicdomain/zero/1.0/'),
      canRedistributeInApp: true,
      canExportRepeatedly: true,
      isAiGenerated: false,
      isCanvaProContent: false,
      hasIndependentReusableLicense: true,
    );

    expect(
      () => VisualAssetCatalogT0240.finalCatalog(duplicateHash),
      throwsStateError,
    );
  });

  test('missing exact license evidence fails even for independent license', () {
    final entries = List.generate(100, licensedEntry);
    final original = entries[7];
    entries[7] = VisualAssetManifestEntry(
      id: original.id,
      title: original.title,
      sourceUrl: original.sourceUrl,
      licenseId: original.licenseId,
      retrievedAt: original.retrievedAt,
      sha256: original.sha256,
      attribution: original.attribution,
      canRedistributeInApp: true,
      canExportRepeatedly: true,
      isAiGenerated: false,
      isCanvaProContent: false,
      hasIndependentReusableLicense: true,
    );

    expect(
      () => VisualAssetCatalogT0240.finalCatalog(entries),
      throwsStateError,
    );
  });
}