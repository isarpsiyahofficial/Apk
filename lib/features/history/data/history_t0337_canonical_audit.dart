import '../domain/history_t0337_audit.dart';
import 'high_medieval_events_t0220.dart';
import 'high_medieval_seljuq_crusades_mamluks.dart';
import 'medieval_caliphates_events_t0220.dart';
import 'medieval_caliphates_regional_dynasties.dart';
import 'rashidun_first_fitna_events_t0220.dart';

/// Explicit work-level source identities for the T0213/T0220 early-caliphate
/// dataset. These values are deliberately not derived from source IDs at
/// runtime: an alias/reprint/mirror added later must be reviewed and assigned
/// to the same underlying work family before it can count toward T0337.
const earlyCaliphateT0337SourceIdentities = <HistoryT0337SourceIdentity>[
  HistoryT0337SourceIdentity(
    sourceId: 'lapidus_caliphate_to_750',
    independenceFamily: 'work:lapidus-history-islamic-societies-caliphate-to-750',
  ),
  HistoryT0337SourceIdentity(
    sourceId: 'madelung_succession_muhammad',
    independenceFamily: 'work:madelung-succession-to-muhammad',
  ),
  HistoryT0337SourceIdentity(
    sourceId: 'hinds_early_islamic_history',
    independenceFamily: 'work:hinds-studies-in-early-islamic-history',
  ),
];

/// T0214 already stores an explicit `workFamilyId` beside every academic
/// locator. Reuse that reviewed metadata rather than inferring independence
/// from citation text, publisher, URL, or source ID spelling.
final medievalT0214T0337SourceIdentities = medievalHistoryT0214Sources
    .map(
      (source) => HistoryT0337SourceIdentity(
        sourceId: source.locator.id,
        independenceFamily: 'work:${source.workFamilyId}',
      ),
    )
    .toList(growable: false);

/// T0215 follows the same reviewed work-family contract. Keeping a separate
/// projection makes the T0337 migration explicit per historical track while
/// preserving the underlying work identity when bibliography aliases or new
/// locators are introduced later.
final highMedievalT0215T0337SourceIdentities = highMedievalHistoryT0215Sources
    .map(
      (source) => HistoryT0337SourceIdentity(
        sourceId: source.locator.id,
        independenceFamily: 'work:${source.workFamilyId}',
      ),
    )
    .toList(growable: false);

/// First real canonical projection wired to the T0337 gate.
HistoryT0337AuditResult auditEarlyCaliphateT0337() => HistoryT0337Audit.validate(
      events: earlyCaliphateT0220Dataset.events,
      sourceIdentities: earlyCaliphateT0337SourceIdentities,
    );

/// Second real projection: the T0214/T0220 Umayyad, Abbasid, al-Andalus,
/// Fatimid and regional-dynasty records. Their work-family metadata is already
/// part of the canonical dataset contract, so aliases cannot silently create a
/// second source family.
HistoryT0337AuditResult auditMedievalT0214T0337() => HistoryT0337Audit.validate(
      events: medievalHistoryT0214EventDatasetT0220.events,
      sourceIdentities: medievalT0214T0337SourceIdentities,
    );

/// Third real projection: the T0215/T0220 Seljuq, Crusades, Ayyubid, Mongol
/// and Mamluk records. Their source registry already requires two independent
/// academic work families for every record; T0337 now re-validates that rule
/// at the shared release-gate layer rather than trusting only the source model.
HistoryT0337AuditResult auditHighMedievalT0215T0337() =>
    HistoryT0337Audit.validate(
      events: highMedievalHistoryT0215EventDatasetT0220.events,
      sourceIdentities: highMedievalT0215T0337SourceIdentities,
    );

/// T0337 remains incomplete until every event-bearing history track is mapped
/// to an explicit work-level registry and the aggregate inventory is audited.
/// Keeping per-track gates visible prevents a partial migration from being
/// mistaken for a release PASS.
