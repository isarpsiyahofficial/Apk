# T0337 — İslam Tarihi Çift Kaynak / Tartışmalı Anlatı Release Gate

Bu belge `SPECIFICATION.md` 583–584/608 ve `TODO.md` T0337 için uygulanan fail-closed QA sözleşmesini kaydeder.

## Zorunlu kurallar

1. Bir tarih olayı en az iki kaynak kimliği taşımakla yetinmez; kaynakların **iki farklı temel eser/kaynak ailesine** ait olduğu açıkça kaydedilmelidir.
2. Aynı eserin farklı baskısı, çevirisi, URL aynası, alias'ı veya yinelenmiş bibliyografya satırı ikinci bağımsız kaynak sayılmaz.
3. Registry'de açıkça eşlenmemiş bir source ID audit'i FAIL yapar. Kaynak ailesi isimden veya URL'den otomatik tahmin edilmez.
4. `HistoryDateCertainty.contested` olaylar TR/EN/AR belirsizlik/tartışma açıklamasını korumalıdır. Tek mezhepsel veya tarih yazımsal yorum tartışmasız hüküm gibi yükseltilemez.
5. `unknown` tarih, release kapısını geçsin diye sentetik CE/Hicrî yıla dönüştürülemez. Bilinmeyen bilgi bilinmeyen olarak kalır.
6. T0337 yalnız tüm event-bearing canonical history track'leri work-level registry'ye bağlanıp aggregate audit geçtiğinde tamamlanmış sayılır.

## Mevcut kanıt

`HistoryT0337Audit` ortak kapısı şu failure-path'leri test eder:

- iki source ID'nin aynı temel esere ait olması,
- yalnız tek kaynak bulunması,
- registry'de bulunmayan kaynak kullanılması,
- duplicate event ID,
- contested event'in ayrı olarak sayılması ve üç dil caveat sözleşmesini koruması.

Gerçek canonical bağlantılar artık şu altı tarih hattını kapsar:

- T0213/T0220 erken hilafet + İlk Fitne,
- T0214/T0220 medieval caliphates/regional dynasties,
- T0215/T0220 high-medieval Seljuq/Crusades/Ayyubid/Mongol/Mamluk,
- T0216/T0220 Ottoman/Safavid/Mughal,
- T0217/T0220 regional Islamic histories,
- T0218/T0220 modern/global Islamic history.

Bu hatlarda bağımsızlık source-ID sayısından değil explicit temel eser/work-family kimliğinden hesaplanır. Aynı eserin farklı bölüm veya locator kayıtları ikinci bağımsız kaynak olarak sayılamaz.

## Aggregate coverage kapısı

`HistoryT0337CoverageReport` altı gerçek track audit'ini önce çalıştırır, ardından audit edilmiş event ID birleşimini exact `historyT0220Inventory` ile karşılaştırır.

- canonical envanter dışında sentetik event coverage'a girerse FAIL,
- bir event iki track tarafından coverage'a sayılırsa FAIL,
- per-track audit event count ile gerçek canonical event projection ayrışırsa FAIL,
- canonical event audit dışı kalırsa açık `missingEventIds` olarak raporlanır,
- `requireComplete()` yalnız missing set boş olduğunda geçer.

Mevcut canonical durumda altı audited track toplam **28 olayı** work-family bağımsızlık kapısından geçirir. Aggregate test, geri kalan canonical açığın tam olarak `muhammadPeriodEventsT0220` olayları olduğunu doğrular. Bu olaylar yalnız kapıyı yeşile çevirmek için yapay ikinci akademik kaynakla veya kaynakta bulunmayan takvim tarihiyle zenginleştirilmeyecektir.

## Final durumu

T0337/D12 henüz PASS değildir. Muhammed dönemi event track'i iki bağımsız kaynak ailesi standardına kaynakları bozmayacak şekilde bağlanmalı; ardından aggregate `missingEventIds` boş olmalı ve `requireComplete()` geçmelidir. Bu gerçekleşmeden `TODO.md` T0337 ve `TEST_MATRIX.md` D12 açık kalmalıdır.
