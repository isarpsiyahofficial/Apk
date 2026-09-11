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
/// dataset. Alias/reprint/mirror rows must keep the same underlying family.
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

/// Muhammad-period events are admitted only when the exact event has two
/// reviewed source/work families. Canonical records stay unchanged; later
/// corroboration is event-scoped and locator-pinned.
const muhammadPartialT0337SourceIdentities = <HistoryT0337SourceIdentity>[
  HistoryT0337SourceIdentity(sourceId: 'muslim-1162e-seerah-birth', independenceFamily: 'primary:sahih-muslim'),
  HistoryT0337SourceIdentity(sourceId: 'abudawud-2426-t0337-birth', independenceFamily: 'primary:sunan-abi-dawud'),
  HistoryT0337SourceIdentity(sourceId: 'bukhari-2262-seerah-youth', independenceFamily: 'primary:sahih-al-bukhari'),
  HistoryT0337SourceIdentity(sourceId: 'ibnmajah-2149-t0337-youth', independenceFamily: 'primary:sunan-ibn-majah'),
  HistoryT0337SourceIdentity(sourceId: 'bukhari-3817-seerah-marriage', independenceFamily: 'primary:sahih-al-bukhari'),
  HistoryT0337SourceIdentity(sourceId: 'muslim-2436-t0337-marriage-khadija', independenceFamily: 'primary:sahih-muslim'),
  HistoryT0337SourceIdentity(sourceId: 'bukhari-3-seerah-hira', independenceFamily: 'primary:sahih-al-bukhari'),
  HistoryT0337SourceIdentity(sourceId: 'muslim-160a-t0337-hira', independenceFamily: 'primary:sahih-muslim'),
  HistoryT0337SourceIdentity(sourceId: 'bukhari-3-seerah-first-revelation', independenceFamily: 'primary:sahih-al-bukhari'),
  HistoryT0337SourceIdentity(sourceId: 'quran-96-1-5-seerah', independenceFamily: 'primary:quran'),
  HistoryT0337SourceIdentity(sourceId: 'quran-26-214-seerah', independenceFamily: 'primary:quran'),
  HistoryT0337SourceIdentity(sourceId: 'bukhari-4770-t0337-nearest-kindred', independenceFamily: 'primary:sahih-al-bukhari'),
  HistoryT0337SourceIdentity(sourceId: 'bukhari-3876-seerah-abyssinia', independenceFamily: 'primary:sahih-al-bukhari'),
  HistoryT0337SourceIdentity(sourceId: 'muslim-2502-2503-t0337-abyssinia', independenceFamily: 'primary:sahih-muslim'),
  HistoryT0337SourceIdentity(sourceId: 'bukhari-3058-seerah-boycott', independenceFamily: 'primary:sahih-al-bukhari'),
  HistoryT0337SourceIdentity(sourceId: 'muslim-1314b-t0337-boycott', independenceFamily: 'primary:sahih-muslim'),
  HistoryT0337SourceIdentity(sourceId: 'bukhari-3231-seerah-taif', independenceFamily: 'primary:sahih-al-bukhari'),
  HistoryT0337SourceIdentity(sourceId: 'muslim-1795-t0337-taif', independenceFamily: 'primary:sahih-muslim'),
  HistoryT0337SourceIdentity(sourceId: 'quran-17-1-seerah', independenceFamily: 'primary:quran'),
  HistoryT0337SourceIdentity(sourceId: 'bukhari-3887-seerah-miraj', independenceFamily: 'primary:sahih-al-bukhari'),
  HistoryT0337SourceIdentity(sourceId: 'bukhari-3893-seerah-aqaba', independenceFamily: 'primary:sahih-al-bukhari'),
  HistoryT0337SourceIdentity(sourceId: 'bukhari-3892-t0337-aqaba', independenceFamily: 'primary:sahih-al-bukhari'),
  HistoryT0337SourceIdentity(sourceId: 'quran-9-40-seerah', independenceFamily: 'primary:quran'),
  HistoryT0337SourceIdentity(sourceId: 'bukhari-4663-seerah-cave', independenceFamily: 'primary:sahih-al-bukhari'),
  HistoryT0337SourceIdentity(sourceId: 'bukhari-3925-seerah-medina', independenceFamily: 'primary:sahih-al-bukhari'),
  HistoryT0337SourceIdentity(sourceId: 'muslim-1376a-t0337-medina-arrival', independenceFamily: 'primary:sahih-muslim'),
  HistoryT0337SourceIdentity(sourceId: 'quran-3-123-seerah', independenceFamily: 'primary:quran'),
  HistoryT0337SourceIdentity(sourceId: 'bukhari-3992-t0337-badr', independenceFamily: 'primary:sahih-al-bukhari'),
  HistoryT0337SourceIdentity(sourceId: 'quran-48-18-seerah', independenceFamily: 'primary:quran'),
  HistoryT0337SourceIdentity(sourceId: 'bukhari-4843-t0337-pledge-under-tree', independenceFamily: 'primary:sahih-al-bukhari'),
  HistoryT0337SourceIdentity(sourceId: 'bukhari-2711-2712-seerah-hudaybiyyah', independenceFamily: 'primary:sahih-al-bukhari'),
  HistoryT0337SourceIdentity(sourceId: 'muslim-1783a-t0337-hudaybiyyah', independenceFamily: 'primary:sahih-muslim'),
  HistoryT0337SourceIdentity(sourceId: 'bukhari-4280-seerah-conquest', independenceFamily: 'primary:sahih-al-bukhari'),
  HistoryT0337SourceIdentity(sourceId: 'muslim-1780c-t0337-conquest', independenceFamily: 'primary:sahih-muslim'),
  HistoryT0337SourceIdentity(sourceId: 'bukhari-1739-seerah-farewell', independenceFamily: 'primary:sahih-al-bukhari'),
  HistoryT0337SourceIdentity(sourceId: 'muslim-1218b-t0337-farewell', independenceFamily: 'primary:sahih-muslim'),
  HistoryT0337SourceIdentity(sourceId: 'bukhari-4449-seerah-death', independenceFamily: 'primary:sahih-al-bukhari'),
  HistoryT0337SourceIdentity(sourceId: 'muslim-2443-t0337-death', independenceFamily: 'primary:sahih-muslim'),
];

const muhammadPartialT0337EventIds = <String>{
  'history:muhammad-birth-monday',
  'history:muhammad-youth-shepherding',
  'history:muhammad-marriage-khadija',
  'history:muhammad-hira-retreat',
  'history:muhammad-first-revelation',
  'history:muhammad-meccan-nearest-kindred',
  'history:muhammad-abyssinia-migrations',
  'history:muhammad-boycott-banu-hashim',
  'history:muhammad-taif-rejection',
  'history:muhammad-isra-miraj',
  'history:muhammad-aqaba-pledge',
  'history:muhammad-hijrah-cave',
  'history:muhammad-medina-arrival',
  'history:muhammad-badr',
  'history:muhammad-pledge-under-tree',
  'history:muhammad-hudaybiyyah-treaty',
  'history:muhammad-conquest-mecca',
  'history:muhammad-farewell-pilgrimage',
  'history:muhammad-death',
};

/// Reviewed supplemental references. Translation text is not bundled; only the
/// bibliographic locator is used by this QA gate.
const muhammadPartialT0337Corroborations = <HistoryT0337Corroboration>[
  HistoryT0337Corroboration(eventId: 'history:muhammad-birth-monday', sourceId: 'abudawud-2426-t0337-birth', locator: 'Sunan Abi Dawud 2426'),
  HistoryT0337Corroboration(eventId: 'history:muhammad-youth-shepherding', sourceId: 'ibnmajah-2149-t0337-youth', locator: 'Sunan Ibn Majah 2149'),
  HistoryT0337Corroboration(eventId: 'history:muhammad-marriage-khadija', sourceId: 'muslim-2436-t0337-marriage-khadija', locator: 'Sahih Muslim 2436'),
  HistoryT0337Corroboration(eventId: 'history:muhammad-hira-retreat', sourceId: 'muslim-160a-t0337-hira', locator: 'Sahih Muslim 160a'),
  HistoryT0337Corroboration(eventId: 'history:muhammad-abyssinia-migrations', sourceId: 'muslim-2502-2503-t0337-abyssinia', locator: 'Sahih Muslim 2502-2503'),
  HistoryT0337Corroboration(eventId: 'history:muhammad-boycott-banu-hashim', sourceId: 'muslim-1314b-t0337-boycott', locator: 'Sahih Muslim 1314b'),
  HistoryT0337Corroboration(eventId: 'history:muhammad-taif-rejection', sourceId: 'muslim-1795-t0337-taif', locator: 'Sahih Muslim 1795'),
  HistoryT0337Corroboration(eventId: 'history:muhammad-aqaba-pledge', sourceId: 'bukhari-3892-t0337-aqaba', locator: 'Sahih al-Bukhari 3892'),
  HistoryT0337Corroboration(eventId: 'history:muhammad-medina-arrival', sourceId: 'muslim-1376a-t0337-medina-arrival', locator: 'Sahih Muslim 1376a'),
  HistoryT0337Corroboration(eventId: 'history:muhammad-badr', sourceId: 'bukhari-3992-t0337-badr', locator: 'Sahih al-Bukhari 3992'),
  HistoryT0337Corroboration(eventId: 'history:muhammad-pledge-under-tree', sourceId: 'bukhari-4843-t0337-pledge-under-tree', locator: 'Sahih al-Bukhari 4843'),
  HistoryT0337Corroboration(eventId: 'history:muhammad-meccan-nearest-kindred', sourceId: 'bukhari-4770-t0337-nearest-kindred', locator: 'Sahih al-Bukhari 4770'),
  HistoryT0337Corroboration(eventId: 'history:muhammad-hudaybiyyah-treaty', sourceId: 'muslim-1783a-t0337-hudaybiyyah', locator: 'Sahih Muslim 1783a'),
  HistoryT0337Corroboration(eventId: 'history:muhammad-conquest-mecca', sourceId: 'muslim-1780c-t0337-conquest', locator: 'Sahih Muslim 1780c'),
  HistoryT0337Corroboration(eventId: 'history:muhammad-farewell-pilgrimage', sourceId: 'muslim-1218b-t0337-farewell', locator: 'Sahih Muslim 1218b'),
  HistoryT0337Corroboration(eventId: 'history:muhammad-death', sourceId: 'muslim-2443-t0337-death', locator: 'Sahih Muslim 2443'),
];

HistoryT0337SourceIdentity _sourceIdentity(String sourceId, String workFamilyId) =>
    HistoryT0337SourceIdentity(
      sourceId: sourceId,
      independenceFamily: 'work:$workFamilyId',
    );

final medievalT0214T0337SourceIdentities = medievalHistoryT0214Sources
    .map((source) => _sourceIdentity(source.locator.id, source.workFamilyId))
    .toList(growable: false);
final highMedievalT0215T0337SourceIdentities = highMedievalHistoryT0215Sources
    .map((source) => _sourceIdentity(source.locator.id, source.workFamilyId))
    .toList(growable: false);
final earlyModernT0216T0337SourceIdentities = earlyModernEmpiresT0216Sources
    .map((source) => _sourceIdentity(source.locator.id, source.workFamilyId))
    .toList(growable: false);
final regionalT0217T0337SourceIdentities = regionalIslamicHistoriesT0217Sources
    .map((source) => _sourceIdentity(source.locator.id, source.workFamilyId))
    .toList(growable: false);
final modernGlobalT0218T0337SourceIdentities = modernGlobalHistoryT0218Sources
    .map((source) => _sourceIdentity(source.locator.id, source.workFamilyId))
    .toList(growable: false);

HistoryT0337AuditResult auditEarlyCaliphateT0337() => HistoryT0337Audit.validate(
      events: earlyCaliphateT0220Dataset.events,
      sourceIdentities: earlyCaliphateT0337SourceIdentities,
    );
HistoryT0337AuditResult auditMuhammadPartialT0337() => HistoryT0337Audit.validate(
      events: muhammadPeriodEventsT0220.events
          .where((event) => muhammadPartialT0337EventIds.contains(event.id))
          .toList(growable: false),
      sourceIdentities: muhammadPartialT0337SourceIdentities,
      corroborations: muhammadPartialT0337Corroborations,
    );
HistoryT0337AuditResult auditMedievalT0214T0337() => HistoryT0337Audit.validate(
      events: medievalHistoryT0214EventDatasetT0220.events,
      sourceIdentities: medievalT0214T0337SourceIdentities,
    );
HistoryT0337AuditResult auditHighMedievalT0215T0337() => HistoryT0337Audit.validate(
      events: highMedievalHistoryT0215EventDatasetT0220.events,
      sourceIdentities: highMedievalT0215T0337SourceIdentities,
    );
HistoryT0337AuditResult auditEarlyModernT0216T0337() => HistoryT0337Audit.validate(
      events: earlyModernEventsT0220.events,
      sourceIdentities: earlyModernT0216T0337SourceIdentities,
    );
HistoryT0337AuditResult auditRegionalT0217T0337() => HistoryT0337Audit.validate(
      events: regionalEventsT0220.events,
      sourceIdentities: regionalT0217T0337SourceIdentities,
    );
HistoryT0337AuditResult auditModernGlobalT0218T0337() => HistoryT0337Audit.validate(
      events: modernGlobalEventsT0220.events,
      sourceIdentities: modernGlobalT0218T0337SourceIdentities,
    );

/// T0337 remains incomplete until every event-bearing history track is mapped
/// and aggregate coverage has no missing canonical event IDs.
