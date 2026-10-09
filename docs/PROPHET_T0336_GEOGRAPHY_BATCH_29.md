# T0336 Geography Batch 29 — Sâlih ve Lût

Bu not, `prophet_biography_t0194_supplements_29.dart` içindeki iki geography claim'inin review sınırını kaydeder. Amaç modern coğrafya tahmini yapmak değil, yalnız Kur'an metninde açıkça kurulabilen biyografi-sahibi bağlamını `verified` seviyesine taşımaktır.

## Sâlih

- Canonical owner: `salih`
- T0194 source id: `tanzil-uthmani-v1.1-salih-q7-73-74-q89-9-thamud-settlement-geography`
- Canonical locator: `Quran 7:73-74; 89:9`
- İzin verilen claim: Sâlih Semûd'a gönderilmiştir; Semûd yerleşim bağlamında düzlüklerde yapılar kurup dağları oyan ve vadide kayaları işleyen topluluk olarak tasvir edilir.
- Yasak çıkarım: modern koordinat, modern devlet sınırı, kesin Hicr eşlemesi, göç rotası veya exact tarih.
- Review cross-check: Diyanet Kur'an Yolu A'râf 7:73-74 tefsiri Semûd'u Sâlih'in kavmi olarak açıklar ve Hicr/Vâdilkurâ geleneğini ayrıca tefsir bilgisi olarak ayırır; Hicr 15:80-82 tefsiri Hicr halkını Semûd ile ilişkilendirir. Production claim bu tefsir ayrıntısını Quran source class içine taşımadığı için daha dar tutulmuştur.
- Review URLs:
  - https://kuran.diyanet.gov.tr/tefsir/A%27r%C3%A2f-suresi/1027/73-74-ayet-tefsiri
  - https://kuran.diyanet.gov.tr/tefsir/Hicr-suresi/1882/80-82-ayet-tefsiri

## Lût

- Canonical owner: `lut`
- T0194 source id: `tanzil-uthmani-v1.1-lut-q21-74-q15-76-town-road-geography`
- Canonical locator: `Quran 21:74; 15:76`
- İzin verilen claim: Kur'an Lût'un kötülük işleyen bir kasabadan kurtarıldığını söyler; aynı kıssanın ardından ibret izlerinin bir yol üzerinde bulunduğunu bildirir.
- Yasak çıkarım: kasabanın özel adını ayetin lafzıymış gibi sunmak, modern koordinat, modern sınır veya exact tarih.
- Review cross-check: Diyanet Kur'an Yolu Enbiyâ 21:74-75 tefsiri kasaba bağlamını Lût'a açıkça bağlar; Hicr 15:75-77 tefsiri yol üzerindeki harabe bağlamının Lût kavmine ait olduğunu açıklar. Sodom/Ölüdeniz gibi tefsir-coğrafya ayrıntıları production Quran-source claim'ine yükseltilmemiştir.
- Review URLs:
  - https://kuran.diyanet.gov.tr/tefsir/Enbiy%C3%A2-suresi/2557/74-75-ayet-tefsiri
  - https://kuran.diyanet.gov.tr/tefsir/Hicr-suresi/1877/75-77-ayet-tefsiri

## Fail-closed QA

`prophet_biography_t0194_supplement_chain_test.dart` source id + exact locator + Quran reference zincirini doğrular. `prophet_semantic_source_bridge_t0336_test.dart` geography owner setini exact olarak pinler ve Lût kaydının Yûsuf biyografisine veya Hûd kaydının Sâlih biyografisine taşınmasını FAIL bekler. Bu batch yalnız geography boyutunu ilerletir; hadith, familyLineage veya historicalDate coverage üretmez.
