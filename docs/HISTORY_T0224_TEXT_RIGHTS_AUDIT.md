# HISTORY T0224 — TEXT RIGHTS / UNLICENSED COPY AUDIT

**Status:** Engineering/content-rights gate for T0224.

## Purpose

History references are used to verify facts, dates, uncertainty and source provenance. They are not a licence to republish an encyclopedia article, book chapter, translation, map or image. User-facing TR/EN/AR history prose must therefore be editorial synthesis unless a separate, explicit redistribution licence is recorded for the exact reused text.

This rule is binding together with `docs/CONTENT_SOURCE_POLICY.md`, especially the rule that encyclopedia prose is not copied into the product.

## TDV / İSAM decision

The official TDV İslâm Ansiklopedisi copyright notice and usage terms were re-checked on 2026-08-31. They state that the work is copyrighted by TDV İslâm Araştırmaları Merkezi / İSAM, whole articles may not be republished, and only short quotations are permitted subject to source attribution and a direct active link. TDV visual material may not be republished in another medium under those site terms.

Product rule:

- TDV may be used as a research/reference source.
- No TDV article is bundled or reproduced as product narration.
- No TDV image, map, table, drawing or photograph is bundled.
- A future direct quotation is forbidden by default. It requires a separately reviewed quotation record satisfying the then-current TDV terms and product disclosure requirements.
- Facts learned from TDV must be independently expressed as editorial synthesis and, for major historical claims, cross-checked with another reliable source when reasonably possible.

Official references checked:

- `https://islamansiklopedisi.org.tr/kullanim_sartlari.php`
- `https://islamansiklopedisi.org.tr/hakk`

## Current branch audit scope

T0224 audits every `*.dart` file under `lib/features/history/data/`, not a hand-maintained subset. That includes the T0211–T0219 research datasets, T0220 event migrations, T0223 map metadata and the aggregate inventory as the directory evolves.

The automated gate extracts localized `tr:`, `en:` and `ar:` user-facing strings and fails on source/copyright artefacts including:

- TDV / İslâm Ansiklopedisi site markers,
- TDV copy-interface or copyright boilerplate,
- source URLs inside localized narration,
- DOI / ISBN / Cambridge Core locator text inside localized narration,
- common HTML / quote markup indicating pasted source material.

Source citations and locators remain allowed in dedicated source metadata; they are not user-facing article prose.

## Failure-path evidence

`scripts/test_audit_history_text_rights.py` proves the gate fails for:

1. TDV reference text inserted into a localized field,
2. a source URL inserted into localized narration,
3. zero parser coverage,

and proves that dedicated citation/locator metadata outside localized narration remains allowed. UTF-8 Turkish/Arabic text and escaped Dart apostrophes are also covered so the audit does not corrupt or skip those locales.

`Flutter CI` runs both the failure-path tests and the live branch audit before the full Flutter test suite. A new pasted source artefact therefore leaves the branch red.

## Audit conclusion for the current history data

The current branch uses history references as citation/research metadata and editorially written TR/EN/AR summaries. No TDV article body or TDV visual asset is part of the history dataset. T0224 does **not** grant production publication status to the historical records: source/certainty review (TEST_MATRIX D12) and real native TR/EN/AR review (D14) remain separate release gates.

## Limits of this control

No static scanner can mathematically prove that a sentence is semantically unrelated to every copyrighted book ever consulted. T0224 therefore combines a binding editorial rule, explicit TDV rights decision, automated paste/source-marker detection, failure-path tests and CI enforcement. Any future intentional quotation or third-party asset requires its own exact licence/provenance evidence; absence of a scanner finding is never treated as a redistribution licence.
