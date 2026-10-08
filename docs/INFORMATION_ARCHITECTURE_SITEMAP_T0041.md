# İSLAMİ HAYAT — BEŞ SEKME SITEMAP / T0041

**Kaynak:** `SPECIFICATION.md` 56–76, 700; `TODO.md` T0040–T0062; `SPECIFICATION_V1_2_DELTA.md`.
**Kapsam:** Bilgi mimarisi kararıdır; uygulama davranışı veya yeni route implementasyonu değildir.
**İncelenen implementation HEAD:** `44dd5dd35ca537d663e1cc1ee6a751fb085bb1e1`.
**Durum etiketleri:** **BAĞLI** = mevcut `AppShell`/hub üzerinden kullanıcı akışında erişilebilir; **KISMİ** = yüzey var fakat içerik/bağlantı eksik; **HEDEF** = şartname gereği tasarlandı, mevcut UI erişimi veya production davranışı kanıtlanmadı. Kısmi/planlanan yüzeyleri tamamlandı sayma.

## Ana navigasyon (tek sahiplik)

| Ana sekme | Amaç ve içerik sahipliği | Mevcut erişim | Sonraki iş |
|---|---|---|---|
| **Bugün** | Günün Ayeti → Günün Duası → Bugün İslam Tarihinde → en fazla dört hızlı erişim → Devam Et; uygun olduğunda günlük peygamber öğrenimi | **KISMİ:** ayet, devam et ve peygamber bağlantıları; dua ve tarih editoryal placeholder, hızlı erişimlerde tam navigation kanıtı yok | T0043/T0048, günlük içerik ve dört hızlı erişimin gerçek yönlendirmesi |
| **Kur’an** | Sure/ayet okuma, meal, kaynak, arama, ezber; okuyucu içi bookmark/favori/not ve ayet paylaşımı | **BAĞLI:** QuranHub reader/search/memorize modları; alt işlevlerin tamamı bu sitemap ile PASS değildir | T0049 ve Kur’an fonksiyonel testleri |
| **Keşfet** | **Global arama (üstte)**, Dualar, Peygamberler/Vahiy Yolculuğu, İslam Tarihi, Dini Günler, Kur’an’da Konuya Göre Ara; bilgi kütüphanesi | **KISMİ:** mevcut DiscoverPage yalnız peygamber girişini render ediyor; diğer modüller için hub bağlantısı kanıtlanmadı | T0042/T0050 ve modül navigation testleri |
| **Zikir** | Sayaç, Zikirler rehberi, Niyetime Göre; Esmâü’l-Hüsnâ rehberi; kaynaklı sayı ile kişisel/geleneksel/ebced ayrımı | **BAĞLI:** DhikrHub üç tab + Esmâ giriş düğmesi; default guide data boş olabildiğinden gerçek içerik PASS değildir | T0052/T0053 ve dini provenance/UX testleri |
| **Ben** | Favoriler, geçmiş, kişisel notlar, zikir geçmişi, bildirim ayarları, dil/tema, gizlilik/veri silme, Lifetime PRO/restore, Kaynaklar ve Lisanslar | **KISMİ:** bildirimler, gizlilik, Premium değer ekranı, Kaynaklar/Lisanslar bağlı; diğer hedefler ayrı UX/entegrasyon kanıtı bekliyor | T0060 ve storage/Billing/restore testleri |

**Sekme kuralı:** Alt navigasyon yalnız Bugün–Kur’an–Keşfet–Zikir–Ben. Telefonlarda `NavigationBar`, `>=840px` genişlikte `NavigationRail`; beşli sıra/kimlik değiştirilmez. Yeni özellik için altıncı sekme veya Bugün'de yeni ana modül kartı açılmaz.

## Hedef alt sayfa ağacı ve erişim ilkesi

```text
Uygulama
├── Bugün [günlük, tek dikey editorial akış]
│   ├── Günün Ayeti → Kur’an > ilgili ayet [mevcut]
│   ├── Günün Duası → Keşfet > Dualar > kaynaklı detay [hedef]
│   ├── Bugün İslam Tarihinde → Keşfet > Tarih > olay [hedef]
│   ├── Hızlı erişim (yalnız 4): Konu Ara / Dualar / Zikir / Keşfet [hedef bağlantılar]
│   └── Devam Et → Kur’an > kayıtlı okuma konumu [mevcut]
├── Kur’an [okuma ve ayet içi araçlar]
│   ├── Oku → sure/ayet, meal, kaynak, favori/bookmark/not, ayet paylaşımı
│   ├── Ara → ayet arama → okuyucuda aç [mevcut hub]
│   └── Ezber [mevcut hub]
├── Keşfet [bilgi kütüphanesi; planlanan tek global arama girişi]
│   ├── Global Ara → kategorili sonuçlar [hedef; T0042]
│   ├── Dualar → kategori/liste → detay → kaynak/paylaş [hedef hub]
│   ├── Peygamberler → biyografi → kaynak/ayet [mevcut giriş; ayrıntı QA açık]
│   │   └── Vahiy Yolculuğu → paralel dönem/soy/coğrafya [hedef gezinme]
│   ├── İslam Tarihi → timeline → olay/kişi/bölge [hedef]
│   ├── Dini Günler → gün → kaynak/tarih belirsizliği [hedef]
│   └── Kur’an’da Konuya Göre Ara → tema → doğrulanmış ayet kümesi [hedef]
├── Zikir [sade, reklamdan arındırılmış ibadet akışı]
│   ├── Sayaç → kişisel hedef / oturum geçmişi [mevcut]
│   ├── Zikirler → rehber → Zikri Başlat → sayaç [rehber mevcut; akış QA açık]
│   ├── Niyetime Göre → anlam temelli yönlendirme [mevcut giriş]
│   └── Esmâü’l-Hüsnâ → anlam/kaynak/rozet/ebced ayrımı [mevcut giriş]
└── Ben [kişisel durum, tercihler ve şeffaflık]
    ├── Favoriler / geçmiş / notlar [hedef birleşik erişim]
    ├── Bildirimler [mevcut]
    ├── Dil ve tema [hedef]
    ├── Gizlilik / verileri temizle [mevcut]
    ├── Lifetime PRO / satın alımları geri yükle [Premium giriş mevcut; Billing QA açık]
    └── Kaynaklar ve Lisanslar [mevcut]
```

## Global arama sonuç kategorileri — T0042 bilgi mimarisi sözleşmesi

**Giriş ve kapsam:** Tek global arama girişi **Keşfet üst alanıdır**. Kur’an sekmesindeki ayet araması okuyucuya özel kalır; ikinci bir global arama servisi, yeni alt sekme veya ayrı içerik kopyası oluşturulmaz. Aşağıdaki sekiz kategori, sonuç gruplarının **sabit sırasıdır**; kullanıcı sorgusuna göre boş gruplar gizlenebilir fakat kategori kimlikleri karıştırılamaz. Bu bölüm yalnız ürün/IA kararıdır; canlı arama motoru veya indeks uygulandığı iddia edilmez.

| Sıra | TR kategori (sabit) | İçerik kapsamı / sahip kayıt | Açılacak hedef | Yayın güvenlik kapısı |
|---|---|---|---|---|
| 1 | **Ayetler** | Canonical sure:ayet ve onaylı meal; sure/ayet kimliği korunur | Kur’an > ilgili ayet | Tanzil pinned metin ve QuranEnc meal bütünlüğü doğrulanmadan gösterme |
| 2 | **Dualar** | Kaynaklı Kur’an/hadis duaları veya açıkça etiketlenmiş Genel Dua | Keşfet > Dualar > detay | Dua kimliği, kaynak ve TR/EN/AR review; editoryal metne hadis/ayet rozeti verme |
| 3 | **Zikirler** | Rehber zikir kaydı; sayı ve sayı kaynağı ayrı | Zikir > rehber > detay/sayaç | Sünnet sayısını kişisel/preset/ebced sayısından ayır; doğrulanmamış sayı önerme |
| 4 | **Esmâ** | Esmâü’l-Hüsnâ adı, anlamı ve dayanak bilgisi | Zikir > Esmâ > detay | Kaynak/rozet doğrulaması; ebced/havas geleneğini sahih sünnet gibi sunma |
| 5 | **Peygamberler** | Kimlik sahibi 25 peygamber biyografisi ve bağlamlı olayları | Keşfet > Peygamberler > biyografi | Kimlik→olay→ayet→hadis→soy→kronoloji→coğrafya→tarih çapraz eşleşmesi; yanlış özne fail-closed |
| 6 | **Tarih** | Kaynaklı dönem/olay kayıtları, kesinlik etiketiyle | Keşfet > İslam Tarihi > olay | Tarihsel provenance, ihtilaf ve yaklaşık/bilinmiyor statüsü korunur |
| 7 | **Kişiler** | Tarihsel şahsiyet kayıtları (peygamber biyografisi kopyası değil) | Keşfet > İslam Tarihi > kişi | Kimlik/olay ve tarihsel kaynak eşleşmesi; tartışmalı aidiyeti kesinleştirme |
| 8 | **Dini Günler** | Gün/gece kayıtları ve doğrulanmış tarih belirsizliği | Keşfet > Dini Günler > detay | Hadis derecesi, özel ibadet iddiası ve ülke/rasat kaynakları ayrı doğrulanır |

**Sonuç ve hata sözleşmesi:** Sonuç başlığı + ayırt edici kaynak/kimlik + güven/inceleme etiketi, ilgili detay sayfasına bağlanmalıdır; başka kategorinin kaydına yönlendirme yasaktır. Doğrulanmamış, taslak, lisanssız veya bütünlüğü bozuk içerik arama sonucuna düşmez (**fail-closed**). Sıfır sonuçta uydurma öneri üretme; veri paketi bozuksa boş sonuç gibi gizleme, ayrı hata göster. Arama çalışmıyorsa sonuç varmış gibi placeholder sunma. Dini iddialarda sonuç sıralaması ücret/etkileşim puanına göre kaynak doğruluğunu bastıramaz.

**Yerelleştirme ve QA:** TR/EN/AR kategori etiketleri ana dilde onaylanmalı, AR RTL'de kategori sırası/odak/geri yönü ve uzun metin davranışı gerçek UI testleriyle doğrulanmalıdır. Buradaki TR adlar localization key eklemez veya üç dilin hazır olduğu anlamına gelmez. Dar telefon, tablet, landscape, büyük font, offline FREE/PRO, empty/loading/error, source-integrity failure ve doğru detail navigation ayrı test edilmeden **global arama PASS değildir**.

**Mevcut durum (HEAD `8d81dfd430c6b0d2904428cfd0344aa52ce5bb54`):** `DiscoverPage` yalnız başlık/alt başlık ve peygamber girişini render ediyor; global arama UI/index ve sekiz kategorili gerçek sonuç akışı **HEDEF**. T0042 yalnız sabit taksonomi/IA kararını tamamlar; T0050, uygulama kodu, TEST_MATRIX L01–L10 ve dinî kaynak release kapıları açık kalır.

## Çapraz bağlantı, görünürlük ve release sınırları

1. **Bugün vitrin, kütüphane değil:** 10–15 ikon veya Keşfet modüllerinin kopyası yasak. Dört hızlı erişim sınırı sabittir. Bugün'den açılan hedef kendi sahip sekmesinde yaşar; aynı içeriğin ikinci bağımsız kopyası oluşturulmaz.
2. **Global arama tek giriş noktası:** Keşfet üst alanı; Kur’an içi ayet araması ayrı, Kur’an'a ait bağlamsal araçtır. T0042'nin sekiz kategori sözleşmesi tamamlanmadan global arama PASS değildir.
3. **Dini içerik kapısı:** Dua, hadis, tarih, peygamber, zikir ve dini gün ayrıntıları yalnız approved/source-verified kayıtla gösterilir; placeholder veya eksik review otomatik gerçek dini bilgiye yükseltilmez.
4. **FREE/PRO:** Navigation sahipliği entitlement'a göre değişmez. Offline FREE gate yeni içeriğe geçişte uygulanır; PRO için reklam/ödüllü giriş zorlaması yoktur. Paylaşım editörü bağlamsal eylemdir; ayrı altıncı sekme değildir.
5. **Erişilebilirlik:** TR/EN/AR, AR RTL, dar/geniş ekran, landscape, 1.6x+ font ve BlueStacks'te aynı bilgi hiyerarşisi; ikon/geri davranışı ayrıca test edilmeden PASS sayılmaz.
6. **Plan ile implementation farkı:** Yukarıdaki HEDEF/KISMİ satırları release eksikliği olarak kalır. T0041 yalnız sekme→özellik sitemap kararıdır; T0042–T0062, TEST_MATRIX L01–L10 ve ilgili gerçek cihaz/monetizasyon/dini QA maddelerini kapatmaz.

## İzlenebilirlik

- Mevcut beş sekme ve FREE geçiş koruması: `lib/shell/app_shell.dart`.
- Bugün kart/placeholder sırası: `lib/features/today/presentation/today_page.dart`.
- Kur’an modları: `lib/features/quran/presentation/quran_hub_page.dart`.
- Keşfet mevcut peygamber girişi: `lib/features/shared/presentation/discover_page.dart`.
- Zikir tabları/Esmâ giriş noktası: `lib/features/dhikr/presentation/dhikr_hub_page.dart`.
- Ben mevcut girişleri: `lib/features/profile/presentation/profile_page.dart`.
- Test kanıtı sınırı: exact-head `44dd5dd35ca537d663e1cc1ee6a751fb085bb1e1` Flutter CI ve Android Emulator Smoke SUCCESS; bu genel CI başarısı planlanan HEDEF ekranların kullanıcı akışı testini kanıtlamaz.
