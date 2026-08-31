# CONTENT SOURCE POLICY

**Status:** Binding research and ingestion policy. A source listed here is not production-approved until its exact content version, license evidence and hash are recorded in the source manifest.

## 1. Qur'an Arabic text

### Tanzil Quran Text v1.1 Uthmani — selected canonical baseline

- Source license: https://tanzil.net/docs/text_license
- Official download/version reference: https://tanzil.net/docs/download
- Selected canonical variant: **Tanzil Quran Text v1.1, Uthmani**.
- License shown by the source: Creative Commons Attribution 3.0.
- Required behavior: distribute verbatim; changing the Qur'an text is not allowed.
- Required attribution: clearly identify Tanzil Project and provide a link to tanzil.net so users can track changes.
- The copyright notice must accompany verbatim copies / files containing a substantial portion of the text.
- Product decision: this is the canonical bundled, read-only Arabic Qur'an baseline because the product requires deterministic hashes and offline PRO access.
- Structural contract: 114 suras and 6236 standard ayah records; exact requirements are in `docs/QURAN_DATASET_CONTRACT.md` and enforced by `scripts/validate_quran_dataset.py`.
- Import gate: record the exact downloaded bytes, retrieval date, upstream version/update reference, source file SHA-256 and attribution text. Until that exact asset is imported and verified, TEST_MATRIX D01/D02 remain TODO.
- Search normalization, presentation-only Bismillah handling or indexing must never rewrite the canonical source bytes.

## 2. Quran Foundation APIs

- Terms checked: https://api-docs.quran.foundation/legal/developer-terms/
- Terms page observed as last updated 2026-08-26.
- QF permits beneficial Quranic applications and allows freemium, advertising and in-app purchases when QF Content remains part of the end-user experience and raw content is not sold/sublicensed/redistributed.
- Qur'an text may not be modified.
- General QF Content cache/storage is limited to one week unless expressly permitted or returned by the Content Sync offline mechanism; Content Sync must be refreshed at least every seven days.
- Product decision: do **not** make normal QF API responses the sole bundled offline Qur'an source. Any future QF integration must be isolated behind its own adapter and comply with current cache/sync/privacy terms.
- QF data must never be used to build advertising profiles or ML models.

## 3. QuranEnc translations

- Source/about/API: https://quranenc.com/en/home/about
- QuranEnc describes its project as providing free, trustworthy translations/exegeses prepared and reviewed by specialized bodies, including formats usable by applications and systems.
- Product decision: translation **candidate**, not yet production-approved.
- Gate before import: identify the exact Turkish/English translation keys, publisher/translator, explicit reuse/license terms for each dataset, version/retrieval date and SHA-256. If exact redistribution/offline rights are not sufficiently clear, do not bundle until written/explicit permission is resolved.
- Do not assume Tanzil's Arabic-text CC BY 3.0 license grants commercial redistribution rights for translations listed on Tanzil; translation rights are reviewed separately.

## 4. Hadith / dua

- No narration enters production solely because it appears on social media, a blog, quote image or unsourced app.
- Every hadith-derived dua requires collection/reference metadata and, where relevant, authenticity grading plus the source used for that grading.
- Exact translated wording requires its own copyright/reuse review.
- General editorial duas must be explicitly labeled as general/editorial and may not be attributed to the Prophet or Qur'an.

## 5. Prophets and Islamic history

Every factual statement must carry a source class:

1. Qur'an
2. Sahih/Hasan hadith
3. Early Islamic history/tafsir
4. Isra'iliyyat
5. Later tradition
6. Modern history/archaeology
7. Disputed
8. Unknown

Rules:

- Unknown dates remain unknown; do not fabricate BCE/CE years.
- Approximate dates must be labeled approximate.
- Isra'iliyyat is never presented as Qur'anic fact.
- Traditional and modern historical conclusions may coexist when clearly separated.
- Major historical events should be cross-checked against at least two reliable references when reasonably possible.
- Copying encyclopedia prose is prohibited; sources are for verification and citation, not unlicensed reproduction.

### TDV İslâm Ansiklopedisi / İSAM

- Official rights/usage pages re-checked on 2026-08-31: `https://islamansiklopedisi.org.tr/hakk` and `https://islamansiklopedisi.org.tr/kullanim_sartlari.php`.
- The site states that TDV İslâm Ansiklopedisi copyright belongs to TDV İslâm Araştırmaları Merkezi / İSAM; whole articles may not be republished, while short quotations require source attribution and a direct active link. Its visual material is not to be republished in another medium under those site terms.
- Product decision: TDV is **verification/citation only by default**. Do not bundle TDV article prose, images, maps, tables, drawings or photographs.
- A future direct quotation requires a separately reviewed quotation record and evidence that the exact intended use complies with the then-current terms. Source citation alone is not redistribution permission.
- T0224 enforcement and audit evidence live in `docs/HISTORY_T0224_TEXT_RIGHTS_AUDIT.md` and `scripts/audit_history_text_rights.py`.

## 6. Production ingestion gate

A religious content record may enter the production dataset only when all required conditions pass:

- unique stable content ID,
- version > 0,
- source reference(s) present,
- source/license record present,
- certainty status present,
- TR + EN + AR content complete when that record is intended for all three locales,
- religious review complete,
- language review complete,
- final status `published`,
- no prohibited certainty/guarantee wording,
- automated dataset validation passes.

The Dart implementation of these core gates starts in `lib/core/content/content_governance.dart` and is enforced by tests in `test/content_governance_test.dart`.
