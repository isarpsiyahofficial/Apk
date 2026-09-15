# T0200 — Peygamber tarihsel/ihtiyat kapısı

Bu belge `SPECIFICATION.md` 878–882 için uygulanan fail-closed davranışı özetler. Amaç kesin olmayan tarihsel ayrıntıyı dinî kesinlik seviyesine yükseltmemektir.

## Kapsam

- **Hz. Nuh:** Kur’an/Sahih-Hasen katmanı ile İsrailiyat/sonraki gelenek ayrıdır. Kur’an/hadis katmanı `explicitSource` veya `stronglyAttested`; sonraki gelenek yalnız `traditional` veya `disputed` olabilir. Katman/source-class takası reddedilir.
- **Hz. Musa / Firavun:** Belirli bir tarihsel Firavun adı ancak `modernHistoryArchaeology` katmanında ve `disputed`/`approximate` certainty ile hipotez olarak tutulabilir. Tek isim kesinleştirilemez.
- **Hz. İbrahim:** Güvenilir biçimde bilinmeyen kesin miladî doğum yılı üretilemez. `exactGregorianYear` içeren assertion reddedilir.
- **Hz. Âdem:** Modern bilimsel/tarihsel tarihleme dinî kronolojiye çevrilemez; exact Gregorian year reddedilir ve modern araştırma yalnız kendi katmanında kalır.
- **Hz. İsa:** Kur’an/Sahih-Hasen inanç anlatısı `islamicRevelation`, modern Roma dönemi araştırması `modernHistoricalResearch` katmanında tutulur. Katmanlar birbirine geçirilemez.

## Failure-path kanıtı

`test/features/prophets/prophet_caution_t0200_failure_paths_test.dart` şu saldırıları reddeder:

1. Nuh sonraki-rivayet ayrıntısını revelation certainty seviyesine yükseltme.
2. Kur’an-explicit Nuh bilgisini `disputed` gibi yanlış certainty ile etiketleme.
3. Musa için tarihsel Firavun hipotezini `stronglyAttested/explicit` kesinliğe yükseltme veya Kur’an katmanına taşıma.
4. İbrahim için tek exact Gregorian yıl sentezleme.
5. Âdem için modern tarihlemeden exact dinî kronoloji üretme veya modern claim'i revelation katmanına taşıma.
6. İsa için Kur’an claim'ini modern tarih; modern tarih claim'ini revelation katmanı gibi işaretleme.
7. `meaningBasedDua` gibi peygamber tarih provenance'ı olmayan source-class enjeksiyonu.

`ProphetCautionPolicy.requireAllowed` başarısız kayıtta `StateError` üreterek production kullanımında fail-closed davranır.

## Tamamlama kuralı

T0200 ancak bu testler Flutter CI ve Android Release full test hatlarında yeşil olduğunda tamamlandı sayılır. Bu kapı, T0194/D10-D11 kaynak ve timeline QA'sını gevşetmez; onların üzerine ek özel ihtiyat katmanıdır.
