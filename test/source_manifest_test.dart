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
    );

    expect(aiEntry.canBeFinalReusableBackground, isFalse);
    expect(proEntry.canBeFinalReusableBackground, isFalse);
  });

  test('only fully licensed non-AI non-Pro visual passes final gate', () {
    final entry = VisualAssetManifestEntry(
      id: 'visual-free',
      title: 'Licensed visual',
      sourceUrl: Uri.parse('https://www.canva.com/'),
      licenseId: 'verified-free-license',
      retrievedAt: DateTime.utc(2026, 8, 27),
      sha256: validSha,
      attribution: 'Canva source recorded',
      canRedistributeInApp: true,
      canExportRepeatedly: true,
      isAiGenerated: false,
      isCanvaProContent: false,
    );

    expect(entry.canBeFinalReusableBackground, isTrue);
  });
}
