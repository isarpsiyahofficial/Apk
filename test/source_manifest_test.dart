import 'package:flutter_test/flutter_test.dart';
import 'package:islami_hayat/core/content/source_manifest.dart';

void main() {
  const validSha =
      '0123456789abcdef0123456789abcdef0123456789abcdef0123456789abcdef';

  test('source manifest requires valid SHA-256 and attribution', () {
    final entry = SourceManifestEntry(
      id: 'tanzil-quran-text',
      title: 'Tanzil Quran Text',
      sourceUrl: Uri.parse('https://tanzil.net/docs/text_license'),
      licenseId: 'CC-BY-3.0',
      retrievedAt: DateTime.utc(2026, 8, 27),
      sha256: validSha,
      attribution: 'Tanzil Project',
    );

    expect(entry.isComplete, isTrue);
  });

  test('invalid content hash blocks a source manifest', () {
    final entry = SourceManifestEntry(
      id: 'source',
      title: 'Source',
      sourceUrl: Uri.parse('https://example.com'),
      licenseId: 'license',
      retrievedAt: DateTime.utc(2026, 8, 27),
      sha256: 'not-a-sha',
      attribution: 'Source attribution',
    );

    expect(entry.isComplete, isFalse);
  });

  test('Canva AI or Pro reusable content cannot become a final background', () {
    final aiEntry = VisualAssetManifestEntry(
      id: 'visual-ai',
      title: 'Visual AI',
      sourceUrl: Uri.parse('https://www.canva.com/'),
      licenseId: 'canva-free',
      retrievedAt: DateTime.utc(2026, 8, 27),
      sha256: validSha,
      attribution: 'Canva',
      canRedistributeInApp: true,
      canExportRepeatedly: true,
      isAiGenerated: true,
      isCanvaProContent: false,
      hasIndependentReusableLicense: true,
    );

    final proEntry = VisualAssetManifestEntry(
      id: 'visual-pro',
      title: 'Visual Pro',
      sourceUrl: Uri.parse('https://www.canva.com/'),
      licenseId: 'canva-pro',
      retrievedAt: DateTime.utc(2026, 8, 27),
      sha256: validSha,
      attribution: 'Canva',
      canRedistributeInApp: true,
      canExportRepeatedly: true,
      isAiGenerated: false,
      isCanvaProContent: true,
      hasIndependentReusableLicense: true,
    );

    expect(aiEntry.canBeFinalReusableBackground, isFalse);
    expect(proEntry.canBeFinalReusableBackground, isFalse);
  });

  test('generic Canva Free license alone cannot pass reusable app gate', () {
    final entry = VisualAssetManifestEntry(
      id: 'visual-free-only',
      title: 'Canva Free only',
      sourceUrl: Uri.parse('https://www.canva.com/'),
      licenseId: 'canva-free',
      retrievedAt: DateTime.utc(2026, 9, 1),
      sha256: validSha,
      attribution: 'Canva source recorded',
      canRedistributeInApp: true,
      canExportRepeatedly: true,
      isAiGenerated: false,
      isCanvaProContent: false,
    );

    expect(entry.canBeFinalReusableBackground, isFalse);
  });

  test('only independently licensed non-AI non-Pro visual passes final gate', () {
    final entry = VisualAssetManifestEntry(
      id: 'visual-cc0',
      title: 'Independently reusable visual',
      sourceUrl: Uri.parse('https://www.canva.com/'),
      licenseId: 'CC0-1.0',
      retrievedAt: DateTime.utc(2026, 9, 1),
      sha256: validSha,
      attribution: 'Underlying source and license recorded',
      canRedistributeInApp: true,
      canExportRepeatedly: true,
      isAiGenerated: false,
      isCanvaProContent: false,
      hasIndependentReusableLicense: true,
    );

    expect(entry.canBeFinalReusableBackground, isTrue);
  });
}