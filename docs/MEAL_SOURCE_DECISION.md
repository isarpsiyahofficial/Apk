# Meal Source Decision — TR / EN

**Durum:** Kaynak/lisans kararı, production import doğrulaması ve release asset paketleme kapısı oluşturuldu.  
**Doğrulama tarihi:** 27 Ağustos 2026

## Seçilen kaynak ailesi

TR ve EN meal için ana kaynak **QuranEnc.com / Rowad (Rowwad) Translation Center** olarak sabitlenmiştir.

### Türkçe

- Başlık: **Türkçe Tercüme - Rowad Tercüme Merkezi**
- Translation key: `turkish_rwwad`
- Kaynak sayfası: `https://quranenc.com/tr/browse/turkish_rwwad`
- QuranEnc arayüzünde görünen sürüm: **V1.0.4**
- API/canonical dataset içinde exact sürüm değeri: **`1.0.4`**
- Canonical generated dataset SHA-256: **`a0c001b1e690cc022351d55b9951a7410fde4a6266638766c553fa91f401b1b7`**
- Coverage: **114 sure / 6236 ayet**

### English

- Title: **English Translation - Rowwad Translation Center**
- Translation key: `english_rwwad`
- Source page: `https://quranenc.com/en/browse/english_rwwad`
- QuranEnc UI version: **V1.0.19**
- Exact API/canonical dataset version value: **`1.0.19`**
- Canonical generated dataset SHA-256: **`24c81ccfa5818e417b96f3b457955d34308a95d006a65c894ac69eaba580a3c0`**
- Coverage: **114 sure / 6236 ayet**

> Runtime validation pins the exact API value (`1.0.x`). The leading `V` is presentation-only and must never be part of byte/dataset identity checks.

## Yeniden yayınlama şartları

QuranEnc'in resmi Terms and Policies sayfası çeviri içeriklerinin indirilip yeniden yayımlanmasına izin verir; ancak aşağıdaki şartları zorunlu tutar:

1. İçerikte değişiklik, ekleme veya silme yapılmamalıdır.
2. Yayıncı ve kaynak olarak QuranEnc.com açıkça belirtilmelidir.
3. Yeniden yayımlanan çevirinin sürüm numarası belirtilmelidir.
4. Dosya içindeki çeviri/transcript bilgileri korunmalıdır.
5. Çeviriyle ilgili tespitler QuranEnc'e bildirilmelidir.
6. Kaynak yeni sürüm yayımladığında uygulamadaki çeviri güncellenmelidir.
7. Meal gösterilirken uygunsuz reklamlar bulunmamalıdır.

Bu şartlar uygulamanın mevcut dini içerik politikasıyla uyumludur: meal metni immutable tutulacak, attribution görünür olacak, exact sürüm/hash manifesti saklanacak ve meal reader içinde reklam gösterilmeyecektir.

## Doğrulanmış production import kanıtı

`QuranEnc Meal Verify` workflow'u canlı resmi API üzerinden her iki çeviri için 114 surenin tamamını ayrı ayrı indirmektedir. `scripts/fetch_quranenc_meals.py`:

- önce resmi translation-list endpoint'inden translation key ve exact sürümü doğrular,
- her surenin canlı API response byte'larını **parse etmeden önce SHA-256** ile kaydeder,
- canonical sure/ayet sayılarıyla her response'u karşılaştırır,
- duplicate, eksik veya sıra dışı ayet olduğunda fail-closed olur,
- `translation` ve `footnotes` değerlerini aynen korur; yazım düzeltmesi, paraphrase, AI çevirisi veya normalizasyon uygulamaz,
- deterministic canonical JSON üretir ve ayrıca onun SHA-256 değerini manifestte sabitler.

27 Ağustos 2026 doğrulamasında:

- `turkish_rwwad` → API `1.0.4` / UI `V1.0.4` → 114 sure / 6236 ayet → SHA-256 `a0c001b1e690cc022351d55b9951a7410fde4a6266638766c553fa91f401b1b7`
- `english_rwwad` → API `1.0.19` / UI `V1.0.19` → 114 sure / 6236 ayet → SHA-256 `24c81ccfa5818e417b96f3b457955d34308a95d006a65c894ac69eaba580a3c0`
- her dil için 114 ayrı official sura response hash kaydı üretilir,
- workflow artifact'i `verified-quranenc-rowad-meals` olarak üretilir.

## Uygulama asseti ve runtime fail-closed zinciri

`scripts/prepare_quranenc_meal_assets.py` yalnız yukarıdaki exact SHA-256 ve exact API sürümü eşleşen canonical JSON dosyalarını Flutter asset alanına byte-for-byte kopyalar. Kopya tekrar hashlenir; unpinned JSON dosyaları asset alanından temizlenir.

`BundledMealDatasetLoader` runtime'da tekrar:

- asset byte SHA-256,
- translation key,
- exact API version,
- 114 sure,
- 6236 ayet,
- duplicate locator,
- contiguous sure/ayet sırası,
- boş meal / geçersiz dipnot tipini

kontrol eder. Bir kontrol bile başarısızsa meal güvenilir içerik olarak dönmez.

Android Release CI, build öncesinde hem Tanzil Arapça kaynağını hem iki QuranEnc meal datasetini hazırlar. APK oluşturulduktan sonra üç kaynak dosyasının gerçekten `flutter_assets` içinde bulunduğu kontrol edilir ve TR/EN meal SHA-256 değerleri tekrar pinned hashlerle karşılaştırılır.

## Neden Quran Foundation ana offline meal kaynağı seçilmedi?

Quran Foundation'ın 18 Ağustos 2026 tarihli Developer Terms ve güncel Connected Apps dokümantasyonu, API içeriği için ek geliştirici şartları uygular; ticari uygulamalarda bazı translation/tafsir içeriklerinin yeniden dağıtımı ayrıca yazılı içerik lisansı gerektirebilir. Bu nedenle QF, açık yazılı içerik lisansı alınmadan bundled offline ana meal kaynağı yapılmayacaktır.

## Production import için zorunlu kapılar

- TR ve EN için 114 sure / 6236 ayetin tamamı bulunmalı. **PASS**
- Her satır `sura`, `ayah`, `translation`, varsa `footnotes` alanlarıyla canonical ayet kimliğine bağlanmalı. **PASS**
- Duplicate veya eksik ayet bulunursa import FAIL olmalı. **PASS — fail-closed validator**
- İndirilen exact source response payload'ları SHA-256 ile pinlenmeli. **PASS — 114 response hash / dil**
- Publisher, source URL, translation key, exact source version ve hash manifestte tutulmalı. **PASS**
- Meal metnine otomatik yazım düzeltmesi, yeniden çeviri veya AI paraphrase uygulanmamalı. **PASS — importer sözleşmesi**
- Kaynak yeni sürüm yayımladığında fark raporu olmadan sessiz replace yapılmamalı. **Enforced by exact API version + SHA pin**
- Runtime loader bozuk/eksik/unpinned asseti kabul etmemeli. **PASS — unit test sözleşmesi**
- Release APK/AAB meal JSON'larını ancak pre-build verification sonrası paketlemeli. **CI gate oluşturuldu; son clean run sonucu ayrıca kaydedilecektir.**

## Resmi doğrulama bağlantıları

- QuranEnc Terms and Policies: `https://quranenc.com/en/home/about/terms-and-conditions`
- QuranEnc API docs: `https://quranenc.com/en/home/api`
- Turkish Rowad: `https://quranenc.com/tr/browse/turkish_rwwad`
- English Rowwad: `https://quranenc.com/en/browse/english_rwwad`
- Quran Foundation Developer Terms: `https://api-docs.quran.foundation/legal/developer-terms/`
- Quran Foundation Connected Apps: `https://api-docs.quran.foundation/docs/connected-apps/`
