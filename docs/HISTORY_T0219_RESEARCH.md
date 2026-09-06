# T0219 — İslam Tarihi Yatay Temalar Araştırma Kaydı

Bu belge `SPECIFICATION.md` 371–380 ve `TODO.md` T0219 kapsamındaki yatay tarih temalarının araştırma ve production kapısını kaydeder.

## Kapsam

Zorunlu dokuz tema ayrı kayıt olarak tutulur: bilim; tıp; matematik/astronomi; felsefe/düşünce; hadis/tefsir/fıkıh; sanat/mimari; ticaret/şehirleşme; eğitim kurumları; kadınların tarihsel rolleri.

Bu temalar siyasi hanedan kronolojisinin yerine geçmez. Farklı dönem ve bölgeler boyunca kesişen yatay katmanlardır; tek bir “altın çağ”, tek bir merkez, tek bir yükseliş/çöküş veya tek bir mezhepsel çizgi anlatısı üretmemelidir.

## Production kapısı

- Her kayıt TR/EN/AR başlık, özet ve certainty/caveat metni taşır.
- Her kayıt en az iki bağımsız akademik **work family** ile desteklenir. Aynı monografinin iki bölümü/locator'ı iki bağımsız kaynak sayılmaz.
- Bilinmeyen kaynak, eksik tema, eksik dil metni ve tek work-family fail-closed reddedilir.
- Bütün T0219 kayıtları şimdilik `researchDraft` durumundadır.
- Factual/editorial review ve gerçek TR/EN/AR native review kanıtları tamamlanmadan `reviewedForProduction` yapılmaz; bu nedenle TEST_MATRIX D12/D14 bu çalışma ile otomatik PASS olmaz.

## Akademik kaynak aileleri

- George Saliba, *Islamic Science and the Making of the European Renaissance*, MIT Press, 2007 — DOI `10.7551/mitpress/3981.001.0001`.
- Peter E. Pormann & Emilie Savage-Smith, *Medieval Islamic Medicine*, Edinburgh University Press, 2007 — ISBN `9780748620678`.
- Peter Adamson, *Philosophy in the Islamic World*, Oxford University Press, 2016 — ISBN `9780199577491`.
- Wael B. Hallaq, *The Origins and Evolution of Islamic Law*, Cambridge University Press, 2005 — DOI `10.1017/CBO9780511818783`.
- Christopher Melchert, *The Formation of the Sunni Schools of Law, 9th-10th Centuries C.E.*, Brill, 1997 — ISBN `9789004109520`.
- Richard Ettinghausen, Oleg Grabar & Marilyn Jenkins-Madina, *Islamic Art and Architecture, 650–1250*, Yale University Press — DOI `10.37862/aaeportal.00202`.
- Ira M. Lapidus, *A History of Islamic Societies*, 3rd ed., Cambridge University Press, 2014 — DOI `10.1017/CBO9781139048828`.
- George Makdisi, *The Rise of Colleges: Institutions of Learning in Islam and the West*, Edinburgh University Press — ISBN `9780852243756`.
- Asma Sayeed, *Women and the Transmission of Religious Knowledge in Islam*, Cambridge University Press, 2013 — DOI `10.1017/CBO9781139381871`.
- Leila Ahmed, *Women and Gender in Islam: Historical Roots of a Modern Debate*, Yale University Press — ISBN `9780300257311`.

## Certainty kararları

- Bilim, tıp, matematik/astronomi, sanat/mimari ve ticaret/şehirleşme kayıtları geniş tarihsel gelişim aralıklarıdır; tarih sınırları öğretici olup evrensel başlangıç/bitiş kabul edilmez.
- Felsefe/kelâm ilişkisi, mezhep ve yöntemlerin oluşumu, medrese kurumsallaşması ve kadınların tarihsel deneyimleri tek çizgili anlatı olmadığı için `contestedInterpretation` olarak işaretlenir.
- Kadınların rolleri sınıf, bölge, dönem ve kaynak türüne göre ayrıştırılmadan genellenmez; hadis aktarımı ve eğitimdeki roller ayrıca Asma Sayeed çalışmasıyla çaprazlanır.

## Kod/test kanıtı

- `lib/features/history/data/islamic_history_horizontal_themes.dart`
- `test/features/history/islamic_history_horizontal_themes_test.dart`

Testler 9/9 tema kapsamı, research-draft production engeli, aynı work-family sahte iki kaynak, unknown source, eksik tema ve eksik AR certainty caveat failure-path'lerini doğrular.
