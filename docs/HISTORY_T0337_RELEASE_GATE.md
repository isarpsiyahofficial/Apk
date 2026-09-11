# T0337 — İslam Tarihi Çift Kaynak / Tartışmalı Anlatı Release Gate

Bu belge `SPECIFICATION.md` 583–584/608 ve `TODO.md` T0337 için uygulanan fail-closed QA sözleşmesini kaydeder.

## Zorunlu kurallar

1. Bir tarih olayı en az iki kaynak kimliği taşımakla yetinmez; kaynakların **iki farklı temel eser/kaynak ailesine** ait olduğu açıkça kaydedilmelidir.
2. Aynı eserin farklı baskısı, çevirisi, URL aynası, alias'ı veya yinelenmiş bibliyografya satırı ikinci bağımsız kaynak sayılmaz.
3. Registry'de açıkça eşlenmemiş bir source ID audit'i FAIL yapar. Kaynak ailesi isimden veya URL'den otomatik tahmin edilmez.
4. Bir canonical T0220 kaydı ilk üretildiğinde tek kaynak taşıyorsa, sonradan doğrulanan ikinci kaynak yalnız **exact event ID + source ID + exact locator** ile event-scoped corroboration olarak eklenebilir. Bu kanıt başka bir olaya otomatik taşınamaz ve canonical metni/tarihi sessizce değiştirmez.
5. `HistoryDateCertainty.contested` olaylar TR/EN/AR belirsizlik/tartışma açıklamasını korumalıdır. Tek mezhepsel veya tarih yazımsal yorum tartışmasız hüküm gibi yükseltilemez.
6. `unknown` tarih, release kapısını geçsin diye sentetik CE/Hicrî yıla dönüştürülemez. Bilinmeyen bilgi bilinmeyen olarak kalır.
7. T0337 yalnız tüm event-bearing canonical history track'leri work-level registry'ye bağlanıp aggregate audit geçtiğinde tamamlanmış sayılır.

## Mevcut kanıt

`HistoryT0337Audit` ortak kapısı şu failure-path'leri test eder:

- iki source ID'nin aynı temel esere ait olması,
- yalnız tek kaynak bulunması,
- registry'de bulunmayan kaynak kullanılması,
- duplicate event ID,
- event dışına taşan supplemental corroboration,
- canonical kaynağı ikinci kez saymaya çalışan corroboration,
- exact locator taşımayan corroboration,
- contested event'in ayrı olarak sayılması ve üç dil caveat sözleşmesini koruması.

Gerçek canonical bağlantılar şu yedi audit projection'ını kapsar:

- T0213/T0220 erken hilafet + İlk Fitne,
- Muhammed dönemi içinde yalnız exact claim düzeyinde iki bağımsız primary source ailesi doğrulanmış alt küme,
- T0214/T0220 medieval caliphates/regional dynasties,
- T0215/T0220 high-medieval Seljuq/Crusades/Ayyubid/Mongol/Mamluk,
- T0216/T0220 Ottoman/Safavid/Mughal,
- T0217/T0220 regional Islamic histories,
- T0218/T0220 modern/global Islamic history.

Bu hatlarda bağımsızlık source-ID sayısından değil explicit temel eser/source-family kimliğinden hesaplanır. Aynı eserin farklı bölüm veya locator kayıtları ikinci bağımsız kaynak olarak sayılamaz.

### Muhammed dönemi kaynak doğrulama ilerlemesi

Canonical siyer kaydında zaten Kur’an + Sahih al-Bukhari iki ayrı primary family taşıyan üç olay korunur: ilk vahiy, İsrâ/Mi‘rac ve Hicret/mağara.

Bu turda iki ek exact-event corroboration güvenilir bibliyografik locator ile doğrulandı:

- `history:muhammad-badr` → canonical Kur’an 3:123 + **Sahih al-Bukhari 3992**,
- `history:muhammad-pledge-under-tree` → canonical Kur’an 48:18 + **Sahih al-Bukhari 4843**.

Bu iki hadisin üçüncü taraf çeviri metni uygulamaya kopyalanmaz; T0337 yalnız bibliyografik locator ve bağımsız source-family kanıtını kullanır. Kaynakta bulunmayan tarih veya ayrıntı üretilmez.

## Aggregate coverage kapısı

`HistoryT0337CoverageReport` gerçek track audit'lerini önce çalıştırır, ardından audit edilmiş event ID birleşimini exact `historyT0220Inventory` ile karşılaştırır.

- canonical envanter dışında sentetik event coverage'a girerse FAIL,
- bir event iki track tarafından coverage'a sayılırsa FAIL,
- per-track audit event count ile gerçek canonical event projection ayrışırsa FAIL,
- canonical event audit dışı kalırsa açık `missingEventIds` olarak raporlanır,
- `requireComplete()` yalnız missing set boş olduğunda geçer.

Mevcut durumda yedi audited projection toplam **33 canonical olayı** bağımsız kaynak ailesi kapısından geçirir. Muhammed dönemi alt kümesi 3 olaydan 5 olaya çıkarılmıştır; geri kalan Muhammed dönemi olayları exact ikinci bağımsız kaynak doğrulanmadan açık kalır.

## Final durumu

T0337/D12 henüz PASS değildir. Kalan Muhammed dönemi event'leri iki bağımsız kaynak ailesi standardına kaynakları bozmayacak şekilde bağlanmalı; ardından aggregate `missingEventIds` boş olmalı ve `requireComplete()` geçmelidir. Bu gerçekleşmeden `TODO.md` T0337 ve `TEST_MATRIX.md` D12 açık kalmalıdır.
