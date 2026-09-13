# T0211 — İslam'dan Önce Dünya araştırma kanıtı

Bu belge `pre_islam_world_context.dart` içindeki 11 araştırma başlığının ikinci bağımsız akademik çalışma katmanını kaydeder. Bu kayıtlar production-native-review kanıtı değildir; içerikler `researchDraft` kalır.

## Kaynak aileleri

- Valentina A. Grasso, *Pre-Islamic Arabia*, Cambridge University Press, 2023. Aynı monografinin bölümleri tek bağımsız çalışma ailesi sayılır.
- Robert G. Hoyland, *Arabia and the Arabs: From the Bronze Age to the Coming of Islam*, Routledge, 2001, ISBN 9780415195355.
- Greg Fisher (ed.), *Arabs and Empires before Islam*, Oxford University Press, 2015, DOI `10.1093/acprof:oso/9780199654529.001.0001`. Bu kitap içindeki Robin bölümü Fisher kitabından bağımsız ikinci eser sayılmaz.
- Christian Julien Robin, “Ḥimyar, Aksūm, and Arabia Deserta in Late Antiquity: The Epigraphic Evidence”, Fisher (ed.), 2015, DOI `10.1093/acprof:oso/9780199654529.003.0004`.
- G. W. Bowersock, *The Throne of Adulis: Red Sea Wars on the Eve of Islam*, Oxford University Press, 2013, ISBN 9780199739325.
- Christian Julien Robin & Jason Harris, “Judaism in Pre-Islamic Arabia”, *The Cambridge History of Judaism*, Cambridge University Press, 2021, DOI `10.1017/9781139048873.013`.
- Michael Lecker, “Pre-Islamic Arabia”, *The New Cambridge History of Islam*, vol. 1, pp. 153–170.
- Wael B. Hallaq, *The Origins and Evolution of Islamic Law*, chapter 1, Cambridge University Press, DOI `10.1017/CBO9780511818783.004`.
- G. R. Hawting, *The Idea of Idolatry and the Emergence of Islam*, Cambridge University Press, ISBN 9780521651653.

## 11 konu için bağımsız çalışma dağılımı

| Konu | Çalışma ailesi 1 | Çalışma ailesi 2+ |
|---|---|---|
| Geç Antik Çağ | Grasso 2023 | Fisher 2015 |
| Bizans dünyası | New Cambridge History of Islam | Fisher 2015 |
| Sasani dünyası | New Cambridge History of Islam | Fisher 2015 |
| Aksum/Habeşistan | Grasso 2023 | Bowersock 2013 |
| Yemen/Güney Arabistan | Grasso 2023 | Fisher/Robin 2015 + Bowersock 2013 |
| Mekke | New Cambridge History of Islam | Hoyland 2001 |
| Yasrib/Medine | New Cambridge History of Islam | Hoyland 2001 |
| Kabile/yerleşim düzeni | Grasso 2023 | Hoyland 2001 |
| Yahudi toplulukları | Grasso 2023 | Cambridge History of Judaism 2021 |
| Hristiyan toplulukları | Grasso 2023 | Fisher 2015 |
| Arap politeizmi/kültleri | Hawting | Hoyland 2001 |

## Fail-closed uygulama

`IndependentHistoryResearchRegistry` şu durumları reddeder:

1. Zorunlu 11 başlıktan birinin eksik olması.
2. Bilinmeyen veya duplicate source ID.
3. Source-family metadata'sı eksik kaynak.
4. Bir konu için iki ID olsa bile ikisinin aynı yayın/çalışma ailesine ait olması.

Bu kapı D12'nin “iki kaynak” kısmına otomatik kanıt üretir; D12 henüz PASS değildir. Production geçişi için içerik bazında certainty, factual editorial review ve TR/EN/AR native review kanıtı ayrıca gereklidir.
