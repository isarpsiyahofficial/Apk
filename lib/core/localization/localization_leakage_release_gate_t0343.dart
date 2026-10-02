import 'localization_release_manifest_t0340.dart';

enum LocalizationLeakageScopeT0343 {
  arbCatalog,
  primaryNavigation,
  today,
  quran,
  dua,
  dhikr,
  prophets,
  history,
  religiousDays,
  topicSearch,
  premium,
  ads,
  billing,
  offlineGate,
  notification,
  widget,
  share,
}

final class LocalizationLeakageDirectionT0343 {
  const LocalizationLeakageDirectionT0343(this.source, this.target)
      : assert(source != target);

  final LocalizationLocaleT0340 source;
  final LocalizationLocaleT0340 target;

  String get key => '${source.name}->${target.name}';
}

final class LocalizationLeakageCellT0343 {
  const LocalizationLeakageCellT0343({
    required this.scope,
    required this.direction,
  });

  final LocalizationLeakageScopeT0343 scope;
  final LocalizationLeakageDirectionT0343 direction;

  String get key => '${scope.name}:${direction.key}';
}

final class LocalizationLeakageEvidenceT0343 {
  const LocalizationLeakageEvidenceT0343({
    required this.cell,
    required this.proofId,
  });

  final LocalizationLeakageCellT0343 cell;
  final String proofId;
}

final class LocalizationLeakageUnresolvedT0343 {
  const LocalizationLeakageUnresolvedT0343({
    required this.cell,
    required this.reason,
  });

  final LocalizationLeakageCellT0343 cell;
  final String reason;
}

final class LocalizationLeakageReleaseGateT0343 {
  const LocalizationLeakageReleaseGateT0343._();

  static const directions = <LocalizationLeakageDirectionT0343>[
    LocalizationLeakageDirectionT0343(
      LocalizationLocaleT0340.tr,
      LocalizationLocaleT0340.en,
    ),
    LocalizationLeakageDirectionT0343(
      LocalizationLocaleT0340.tr,
      LocalizationLocaleT0340.ar,
    ),
    LocalizationLeakageDirectionT0343(
      LocalizationLocaleT0340.en,
      LocalizationLocaleT0340.tr,
    ),
    LocalizationLeakageDirectionT0343(
      LocalizationLocaleT0340.en,
      LocalizationLocaleT0340.ar,
    ),
    LocalizationLeakageDirectionT0343(
      LocalizationLocaleT0340.ar,
      LocalizationLocaleT0340.tr,
    ),
    LocalizationLeakageDirectionT0343(
      LocalizationLocaleT0340.ar,
      LocalizationLocaleT0340.en,
    ),
  ];

  static List<LocalizationLeakageCellT0343> get requiredCells => List.unmodifiable(
        [
          for (final scope in LocalizationLeakageScopeT0343.values)
            for (final direction in directions)
              LocalizationLeakageCellT0343(
                scope: scope,
                direction: direction,
              ),
        ],
      );

  static List<LocalizationLeakageEvidenceT0343> get verified {
    final items = <LocalizationLeakageEvidenceT0343>[];

    for (final direction in directions) {
      items.add(
        LocalizationLeakageEvidenceT0343(
          cell: LocalizationLeakageCellT0343(
            scope: LocalizationLeakageScopeT0343.primaryNavigation,
            direction: direction,
          ),
          proofId:
              'test/localization_primary_surface_crawl_t0340_t0343_test.dart::${direction.key}',
        ),
      );
    }

    for (final direction in directions.where(
      (item) =>
          item.source == LocalizationLocaleT0340.tr ||
          item.source == LocalizationLocaleT0340.ar,
    )) {
      items.add(
        LocalizationLeakageEvidenceT0343(
          cell: LocalizationLeakageCellT0343(
            scope: LocalizationLeakageScopeT0343.arbCatalog,
            direction: direction,
          ),
          proofId:
              'scripts/audit_localization_contract_t0340.py::${direction.key}',
        ),
      );
    }

    return List.unmodifiable(items);
  }

  static List<LocalizationLeakageUnresolvedT0343> get unresolved {
    final verifiedKeys = {for (final item in verified) item.cell.key};
    return List.unmodifiable(
      requiredCells
          .where((cell) => !verifiedKeys.contains(cell.key))
          .map(
            (cell) => LocalizationLeakageUnresolvedT0343(
              cell: cell,
              reason: _reason(cell),
            ),
          ),
    );
  }

  static String _reason(LocalizationLeakageCellT0343 cell) {
    if (cell.scope == LocalizationLeakageScopeT0343.arbCatalog &&
        cell.direction.source == LocalizationLocaleT0340.en) {
      return 'Static catalog audit does not yet claim safe English-text leakage detection for this direction.';
    }
    return 'Surface-specific directional leakage proof is pending.';
  }

  static void validateCanonicalSnapshot() {
    final required = {for (final cell in requiredCells) cell.key};
    final verifiedKeys = <String>{};
    final unresolvedKeys = <String>{};

    for (final evidence in verified) {
      if (evidence.proofId.trim().isEmpty) {
        throw StateError('Verified leakage evidence requires a proof ID.');
      }
      final key = evidence.cell.key;
      if (!required.contains(key) || !verifiedKeys.add(key)) {
        throw StateError('Invalid or duplicate verified leakage cell: $key');
      }
    }

    for (final item in unresolved) {
      if (item.reason.trim().isEmpty) {
        throw StateError('Unresolved leakage evidence requires a reason.');
      }
      final key = item.cell.key;
      if (!required.contains(key) || !unresolvedKeys.add(key)) {
        throw StateError('Invalid or duplicate unresolved leakage cell: $key');
      }
      if (verifiedKeys.contains(key)) {
        throw StateError('Leakage cell cannot be verified and unresolved: $key');
      }
    }

    final covered = <String>{...verifiedKeys, ...unresolvedKeys};
    if (covered.length != required.length || !covered.containsAll(required)) {
      throw StateError('Directional localization leakage manifest is not closed.');
    }
  }
}
