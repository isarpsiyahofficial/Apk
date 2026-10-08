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
- Import/release gate: record exact downloaded bytes, retrieval date, upstream version/update reference, SHA-256 and attribution. The pinned canonical Tanzil asset has passed D01/D02 at the current reviewed HEAD; any later byte, manifest, license or packaging drift must fail closed and be reverified on its own exact HEAD.
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
- Current selected, pinned datasets: QuranEnc Turkish Rowad v1.0.4 (`turkish_rwwad`) and English Rowwad v1.0.19 (`english_rwwad`); the reviewed canonical assets and license/source attribution are recorded in `TODO.md` T0021–T0022 and `TEST_MATRIX.md` D03/D04. These PASS records apply to their exact pinned assets, not future revisions.
- Ongoing import/release gate: preserve exact translation keys, publisher, version, terms and attribution, source-response/asset hashes and retrieval evidence; do not silently edit the translation, strip required notices, infer broader reuse rights or accept drift. New or unclear offline/redistribution rights remain HOLD pending evidence.
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

## 7. Dini İçerik Metodolojisi — bağlayıcı editoryal sözleşme (T0036)

**Kapsam ve statü:** Bu bölüm, mevcut kaynak/lisans politikasını yeniden adlandırmadan genişletir. Ürün gereksinimleri için `SPECIFICATION.md` §§5–17, 517, 519–522, 685–686; uygulama sözleşmesi için `lib/core/content/content_governance.dart`; üretim kapısı için `docs/CONTENT_PUBLICATION_T0338_RELEASE_GATE.md` geçerlidir. Bu belge kaynak sınıflandırma ve editoryal çalışma metodolojisidir; bir dinî fetva, kurum onayı, tamamlanmış TR/EN/AR kullanıcı sayfası veya otomatik release onayı değildir.

### 7.1 Ne fetvadır, ne değildir?

- **Fetva değildir:** Uygulama kullanıcıya bağlayıcı fıkhî hüküm, kişiye özel dinî karar, günah/sevap hakkında bireysel kesin hüküm, gaip/gelecek bilgisi veya Allah'tan kişiye özel cevap vermez. Mezhep ihtilafında tek görüşü evrensel hüküm gibi sunmaz.
- **Bilgilendirme olabilir:** Kaynağı gösterilmiş ayet, meal, hadis, dua, tarihsel bilgi ve temaya göre önceden editoryal onaylanmış okuma önerileri. Kullanıcının yazdığı soru sadece yerel, sınırlı tema eşleştirmesine girer; rastgele ayet/kehanet veya serbest metin dinî hüküm üretimi yapılamaz.
- **Güvenli yanıt:** Uygun doğrulanmış tema/ayet kümesi bulunmazsa "bu soruya kesin dinî cevap veremem" anlamında açık sınır/boş durum gösterilir; ilgisiz ayet sırf bir cevap vermek için bağlanmaz. Yüksek riskli sağlık, ruh sağlığı, mali ve hukukî konularda dinî bilgi tedavi, teşhis, yatırım veya hukuk danışmanlığı yerine geçmez; kesin şifa/para/evlilik sonucu vaat edilmez.
- **Görünürlük:** İlgili içerikte kaynak, rivayet derecesi, yorum/gelenek ayrımı ve belirsizlik kullanıcıya erişilebilir olmalı; temel kaynak doğruluğu PRO/paywall arkasına alınamaz.

### 7.2 Kaynak sınıfları ve iddia gücü

Her iddia kendi **kaynak sınıfını** ve ondan ayrı **kesinlik düzeyini** taşır. Mevcut `ReligiousSourceClass` değerleriyle uyumlu sınıflandırma:

| Kaynak sınıfı | Kullanım ve sınır |
|---|---|
| `quran` | Exact pinned Tanzil Arapça ayet + ilgili canonical sure/ayet kimliği; meal ayrı kaynak/sürüm ile gösterilir. Ayet bağlamı veya muhatabı kaynakta olmayan kişiye taşınamaz. |
| `sahihHasanHadith` | Exact kayıt/locator, kaynak eser, HadeethEnc provenance ve kaynakta yayımlanmış derece; editör yeni derece uyduramaz. |
| `earlyIslamicHistoryTafsir` | Erken tefsir, sîre, meğâzî, tabakāt/kronik: rivayet/yorum bağlamı ve ihtilaf korunur; tek başına kesin tarih, sayı veya soy kanıtı değildir. |
| `meaningBasedDua` | Ayet/hadis diye atfedilmeyen, açık **Genel Dua / editoryal** etiketli metin; vahiy veya Hz. Peygamber sözü gibi gösterilemez. |
| `classicalTraditional`, `laterTradition` | Geleneksel/tasavvufî pratik veya sonraki yorum; kaynaklı sünnet ya da Kur’an kesinliği kazanmaz. |
| `israiliyat` | Açık İsrailiyat etiketiyle tarihsel/rivayet bağlamında; Kur’an kıssası gerçeğine yükseltilmez. |
| `modernHistoryArchaeology` | Belge, kitabe, sikke, arkeoloji ve modern akademik eleştiri: tarih/coğrafya araştırması; vahiy delili olarak gösterilmez. |
| `ebcedHavasTradition` | Harf-sayı ve havasın tarihsel/geleneksel anlatımı; kişisel kader, tılsım/vefk, irade kontrolü veya kaynaklı sünnet sayısı üretmez. |
| `disputed`, `unknown` | İhtilaf veya kaynak yetersizliği açık kalır; production kabulü ve kullanıcıya kesinlik iddiası için delil sayılmaz. |

`CertaintyLevel` ayrı tutulur: `explicitSource`, `stronglyAttested`, `approximate`, `traditional`, `disputed`, `unknown`. "Kaynağı var" tek başına "kesin" demek değildir. Kaynak sınıfı, rivayet derecesi, tarihsel belirsizlik ve editoryal çıkarım farklı alanlardır. `unknown` kayıtlar sırf boş slotu doldurmak için `verified` yapılamaz.

### 7.3 İddia → kaynak → bağlam doğrulaması

1. Her içerik/iddia için kararlı kimlik, sürüm, iddia metni, özne/sahiplik, kaynak sınıfı, exact locator/URL, dil varyantı, güven statüsü, lisans/attribution ve inceleyen kişi kanıtı kaydedilir. Atıf yalnız eser adı veya sosyal medya paylaşımı olamaz.
2. Ayet/hadis doğrulaması canonical kaynak metninin gerçekten bu iddiayı ve bu özneyi desteklediğini içerir; kelime eşleşmesi tek başına doğrulama değildir. Kur’an aslı ve tercüme sürümü ayrı, değiştirilmeden korunur.
3. Hadis rivayetinin kaynakta yayımlanan derecesi, asıl metin, çeviri, eser/locator ve sürüm korunur. Zayıf/ihtilaflı rivayet sahih/hasen gibi gösterilmez; kaynağın hükmü yoksa hüküm uydurulmaz.
4. Tarih, coğrafya, kişi, sayı ve aile/soy iddialarında mümkünse bağımsız kaynaklarla çapraz kontrol yapılır. Birincil belge ile klasik rivayet ve modern akademik yorumun farkı gizlenmez; yaklaşık veya bilinmiyor sonucu geçerli editoryal çıktıdır.
5. Kaynak erişilemiyor, iddia ile locator uyuşmuyor, lisans kanıtı yok, çeviri eksik veya güven düzeyi abartılıysa yayın **HOLD/withdrawn**; tahmini metadata ile PASS verilmez.

### 7.4 Peygamberler için 25 × 8 semantik sahiplik kapısı

Her 25 canonical peygamber için `identity → event → quranVerse → hadith → familyLineage → chronology → geography → historicalDate` boyutları **200 ayrı coverage slotu** olarak değerlendirilir. Her iddia `biographyProphetId` ve gerçek `subjectProphetId` bağını taşır; bağlamsal karşılaştırma (`contextReference`) biyografinin kendi olayı sayılmaz. Yûsuf'un kuyu/Mısır olayını Muhammed biyografisine veya Muhammed'in Hicret/Medine olayını Yûsuf biyografisine bağlamak **FAIL**; bu olaylardan sadece karşılaştırma amacıyla söz etmek explicit context etiketiyle mümkündür. Hadis ile Kur’an kaynak sınıfı birbirinin yerine geçirilemez. Soy grafiği ve yaklaşık kronoloji çapraz kontrol edilir; tahminî dönemden exact miladî tarih çıkarılmaz. Kesin tarih için ayrıca explicit exact-date kanıtı gerekir. `unknown` / `pendingReview` slotları gizlenmez ama verified coverage sayılmaz. Uygulama kapısı ve mevcut açık eksikler: `docs/PROPHET_T0336_SEMANTIC_RELEASE_GATE.md` ve `TEST_MATRIX.md` D10.

### 7.5 Dini günler, zikir, Esmâ ve gelenek

- Dinî gün/gece için nedir/tarihçe, ayet dayanağı, hadis locator+derece, güçlü-zayıf rivayet, yerel gelenek, özel ibadet/dua iddiası ve Hicrî–Gregoryen tarih belirsizliği ayrı alanlardır. Kaynaklı özel dua/namaz yoksa uydurulmaz; "sahih kaynakta özel dua tespit edilmedi" gibi açık bir sınır kullanılır. Gözlem/ülke farkıyla değişen tarihler kesinleştirilmez.
- Zikirde metin ve önerilen sayı ayrı provenance ister. Kullanıcının kişisel hedefi ve kolaylık için sunulan 33/100 hazır hedefleri **sünnet kaynaklı sayı** değildir. Kaynaklı sayı için exact sayı/locator ve güvenilir derece gerekir.
- Esmâ için niyet/tema eşleştirmesi yalnız anlam bağlantısıdır. Ebced/havas ve tasavvufî gelenek, Kur’an/Sünnet rozetinden ayrılır; kader okuma, vefk/tılsım, kişiyi bağlama, kesin şifa/para/aşk sonucu yasaktır.
- Tarih, biyografi ve dinî gün içeriklerinde mezhep/ekol ve kültürel gelenek farklılığı uygun etiketle korunur; çoğul gelenek tek evrensel İslam uygulaması diye genellenmez.

### 7.6 TR / EN / AR, gösterim ve paylaşım

TR/EN/AR metinler her dilde doğal, anlamca eşdeğer ve insan tarafından ayrı gözden geçirilmiş olmalıdır; Türkçeden mekanik çeviri native review değildir. Arapça canonical ayet locale string'inden üretilmez; RTL, hareke, uzun metin ve büyük fontta anlam kaybı/kesilme olmamalıdır. Ayet sure/ayet atfı, hadis derecesi ve "Genel Dua" etiketi uygun UI ve 9:16, 4:5, 1:1 exportta kilitli kalır; kullanıcı kutsal metni değiştiremez. Her önemli dinî kartın kaynak erişimi bulunur.

### 7.7 Editoryal yaşam döngüsü ve hata düzeltme

**Araştırma → kaynak/lisans kanıtı → dinî içerik review → üç ayrı dil review → fail-closed testler → `approved` → ayrı `published` onayı**. `draft`, `research`, `religiousReview`, `languageReview`, `approved`, `withdrawn` production yayın durumu değildir. `published` etiketi tek başına da yeterli değildir: stable ID, pozitif sürüm, tam TR/EN/AR, reviewer, exact kaynak/locator, lisans ve içerik türüne özel QA kapıları gerekir. Kaynak/metin sürümü değişince önceki onay otomatik taşınmaz; yanlış atıf, telif, kesinlik veya özne sahipliği saptanırsa kayıt yayın dışı bırakılır, düzeltme yeniden gözden geçirilir.

**Doğrulama sınırı:** `docs/CONTENT_PUBLICATION_T0338_RELEASE_GATE.md`, `docs/CONTENT_T0334_FORBIDDEN_CLAIM_RELEASE_GATE.md`, `docs/PROPHET_T0336_SEMANTIC_RELEASE_GATE.md` ve `TEST_MATRIX.md` ayrı bağımsız release kapılarıdır. Bu metodoloji belgesinin varlığı D05–D11, TR/EN/AR UI crawl, gerçek export, lisans, runtime happy/failure-path veya nihai mağaza onayı için **PASS değildir**. SPEC 517 uyarınca kullanıcıya gösterilecek üç dilli metodoloji sayfası/bağlantısı ve gerçek cihaz davranışı ayrıca doğrulanmalıdır.
