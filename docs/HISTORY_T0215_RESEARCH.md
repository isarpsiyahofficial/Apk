# T0215 — Selçuklular, Haçlı Seferleri, Eyyûbîler, Moğollar ve Memlükler

## Amaç

Bu belge T0215 için araştırma, veri modeli ve QA sözleşmesini kaydeder. İçerik production onayı değildir. `lib/features/history/data/high_medieval_seljuq_crusades_mamluks.dart` içindeki kayıtların tamamı `researchDraft` durumundadır; factual editorial review ve gerçek TR/EN/AR native review kanıtı olmadan production içeriğine terfi ettirilemez.

## Paralel tarih hattı kararı

T0215 tek bir düz çizgi gibi modellenmez. Selçuklu kolları, Haçlı seferleri ve Latin siyasi varlıkları, Eyyûbîler, Moğol istilaları ve Memlükler belirli dönemlerde birbirleriyle zaman bakımından örtüşür. Veri modeli bu nedenle beş paralel track kullanır:

- `seljuq`
- `crusades`
- `ayyubid`
- `mongol`
- `mamluk`

Validator farklı track'lerin zaman bakımından örtüşmesine izin verir; aynı track içindeki kayıtların geriye doğru gitmesini reddeder. Böylece tarihsel eşzamanlılık sahte bir ardışık zincire dönüştürülmez.

## Kaynak bağımsızlığı

Her kayıt en az iki ayrı akademik çalışma ailesine dayanmak zorundadır. Aynı monografinin veya aynı edit edilmiş eserin iki farklı locator kaydı iki bağımsız kaynak sayılmaz; `workFamilyId` bu durumu fail-closed engeller.

Ana araştırma aileleri:

- C. E. Bosworth, “The Political and Dynastic History of the Iranian World (A.D. 1000–1217)”, *The Cambridge History of Iran*, vol. 5.
- Michael Brett, “Abbasids, Fatimids and Seljuqs”, *The New Cambridge Medieval History* — DOI `10.1017/CHOL9780521414111.026`.
- Anne-Marie Eddé, “Bilād al-Shām, from the Fāṭimid conquest to the fall of the Ayyūbids (970–1260)”, *The New Cambridge History of Islam* — DOI `10.1017/CHOL9780521839570.008`.
- Carole Hillenbrand, *The Crusades: Islamic Perspectives*, Edinburgh University Press.
- Yaacov Lev, “The Fāṭimid caliphate (969–1171) and the Ayyūbids in Egypt (1171–1250)”, *The New Cambridge History of Islam* — chapter DOI `10.1017/CHOL9780521839570.009`.
- R. Stephen Humphreys, *From Saladin to the Mongols: The Ayyubids of Damascus, 1193–1260*.
- Peter Jackson, “The rule of the infidels: the Mongols and the Islamic world”, *The New Cambridge History of Islam* — DOI `10.1017/CHOL9780521850315.006`.
- Michal Biran, “The Mongol Empire and inter-civilizational exchange”, *The Cambridge World History* — DOI `10.1017/CBO9780511667480.021`.
- Amalia Levanoni, “The Mamlūks in Egypt and Syria”, *The New Cambridge History of Islam* — DOI `10.1017/CHOL9780521839570.010`.
- Carl F. Petry, *The Mamluk Sultanate: A History*, Cambridge University Press, 2022 — DOI `10.1017/9781108557382`.

## Certainty ve tarafsız anlatım

Geniş tarih aralıkları kesin devlet başlangıç/bitiş tarihi gibi sunulmaz. `broadPeriod` veya `contestedInterpretation` kayıtları TR/EN/AR caveat olmadan geçemez.

Özellikle:

- 1037–1194 Büyük Selçuklu merkezî hanedan çizgisini özetleyen geniş bir çerçevedir; tüm Selçuklu kolları aynı tarihlerde başlayıp bitmiş sayılmaz.
- 1095–1291 Haçlı seferleri ve Levant'taki başlıca Latin siyasi varlıklar için öğretici geniş çerçevedir; tek kesintisiz savaş veya tek taraflı dinî anlatı değildir.
- 1219–1260 Moğol istilalarının büyük ilk dalgalarını sınırlar; Moğol/İlhanlı hâkimiyetinin bütün bölgelerde 1260'ta bittiği anlamına gelmez.
- Eyyûbî 1171–1250 kaydı özellikle Mısır sultanlığına göre tarihlenir; Suriye'deki Eyyûbî kollarının daha sonraki varlığı ayrı tarihsel bağlamdır.

## Failure-path kanıtı

`test/features/history/high_medieval_seljuq_crusades_mamluks_test.dart` şu davranışları doğrular:

- zorunlu beş track ve beş çekirdek kayıt bulunur;
- Haçlı/Eyyûbî/Moğol/Memlük zaman örtüşmesi korunur;
- araştırma kayıtları production'a sızmaz;
- aynı work-family iki bağımsız kaynak gibi kullanılamaz;
- bilinmeyen source ID reddedilir;
- zorunlu tarih hattı eksikse dataset reddedilir;
- broad/contested kayıtta eksik TR/EN/AR caveat reddedilir;
- cross-track overlap kabul edilirken aynı track chronology drift reddedilir.

## TEST_MATRIX durumu

Bu çalışma D12'nin otomatik enforcement ve tarih kapsamını ilerletir; D12'yi PASS yapmaz. T0211–T0215 tarih içeriklerinin gerçek factual editorial review, certainty doğrulaması ve TR/EN/AR native insan review kanıtları tamamlanmadığı sürece D12/D14 TODO kalmalıdır.
