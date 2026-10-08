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
