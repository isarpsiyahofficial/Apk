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

İlk gerçek canonical bağlantı, T0213/T0220 erken hilafet ve İlk Fitne datasetidir. Lapidus, Madelung ve Hinds bibliyografya kayıtları ayrı temel eser aileleri olarak açıkça tanımlanır; beş gerçek olay audit'ten geçer ve İlk Fitne contested kayıt olarak kalır.

## Final durumu

Bu belge veya ilk canonical bağlantı T0337/D12'yi tek başına PASS yapmaz. Muhammed dönemi, sonraki hilafetler, yüksek ortaçağ, erken modern, bölgesel ve modern-global event track'lerinin tamamı aynı bağımsızlık registry'sine açık biçimde bağlanmadan `TODO.md` T0337 ve `TEST_MATRIX.md` D12 açık kalmalıdır.
