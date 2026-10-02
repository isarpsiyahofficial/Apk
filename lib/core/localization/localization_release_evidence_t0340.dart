import 'localization_release_manifest_t0340.dart';

/// Canonical progress snapshot for the T0340-T0344 localization release gate.
///
/// Only behavior that already has concrete TR/EN/AR widget/integration proof is
/// promoted to [verified]. Everything else is generated as explicit unresolved
/// coverage so a new surface/state can never disappear from release QA silently.
final class LocalizationReleaseEvidenceT0340 {
  const LocalizationReleaseEvidenceT0340._();

  static List<LocalizationVerifiedEvidenceT0340> get verified {
    final evidence = <LocalizationVerifiedEvidenceT0340>[];

    void addAllLocales(
      LocalizationSurfaceT0340 surface,
      LocalizationStateT0340 state,
      String proofId,
    ) {
      for (final locale in LocalizationLocaleT0340.values) {
        evidence.add(
          LocalizationVerifiedEvidenceT0340(
            cell: LocalizationCoverageCellT0340(
              surface: surface,
              state: state,
              locale: locale,
            ),
            proofId: '$proofId::${locale.name}',
          ),
        );
      }
    }

    addAllLocales(
      LocalizationSurfaceT0340.today,
      LocalizationStateT0340.happy,
      'localization_primary_surface_crawl_t0340_t0343_test.dart::today',
    );
    addAllLocales(
      LocalizationSurfaceT0340.quran,
      LocalizationStateT0340.happy,
      'localization_primary_surface_crawl_t0340_t0343_test.dart::quran',
    );
    addAllLocales(
      LocalizationSurfaceT0340.dhikr,
      LocalizationStateT0340.happy,
      'localization_primary_surface_crawl_t0340_t0343_test.dart::dhikr',
    );

    for (final state in <LocalizationStateT0340>[
      LocalizationStateT0340.happy,
      LocalizationStateT0340.loading,
      LocalizationStateT0340.empty,
      LocalizationStateT0340.error,
    ]) {
      addAllLocales(
        LocalizationSurfaceT0340.dua,
        state,
        'localization_dua_surface_t0344_test.dart::${state.name}',
      );
    }

    addAllLocales(
      LocalizationSurfaceT0340.premium,
      LocalizationStateT0340.happy,
      'premium_value_page_t0279_test.dart::localized-surface',
    );

    for (final state in <LocalizationStateT0340>[
      LocalizationStateT0340.happy,
      LocalizationStateT0340.offline,
      LocalizationStateT0340.recovery,
    ]) {
      addAllLocales(
        LocalizationSurfaceT0340.offlineGate,
        state,
        state == LocalizationStateT0340.happy
            ? 'app_startup_access_t0262_test.dart::free-online'
            : 'free_connection_drop_t0263_test.dart::${state.name}',
      );
    }

    for (final state in <LocalizationStateT0340>[
      LocalizationStateT0340.loading,
      LocalizationStateT0340.error,
      LocalizationStateT0340.permission,
    ]) {
      addAllLocales(
        LocalizationSurfaceT0340.notification,
        state,
        'notification_settings_page_t0290_test.dart::${state.name}',
      );
    }

    return List.unmodifiable(evidence);
  }

  static List<LocalizationUnresolvedEvidenceT0340> get unresolved {
    final verifiedKeys = {for (final item in verified) item.cell.key};
    return List.unmodifiable(
      LocalizationReleaseManifestT0340.requiredCells
          .where((cell) => !verifiedKeys.contains(cell.key))
          .map(
            (cell) => LocalizationUnresolvedEvidenceT0340(
              cell: cell,
              reason: _reasonFor(cell),
            ),
          ),
    );
  }

  static String _reasonFor(LocalizationCoverageCellT0340 cell) {
    return switch (cell.surface) {
      LocalizationSurfaceT0340.ads =>
        'Rewarded/ad localized success-cancel-no-fill-error UI proof is pending.',
      LocalizationSurfaceT0340.billing =>
        'Google Play purchase/restore/revoke localized UI integration proof is pending.',
      LocalizationSurfaceT0340.share =>
        'Share/export localized failure and RTL four-format proof is pending.',
      LocalizationSurfaceT0340.widget =>
        'Home-widget localized happy/failure copy integration proof is pending.',
      LocalizationSurfaceT0340.prophets =>
        'Full Prophets surface crawl is pending; nested Revelation Journey proof alone is insufficient.',
      LocalizationSurfaceT0340.history =>
        'Full History surface localized state crawl is pending.',
      LocalizationSurfaceT0340.religiousDays =>
        'Religious Days localized state crawl is pending.',
      LocalizationSurfaceT0340.topicSearch =>
        'Topic Search localized happy/empty/error crawl is pending.',
      _ =>
        'Surface/state-specific TR/EN/AR widget or integration proof is pending.',
    };
  }

  static void validateCanonicalSnapshot() {
    LocalizationReleaseManifestT0340.validate(
      verified: verified,
      unresolved: unresolved,
    );
  }
}
