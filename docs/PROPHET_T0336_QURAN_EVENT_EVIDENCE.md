# T0336 — Kur’an Kaynaklı Olay Sahipliği Kanıtı

Bu belge `SPECIFICATION_V1_2_DELTA.md` içindeki 25 peygamber × 8 semantik çapraz doğrulama kapısının **event ownership** boyutunda eklenen doğrudan Kur’an kanıtlarını kaydeder.

Bu kayıtlar yalnız ilgili olayın hangi peygambere ait olduğunu doğrular. **Kronoloji, coğrafya veya kesin tarih üretmez.** Bir ayetin olay sahipliğini kanıtlaması, diğer semantik boyutları otomatik olarak PASS yapmaz.

| Event key | Biyografi/özne | Kur’an referansı | Canonical source locator | Semantik sınır |
|---|---|---|---|---|
| `yusuf_well_and_egypt` | Yûsuf | Yûsuf 12:15 ve 12:21 | `tanzil-uthmani-v1.1:q12:15` + `tanzil-uthmani-v1.1:q12:21` | 12:15 kuyu olayını, 12:21 Mısır bağlamını sabitler; bundan dönem veya kesin tarih çıkarılmaz. |
| `ibrahim_fire_trial` | İbrâhim | Enbiyâ 21:68–69 | `tanzil-uthmani-v1.1:q21:68-69` | Ateş olayı İbrâhim’e aittir; yer/tarih infer edilmez. |
| `musa_exodus_pharaoh` | Mûsâ | Şuarâ 26:60–66 | `tanzil-uthmani-v1.1:q26:60-66` | Firavun takibi ile denizin yarılması aynı bağlamda tutulur; exact civil date infer edilmez. |
| `yunus_fish_episode` | Yûnus | Sâffât 37:139–142 | `tanzil-uthmani-v1.1:q37:139-142` | İsimlendirilmiş Yûnus pasajı ile balık olayı birlikte tutulur; süre/coğrafya gibi ayrıntılar bu satırdan çıkarılmaz. |

## Fail-closed davranışı

- Bu dört key `ProphetSemanticOwnershipQa` içinde exclusive event ownership ile korunur.
- Olay başka peygamber biyografisine sahiplik verilerek taşınırsa QA FAIL verir.
- Olay key’i `chronology`, `historicalDate`, `hadith` veya başka boyuta yeniden etiketlenirse QA FAIL verir.
- Başka peygamberin adı doğal bağlam/cross-reference içinde geçebilir; ancak bunun için `contextReference=true` gerekir ve bu kullanım coverage üretmez.
- Kaynak sınıfı bu kayıtlar için `quran` olmak zorundadır; verified event coverage yalnız typed ownership üzerinden oluşur.

## Kaynak ve doğrulama notu

Uygulamadaki canonical Arapça Kur’an kaynağı `tanzil-uthmani-v1.1` olarak pinlenmiştir ve mevcut Quran Source Verify/release integrity kapılarıyla hash doğrulamasından geçmektedir. Bu event locator’ları aynı canonical kaynağa bağlanır. Harici web kontrolü yalnız insan-readable cross-check olarak kullanılmıştır; production metni web’den kopyalanmaz.

## Release durumu

Bu çalışma D10/D11’i **tamamlamaz**. 25 peygamber × 8 boyutun tamamı verified ve uygun source-class evidence ile kapanana kadar peygamber biyografileri final kabul edilmez. Exact historical date için kaynak yoksa `unknown`/`pendingReview` açıkça tutulur; başka boyutlardan tarih türetilmez.
