/// Fail-closed coverage manifest for T0340-T0344 localization release QA.
///
/// This manifest does not turn a visible screen into a PASS. It records every
/// required surface/state/locale cell as either verified by a concrete test or
/// explicitly unresolved. Missing, duplicated, overlapping or anonymous cells
/// are release errors.
enum LocalizationLocaleT0340 { tr, en, ar }

enum LocalizationSurfaceT0340 {
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

enum LocalizationStateT0340 {
  happy,
  loading,
  empty,
  error,
  permission,
  offline,
  recovery,
  success,
  cancelled,
  pending,
  noFill,
  restore,
  revoke,
}

final class LocalizationCoverageCellT0340 {
  const LocalizationCoverageCellT0340({
    required this.surface,
    required this.state,
    required this.locale,
  });

  final LocalizationSurfaceT0340 surface;
  final LocalizationStateT0340 state;
  final LocalizationLocaleT0340 locale;

  String get key => '${surface.name}:${state.name}:${locale.name}';
}

final class LocalizationVerifiedEvidenceT0340 {
  const LocalizationVerifiedEvidenceT0340({
    required this.cell,
    required this.proofId,
  });

  final LocalizationCoverageCellT0340 cell;
  final String proofId;
}

final class LocalizationUnresolvedEvidenceT0340 {
  const LocalizationUnresolvedEvidenceT0340({
    required this.cell,
    required this.reason,
  });

  final LocalizationCoverageCellT0340 cell;
  final String reason;
}

final class LocalizationReleaseManifestT0340 {
  const LocalizationReleaseManifestT0340._();

  static const Map<LocalizationSurfaceT0340, Set<LocalizationStateT0340>>
      requiredStates = {
    LocalizationSurfaceT0340.today: {
      LocalizationStateT0340.happy,
      LocalizationStateT0340.error,
    },
    LocalizationSurfaceT0340.quran: {
      LocalizationStateT0340.happy,
      LocalizationStateT0340.empty,
      LocalizationStateT0340.error,
    },
    LocalizationSurfaceT0340.dua: {
      LocalizationStateT0340.happy,
      LocalizationStateT0340.loading,
      LocalizationStateT0340.empty,
      LocalizationStateT0340.error,
    },
    LocalizationSurfaceT0340.dhikr: {
      LocalizationStateT0340.happy,
      LocalizationStateT0340.error,
    },
    LocalizationSurfaceT0340.prophets: {
      LocalizationStateT0340.happy,
      LocalizationStateT0340.empty,
      LocalizationStateT0340.error,
    },
    LocalizationSurfaceT0340.history: {
      LocalizationStateT0340.happy,
      LocalizationStateT0340.empty,
      LocalizationStateT0340.error,
    },
    LocalizationSurfaceT0340.religiousDays: {
      LocalizationStateT0340.happy,
      LocalizationStateT0340.empty,
      LocalizationStateT0340.error,
    },
    LocalizationSurfaceT0340.topicSearch: {
      LocalizationStateT0340.happy,
      LocalizationStateT0340.empty,
      LocalizationStateT0340.error,
    },
    LocalizationSurfaceT0340.premium: {
      LocalizationStateT0340.happy,
      LocalizationStateT0340.success,
      LocalizationStateT0340.cancelled,
      LocalizationStateT0340.pending,
      LocalizationStateT0340.restore,
      LocalizationStateT0340.revoke,
      LocalizationStateT0340.error,
    },
    LocalizationSurfaceT0340.ads: {
      LocalizationStateT0340.success,
      LocalizationStateT0340.cancelled,
      LocalizationStateT0340.noFill,
      LocalizationStateT0340.error,
    },
    LocalizationSurfaceT0340.billing: {
      LocalizationStateT0340.success,
      LocalizationStateT0340.cancelled,
      LocalizationStateT0340.pending,
      LocalizationStateT0340.restore,
      LocalizationStateT0340.revoke,
      LocalizationStateT0340.error,
    },
    LocalizationSurfaceT0340.offlineGate: {
      LocalizationStateT0340.happy,
      LocalizationStateT0340.offline,
      LocalizationStateT0340.recovery,
      LocalizationStateT0340.error,
    },
    LocalizationSurfaceT0340.notification: {
      LocalizationStateT0340.happy,
      LocalizationStateT0340.loading,
      LocalizationStateT0340.error,
      LocalizationStateT0340.permission,
    },
    LocalizationSurfaceT0340.widget: {
      LocalizationStateT0340.happy,
      LocalizationStateT0340.error,
    },
    LocalizationSurfaceT0340.share: {
      LocalizationStateT0340.happy,
      LocalizationStateT0340.error,
    },
  };

  static List<LocalizationCoverageCellT0340> get requiredCells {
    final cells = <LocalizationCoverageCellT0340>[];
    for (final entry in requiredStates.entries) {
      for (final state in entry.value) {
        for (final locale in LocalizationLocaleT0340.values) {
          cells.add(
            LocalizationCoverageCellT0340(
              surface: entry.key,
              state: state,
              locale: locale,
            ),
          );
        }
      }
    }
    return List.unmodifiable(cells);
  }

  static void validate({
    required Iterable<LocalizationVerifiedEvidenceT0340> verified,
    required Iterable<LocalizationUnresolvedEvidenceT0340> unresolved,
  }) {
    final required = {for (final cell in requiredCells) cell.key};
    final verifiedKeys = <String>{};
    final unresolvedKeys = <String>{};

    for (final evidence in verified) {
      final proof = evidence.proofId.trim();
      if (proof.isEmpty) {
        throw StateError('Verified localization evidence requires a proof ID.');
      }
      final key = evidence.cell.key;
      if (!required.contains(key)) {
        throw StateError('Unexpected verified localization cell: $key');
      }
      if (!verifiedKeys.add(key)) {
        throw StateError('Duplicate verified localization cell: $key');
      }
    }

    for (final evidence in unresolved) {
      final reason = evidence.reason.trim();
      if (reason.isEmpty) {
        throw StateError('Unresolved localization evidence requires a reason.');
      }
      final key = evidence.cell.key;
      if (!required.contains(key)) {
        throw StateError('Unexpected unresolved localization cell: $key');
      }
      if (!unresolvedKeys.add(key)) {
        throw StateError('Duplicate unresolved localization cell: $key');
      }
      if (verifiedKeys.contains(key)) {
        throw StateError('Localization cell cannot be verified and unresolved: $key');
      }
    }

    final covered = <String>{...verifiedKeys, ...unresolvedKeys};
    final missing = required.difference(covered);
    final extra = covered.difference(required);
    if (missing.isNotEmpty || extra.isNotEmpty) {
      throw StateError(
        'Localization release manifest is not closed. '
        'Missing=${missing.toList()..sort()} Extra=${extra.toList()..sort()}',
      );
    }
  }
}
