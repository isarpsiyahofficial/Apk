# İSLAMİ HAYAT — TEST MATRIX

Bu matris `SPECIFICATION.md` + `SPECIFICATION_V1_2_DELTA.md` + `TODO.md` ile birlikte final kapısıdır. `PASS` kanıtı olmayan kritik satır finalde açık kabul edilir.

## Durum anahtarı

- `TODO` — henüz test edilmedi
- `PASS` — kanıtlı geçti
- `FAIL` — kırmızı açık
- `N/A` — yalnız şartname gereği gerçekten kapsam dışıysa, gerekçesiyle

## A. Responsive / cihaz matrisi

| ID | Görünüm | Hedef | Durum | Kanıt |
|---|---|---|---|---|
| R01 | Dar telefon | 320×568 / 360×640 | PASS | `app_shell_responsive_test.dart`: 320×640, overflow yok, bottom navigation |
| R02 | Modern telefon | 390×844 | PASS | `app_shell_responsive_test.dart`: 390×844, bottom navigation |
| R03 | Büyük telefon | 430×932 | TODO | |
| R04 | Küçük tablet/fold geniş | 600–839 px | PASS | 599/600 ve 839 breakpoint sınır testleri; rail yok |
| R05 | Tablet portrait | 840–1199 px | PASS | 840 sınır testi + 1024 px tablet rail testi |
| R06 | 4:3 tablet | 1024×1366 benzeri | PASS | 1024×768 4:3 landscape shell testi, overflow yok |
| R07 | BlueStacks/desktop window | 1280×720 | TODO | |
| R08 | BlueStacks wide | 1920×1080 | PASS | 1920×1080 rail + overflow kontrolü |
| R09 | 16:10 landscape | 1280×800 | PASS | 1280×800 rail + overflow kontrolü |
| R10 | Büyük font scale | 1.3–2.0 | PASS | 360×800, text scale 1.6, shell overflow yok |
| R11 | Orientation change | portrait ↔ landscape | TODO | |
| R12 | Keyboard inset | text input ekranları | TODO | |

**Beklenti:** `<840px` alt navigation; `>=840px` rail/adaptif geniş ekran. Overflow, kesilmiş dini metin, kontrolsüz satır genişliği veya navigation çakışması FAIL.

## B. Dil / RTL matrisi

| ID | Senaryo | Durum | Kanıt |
|---|---|---|---|
| L01 | TR tam UI crawl | TODO | |
| L02 | EN tam UI crawl | TODO | |
| L03 | AR tam UI crawl | TODO | |
| L04 | TR içinde EN/AR sızıntı | TODO | |
| L05 | EN içinde TR/AR sızıntı | TODO | |
| L06 | AR içinde TR/EN sızıntı | TODO | |
| L07 | AR RTL navigation/icon mirroring | PASS | `app_shell_responsive_test.dart`: AR phone + tablet Directionality.rtl, nav/rail render |
| L08 | AR share card line break | TODO | |
| L09 | TR/EN modunda Arapça asıl yalnız explicit tercih ile | TODO | |
| L10 | Error/loading/empty/paywall/ad/billing metinleri üç dil | TODO | |

## C. Dini içerik doğruluk matrisi

| ID | Alan | Durum | Kanıt |
|---|---|---|---|
| D01 | 114 sure ve ayet sayıları source hash ile | TODO | |
| D02 | Arapça Kur’an exact source integrity | TODO | |
| D03 | TR meal source/license/version | TODO | |
| D04 | EN meal source/license/version | TODO | |
| D05 | Dua source/status/authenticity | TODO | |
| D06 | Genel dua yanlışlıkla hadis/ayet değil | TODO | |
| D07 | Zikir sayıları source-backed vs kişisel | TODO | |
| D08 | Ebced/havas sünnet gibi gösterilmiyor | TODO | |
| D09 | Dini gün özel ibadet/dua iddiaları | TODO | |
| D10 | Peygamber biyografileri source/certainty | TODO | |
| D11 | Peygamber timeline çelişki taraması | TODO | |
| D12 | İslam tarihi iki kaynak/certainty | TODO | |
| D13 | Yasak kesin para/aşk/şifa iddiaları sıfır | TODO | |
| D14 | Yazım/imla native TR/EN/AR review | TODO | |

## D. FREE / PRO / reklam / billing

| ID | Senaryo | Durum | Kanıt |
|---|---|---|---|
| M01 | FREE online kullanım | TODO | |
| M02 | FREE cold-start offline block | TODO | |
| M03 | FREE online → bağlantıyı kes → gate | TODO | |
| M04 | PRO online | TODO | |
| M05 | PRO offline core erişim | TODO | |
| M06 | PRO zero ad UI | TODO | |
| M07 | PRO zero ad network request | TODO | |
| M08 | FREE ad yerleşimi kutsal metni bölmüyor | TODO | |
| M09 | Rewarded success | TODO | |
| M10 | Rewarded cancel | TODO | |
| M11 | Rewarded fail/no-fill | TODO | |
| M12 | Reward yalnız tamamlanınca | TODO | |
| M13 | Purchase success | TODO | |
| M14 | Purchase cancel | TODO | |
| M15 | Purchase pending | TODO | |
| M16 | Restore | TODO | |
| M17 | Reinstall restore | TODO | |
| M18 | Offline cached entitlement | TODO | |
| M19 | Refund/revoke online refresh | TODO | |
| M20 | PRO geçişinde loaded ad dispose | TODO | |

## E. 100 Canva görsel / paylaşım

| ID | Senaryo | Durum | Kanıt |
|---|---|---|---|
| S01 | Final 100 asset lisans manifest | TODO | |
| S02 | AI-generated final asset = 0 | TODO | |
| S03 | Lisansı yetersiz Pro reusable asset = 0 | TODO | |
| S04 | Story 9:16 export | TODO | |
| S05 | WhatsApp Status 9:16 export | TODO | |
| S06 | Post 4:5 export | TODO | |
| S07 | Kare 1:1 export | TODO | |
| S08 | Uzun ayet multi-card/fit, truncation yok | TODO | |
| S09 | Ayet kaynak satırı kilitli | TODO | |
| S10 | Genel Dua etiketi korunuyor | TODO | |
| S11 | AR RTL export | TODO | |
| S12 | TR export | TODO | |
| S13 | EN export | TODO | |
| S14 | 100 asset × 4 format crop/readability | TODO | |
| S15 | FREE/Rewarded/PRO access matrix | TODO | |
| S16 | PRO tüm final tasarımlarda reklamsız | TODO | |

## F. Gizlilik / güvenlik

| ID | Senaryo | Durum | Kanıt |
|---|---|---|---|
| P01 | Ham dini soru network çıkışı = 0 | TODO | |
| P02 | Ham soru ad payload = 0 | TODO | |
| P03 | Ham soru analytics/crash log = 0 | TODO | |
| P04 | Yerel hassas veri encryption | TODO | |
| P05 | Auto Backup hassas veri kontrolü | TODO | |
| P06 | Clipboard/share note leak = 0 | TODO | |
| P07 | Release debug log = 0 | TODO | |
| P08 | Location permission = 0 | TODO | |
| P09 | Microphone permission = 0 | TODO | |
| P10 | Camera permission = 0 | TODO | |
| P11 | Contacts permission = 0 | TODO | |

## G. CI / build / release

| ID | Senaryo | Durum | Kanıt |
|---|---|---|---|
| B01 | `flutter gen-l10n` | PASS | Flutter CI run #10, `Generate localizations` success on `a64b992` |
| B02 | `flutter analyze --fatal-infos --fatal-warnings` | PASS | Flutter CI run #10, `Analyze` success on `a64b992` |
| B03 | `flutter test` | PASS | Flutter CI run #10, `Test` success on `a64b992` |
| B04 | Android debug build | TODO | |
| B05 | Android release AAB | TODO | |
| B06 | Android release APK gerektiğinde | TODO | |
| B07 | APK install/launch gerçek/emülatör | TODO | |
| B08 | Final artifact SHA-256 | TODO | |
| B09 | Privacy/Terms/Sources URLs | TODO | |
| B10 | Store TR/EN/AR screenshots/copy | TODO | |

## Final kuralı

`D`, `M`, `S`, `P` veya `B` grubundaki kritik satırlardan biri `TODO` veya `FAIL` ise ürün final değildir. Responsive ve localization testlerinde release hedefli cihaz/dil kombinasyonlarının tamamı PASS olmadan final verilmez.
