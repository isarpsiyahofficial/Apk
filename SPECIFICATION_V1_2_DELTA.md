# SPECIFICATION v1.2 — KARAR DELTASI

Bu dosya `SPECIFICATION.md` v1.1 üzerinde alınan son kararları kilitler. `SPECIFICATION.md` içine birleştirilene kadar bağlayıcı ürün kararıdır.

## 1. Paylaşım görselleri

- Final hedef **30 değil 100 paylaşım görselidir**.
- 100/100 görsel Canva kataloğundan seçilecektir.
- Uygulamanın final reusable background assetleri sıfırdan AI ile üretilmeyecektir.
- `CANVA_VISUAL_CANDIDATES.md` içindeki 100 kayıt aday havuzudur; her biri Free/Pro, Canva-AI durumu ve tekrar export/uygulama içine gömme hakkı açısından tek tek doğrulanmadan final asset değildir.
- Canva Pro veya yeniden dağıtım/export hakkı yetersiz içerik final APK/AAB içine gömülmeyecektir.
- Uygulamanın ayet, dua ve kaynak metni Canva şablonundan alınmayacak; doğrulanmış yerel içerik veritabanından runtime'da render edilecektir.
- Story 9:16, WhatsApp Status 9:16, Post 4:5 ve kare 1:1 formatlarının tamamı desteklenecek ve gerçek cihazda test edilecektir.
- Uzun ayet, TR/EN/AR, Arapça RTL ve source-lock her formatta doğrulanacaktır.
- **Nihai V1 erişim matrisi 100 tasarım için sabittir: 3 kalıcı FREE + 97 Rewarded/PRO.** FREE kullanıcı ilk üç tasarımı sınırsız kullanır; 004–100 arasındaki kilitli tasarımlarda yalnız başarıyla tamamlanan gönüllü rewarded reklam seçilen tasarım için 1 paylaşım hakkı üretir; PRO kullanıcı 100 tasarımın tamamını sınırsız ve rewarded teklif edilmeden kullanır.
- Bu erişim kararı herhangi bir Canva adayını final asset yapmaz; lisans/hash/AI/re-export ve dört-format görsel QA kapıları ayrıca geçilmelidir.

## 2. UI/UX ve responsive cihaz matrisi

- UI light-first, sıcak, açık, editorial ve sade olacaktır; koyu petrol yeşili ağırlıklı jenerik AI-dashboard görünümü final kabul edilmez.
- Telefonlarda alt `NavigationBar`, tablet ve geniş emülatörlerde `NavigationRail` kullanılacak adaptif kabuk tercih edilir.
- Başlangıç breakpointleri: compact `<=599`, medium `600–839`, rail/expanded `>=840`.
- Geniş tablet/BlueStacks pencerelerinde içerik kontrolsüz şekilde tüm yatay alanı kaplamayacak; okunabilir maksimum içerik genişliği uygulanacaktır.
- Release cihaz matrisi en az şu görünüm sınıflarını içerecektir:
  - 320–360 px dar telefon,
  - 390–430 px güncel telefon,
  - 600–839 px küçük tablet/katlanabilir genişliği,
  - 840–1199 px tablet,
  - 1200+ px büyük tablet/desktop-window/BlueStacks,
  - 16:9 ve 16:10 yatay emülatör pencereleri,
  - 4:3 tablet,
  - font scale büyütülmüş erişilebilirlik senaryoları,
  - TR/EN LTR ve AR RTL.
- Layout overflow, kesilen metin, aşırı geniş satır, alt navigasyon çakışması, keyboard inset ve orientation değişimi release blocker sayılacaktır.

## 3. Tamamlama standardı

- Bir ekran yalnız görünür olduğu için tamamlanmış sayılmaz: navigation, state, empty/error/loading, localization, RTL ve responsive davranışı test edilmelidir.
- Bir monetizasyon özelliği yalnız SDK entegrasyonu ile tamamlanmış sayılmaz: FREE/PRO, offline, rewarded success/cancel/fail, restore/reinstall/revoke ve PRO sıfır reklam davranışı gerçek test ister.
- Dini/tarihsel içerik yalnız veri tabanına girdiği için tamamlanmış sayılmaz: kaynak, doğruluk, kesinlik seviyesi, lisans, üç dil ve yazım kontrolü geçmelidir.
