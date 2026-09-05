# İSLAMİ HAYAT — TEST MATRIX

Bu matris `SPECIFICATION.md` + `SPECIFICATION_V1_2_DELTA.md` + `TODO.md` ile birlikte final kapısıdır. `PASS` kanıtı olmayan kritik satır finalde açık kabul edilir.

## Durum anahtarı

- `TODO` — henüz tam doğrulanmadı
- `PASS` — kanıtlı geçti
- `FAIL` — kırmızı açık
- `N/A` — yalnız gerçekten kapsam dışıysa ve gerekçesi varsa

## A. Responsive / cihaz matrisi

| ID | Görünüm | Durum | Kanıt |
|---|---|---|---|
| R01 | Dar telefon 320–360 px | PASS | `app_shell_responsive_test.dart` |
| R02 | Modern telefon 390×844 | PASS | responsive widget test |
| R03 | Büyük telefon 430×932 | PASS | compact shell + overflow kontrolü |
| R04 | Küçük tablet/fold 600–839 | PASS | 599/600/839 sınır testleri |
| R05 | Tablet >=840 | PASS | 840 + 1024 rail testleri |
| R06 | 4:3 tablet | PASS | 1024×768 |
| R07 | BlueStacks/desktop 1280×720 | PASS | 16:9 rail + overflow kontrolü |
| R08 | BlueStacks wide 1920×1080 | PASS | bounded wide shell |
| R09 | 16:10 landscape 1280×800 | PASS | rail testi |
| R10 | Büyük font 1.6× | PASS | 360×800, overflow yok |
| R11 | Orientation change | PASS | 430×932 -> 932×430, nav -> rail |
| R12 | Keyboard inset | PASS | 390×844 + 320px viewInset |

**Kural:** `<840px` bottom navigation; `>=840px` navigation rail/adaptif geniş ekran. Kesilmiş dini metin veya overflow FAIL.

## B. Dil / RTL matrisi

| ID | Senaryo | Durum | Kanıt |
|---|---|---|---|
| L01 | TR tam UI crawl | TODO | |
| L02 | EN tam UI crawl | TODO | |
| L03 | AR tam UI crawl | TODO | |
| L04 | TR içinde EN/AR sızıntı | TODO | |
| L05 | EN içinde TR/AR sızıntı | TODO | |
| L06 | AR içinde TR/EN sızıntı | TODO | |
| L07 | AR RTL navigation/icon yönü | PASS | AR phone + tablet Directionality.rtl testleri |
| L08 | AR share card line break | TODO | |
| L09 | TR/EN modunda Arapça asıl yalnız explicit tercih | TODO | |
| L10 | Error/loading/empty/paywall/ad/billing üç dil | TODO | integrity error TR/AR yüzeyi PASS; diğer yüzeyler açık |

## C. Dini içerik doğruluğu

| ID | Alan | Durum | Kanıt / açık iş |
|---|---|---|---|
| D01 | 114 sure ve ayet sayıları source hash ile | PASS | Tanzil Uthmani v1.1 exact source: 114 sure / 6236 ayet; `Quran Source Verify` SUCCESS; runtime `canonical_quran_source_test.dart` bağımsız sure-ayet sırasını doğruluyor |
| D02 | Arapça Kur’an exact source integrity | PASS | pinned exact-byte SHA-256 `bf4f57b968d03f4131c070b1e285da9be0e0a108a21c910e872801ca273312c8`; 1,370,878 byte; attribution footer dahil; `prepare_quran_asset.py` + release packaging + runtime fail-closed hash testi PASS |
| D03 | TR meal source/license/version | PASS | QuranEnc `turkish_rwwad` Rowad; V1.0.4; 114 sure / 6236 ayet; canonical SHA-256 `a0c001b1e690cc022351d55b9951a7410fde4a6266638766c553fa91f401b1b7`; `QuranEnc Meal Verify` SUCCESS; 114 ayrı source-response hash |
| D04 | EN meal source/license/version | PASS | QuranEnc `english_rwwad` Rowwad; V1.0.19; 114 sure / 6236 ayet; canonical SHA-256 `24c81ccfa5818e417b96f3b457955d34308a95d006a65c894ac69eaba580a3c0`; `QuranEnc Meal Verify` SUCCESS; 114 ayrı source-response hash |
| D05 | Dua source/status/authenticity | TODO | |
| D06 | Genel dua yanlışlıkla hadis/ayet değil | TODO | |
| D07 | Zikir sayıları source-backed vs kişisel | TODO | |
| D08 | Ebced/havas sünnet gibi gösterilmiyor | TODO | |
| D09 | Dini gün özel ibadet/dua iddiaları | TODO | |
| D10 | Peygamber biyografileri source/certainty | TODO | |
| D11 | Peygamber timeline çelişki taraması | TODO | |
| D12 | İslam tarihi iki kaynak/certainty | TODO | |
| D13 | Yasak kesin para/aşk/şifa iddiası sıfır | TODO | |
| D14 | Yazım/imla native TR/EN/AR review | TODO | |

**Kur’an canonical kaynak kanıtı:** `assets/quran/source/quran-uthmani.manifest.json` Tanzil Project Uthmani v1.1 kaynağını, CC BY 3.0 lisansını, exact byte/hash kapsamını ve 114/6236 yapısını pinler. `Quran Source Verify`, `Android Release CI` ve `CanonicalQuranDataset` aynı sözleşmeyi birbirinden bağımsız katmanlarda doğrular. Kaynak byte değişirse build/runtime fail-closed olur.

**Meal canonical kaynak kanıtı:** `scripts/fetch_quranenc_meals.py` resmi QuranEnc API metadata + 114 sura endpointini canlı doğrular; her raw response parse öncesi SHA-256 ile kaydedilir. Translation/footnotes değerleri değiştirilmez. `docs/MEAL_SOURCE_DECISION.md` exact sürüm, hash ve yeniden yayın koşullarını pinler.

**Altyapı PASS:** `content_governance_test.dart`, `source_manifest_test.dart`, `integrity_checked_trusted_content_store_test.dart`. Bunlar diğer gerçek dini dataset satırlarını otomatik PASS yapmaz.

## D. FREE / PRO / reklam / billing

| ID | Senaryo | Durum |
|---|---|---|
| M01 | FREE online kullanım | TODO |
| M02 | FREE cold-start offline block | TODO |
| M03 | FREE online -> bağlantıyı kes -> gate | TODO |
| M04 | PRO online | TODO |
| M05 | PRO offline core erişim | TODO |
| M06 | PRO zero ad UI | TODO |
| M07 | PRO zero ad network request | TODO |
| M08 | FREE reklam kutsal metni bölmüyor | TODO |
| M09 | Rewarded success | TODO |
| M10 | Rewarded cancel | TODO |
| M11 | Rewarded fail/no-fill | TODO |
| M12 | Reward yalnız tamamlanınca | TODO |
| M13 | Purchase success | TODO |
| M14 | Purchase cancel | TODO |
| M15 | Purchase pending | TODO |
| M16 | Restore | TODO |
| M17 | Reinstall restore | TODO |
| M18 | Offline cached entitlement | TODO |
| M19 | Refund/revoke online refresh | TODO |
| M20 | PRO geçişinde loaded ad dispose | TODO |

## E. 100 Canva görsel / paylaşım

| ID | Senaryo | Durum |
|---|---|---|
| S01 | Final 100 asset lisans manifest | TODO |
| S02 | AI-generated final asset = 0 | TODO |
| S03 | Lisansı yetersiz Pro reusable asset = 0 | TODO |
| S04 | Story 9:16 export | TODO |
| S05 | WhatsApp Status 9:16 export | TODO |
| S06 | Post 4:5 export | TODO |
| S07 | Kare 1:1 export | TODO |
| S08 | Uzun ayet multi-card/fit, truncation yok | TODO |
| S09 | Ayet kaynak satırı kilitli | TODO |
| S10 | Genel Dua etiketi korunuyor | TODO |
| S11 | AR RTL export | TODO |
| S12 | TR export | TODO |
| S13 | EN export | TODO |
| S14 | 100 asset × 4 format crop/readability | TODO |
| S15 | FREE/Rewarded/PRO access matrix | TODO |
| S16 | PRO tüm final tasarımlarda reklamsız | TODO |

**Altyapı PASS:** `VisualAssetManifestEntry.canBeFinalReusableBackground` ve `source_manifest_test.dart` lisans/redistribution/export hakkı olmayan, Canva-AI veya Pro reusable adayları finalden engeller. 100 gerçek asset doğrulanmadan S01–S03 PASS değildir.

## F. Gizlilik / güvenlik

| ID | Senaryo | Durum | Kanıt |
|---|---|---|---|
| P01 | Ham dini soru network çıkışı = 0 | TODO | network özelliği tamamlanınca packet audit |
| P02 | Ham soru ad payload = 0 | TODO | reklam entegrasyonu sonrası |
| P03 | Ham soru analytics/crash log = 0 | TODO | |
| P04 | Yerel hassas veri encryption | PASS | `SecurePrivateUserStore` + secure-storage testleri; Android build PASS |
| P05 | Auto Backup hassas veri kontrolü | PASS | `allowBackup=false`; backup/data-extraction root/file/database/sharedpref/external exclude; Android Debug CI source audit PASS |
| P06 | Clipboard/share note leak = 0 | TODO | |
| P07 | Release debug log = 0 | TODO | release log audit ayrı yapılacak |
| P08 | Location permission = 0 | PASS | Android Debug + Release CI final APK permission audit |
| P09 | Microphone permission = 0 | PASS | aynı final APK audit |
| P10 | Camera permission = 0 | PASS | aynı final APK audit |
| P11 | Contacts/accounts permission = 0 | PASS | aynı final APK audit |

## G. CI / build / release

| ID | Senaryo | Durum | Kanıt |
|---|---|---|---|
| B01 | `flutter gen-l10n` | PASS | current branch CI |
| B02 | fatal analyzer | PASS | current branch Flutter + Android Release CI |
| B03 | `flutter test` | PASS | current branch Flutter + Android Release CI |
| B04 | Android debug build | PASS | current branch Android Debug CI |
| B05 | Android release AAB verification build | PASS | current branch Android Release CI |
| B06 | Android release APK verification build | PASS | current branch Android Release CI |
| B07 | APK install/launch gerçek cihaz/emülatör | PASS | current branch Android Emulator Smoke: install + process + MainActivity + fatal-crash scan PASS |
| B08 | Final production artifact SHA-256 | TODO | verification hashes mevcut; production signing/final dataset sonrası yeniden üretilecek |
| B09 | Privacy/Terms/Sources URLs | TODO | |
| B10 | Store TR/EN/AR screenshots/copy | TODO | |

### Release-verification kanıtı

- Current implementation HEAD öncesindeki canonical Quran entegrasyonunda Flutter CI, Quran Source Verify, Android Debug CI, Android Release CI ve Android Emulator Smoke birlikte SUCCESS durumundadır.
- Release APK/AAB verification CI hattı production signing öncesi doğrulama artifactleri üretmektedir.
- Release APK birleşik izin auditinde yasak hassas izin bulunmamaktadır.
- Canonical Tanzil kaynağının APK içine source + manifest olarak paketlendiği release CI tarafından `unzip -l` ile doğrulanmaktadır.
- B08 yalnız production signing ve final dataset sonrası üretilen exact artifact hash ile kapatılacaktır.

## Final kuralı

`D`, `M`, `S`, `P` veya `B` grubundaki kritik satırlardan biri `TODO` veya `FAIL` ise ürün final değildir. Responsive ve localization testlerinde release hedefli cihaz/dil kombinasyonlarının tamamı PASS olmadan final verilmez.
