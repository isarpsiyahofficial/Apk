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

## Migration status

This commit establishes the shared gate but does **not** pretend that legacy T0211–T0219 records already contain all T0220 fields. Existing history datasets remain research-stage records until their event-shaped entries are migrated through this contract with source-backed before/cause/consequence/person/geography data.

Therefore T0220 must remain unchecked until the migration audit proves every event record passes this contract. D12/D14 also remain TODO until the independent source/certainty and real TR/EN/AR review evidence is complete.
