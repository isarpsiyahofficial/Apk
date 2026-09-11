import '../domain/history_t0337_audit.dart';
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

/// First real canonical projection wired to the T0337 gate.
///
/// T0337 remains incomplete until every event-bearing history track is mapped
/// to an explicit work-level source registry and the aggregate inventory is
/// audited. Keeping this function scoped to the early-caliphate track avoids a
/// false PASS while still preventing regressions in the migrated real data.
HistoryT0337AuditResult auditEarlyCaliphateT0337() => HistoryT0337Audit.validate(
      events: earlyCaliphateT0220Dataset.events,
      sourceIdentities: earlyCaliphateT0337SourceIdentities,
    );
