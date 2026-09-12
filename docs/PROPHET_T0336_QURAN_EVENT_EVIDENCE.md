# T0336 — Kur’an Kaynaklı Olay Sahipliği Kanıtı

Bu belge `SPECIFICATION_V1_2_DELTA.md` içindeki 25 peygamber × 8 semantik çapraz doğrulama kapısının **event ownership** boyutunda eklenen doğrudan Kur’an kanıtlarını kaydeder.

Bu kayıtlar yalnız ilgili olayın hangi peygambere ait olduğunu doğrular. **Kronoloji, coğrafya veya kesin tarih üretmez.** Bir ayetin olay sahipliğini kanıtlaması, diğer semantik boyutları otomatik olarak PASS yapmaz.

| Event key | Biyografi/özne | Kur’an referansı | Canonical source locator | Semantik sınır |
|---|---|---|---|---|
| `nuh_ark_and_flood` | Nûh | Hûd 11:36–44 | `tanzil-uthmani-v1.1:q11:36-44` | Gemi/tufan bağlamını Nûh’a sabitler; gemide kalış süresi veya kesin tarih çıkarılmaz. |
| `hud_aad_warning_and_judgment` | Hûd | Hûd 11:50–60 | `tanzil-uthmani-v1.1:q11:50-60` | Hûd’un Âd kavmine tebliğ ve hüküm bağlamını sabitler; dönem/tarih infer edilmez. |
| `salih_she_camel_trial` | Sâlih | Hûd 11:61–68 | `tanzil-uthmani-v1.1:q11:61-68` | Deve uyarısı ve devamındaki sonuç Sâlih bağlamında tutulur; modern tarih/coğrafya üretilmez. |
| `ibrahim_fire_trial` | İbrâhim | Enbiyâ 21:68–69 | `tanzil-uthmani-v1.1:q21:68-69` | Ateş olayı İbrâhim’e aittir; yer/tarih infer edilmez. |
| `yusuf_well_and_egypt` | Yûsuf | Yûsuf 12:15 ve 12:21 | `tanzil-uthmani-v1.1:q12:15` + `tanzil-uthmani-v1.1:q12:21` | 12:15 kuyu olayını, 12:21 Mısır bağlamını sabitler; bundan dönem veya kesin tarih çıkarılmaz. |
| `musa_exodus_pharaoh` | Mûsâ | Şuarâ 26:60–66 | `tanzil-uthmani-v1.1:q26:60-66` | Firavun takibi ile denizin yarılması aynı bağlamda tutulur; exact civil date infer edilmez. |
| `sulayman_ant_valley` | Süleyman | Neml 27:17–19 | `tanzil-uthmani-v1.1:q27:17-19` | Ordu/karınca vadisi olayı Süleyman’a sabitlenir; vadinin modern konumu bu kanıttan çıkarılmaz. |
| `yunus_fish_episode` | Yûnus | Sâffât 37:139–142 | `tanzil-uthmani-v1.1:q37:139-142` | İsimlendirilmiş Yûnus pasajı ile balık olayı birlikte tutulur; süre/coğrafya gibi ayrıntılar bu satırdan çıkarılmaz. |

## Fail-closed davranışı

- Bu sekiz key `ProphetSemanticOwnershipQa` içinde exclusive event ownership ile korunur.
- Sekiz olayın her biri başka peygamber biyografisine sahiplik verilerek taşınırsa data-driven QA FAIL verir.
- Olay key’lerinden biri `chronology`, `historicalDate`, `hadith` veya başka boyuta yeniden etiketlenirse QA FAIL verir.
- Başka peygamberin adı doğal bağlam/cross-reference içinde geçebilir; `contextReference=true` bu kullanımı hata saydırmaz ve **coverage üretmez**.
- Kaynak sınıfı bu kayıtlar için `quran` olmak zorundadır; verified event coverage yalnız typed ownership üzerinden oluşur.

## Kaynak ve doğrulama notu

Uygulamadaki canonical Arapça Kur’an kaynağı `tanzil-uthmani-v1.1` olarak pinlenmiştir ve mevcut Quran Source Verify/release integrity kapılarıyla hash doğrulamasından geçmektedir. Bu event locator’ları aynı canonical kaynağa bağlanır. Harici insan-readable çapraz kontrolde Diyanet İşleri Başkanlığı Kur’an portalı kullanılmıştır; production metni web’den kopyalanmaz.

Nûh için Hûd 11:36–44, Hûd için 11:50–60, Sâlih için 11:61–68 ve Süleyman için Neml 27:17–19 bağlamları ayrıca kontrol edilmiştir. Özellikle Nûh’un gemisinin Cûdî’ye oturması Hûd 11:44’te açık olmakla birlikte tefsirde gemide kalış süresinin kesin bilinmediği de belirtilir; bu nedenle event kanıtından tarih/süre türetilmez.

## Release durumu

Bu çalışma D10/D11’i **tamamlamaz**. 25 peygamber × 8 boyutun tamamı verified ve uygun source-class evidence ile kapanana kadar peygamber biyografileri final kabul edilmez. Exact historical date için kaynak yoksa `unknown`/`pendingReview` açıkça tutulur; başka boyutlardan tarih türetilmez.