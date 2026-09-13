# T0336 Hadith Batch 32 — İbrâhim provenance note

## Scope

This batch advances only the mandatory `hadith` semantic dimension for canonical prophet `ibrahim`.

## Source decision

- Collection: **Sahih al-Bukhari**
- Exact locator: **Sahih al-Bukhari 3356**
- Stable app source id: `sahih-bukhari-3356-ibrahim-circumcision`
- App source class: `sahihHasanHadith`
- Rights mode: `REFERENCE-ONLY`
- Public verification page used during review: `https://sunnah.com/bukhari:3356`

The report states that Ibrahim was circumcised at the age of eighty. The application does not copy a third-party English/Turkish translation into reusable content. The semantic gate stores only exact bibliographic provenance and an owner-bound evidence claim.

## Deliberate non-inferences

This report does **not** create or upgrade any of the following dimensions:

- `historicalDate`: age eighty is not a calendar year or exact historical date.
- `chronology`: no new chronology band is inferred from the report.
- `geography`: no location is derived from wording variants around the instrument/place term.
- `familyLineage`: no genealogy relation is inferred.

## Fail-closed ownership rule

The evidence builder accepts only `biographyProphetId == subjectProphetId == ibrahim` and the exact source metadata above. A changed source id, title, class, licence marker or locator throws before the claim can enter the 25×8 release registry.

## Release impact

Hadith verified-owner coverage becomes **3/25**: `adam`, `ibrahim`, `muhammad`. The remaining 22 canonical prophets stay explicit unresolved/pending; no missing report is guessed merely to increase coverage.
