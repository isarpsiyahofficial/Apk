import 'package:flutter_test/flutter_test.dart';
import 'package:islami_hayat/core/content/source_manifest.dart';
import 'package:islami_hayat/features/share/domain/visual_asset_catalog_t0240.dart';

void main() {
  VisualAssetManifestEntry licensedEntry(int index) {
    final ordinal = index + 1;
    final padded = ordinal.toString().padLeft(3, '0');
    final hex = ordinal.toRadixString(16).padLeft(64, '0');
    return VisualAssetManifestEntry(
      id: 'Canva-$padded',
      title: 'Verified visual $ordinal',
      sourceUrl: Uri.parse('https://www.canva.com/design/DAF$padded'),
      licenseId: 'CC0-1.0',
      retrievedAt: DateTime.utc(2026, 9, 8),
      sha256: hex,
      attribution: 'Exact underlying source recorded',
      licenseEvidenceUrl: Uri.parse(
        'https://creativecommons.org/publicdomain/zero/1.0/',
      ),
      canRedistributeInApp: true,
      canExportRepeatedly: true,
      isAiGenerated: false,
      isCanvaProContent: false,
      hasIndependentReusableLicense: true,
      localAssetPath: 'assets/share/backgrounds/canva-$padded.webp',
    );
  }

  VisualAssetManifestEntry copyEntry(
    VisualAssetManifestEntry original, {
    String? id,
    Uri? sourceUrl,
    String? sha256,
    Uri? licenseEvidenceUrl,
    bool keepLicenseEvidence = true,
    String? localAssetPath,
    bool keepLocalAssetPath = true,
    bool? hasIndependentReusableLicense,
  }) {
    return VisualAssetManifestEntry(
      id: id ?? original.id,
      title: original.title,
      sourceUrl: sourceUrl ?? original.sourceUrl,
      licenseId: original.licenseId,
      retrievedAt: original.retrievedAt,
      sha256: sha256 ?? original.sha256,
      attribution: original.attribution,
      licenseEvidenceUrl:
          keepLicenseEvidence ? licenseEvidenceUrl ?? original.licenseEvidenceUrl : null,
      canRedistributeInApp: true,
      canExportRepeatedly: true,
      isAiGenerated: false,
      isCanvaProContent: false,
      hasIndependentReusableLicense:
          hasIndependentReusableLicense ?? original.hasIndependentReusableLicense,
      localAssetPath:
          keepLocalAssetPath ? localAssetPath ?? original.localAssetPath : null,
    );
  }

  test('final T0240 catalog requires exactly 100 verified bundled assets', () {
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
    entries[42] = copyEntry(
      entries[42],
      hasIndependentReusableLicense: false,
    );

    expect(
      () => VisualAssetCatalogT0240.finalCatalog(entries),
      throwsStateError,
    );
  });

  test('duplicate ids and hashes fail closed', () {
    final duplicateId = List.generate(100, licensedEntry);
    duplicateId[99] = copyEntry(duplicateId[99], id: duplicateId[0].id);

    expect(
      () => VisualAssetCatalogT0240.finalCatalog(duplicateId),
      throwsStateError,
    );

    final duplicateHash = List.generate(100, licensedEntry);
    duplicateHash[99] = copyEntry(
      duplicateHash[99],
      sha256: duplicateHash[0].sha256,
    );

    expect(
      () => VisualAssetCatalogT0240.finalCatalog(duplicateHash),
      throwsStateError,
    );
  });

  test('missing exact license evidence fails even for independent license', () {
    final entries = List.generate(100, licensedEntry);
    entries[7] = copyEntry(entries[7], keepLicenseEvidence: false);

    expect(
      () => VisualAssetCatalogT0240.finalCatalog(entries),
      throwsStateError,
    );
  });

  test('non-canonical Canva candidate id cannot replace a final slot', () {
    final entries = List.generate(100, licensedEntry);
    entries[7] = copyEntry(entries[7], id: 'visual-008');

    expect(
      () => VisualAssetCatalogT0240.finalCatalog(entries),
      throwsStateError,
    );
  });

  test('Canva homepage is not accepted as exact asset identity', () {
    final entries = List.generate(100, licensedEntry);
    entries[7] = copyEntry(
      entries[7],
      sourceUrl: Uri.parse('https://www.canva.com/'),
    );

    expect(
      () => VisualAssetCatalogT0240.finalCatalog(entries),
      throwsStateError,
    );
  });

  test('missing, remote, traversal and nested local paths fail closed', () {
    for (final invalidPath in <String?>[
      null,
      'https://example.com/canva-008.webp',
      'assets/share/backgrounds/../canva-008.webp',
      'assets/share/backgrounds/nested/canva-008.webp',
    ]) {
      final entries = List.generate(100, licensedEntry);
      entries[7] = invalidPath == null
          ? copyEntry(entries[7], keepLocalAssetPath: false)
          : copyEntry(entries[7], localAssetPath: invalidPath);

      expect(
        () => VisualAssetCatalogT0240.finalCatalog(entries),
        throwsStateError,
        reason: 'invalid path must fail: $invalidPath',
      );
    }
  });

  test('duplicate local path and duplicate Canva source fail closed', () {
    final duplicatePath = List.generate(100, licensedEntry);
    duplicatePath[99] = copyEntry(
      duplicatePath[99],
      localAssetPath: duplicatePath[0].localAssetPath,
    );
    expect(
      () => VisualAssetCatalogT0240.finalCatalog(duplicatePath),
      throwsStateError,
    );

    final duplicateSource = List.generate(100, licensedEntry);
    duplicateSource[99] = copyEntry(
      duplicateSource[99],
      sourceUrl: duplicateSource[0].sourceUrl,
    );
    expect(
      () => VisualAssetCatalogT0240.finalCatalog(duplicateSource),
      throwsStateError,
    );
  });
}
