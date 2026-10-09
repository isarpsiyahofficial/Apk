# İslami Hayat — Privacy Policy Taslağı

**Durum:** V1 ürün davranışına bağlı çalışma taslağıdır; mağaza yayını için final hukuk metni değildir.  
**Kaynak:** `SPECIFICATION.md` 494–515 ve 813; mevcut privacy/storage/ad sınırları.  
**Fail-closed kuralı:** Release öncesinde uygulamanın gerçek APK/AAB davranışı, dahil edilen SDK'lar, Android backup ayarları ve mağaza Data safety / privacy beyanları bu metinle birebir doğrulanmadan bu belge final Privacy Policy sayılmaz.

## 1. Kapsam

İslami Hayat; Kur’an, dua, zikir ve İslami bilgi özellikleri sunan, hassas dini kullanım verisini mümkün olduğunca cihazda tutmayı amaçlayan bir mobil uygulamadır. V1'de hesap tabanlı kullanıcı profili veya uygulamaya ait bir analytics backend'i planlanmaz.

## 2. Cihazda kalan kişisel ve hassas veriler

Kullanıcının serbest metin dini soruları, özel notları, zikir geçmişi ve dini ilgi çıkarımı oluşturabilecek kullanıcı kaynaklı içerik ağ, reklam, analytics veya debug-log kanallarına gönderilmemelidir. Uygulamadaki merkezi egress sınırı bu veri sınıflarını fail-closed reddeder.

Favoriler, notlar ve zikir geçmişi yerel kullanıcı verisidir. Soru geçmişi varsayılan olarak kapalıdır; kullanıcı açıkça etkinleştirirse yerel olarak tutulabilir. Soru geçmişi kapatıldığında önceden tutulan soru geçmişi silinir. Kullanıcı tüm mutable yerel kişisel veriyi tek işlemle sıfırlayabilmelidir.

## 3. Analytics ve crash gözlemi

V1 privacy politikası first-party analytics, marketing analytics ve remote crash reporting kanallarını varsayılan olarak kapalı tutar. Firebase Analytics, AppsFlyer, Adjust, Facebook App Events, Mixpanel ve Amplitude benzeri analytics/marketing paketleri V1 privacy sınırında yasaklıdır.

Crash gözlemi için mümkün olduğunca Google Play Android Vitals tercih edilir. Gelecekte remote crash reporting eklenirse hassas kullanıcı metni cihazdan çıkmadan önce redaction sınırından geçmeli ve bu Privacy Policy ile mağaza beyanları yeniden gözden geçirilmelidir.

## 4. Reklamlar

Free sürümde reklam/rewarded reklam bulunabilir. Ürün kodunun reklam isteği sınırı yalnız contextual/non-personalized profile izin verir; kullanıcı sorgusu, not, ayet/dua/zikir kimliği, geçmiş, topic veya çıkarılmış dini ilgi reklam hedefleme girdisi olamaz. Publisher first-party user ID, kullanıcı hedefleme keyword'leri, historical-interest targeting ve religious-interest signals V1 strict profile'da kapalıdır.

Gerçek reklam SDK'sının kendi zorunlu teknik veri işlemesi, consent gereksinimleri ve üçüncü taraf alıcıları release öncesi exact production SDK sürümü üzerinden ayrıca doğrulanmalı; doğrulanmamış üçüncü taraf veri akışı bu taslakla meşrulaştırılmış sayılmaz.

## 5. Billing / PRO

Lifetime PRO satın alma ve restore işlemleri mağaza billing altyapısını kullanabilir. Uygulama Free/PRO entitlement dışında kullanıcıyı dini davranışına göre profillememelidir. Production billing SDK'sının işlediği teknik/satın alma verileri release öncesi exact sürüm ve mağaza şartlarıyla bu belgeye işlenmelidir.

## 6. Android backup

Hassas dini soru, not ve benzeri özel verinin Android Auto Backup / device-transfer mekanizmalarıyla istem dışı buluta çıkması engellenmeli veya açıkça kontrol edilmelidir. Bu gereksinim yalnız dokümantasyonla sağlanmış sayılmaz: final Android manifest, backup/data-extraction rules ve gerçek cihaz/emülatör restore davranışı release gate'te doğrulanmalıdır.

## 7. İzinler

V1 namaz vakti hesaplamadığı için konum izni istememelidir. İleride Kıble özelliği eklenirse konum yalnız kullanıcı özelliği açtığında istenmeli ve mümkün olduğunca cihazda işlenmelidir. Yeni bir izin veya veri akışı eklenmesi privacy review gerektirir.

## 8. Veri saklama ve silme

Yerel veri, kullanıcı ilgili özelliği kullandığı sürece cihazda kalabilir. Soru geçmişi opt-in ve en fazla 100 kayıt olacak şekilde tasarlanmıştır. Kullanıcı soru geçmişini temizleyebilir ve tüm mutable yerel kişisel veriyi sıfırlayabilir. Uygulama kaldırıldığında Android'in uygulama verisi yaşam döngüsü geçerlidir; backup'tan geri yükleme davranışı ise 6. bölümdeki fail-closed kapıya tabidir.

## 9. Çocuklar ve hassas dini veri

Uygulama çocuklara yönelik bir ürün olarak tasarlanmamıştır. Dini inanç ve dini ilgi çıkarımı oluşturabilecek veriler hassas kabul edilir; veri minimizasyonu esastır. Store target-age ve ülke bazlı hukuki gereksinimler final yayın matrisiyle ayrıca doğrulanmalıdır.

## 10. Uluslararası yayın ve kullanıcı hakları

Türkiye, EEA/UK, ABD/California ve diğer hedef bölgelerdeki zorunlu privacy açıklamaları, yasal dayanaklar, kullanıcı hakları, veri sorumlusu/iletişim bilgileri ve gerekiyorsa üçüncü taraf processor/alıcı listesi yayın ülke matrisi kesinleştiğinde tamamlanacaktır. Bu taslak bu alanlarda hukuki kesinlik iddiası taşımaz.

## 11. Release öncesi zorunlu uyum kapısı

Privacy Policy ancak aşağıdakilerin tamamı exact release candidate üzerinde doğrulanınca yayın metnine dönüştürülebilir:

- Hassas sorgu/not/zikir/dini-ilgi payload'larının egress testleri fail-closed PASS.
- Analytics/marketing/remote-crash SDK envanteri gerçek dependency tree ile uyumlu.
- Reklam SDK'sı yalnız onaylı contextual/non-personalized request sınırından çağrılıyor.
- Android backup/data-extraction davranışı hassas veriyi istem dışı cloud backup'a çıkarmıyor.
- Yerel history opt-in, clear-history ve reset-all happy/failure path testleri PASS.
- Production Billing ve Ads SDK veri işleme beyanları exact sürümlerle kaydedilmiş.
- Google Play Data safety ve varsa diğer store privacy formları gerçek binary davranışıyla aynı.
- Hedef ülke hukuk matrisi ve zorunlu iletişim/veri sorumlusu alanları tamamlanmış.
- Privacy URL erişilebilir ve mağaza listing'iyle aynı yayın metnini gösteriyor.

Bu kapılardan biri doğrulanmadıysa SPEC 813 gereği uygulama privacy açısından final değildir.
