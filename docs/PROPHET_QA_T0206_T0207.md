# Prophet QA evidence — T0206 / T0207

This note records the implementation evidence for the prophet-data QA gates on the active implementation branch. It does not upgrade unresolved editorial/native-review work to PASS.

## T0206 — Quran reference cross-validation

- `ProphetQuranReferenceValidator` resolves every canonical prophet Quran reference against the pinned `CanonicalQuranDataset` rather than accepting only broad `1..114 / ayah > 0` shape checks.
- It rejects unknown/out-of-range ayat, duplicate references, duplicate canonical prophet IDs, empty prophet reference lists, canonical lookup mismatches, and empty cross-validation input.
- `prophet_quran_reference_validator_test.dart` verifies all 25 canonical prophets against the bundled pinned Quran asset and includes failure-path coverage such as invalid `1:8`.
- Current exact T0206 branch HEAD `5fe2649e4289e1198892b21617bc1da362a4fd77` passed Flutter CI #2074, Android Debug #2008, Android Release #988, Android Emulator Smoke #979, Quran Source Verify #974, and QuranEnc Meal Verify #957.

## T0207 — biography/certainty/genealogy/timeline QA

`ProphetBiographyQaAudit` is fail-closed and covers the SPEC 897–903 QA families:

1. source-backed biography text without source metadata is rejected;
2. invalid or falsely exact structured date evidence is rejected through `ProphetDateEvidence.isValid` and exact-source certainty rules;
3. every `ReligiousSourceClass.israiliyat` source requires explicit badge evidence by stable source ID;
4. contradictory genealogy pairs and directed ancestry cycles are rejected;
5. invalid timeline bands, non-contiguous ordering, duplicate prophet placement, and genealogy-vs-timeline ordering contradictions are rejected.

T0207 now also has `ProphetExactDateClaimAuditT0207`. This closes a separate failure path that the structured `ProphetDateEvidence` model alone could not catch: a calendar year written directly into TR/EN/AR biography prose. The release QA scan rejects Latin `BC/BCE/AD/CE/AH`, Turkish `MÖ/MS/Hicri/Miladi`, and Arabic Hijri/Gregorian/BCE-style markers when they are embedded as unstructured exact-year claims. Quranic durations such as Noah's mission duration are not treated as calendar years.

`prophet_biography_qa_test.dart` injects the source, certainty, Israiliyat, genealogy and timeline failures. `prophet_exact_date_claim_audit_t0207_test.dart` additionally scans the supplemented canonical T0194 dataset and injects Latin and Arabic calendar-year leaks.

## Deliberately still open

- D10/D11 PASS remain supported by the existing canonical biography provenance and genealogy/timeline audits; this note does not promote unrelated content rows.
- D14 remains open until real human TR/EN/AR native review evidence exists; automated terminology and exact-year scans are not substitutes for native editorial review.
- Israiliyat badge enforcement is a data/UI contract: production data containing Israiliyat must supply the explicit badge source IDs to the audit and presentation layer. The current canonical T0194 seed does not silently infer or hide such provenance.
- T0207 must not be marked complete until the new exact-date audit HEAD is green in Flutter and Android release/full-test CI.
