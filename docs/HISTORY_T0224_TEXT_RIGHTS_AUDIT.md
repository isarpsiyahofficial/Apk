# HISTORY T0224 — TEXT RIGHTS / UNLICENSED COPY AUDIT

**Status:** Engineering/content-rights gate for T0224.

## Purpose

History references are used to verify facts, dates, uncertainty and source provenance. They are not a licence to republish an encyclopedia article, book chapter, translation, map or image. User-facing TR/EN/AR history prose must therefore be editorial synthesis unless a separate, explicit redistribution licence is recorded for the exact reused text.

This rule is binding together with `docs/CONTENT_SOURCE_POLICY.md`, especially the rule that encyclopedia prose is not copied into the product.

## TDV / İSAM decision

The official TDV İslâm Ansiklopedisi copyright footer and usage terms were re-checked on **2026-09-08**.

- The encyclopedia copyright notice says whole articles may not be republished and describes a limited short-quotation path with source attribution and a direct active link; it also says TDV visual material may not be republished in another medium.
- The separate `Kullanım Şartları` page reserves rights over site content and contains stricter language stating that listed content elements may not be used without permission even when the source is shown.

Because those official site statements differ in strictness, the application does **not** infer a reusable-content licence from either page. It applies the stricter fail-closed product rule below; this is a product compliance decision, not a claim that the audit itself gives legal permission.

Product rule:

- TDV may be used as a research/reference source.
- No TDV article is bundled or reproduced as product narration.
- No TDV image, map, table, drawing or photograph is bundled.
- A future direct quotation is forbidden by default. It requires separately documented permission/licence review for the exact reuse plus the then-current attribution/disclosure requirements.
- Facts learned from TDV must be independently expressed as editorial synthesis and, for major historical claims, cross-checked with another reliable source when reasonably possible.

Official references checked:

- `https://islamansiklopedisi.org.tr/kullanim_sartlari.php`
- `https://islamansiklopedisi.org.tr/hakk`

## Current branch audit scope

T0224 audits every `*.dart` file under `lib/features/history/data/`, not a hand-maintained subset. That includes the T0211–T0219 research datasets, T0220 event migrations, T0223 map metadata and the aggregate inventory as the directory evolves.

The automated gate extracts localized `tr:`, `en:` and `ar:` user-facing strings written with ordinary Dart single- or double-quoted literals and fails on source/copyright artefacts including:

- TDV / İslâm Ansiklopedisi site markers,
- TDV copy-interface or copyright boilerplate,
- source URLs inside localized narration,
- DOI / ISBN / Cambridge Core locator text inside localized narration,
- common HTML / quote markup indicating pasted source material.

Parser coverage is also fail-closed for literal prose. If a history data file introduces a `tr:`, `en:` or `ar:` **string literal** in syntax the audit does not understand (for example a triple-quoted/multiline locale literal), that literal is reported as an audit finding instead of being silently skipped. Delegated already-governed values such as `tr: value.tr` or helper parameters such as `tr: tr` are not new prose and are therefore allowed. Supporting a new locale-string literal syntax requires extending the scanner and its failure-path tests first.

Source citations and locators remain allowed in dedicated source metadata; they are not user-facing article prose.

## Failure-path evidence

`scripts/test_audit_history_text_rights.py` proves the gate fails for:

1. TDV reference text inserted into a single-quoted localized field,
2. the same TDV marker inserted through a double-quoted localized field,
3. a source URL inserted into single- or double-quoted localized narration,
4. an unsupported localized literal syntax that would otherwise evade parsing,
5. zero parser coverage,

and proves that dedicated citation/locator metadata outside localized narration and delegated existing locale values remain allowed. UTF-8 Turkish/Arabic text and escaped Dart apostrophes are also covered so the audit does not corrupt or skip those locales.

`Flutter CI` runs both the failure-path tests and the live branch audit before the full Flutter test suite. A new pasted source artefact or parser-bypass locale literal therefore leaves the branch red.

## Audit conclusion for the current history data

The current branch uses history references as citation/research metadata and editorially written TR/EN/AR summaries. No TDV article body or TDV visual asset is part of the history dataset. T0224 does **not** grant production publication status to the historical records: source/certainty review (TEST_MATRIX D12) and real native TR/EN/AR review (D14) remain separate release gates.

## Limits of this control

No static scanner can mathematically prove that a sentence is semantically unrelated to every copyrighted book ever consulted. T0224 therefore combines a binding editorial rule, explicit TDV rights decision, automated paste/source-marker detection, failure-path tests and CI enforcement. Any future intentional quotation or third-party asset requires its own exact licence/provenance evidence; absence of a scanner finding is never treated as a redistribution licence.