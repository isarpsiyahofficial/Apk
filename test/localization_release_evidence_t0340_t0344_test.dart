import 'package:flutter_test/flutter_test.dart';
import 'package:islami_hayat/core/localization/localization_release_evidence_t0340.dart';
import 'package:islami_hayat/core/localization/localization_release_manifest_t0340.dart';

void main() {
  test('canonical localization progress snapshot is a closed partition', () {
    expect(
      LocalizationReleaseEvidenceT0340.validateCanonicalSnapshot,
      returnsNormally,
    );

    expect(LocalizationReleaseManifestT0340.requiredCells, hasLength(156));
    expect(LocalizationReleaseEvidenceT0340.verified, hasLength(42));
    expect(LocalizationReleaseEvidenceT0340.unresolved, hasLength(114));
  });

  test('verified evidence is concrete and locale-specific', () {
    for (final evidence in LocalizationReleaseEvidenceT0340.verified) {
      expect(evidence.proofId.trim(), isNotEmpty);
      expect(
        evidence.proofId,
        endsWith('::${evidence.cell.locale.name}'),
      );
    }
  });

  test('billing ad share and widget states remain unresolved until integration proof', () {
    final verifiedSurfaces = LocalizationReleaseEvidenceT0340.verified
        .map((item) => item.cell.surface)
        .toSet();

    expect(verifiedSurfaces, isNot(contains(LocalizationSurfaceT0340.billing)));
    expect(verifiedSurfaces, isNot(contains(LocalizationSurfaceT0340.ads)));
    expect(verifiedSurfaces, isNot(contains(LocalizationSurfaceT0340.share)));
    expect(verifiedSurfaces, isNot(contains(LocalizationSurfaceT0340.widget)));

    for (final surface in <LocalizationSurfaceT0340>[
      LocalizationSurfaceT0340.billing,
      LocalizationSurfaceT0340.ads,
      LocalizationSurfaceT0340.share,
      LocalizationSurfaceT0340.widget,
    ]) {
      final requiredCount = LocalizationReleaseManifestT0340.requiredCells
          .where((cell) => cell.surface == surface)
          .length;
      final unresolvedCount = LocalizationReleaseEvidenceT0340.unresolved
          .where((item) => item.cell.surface == surface)
          .length;
      expect(unresolvedCount, requiredCount);
    }
  });

  test('nested prophet evidence cannot accidentally promote full prophet surface', () {
    expect(
      LocalizationReleaseEvidenceT0340.verified.any(
        (item) => item.cell.surface == LocalizationSurfaceT0340.prophets,
      ),
      isFalse,
    );
    expect(
      LocalizationReleaseEvidenceT0340.unresolved
          .where(
            (item) => item.cell.surface == LocalizationSurfaceT0340.prophets,
          )
          .every((item) => item.reason.contains('nested Revelation Journey')),
      isTrue,
    );
  });

  test('all three locales remain represented in both progress buckets', () {
    for (final locale in LocalizationLocaleT0340.values) {
      expect(
        LocalizationReleaseEvidenceT0340.verified
            .where((item) => item.cell.locale == locale),
        isNotEmpty,
      );
      expect(
        LocalizationReleaseEvidenceT0340.unresolved
            .where((item) => item.cell.locale == locale),
        isNotEmpty,
      );
    }
  });
}
