# T0220 — History event contract

## Scope

SPEC T0220 requires every history **event** record to carry date + certainty, before-context, causes, consequences, people/actors, geography and source references. The v1.2 completion rule also requires source/certainty/language QA before production promotion.

## Implemented domain gate

`HistoryEventRecord.validated` is the fail-closed canonical event contract. It requires:

- stable non-empty event ID;
- complete TR/EN/AR title;
- start/end CE range with start <= end;
- explicit `HistoryDateCertainty`;
- complete TR/EN/AR date/certainty caveat;
- complete TR/EN/AR before-context;
- at least one complete TR/EN/AR cause;
- at least one complete TR/EN/AR consequence;
- at least one identified person/actor with TR/EN/AR name;
- at least one geography with TR/EN/AR label and explicit exact/approximate/regional precision;
- non-empty, unique source IDs that exist in the supplied source registry;
- research/production status.

An `unknown` date certainty cannot be promoted to `reviewedForProduction`.

`HistoryEventContractDataset.validated` additionally rejects duplicate event identities and exposes production records separately from research drafts.

## Failure-path evidence

`test/features/history/history_event_contract_test.dart` covers valid construction plus reversed dates, missing before-context, missing causes/consequences, missing people/geography, incomplete Arabic localization, unknown/duplicate/blank source references, unknown-date production promotion and duplicate event IDs.

Migration-specific tests additionally require legacy chronology, source IDs and `researchDraft` status to remain unchanged while mandatory T0220 fields are added.

## Migration status

The shared gate does **not** imply that every legacy T0211–T0219 record already satisfies T0220.

Completed migrations:

- **T0213 — Rashidun / First Fitna:** 5/5 canonical entries pass `HistoryEventRecord.validated` through `rashidun_first_fitna_events_t0220.dart`. First Fitna remains explicitly contested and research-only.
- **T0214 — Umayyad / Abbasid / al-Andalus / Fatimid / Samanid / Buyid:** 6/6 canonical entries pass through `medieval_caliphates_events_t0220.dart`. Parallel historical tracks are preserved; migration does not linearize overlapping dynasties or promote any record to production.

Still open before T0220 can be checked:

- classify T0211 pre-Islam material into true event records versus contextual/background records so the contract does not force invented dates, causes or named actors onto non-event context;
- audit/migrate T0212 event-shaped Muhammad-period history records while retaining the canonical Seerah bridge;
- audit/migrate event-shaped records in T0215–T0219;
- run a final inventory proving that every history record classified as an event is represented exactly once in the T0220 contract dataset.

T0220 therefore remains unchecked. D12/D14 also remain TODO until independent source/certainty review and real TR/EN/AR native review evidence are complete.
