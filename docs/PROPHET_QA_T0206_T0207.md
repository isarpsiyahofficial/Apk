# Prophet QA evidence — T0206 / T0207

This note records the implementation evidence for the prophet-data QA gates on the active implementation branch. It does not upgrade unresolved editorial/native-review work to PASS.

## T0206 — Quran reference cross-validation

- `ProphetQuranReferenceValidator` resolves every canonical prophet Quran reference against the pinned `CanonicalQuranDataset` rather than accepting only broad `1..114 / ayah > 0` shape checks.
- It rejects unknown/out-of-range ayat, duplicate references, duplicate canonical prophet IDs, empty prophet reference lists, canonical lookup mismatches, and empty cross-validation input.
- `prophet_quran_reference_validator_test.dart` verifies all 25 canonical prophets against the bundled pinned Quran asset and includes failure-path coverage such as invalid `1:8`.
- Implementation HEAD `94db2ca353bccf8c73998b18b501ed19a8128d5c` passed Flutter CI #972, Android Debug #906, Android Release #440, Android Emulator Smoke #431, Quran Source Verify #426, and QuranEnc Meal Verify #405.

## T0207 — biography/certainty/genealogy/timeline QA

`ProphetBiographyQaAudit` is fail-closed and covers the SPEC 897–903 QA families:

1. source-backed biography text without source metadata is rejected;
2. invalid or falsely exact date evidence is rejected through `ProphetDateEvidence.isValid` and exact-source certainty rules;
3. every `ReligiousSourceClass.israiliyat` source requires explicit badge evidence by stable source ID;
4. contradictory genealogy pairs and directed ancestry cycles are rejected;
5. invalid timeline bands, non-contiguous ordering, duplicate prophet placement, and genealogy-vs-timeline ordering contradictions are rejected.

`prophet_biography_qa_test.dart` runs the canonical T0194 research dataset through the audit and separately injects each failure path above. Exact code/test HEAD `e93dd70d3494798683e1dcd53d83f97060c2f23c` passed Flutter CI #976, Android Debug #910, Android Release #442, Android Emulator Smoke #433, Quran Source Verify #428, and QuranEnc Meal Verify #407.

## Deliberately still open

- D10 is not promoted to PASS merely because structural/source-class QA exists: T0194 still contains explicit `unknownPendingResearch` fields and production biography review remains incomplete.
- D14 remains open until real human TR/EN/AR native review evidence exists; automated terminology tests are not a substitute for native editorial review.
- Israiliyat badge enforcement is a data/UI contract: production data containing Israiliyat must supply the explicit badge source IDs to the audit and presentation layer. The current canonical T0194 seed does not silently infer or hide such provenance.
