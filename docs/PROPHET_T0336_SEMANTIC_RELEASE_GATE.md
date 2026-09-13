# T0336 — 25×8 Peygamber Semantik Release Kapısı

Bu belge SPEC v1.2'deki peygamber biyografisi semantik doğrulamasının uygulamadaki fail-closed sözleşmesini özetler.

## Zorunlu matris

25 canonical peygamberin her biri için aşağıdaki 8 boyut ayrı ayrı doğrulanmalıdır:

1. `identity`
2. `event`
3. `quranVerse`
4. `hadith`
5. `familyLineage`
6. `chronology`
7. `geography`
8. `historicalDate`

Toplam zorunlu slot sayısı **25 × 8 = 200**'dür.

## PASS sayılan evidence

Bir slot yalnızca aşağıdaki şartların tamamı sağlanırsa `verified` sayılır:

- claim canonical peygamber kimliğine aittir;
- `biographyProphetId == subjectProphetId` olmalıdır;
- claim `contextReference` değildir;
- evidence state `verified` olmalıdır;
- kaynak kimliği boş değildir;
- semantik boyuta izin verilen kaynak sınıfı açıkça belirtilmiştir;
- `ProphetSemanticOwnershipQa` claim'i kabul eder.

`unknown` ve `pendingReview` kayıtları araştırmanın belirsizliğini korumak için tutulabilir fakat release coverage'a **asla sayılmaz**.

## Yanlış sahiplik koruması

Metinde başka bir peygamberin adının doğal biçimde geçmesi hata değildir. Hata, olayın/iddianın öznesinin yanlış biyografiye sahiplik olarak atanmasıdır.

Örnek fail-closed vakalar:

- Yûsuf'a ait kuyu/Mısır olayının Muhammed biyografisine aitmiş gibi atanması;
- Muhammed'e ait Hicret/Medine olayının Yûsuf biyografisine aitmiş gibi atanması;
- Kur'an kaynağının hadis evidence sınıfı gibi yeniden etiketlenmesi;
- period/chronology bilgisinden bağımsız kaynak olmadan kesin `historicalDate` üretilmesi.

## Makine-okunur kanıt yüzeyleri

- `prophet_semantic_evidence_t0336.dart`: canonical veri katmanlarından kabul edilen semantik claim'leri üretir. Exact historical date kanıtı bulunmayan 25 canonical peygamber için ayrıca explicit `unknown` claim üretir; bu kayıtlar coverage artırmaz.
- `prophet_semantic_coverage_report_t0336.dart`: peygamber bazında covered/missing boyutları özetler.
- `prophet_semantic_gap_manifest_t0336.dart`: 200 slotun her birini verified claim key/source id ile açıkça gösterir; ayrıca `unknown`/`pendingReview` claim key ve state'lerini ayrı tutarak eksikliği makine-okunur bırakır.
- `prophet_semantic_release_gate_t0336.dart`: coverage report ile gap manifestin birebir aynı sonucu verdiğini çapraz doğrular.
- `prophet_exact_date_claim_audit_t0207.dart`: T0194 biyografi metnindeki takvim yılı iddialarını ayrı fail-closed kapıdan geçirir. T0336 coverage hesabı bu denetimi doğrudan çalıştırır; desteklenmeyen veya kesinliği abartılmış takvim tarihi içeren bir canonical biyografi varken hiçbir 25×8 coverage sonucu release kanıtı sayılamaz.

Bu yüzeylerden biri eksik slotu gizlerken diğeri eksik gösterirse release gate FAIL olur.

## Aile/soy + kronoloji çapraz kontrolü

`verified_prophet_family_relations.dart` yalnız exact source metadata ile önceden review edilmiş ilişki iddialarını kabul eder. Quran source class etiketi tek başına yeterli değildir; claim id, iki canonical kimlik, ilişki yönü, locator, lisans ve source id birlikte pinlenir. Şu anda Kur'an-explicit ve ayrıca gözden geçirilmiş ilişkiler şunlardır:

- Mûsâ ↔ Hârûn — kardeşlik, Kur'an 20:30;
- Zekeriyyâ → Yahyâ — baba/oğul, Kur'an 19:7;
- İbrâhim → İsmâil — baba/oğul, Kur'an 14:39;
- İbrâhim → İshak — baba/oğul, Kur'an 14:39;
- İshak → Ya‘kūb — baba/oğul, Kur'an 21:72; oğulluk okuması Diyanet Kur'an Yolu tefsiriyle ayrıca çapraz kontrol edilmiştir;
- Ya‘kūb → Yûsuf — baba/oğul, Kur'an 12:4–6; soy zinciri Diyanet Kur'an Yolu tefsiriyle ayrıca çapraz kontrol edilmiştir;
- Dâvûd → Süleyman — baba/oğul, Kur'an 38:30; oğulluk okuması Diyanet Kur'an Yolu tefsiriyle ayrıca çapraz kontrol edilmiştir.

Bu yedi relation fact T0336 içinde 14 `familyLineage` claim üretir ve **11 farklı canonical peygamberin** family-lineage slotuna verified evidence sağlar. Bir peygamber birden fazla exact relation taşıyabildiği için claim sayısı coverage-slot sayısından büyüktür. Bu ilerleme 25/25 soy coverage anlamına gelmez.

Ayrıca `verifiedProphetFamilyChronologyIsConsistent` aynı reviewed relation setini bağımsız `mainApproximateProphetChronology` katmanıyla karşılaştırır. Parent/ancestor claim'i child/descendant bandından önce gelmelidir; sibling claim'i aynı chronology bandında olmalıdır. Bu audit yaklaşık chronology bilgisini exact tarihe yükseltmez. Doğrudan review edilmiş zincirler dahi transitive yeni relation üretmez: örneğin İbrâhim → İshak ve İshak → Ya‘kūb kayıtları İbrâhim → Ya‘kūb için otomatik ayrı coverage üretmez.

## Tarih / kronoloji çapraz kontrolü

`chronology` coverage tek başına `historicalDate` coverage üretmez. Canonical T0194 datasetindeki takvim yılı içeren biyografi metni ayrıca T0207 exact-date auditinden geçer. Kaynaksız takvim yılı, modern-history provenance olmadan verilen civil tarih veya yaklaşık kaynak bilgisini kesin tarihe yükselten ifade FAIL olur. Bu kontrol coverage hesaplanmadan önce çalışır; böylece semantik slot sayısı geçersiz tarih metnini maskeleyemez.

Canonical T0336 registry'de 25 peygamberin `historicalDate` slotu şu an explicit `unknown` olarak kayıtlıdır. Bu, tarih bulunmadığını saklamaz ve hiçbir slotu PASS'e yükseltmez. İleride exact-date evidence eklenirse ilgili unknown kayıt kaldırılmalı; verified claim bağımsız kaynak/provenance ve T0207 tarih kesinliği kontrollerinden geçmelidir.

## Bilinmeyen tarih/soy kuralı

Eksik `historicalDate`, soy veya coğrafya bilgisi sırf 200 slotu doldurmak için tahmin edilemez. Güvenilir, izlenebilir ve ilgili semantik boyutu gerçekten destekleyen kaynak bulunmadıkça slot açık kalır. Tarihsel tarih iddiasında belirsizlik/approximation gerekiyorsa içerikte de korunur.

## Final koşulu

D10/D11 yalnızca canonical 200 slotun tamamı doğrulanmış evidence ile kapandığında ve ownership + provenance + genealogy + chronology + calendar-date QA birlikte yeşil olduğunda PASS yapılabilir. Explicit `unknown`/`pendingReview` kayıtları araştırma durumunu kanıtlar fakat release coverage sayılmaz. Bu koşul sağlanmadan peygamber hayatları final kabul edilmez.
