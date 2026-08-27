# Meal Source Decision — TR / EN

**Durum:** Kaynak/lisans kararı doğrulandı; production import pipeline henüz tamamlanmadı.  
**Doğrulama tarihi:** 27 Ağustos 2026

## Seçilen kaynak ailesi

TR ve EN meal için ana aday kaynak **QuranEnc.com / Rowad (Rowwad) Translation Center** olarak sabitlenmiştir.

### Türkçe

- Başlık: **Türkçe Tercüme - Rowad Tercüme Merkezi**
- Translation key: `turkish_rwwad`
- Kaynak sayfası: `https://quranenc.com/tr/browse/turkish_rwwad`
- Güncel katalog sürümü doğrulaması: QuranEnc Türkçe kataloğunda Rowad tercümesi yayımlanmış ve XML/CSV/Excel/SQLite/API indirme seçenekleri sunulmaktadır.
- Production import sırasında exact sürüm yeniden sorgulanacak ve manifestte pinlenecektir; katalog sürümü değişmişse eski sürüm sessizce kullanılmayacaktır.

### English

- Title: **English Translation - Rowwad Translation Center**
- Translation key: `english_rwwad`
- Source page: `https://quranenc.com/en/browse/english_rwwad`
- 12 Mart 2026 tarihli katalog kaydı V1.0.19 olarak doğrulanmıştır.
- Production import sırasında exact güncel sürüm yeniden sorgulanıp manifestte pinlenecektir.

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

## Neden Quran Foundation ana offline meal kaynağı seçilmedi?

Quran Foundation'ın 18 Ağustos 2026 tarihli Developer Terms ve güncel Connected Apps dokümantasyonu, API içeriği için ek geliştirici şartları uygular; ticari uygulamalarda bazı translation/tafsir içeriklerinin yeniden dağıtımı ayrıca yazılı içerik lisansı gerektirebilir. Bu nedenle QF, açık yazılı içerik lisansı alınmadan bundled offline ana meal kaynağı yapılmayacaktır.

## Production import için zorunlu kapılar

- TR ve EN için 114 sure / 6236 ayetin tamamı bulunmalı.
- Her satır `sura`, `ayah`, `translation`, varsa `footnotes` alanlarıyla canonical ayet kimliğine bağlanmalı.
- Duplicate veya eksik ayet bulunursa import FAIL olmalı.
- İndirilen exact payload SHA-256 ile pinlenmeli.
- Publisher, source URL, translation key, exact source version, download timestamp ve hash manifestte tutulmalı.
- Meal metnine otomatik yazım düzeltmesi, yeniden çeviri veya AI paraphrase uygulanmamalı.
- Kaynak yeni sürüm yayımladığında fark raporu olmadan sessiz replace yapılmamalı.
- TR/EN production dataset D03/D04 ancak gerçek import + hash + 6236/6236 coverage testi geçince PASS olacaktır.

## Resmi doğrulama bağlantıları

- QuranEnc Terms and Policies: `https://quranenc.com/en/home/about/terms-and-conditions`
- Turkish Rowad: `https://quranenc.com/tr/browse/turkish_rwwad`
- English Rowwad: `https://quranenc.com/en/browse/english_rwwad`
- Quran Foundation Developer Terms: `https://api-docs.quran.foundation/legal/developer-terms/`
- Quran Foundation Connected Apps: `https://api-docs.quran.foundation/docs/connected-apps/`
