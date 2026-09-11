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

- `prophet_semantic_evidence_t0336.dart`: canonical veri katmanlarından kabul edilen semantik claim'leri üretir.
- `prophet_semantic_coverage_report_t0336.dart`: peygamber bazında covered/missing boyutları özetler.
- `prophet_semantic_gap_manifest_t0336.dart`: 200 slotun her birini claim key/source id ile açıkça gösterir; eksikleri görünür bırakır.
- `prophet_semantic_release_gate_t0336.dart`: coverage report ile gap manifestin birebir aynı sonucu verdiğini çapraz doğrular.
- `prophet_exact_date_claim_audit_t0207.dart`: T0194 biyografi metnindeki takvim yılı iddialarını ayrı fail-closed kapıdan geçirir. T0336 coverage hesabı artık bu denetimi doğrudan çalıştırır; desteklenmeyen veya kesinliği abartılmış takvim tarihi içeren bir canonical biyografi varken hiçbir 25×8 coverage sonucu release kanıtı sayılamaz.

Bu yüzeylerden biri eksik slotu gizlerken diğeri eksik gösterirse release gate FAIL olur.

## Tarih / kronoloji çapraz kontrolü

`chronology` coverage tek başına `historicalDate` coverage üretmez. Canonical T0194 datasetindeki takvim yılı içeren biyografi metni ayrıca T0207 exact-date auditinden geçer. Kaynaksız takvim yılı, modern-history provenance olmadan verilen civil tarih veya yaklaşık kaynak bilgisini kesin tarihe yükselten ifade FAIL olur. Bu kontrol coverage hesaplanmadan önce çalışır; böylece semantik slot sayısı geçersiz tarih metnini maskeleyemez.

## Bilinmeyen tarih/soy kuralı

Eksik `historicalDate`, soy veya coğrafya bilgisi sırf 200 slotu doldurmak için tahmin edilemez. Güvenilir, izlenebilir ve ilgili semantik boyutu gerçekten destekleyen kaynak bulunmadıkça slot açık kalır. Tarihsel tarih iddiasında belirsizlik/approximation gerekiyorsa içerikte de korunur.

## Final koşulu

D10/D11 yalnızca canonical 200 slotun tamamı doğrulanmış evidence ile kapandığında ve ownership + provenance + genealogy + chronology + calendar-date QA birlikte yeşil olduğunda PASS yapılabilir. Bu koşul sağlanmadan peygamber hayatları final kabul edilmez.
