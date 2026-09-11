# T0340–T0344 TR / EN / AR localization release gate

Bu belge `SPECIFICATION.md`, `SPECIFICATION_V1_2_DELTA.md`, `TODO.md` ve `TEST_MATRIX.md` içindeki localization final kapısını somutlaştırır. Bu belge tek başına hiçbir TODO veya TEST_MATRIX satırını PASS yapmaz.

## Kanıt katmanları

### 1. ARB contract — mevcut otomatik kapı

`scripts/audit_localization_contract_t0340.py` ve failure-path testleri şu hatalarda fail-closed davranır:

- TR / EN / AR key set farkı,
- yanlış `@@locale`,
- boş değer,
- placeholder drift,
- EN/TR normal UI stringlerine beklenmeyen Arapça sızıntısı,
- EN/AR normal UI stringlerine beklenmeyen Türkçe-özel karakter sızıntısı.

Bu katman katalog doğruluğudur; gerçek UI crawl yerine geçmez.

### 2. Primary surface widget crawl — otomatik kapı

`test/localization_primary_surface_crawl_t0340_t0343_test.dart` gerçek `IslamiHayatApp` ağacını TR, EN ve AR locale ile açar ve beş ana yüzeyi kullanıcı navigasyonu üzerinden dolaşır:

1. Bugün / Today / اليوم
2. Kur’an / Qur’an / القرآن
3. Keşfet / Discover / اكتشف
4. Zikir / Dhikr / الذكر
5. Ben / Me / أنا

Kapı her locale için:

- doğru LTR/RTL yönünü,
- locale'e ait navigation label setini,
- diğer iki locale navigation label setinin sızmamasını,
- beş gerçek page type'a navigation yapılmasını,
- her geçişten sonra Flutter exception/overflow bulunmamasını doğrular.

AR ayrıca 1024×768 tablet `NavigationRail` üzerinde tekrar dolaştırılır. Bu, RTL'in yalnız compact telefonda görünür olmasına dayanan sahte PASS'i engeller.

### 3. T0344 full-surface crawl — AÇIK

Aşağıdaki alanların her biri TR/EN/AR için happy path ile birlikte loading / empty / error / permission / offline / monetization failure state'leri üzerinde gerçek widget/integration kanıtı olmadan T0340–T0344 final PASS değildir:

- Ana ekran
- Kur’an
- Dua
- Zikir
- Peygamber
- Tarih
- Dini Gün
- Konu Ara
- Premium
- Ads
- Billing
- Offline gate
- Notification
- Widget
- Share
- Empty
- Error
- Permission

Özellikle aşağıdakiler ayrıca açık kalır:

- AR share-card line break ve dört export formatında RTL,
- TR/EN modunda Arapça asıl metnin yalnız explicit ürün kararına göre gösterilmesi,
- rewarded success/cancel/no-fill metinleri,
- billing success/cancel/pending/restore/revoke metinleri,
- offline cold-start ve online→offline transition metinleri,
- notification/widget/share failure copy,
- native TR/EN/AR editorial pass.

## PASS kuralı

T0340–T0344 ancak şu üç koşul birlikte sağlandığında kapatılabilir:

1. ARB contract yeşil,
2. route/state manifestindeki tüm zorunlu yüzeyler üç locale'de gerçekten crawl edilmiş ve leakage/RTL/snapshot-functional kanıtı üretmiş,
3. exact release HEAD üzerinde Flutter CI + ilgili Android/emulator hatları yeşil.

Bir ekranın yalnız render olması veya ARB anahtarının mevcut olması PASS sayılmaz. Açık failure-path bulunan alan fail-closed biçimde TODO kalır.
