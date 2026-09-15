# T0216 — Osmanlı, Safevî ve Babür dönemleri

## Amaç

Bu belge T0216 için araştırma, veri modeli ve QA sözleşmesini kaydeder. İçerik production onayı değildir. `lib/features/history/data/early_modern_ottoman_safavid_mughal.dart` içindeki bütün kayıtlar `researchDraft` durumundadır; factual editorial review ve gerçek TR/EN/AR native review kanıtı olmadan production içeriğine terfi ettirilemez.

## Paralel tarih hattı kararı

Osmanlı, Safevî ve Babür siyasi yapıları özellikle 16. ve 17. yüzyıllarda eşzamanlıdır. T0216 bu nedenle üç ayrı track kullanır: `ottoman`, `safavid`, `mughal`. Validator farklı track'lerin tarih bakımından örtüşmesine izin verir; aynı track içindeki kronolojinin geriye gitmesini reddeder. Böylece erken modern İslam tarihi sahte bir tek ardışık hanedan zincirine dönüştürülmez.

## Kaynak bağımsızlığı

Her çekirdek kayıt en az iki bağımsız akademik çalışma ailesi ister. Aynı eserin iki locator'ı iki bağımsız kaynak sayılamaz; `workFamilyId` bunu fail-closed engeller.

Kullanılan araştırma aileleri:

- Suraiya N. Faroqhi ve Kate Fleet (ed.), *The Cambridge History of Turkey*, Volume 2 — DOI `10.1017/CHO9781139049047`.
- Colin Imber, *The Ottoman Empire, 1300–1650: The Structure of Power*, 3. bs., Bloomsbury Academic — ISBN `9781352004137`.
- *The Cambridge History of Iran*, Volume 6, Safevî dönem bölümleri.
- Andrew J. Newman, *Safavid Iran: Rebirth of a Persian Empire*, I.B. Tauris — ISBN `9781845118303`.
- John F. Richards, *The Mughal Empire*, The New Cambridge History of India — DOI `10.1017/CBO9780511584060`.
- Catherine B. Asher ve Cynthia Talbot, *India before Europe* — DOI `10.1017/CBO9780511808586`.

## Certainty ve tarafsız anlatım

- Osmanlı başlangıcı `1300` yaklaşık öğretici sınırdır; tek ve tartışmasız bir “kuruluş günü/yılı” gibi gösterilmez. 1922 saltanatın kaldırılmasıdır; imparatorluğun çözülmesi daha uzun bir süreçtir.
- Safevîler için 1501 güçlü hanedan başlangıç sınırıdır. 1722 İsfahan'ın düşüşü kritik kırılmadır; 1736 Nâdir Şah'ın tahta çıkışı hanedan çizgisinin sonu için kullanılan yaygın sınırdır. Bu nedenle kayıt `broadPeriod` caveat'i taşır.
- Babürler için 1526 temel hanedan başlangıcıdır. 18. yüzyıldaki merkezî güç kaybı nedeniyle 1858'e kadar devam, aynı siyasî kapasitenin kesintisiz sürdüğü anlamına gelmez.
- Osmanlı–Safevî rekabeti mezhepsel tek nedenli çatışma gibi sunulmaz; siyaset, sınır, hanedan meşruiyeti ve dinî kimlik birlikte değerlendirilir.

## Failure-path kanıtı

`test/features/history/early_modern_ottoman_safavid_mughal_test.dart` şu davranışları doğrular:

- üç zorunlu track ve üç çekirdek kayıt vardır;
- Osmanlı/Safevî/Babür eşzamanlılığı korunur;
- bütün kayıtlar editorial/native review öncesi production dışında kalır;
- aynı work-family iki bağımsız kaynak gibi kullanılamaz;
- bilinmeyen source ID reddedilir;
- zorunlu track eksikse dataset reddedilir;
- broad/contested tarihlemede eksik TR/EN/AR caveat reddedilir;
- cross-track overlap kabul edilirken aynı track chronology drift reddedilir.

## TEST_MATRIX durumu

T0216 D12'nin tarih kapsamını ve otomatik iki-kaynak/certainty enforcement'ini ilerletir; D12'yi PASS yapmaz. T0211–T0216 içeriklerinin factual editorial review, certainty doğrulaması ve gerçek TR/EN/AR native insan review kanıtları tamamlanmadan D12/D14 TODO kalmalıdır.
