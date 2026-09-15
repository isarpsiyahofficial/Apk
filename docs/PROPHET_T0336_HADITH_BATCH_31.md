# T0336 Hadith Batch 31 — Âdem / Sahih Muslim 854b

## Scope

This batch advances the mandatory prophet-semantic `hadith` dimension without inferring an exact historical year, geography, genealogy, or chronology from the report.

## Primary locator

- Collection: **Sahih Muslim**
- Exact application locator: **Sahih Muslim 854b**
- Application source id: `sahih-muslim-854b-adam-friday`
- Source class: `sahihHasanHadith`
- Rights mode: `REFERENCE-ONLY`
- Public reference checked: `https://sunnah.com/muslim/7/27`

The report explicitly associates Adam with creation on Friday and with entering and leaving Paradise on Friday. The application stores a short original editorial paraphrase in TR/EN/AR; it does not package or redistribute the public website's translation text.

## Independent cross-check

Diyanet İşleri Başkanlığı Din İşleri Yüksek Kurulu, in its 7 February 2024 answer **“Mübârek gün ve geceler ile kandillerin İslam’daki yeri nedir?”**, cites the same report as `Müslim, Cum’a, 18 [854]` and describes Adam's creation, entry into Paradise, and exit from Paradise on Friday.

Reference: `https://kurul.diyanet.gov.tr/tr/fetva/mubarek-gun-ve-geceler-ile-kandillerin-islamdaki-yeri-nedir/a43ec845-60e3-439a-08f5-08dd1c135351`

The differing display suffix (`854b`) versus collection-level citation (`854`) is not normalized away in code: the application provenance gate pins the exact selected locator `Sahih Muslim 854b`, while the Diyanet citation is used only as an independent content cross-check.

## Fail-closed boundaries

- `sahih-muslim-854b-adam-friday` is admitted only with exact title `Sahih Muslim`, exact locator `Sahih Muslim 854b`, `REFERENCE-ONLY`, and `sahihHasanHadith` source class.
- ID, title, licence, or locator tampering must fail T0194 provenance.
- The resulting T0336 claim must remain biography-owner `adam` / subject-owner `adam`.
- Moving the claim into another prophet biography must fail semantic ownership QA.
- This report does **not** create a verified `historicalDate` claim; that slot remains unresolved.

## Coverage effect

After this batch, verified prophet owners for the T0336 hadith dimension are expected to be **2/25** (`adam`, `muhammad`). The remaining 23 prophet hadith slots remain explicit unresolved/pending research and therefore do not satisfy the release gate.
