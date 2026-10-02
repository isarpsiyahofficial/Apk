# T0336 — Geography unresolved release gate

## Scope

This audit is intentionally conservative. It does **not** claim that no historical geography can ever be established for the prophets below. It records only that the currently admitted Quran anchors do not provide enough explicit, release-safe terrestrial geography to promote these seven biography geography slots to `verified` without importing a weaker or disputed inference.

The release rule is fail-closed: a popular traditional location, later identification, modern border, coordinate, route or archaeological proposal must not silently become canonical geography. A slot stays explicit unresolved until an independently reviewed source claim is admitted through the T0194 provenance model and the T0336 ownership gate.

## Current unresolved canonical set

| Prophet ID | Quran anchor reviewed | Release decision |
|---|---|---|
| `adam` | 2:35–36 | The passage gives Garden → earth language, but no named terrestrial location suitable for a canonical map/geography claim. Do not infer a modern or historical landing location. |
| `idris` | 19:56–57 | The passage says Idris was raised to a high station. This is not a release-safe named terrestrial geography. |
| `ishaq` | 37:112–113 | The passage gives the glad tidings and blessing of Ishaq, but no explicit named location for Ishaq himself. |
| `ilyas` | 37:123–132 | The passage records Ilyas addressing his people and rejecting Baal worship; the admitted Quran anchor does not itself name a terrestrial place. |
| `alyasa` | 38:48 | Elyesa is named among the good; this verse does not supply a location. |
| `yahya` | 19:7–15 | The passage establishes Yahya's birth/name/qualities, but does not supply a named terrestrial geography for him. |
| `dhul_kifl` | 21:85–86; 38:48 | The Quran anchors establish patience/righteousness but do not supply a named terrestrial geography. Later reports about identity or burial location remain outside verified geography until independently reviewed. |

## Cross-check sources

Primary application source remains the pinned Tanzil Uthmani v1.1 Quran dataset already governed by the repository. For editorial cross-checking, the following Diyanet Kur'an Yolu pages were reviewed on 2026-09-13:

- Adam, Bakara 2:35–36: https://kuran.diyanet.gov.tr/mushaf/kuran-meal-1/bakara-suresi-2/ayet-35/diyanet-vakfi-meali-4
- Idris, Meryem 19:56–57: https://kuran.diyanet.gov.tr/tefsir/Meryem-suresi/2306/56-57-ayet-tefsiri
- Ishaq, Saffat 37:112–113: https://kuran.diyanet.gov.tr/mushaf/tefsir-2/saffat-suresi-37/ayet-77/kuran-yolu-meali-5
- Ilyas, Saffat 37:123–132: https://kuran.diyanet.gov.tr/mushaf/kuran-tefsir-1/saffat-suresi-37/ayet-107/diyanet-isleri-baskanligi-meali-1
- Elyesa, Sad 38:45–48: https://kuran.diyanet.gov.tr/mushaf/kuran-tefsir-1/sad-suresi-38/ayet-43/kuran-yolu-meali-5
- Yahya, Meryem 19:7 and 19:15: https://kuran.diyanet.gov.tr/tefsir/Meryem-suresi/2257/7-ayet-tefsiri and https://kuran.diyanet.gov.tr/tefsir/Meryem-suresi/2265/15-ayet-tefsiri
- Dhul-Kifl, Enbiya 21:85–86: https://kuran.diyanet.gov.tr/tefsir/Enbiy%C3%A2-suresi/2568/85-86-ayet-tefsiri

Diyanet is used here as a secondary editorial cross-check, not as an authorization/endorsement claim and not as a replacement for the application's pinned Quran source.

## QA consequences

1. Verified geography owner count remains **18/25**.
2. The unresolved owner set must remain exactly: `adam`, `idris`, `ishaq`, `ilyas`, `alyasa`, `yahya`, `dhul_kifl` until new reviewed evidence is admitted.
3. These seven unresolved records must stay machine-readable; they may not disappear as silent gaps.
4. Adding one of these prophet IDs to verified geography without T0194 source-backed provenance must fail the regression gate.
5. `D10`/`D11` remain TODO. This document is a research hold/gate, not a PASS declaration.
