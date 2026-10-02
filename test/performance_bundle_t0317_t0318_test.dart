import 'dart:io';

import 'package:flutter_test/flutter_test.dart';
import 'package:islami_hayat/core/content/source_manifest.dart';
import 'package:islami_hayat/features/share/domain/share_asset_packaging_policy_t0317.dart';
import 'package:islami_hayat/features/share/domain/visual_asset_catalog_t0240.dart';

void main() {
  VisualAssetManifestEntry entry(int index) {
    final ordinal = index + 1;
    final padded = ordinal.toString().padLeft(3, '0');
    return VisualAssetManifestEntry(
      id: 'Canva-$padded',
      title: 'Verified $padded',
      sourceUrl: Uri.parse('https://www.canva.com/design/DAF$padded'),
      licenseId: 'CC0-1.0',
      retrievedAt: DateTime.utc(2026, 9, 10),
      sha256: ordinal.toRadixString(16).padLeft(64, '0'),
      attribution: 'Exact source recorded',
      licenseEvidenceUrl: Uri.parse('https://creativecommons.org/publicdomain/zero/1.0/'),
      canRedistributeInApp: true,
      canExportRepeatedly: true,
      isAiGenerated: false,
      isCanvaProContent: false,
      hasIndependentReusableLicense: true,
      localAssetPath: 'assets/share/backgrounds/canva-$padded.webp',
    );
  }

  List<ShareAssetPackagingPlanT0317> plans({
    int? bakedTextIndex,
    int? avifIndex,
  }) => List.generate(100, (index) {
        final padded = (index + 1).toString().padLeft(3, '0');
        return ShareAssetPackagingPlanT0317(
          assetId: 'Canva-$padded',
          localAssetPath: 'assets/share/backgrounds/canva-$padded.webp',
          codec: index == avifIndex
              ? ShareAssetCodecT0317.avifExperimental
              : ShareAssetCodecT0317.webpLossy,
          religiousTextBakedIn: index == bakedTextIndex,
        );
      });

  test('T0317 accepts exactly 100 WebP plans with runtime religious text', () {
    final catalog = VisualAssetCatalogT0240.finalCatalog(List.generate(100, entry));
    expect(
      () => ShareAssetPackagingPolicyT0317.requireReleaseReady(catalog, plans()),
      returnsNormally,
    );
  });

  test('T0317 fails closed when religious text is baked into a background', () {
    final catalog = VisualAssetCatalogT0240.finalCatalog(List.generate(100, entry));
    expect(
      () => ShareAssetPackagingPolicyT0317.requireReleaseReady(
        catalog,
        plans(bakedTextIndex: 12),
      ),
      throwsStateError,
    );
  });

  test('T0317 AVIF stays blocked until full Android decode matrix is proven', () {
    final catalog = VisualAssetCatalogT0240.finalCatalog(List.generate(100, entry));
    expect(
      () => ShareAssetPackagingPolicyT0317.requireReleaseReady(
        catalog,
        plans(avifIndex: 44),
      ),
      throwsStateError,
    );
  });

  test('T0318 full audio library is not bundled or declared', () {
    final pubspec = File('pubspec.yaml').readAsStringSync().toLowerCase();
    expect(pubspec, isNot(contains('assets/audio/')));
    expect(pubspec, isNot(contains('assets/recitation/')));
    expect(pubspec, isNot(contains('assets/tilawah/')));

    final assets = Directory('assets');
    if (!assets.existsSync()) return;
    final bundledAudio = assets
        .listSync(recursive: true, followLinks: false)
        .whereType<File>()
        .where((file) => RegExp(r'\.(mp3|m4a|aac|ogg|wav|flac)$', caseSensitive: false)
            .hasMatch(file.path))
        .toList();
    expect(
      bundledAudio,
      isEmpty,
      reason: 'SPEC 566 forbids embedding the full V1 audio library.',
    );
  });
}
