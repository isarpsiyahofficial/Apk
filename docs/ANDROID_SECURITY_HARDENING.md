# Android Security Hardening

Bu belge İslami Hayat Android build hattında hassas yerel verinin yedeklenmesini ve gereksiz cihaz izinlarının eklenmesini engelleyen zorunlu kontrolleri açıklar.

## Backup politikası

- `android:allowBackup="false"` zorunludur.
- Legacy Android backup için `backup_rules.xml` root/file/database/sharedpref/external alanlarının tamamını dışlar.
- Android 12+ `data_extraction_rules.xml`, aynı alanları hem cloud backup hem device transfer dışında tutar.
- Kullanıcının dini soruları, notları, favorileri, zikir geçmişi ve entitlement cache'i uygulama dışına otomatik yedeklenmemelidir.

## İzin politikası

V1 uygulama kapsamı gereği aşağıdaki izinlar yasaktır:

- `ACCESS_FINE_LOCATION`
- `ACCESS_COARSE_LOCATION`
- `RECORD_AUDIO`
- `CAMERA`
- `READ_CONTACTS`
- `WRITE_CONTACTS`
- `GET_ACCOUNTS`

`INTERNET`, FREE internet gate/reklam/Billing gibi çevrimiçi fonksiyonlar için gereklidir.

## CI enforcement

Android Debug CI iki ayrı seviyede doğrulama yapar:

1. Build öncesinde `scripts/audit_android_security.py`, kaynak manifestini ve backup/data-extraction XML dosyalarını doğrular.
2. Build sonrasında `aapt2 dump permissions` ile gerçek `app-debug.apk` birleşik izin seti taranır. Bir dependency yasak hassas izin eklerse CI başarısız olur.

Bu kontroller geçmeden TEST_MATRIX içindeki Auto Backup ve yasak permission satırları PASS kabul edilmez.
