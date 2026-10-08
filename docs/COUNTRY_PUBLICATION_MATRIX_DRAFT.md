# İSLAMİ HAYAT — ÜLKE/BÖLGE YAYIN MATRİSİ (T0038, TASLAK)

**İnceleme tarihi:** 2026-10-08 (Europe/Istanbul)
**Kapsam:** SPECIFICATION.md 534–543; SPECIFICATION_V1_2_DELTA.md; yalnız Android V1, TR/EN/AR, Kur’an + meal + dua + zikir + tarih + paylaşım, Free/PRO, rewarded reklam, Google Play Billing.
**Statü:** Hukuki/mağaza/kurumsal yayın uygunluk kararı DEĞİLDİR. Ülke hedefleme, mağaza yayını ve production signing için ayrıca karar gerekir.

## Durum sözlüğü ve release kapısı

- **GREEN:** Ülke için içerik/telif, veri koruma, reklam, ödeme, mağaza beyanı ve gerekiyorsa dinî metin yayımlama koşulları güncel kanıtla tek tek incelenmiş; gerekli izinler yazılı; release sahibi onay vermiştir. Bu taslakta GREEN yoktur.
- **REVIEW:** İnceleme yolu tanımlanmış, fakat hukuki/operasyonel delil veya mağaza uygulama kanıtı eksiktir; **yayına izin vermez**.
- **HOLD:** Özellikle belirsiz izin/onay, dinî metin yayımlama veya yerel uyum riski vardır; yazılı yerel değerlendirme ve gerekli izinler olmadan ülke hedeflemesi kapalı kalır.
- Her satırın **mevcut statüsü release izni değildir**. Google Play onayı, dinî/yerel mevzuata uygunluğun kanıtı sayılmaz. Hukuk görüşü olmadan REVIEW/HOLD -> GREEN yapılamaz.

## İlk yayın matrisi

| Pazar | Taslak durum | Somut kontrol / açık kanıt | GREEN'e geçiş şartı |
|---|---|---|---|
| **Türkiye** | **REVIEW** | KVKK/SDK veri akışları, reklam ve satın alma beyanları; Kur’an/meal telifi ve kaynak atfı; resmî kurum onayı ima etmeyen store copy; tüketici ve dijital ürün koşulları. | Veri akış audit + TR privacy/terms + lisans/re-export kanıtı + mağaza formları + gerekli yerel hukuk değerlendirmesi. |
| **Avrupa Ekonomik Alanı (EEA)** | **REVIEW** | GDPR'nin ülke dışından AB kişilerine hizmet sunumunda uygulanabilirliği; reklam SDK/cihaz tanımlayıcısı, rıza/şeffaflık, yaş hedefi ve mağaza beyanı; ülke bazlı farklılıklar. | EEA veri işleme envanteri ve hukuki dayanak/notice/SDK testleri, tüketici/ödeme yükümlülükleri ve ülke kapsamı ayrı onay. |
| **Birleşik Krallık (UK)** | **REVIEW** | UK GDPR / ICO yaklaşımı, reklam ve uygulama içi ödeme akışları, store disclosure ve yaş hedefi. EEA onayı UK onayı yerine geçmez. | UK'ye özgü veri koruma, tüketici/ödeme ve içerik/telif değerlendirmesi; test edilmiş store beyanı. |
| **ABD / California** | **REVIEW** | COPPA/Families hedef kitle riski, California gizlilik mevzuatının somut işletme/işleme modeline uygulanabilirliği, reklam SDK ve billing/refund akışı. California ve diğer eyaletler tek hukuk alanı değildir. | Uygulanabilirlik analizi, SDK/veri akışı kanıtı, doğru age/store formları, satış/iade beyanı ve hukuk kontrolü. |
| **Körfez (Suudi Arabistan, BAE, Katar, Kuveyt, Bahreyn, Umman)** | **HOLD** | Altı ülke **ayrı ayrı** ele alınacak: dinî metin yayımı/izin, dijital içerik ve reklam kuralları, veri koruma, uygulama içi ödeme, yerel mağaza kısıtları. Ortak GCC statüsü toplu izin değildir. | Her ülke için yetkili otorite ve mevzuat kaynağı, gerekiyorsa yazılı izin, lokal hukuk incelemesi ve ayrı store availability kararı. |
| **Malezya** | **HOLD** | JAKIM, KDN/LPPPQ ve 1986 Al-Quran Printing of Text Act (Act 326) çerçevesi araştırılmalı; resmî JAKIM sayfası Smart Quran'ı kurul onaylı mobil uygulama olarak tanımlar. Bu örnek **bizim uygulamaya otomatik izin veya aynı yükümlülüğün kesin uygulandığına dair hukuki hüküm değildir**. Dijital uygulama için güncel yazılı yönlendirme gerekli. | KDN/LPPPQ'den uygulamaya özgü resmî kapsam/izin cevabı, mushaf/meal QA, yerel hukuk görüşü ve mağaza onayı. |
| **Endonezya** | **HOLD** | Kemenag/LPMQ'nin resmî Kur’an uygulaması ve tashih (metin kontrol) süreçleri var. Üçüncü taraf dijital mushaf için hangi onay/yetkinin gerektiği bu taslakta doğrulanmış değildir. | LPMQ/Kemenag'dan güncel üçüncü taraf dijital yayım prosedürü, gerekiyorsa tashih/izin ve lisans/mağaza incelemesi. |
| **Pakistan** | **HOLD** | Federal ve eyalet bazlı dinî metin yayımı, dijital içerik, gizlilik ve ödeme koşulları için güncel yetkili kaynak/yerel hukuk incelemesi henüz yok. Bu boşluk 'izin gerekmiyor' anlamına gelmez. | Yetkili makam/mevzuat eşlemesi, gerekliyse izinler ve mağaza/SDK/billing incelemesi. |

## Bağımsız, zorunlu çapraz kapılar (her pazar için)

1. **Kutsal metin / kaynak:** Tanzil exact-byte 114 sure/6236 ayet ve QuranEnc TR/EN exact-source testleri CI'da geçse de lisansın ilgili kullanım/ülke/yeniden dağıtım hakkı ayrıca kanıtlanmalı. Diyanet, JAKIM, Kemenag vb. kurumlardan yazılı onay yoksa 'onaylı/resmî' denmez.
2. **100 Canva görseli:** T0032/T0033 bitmeden hiçbir Canva adayı final reusable APK asseti sayılmaz. Her birinin kaynak ID, Free/Pro, AI durumu, bağımsız yeniden dağıtım ve tekrar export izni, lisans kanıtı ve SHA-256 kaydı gerekir.
3. **Gerçek davranış:** Free/PRO offline, rewarded success/cancel/no-fill, billing purchase/restore/refund, paylaşım 9:16/4:5/1:1, TR/EN/AR RTL ve farklı cihaz/orientation testleri TEST_MATRIX'te PASS olmadan yayın yok.
4. **Gizlilik:** SDK/analytics/reklam/billing gerçek network audit, hassas not ve soru verisi, yerel şifreleme, backup, izinler, privacy policy/terms ve Play Data safety formu aynı release binary'si üzerinde doğrulanmalı.
5. **Yaş / tüketici:** V1 çocuklara pazarlanmaz; ancak hedef yaş gerçek içerik ve pazarlama ile tutarlı beyan edilir. Google Play Families/COPPA, yerel iade/tüketici ve vergi/ödeme kuralları ayrıca değerlendirilir.
6. **Operasyon:** Pazar bazlı sorumlu, inceleme tarihi, kaynak URL/versiyon, yazılı izin veya hukuk görüşü, karar veren, store availability ayarı, final APK/AAB hash ve imzalı karar kaydı olmadan GREEN yok.
7. **Fail-closed:** Belirsiz mevzuat, lisans, dinî içerik, locale, mağaza veya entitlement durumunda pazarı HOLD'a indir; mevcut çalışan route/storage/asset mimarisini bunun için değiştirme.

## Resmî başlangıç kaynakları (uyum/izin belgesi değil)

- Avrupa Komisyonu, GDPR kapsamı: https://commission.europa.eu/law/law-topic/data-protection/information-business-and-organisations/application-gdpr_en
- Google Play Console, çocuklar/aileler ve hedef kitle: https://play.google.com/intl/en-GB_ALL/console/about/programs/families/
- Malezya JAKIM, Smart Quran ve kurul onayı örneği: https://www.islam.gov.my/ms/quran-hadith/smart-quran
- Malezya KDN rehberi (Kur’an metni yayımlama lisansı): https://www.mygp.gov.my/garis-panduan-permohonan-lesen-mencetak-teks-al-quran
- Endonezya Kemenag resmî Kur’an uygulaması: https://quranindonesia.kemenag.go.id/
- Endonezya LPMQ, tashih sürecinde uzman doğrulaması: https://lajnah.kemenag.go.id/info-lpmq/berita-dan-artikel/berita/finalisasi-pengembangan-aplikasi-tashih-mushaf-al-qur%E2%80%99an-otomatis-teknologi-terdepan-dalam-pengecekan-tashih-secara-instan.html

**Açık kanıt:** Türkiye, UK, California, altı Körfez ülkesi ve Pakistan için bu taslakta doğrulanmış güncel ülkeye özgü resmî karar/izin listesi bulunmuyor; bunlar sonraki hukuki araştırmanın açık kalemleridir. Kaynakların yayımlanma tarihi ile bu taslağın inceleme tarihi aynı değildir. Ülke statüleri yalnız risk-temelli iç taslak sınıflandırmadır.

**Sonuç:** T0038'in **taslak oluşturma** kapsamı tamamlandı; hiçbir ülkenin yayın onayı, store rollout veya TEST_MATRIX release PASS'i tamamlanmış sayılmaz.
