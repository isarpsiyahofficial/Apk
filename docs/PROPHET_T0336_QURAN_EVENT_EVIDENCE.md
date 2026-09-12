# T0336 — Kur’an Kaynaklı Olay Sahipliği Kanıtı

Bu belge `SPECIFICATION_V1_2_DELTA.md` içindeki 25 peygamber × 8 semantik çapraz doğrulama kapısının **event ownership** boyutunda eklenen doğrudan Kur’an kanıtlarını kaydeder.

Bu kayıtlar yalnız ilgili olayın hangi peygambere ait olduğunu doğrular. **Kronoloji, coğrafya, hadis, aile/soy veya kesin tarih üretmez.** Bir ayetin olay sahipliğini kanıtlaması, diğer semantik boyutları otomatik olarak PASS yapmaz.

| Event key | Biyografi/özne | Kur’an referansı | Canonical source locator | Semantik sınır |
|---|---|---|---|---|
| `adam_tree_and_descent` | Âdem | Bakara 2:35–36 | `tanzil-uthmani-v1.1:q2:35-36` | Bahçe/ağaç uyarısı ve devamındaki iniş bağlamını Âdem’e sabitler; ağacın türü, tarih veya modern coğrafya çıkarılmaz. |
| `nuh_ark_and_flood` | Nûh | Hûd 11:36–44 | `tanzil-uthmani-v1.1:q11:36-44` | Gemi/tufan bağlamını Nûh’a sabitler; gemide kalış süresi veya kesin tarih çıkarılmaz. |
| `hud_aad_warning_and_judgment` | Hûd | Hûd 11:50–60 | `tanzil-uthmani-v1.1:q11:50-60` | Hûd’un Âd kavmine tebliğ ve hüküm bağlamını sabitler; dönem/tarih infer edilmez. |
| `salih_she_camel_trial` | Sâlih | Hûd 11:61–68 | `tanzil-uthmani-v1.1:q11:61-68` | Deve uyarısı ve devamındaki sonuç Sâlih bağlamında tutulur; modern tarih/coğrafya üretilmez. |
| `ibrahim_fire_trial` | İbrâhim | Enbiyâ 21:68–69 | `tanzil-uthmani-v1.1:q21:68-69` | Ateş olayı İbrâhim’e aittir; yer/tarih infer edilmez. |
| `lut_people_warning_and_rescue` | Lût | A‘râf 7:80–84 | `tanzil-uthmani-v1.1:q7:80-84` | Kavmine uyarı, ailesinin kurtarılması ve sonucu Lût bağlamına sabitler; modern yer/tarih bu kayıttan üretilmez. |
| `yusuf_well_and_egypt` | Yûsuf | Yûsuf 12:15 ve 12:21 | `tanzil-uthmani-v1.1:q12:15` + `tanzil-uthmani-v1.1:q12:21` | 12:15 kuyu olayını, 12:21 Mısır bağlamını sabitler; bundan dönem veya kesin tarih çıkarılmaz. |
| `ayyub_affliction_and_relief` | Eyyûb | Enbiyâ 21:83–84 | `tanzil-uthmani-v1.1:q21:83-84` | Sıkıntı duası ve giderilmesi Eyyûb’a sabitlenir; rahatsızlığın tıbbi türü/süresi veya tarih çıkarılmaz. |
| `shuayb_madyan_measure_weight` | Şuayb | A‘râf 7:85–93 | `tanzil-uthmani-v1.1:q7:85-93` | Medyen’e tebliğ ve ölçü-tartı uyarısını Şuayb’a sabitler; modern koordinat veya dönem üretmez. |
| `musa_exodus_pharaoh` | Mûsâ | Şuarâ 26:60–66 | `tanzil-uthmani-v1.1:q26:60-66` | Firavun takibi ile denizin yarılması aynı bağlamda tutulur; exact civil date infer edilmez. |
| `dawud_defeats_jalut` | Dâvûd | Bakara 2:251 | `tanzil-uthmani-v1.1:q2:251` | Câlût’un Dâvûd tarafından öldürülmesini sabitler; savaşın modern tarihi veya yeri bu kanıttan çıkarılmaz. |
| `sulayman_ant_valley` | Süleyman | Neml 27:17–19 | `tanzil-uthmani-v1.1:q27:17-19` | Ordu/karınca vadisi olayı Süleyman’a sabitlenir; vadinin modern konumu bu kanıttan çıkarılmaz. |
| `ilyas_baal_warning` | İlyâs | Sâffât 37:123–132 | `tanzil-uthmani-v1.1:q37:123-132` | İlyâs’ın kavmine Baal konusunda yaptığı uyarıyı sabitler; tefsirden exact dönem/tarih otomatik taşınmaz. |
| `yunus_fish_episode` | Yûnus | Sâffât 37:139–142 | `tanzil-uthmani-v1.1:q37:139-142` | İsimlendirilmiş Yûnus pasajı ile balık olayı birlikte tutulur; süre/coğrafya gibi ayrıntılar bu satırdan çıkarılmaz. |
| `zakariya_prayer_yahya_sign` | Zekeriyyâ | Âl-i İmrân 3:38–41 | `tanzil-uthmani-v1.1:q3:38-41` | Zekeriyyâ’nın evlat duası, Yahyâ müjdesi ve işaret bağlamını sabitler; soyun diğer ayrıntıları veya tarih türetilmez. |
| `isa_infant_speech` | Îsâ | Meryem 19:29–33 | `tanzil-uthmani-v1.1:q19:29-33` | Meryem’in işaret ettiği çocuğun konuşma bağlamını Îsâ’ya sabitler; sonraki hayat kronolojisi veya tarih üretmez. |

## Fail-closed davranışı

- Bu on altı key `ProphetSemanticOwnershipQa` içinde exclusive event ownership ile korunur.
- On altı olayın her biri başka peygamber biyografisine sahiplik verilerek taşınırsa data-driven QA FAIL verir.
- Olayın typed `subjectProphetId` alanı, `contextReference=true` verilerek bile başka peygambere çevrilirse QA FAIL verir.
- Olay key’lerinden biri `chronology`, `historicalDate`, `geography`, `hadith`, `familyLineage` veya başka boyuta yeniden etiketlenirse QA FAIL verir.
- Başka peygamberin adı doğal bağlam/cross-reference içinde geçebilir; `contextReference=true` bu kullanımı hata saydırmaz ve **coverage üretmez**.
- Kaynak sınıfı bu kayıtlar için `quran` olmak zorundadır; verified event coverage yalnız typed ownership üzerinden oluşur.

## Kaynak ve doğrulama notu

Uygulamadaki canonical Arapça Kur’an kaynağı `tanzil-uthmani-v1.1` olarak pinlenmiştir ve mevcut Quran Source Verify/release integrity kapılarıyla hash doğrulamasından geçmektedir. Bu event locator’ları aynı canonical kaynağa bağlanır. Harici insan-readable çapraz kontrolde Diyanet İşleri Başkanlığı Kur’an portalı ve Âdem 2:35–36 için ayrıca Quran.com ayet görünümü kullanılmıştır; production metni web’den kopyalanmaz.

Bu turda yeni eklenen olaylar için çapraz kontrol edilen temel ayet aralıkları: Bakara 2:35–36 (Âdem), Bakara 2:251 (Dâvûd), A‘râf 7:80–84 (Lût), A‘râf 7:85–93 (Şuayb), Enbiyâ 21:83–84 (Eyyûb), Sâffât 37:123–132 (İlyâs), Âl-i İmrân 3:38–41 (Zekeriyyâ), Meryem 19:29–33 (Îsâ). Tefsir sayfalarında dönem/coğrafya veya başka tarihsel bilgiler bulunsa bile bu event kanıtına otomatik aktarılmaz; ilgili semantik boyut kendi bağımsız source-class kanıtını gerektirir.

## Release durumu

Bu çalışma D10/D11’i **tamamlamaz**. 25 peygamber × 8 boyutun tamamı verified ve uygun source-class evidence ile kapanana kadar peygamber biyografileri final kabul edilmez. Exact historical date için kaynak yoksa `unknown`/`pendingReview` açıkça tutulur; başka boyutlardan tarih türetilmez.
