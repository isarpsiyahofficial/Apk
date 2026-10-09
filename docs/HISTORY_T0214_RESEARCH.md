# T0214 — Emevîler, Abbâsîler, Endülüs, Fâtımîler ve bölgesel hanedanlar

## Amaç

Bu belge T0214 için araştırma, veri modeli ve QA sözleşmesini kaydeder. İçerik production onayı değildir. `lib/features/history/data/medieval_caliphates_regional_dynasties.dart` içindeki kayıtların tamamı `researchDraft` durumundadır; factual editorial review ve gerçek TR/EN/AR native review kanıtı olmadan production içeriğine terfi ettirilemez.

## Paralel tarih hattı kararı

T0214 tek ve düz bir kronoloji gibi modellenmez. Abbâsîler, Endülüs Emevî yönetimi, Fâtımîler ve çeşitli bölgesel hanedanlar uzun dönemler boyunca birbirleriyle zaman bakımından örtüşür. Bu nedenle veri modeli beş paralel track kullanır:

- `umayyad`
- `abbasid`
- `alAndalus`
- `fatimid`
- `regionalDynasties`

Validator farklı track'lerin zaman bakımından örtüşmesine izin verir; aynı track içindeki kayıtların geriye doğru gitmesini reddeder. Böylece tarihsel olarak eşzamanlı siyasi merkezler sahte bir ardışık zincire dönüştürülmez.

## Kaynak bağımsızlığı

Her T0214 kaydı en az iki ayrı akademik çalışma ailesine dayanmak zorundadır. Aynı monografinin veya aynı edit edilmiş eserin iki farklı chapter/locator kaydı iki bağımsız kaynak sayılmaz. Bu kural `workFamilyId` üzerinden fail-closed uygulanır.

Kullanılan ana akademik kaynak aileleri:

- Mehdi Kurgan Kader, *The Cambridge History of Strategy*, Emevî/Abbâsî bölümü, CUP, 2025 — DOI `10.1017/9781108788090.012`.
- Andrew Marsham, *The Umayyad Empire*, Edinburgh University Press.
- Tayeb El-Hibri, *The Abbasid Caliphate: A History*, CUP, 2021 — DOI `10.1017/9781316869567`.
- Ira M. Lapidus, “The Post-ʿAbbasid Middle Eastern State System”, *Islamic Societies to the Nineteenth Century*, CUP — chapter DOI `10.1017/CBO9781139027670.025`.
- R. N. Frye, “The Samanids”, *The Cambridge History of Iran* — DOI `10.1017/CHOL9780521200936.005`.
- Heribert Busse, “Iran under the Būyids”, *The Cambridge History of Iran* — DOI `10.1017/CHOL9780521200936.008`.
- Janina Safran, Endülüs’te halifelik meşruiyeti üzerine hakemli IJMES çalışması.
- Eduardo Manzano Moreno, *The Court of the Caliphate of al-Andalus*, Edinburgh University Press, 2023.
- Christine D. Baker, “Ismaili and Fatimid North Africa”, Oxford Research Encyclopedia, 2018 — DOI `10.1093/acrefore/9780190277734.013.327`.
- Michael Brett, Fâtımîlerin onuncu yüzyıl siyasal alanı üzerine BSOAS çalışması.

## Certainty ve dönem sınırları

Kesin kronolojik çerçeve ile geniş/yoruma açık dönemler aynı statüde tutulmaz. `broadPeriod` veya `contestedInterpretation` işaretli kayıtlar TR/EN/AR caveat olmadan validator'dan geçemez.

Büveyhî kaydı özellikle Lapidus'un açıkça verdiği Irak ve Batı İran'daki 945–1055 etkin bölgesel hâkimiyet çerçevesine sabitlenmiştir. Bu aralık hanedanın bütün coğrafyalardaki mutlak doğum/ölüm tarihi gibi sunulmaz.

## Failure-path kanıtı

`test/features/history/medieval_caliphates_regional_dynasties_test.dart` şu davranışları doğrular:

- zorunlu beş parallel track ve çekirdek kayıtların tamamı bulunur;
- Abbâsî/Endülüs/Fâtımî zaman örtüşmesi kabul edilir;
- araştırma kayıtları production'a sızmaz;
- aynı work-family iki kaynak gibi gösterilemez;
- bilinmeyen source ID reddedilir;
- zorunlu bir tarih hattının eksilmesi reddedilir;
- broad/contested kayıtta eksik TR/EN/AR caveat reddedilir;
- farklı track overlap kabul edilirken aynı track içinde chronology drift reddedilir.

## TEST_MATRIX durumu

Bu çalışma D12'nin otomatik enforcement ve kaynak kapsamını ilerletir, fakat D12'yi PASS yapmaz. T0211–T0214 tarih içeriklerinin gerçek factual editorial review, certainty doğrulaması ve TR/EN/AR native insan review kanıtları tamamlanmadığı sürece D12/D14 TODO kalmalıdır.
