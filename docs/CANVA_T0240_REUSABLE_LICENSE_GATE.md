# T0240 — Canva reusable background license gate

**Checked:** 2026-09-01  
**Status:** release-blocking policy for the 100 reusable share backgrounds

## Why the existing Free/Pro check was insufficient

Canva's current Content License Agreement allows broad use of Canva Designs, and Free Content has additional permissions. However, the same agreement also prohibits uses that redistribute/re-use Content in a way that lets a person extract, access or reproduce the Content as an electronic file, and prohibits electronic-format use that enables Content to be downloaded/exported/distributed via mobile devices. Pro Content additionally uses a one-design license model. AI-generated Content is separately marked in source information.

The İslami Hayat share engine is not a one-time static Canva Design export. It intends to bundle reusable backgrounds inside an Android application and let users repeatedly render/export new Story/Status/Post cards from those backgrounds. Therefore a generic `Canva Free` label by itself is not accepted as sufficient evidence for final reusable app embedding.

Official source used for this decision:

- Canva Content License Agreement: `https://www.canva.com/policies/content-license-agreement/`
  - Free Content source information and license classification: section 2.
  - Pro Content one-design licensing: sections 3–4.
  - AI-generated source marking: section 3A.
  - Free Content additional uses: section 6.
  - Prohibited redistribution/re-use/extractable electronic/mobile export uses: section 9.

## Fail-closed product rule

A visual can become one of the final 100 reusable in-app backgrounds only when **all** of these are proven for that exact asset:

1. Exact Canva item/source identity is recorded.
2. Exact downloaded file SHA-256 is recorded.
3. It is not Canva Pro Content.
4. It is not Canva AI-generated Content.
5. The underlying source/license is independently identified (for example CC0/Public Domain, or another separately verified source license).
6. That independent license explicitly permits bundling/redistribution inside the app.
7. That independent license permits repeated derivative electronic export from the app.
8. License evidence URL/screenshot/record is retained.
9. 9:16, WhatsApp Status 9:16, 4:5 and 1:1 crop/readability tests pass after asset selection.

`VisualAssetManifestEntry.canBeFinalReusableBackground` now requires `hasIndependentReusableLicense=true` in addition to the existing redistribution/export, non-AI and non-Pro gates.

## Candidate-list implication

`CANVA_VISUAL_CANDIDATES.md` remains a discovery list only. Titles are not unique license identities and cannot establish Free/Pro/AI/source-license status. No candidate is promoted into the APK/AAB asset manifest until its exact Canva source information and independent reuse rights are captured.

This deliberately keeps TEST_MATRIX S01–S03 and TODO T0240 open until 100 real files satisfy the gate. The implementation must not weaken this rule merely to reach a numeric target.