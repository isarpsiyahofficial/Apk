# T0334 — Yasak Dini Sonuç İddiası Release Kapısı

Bu kapı `SPECIFICATION.md` içindeki ürün sınırlarını ve TODO T0334'ü fail-closed uygular.

## Kapsam

Release testi aşağıdaki production dini/tarihsel veri dizinlerini otomatik tarar:

- `lib/features/dua/data`
- `lib/features/dhikr/data`
- `lib/features/religious_days/data`
- `lib/features/prophets/data`
- `lib/features/history/data`
- `lib/features/topic_search/data`
- `lib/features/today/data`

Kur'an exact-source assetleri bu serbest-metin claim taramasına dahil edilmez; onlar ayrı pinned hash/source doğrulama zincirindedir.

## Fail-closed davranış

TR/EN/AR içinde para/zenginlik, aşk/kişiyi bağlama, şifa/hastalık sonucu veya dini metni Allah'ın kullanıcıya kişisel ve kesin cevabı gibi sunan yasak kalıplardan biri production dataset dosyasında bulunursa `flutter test` kırmızı olur.

Tarama dizinlerinden biri kaybolursa test bunu sessizce atlamaz; `StateError` ile FAIL verir. Finding çıktısı dosya yolu, satır ve eşleşen fragment içerir.

## Mimari bağlantı

`DhikrOutcomeClaimPolicy` ayrı bir yasak kelime listesi taşımak yerine aynı merkezi `ForbiddenReligiousClaimAuditT0334` politikasını kullanır. Böylece zikir runtime gate ile release dataset auditinin kural seti ayrışmaz.

## Sınır

Bu otomasyon native dil ve dini içerik editoryal review'unun yerine geçmez. Regex/fragment temizliği yalnız yasak kesin-sonuç iddialarına karşı ek release katmanıdır; güvenilir kaynak, doğruluk, certainty ve lisans kapıları ayrıca geçilmelidir.
