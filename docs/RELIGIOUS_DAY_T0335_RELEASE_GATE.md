# T0335 — Dini Gün Özel İbadet ve Tarih Certainty Release Gate

## Amaç

Bu kapı, dini gün/gece içeriğinin yalnız görünür veya kaynak alanı dolu olduğu için production-ready sayılmasını engeller. İki bağımsız risk fail-closed doğrulanır:

1. özel ibadet/dua iddiasının kaynak sınıfı ve kesinlik seviyesi,
2. Hicrî → Gregoryen exact tarih gösteriminin yetkili, tarihli ve pinlenmiş yayın kanıtı.

## Canonical kapsam

`ReligiousDayReleaseAuditT0335.expectedCanonicalContentIds` mevcut 10 dini gün/gece kaydını exact ID ile kilitler:

- Arefe Günü
- Berat / Şâban ortası gecesi
- Kurban Bayramı
- Ramazan Bayramı
- Kadir Gecesi
- Mevlid
- İsrâ/Mi‘rac
- Muharrem/Aşûrâ
- Ramazan
- Regaib

Yeni bir içerik dosyasının registry/audit dışında kalması release hatasıdır. Duplicate veya eksik ID de FAIL verir.

## Özel ibadet semantiği

`ReligiousDayContent.hasSafeEvidenceSemantics` ve T0335 audit birlikte şu ayrımları korur:

- Kur’an dayanağı yalnız Kur’an source-class ile,
- sahih/hasen hadis ve güçlü rivayet yalnız güçlü hadis source-class ile,
- tartışmalı rivayet yalnız `disputed` certainty + disputed source-class ile,
- gelenek yalnız classical/later-tradition sınıfıyla,
- özel ibadet ancak kendi `SpecificWorshipStatus` sözleşmesine uygun kaynak sınıfıyla,
- genel ibadet yalnız Kur’an veya sahih/hasen hadis dayanağıyla.

`noSpecificPracticeEstablished` olan bir kayda gizlice özel dua/namaz/sayı eklenmesi testte FAIL verir.

## Source-closure kapısı

Her evidence-section kaynağı aynı kaydın governed `record.sources` manifestinde de bulunmak zorundadır. Böylece bir evidence bölümü içine sonradan eklenen fakat ana provenance manifestine işlenmeyen kaynak sessizce production QA’dan geçemez.

Ayrıca record-level source ID tekrarı, boş source ID/title/license/locator veya `unknown` source-class FAIL verir.

Bu kontrol özellikle “kanıt metni doğru görünüyor fakat governed source manifest eski kaldı” sınıfındaki provenance drift hatasını engeller.

## Exact tarih politikası

V1 canonical religious-date observation listesi, doğrulanmamış gelecek Gregoryen tarih uydurmamak için boş tutulur. Exact tarih ancak:

- canonical dini gün ID’sine bağlıysa,
- yetkili/local authority metadata’sı varsa,
- status `confirmed` ise,
- tarihli resmî yayına `sourcePublicationLocator` ve `sourcePublicationUrl` ile pinlenmişse

gösterilebilir.

`provisional`, generic homepage’e dayanan, publication locator/URL’si eksik veya bilinmeyen dini güne bağlı exact tarih release FAIL’dir.

## Test kanıtı

`test/features/religious_days/religious_day_release_audit_t0335_test.dart` en az şu failure-pathleri kapsar:

- canonical registry omission,
- duplicate content ID,
- araştırma kaydına gizli özel ibadet claim’i eklenmesi,
- evidence kaynağının governed record manifestinden kopması,
- provisional/unpinned exact tarih,
- unknown religious-day ID’ye exact tarih bağlanması,
- confirmed + pinlenmiş authority publication pozitif kontrolü.

## Final/PASS sınırı

Bu gate’in çalışması T0335 QA altyapısının kanıtıdır; **TEST_MATRIX D09 otomatik PASS değildir**. Canonical kayıtlar hâlen religious/editorial ve native TR/EN/AR review gerektiriyorsa research durumunda tutulur. Review kanıtı oluşmadan yalnız bu auditin yeşil olması production yayın onayı sayılmaz.
