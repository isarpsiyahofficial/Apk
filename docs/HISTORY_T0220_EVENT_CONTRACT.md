# T0220 — History event contract

## Scope

SPEC T0220 requires every history **event** record to carry date + certainty, before-context, causes, consequences, people/actors, geography and source references. The v1.2 completion rule also requires source/certainty/language QA before production promotion.

## Implemented domain gate

`HistoryEventRecord.validated` is the fail-closed canonical event contract. It requires:

- stable non-empty event ID;
- complete TR/EN/AR title;
- explicit `HistoryDateCertainty`;
- for `exact` / `approximate` / `broadRange` / `contested`: both CE range bounds with start <= end;
- for `unknown`: **no numeric year bounds at all** — sentinel years such as `0` are rejected so an unstated date cannot become fake precision;
- complete TR/EN/AR date/certainty caveat;
- complete TR/EN/AR before-context;
- at least one complete TR/EN/AR cause field;
- at least one complete TR/EN/AR consequence field;
- at least one identified person/actor with TR/EN/AR name;
- at least one geography with TR/EN/AR label and explicit exact/approximate/regional precision;
- non-empty, unique source IDs that exist in the supplied source registry;
- research/production status.

An `unknown` date certainty cannot be promoted to `reviewedForProduction`.

`HistoryEventContractDataset.validated` additionally rejects duplicate event identities and exposes production records separately from research drafts.

## Failure-path evidence

`test/features/history/history_event_contract_test.dart` covers valid construction plus reversed dates, half-present date ranges, unknown dates carrying numeric/sentinel bounds, estimated dates missing bounds, missing before-context, missing causes/consequences, missing people/geography, incomplete Arabic localization, unknown/duplicate/blank source references, unknown-date production promotion and duplicate event IDs.

Migration-specific tests additionally require legacy chronology, source IDs and `researchDraft` status to remain unchanged while mandatory T0220 fields are added.

## Migration status

The shared gate does **not** imply that every legacy T0211–T0219 record is an event. T0220 is deliberately applied only after event-vs-context classification so contextual material is never forced to invent dates, causes or named actors.

Completed event migrations:

- **T0212 — Muhammad-period history / canonical Seerah bridge:** the complete canonical T0201 seerah list is projected 1:1 through `muhammad_period_events_t0220.dart`. History IDs, seerah IDs, order/phase bridge and source IDs are preserved. T0201 intentionally stores relative chronology without manufacturing Gregorian/Hijri years, therefore T0220 records use `HistoryDateCertainty.unknown` with `null/null` year bounds and remain `researchDraft`. `muhammad_period_events_t0220_test.dart` proves 1:1 coverage, source preservation, complete mandatory fields, geography overrides and zero production leakage.
- **T0213 — Rashidun / First Fitna:** 5/5 canonical entries pass `HistoryEventRecord.validated` through `rashidun_first_fitna_events_t0220.dart`. First Fitna remains explicitly contested and research-only.
- **T0214 — Umayyad / Abbasid / al-Andalus / Fatimid / Samanid / Buyid:** 6/6 canonical entries pass through `medieval_caliphates_events_t0220.dart`. Parallel historical tracks are preserved; migration does not linearize overlapping dynasties or promote any record to production.
- **T0215 — Seljuq / Crusades / Ayyubid / Mongol / Mamluk:** 5/5 canonical entries pass through `high_medieval_events_t0220.dart`. Existing date ranges, source IDs and `researchDraft` status are preserved. Broad teaching ranges such as the Crusades and initial Mongol invasion waves remain `broadRange`; the Crusades retain multiple identified sides rather than being reduced to a single-party event.
- **T0216 — Ottoman / Safavid / Mughal:** 3/3 canonical entries pass through `early_modern_events_t0220.dart`. Existing broad date ranges, source IDs and `researchDraft` status are preserved. The migration adds source-bounded before-context, cause, consequence, actor and regional-geography fields without converting broad dynasty spans into false exactness.
- **T0217 — Africa / Central Asia / Southeast Asia / Indian subcontinent / Europe:** 5/5 canonical regional entries pass through `regional_events_t0220.dart`. Existing teaching boundaries, source IDs, localized certainty caveats and `researchDraft` status are preserved. All five remain `broadRange`; contact boundaries such as 615, 700, 1200 or 711 are not promoted to exact continent-wide Islamization dates.
- **T0218 — colonial/imperial rule / decolonization and nation states / twentieth-century transformations / contemporary global Muslim societies:** 4/4 canonical entries pass through `modern_global_events_t0220.dart`. Existing date ranges, source IDs, localized caveats and `researchDraft` status are preserved. Broad periods remain `broadRange`, the decolonization track remains `contested`, and `snapshotBounded` is deliberately mapped to non-exact `broadRange`; the 2026 value stays only the dataset currency boundary and is not promoted into a permanent historical endpoint.

## T0211 / T0219 event-vs-context classification

`history_record_classification.dart` now performs the missing 1:1 classification instead of manufacturing event fields:

- **T0211 — 11/11 records are `backgroundContext`.** Late Antiquity, Byzantine/Sasanian/Aksum settings, South Arabia, Mecca/Yathrib, tribal society and religious-community entries describe historical background rather than discrete events. They therefore remain outside `HistoryEventRecord`.
- **T0219 — 9/9 records are `horizontalTheme`.** Science, medicine, mathematics/astronomy, philosophy/thought, hadith/tafsir/fiqh, art/architecture, trade/urbanization, education and women’s historical roles span multiple regions and periods. Their pedagogical ranges are not treated as one event’s start/end dates.
- The classification dataset rejects missing canonical IDs, duplicate IDs, wrong task/kind mappings and any attempt to reclassify these non-event records as T0220 events.

`history_record_classification_test.dart` proves exact T0211 and T0219 coverage and the failure paths above.

## Final T0220 inventory audit

`history_t0220_inventory.dart` aggregates all T0212–T0218 event datasets after their individual 1:1 migration gates and joins them with the explicit T0211/T0219 non-event registry. It fails closed when:

- any event identity occurs more than once across the migrated tracks; or
- an ID appears in both the event inventory and the non-event registry.

`history_t0220_inventory_test.dart` proves the aggregate event count equals the sum of the seven migrated event tracks, every aggregate event ID is unique, event/non-event sets are disjoint, all inventoried events expose the mandatory T0220 fields, and duplicate identities are rejected.

With this classification + aggregate inventory, the **T0220 engineering contract is implemented**. This does **not** promote religious/history content to production: TEST_MATRIX D12/D14 remain TODO until independent factual/source/certainty review and real TR/EN/AR native review evidence are complete. T0211/T0219 content status also remains `researchDraft` until those review gates are satisfied.
