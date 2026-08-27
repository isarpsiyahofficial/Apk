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
| D01 | 114 sure ve ayet sayıları source hash ile | TODO | gerçek Tanzil dataset importu açık |
| D02 | Arapça Kur’an exact source integrity | TODO | SHA-256 fail-closed altyapısı PASS, gerçek dataset açık |
| D03 | TR meal source/license/version | TODO | exact ticari kullanım lisansı seçilecek |
| D04 | EN meal source/license/version | TODO | exact ticari kullanım lisansı seçilecek |
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

**Altyapı PASS:** `content_governance_test.dart`, `source_manifest_test.dart`, `integrity_checked_trusted_content_store_test.dart`. Bunlar gerçek dini dataset satırlarını otomatik PASS yapmaz.

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
| B01 | `flutter gen-l10n` | PASS | Flutter CI #123, HEAD `ed5ab4a0d7aae637d8d74859805d7ffda2405903` |
| B02 | fatal analyzer | PASS | Flutter CI #123; Android Release CI #14 analyze PASS |
| B03 | `flutter test` | PASS | Flutter CI #123; Android Release CI #14 tests PASS |
| B04 | Android debug build | PASS | Android Debug CI #56 |
| B05 | Android release AAB verification build | PASS | Android Release CI #14 |
| B06 | Android release APK verification build | PASS | Android Release CI #14 |
| B07 | APK install/launch gerçek cihaz/emülatör | PASS | Android Emulator Smoke #5, HEAD `ed5ab4a0d7aae637d8d74859805d7ffda2405903`: install success + process + MainActivity + fatal-crash scan PASS |
| B08 | Final production artifact SHA-256 | TODO | verification hashes mevcut; production signing/final dataset sonrası yeniden üretilecek |
| B09 | Privacy/Terms/Sources URLs | TODO | |
| B10 | Store TR/EN/AR screenshots/copy | TODO | |

### Release-verification kanıtı

- Release APK/AAB verification CI hattı PASS durumundadır; bunlar production signing/final dataset öncesi geçici doğrulama artifactleridir.
- Release APK birleşik izin auditinde yasak hassas izin bulunmamaktadır.
- B08 yalnız production signing ve final dataset sonrası üretilen exact artifact hash ile kapatılacaktır.

### Emulator smoke kanıtı — CI #5

- Debug APK emülatöre `adb install -r` ile başarıyla kurulmuştur.
- Uygulama prosesi başlatılmış ve PID doğrulanmıştır.
- `com.example.islami_hayat/.MainActivity` gerçek ActivityManager state içinde doğrulanmıştır.
- Launch sonrası logcat fatal crash taraması temizdir.
- Önceki iki smoke hatasının uygulama crash'i değil CI harness kaynaklı olduğu loglarla ayrıştırılmıştır: `/bin/sh` pipefail uyumsuzluğu ve `am start -W` cold-start timeout beklentisi giderilmiştir.

## Final kuralı

`D`, `M`, `S`, `P` veya `B` grubundaki kritik satırlardan biri `TODO` veya `FAIL` ise ürün final değildir. Responsive ve localization testlerinde release hedefli cihaz/dil kombinasyonlarının tamamı PASS olmadan final verilmez.
