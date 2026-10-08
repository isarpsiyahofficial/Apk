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

## Bugün ana ekran bilgi hiyerarşisi — T0043 IA sözleşmesi

**Kapsam:** Bu bölüm varsayılan içerik önceliğini ve durum sınırlarını sabitler; yeni widget, route, kaynak kaydı veya çalışma zamanı testi değildir. **İlk açılış akışı:** sakin selamlama + gün bilgisi (başlık), ardından **1. Günün Ayeti → 2. Bugünün Duası → 3. Bugün İslam Tarihinde → 4. dört hızlı erişim → 5. koşullu Devam Et**. Altıncı ana modül, çoklu mini-kart panosu veya ikinci arama girişi eklenmez. Kullanıcının daha sonra yapabileceği kişiselleştirme, varsayılan sıralamayı değiştirmez.

| Öncelik | Görünür içerik ve etkileşim sözleşmesi | Veri güvenliği / boş-hata yolu | Mevcut HEAD durumu |
|---|---|---|---|
| Başlık | Selamlama ve yerel gün bilgisi; tarih kesinliği iddiası yok | Dil/RTL ve büyük fontta okunabilir, görsel yükü düşük | **KISMİ:** selamlama/alt başlık var; gün bilgisinin gösterimi ayrıca doğrulanmalı |
| 1 — Günün Ayeti | Doğrulanmış deterministik günlük ayet; Arapça metin, onaylı meal, sure:ayet ve kaynak; favori, detay ve paylaş eylemleri | Aynı yerel gün yeniden açıldığında aynı ayet; integrity/translation failure durumunda yanlış veya kısmi dinî metin gösterme, ayrı açıklanabilir hata durumu; share source-lock | **KISMİ:** daily verse, kaynak, favori, okuyucu bağlantısı var; paylaş ve loading/error ayrımı tamamlanmış değil |
| 2 — Bugünün Duası | Uzunsa doğal kısa önizleme; **Tam Duayı Oku** doğrulanmış dua detayına gider | Kaynak/dua türü ve review eksikse sahih dua gibi sunma; yayınlanabilir kayıt yoksa uydurma dua üretme | **HEDEF:** şu an yalnız `contentPending` placeholder; gerçek dua/detail navigation yok |
| 3 — Bugün İslam Tarihinde | Yalnız gün/ay eşleşmesi güvenilir kaynakla kanıtlı tarih olayı; detayda kaynak ve belirsizlik etiketi | Yaklaşık yıl veya tarihi bilinmeyen olayı kesin günün olayı olarak atama; o gün onaylı olay yoksa sahte olay doldurma | **HEDEF:** şu an yalnız `contentPending` placeholder |
| 4 — Hızlı erişimler | Tam **dört** giriş: **Konu Ara → Dualar → Zikir → Keşfet**; her biri sahip sekme/alt ekrana gider | FREE offline geçişi `AppShell` guard ile korunur; başarısız route sessizce başarılı sayılmaz; PRO reklam teklifi almaz | **KISMİ:** dört etiket çiziliyor fakat `_QuickAction.onTap: () {}` olduğundan hedefe gitmiyor |
| 5 — Devam Et | Yalnız geçerli kayıtlı Kur’an okuma konumu varsa, sure/ayetle devam et | Konum yoksa kart gizlenir; bozuk/veri okunamıyor durumda yanlış konuma götürme; yeni içerik geçişinde FREE guard | **KISMİ:** kayıtlı konum ve Kur’an sekmesi callback'i var; hatada kart gizleniyor, ayrı hata geri bildirimi henüz kanıtlanmadı |

**İkincil öğrenim:** `DailyProphetLearningCard` mevcut günlük ayet/tarih bölgesinde isteğe bağlı öneridir; ana beş basamağın yerini alamaz, hızlı erişim sayısını artıramaz ve doğrulanmamış peygamber olayını öneremez. Tarihsel özne/olay aidiyeti ve sekiz boyutlu 25 peygamber QA kapısı ayrıca geçilmelidir.

**Sunum sınırı:** Light-first editorial dikey akış, tek baskın ayet odağı, sakin boşluklar ve okunabilir satır genişliği; 10–15 özellik kutusu veya AI-dashboard paneli yok. 320–360px, 390–430px, 600–839px, 840–1199px, 1200+px, landscape 16:9/16:10, tablet 4:3, 1.6x+ yazı, TR/EN LTR ve AR RTL'de sıra, taşma, klavye inset, dokunma hedefleri ve odak sırası test edilmeden ekran PASS değildir. Dar ekranda ilk görünüm 5 saniyede amaç/ilk eylemi anlatmalıdır; bu kullanıcı/cihaz testi henüz yapılmadı.

**Eylem ve durum test kapısı:** Her gerçek bağlantı için başarı, offline FREE engeli, PRO geçişi, boş veri, bozuk integrity, yükleniyor/hata, geri navigasyonu ve paylaşım kaynak kilidi ayrı doğrulanır. Placeholder görünmesi gerçek içerik PASS sayılmaz. T0043 yalnız **bilgi hiyerarşisi kararını** tamamlar; T0048 wireframe/5 saniye anlaşılırlık, günlük dua/tarih içeriği, paylaşım ve TEST_MATRIX UI/monetizasyon/dinî QA maddeleri açık kalır.

**Kod kanıtı:** `lib/features/today/presentation/today_page.dart` (`_Header`, `_DailyVerseBlock`, `_EditorialBlock`, `_QuickActions`, `_ContinueQuranBlock`); `lib/shell/app_shell.dart` (sekme ve guarded navigation). Bu bölüm kod değişikliği veya yeni exact-head davranış testi değildir.

## Light-first tasarım token planı — T0044

**Kapsam:** Bu bölüm mevcut `lib/core/theme/app_theme.dart` içindeki renk kararlarını adlandırır; Flutter theme, widget, route, storage, font asseti veya localization key'i değiştirmez. Bu bir **design-token/ürün sözleşmesidir**, cihaz QA veya her ekranda tamamlanmış görsel uygulama iddiası değildir. Kaynak: SPEC 77–102, 704–705, 815; exact-head `5e5f865fb97bbbcd6cd95fbdefcb90f8da4111f6`.

| Semantik token | Mevcut `AppTheme.light()` karşılığı | HEX | Kullanım sınırı |
|---|---|---|---|
| `canvas.warmIvory` | `_ivory`, `scaffoldBackgroundColor` | `#F8F5EE` | Varsayılan ekran zemini; sıcak, açık, editorial; tam ekran koyu forest yerine. |
| `surface.paper` | `_surface`, `ColorScheme.surface` | `#FFFDF8` | Okuma yüzeyi ve sınırlı içerik blokları; her paragrafı kart içine alma. |
| `accent.forest` | `_forest`, `ColorScheme.primary` | `#183D32` | Seçili eylem, navigasyon odağı, az sayıdaki güçlü vurgu; büyük koyu panel yığınları yasak. |
| `accent.sage` | `_sage`, `ColorScheme.secondary` | `#708A78` | Yardımcı ikon/indikator ve düşük yoğunluklu seçili arka plan; varsayılan küçük metin rengi değil. |
| `detail.sand` | `_sand`, `dividerColor` | `#D8C8A8` | İnce divider/border; metin ve bilgi taşıyan tek gösterge değil. |
| `text.ink` | `_ink`, `ColorScheme.onSurface` | `#20231F` | Başlık ve ana metin. |
| `text.muted` | `_muted`, `bodyMedium` | `#666A63` | İkincil metin; gizli/disabled bilgiyi yalnız düşük kontrastla iletme. |
| `feedback.error` | `ColorScheme.error` | `#B3261E` | Hata mesajı; yalnız renge değil açıklayıcı metne de dayanır. |
| `detail.gold` | **Henüz production token yok** | **TBD** | Minimal altın yalnız doğrulanmış ince çizgi/ikon vurgusu; `_sand` otomatik gold sayılmaz. Yeni renk T0045+ kontrast incelemesi olmadan eklenmez. |

**Gözden geçirilebilir kontrast hesabı (sRGB/WCAG relative luminance, mevcut HEX çiftleri):** forest `#183D32` / paper `#FFFDF8` **11.79:1**; ink `#20231F` / ivory `#F8F5EE` **14.59:1**; muted `#666A63` / paper **5.43:1**; error `#B3261E` / paper **6.43:1**. Buna karşılık sage `#708A78` / paper **3.69:1**, white `#FFFFFF` / sage **3.75:1**, sand `#D8C8A8` / paper **1.62:1**. Bu sayılar yalnız belirtilen düz renk çiftlerine aittir; composited alpha, opacity, durum, gerçek ekran veya erişilebilirlik PASS kanıtı değildir.

**Kontrast koruması:** Normal metin için en az 4.5:1, büyük metin için en az 3:1 hedeflenir; anlam taşıyan UI bileşenlerinin grafik/sınır kontrastı ayrıca en az 3:1 olarak test edilir. Mevcut `ColorScheme.onSecondary = Colors.white` / sage çifti **3.75:1** olduğundan **normal boyutlu metinde kullanımı engellenmelidir**; bu plan sorunu giderilmiş saymaz. Sage ve sand tek başına kaynak güvenilirliği, seçili durum veya hata anlamı taşıyamaz. Kontrastı bozuk yüzey T0045+ düzeltme ve test kanıtı bekler; testi yeşil yapmak için eşiği düşürme.

**Anti-dashboard tasarım kapısı:** Koyu petrol yeşili ekran zemini veya birden fazla yoğun koyu panel, 10–15 eşdeğer modül kartı, her öğeye 20–24 px aynı radius, dekoratif glow, yoğun gradient, cam efekti ve rastgele cami/minare görselleri varsayılan ürün dili olamaz. Bugün'de tek güçlü ayet odağı + sakin dikey editorial sıra; Kur’an'da sayfa/okuma hissi; Dua'da metin önceliği; Zikir'de dikkat dağıtmayan kontrol; Tarih'te gerçek timeline; Peygamberler'de dönem/bağlam geçişleri tercih edilir. Altın küçük dekoratif aksan olarak kalır, ücretli/dini doğruluk işareti değildir.

**Dark mode sınırı:** `AppTheme.dark()` mevcut alternatif temadır; light-first marka varsayılanını değiştirmez, FREE kullanıcıdan saklanamaz. `light().copyWith(...)` yaklaşımında inherited navigation/input/text alt temalarının dark kontrastı ve durumları otomatik PASS kabul edilmez. T0045/T0046 ve gerçek widget/cihaz testlerinde light/dark, TR/EN/AR, AR RTL, 320–360 px, tablet/landscape/BlueStacks, 1.6x+ font, focus/disabled/error ve offline FREE/PRO ayrı incelenir. Renk token planı dinî içerik kaynak doğruluğu veya Billing/rewarded davranışını kanıtlamaz.

**T0044 tamamlanma sınırı:** Yukarıdaki palet, semantik roller, kontrast riskleri ve yasak tasarım kalıpları **planlandı**. Uygulama genelinde tutarlılık, gold seçimi, kart/radius/spacing/elevation (T0045), Latin/Arapça/mushaf typography (T0046), 5 saniye anlaşılabilirlik (T0048), RTL wireframe (T0061) ve release matrisi **açıktır**.

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
