# İSLAMİ HAYAT — EKSİKSİZ KRONOLOJİK YAPILACAKLAR LİSTESİ

**Durum:** Uygulama geliştirme ana yürütme listesi  
**Kaynak:** `SPECIFICATION.md` v1.1 + son kullanıcı kararları + `CANVA_VISUAL_CANDIDATES.md`  
**Tarih:** 26 Ağustos 2026  

> Bu dosya sırayla yürütülecektir. Bir fazın bağımlılıkları tamamlanmadan ona bağlı ileri görev tamamlandı sayılmaz. Her tamamlanan iş için mümkün olduğunda test, ekran görüntüsü, log, hash, lisans kanıtı veya gerçek cihaz davranış kanıtı tutulur.

## SON KARARLAR — ŞARTNAME v1.2'YE AKTARILACAK DELTA

- [ ] **T0001** — `SPECIFICATION.md` sürümünü v1.2'ye çıkar; paylaşım görseli sayısını 30'dan **100'e** güncelle. **Ref:** SPEC 402–426, 487, 563, 655–666, 758–761, 904–923.
- [ ] **T0002** — 100 final paylaşım assetinin **AI ile üretilmeyeceğini**, Canva kataloğundan seçileceğini şartnameye işle. **Ref:** SPEC 77–91, 402–426, 904–923 + son kullanıcı kararı.
- [ ] **T0003** — `CANVA_VISUAL_CANDIDATES.md` içindeki 100 adayın final asset olmadığını; her birinin Free/Pro/AI-generated/yeniden dağıtım-export hakkı kontrolünden sonra sabitleneceğini şartnameye işle. **Ref:** SPEC 423–426, 811, 919–923.
- [ ] **T0004** — Görsel monetizasyon dağılımını kodlamadan önce sabitle: ücretsiz sürekli açık görsel sayısı, rewarded ile tek kullanımlık açılanlar ve PRO sınırsız görseller. Mevcut taban kural 3 ücretsiz + kalan kilitli modelidir; 100 görsele uyarlanmış nihai sayı yazılı karara bağlanmadan implementasyona geçme. **Ref:** SPEC 405–408, 465–468, 487, 655–666, 922.
- [ ] **T0005** — v1.2 şartname ile bu TODO arasında çift yönlü referans kontrolü yap ve bundan sonra tek kaynak zincirini `SPECIFICATION.md -> TODO.md -> TEST_MATRIX.md` olarak kilitle. **Ref:** SPEC 924–942.

---

# FAZ 0 — ÜRÜN ANAYASASI, KAPSAM VE KIRMIZI ÇİZGİLER

- [ ] **T0010** — Ürün adını ve mağaza görünen adını kesinleştir; geçici isim ile production package kimliğini ayır. **Ref:** SPEC 1–20, 684.
- [ ] **T0011** — Uygulamanın Kur’an merkezli İslami yaşam/bilgi ürünü olduğunu ürün dokümanında kilitle; genel spiritual/astroloji/tarot motivasyon çizgisini kapsam dışı bırak. **Ref:** SPEC 1–4, 12.
- [ ] **T0012** — “Fetva değildir”, “Allah’ın kişisel cevabı değildir”, “rastgele ayet kehaneti değildir” ürün sınırlarını yazılı metodolojiye dönüştür. **Ref:** SPEC 5–8, 192–227, 519.
- [ ] **T0013** — Mezhepsel ihtilaf, zayıf rivayet, gelenek, ebced/havas ve editoryal dua ayrım ilkelerini kilitle. **Ref:** SPEC 9–17, 228–251, 287–303.
- [ ] **T0014** — V1 kapsam dışı listesini geliştirme koruması haline getir: namaz vakti, ezan, imsak/iftar hesaplama, canlı fetva, kullanıcı mesajlaşması/feed, AI chatbot, recitation AI, cami/helal bulucu, tılsım/vefk üretici yok. **Ref:** SPEC 21–35.
- [ ] **T0015** — “Kesin para getirir / kesin şifa verir / kesin âşık eder / kişiyi bağlar” gibi sonuç vaatlerini yasak içerik sözlüğüne ekle. **Ref:** SPEC 34–35, 280–284, 299–303, 605, 803.
- [ ] **T0016** — Final engelleyici kırmızı çizgilerin tamamını release gate olarak dokümante et. **Ref:** SPEC 797–819.

**Faz 0 çıkış kriteri:** Ürün kapsamı ve yasakları yazılı, çelişkisiz, herkesin referans alacağı biçimde sabit.

---

# FAZ 1 — HUKUK, KAYNAK, LİSANS VE İÇERİK YÖNETİŞİMİ

- [ ] **T0020** — Kur’an Arapça ana metin kaynağını ve lisansını kesinleştir; exact sürüm ve attribution metnini kaydet. **Ref:** SPEC 148–151, 687, 797.
- [ ] **T0021** — Türkçe meal kaynağını, sürümünü, lisansını ve gösterilecek attribution metnini kesinleştir. **Ref:** SPEC 168–171, 688, 798.
- [ ] **T0022** — İngilizce meal kaynağını, sürümünü, lisansını ve gösterilecek attribution metnini kesinleştir. **Ref:** SPEC 168–171, 689, 798.
- [ ] **T0023** — Arapça Kur’an metninin localization string değil kutsal kaynak metni olarak ayrı veri sınıfında tutulacağını veri sözleşmesine yaz. **Ref:** SPEC 103–121, 148–171.
- [ ] **T0024** — Hadis/dua kaynak zincirini belirle; exact translation teliflerini, hadis derecelendirme kaynaklarını ve kullanım haklarını kaydet. **Ref:** SPEC 228–251, 528, 582, 690.
- [ ] **T0025** — İslam tarihi için kullanılacak birincil/ikincil kaynak ailelerini ve akademik doğrulama politikasını belirle. **Ref:** SPEC 320–389, 583–584, 699.
- [ ] **T0026** — Peygamberler/Vahiy Tarihi için Kur’an, sahih hadis, erken tefsir/tarih, İsrailiyat, sonraki gelenek ve modern tarih/arkeoloji kaynak sınıflarını kesinleştir. **Ref:** SPEC 820–903.
- [ ] **T0027** — Dini gün/gece içerikleri için her başlıkta kaynak doğrulama şablonu oluştur. **Ref:** SPEC 304–319.
- [ ] **T0028** — Zikir/Esmâ/Ebced/Havas için kaynak katmanı kurallarını ve hangi içeriğin kullanıcıya hangi rozetle gösterileceğini kesinleştir. **Ref:** SPEC 252–303, 696–697.
- [ ] **T0029** — Her üçüncü taraf içerik için lisans manifest formatı tanımla: kaynak, sürüm, URL/kimlik, lisans türü, tarih, kanıt, hash. **Ref:** SPEC 523–531.
- [ ] **T0030** — Font lisanslarını kesinleştir: Latin UI, Arabic UI, Kur’an/mushaf fontu. **Ref:** SPEC 98–100, 526, 692.
- [ ] **T0031** — Canva görsel lisans manifest formatını kesinleştir; Pro Content ve Canva-AI içeriğini final reusable asset havuzundan dışla. **Ref:** SPEC 423–426, 527, 691, 811, 919–923 + son kullanıcı kararı.
- [ ] **T0032** — 100 Canva adayın her biri için tek tek Free/Pro, AI-generated durumu, yeniden dağıtım/export uygunluğu ve kaynak kimliği kontrolü yap; uygun olmayanı aynı aileden uygun Canva alternatifiyle değiştir. **Ref:** `CANVA_VISUAL_CANDIDATES.md`, SPEC 919–923.
- [ ] **T0033** — Final 100 Canva asseti sabitle; her dosya için SHA-256 ve lisans kanıtı üret. **Ref:** SPEC 425, 811, 919–923.
- [ ] **T0034** — Privacy Policy taslağı oluştur. **Ref:** SPEC 494–514, 515.
- [ ] **T0035** — Kullanım Koşulları taslağı oluştur. **Ref:** SPEC 516.
- [ ] **T0036** — Dini İçerik Metodolojisi / kaynak sınıflandırma / “fetva değildir” belgesini oluştur. **Ref:** SPEC 5–17, 517, 519–522, 685–686.
- [ ] **T0037** — Kaynaklar ve Lisanslar sayfası veri modelini oluştur. **Ref:** SPEC 171, 518, 523–531.
- [ ] **T0038** — Hedef ülke yayın matrisi taslağını oluştur: Türkiye, EEA, UK, ABD/California, Körfez, Malezya, Endonezya, Pakistan; GREEN/REVIEW/HOLD statüsü. **Ref:** SPEC 534–543.
- [ ] **T0039** — Store hedef yaşını çocuk uygulaması olmayacak şekilde planla; Families/COPPA yoluna yanlışlıkla girmeyi engelle. **Ref:** SPEC 544–548.

**Faz 1 çıkış kriteri:** Kaynağı/lisansı belirsiz hiçbir kutsal metin, meal, hadis, font veya final görsel geliştirmeye girmiyor.

---

# FAZ 2 — BİLGİ MİMARİSİ VE UI/UX PLANLAMA

- [ ] **T0040** — Alt navigasyonu 5 sekme olarak kilitle: **Bugün – Kur’an – Keşfet – Zikir – Ben**. **Ref:** SPEC 56–76, 701.
- [ ] **T0041** — Her özelliğin hangi sekme altında yaşayacağını sitemap olarak çıkar; ana ekrana özellik yığılmasını engelle. **Ref:** SPEC 58–76, 700.
- [ ] **T0042** — Global arama sonuç kategorilerini sabitle: Ayetler / Dualar / Zikirler / Esmâ / Peygamberler / Tarih / Kişiler / Dini Günler. **Ref:** SPEC 69–71.
- [ ] **T0043** — Ana ekran bilgi hiyerarşisini sabitle: Günün Ayeti -> Günün Duası -> Bugün İslam Tarihinde -> 4 hızlı erişim -> Devam Et. **Ref:** SPEC 133–147.
- [ ] **T0044** — Light-first tasarım tokenlarını planla: warm ivory/cream, forest accent, sage auxiliary, minimal gold; AI-dashboard görünümünü yasakla. **Ref:** SPEC 77–102, 704–705, 815.
- [ ] **T0045** — Kart, radius, spacing, typography, icon, divider ve elevation kurallarını yaz; her ekranı aynı yuvarlak kart kalıbına sokma. **Ref:** SPEC 77–96.
- [ ] **T0046** — Latin UI fontu, Arabic UI fontu ve Kur’an fontu için typography scale oluştur. **Ref:** SPEC 98–100, 549–558.
- [ ] **T0047** — Onboarding wireframe: dil seçimi, kısa ürün tanıtımı, kontrollü bildirim açıklaması; hesap/mezhep zorlaması yok. **Ref:** SPEC 123–132.
- [ ] **T0048** — Ana ekran wireframe ve 5 saniye anlaşılabilirlik testi hazırla. **Ref:** SPEC 56–76, 133–147, 703, 706, 816.
- [ ] **T0049** — Kur’an okuyucu wireframe: sure/jüz, reader, meal, kaynak, bookmark, favori, not, search, direct verse jump, share. **Ref:** SPEC 148–191, 707.
- [ ] **T0050** — Keşfet wireframe: Dua, Peygamberler, Tarih, Dini Günler, Konu Ara ve universal search. **Ref:** SPEC 61, 64–71, 708.
- [ ] **T0051** — Dua liste/detay wireframe: kategori, uzunluk, kaynak rozeti, tam dua, favori, paylaş. **Ref:** SPEC 228–251, 711.
- [ ] **T0052** — Zikir wireframe: Sayaç / Zikirler / Niyetime Göre, hedef, titreşim/ses, kaynaklı sayı, kişisel hedef. **Ref:** SPEC 252–271, 709.
- [ ] **T0053** — Esmâ/Ebced rehber wireframe: anlam, dayanak, neden zikredilir, kaynak etiketi, sünnet sayısı vs ebced ayrımı. **Ref:** SPEC 272–303.
- [ ] **T0054** — Peygamberler wireframe: dönem filtreleri, biyografi, kaynak katmanı, ayet/dua/tarih bağlantıları. **Ref:** SPEC 820–903, 712.
- [ ] **T0055** — Vahiy Yolculuğu paralel timeline wireframe: eşzamanlı peygamberler, yaklaşık/bilinmiyor durumları, soy şeması, harita. **Ref:** SPEC 830–877, 713.
- [ ] **T0056** — İslam Tarihi timeline wireframe: dönem, bölge, kişi, bilim/kültür/savaş filtreleri, olay detay ve harita. **Ref:** SPEC 320–389, 714.
- [ ] **T0057** — Konu Ara wireframe: serbest metin, hazır tema, düşük güven netleştirme, 3–5 ayet sonucu, “Bu neden gösterildi?” alanı. **Ref:** SPEC 192–227, 715.
- [ ] **T0058** — Share editor wireframe: 100 background picker, format seçimi, font size safe range, alignment, source locked, rewarded/PRO lock state. **Ref:** SPEC 402–426, 716 + son 100 Canva kararı.
- [ ] **T0059** — Premium Store wireframe: Lifetime PRO, reklam yok, offline, 100 tasarım erişimi, restore; dini doğruluğu paywall arkasına koyma. **Ref:** SPEC 445–493, 717.
- [ ] **T0060** — Ben/Profil wireframe: favoriler, geçmiş, notlar, zikir geçmişi, bildirimler, tema, privacy clear/reset, premium, kaynak/lisans. **Ref:** SPEC 63, 494–514, 710.
- [ ] **T0061** — Tüm wireframe’lerin Arabic RTL versiyonlarını ayrıca çiz ve navigation/icon mirroring kontrolü yap. **Ref:** SPEC 103–122, 718, 808.
- [ ] **T0062** — Wireframe karmaşa testi yap; ana ekran ve Keşfet’te gereksiz tekrar/özellik yığılmasını temizle. **Ref:** SPEC 58, 72–76, 703, 816.

**Faz 2 çıkış kriteri:** Kod başlamadan tüm ana ekranlar ve navigation akışı sabit, light-first ve RTL düşünülmüş.

---

# FAZ 3 — PROJE İSKELETİ, KOD KALİTESİ VE TEMEL ALTYAPI

- [ ] **T0070** — Flutter projesini oluştur; Android ana hedef, iOS taşınabilir mimari. **Ref:** SPEC 36–38, 719.
- [ ] **T0071** — Production package/application ID, flavor yapısı (`dev`, `staging`, `prod`) ve versioning kuralını oluştur. **Ref:** SPEC 36–55, 777–789.
- [ ] **T0072** — Feature-based klasör yapısını kur: quran, dua, dhikr, prophets, history, daily, share, premium, settings, localization, sources. **Ref:** SPEC 55.
- [ ] **T0073** — Router/navigation altyapısını 5 tab ve deep link destekli kur. **Ref:** SPEC 56–76.
- [ ] **T0074** — Theme/design token sistemini kodla; light-first + ücretsiz dark mode. **Ref:** SPEC 77–102, 721.
- [ ] **T0075** — TR/EN/AR locale altyapısını kur; UI hard-coded string lint/check mekanizması ekle. **Ref:** SPEC 103–122, 720.
- [ ] **T0076** — RTL yön, icon mirroring, text direction ve numerals/date formatter altyapısını kur. **Ref:** SPEC 116–121.
- [ ] **T0077** — Yerel içerik DB ile kullanıcı DB’sini ayrı katmanlar olarak tasarla. **Ref:** SPEC 42–47, 722.
- [ ] **T0078** — Hassas kullanıcı DB’si için encryption + Android Keystore anahtar yönetimini kur. **Ref:** SPEC 45–47, 671.
- [ ] **T0079** — `ContentRecord` ortak şemasını oluştur: content_id, type, source_status, review_status, version, last_reviewed_at, reviewer, locale payload, source refs. **Ref:** SPEC 571–589, 723.
- [ ] **T0080** — `UserData` şemasını oluştur: favorites, bookmarks, notes, question history opt-in, dhikr history, settings, entitlement cache. **Ref:** SPEC 45, 160–165, 240–241, 262–264, 503–508, 724.
- [ ] **T0081** — İçerik dataset hash/manifest altyapısını kur. **Ref:** SPEC 52–54, 593, 778.
- [ ] **T0082** — Kritik content corruption halinde dini metni göstermeyen fail-safe state oluştur. **Ref:** SPEC 53–54.
- [ ] **T0083** — Global error, loading, empty-state ve offline-state componentlerini üç dil/RTL uyumlu oluştur. **Ref:** SPEC 107–122, 633–635, 930.
- [ ] **T0084** — Accessibility temel componentleri kur: semantic labels, 44–48dp targets, dynamic text, contrast, reduced motion. **Ref:** SPEC 549–558.
- [ ] **T0085** — Gereksiz permission/SDK eklenmesini engelleyen manifest audit scripti oluştur. **Ref:** SPEC 559, 678–682.

---

# FAZ 4 — KUR’AN VERİ HATTI VE OKUYUCU

- [ ] **T0090** — Lisanslı Arapça Kur’an kaynağını exact version ile projeye import eden pipeline oluştur. **Ref:** SPEC 148–157, 725.
- [ ] **T0091** — 114 sure, sure sırası, ayet sayısı, ayet ID ve jüz metadata doğrulama scriptlerini yaz. **Ref:** SPEC 152–157, 590–595, 726.
- [ ] **T0092** — Kaynak Kur’an metnine otomatik düzeltme uygulanmadığını garanti eden immutable import kuralı oluştur. **Ref:** SPEC 149–151.
- [ ] **T0093** — TR ve EN meal import pipeline’ını oluştur; source ID her ayette zorunlu olsun. **Ref:** SPEC 168–171, 596–598, 727.
- [ ] **T0094** — Kur’an kaynak/lisans ekranını oluştur. **Ref:** SPEC 170–171, 728.
- [ ] **T0095** — Sure listesi ve jüz listesi ekranlarını uygula. **Ref:** SPEC 158–159.
- [ ] **T0096** — Kur’an reader: Arapça asıl + seçili meal + font size + source erişimi. **Ref:** SPEC 114–115, 148–183, 729.
- [ ] **T0097** — Son okunan konum ve local progress persistence. **Ref:** SPEC 160–161.
- [ ] **T0098** — Ayet favorite + bookmark sistemi. **Ref:** SPEC 162–163, 730.
- [ ] **T0099** — Tefekkür notu oluşturma/düzenleme/silme; cihaz dışına çıkmama garantisi. **Ref:** SPEC 164–165, 503, 674.
- [ ] **T0100** — Sure adı, seçili dil anahtar kelime araması ve ayet numarasına direkt gitme. **Ref:** SPEC 172–175.
- [ ] **T0101** — Günün ayetinden doğrudan sure/ayete navigation. **Ref:** SPEC 176.
- [ ] **T0102** — Kur’an içinde banner/interstitial yerleştirilmesini teknik policy ile engelle. **Ref:** SPEC 180–181, 461, 464.
- [ ] **T0103** — Basit Ezber Modu: ayeti gizle/göster/test; mikrofon kullanma. **Ref:** SPEC 187–189.
- [ ] **T0104** — Opsiyonel okuma hedefi altyapısı; suçluluk/FOMO dili kullanma. **Ref:** SPEC 190–191.
- [ ] **T0105** — Kur’an tüm reader akışını TR/EN/AR, dynamic font, düşük RAM ve farklı ekranlarda test et. **Ref:** SPEC 549–570, 590–598, 619, 636.

---

# FAZ 5 — GÜNLÜK MOTOR VE ANA EKRAN

- [ ] **T0110** — Tarihe bağlı deterministik “Günün Ayeti” motoru oluştur. **Ref:** SPEC 134–138, 731.
- [ ] **T0111** — Gün içinde tekrar açılışta aynı ayetin kalmasını test et. **Ref:** SPEC 135–137.
- [ ] **T0112** — Günün Ayeti kartında source, favorite, share ve sureye git eylemlerini uygula. **Ref:** SPEC 138, 176.
- [ ] **T0113** — Tarihe bağlı deterministik “Bugünün Duası” motorunu güvenilir yayın havuzuyla bağla. **Ref:** SPEC 139–141, 246.
- [ ] **T0114** — Uzun dua preview + “Tam Duayı Oku” davranışını uygula. **Ref:** SPEC 140–141, 232–237.
- [ ] **T0115** — “Bugün İslam Tarihinde” motorunu yalnız kesin gün bilgisi olan olaylarla bağla. **Ref:** SPEC 142–144.
- [ ] **T0116** — Maksimum 4 hızlı erişim alanını uygula. **Ref:** SPEC 145–146.
- [ ] **T0117** — Kur’an devam kartını okuma progress varsa koşullu göster. **Ref:** SPEC 147.
- [ ] **T0118** — Ana ekran performansını 1–2 saniye kullanılabilirlik hedefiyle optimize et. **Ref:** SPEC 559–560.

---

# FAZ 6 — DUA KÜTÜPHANESİ

- [ ] **T0120** — Dua veri modelini dört kaynak statüsüyle oluştur: Kur’an / sahih-hasen sünnet / klasik-geleneksel / genel editoryal. **Ref:** SPEC 228–231, 599–601, 732.
- [ ] **T0121** — Dua uzunluklarını kısa/orta/uzun olarak destekle; UI’da metni keyfi kesme. **Ref:** SPEC 232–237.
- [ ] **T0122** — Dua kategori taksonomisini şartnamedeki tüm kategorilerle oluştur. **Ref:** SPEC 238, 695.
- [ ] **T0123** — Her duaya kaynak statüsü, hadis ref/derece, ihtilaf notu zorunluluğu uygula. **Ref:** SPEC 242–245.
- [ ] **T0124** — Genel/editoryal duada “ayet veya hadis değildir” etiketini zorunlu kıl. **Ref:** SPEC 230, 522, 601.
- [ ] **T0125** — Sosyal medyada popüler dua için research -> source verification -> gerekirse general dua olarak yeniden yazım workflow’u kur. **Ref:** SPEC 249–251.
- [ ] **T0126** — Dua search, category filter, favorite ve history özelliklerini uygula. **Ref:** SPEC 239–241, 733.
- [ ] **T0127** — Dini güne özel sahih dua yoksa bunu dürüstçe gösteren state oluştur. **Ref:** SPEC 248, 316.
- [ ] **T0128** — Dua okuma ekranında metin ortasında reklam gösterilemeyeceğini teknik olarak kilitle. **Ref:** SPEC 462.
- [ ] **T0129** — Dua datasetini TR/EN/AR native editorial/religious review’den geçir. **Ref:** SPEC 585–589.

---

# FAZ 7 — ZİKİR MATİK, ZİKİR REHBERİ, ESMÂ VE EBCED

- [ ] **T0130** — Zikir Sayaç ekranını tek büyük dokunma alanı ile uygula. **Ref:** SPEC 252–254, 734.
- [ ] **T0131** — Titreşim ve ses efektini ayrı opt-in ayar yap. **Ref:** SPEC 255–256.
- [ ] **T0132** — Kişisel hedef + hazır hedef + source-backed target veri modelini uygula. **Ref:** SPEC 257–261.
- [ ] **T0133** — Zikir history, günlük toplam, opsiyonel haftalık istatistik ve streak’i local-only uygula. **Ref:** SPEC 262–269.
- [ ] **T0134** — Leaderboard/sosyal karşılaştırma ve suçluluk mesajlarını ürün seviyesinde engelle. **Ref:** SPEC 265–269.
- [ ] **T0135** — Zikir rehberi kaydına Arapça, okunuş, anlam, kaynak, neden zikredilir, sayı, sayı kaynağı alanlarını ekle. **Ref:** SPEC 270–271, 735.
- [ ] **T0136** — “Zikri Başlat” ile rehberden sayaca tek dokunuş geçişini uygula. **Ref:** SPEC 271.
- [ ] **T0137** — Esmâü’l-Hüsnâ rehberini oluştur; Arapça, transliterasyon, ana dil anlamı, Kur’an/hadis bağlantısı. **Ref:** SPEC 272–277, 736.
- [ ] **T0138** — “Niyetime Göre” kategorilerini oluştur: rızık/bereket, sevgi/merhamet, şifa için manevi destek, kolaylık/çıkış yolu vb. **Ref:** SPEC 278–286.
- [ ] **T0139** — Esmâ önerilerinde sonuç garantisini yasakla; yalnız anlam/dayanak bağını göster. **Ref:** SPEC 279–286.
- [ ] **T0140** — Ebced değerini ayrı alan ve ayrı UI rozetiyle göster. **Ref:** SPEC 287–294, 737.
- [ ] **T0141** — Sünnetle sabit sayı ile ebced/havas/geleneksel sayıyı veri ve UI seviyesinde birbirinden ayrı tut. **Ref:** SPEC 291–295, 602–604, 802.
- [ ] **T0142** — “Geleneksel uygulamaları göster” ve “Ebced/havas tarihsel bilgisini göster” ayarlarını tasarla; varsayılan güçlü kaynakları öne çıkar. **Ref:** SPEC 295–298.
- [ ] **T0143** — Vefk/tılsım, aşk bağlama, gayb/kader analizi, isim/doğum tarihi okült analizi yollarını hiç implement etme ve testle yokluğunu doğrula. **Ref:** SPEC 299–303.
- [ ] **T0144** — Zikir sırasında reklam gösterilmediğini tüm Free akışlarında test et. **Ref:** SPEC 463.

---

# FAZ 8 — KUR’AN’DA KONUYA GÖRE ARAMA / CİHAZ İÇİ EŞLEŞTİRME

- [ ] **T0150** — Tema taksonomisini tüm başlangıç temalarıyla oluştur ve uzman incelemesine hazırla. **Ref:** SPEC 213–215, 694.
- [ ] **T0151** — Her temayı manuel doğrulanmış 3–5+ ayet kümeleriyle ilişkilendir. **Ref:** SPEC 215–218, 744.
- [ ] **T0152** — TR normalization pipeline: lowercase, punctuation, Turkish char tolerance, slang/typo dictionary. **Ref:** SPEC 198, 201–204, 739.
- [ ] **T0153** — EN normalization + typo dictionary. **Ref:** SPEC 199, 205, 740.
- [ ] **T0154** — AR normalization: hareke, tatweel, elif varyantları ve RTL-safe preprocessing. **Ref:** SPEC 200, 206–208, 741.
- [ ] **T0155** — Üç dil stop-word listelerini oluştur. **Ref:** SPEC 212.
- [ ] **T0156** — Fuzzy matcher/Levenshtein ve n-gram phrase matching uygula. **Ref:** SPEC 209–211, 742.
- [ ] **T0157** — Theme scoring ve multi-theme sonucu uygula. **Ref:** SPEC 217–220, 743.
- [ ] **T0158** — Low-confidence durumda ayet tahmin etmek yerine tema netleştirme akışı oluştur. **Ref:** SPEC 221, 745.
- [ ] **T0159** — Sonuçta tek kehanet ayeti yerine 3–5 ilgili ayet ve “Bu neden gösterildi?” açıklaması sun. **Ref:** SPEC 222–224.
- [ ] **T0160** — Algoritmanın yeni dini yorum/fetva/karar üretmesini teknik olarak engelle; yalnız theme ID seçsin. **Ref:** SPEC 216–218, 225.
- [ ] **T0161** — Sağlık yüksek-risk sorgularında manevi destek + profesyonel yardım yerine geçmez mesajını uygula. **Ref:** SPEC 226, 520.
- [ ] **T0162** — Kendine zarar ima eden sorgular için güvenli escalation/yardım yönlendirme akışını ayrı güvenlik kuralı olarak uygula. **Ref:** SPEC 227.
- [ ] **T0163** — Ham sorunun hiçbir network/ad/analytics/log yoluna çıkmadığını packet test ile kanıtla. **Ref:** SPEC 196–197, 495–497, 667–670, 804.

---

# FAZ 9 — DİNİ GÜNLER VE GECELER

- [ ] **T0170** — Dini gün/gece ortak content schema oluştur. **Ref:** SPEC 304–306, 746.
- [ ] **T0171** — Kadir Gecesi kapsamlı dosyası. **Ref:** SPEC 307.
- [ ] **T0172** — Ramazan rehberi. **Ref:** SPEC 308.
- [ ] **T0173** — Ramazan Bayramı rehberi. **Ref:** SPEC 309.
- [ ] **T0174** — Kurban Bayramı rehberi. **Ref:** SPEC 310.
- [ ] **T0175** — Arefe rehberi. **Ref:** SPEC 311.
- [ ] **T0176** — Muharrem/Aşure rehberi. **Ref:** SPEC 312.
- [ ] **T0177** — Miraç, Berat, Regaib, Mevlid dosyalarını kaynak statüleri ve gelenek/özel ibadet ayrımıyla oluştur. **Ref:** SPEC 313–316.
- [ ] **T0178** — Kandil terminolojisinin TR/EN/AR yerelleştirme farklarını düzelt. **Ref:** SPEC 314–315.
- [ ] **T0179** — Hicri tarih ülke farklılığı açıklamasını ve tarih source metadata’yı uygula. **Ref:** SPEC 317–319.
- [ ] **T0180** — Dini gün notification açılmadan önce tarih doğrulama kaynağı gerektiren gate oluştur. **Ref:** SPEC 318, 432.

---

# FAZ 10 — PEYGAMBERLER VE VAHİY TARİHİ

- [ ] **T0190** — Peygamberler content schema’sını kaynak sınıfları, tarih certainty, geography, family, ayet refs, dua refs ve timeline ilişkileriyle oluştur. **Ref:** SPEC 820–869, 698, 747.
- [ ] **T0191** — Kur’an’da adı açıkça geçen 25 peygamberin canonical listesini oluştur. **Ref:** SPEC 822–823.
- [ ] **T0192** — Lokman, Üzeyir, Zülkarneyn, Hızır ve Şît gibi ihtilaflı/geleneksel isimleri ayrı statüyle modelle. **Ref:** SPEC 824–829.
- [ ] **T0193** — Ana yaklaşık peygamberlik zincirini oluştur; bilinmeyen tarihe kesin yıl yazma. **Ref:** SPEC 830–834.
- [ ] **T0194** — Her peygamber için TR/EN/AR isim, Kur’an referansları, toplum, coğrafya, dönem, doğum/çocukluk varsa, tebliğ, tepkiler, olaylar, mucizeler, kitap/sahife, dua, vefat ve etki alanlarını doldur. **Ref:** SPEC 835–860.
- [ ] **T0195** — Yahudilik/Hristiyanlık karşılaştırma alanlarını yalnız gerekli yerde, saygılı ve İslami anlatıdan ayrılmış biçimde oluştur. **Ref:** SPEC 861–863.
- [ ] **T0196** — Her bilgi parçasına source class ata: Kur’an / Sahih-Hasen / Erken tarih-tefsir / İsrailiyat / Sonraki gelenek / Modern tarih-arkeoloji / Tartışmalı / Bilinmiyor. **Ref:** SPEC 864–869.
- [ ] **T0197** — Vahiy Yolculuğu timeline’ını paralel dönem desteğiyle uygula. **Ref:** SPEC 870–877, 748.
- [x] **T0198** — Soy/aile ilişkileri şemasını yalnız doğrulanmış ilişkilerle oluştur. **Ref:** SPEC 873, 901.
- [ ] **T0199** — Peygamber coğrafya haritalarında exact/approximate pin ayrımı uygula. **Ref:** SPEC 874–875.
- [ ] **T0200** — Hz. Nuh, Musa/Firavun, İbrahim tarihi, Âdem tarihi ve Hz. İsa tarihsel/İslami katman örneklerinde şartnamedeki ihtiyat kurallarını özel test et. **Ref:** SPEC 878–882.
- [ ] **T0201** — Hz. Muhammed siyeri için ayrıntılı alt kronoloji ve olay bağlantıları oluştur. **Ref:** SPEC 883–884.
- [ ] **T0202** — Peygamber -> Dua, Peygamber -> Ayet, Peygamber -> İslam Tarihi, Peygamber -> Harita deep linklerini uygula. **Ref:** SPEC 885–888, 749.
- [ ] **T0203** — Günün Ayeti peygamber kıssasıysa “Bu kıssayı keşfet” bağlantısını uygula. **Ref:** SPEC 889.
- [ ] **T0204** — “Bugün ne öğrenelim?” için kaynaklı peygamber okuma önerisi alanını oluştur. **Ref:** SPEC 890.
- [ ] **T0205** — Peygamber içeriklerinin TR/EN/AR native review ve isim terminoloji testlerini yap. **Ref:** SPEC 891–894.
- [ ] **T0206** — Her peygamberin Kur’an ref listesi ile ayet DB’sini otomatik çapraz doğrula. **Ref:** SPEC 895–896.
- [ ] **T0207** — Kaynaksız biyografi cümlesi, yanlış kesin tarih, İsrailiyat badge, soy çelişkisi ve timeline çelişkisi QA script/testlerini çalıştır. **Ref:** SPEC 897–903.

---

# FAZ 11 — İSLAM TARİHİ

- [ ] **T0210** — İslam Tarihi dönem ağacını “İslam’dan Önce Dünya” ile başlat. **Ref:** SPEC 320–336, 699, 750.
- [ ] **T0211** — Geç Antik Çağ, Bizans, Sasani, Aksum, Yemen/Güney Arabistan, Mekke, Medine, kabile yapısı, Yahudi/Hristiyan toplulukları ve Arap politeizmi içeriklerini oluştur. **Ref:** SPEC 322–336.
- [ ] **T0212** — Hz. Muhammed dönemi tarih timeline’ını siyer modülüyle tutarlı bağla. **Ref:** SPEC 337–347.
- [ ] **T0213** — Hulefâ-yi Râşidîn ve ilk fitne dönemleri. **Ref:** SPEC 348–349.
- [ ] **T0214** — Emevîler, Abbâsîler, Endülüs, Fâtımîler ve bölgesel hanedanlar. **Ref:** SPEC 350–353.
- [ ] **T0215** — Selçuklular, Haçlılar, Eyyûbîler, Moğollar, Memlükler. **Ref:** SPEC 354–358.
- [ ] **T0216** — Osmanlı, Safevî, Babür dönemleri. **Ref:** SPEC 359–361.
- [ ] **T0217** — Afrika, Orta Asya, Güneydoğu Asya, Hint alt kıtası ve Avrupa İslam tarihini ayrı bölgesel hatlar halinde ekle. **Ref:** SPEC 362–366.
- [ ] **T0218** — Sömürgecilik, modern ulus devletleri, 20. yüzyıl ve günümüze kadar kronoloji. **Ref:** SPEC 367–370.
- [ ] **T0219** — Bilim, tıp, matematik/astronomi, felsefe, hadis/tefsir/fıkıh, sanat/mimari, ticaret/şehir, eğitim ve kadınların tarihsel rolleri yatay temalarını ekle. **Ref:** SPEC 371–380.
- [ ] **T0220** — Her olay kaydında tarih, certainty, öncesi, neden, sonuç, kişiler, coğrafya ve kaynak zorunlu olsun. **Ref:** SPEC 381–383.
- [ ] **T0221** — Dönem/Bölge/Hanedan/Kişi/Bilim/Kültür/Savaş/Dinî gelişme filtrelerini uygula. **Ref:** SPEC 384.
- [ ] **T0222** — Biyografi sayfalarını olay timeline’ına bağla. **Ref:** SPEC 385–386, 752.
- [ ] **T0223** — Telifi uygun local vector historical maps ve approximate/schematic gösterim kuralını uygula. **Ref:** SPEC 387–388.
- [ ] **T0224** — TDV dahil referanslardan izinsiz metin kopyalanmadığını içerik audit ile doğrula. **Ref:** SPEC 389, 530.
- [ ] **T0225** — History verisini lazy load ve cihaz içi index ile performanslı hale getir. **Ref:** SPEC 561–562, 751–754.

---

# FAZ 12 — UNIVERSAL SEARCH VE KEŞFET

- [ ] **T0230** — Cihaz içi search index oluştur. **Ref:** SPEC 70–71, 562, 753.
- [ ] **T0231** — Ayet, Dua, Zikir, Esmâ, Peygamber, Tarih, Kişi ve Dini Gün sonuçlarını tek universal search içinde kategorize et. **Ref:** SPEC 71, 754.
- [ ] **T0232** — Search locale-aware ve Arabic normalization uyumlu olsun. **Ref:** SPEC 103–121, 172–175, 198–212.
- [ ] **T0233** — Search sonuçlarında source/reliability badge uygun içeriklerde görünür olsun. **Ref:** SPEC 16–17, 242–245, 286, 294, 553.

---

# FAZ 13 — PAYLAŞIM MOTORU VE 100 CANVA TASARIM

- [ ] **T0240** — Final lisans filtresinden geçmiş 100 Canva background assetini uygulama asset manifestine ekle. **Ref:** SPEC 402–426, 919–923 + `CANVA_VISUAL_CANDIDATES.md`.
- [ ] **T0241** — Assetleri görsel ailelere göre etiketle; aynı tonda 100 tekrar oluşmasını engelle. **Ref:** SPEC 77–91, 907–910.
- [ ] **T0242** — 9:16 Story/Status, 4:5 Post ve 1:1 layout renderer’ı tamamen cihazda oluştur. **Ref:** SPEC 409, 757–761, 915–918.
- [ ] **T0243** — Dini metni Canva görselinden değil doğrulanmış uygulama DB’sinden runtime render et. **Ref:** SPEC 148–171, 413–415, son Canva kararı.
- [ ] **T0244** — Ayetlerde sure/ayet source satırını kilitli render et; kullanıcı gizleyemesin. **Ref:** SPEC 413–414, 664, 809–810.
- [ ] **T0245** — General Dua etiketini gerekli share cardlarda koru. **Ref:** SPEC 415.
- [ ] **T0246** — Safe font size range ve sınırlı alignment seçenekleri uygula; dini metni edit edilemez yap. **Ref:** SPEC 416–419.
- [ ] **T0247** — Otomatik contrast seçimi ve export öncesi readability check uygula. **Ref:** SPEC 420–422.
- [ ] **T0248** — Uzun ayette küçültme/multi-card çözümü uygula; hiçbir kelime/ayet kaynak bilgisi kesilmesin. **Ref:** SPEC 178–179, 662, 809.
- [ ] **T0249** — Arabic RTL line breaking ve safe area render testlerini uygula. **Ref:** SPEC 121, 663, 913–914.
- [ ] **T0250** — 100 tasarımın her birini 9:16, 4:5, 1:1 ve WhatsApp safe area’da otomatik screenshot/golden testten geçir. **Ref:** SPEC 915–918.
- [ ] **T0251** — Android share sheet ile Instagram Story, WhatsApp Status/Post ve genel paylaşımı gerçek cihazda test et. **Ref:** SPEC 658–661, 817, 932.
- [ ] **T0252** — Reels motion export’u V1 dışı/sonraki sürüm olarak kod seviyesinde ayrı feature flag’te tut; telifli müzik gömme. **Ref:** SPEC 410–412.

---

# FAZ 14 — FREE / PRO, INTERNET GATE, REKLAMLAR VE BILLING

- [ ] **T0260** — FREE ve PRO entitlement state machine’i tasarla. **Ref:** SPEC 445–457.
- [ ] **T0261** — FREE kullanıcı için gerçek internet erişimi doğrulama katmanı kur; yalnız Wi-Fi bağlı flag’ine güvenme. **Ref:** SPEC 453–456.
- [ ] **T0262** — Free app cold-start offline gate uygula. **Ref:** SPEC 455–456.
- [ ] **T0263** — Free online başlayıp interneti sonradan kapatma senaryosunda yeni content geçişinde gate uygula; mevcut ekranı patlatma. **Ref:** SPEC 458, 933.
- [ ] **T0264** — PRO kullanıcının temel content DB’sine offline tam erişimini sağla. **Ref:** SPEC 457, 481, 640.
- [ ] **T0265** — Ad SDK init’i PRO entitlement kontrolünden sonra yap; PRO’da ad request bile oluşmamasını hedefle. **Ref:** SPEC 447–452, 819.
- [ ] **T0266** — PRO geçişinde memory’de loaded banner/interstitial/rewarded varsa dispose et. **Ref:** SPEC 452, 647.
- [ ] **T0267** — FREE ana ekranda uygun reklam yüzeyini uygula; Kur’an/Dua/Zikir kutsal içerik akışlarından uzak tut. **Ref:** SPEC 459–464.
- [ ] **T0268** — Banner/interstitial/rewarded placement policy testleri yaz. **Ref:** SPEC 460–464, 641–647.
- [ ] **T0269** — Rewarded akışı: kullanıcı kilitli Canva tasarımını seçer -> açık ödül metni -> tamamlanınca tanımlı kullanım hakkı. **Ref:** SPEC 465–468, 646, 665.
- [ ] **T0270** — Rewarded cancel/fail/no-fill durumlarında reward verme; dini içeriği bloklama; kullanıcıyı zorla PRO’ya itme. **Ref:** SPEC 459, 467–468, 643–645.
- [ ] **T0271** — 100 tasarım için nihai FREE/Rewarded/PRO erişim matrisi uygula. **Ref:** SPEC 405–408, 655–666 + T0004.
- [ ] **T0272** — Reklam kategori blokları ve düşük max ad content rating ayarlarını yapılandır. **Ref:** SPEC 469–472.
- [ ] **T0273** — Religious/sensitive interest verisini ad personalization’dan kesin çıkar; mümkün olduğunda contextual/non-personalized ads. **Ref:** SPEC 473–475, 513.
- [ ] **T0274** — Google Play Lifetime PRO için non-consumable product ID’yi kesinleştir. **Ref:** SPEC 476–478.
- [ ] **T0275** — Purchase success/cancel/pending state’lerini uygula. **Ref:** SPEC 480, 648–650.
- [ ] **T0276** — Restore purchases akışını uygula. **Ref:** SPEC 479, 651–652, 812.
- [ ] **T0277** — Verified entitlement’i Keystore destekli güvenli cache ederek PRO offline kullanımını sağla. **Ref:** SPEC 480–482, 653.
- [ ] **T0278** — Online olduğunda refund/revoked purchase senaryosunu kontrol edip entitlement güncelle. **Ref:** SPEC 654, 934.
- [ ] **T0279** — Pro ekranında doğru değer önerisini göster: sıfır reklam, offline, 100 tasarım sınırsız, gelişmiş kişiselleştirme; dini truth/source paywall yok. **Ref:** SPEC 486–493 + son 100 görsel kararı.
- [ ] **T0280** — PRO kullanıcının hiçbir banner/interstitial/rewarded/ad request görmediği network+UI testini çalıştır. **Ref:** SPEC 642, 647, 666, 806, 819.

---

# FAZ 15 — BİLDİRİMLER VE WIDGET

- [ ] **T0290** — Notification settings ekranını kategori bazlı opt-in kur. **Ref:** SPEC 427–434.
- [ ] **T0291** — Günün Ayeti local notification. **Ref:** SPEC 429.
- [ ] **T0292** — Günün Duası local notification. **Ref:** SPEC 430.
- [ ] **T0293** — Zikir reminder local notification. **Ref:** SPEC 431.
- [ ] **T0294** — Dini gün reminder’ı yalnız doğrulanmış tarih kaynağı varsa etkinleştir. **Ref:** SPEC 432, 318.
- [ ] **T0295** — Reboot sonrası local schedule restore. **Ref:** SPEC 435–437.
- [ ] **T0296** — FREE offline notification içeriğinin Premium content sızdırmadığını doğrula. **Ref:** SPEC 439–441.
- [ ] **T0297** — Android home widget: Günün Ayeti/Günün Duası; bazı görsel özelleştirmeler PRO olabilir. **Ref:** SPEC 442–444, 756.

---

# FAZ 16 — GİZLİLİK, VERİ MİNİMİZASYONU VE GÜVENLİK

- [ ] **T0300** — Kendi analytics backendini kurma; Firebase Analytics ve marketing SDK’larını varsayılan olarak dışarıda tut. **Ref:** SPEC 498–500.
- [ ] **T0301** — Android Vitals odaklı crash gözlem stratejisi kullan; remote crash SDK varsa text redaction zorunlu. **Ref:** SPEC 501–502.
- [ ] **T0302** — Soru, not, zikir geçmişi ve dini ilgi bilgisinin network, ad, analytics veya debug log’a çıkmadığını instrumented test ile kanıtla. **Ref:** SPEC 494–506, 667–676.
- [ ] **T0303** — Soru history için opt-in/disable tercihi ve tek dokunuş clear history uygula. **Ref:** SPEC 506–507.
- [ ] **T0304** — Tüm local kişisel verileri resetleme işlevini uygula. **Ref:** SPEC 508.
- [ ] **T0305** — Android Auto Backup’ta hassas soru/not DB’sinin istemeden buluta çıkmasını engelle/konfigüre et. **Ref:** SPEC 509, 672.
- [ ] **T0306** — Location, microphone, camera, contacts permission istemediğini manifest ve runtime’da doğrula. **Ref:** SPEC 510–511, 678–682.
- [ ] **T0307** — Clipboard ve share pipeline’da kişisel notların yanlışlıkla export edilmediğini test et. **Ref:** SPEC 673–674.
- [ ] **T0308** — Release build debug loglarını kapat; secret/API key audit yap. **Ref:** SPEC 675–677.

---

# FAZ 17 — ERİŞİLEBİLİRLİK, PERFORMANS VE CİHAZ MATRİSİ

- [ ] **T0310** — System font scaling ile tüm ekranları test et; uzun meal/dua kesilmesin. **Ref:** SPEC 549–550.
- [ ] **T0311** — Screen reader semantics ve ikon text labels ekle. **Ref:** SPEC 551–553.
- [ ] **T0312** — 44–48dp dokunma alanı ve contrast audit. **Ref:** SPEC 554–555.
- [ ] **T0313** — Reduced motion desteği. **Ref:** SPEC 556.
- [ ] **T0314** — Küçük ekranda Arapça hareke ve bağımsız Kur’an font size testleri. **Ref:** SPEC 557–558.
- [ ] **T0315** — Cold start ve ana ekran kullanılabilirlik performans profilini çıkar; gereksiz SDK’ları kaldır. **Ref:** SPEC 559–560.
- [ ] **T0316** — History lazy load ve search index memory/performance testleri. **Ref:** SPEC 561–562.
- [ ] **T0317** — 100 Canva asset için WebP/AVIF/uygun lossless-lossy pipeline belirle; dini metin görsele bake edilmesin. **Ref:** SPEC 563–565 + son 100 asset kararı.
- [ ] **T0318** — Tam audio library’yi V1 bundle’a gömme. **Ref:** SPEC 184–186, 566.
- [ ] **T0319** — Düşük RAM cihaz, farklı Android oranları, tablet ve orientation test matrisi çalıştır. **Ref:** SPEC 567–570.

---

# FAZ 18 — OPSİYONEL EĞİTİM MODÜLLERİ (CORE TAMAMLANDIKTAN SONRA)

- [ ] **T0320** — Hac & Umre sunucusuz eğitsel rehberini ancak core release scope tamamlandıktan sonra değerlendir; canlı fiyat/uçuş/tur yok. **Ref:** SPEC 392–393.
- [ ] **T0321** — Korunma/Sahih Rukye rehberini dini ve tıbbi güvenlik review sonrası değerlendir; cin teşhisi/tedavi alternatifi yok. **Ref:** SPEC 394–396.
- [ ] **T0322** — Oruç Günlüğü: manuel işaretleme; sahur/iftar hesaplama yok. **Ref:** SPEC 397–399.
- [ ] **T0323** — Namaz Günlüğü: yalnız manuel takip; vakit hesaplama yok. **Ref:** SPEC 400–401.

---

# FAZ 19 — OTOMATİK QA VE İÇERİK DOĞRULAMA

- [ ] **T0330** — 114 sure varlığı, ayet sayısı, sure ID, source hash, Arabic character/waqf doğrulama test suite’i. **Ref:** SPEC 590–595.
- [ ] **T0331** — TR/EN meal bütünlük + source ID tests. **Ref:** SPEC 596–598.
- [ ] **T0332** — Dua source required, hadith authenticity metadata, general dua mislabel testleri. **Ref:** SPEC 599–601.
- [ ] **T0333** — Zikir source/sayı ve ebced-sünnet ayrım testleri. **Ref:** SPEC 602–604.
- [ ] **T0334** — Dataset yasak claim tarayıcısı: kesin para/şifa/aşk, Allah’ın kişisel cevabı vb. **Ref:** SPEC 605–606.
- [ ] **T0335** — Dini gün özel dua ve tarih certainty audit. **Ref:** SPEC 607–608.
- [ ] **T0336** — Peygamber biography source/date/Israiliyat/family/timeline audit. **Ref:** SPEC 895–903.
- [ ] **T0337** — Tarih olayları çift kaynak/tartışmalı anlatı audit’i. **Ref:** SPEC 583–584, 608.
- [ ] **T0338** — Content publication state test: approved olmayan hiçbir kayıt production dataset’e girmesin. **Ref:** SPEC 571–589.

---

# FAZ 20 — TR / EN / AR TAM DİL VE RTL TESTİ

- [ ] **T0340** — TR UI full crawl ve sızıntı taraması. **Ref:** SPEC 609, 618–636.
- [ ] **T0341** — EN UI full crawl ve sızıntı taraması. **Ref:** SPEC 610, 618–636.
- [ ] **T0342** — AR UI full crawl ve RTL audit. **Ref:** SPEC 611, 616–617, 622, 636, 808.
- [ ] **T0343** — TR->EN, TR->AR, EN->TR, EN->AR, AR->TR, AR->EN yönlü leakage testleri. **Ref:** SPEC 612–617.
- [ ] **T0344** — Ana ekran / Kur’an / Dua / Zikir / Peygamber / Tarih / Dini Gün / Konu Ara / Premium / Ads / Billing / Offline / Notification / Widget / Share / Empty / Error / Permission tümünde üç dil snapshot+functional test. **Ref:** SPEC 618–636.
- [ ] **T0345** — Native TR editorial final pass. **Ref:** SPEC 588, 780.
- [ ] **T0346** — Native EN editorial final pass. **Ref:** SPEC 587, 781.
- [ ] **T0347** — Native AR editorial + RTL final pass. **Ref:** SPEC 586, 782.

---

# FAZ 21 — MONETİZASYON, OFFLINE VE PAYLAŞIM GERÇEK CİHAZ QA

- [ ] **T0350** — Free online happy-path. **Ref:** SPEC 637.
- [ ] **T0351** — Free cold-start offline blocked. **Ref:** SPEC 638, 805.
- [ ] **T0352** — Free online -> internet kapat -> navigation/content gate davranışı. **Ref:** SPEC 458, 933.
- [ ] **T0353** — PRO online happy-path ve zero ads. **Ref:** SPEC 639, 642.
- [ ] **T0354** — PRO offline full core access. **Ref:** SPEC 640.
- [ ] **T0355** — Free ad placement görünürlük ve kutsal içerik yasak yüzeyleri testi. **Ref:** SPEC 641, 460–464.
- [ ] **T0356** — Rewarded success/cancel/network fail/no-fill. **Ref:** SPEC 643–646.
- [ ] **T0357** — Reward tamamlanınca yalnız doğru entitlement/use token verilmesi. **Ref:** SPEC 646, 665.
- [ ] **T0358** — Purchase success/cancel/pending/restore/reinstall/cached entitlement/refund-revoke matrix. **Ref:** SPEC 648–654, 934.
- [ ] **T0359** — 100 görsel erişim kilit matrisi Free/Rewarded/PRO testleri. **Ref:** SPEC 655–666 + son 100 asset kararı.
- [ ] **T0360** — Story 9:16 gerçek dosya export + Instagram/WhatsApp hedef paylaşım. **Ref:** SPEC 658–659, 817, 932.
- [ ] **T0361** — Post 4:5 ve 1:1 gerçek export. **Ref:** SPEC 660–661.
- [ ] **T0362** — Uzun ayet, Arabic RTL ve source-lock gerçek export testleri. **Ref:** SPEC 662–664, 809–810.
- [ ] **T0363** — PRO 100 tasarımın hiçbirinde rewarded/ad path’e düşmeme testi. **Ref:** SPEC 666, 819.

---

# FAZ 22 — GİZLİLİK / NETWORK / SECURITY RELEASE AUDIT

- [ ] **T0370** — Soru yazarken packet capture yap; raw text sıfır network. **Ref:** SPEC 667–670, 804.
- [ ] **T0371** — Ads request payload’da dini tema/question text olmadığına bak. **Ref:** SPEC 668, 670.
- [ ] **T0372** — Analytics/crash/log içinde sensitive text olmadığını doğrula. **Ref:** SPEC 669, 675–676.
- [ ] **T0373** — DB encryption, backup, clipboard, export leak testleri. **Ref:** SPEC 671–674.
- [ ] **T0374** — Release APK/AAB manifest permission audit. **Ref:** SPEC 677–682.

---

# FAZ 23 — LEGAL / STORE / ÜLKE YAYIN HAZIRLIĞI

- [ ] **T0380** — Privacy Policy’yi gerçek app davranışıyla satır satır eşleştir. **Ref:** SPEC 515, 813.
- [ ] **T0381** — Terms of Use final. **Ref:** SPEC 516.
- [ ] **T0382** — Dini İçerik Metodolojisi ve Not a Fatwa açıklaması final. **Ref:** SPEC 517, 519.
- [ ] **T0383** — Sources & Licenses ekranı final; Kur’an/meal/hadith/font/Canva manifestleri görünür. **Ref:** SPEC 518, 523–531.
- [ ] **T0384** — Tıbbi/finansal disclaimer yalnız gerekli ekranlarda doğru yerleşsin. **Ref:** SPEC 520–521.
- [ ] **T0385** — “Diyanet onaylı / resmî / QF approved” gibi yetkisiz endorsement metinlerini global taramada sıfırla. **Ref:** SPEC 532, 814.
- [ ] **T0386** — Store screenshot/copy’de yanlış dini alıntı veya misleading Premium iddiası olmadığını doğrula. **Ref:** SPEC 533, 794.
- [ ] **T0387** — Ülke bazlı GREEN/REVIEW/HOLD yayın matrisini güncel hukuk kontrolüyle finalleştir. **Ref:** SPEC 534–543, 796.

---

# FAZ 24 — RELEASE CANDIDATE VE FİNAL KAPILARI

- [ ] **T0390** — UI consistency audit. **Ref:** SPEC 774, 815–816.
- [ ] **T0391** — Accessibility audit. **Ref:** SPEC 775.
- [ ] **T0392** — Performance/stress audit. **Ref:** SPEC 776.
- [ ] **T0393** — Security/network audit. **Ref:** SPEC 772.
- [ ] **T0394** — Monetization audit. **Ref:** SPEC 773.
- [ ] **T0395** — Religious content full pass. **Ref:** SPEC 771, 779, 797–803.
- [ ] **T0396** — 100 Canva asset license/hash full pass. **Ref:** SPEC 811, 919–923 + latest decision.
- [ ] **T0397** — Release Candidate build oluştur. **Ref:** SPEC 777.
- [ ] **T0398** — RC content dataset hash’i sabitle ve kaydet. **Ref:** SPEC 778.
- [ ] **T0399** — Android internal test dağıtımı yap. **Ref:** SPEC 784.
- [ ] **T0400** — Closed beta çalıştır. **Ref:** SPEC 785.
- [ ] **T0401** — Beta buglarını dini içerik > privacy/security > monetization > crash > UI önceliğinde sınıflandır. **Ref:** SPEC 786–788.
- [ ] **T0402** — Kırmızı dini doğruluk/dil/privacy hatası varsa release’i durdur. **Ref:** SPEC 787–788.
- [ ] **T0403** — Final AAB ve gerekiyorsa APK üret; gerçekten açıldığını ve yüklenebildiğini doğrula. **Ref:** SPEC 789, 940–941.
- [ ] **T0404** — Final AAB/APK exact SHA-256 kaydet. **Ref:** SPEC 789, 940.
- [ ] **T0405** — Store listing TR final. **Ref:** SPEC 790.
- [ ] **T0406** — Store listing EN final. **Ref:** SPEC 791.
- [ ] **T0407** — Store listing AR final. **Ref:** SPEC 792.
- [ ] **T0408** — Store screenshots TR/EN/AR final. **Ref:** SPEC 793.
- [ ] **T0409** — Privacy URL ve legal URLs erişilebilirlik testi. **Ref:** SPEC 795.
- [ ] **T0410** — İlk ülke grubunu yalnız yayın matrisi izin veriyorsa aç. **Ref:** SPEC 796.
- [ ] **T0411** — `FINAL` kelimesini ancak SPEC + TODO + TEST_MATRIX içinde kırmızı açık kalmadığında kullan. **Ref:** SPEC 942.

---

# TAMAMLAMA KANITI STANDARDI

Her `[x]` işaretlenen görev için uygun olan kanıtlardan en az biri eklenmelidir:

- unit/integration/widget test adı ve sonucu,
- gerçek cihaz test kaydı,
- screenshot/screen recording,
- dataset/hash raporu,
- network capture sonucu,
- lisans/attribution kaydı,
- build SHA / artifact SHA,
- manual religious/editorial review kaydı,
- store/billing sandbox sonucu.

**Ref:** SPEC 924–942.

---

# ŞARTNAME KAPSAM MATRİSİ

Bu TODO aşağıdaki şartname kapsamlarını bilinçli olarak karşılar:

| SPEC aralığı | TODO fazları |
|---|---|
| 1–35 | Faz 0 |
| 36–55 | Faz 3 |
| 56–76 | Faz 2–3 |
| 77–102 | Faz 2–3, 13 |
| 103–122 | Faz 2–3, 20 |
| 123–147 | Faz 2, 5 |
| 148–191 | Faz 4, 13 |
| 192–227 | Faz 8, 16, 22 |
| 228–251 | Faz 6 |
| 252–286 | Faz 7 |
| 287–303 | Faz 7 |
| 304–319 | Faz 9 |
| 320–389 | Faz 11 |
| 390–401 | Faz 10, 18 |
| 402–426 | Faz 1, 2, 13 |
| 427–444 | Faz 15 |
| 445–493 | Faz 14, 21 |
| 494–514 | Faz 16, 22 |
| 515–543 | Faz 1, 23 |
| 544–548 | Faz 1 |
| 549–570 | Faz 3, 17 |
| 571–589 | Faz 1, 3, 19 |
| 590–608 | Faz 4, 6, 7, 9, 19 |
| 609–636 | Faz 20 |
| 637–666 | Faz 14, 21 |
| 667–682 | Faz 16, 22 |
| 683–796 | Faz 0–24 kronolojik yürütme |
| 797–819 | Faz 0, 21–24 release gates |
| 820–903 | Faz 10 |
| 904–923 | Faz 1, 13 + 100 Canva delta |
| 924–942 | TODO yönetimi ve Faz 24 |

---

# GELİŞTİRME BAŞLAMA KURALI

Kodlamaya başlamadan önce **Faz 0, Faz 1'in kritik lisans/kaynak maddeleri ve Faz 2 wireframe/bilgi mimarisi** tamamlanacaktır. Böylece uygulama geliştirilirken ekranlar sonradan birbirine eklenip dağınık hale gelmeyecek.

İlk teknik implementasyon sırası: **Faz 3 -> Faz 4 -> Faz 5 -> Faz 6 -> Faz 7 -> Faz 8 -> Faz 9 -> Faz 10 -> Faz 11 -> Faz 12 -> Faz 13 -> Faz 14 -> Faz 15 -> Faz 16 -> Faz 17 -> QA/Release fazları.**
