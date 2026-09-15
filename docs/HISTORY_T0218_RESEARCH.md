# T0218 — Modern İslam Tarihi Araştırma / QA Kaydı

## Kapsam

T0218 dört örtüşebilen öğretici katmanla modellenir:

1. sömürgecilik ve imparatorluk yönetimleri,
2. bağımsızlık/dekolonizasyon ve modern ulus devletler,
3. 20. yüzyıl toplumsal/dinî dönüşümleri,
4. günümüze uzanan küresel Müslüman toplumlar.

Bu katmanlar tek bir küresel ardışık hanedan çizgisi değildir. Bölgelere göre başlangıç, bitiş, sömürge yönetimi, bağımsızlık ve toplumsal dönüşüm tarihleri farklıdır.

## Kaynak aileleri

- David Motadel (ed.), *Islam and the European Empires*, Oxford University Press, 2014. DOI: `10.1093/acprof:oso/9780199668311.001.0001`.
- Francis Robinson (ed.), *The New Cambridge History of Islam*, Vol. 5: *The Islamic World in the Age of Western Dominance*, Cambridge University Press, 2010. DOI: `10.1017/CHOL9780521838269`.
- Ira M. Lapidus, *A History of Islamic Societies*, 3rd ed., Cambridge University Press, 2014. DOI: `10.1017/CBO9781139048828`.
- Muhamad Ali, *Islam and Colonialism: Becoming Modern in Indonesia and Malaya*, Edinburgh University Press, 2016. DOI: `10.3366/edinburgh/9781474409209.001.0001`.
- Humayun Ansari, “Islam in the West”, *The New Cambridge History of Islam*, Vol. 5. DOI: `10.1017/CHOL9780521838269.026`.
- Emily Greble, *Muslims and the Making of Modern Europe*, Oxford University Press, 2021. DOI: `10.1093/oso/9780197538807.001.0001`.

## Certainty / anlatım kuralları

- `1800–1919`, `1919–1970`, `1900–2000` gibi aralıklar öğretici sentez sınırlarıdır; evrensel başlangıç/bitiş tarihi gibi gösterilemez.
- “Sömürgecilik Müslüman dünyasında tek biçimde yaşandı” veya “bağımsızlık tek tarihte gerçekleşti” türü genellemeler yasaktır.
- Modernleşme ile dinî dönüşüm tek yönlü karşıtlık veya kaçınılmaz sekülerleşme tezi şeklinde kesinleştirilmez.
- Günümüz katmanı `snapshotBounded` olarak işaretlenir. `2026` tarihsel bir bitiş değil, bu veri sürümünün güncellik sınırıdır.
- Güncel siyasi olaylar, yaşayan kişiler veya sürmekte olan çatışmalar tarihsel kesinlik diliyle otomatik eklenmez; ayrıca güncel kaynak doğrulaması gerekir.

## Production kapısı

Bu turdaki kayıtların tamamı `researchDraft` durumundadır. Production terfisi için:

- iddia bazında factual/editorial review,
- en az iki bağımsız akademik çalışma ailesi,
- TR/EN/AR native dil ve terminoloji incelemesi,
- certainty/caveat kontrolü,
- yazım ve kaynak locator kontrolü

zorunludur. Bu kanıtlar olmadan TEST_MATRIX D12/D14 PASS yapılamaz.
