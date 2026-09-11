import '../domain/history_t0337_audit.dart';
import 'early_modern_events_t0220.dart';
import 'early_modern_ottoman_safavid_mughal.dart';
import 'high_medieval_events_t0220.dart';
import 'high_medieval_seljuq_crusades_mamluks.dart';
import 'medieval_caliphates_events_t0220.dart';
import 'medieval_caliphates_regional_dynasties.dart';
import 'modern_global_events_t0220.dart';
import 'modern_global_islamic_history.dart';
import 'muhammad_period_events_t0220.dart';
import 'rashidun_first_fitna_events_t0220.dart';
import 'regional_events_t0220.dart';
import 'regional_islamic_histories.dart';

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

/// Muhammad-period events are not blanket-promoted into the double-source
/// audit. Only records with two independently reviewed primary source families
/// are projected here. For Badr and the pledge under the tree, the canonical
/// Quran source is paired with an event-scoped Sahih al-Bukhari corroboration
/// whose exact locator was separately reviewed; the base T0220 record is not
/// rewritten merely to satisfy T0337.
const muhammadPartialT0337SourceIdentities = <HistoryT0337SourceIdentity>[
  HistoryT0337SourceIdentity(
    sourceId: 'bukhari-3-seerah-first-revelation',
    independenceFamily: 'primary:sahih-al-bukhari',
  ),
  HistoryT0337SourceIdentity(
    sourceId: 'quran-96-1-5-seerah',
    independenceFamily: 'primary:quran',
  ),
  HistoryT0337SourceIdentity(
    sourceId: 'quran-17-1-seerah',
    independenceFamily: 'primary:quran',
  ),
  HistoryT0337SourceIdentity(
    sourceId: 'bukhari-3887-seerah-miraj',
    independenceFamily: 'primary:sahih-al-bukhari',
  ),
  HistoryT0337SourceIdentity(
    sourceId: 'quran-9-40-seerah',
    independenceFamily: 'primary:quran',
  ),
  HistoryT0337SourceIdentity(
    sourceId: 'bukhari-4663-seerah-cave',
    independenceFamily: 'primary:sahih-al-bukhari',
  ),
  HistoryT0337SourceIdentity(
    sourceId: 'quran-3-123-seerah',
    independenceFamily: 'primary:quran',
  ),
  HistoryT0337SourceIdentity(
    sourceId: 'bukhari-3992-t0337-badr',
    independenceFamily: 'primary:sahih-al-bukhari',
  ),
  HistoryT0337SourceIdentity(
    sourceId: 'quran-48-18-seerah',
    independenceFamily: 'primary:quran',
  ),
  HistoryT0337SourceIdentity(
    sourceId: 'bukhari-4843-t0337-pledge-under-tree',
    independenceFamily: 'primary:sahih-al-bukhari',
  ),
];

const muhammadPartialT0337EventIds = <String>{
  'history:muhammad-first-revelation',
  'history:muhammad-isra-miraj',
  'history:muhammad-hijrah-cave',
  'history:muhammad-badr',
  'history:muhammad-pledge-under-tree',
};

/// Exact reviewed supplemental references. These are QA evidence only: they do
/// not copy third-party translations into the app and they do not invent dates.
const muhammadPartialT0337Corroborations = <HistoryT0337Corroboration>[
  HistoryT0337Corroboration(
    eventId: 'history:muhammad-badr',
    sourceId: 'bukhari-3992-t0337-badr',
    locator: 'Sahih al-Bukhari 3992',
  ),
  HistoryT0337Corroboration(
    eventId: 'history:muhammad-pledge-under-tree',
    sourceId: 'bukhari-4843-t0337-pledge-under-tree',
    locator: 'Sahih al-Bukhari 4843',
  ),
];

HistoryT0337SourceIdentity _sourceIdentity(
  String sourceId,
  String workFamilyId,
) =>
    HistoryT0337SourceIdentity(
      sourceId: sourceId,
      independenceFamily: 'work:$workFamilyId',
    );

/// T0214 already stores an explicit `workFamilyId` beside every academic
/// locator. Reuse that reviewed metadata rather than inferring independence
/// from citation text, publisher, URL, or source ID spelling.
final medievalT0214T0337SourceIdentities = medievalHistoryT0214Sources
    .map((source) => _sourceIdentity(source.locator.id, source.workFamilyId))
    .toList(growable: false);

/// T0215 follows the same reviewed work-family contract. Keeping a separate
/// projection makes the T0337 migration explicit per historical track while
/// preserving the underlying work identity when bibliography aliases or new
/// locators are introduced later.
final highMedievalT0215T0337SourceIdentities = highMedievalHistoryT0215Sources
    .map((source) => _sourceIdentity(source.locator.id, source.workFamilyId))
    .toList(growable: false);

/// T0216 likewise owns explicit work-family metadata for the Ottoman, Safavid
/// and Mughal research tracks. Do not infer independence from different
/// citation strings; project only the reviewed work-family IDs.
final earlyModernT0216T0337SourceIdentities = earlyModernEmpiresT0216Sources
    .map((source) => _sourceIdentity(source.locator.id, source.workFamilyId))
    .toList(growable: false);

/// T0217 regional history intentionally reuses some underlying works across
/// different regions. The work-family ID, not the bibliography-row count,
/// remains the independence unit so repeated chapters from one book cannot be
/// miscounted as separate corroborating works.
final regionalT0217T0337SourceIdentities = regionalIslamicHistoriesT0217Sources
    .map((source) => _sourceIdentity(source.locator.id, source.workFamilyId))
    .toList(growable: false);

/// T0218 modern/global history is mapped through the same explicit work-family
/// contract. This prevents different chapters or locators from a single work
/// family from accidentally satisfying the two-source requirement.
final modernGlobalT0218T0337SourceIdentities = modernGlobalHistoryT0218Sources
    .map((source) => _sourceIdentity(source.locator.id, source.workFamilyId))
    .toList(growable: false);

/// First real canonical projection wired to the T0337 gate.
HistoryT0337AuditResult auditEarlyCaliphateT0337() => HistoryT0337Audit.validate(
      events: earlyCaliphateT0220Dataset.events,
      sourceIdentities: earlyCaliphateT0337SourceIdentities,
    );

/// Conservative Muhammad-period projection. Events enter this audit only when
/// two independent primary source families are explicitly reviewed for that
/// exact claim. No second source is synthesized from chronology, biography
/// links, or general seerah knowledge.
HistoryT0337AuditResult auditMuhammadPartialT0337() => HistoryT0337Audit.validate(
      events: muhammadPeriodEventsT0220.events
          .where((event) => muhammadPartialT0337EventIds.contains(event.id))
          .toList(growable: false),
      sourceIdentities: muhammadPartialT0337SourceIdentities,
      corroborations: muhammadPartialT0337Corroborations,
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
/// and Mamluk records.
HistoryT0337AuditResult auditHighMedievalT0215T0337() =>
    HistoryT0337Audit.validate(
      events: highMedievalHistoryT0215EventDatasetT0220.events,
      sourceIdentities: highMedievalT0215T0337SourceIdentities,
    );

/// Fourth real projection: the T0216/T0220 Ottoman, Safavid and Mughal records.
HistoryT0337AuditResult auditEarlyModernT0216T0337() =>
    HistoryT0337Audit.validate(
      events: earlyModernEventsT0220.events,
      sourceIdentities: earlyModernT0216T0337SourceIdentities,
    );

/// Fifth real projection: the T0217/T0220 Africa, Central Asia, Southeast Asia,
/// Indian subcontinent and Europe regional-history records.
HistoryT0337AuditResult auditRegionalT0217T0337() => HistoryT0337Audit.validate(
      events: regionalEventsT0220.events,
      sourceIdentities: regionalT0217T0337SourceIdentities,
    );

/// Sixth real projection: T0218/T0220 colonial, decolonization, twentieth-
/// century and contemporary-global history records.
HistoryT0337AuditResult auditModernGlobalT0218T0337() =>
    HistoryT0337Audit.validate(
      events: modernGlobalEventsT0220.events,
      sourceIdentities: modernGlobalT0218T0337SourceIdentities,
    );

/// T0337 remains incomplete until every event-bearing history track is mapped
/// to an explicit work-level registry and the aggregate inventory is audited.
/// Keeping per-track gates visible prevents a partial migration from being
/// mistaken for a release PASS.
