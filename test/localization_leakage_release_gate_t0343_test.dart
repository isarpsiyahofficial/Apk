import 'dart:io';

import 'package:flutter_test/flutter_test.dart';
import 'package:islami_hayat/core/localization/localization_leakage_release_gate_t0343.dart';
import 'package:islami_hayat/core/localization/localization_release_manifest_t0340.dart';

void main() {
  test('T0343 canonical six-direction leakage matrix is fail-closed', () {
    expect(
      LocalizationLeakageReleaseGateT0343.validateCanonicalSnapshot,
      returnsNormally,
    );
    expect(LocalizationLeakageReleaseGateT0343.directions, hasLength(6));
    expect(LocalizationLeakageReleaseGateT0343.requiredCells, hasLength(102));
    expect(LocalizationLeakageReleaseGateT0343.verified, hasLength(10));
    expect(LocalizationLeakageReleaseGateT0343.unresolved, hasLength(92));
  });

  test('primary navigation has all six directed leakage proofs', () {
    final primary = LocalizationLeakageReleaseGateT0343.verified
        .where(
          (item) =>
              item.cell.scope ==
              LocalizationLeakageScopeT0343.primaryNavigation,
        )
        .map((item) => item.cell.direction.key)
        .toSet();
    expect(
      primary,
      LocalizationLeakageReleaseGateT0343.directions
          .map((item) => item.key)
          .toSet(),
    );
  });

  test('static catalog audit does not pretend to detect EN to TR or AR', () {
    for (final target in <LocalizationLocaleT0340>[
      LocalizationLocaleT0340.tr,
      LocalizationLocaleT0340.ar,
    ]) {
      final key =
          'arbCatalog:${LocalizationLocaleT0340.en.name}->${target.name}';
      expect(
        LocalizationLeakageReleaseGateT0343.verified
            .any((item) => item.cell.key == key),
        isFalse,
      );
      expect(
        LocalizationLeakageReleaseGateT0343.unresolved
            .singleWhere((item) => item.cell.key == key)
            .reason,
        contains('does not yet claim'),
      );
    }
  });

  test('every verified leakage proof points to an existing source file', () {
    for (final evidence in LocalizationLeakageReleaseGateT0343.verified) {
      final path = evidence.proofId.split('::').first;
      expect(
        File(path).existsSync(),
        isTrue,
        reason: 'Missing directional leakage proof file: $path',
      );
    }
  });

  test('non-navigation product surfaces stay unresolved until real crawl proof', () {
    for (final scope in LocalizationLeakageScopeT0343.values) {
      if (scope == LocalizationLeakageScopeT0343.primaryNavigation ||
          scope == LocalizationLeakageScopeT0343.arbCatalog) {
        continue;
      }
      expect(
        LocalizationLeakageReleaseGateT0343.verified
            .where((item) => item.cell.scope == scope),
        isEmpty,
        reason: '${scope.name} must not be promoted by visibility alone',
      );
      expect(
        LocalizationLeakageReleaseGateT0343.unresolved
            .where((item) => item.cell.scope == scope),
        hasLength(6),
      );
    }
  });
}
