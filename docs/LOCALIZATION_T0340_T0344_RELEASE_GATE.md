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

### 2.1. Nested Vahiy Yolculuğu route'u — ARB bağlı

Keşfet içindeki `RevelationJourneyPage` için kullanıcıya görünen başlık, açıklama, filtreler, yaklaşık-tarih uyarısı, semantics metinleri, Kur’an referans başlığı, güvenli-açma hata metni ve dönem adları artık yalnız TR/EN/AR ARB anahtarlarından gelir. Önceki `_JourneyCopy` locale-switch yapısı kaldırılmıştır.

`test/features/prophets/revelation_journey_page_test.dart`:

- TR telefonda ARB başlık + açıklama,
- EN geniş görünümde dönem filtresi + paralel dönem etiketi + yaklaşık tarih uyarısı,
- AR 320×800 RTL görünümde ARB başlık + filtre + açıklama,
- Kur’an referans bottom-sheet başlığı ve failure-path davranışı,
- geniş landscape overflow kontrolü

kanıtlarını üretir. Bu nested-route kanıtı T0340–T0344 kapsamını ilerletir ancak full-surface crawl tamamlanmadan satırları tek başına PASS yapmaz.

### 2.2. Dua deep-surface state coverage — otomatik kapı

`DuaLibraryPage` kullanıcı arayüzündeki başlık, arama, filtre, favori/geçmiş, empty/error ve 24 kategori adı artık yalnız `AppLocalizations` üzerinden TR/EN/AR ARB anahtarlarından gelir. Önceki `_DuaLabels` locale-switch yapısı ve üç ayrı hard-coded kategori map'i kaldırılmıştır. Bu değişiklik yalnız UI copy katmanını etkiler; doğrulanmış `LocalizedReligiousText` dua metni kaynak verisi değiştirilmez.

`test/localization_dua_surface_t0344_test.dart` Dua kütüphanesini doğrudan gerçek widget yüzeyi olarak TR/EN/AR locale'lerinde açar. Test fixture dini içeriği yalnız `published` durumunda ve typed `Quran` source reference ile üretir; test herhangi bir üretim dini metnini değiştirmez.

Kapı üç locale için:

- doğru LTR/RTL yönünü,
- locale'e ait başlık ve arama metnini,
- locale'e ait tüm-kategoriler ve `morning` kategori metnini gerçek dropdown üzerinden,
- locale'e ait doğrulanmış fixture metnini,
- arama sonucu bulunmadığında locale'e ait `empty` durumunu,
- private user-state okuması hata verdiğinde locale'e ait güvenli `error` metnini,
- exception/overflow bulunmamasını

doğrular. Ek AR testi private-state future'ı bilinçli olarak bekleterek gerçek `loading` durumunun RTL kalmasını ve içerik hazır olmadan arama yüzeyinin sızmamasını kontrol eder.

Bu kanıt T0344 içindeki **Dua + loading/empty/error + kategori localization** alt kapsamını ilerletir. Branch üzerinde `DuaLibraryRepository` ve review gate bulunmasına rağmen production'a bağlanabilecek, kaynak/review kanıtı tamamlanmış canonical Dua dataset dosyası henüz yoktur. Test fixture'ı production dataset yerine kullanılamaz; bu nedenle sırf ekranı görünür kılmak için boş veya sahte veriyle Keşfet route'u bağlanmaz. Gerçek production dataset yayın kapısından geçmeden Dua'nın Keşfet production navigation girişi ve T0340–T0344 PASS değildir.

### 2.3. FREE offline kapıları — üç dil fail-closed

`test/app_startup_access_t0262_test.dart` FREE cold-start offline engelini TR, EN ve AR locale'lerinde doğrular. Network probe başarısız olduğunda `AppShell` hiç mount edilmez; kullanıcı yalnız locale'e ait offline başlık/gövde/retry metnini görür. AR senaryosu ayrıca root `Directionality.rtl` davranışını kontrol eder.

`test/features/premium/free_connection_drop_t0263_test.dart` artık aynı gerçek `IslamiHayatApp` ağacında TR/EN/AR için **online → offline → online recovery** geçişini ayrı ayrı doğrular:

- cold-start'ta HTTP 204 ile FREE shell açılır,
- bağlantı kaybolduğunda yeni Kur’an yüzeyine geçiş fail-closed engellenir ve kullanıcı mevcut ekranda kalır,
- her locale kendi offline açıklamasını SnackBar üzerinde gösterir,
- AR akışında RTL korunur,
- bağlantı geri geldiğinde aynı kullanıcı hareketi Kur’an yüzeyine geçer,
- her geçişte reachability yeniden kontrol edilir ve exception oluşmaz.

Aynı cold-start testleri cached PRO kullanıcının reachability request göndermeden shell'e girdiğini korumaya devam eder. Bu kanıt T0344 içindeki **Offline gate + online→offline failure/recovery** alt kapsamını ilerletir; diğer monetization state'leri tamamlanmadan localization veya M-grubu topluca PASS değildir.

### 2.4. Premium value surface — mevcut üç dil davranış kanıtı

`test/features/premium/premium_value_page_t0279_test.dart` gerçek `PremiumValuePage` yüzeyinde TR telefon, EN 320px + 1.6× büyük font ve AR 1200×800 RTL senaryolarını doğrular. Test yalnız uygulanmış V1 faydalarının görünmesini, uygulanmamış tema/widget vaatlerinin sızmamasını, dini doğruluğun paywall arkasına konmamasını ve overflow/exception bulunmamasını kontrol eder. Bu kanıt Premium sunum yüzeyini ilerletir; satın alma/restore/pending/revoke ve reklam lifecycle kapılarının yerine geçmez.

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
- notification/widget/share failure copy,
- native TR/EN/AR editorial pass.

## PASS kuralı

T0340–T0344 ancak şu üç koşul birlikte sağlandığında kapatılabilir:

1. ARB contract yeşil,
2. route/state manifestindeki tüm zorunlu yüzeyler üç locale'de gerçekten crawl edilmiş ve leakage/RTL/snapshot-functional kanıtı üretmiş,
3. exact release HEAD üzerinde Flutter CI + ilgili Android/emulator hatları yeşil.

Bir ekranın yalnız render olması veya ARB anahtarının mevcut olması PASS sayılmaz. Açık failure-path bulunan alan fail-closed biçimde TODO kalır.
