import 'package:flutter_test/flutter_test.dart';
import 'package:islami_hayat/core/content/source_manifest.dart';
import 'package:islami_hayat/features/share/domain/share_golden_matrix_t0250.dart';
import 'package:islami_hayat/features/share/domain/visual_asset_catalog_t0240.dart';

void main() {
  VisualAssetManifestEntry licensedEntry(int index) {
    final ordinal = index + 1;
    final padded = ordinal.toString().padLeft(3, '0');
    return VisualAssetManifestEntry(
      id: 'Canva-$padded',
      title: 'Verified visual $ordinal',
      sourceUrl: Uri.parse('https://www.canva.com/design/DAF$padded'),
      licenseId: 'CC0-1.0',
      retrievedAt: DateTime.utc(2026, 9, 8),
      sha256: ordinal.toRadixString(16).padLeft(64, '0'),
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

  ShareGoldenMatrixT0250 matrix() => ShareGoldenMatrixT0250.forFinalCatalog(
        VisualAssetCatalogT0240.finalCatalog(
          List.generate(100, licensedEntry),
        ),
      );

  List<ShareGoldenResultT0250> passingResults(ShareGoldenMatrixT0250 matrix) {
    return matrix.cases
        .map(
          (testCase) => ShareGoldenResultT0250(
            goldenKey: testCase.goldenKey,
            pixelWidth: testCase.pixelWidth,
            pixelHeight: testCase.pixelHeight,
            safeAreaPassed: true,
            readabilityPassed: true,
            goldenMatched: true,
          ),
        )
        .toList();
  }

  test('T0250 plans exactly 100 assets x four canonical export formats', () {
    final subject = matrix();

    expect(subject.cases, hasLength(400));
    expect(subject.cases.map((e) => e.assetId).toSet(), hasLength(100));
    for (final assetId in subject.cases.map((e) => e.assetId).toSet()) {
      expect(
        subject.cases.where((e) => e.assetId == assetId),
        hasLength(4),
      );
    }
    expect(subject.cases.map((e) => e.goldenKey).toSet(), hasLength(400));
  });

  test('complete golden evidence passes only when all 400 cases pass', () {
    final subject = matrix();

    expect(
      () => subject.requireCompleteResults(passingResults(subject)),
      returnsNormally,
    );
  });

  test('missing golden evidence fails closed', () {
    final subject = matrix();
    final results = passingResults(subject)..removeLast();

    expect(() => subject.requireCompleteResults(results), throwsStateError);
  });

  test('duplicate golden evidence fails closed', () {
    final subject = matrix();
    final results = passingResults(subject)..add(passingResults(subject).first);

    expect(() => subject.requireCompleteResults(results), throwsStateError);
  });

  test('wrong dimensions fail closed', () {
    final subject = matrix();
    final results = passingResults(subject);
    final original = results.first;
    results[0] = ShareGoldenResultT0250(
      goldenKey: original.goldenKey,
      pixelWidth: original.pixelWidth - 1,
      pixelHeight: original.pixelHeight,
      safeAreaPassed: true,
      readabilityPassed: true,
      goldenMatched: true,
    );

    expect(() => subject.requireCompleteResults(results), throwsStateError);
  });

  test('safe-area readability and golden mismatch each fail closed', () {
    final subject = matrix();
    final base = passingResults(subject);

    for (final failure in <ShareGoldenResultT0250 Function(ShareGoldenResultT0250)>[
      (original) => ShareGoldenResultT0250(
            goldenKey: original.goldenKey,
            pixelWidth: original.pixelWidth,
            pixelHeight: original.pixelHeight,
            safeAreaPassed: false,
            readabilityPassed: true,
            goldenMatched: true,
          ),
      (original) => ShareGoldenResultT0250(
            goldenKey: original.goldenKey,
            pixelWidth: original.pixelWidth,
            pixelHeight: original.pixelHeight,
            safeAreaPassed: true,
            readabilityPassed: false,
            goldenMatched: true,
          ),
      (original) => ShareGoldenResultT0250(
            goldenKey: original.goldenKey,
            pixelWidth: original.pixelWidth,
            pixelHeight: original.pixelHeight,
            safeAreaPassed: true,
            readabilityPassed: true,
            goldenMatched: false,
          ),
    ]) {
      final results = List<ShareGoldenResultT0250>.of(base);
      results[0] = failure(results[0]);
      expect(() => subject.requireCompleteResults(results), throwsStateError);
    }
  });
}
