# T0358 — Lifetime PRO billing / restore QA matrix

Bu belge `SPECIFICATION.md`, `SPECIFICATION_V1_2_DELTA.md`, `TODO.md` T0358 ve `TEST_MATRIX.md` M13–M19 için kanıt haritasıdır. Amaç mevcut domain testlerini gerçek Google Play sandbox/device kanıtıyla karıştırmadan hangi davranışın nerede doğrulandığını sabitlemektir.

## Canonical ürün

- Android V1 Lifetime PRO product ID: `islami_hayat_lifetime_pro`.
- Aylık/yıllık abonelik veya başka SKU Lifetime PRO entitlement üretemez.
- Purchase/restore yalnız doğrulanmış canonical ownership evidence ile PRO üretebilir.

## Otomatik davranış kanıtları

| Matrix | Davranış | Otomatik kanıt | Durum |
|---|---|---|---|
| M13 | Purchase success | `play_purchase_state_t0275_test.dart` — PURCHASED yalnız exact verification evidence sonrasında `verifiedOnline` PRO olur | Otomatik davranış kanıtı var |
| M14 | Purchase cancel | `play_purchase_state_t0275_test.dart` — cancelled state PRO vermez; mevcut verified PRO'yu da yanlış downgrade etmez | Otomatik failure-path kanıtı var |
| M15 | Purchase pending | `play_purchase_state_t0275_test.dart` — pending state PRO vermez; evidence smuggling reddedilir | Otomatik failure-path kanıtı var |
| M16 | Restore | `play_restore_purchases_t0276_test.dart` — canonical ownership + matching verification olmadan PRO yok; empty/unrelated/query-failure fail-closed | Otomatik davranış/failure-path kanıtı var |
| M17 | Reinstall restore | `play_reinstall_restore_t0358_test.dart` — fresh install cache yokken FREE başlar; yalnız verified Play ownership restore PRO verir; unrelated ownership FREE kalır | Otomatik fresh-install davranış kanıtı var |
| M18 | Offline cached entitlement | `secure_entitlement_cache_t0277_test.dart` — yalnız online-verified PRO secure cache'e yazılabilir; corrupt/wrong-product/unverified/read-failure FREE fail-closed | Otomatik davranış/failure-path kanıtı var |
| M19 | Refund/revoke online refresh | `play_ownership_refresh_t0278_test.dart` — verified revoke/refund veya no-ownership PRO'yu düşürür ve cache'i temizler; wrong-SKU/missing evidence/transient failure sahte revoke yapamaz | Otomatik davranış/failure-path kanıtı var |

## Final PASS için hâlâ gerekli kanıt

Bu otomatik testler T0358'in state-machine/cache güvenliğini kanıtlar; fakat Faz 21 "gerçek cihaz QA" kapısını tek başına kapatmaz. T0358 ve M13–M19 final PASS verilmeden önce Google Play test ortamında en az aşağıdaki gerçek entegrasyon kanıtı tutulmalıdır:

1. Lisanslı test hesabıyla canonical one-time product purchase SUCCESS.
2. Kullanıcı CANCEL akışı.
3. Play tarafından PENDING transaction akışı mümkün test senaryosunda doğrulama; pending iken PRO açılmamalı.
4. Restore purchases ile mevcut sahipliğin geri gelmesi.
5. Uygulama kaldırılıp yeniden kurulduktan sonra yerel cache olmadan Play ownership ile restore.
6. Online doğrulama sonrası internet kapatıldığında secure cached entitlement ile PRO başlangıcı.
7. Refund/revoke test ownership değişikliği sonrası online refresh ile PRO'nun kaldırılması ve offline cache'in temizlenmesi.
8. Unknown/wrong SKU'nun hiçbir adımda Lifetime PRO üretmemesi.

## Fail-closed kuralı

Play query/verification geçici olarak başarısızsa mevcut doğrulanmış kullanıcı sahipliği uydurma biçimde revoke veya grant edilmez. Yeni FREE kullanıcıya PRO verilmez; mevcut cached PRO ise yalnız authoritative verified revoke/no-ownership evidence ile kaldırılır.

## Release notu

Bu belge nedeniyle `TEST_MATRIX.md` M13–M19 otomatik olarak PASS sayılmaz. Gerçek Google Play sandbox/device kanıtı gelene kadar bu satırların release statüsü TODO kalabilir; otomatik testler final entegrasyon öncesi regresyon kapısıdır.
