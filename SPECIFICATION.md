# İSLAMİ HAYAT — GLOBAL ÜRÜN VE GELİŞTİRME ANA ŞARTNAMESİ

**Sürüm:** v1.1  
**Tarih:** 26 Ağustos 2026  
**Durum:** Master şartname / geliştirme öncesi ana referans  
**Repo:** `isarpsiyahofficial/Apk`

> Bu dosya ürünün tek ana şartname kaynağıdır. Daha sonra hazırlanacak `TODO.md` ve geliştirme planı bu şartnameden birebir türetilecek; şartnamede karşılığı olmayan kritik davranış eklenmeyecek, şartnamede bulunan hiçbir madde sessizce atlanmayacaktır.

---

## A. ÜRÜNÜN ANAYASASI

1. Uygulamanın temel kimliği **Kur’an merkezli modern İslami yaşam ve bilgi uygulaması** olacaktır.
2. Uygulama genel motivasyon, astroloji, tarot veya belirsiz “spiritual” içerik uygulamasına dönüşmeyecektir.
3. Mevlânâ veya rastgele spiritüel alıntılar ana günlük içerik sisteminden çıkarılacaktır; uygulamanın İslami kimliği bulanıklaştırılmayacaktır.
4. Ana dini içerik eksenleri **Kur’an, dua, zikir, Esmâü’l-Hüsnâ, dini günler/geceler, peygamberlerin hayatları, vahiy tarihi, İslam tarihi ve kullanıcının yaşadığı konularla ilgili Kur’an ayetlerini keşfetmesi** olacaktır.
5. Uygulama **fetva uygulaması değildir** ve hiçbir kullanıcı sorusuna bağlayıcı dini hüküm vermeyecektir.
6. Uygulama hiçbir zaman “Allah sana bunu söyledi”, “Allah’ın cevabı”, “bu ayet senin kesin cevabın” gibi ifadeler kullanmayacaktır.
7. “Soru sor → rastgele ayet cevabın olsun” sistemi kullanılmayacaktır.
8. Kullanıcı soruları yalnızca **önceden hazırlanmış temalara ve uzman kontrolünden geçmiş ayet kümelerine** eşlenecektir.
9. Din adına kesinlik iddiası yalnız gerçekten kesin/kuvvetli kaynak bulunan durumlarda kullanılacaktır.
10. Kur’an, hadis, klasik dua, gelenek, tasavvufî uygulama, ebced/havas geleneği ve editoryal dua birbirinden açıkça ayrılacaktır.
11. Kaynağı doğrulanamayan sosyal medya dini iddiası doğrulanmış dini bilgi gibi gösterilmeyecektir.
12. Uygulama İslam’ı küçültecek, alaya alacak, batıl/okült uygulamalarla aynı statüye indirecek veya başka dinleri aşağılayacak bir dil kullanmayacaktır.
13. Mezhepsel ihtilaf bulunan konular tek bir görüş “İslam’ın tek hükmü” şeklinde sunulmayacaktır.
14. V1 mümkün olduğunca mezhepler arası ihtilaf üretmeyen ortak İslami içerik üzerine kurulacaktır.
15. İhtilaflı meselelerde “görüş farklılığı vardır” açıklaması bulunacaktır.
16. Kullanıcıya bilgi kaynağını görme hakkı ürünün temel özelliği olacaktır.
17. Her önemli dini kartta **Kaynak** düğmesi veya eşdeğer erişim bulunacaktır.
18. Kullanıcı hiçbir dini metni uygulama içerisinde değiştirerek paylaşamayacaktır.
19. Uygulamanın temel dini bilgileri Premium duvarının arkasına kapatılmayacaktır.
20. Premium esas olarak **reklamsızlık, çevrimdışı erişim, görsel kişiselleştirme ve gelişmiş kullanım kolaylıkları** satacaktır.

---

## B. KAPSAM DIŞI BIRAKILANLAR

21. Namaz vakitleri V1’de bulunmayacaktır.
22. Otomatik ezan çalma V1’de bulunmayacaktır.
23. İmsak/iftar saati hesaplama yapılmayacaktır.
24. Bunun nedeni yaz/kış saati, yüksek enlem, farklı hesaplama metotları ve yerel otoriteler arasındaki dakika farklılıklarında dini hata riskini azaltmaktır.
25. Kullanıcılar arası mesajlaşma bulunmayacaktır.
26. Sosyal feed/topluluk sistemi bulunmayacaktır.
27. Canlı Mekke yayını bulunmayacaktır.
28. Cami/helal restoran bulucu bulunmayacaktır.
29. Canlı yardım/fetva servisi bulunmayacaktır.
30. Bulut AI chatbot bulunmayacaktır.
31. Kur’an tilavetini AI ile dinleyip yanlış okuma tespiti yapan sistem V1’de bulunmayacaktır.
32. Bu özelliklerin çoğu sürekli backend, moderasyon, canlı veri veya maliyet gerektirdiğinden sunucusuz mimari hedefiyle çelişmektedir.
33. Vefk, muska, tılsım veya bir insanın iradesini etkilemeye yönelik “bağlama” uygulamaları öğretilmeyecektir.
34. “Şu zikri X kez yaparsan kesin para/aşk/şifa gelir” şeklinde sonuç garantisi verilmeyecektir.
35. Sağlık, para, evlilik ve benzeri alanlarda dini içerik profesyonel tıbbi/hukuki/finansal danışmanlığın yerine konulmayacaktır.

---

## C. PLATFORM VE TEKNİK MİMARİ

36. İlk ana hedef platform **Android** olacaktır.
37. Kod mimarisi mümkün olduğu ölçüde iOS’a taşınabilir şekilde kurulacaktır.
38. Tercih edilen uygulama teknolojisi Flutter olacaktır.
39. Uygulamanın temel işlevlerini çalıştırmak için bize ait bir backend zorunlu olmayacaktır.
40. Kullanıcı hesabı zorunlu olmayacaktır.
41. E-posta, telefon veya sosyal medya girişi olmadan kullanılabilecektir.
42. Ana dini içerik cihazın uygulama paketinde veya uygulamayla dağıtılan yerel veri paketinde bulunacaktır.
43. İçerik veri tabanı ile kullanıcı veri tabanı birbirinden ayrılacaktır.
44. Dini ana veri salt okunur olacaktır.
45. Kullanıcı favorileri, geçmişi, zikir sayımları ve tefekkür notları ayrı yerel veride saklanacaktır.
46. Hassas kullanıcı verileri cihaz üzerinde şifreli saklanacaktır.
47. Android Keystore uygun anahtar materyali için kullanılacaktır.
48. Uygulamanın çalışması kendi CDN/API altyapımıza bağlı olmayacaktır.
49. Kritik içerik güncellemesi gerektiğinde yeni uygulama sürümü yayınlanacaktır.
50. Play Store/App Store dışındaki uzaktan değiştirilebilir dini metin mekanizmaları V1’de kullanılmayacaktır.
51. Böylece kullanıcının gördüğü dini veri belirli uygulama sürümüyle birebir doğrulanabilir olacaktır.
52. İçerik paketinin SHA-256 manifesti oluşturulacaktır.
53. Uygulama başlangıcında kritik Kur’an varlıklarının bütünlüğü doğrulanabilecektir.
54. İçerik dosyasında beklenmeyen bozulma görülürse bozuk dini metin gösterilmemelidir.
55. Mimari feature-based modüler kurulacaktır: `quran`, `dua`, `dhikr`, `prophets`, `history`, `daily`, `share`, `premium`, `settings`, `localization`, `sources`.

---

## D. BİLGİ MİMARİSİ — UI DAĞILMASINI ENGELLEYEN ANA PLAN

56. Uygulamanın alt navigasyonu **en fazla 5 ana sekmeden** oluşacaktır.
57. Ana sekmeler: **Bugün – Kur’an – Keşfet – Zikir – Ben** olacaktır.
58. Ana ekranda 10–15 küçük özellik butonu yan yana dizilmeyecektir.
59. “Bugün” ekranı günlük kullanım merkezidir.
60. “Kur’an” ekranı yalnız Kur’an deneyimidir.
61. “Keşfet” ekranı bilgi kütüphanesidir.
62. “Zikir” ekranı zikir sayaç ve rehber sistemidir.
63. “Ben” ekranı favori, geçmiş, Premium, gizlilik ve ayarlardır.
64. İslam Tarihi Keşfet içinde güçlü bir ana modül olacaktır.
65. Peygamberler ve Vahiy Tarihi Keşfet içinde güçlü bir ana modül olacaktır.
66. Dualar Keşfet içinde güçlü bir ana modül olacaktır.
67. Dini Günler Keşfet içinde olacaktır.
68. Esmâü’l-Hüsnâ Zikir alanıyla ilişkilendirilecektir.
69. “Kur’an’da Konuya Göre Ara” Keşfet içinde ve ana ekrandaki hızlı eylemlerden erişilebilir olacaktır.
70. Uygulama içi global arama Keşfet ekranının üstünde bulunacaktır.
71. Global arama sonuçları kategoriye ayrılacaktır: **Ayetler / Dualar / Zikirler / Esmâ / Peygamberler / Tarih / Kişiler / Dini Günler.**
72. Her özellik ana ekrana taşınmayacaktır.
73. Ana ekran ilk görünümde kullanıcının ne yapabileceğini 5 saniye içinde anlatmalıdır.
74. Ana ekran öncelik sırası: **Günün ayeti → Günün duası → Bugün İslam tarihinde → hızlı erişimler → kişisel devam alanı** olacaktır.
75. Ana ekran dikey bir içerik akışıdır; karmaşık dashboard olmayacaktır.
76. Kullanıcı kartların sırasını sonradan kişiselleştirebilir; varsayılan düzen bozulmamalıdır.

---

## E. UI / GÖRSEL TASARIM ANAYASASI

77. Uygulama “AI dashboard tasarımı” gibi görünmeyecektir.
78. Sürekli koyu petrol yeşili zemin kullanılmayacaktır.
79. Ana tema **açık, sıcak ve doğal** olacaktır.
80. Temel zemin kırık beyaz, ivory veya sıcak krem olacaktır.
81. Koyu orman yeşili ana vurgu rengidir fakat tüm ekranı kaplamayacaktır.
82. Soft sage/zeytin yardımcı renk olarak kullanılabilir.
83. Altın yalnız ince çizgi, ikon veya küçük vurgu olarak kullanılacaktır.
84. Her içerik dev yuvarlak kart içine sokulmayacaktır.
85. Gereksiz gradient yasaktır.
86. Gereksiz glow yasaktır.
87. Cam efekti/glassmorphism ana tasarım dili olmayacaktır.
88. Sürekli aynı 20–24 px yuvarlatılmış kart kalıbı kullanılmayacaktır.
89. Büyük boşluklar ve editorial tipografi kullanılacaktır.
90. Cami/minare görselleri her ekranda dekor olarak kullanılmayacaktır.
91. İslami kimlik; tipografi, geometrik oran, ince desen ve kompozisyonla verilecektir.
92. Kur’an ekranı kitap/okuma hissi taşıyacaktır.
93. Dua ekranı sakin ve metin odaklı olacaktır.
94. Zikir ekranı fonksiyonel ve dikkat dağıtmayan olacaktır.
95. İslam Tarihi ekranı ayarlar listesi gibi görünmeyecek, gerçek timeline deneyimi olacaktır.
96. Peygamberler bölümü ansiklopedi listesi gibi değil; kronoloji, dönem ve biyografi arasında akış sağlayacaktır.
97. Arapça modda Arap kullanıcı için sonradan ters çevrilmiş Türkçe uygulama hissi olmayacaktır.
98. Türkçe ve İngilizce arayüzlerde Latin UI fontu açık lisanslı olacaktır.
99. Arapça UI için kaliteli açık lisanslı Arapça font ailesi kullanılacaktır.
100. Kur’an metni için ayrıca mushaf doğruluğu ve font lisansı kontrol edilmiş font kullanılacaktır.
101. Dark mode bulunabilir ancak ilk marka kimliği light-first olacaktır.
102. Dark mode erişilebilirlik/tercih özelliği olarak ücretsiz olacaktır; Premium’a kilitlenmeyecektir.

---

## F. DİL VE YERELLEŞTİRME

103. Uygulama yalnız üç ana dilde yayınlanacaktır: **Türkçe – English – العربية.**
104. Üç dil de ana dil seviyesinde olacaktır.
105. Kelime kelime makine çevirisi yapılmayacaktır.
106. Dini terminoloji ilgili dilde kullanılan gerçek terminolojiyle yazılacaktır.
107. Uygulama kodunda kullanıcıya görünen hard-coded string bırakılmayacaktır.
108. Her UI metni locale anahtarından gelecektir.
109. Varsayılan fallback ile başka dil gösterilmeyecektir.
110. Eksik lokalizasyon geliştirme/QA hatası sayılacaktır.
111. Bir dini içerik kaydı üç dilde onaylanmadan `published` durumuna geçemeyecektir.
112. Aynı `content_id` üç dilde aynı dini içeriği temsil edecektir.
113. TR modunda EN metin sızıntısı olmayacaktır.
114. TR modunda AR metin yalnız kullanıcının özellikle “Arapça aslı göster” seçimini açması halinde görünebilir.
115. EN için aynı kural geçerlidir.
116. AR arayüz %100 RTL olacaktır.
117. Arapça RTL'de geri okları, carousel yönleri ve yatay navigasyon gerektiğinde aynalanacaktır.
118. Dini kaynak numaraları yanlış biçimde çevrilmeyecektir.
119. Arapçada Arap rakamları/Latin rakamları seçilebilir ayar olabilir.
120. Tarih biçimleri locale uygun gösterilecektir.
121. Arapça paylaşım kartlarının satır kırılımı ayrıca test edilecektir.
122. Store açıklaması, screenshot metinleri ve Premium ekranı da üç dilde ayrı hazırlanacaktır.

---

## G. ONBOARDING

123. İlk açılış maksimum birkaç kısa adımdan oluşacaktır.
124. İlk adım dil seçimi olacaktır.
125. İkinci adım kısa ürün tanıtımı olacaktır: **Kur’an – Dua – Zikir – Tarih/Peygamberler.**
126. Kullanıcıdan dini mezhep veya kişisel inanç bilgisi onboarding’de sorulmayacaktır.
127. Hesap oluşturma istenmeyecektir.
128. Bildirim izni ilk açılışta kör biçimde sorulmayacaktır.
129. Önce hangi bildirimlerin gönderileceği anlatılacaktır.
130. Kullanıcı isterse günlük ayet, günlük dua, zikir hatırlatması ve dini gün hatırlatmasını ayrı ayrı seçebilecektir.
131. Bildirim izni reddedilse uygulama normal çalışacaktır.
132. Kullanıcı açık/koyu tema seçimini onboarding’de yapmak zorunda olmayacaktır.

---

## H. BUGÜN ANA EKRANI

133. Üst bölüm sakin bir selamlama ve gün bilgisi içerecektir.
134. İlk ana içerik **Günün Ayeti** olacaktır.
135. Günün Ayeti tamamen doğrulanmış önceden hazırlanmış günlük havuzdan seçilecektir.
136. Aynı gün içerisinde uygulama yeniden açıldığında ayet sürekli değişmeyecektir.
137. Tarih tabanlı deterministik seçim kullanılacaktır.
138. Günün Ayeti kartı ayet/meali, sure/ayet numarası, kısa kaynak bilgisi, favori ve paylaş işlemlerini sunacaktır.
139. İkinci bölüm **Bugünün Duası** olacaktır.
140. Dua uzun ise ana ekranda yalnız doğal bir önizleme gösterilecektir.
141. “Tam Duayı Oku” ile dua sayfası açılacaktır.
142. Üçüncü bölüm **Bugün İslam Tarihinde** olacaktır.
143. O güne denk gelen güvenilir tarih olayı varsa gösterilecektir.
144. Kesin günü bilinmeyen tarih olayları “bugün” alanına zorla konulmayacaktır.
145. Dördüncü bölüm hızlı erişimlerden oluşacaktır.
146. Hızlı erişimler maksimum 4 olacaktır: **Konu Ara – Dualar – Zikir – Keşfet.**
147. Kullanıcının devam ettiği Kur’an okuması varsa “Devam Et” kartı gösterilebilir.

---

## I. KUR’AN-I KERİM

148. Kur’an Arapça metni doğrulanmış ve lisansı uygun kaynaktan alınacaktır.
149. Kaynağın metin değiştirmeme ve attribution şartlarına uyulacaktır.
150. Kur’an metnine otomatik düzeltme uygulanmayacaktır.
151. Kur’an text normalization işlemi kaynak metni değiştirmeyecektir.
152. Ayet sayıları otomatik doğrulanacaktır.
153. 114 sure eksiksiz olacaktır.
154. Sure sıralaması doğrulanacaktır.
155. Mekki/Medeni metadata kaynağı saklanacaktır.
156. Jüz bilgisi bulunacaktır.
157. Hizb/rub bilgileri veri kaynağı doğrulanmışsa desteklenebilir.
158. Kullanıcı sure listesine göre okuyabilecektir.
159. Kullanıcı jüz listesine göre okuyabilecektir.
160. Son okunan konum saklanacaktır.
161. Okuma ilerlemesi yerel olacaktır.
162. Ayet favorileme olacaktır.
163. Bookmark olacaktır.
164. Tefekkür notu eklenebilecektir.
165. Tefekkür notları cihazdan çıkmayacaktır.
166. Kullanıcı ayet metnini düzenleyemez.
167. Kullanıcı meal metnini düzenleyemez.
168. Türkçe ve İngilizce meal insan tarafından hazırlanmış, lisanslı/doğrulanmış kaynaktan alınacaktır.
169. Mealler başka dilden AI ile çevrilmeyecektir.
170. Kullanıcı meal kaynağını görebilecektir.
171. Kur’an kaynak/lisans ekranı uygulamada bulunacaktır.
172. Kur’an içerisinde anahtar kelime arama olacaktır.
173. Arama seçili dilde çalışacaktır.
174. Sure adına göre arama olacaktır.
175. Ayet numarasına direkt gitme olacaktır.
176. “Bugünün ayetinden sureye git” işlevi olacaktır.
177. Ayet paylaşımı olacaktır.
178. Uzun ayet paylaşımda kesilmeyecektir.
179. Gerekiyorsa font küçülecek veya çoklu paylaşım kartı kullanılacaktır.
180. Kur’an ekranının içinde banner reklam olmayacaktır.
181. Ayetler arasında interstitial reklam olmayacaktır.
182. Kullanıcı Premium olmasa dahi Kur’an metni online olduğu sürece erişilebilir olacaktır.
183. Premium kullanıcının Kur’an metni çevrimdışı çalışacaktır.
184. V1’de sesli Kur’an zorunlu değildir.
185. Tam Kur’an audio eklenirse telif/lisans ayrı doğrulanacaktır.
186. Sesli tilavet eklenirse kendi sunucumuz yerine mağaza asset delivery veya lisanslı uygun dağıtım modeli değerlendirilecektir.
187. AI tabanlı recitation mistake detection V1 dışında tutulacaktır.
188. Basit **Ezber Modu** bulunabilir: ayeti gizle, dokunarak göster, kendini test et.
189. Ezber modu kullanıcının sesini analiz etmeyecektir.
190. Okuma hedefi bulunabilir: günlük dakika / ayet / sayfa.
191. Hedefler suçluluk yaratacak biçimde tasarlanmayacaktır.

---

## J. KUR’AN’DA KONUYA GÖRE ARAMA / SORU SİSTEMİ

192. Kullanıcının gördüğü ifade “Soruma Allah’ın cevabı” olmayacaktır.
193. Önerilen başlık: **“Yaşadığın Konuyu Kur’an’da Keşfet.”**
194. Kullanıcı serbest metin yazabilecektir.
195. Kullanıcı yazmak istemezse hazır tema seçebilecektir.
196. Analiz tamamen mümkün olduğu ölçüde cihazda yapılacaktır.
197. Ham soru dış servise gönderilmeyecektir.
198. Türkçe normalizasyon olacaktır.
199. İngilizce normalizasyon olacaktır.
200. Arapça normalizasyon olacaktır.
201. Noktalama önemli olmayacaktır.
202. Büyük/küçük harf normalize edilecektir.
203. Türkçe karakter toleransı olacaktır.
204. Yaygın konuşma dili eşleşmeleri olacaktır: `napcam`, `napiyim`, `yalnizim` vb.
205. İngilizce yaygın typo sözlüğü olacaktır.
206. Arapçada hareke kaldırılarak karşılaştırma yapılabilecektir.
207. Arapçada tatweel temizlenebilecektir.
208. Arapça elif varyantları normalizasyon katmanında ele alınacaktır.
209. Fuzzy matching kullanılacaktır.
210. Levenshtein benzerliği veya eşdeğer hafif algoritma kullanılabilir.
211. N-gram/phrase matching kullanılacaktır.
212. Stop-word sistemi üç dil için ayrı olacaktır.
213. Tema taksonomisi uzman tarafından hazırlanacaktır.
214. Başlangıç temaları: sabır, kaygı, korku, ümit, yalnızlık, tövbe, bağışlanma, aile, anne-baba, evlilik, sevgi ve merhamet, öfke, affetme, adalet, haksızlık, rızık, borç, çalışma, karar, tevekkül, hastalıkta manevi destek, kayıp, ölüm, şükür, dua.
215. Her tema ayetlerle manuel olarak ilişkilendirilecektir.
216. Algoritma yeni ayet yorumu üretmeyecektir.
217. Sistem yalnız uygun tema ID’si bulacaktır.
218. Tema ID’si önceden doğrulanmış ayet kümesine bağlanacaktır.
219. Aynı soruda birden fazla tema bulunabilir.
220. Tema puanlaması olacaktır.
221. Güven skoru düşükse ayet göstermeden kullanıcıdan temayı netleştirmesi istenecektir.
222. Kullanıcıya tek “kehanet ayeti” yerine mümkünse 3–5 ilgili ayet sunulacaktır.
223. Her sonuçta **“Bu neden gösterildi?”** açıklaması olacaktır.
224. Açıklama “Sorunda sabır ve kaygı temaları tespit edildi” gibi olacaktır.
225. Uygulama “bu ilişkiyi bitir”, “işinden ayrıl” gibi karar vermeyecektir.
226. Sağlık riski içeren sorularda yalnız manevi destek içeriği gösterilecek ve profesyonel yardımın yerine geçmediği belirtilecektir.
227. Kendine zarar ima eden içerikler dini hüküm sistemine bırakılmayacaktır; güvenli destek yönlendirmesi yapılacaktır.

---

## K. DUALAR

228. Dua sistemi yalnız Kur’an dualarından oluşmayacaktır.
229. Dua içerikleri dört ana statüde tutulacaktır: **Kur’an duası / sahih-hasen sünnet duası / klasik-geleneksel dua / genel editoryal dua.**
230. Editoryal dua “ayet veya hadis değildir” etiketi taşıyacaktır.
231. Kaynaksız dua Peygamber’e nispet edilmeyecektir.
232. Dua uzunlukları tek tip olmayacaktır.
233. **Kısa Dua** 1–3 cümle olabilir.
234. **Orta Dua** birkaç paragraf olabilir.
235. **Uzun Dua** gerektiği kadar kapsamlı olabilir.
236. Uzun dua sırf paylaşım kartına sığsın diye kesilmeyecektir.
237. Paylaşım için ayrı kısa özet/alıntı hazırlanabilir.
238. Dua kategorileri: sabah, akşam, gece, sıkıntı, huzur, tövbe, istiğfar, şükür, sabır, rızık, borç, bereket, aile, eş, anne-baba, çocuklar, hastalıkta manevi destek, korku, yolculuk, korunma, Ramazan, cuma, bayram ve dini geceler.
239. Dua araması olacaktır.
240. Dua favorileme olacaktır.
241. Dua geçmişi yerel tutulacaktır.
242. Her duada kaynak statüsü görünecektir.
243. Hadis duasında hadis referansı gösterilecektir.
244. Hadis derecesi gerekli olduğunda gösterilecektir.
245. Kaynaklar arasında ihtilaf varsa not düşülecektir.
246. “Bugünün Duası” her gün güvenilir havuzdan deterministik seçilecektir.
247. Günlük dua kullanıcının yaşadığı soruya otomatik “kehanet” olarak bağlanmayacaktır.
248. Dini güne özel sahih dua yoksa uygulama bunu açıkça söyleyebilecektir.
249. Sosyal medyada popüler bir dua bulunursa önce kaynak araştırmasına girecektir.
250. Kaynağı bulunamazsa ancak “genel dua” olarak yeniden hazırlanabilir; sahte kaynak eklenemez.
251. “100 kez oku kesin kabul olur” türü kaynak dışı iddialar kaldırılacaktır.

---

## L. ZİKİR MATİK

252. Zikir modülünün üç temel alanı olacaktır: **Sayaç – Zikirler – Niyetime Göre.**
253. Sayaç basit ve dikkat dağıtmayan olacaktır.
254. Ana sayaç büyük tek dokunuş alanı içerecektir.
255. Titreşim isteğe bağlı olacaktır.
256. Ses efekti isteğe bağlı olacaktır.
257. Kullanıcı hedef belirleyebilecektir.
258. Hazır hedefler 33 / 100 gibi yaygın değerler içerebilir.
259. Kaynağa bağlı sayı varsa “Kaynaklı sayı” etiketi gösterilecektir.
260. Kaynaksız sayı dini tavsiye gibi gösterilmeyecektir.
261. Kullanıcının seçtiği rastgele hedef **“Kişisel hedef”** olarak işaretlenecektir.
262. Zikir geçmişi cihazda saklanacaktır.
263. Günlük toplam gösterilebilir.
264. Haftalık istatistik gösterilebilir.
265. İstatistik kullanıcının ibadetini başkalarıyla karşılaştırmayacaktır.
266. Leaderboard olmayacaktır.
267. “Sen diğer Müslümanların %90’ından fazla zikir çektin” gibi ifadeler olmayacaktır.
268. Zikir serisi/streak varsa isteğe bağlı ve yumuşak olacaktır.
269. Kaçırılan gün için suçluluk mesajı gösterilmeyecektir.
270. Her zikirde Arapça, okunuş, anlam, kaynak, neden zikredilir, önerilen sayı varsa sayı ve sayı kaynağı bulunacaktır.
271. Kullanıcı tek dokunuşla ilgili zikri sayaca yükleyebilecektir.

---

## M. ESMÂÜ’L-HÜSNÂ / “HANGİ ZİKİR NEDEN?”

272. Esmâü’l-Hüsnâ ayrı bilgi rehberi olacaktır.
273. Her isimde Arapça yazılış olacaktır.
274. Transliterasyon TR/EN için bulunabilir.
275. Ana dilde anlam olacaktır.
276. Kur’an/hadis bağlantısı varsa belirtilecektir.
277. “Neden zikredilir?” bölümü bulunacaktır.
278. “Rızık ve bereket” gibi ihtiyaç kategorileri bulunabilir.
279. Örneğin Er-Rezzâk, rızık temasıyla anlam bağlantısı üzerinden gösterilebilir.
280. Bu ilişki “bu zikri söylemek para getirir” şeklinde sunulmayacaktır.
281. “Sevgi ve merhamet” kategorisinde El-Vedûd gibi isimler gösterilebilir.
282. Bu ilişki “X kişisini sana âşık eder” şeklinde sunulmayacaktır.
283. “Şifa için manevi destek” alanında güvenilir dua ve ilgili esmâ bulunabilir.
284. Sağlık sonucu garanti edilmeyecektir.
285. “Kolaylık ve çıkış yolu” kategorileri olabilir.
286. Her öneride önerinin dayanak türü gösterilecektir.

---

## N. EBCED / HAVAS / GELENEKSEL BİLGİ

287. Ebced bilgisi tamamen kaldırılmayacaktır.
288. Ancak varsayılan güvenilir dini içerikle aynı statüde gösterilmeyecektir.
289. Her uygun isimde **Ebced değeri** bulunabilir.
290. Ebced matematiksel harf-sayı değeri olarak açıklanacaktır.
291. Ebced sayısı “Peygamber’in önerdiği zikir sayısı” gibi gösterilmeyecektir.
292. 308 / 129 / 391 gibi sayılar yalnız kaynağı ve geleneği açıkça belirtilerek gösterilebilir.
293. Kaynaklı sünnet sayısı ile ebced sayısı farklı UI etiketi taşıyacaktır.
294. Kaynak etiket sistemi: **Kur’an / Sahih-Hasen Sünnet / Anlam temelli dua / Tasavvufî-Geleneksel / Ebced-Havas geleneği / Kaynağı doğrulanamadı.**
295. Varsayılan filtre güçlü kaynakları öne çıkaracaktır.
296. Ayarlar içinde “Geleneksel uygulamaları da göster” seçeneği olabilir.
297. “Ebced/havas tarihsel bilgisini göster” ayrıca açılabilir.
298. Bu alan varsayılan olarak bilgilendirici olacaktır.
299. Vefk/tılsım üretici yapılmayacaktır.
300. Bir kişinin iradesini etkilemeye yönelik “aşk bağlama” içeriği sunulmayacaktır.
301. Gaybı bildiğini iddia eden sayı analizi yapılmayacaktır.
302. Ebced değeri kullanıcıya dini hüküm üretmeyecektir.
303. Kullanıcının doğum tarihi/ismi üzerinden okült kader analizi yapılmayacaktır.

---

## O. DİNİ GÜNLER VE GECELER

304. Dini günler yalnız takvim kartlarından oluşmayacaktır.
305. Her gün/gece için kapsamlı bilgi sayfası olacaktır.
306. Sayfada nedir, tarihçesi, Kur’an dayanağı, hadis dayanağı, güçlü rivayetler, tartışmalı rivayetler, gelenekler, özel ibadet var mı ve önerilen genel ibadet/dua alanları bulunacaktır.
307. Kadir Gecesi ayrı kapsamlı dosya olacaktır.
308. Ramazan ayrı kapsamlı rehber olacaktır.
309. Ramazan Bayramı rehberi olacaktır.
310. Kurban Bayramı rehberi olacaktır.
311. Arefe rehberi olacaktır.
312. Muharrem/Aşure rehberi olacaktır.
313. Miraç, Berat, Regaib, Mevlid gibi geceler kaynak statüleriyle anlatılacaktır.
314. Türk “kandil” geleneği global İslam’ın her yerde aynı pratiğiymiş gibi sunulmayacaktır.
315. AR/EN çevirileri o kültürde kullanılan gerçek dini adlandırmaları kullanacaktır.
316. Dini günlerde özel dua sahih kaynakta yoksa varmış gibi üretilemez.
317. Hicri tarihlerin ülkelere göre değişebileceği açıklanacaktır.
318. V1’de dünya çapında otomatik dini gün bildirimi verilmeden önce tarih kaynağı ayrıca doğrulanacaktır.
319. Gerekirse Dini Günler eğitsel bilgi olarak çalışır; kesin yerel Gregoryen gün için kullanıcıya kaynak bilgisi verilir.

---

## P. İSLAM TARİHİ

320. İslam Tarihi uygulamanın ayırt edici büyük modüllerinden biri olacaktır.
321. Tarih doğrudan 610 yılıyla başlamayacaktır.
322. İlk ana bölüm **İslam’dan Önce Dünya** olacaktır.
323. Geç Antik Çağ anlatılacaktır.
324. Bizans anlatılacaktır.
325. Sasani dünyası anlatılacaktır.
326. Habeşistan/Aksum anlatılacaktır.
327. Yemen ve Güney Arabistan anlatılacaktır.
328. Mekke’nin ekonomik/dini yapısı anlatılacaktır.
329. Medine/Yasrib anlatılacaktır.
330. Arap kabile düzeni anlatılacaktır.
331. Yahudi toplulukları anlatılacaktır.
332. Hristiyan toplulukları ve dönemin farklı Hristiyan gelenekleri anlatılacaktır.
333. Arap politeizmi ve diğer inanç biçimleri tarihsel bağlamıyla açıklanacaktır.
334. İslami vahiy perspektifi ile modern tarihsel araştırma gerektiğinde ayrı başlıklar halinde gösterilecektir.
335. Hristiyanlık “İslam’a hazırlık amacıyla yaratılmış tarihsel aşama” şeklinde nötr tarih gerçeği olarak sunulmayacaktır.
336. İslami perspektifte peygamberler/vahiy zinciri ayrıca anlatılacaktır.
337. Hz. Muhammed’in hayatı ayrıntılı kronoloji olacaktır.
338. Mekke dönemi.
339. Habeşistan hicretleri.
340. Akabe süreçleri.
341. Hicret.
342. Medine dönemi.
343. Önemli savaşlar ve antlaşmalar.
344. Hudeybiye.
345. Mekke’nin fethi.
346. Veda Haccı.
347. Vefat.
348. Hulefâ-yi Râşidîn.
349. İlk fitne dönemleri.
350. Emevîler.
351. Abbâsîler.
352. Endülüs.
353. Fâtımîler ve diğer bölgesel hanedanlar.
354. Selçuklular.
355. Haçlı Seferleri.
356. Eyyûbîler.
357. Moğol istilaları.
358. Memlükler.
359. Osmanlılar.
360. Safevîler.
361. Babürler.
362. Afrika’daki İslam tarihi.
363. Orta Asya tarihi.
364. Güneydoğu Asya İslam tarihi.
365. Hint alt kıtası.
366. Avrupa’daki İslam tarihi.
367. Sömürgecilik dönemi.
368. Modern ulus devletleri.
369. 20. yüzyıl.
370. Günümüz İslam dünyasına kadar kronoloji.
371. Tarih yalnız siyasi savaşlardan oluşmayacaktır.
372. Bilim tarihi olacaktır.
373. Tıp tarihi olacaktır.
374. Matematik/astronomi olacaktır.
375. Felsefe ve düşünce tarihi olacaktır.
376. Hadis/tefsir/fıkıh ilimlerinin gelişimi anlatılacaktır.
377. Sanat ve mimari olacaktır.
378. Ticaret ve şehirleşme olacaktır.
379. Eğitim kurumları olacaktır.
380. Kadınların tarihsel rolleri gerektiği yerde kaynaklarıyla anlatılacaktır.
381. Her olay kartında tarih, olay, öncesi, nedenleri, sonucu, kişiler, coğrafya ve kaynaklar bulunacaktır.
382. Tarih kesin değilse “yaklaşık” yazılacaktır.
383. Geleneksel kronoloji ile modern akademik görüş ayrışıyorsa ikisi dürüstçe gösterilecektir.
384. Tarih filtreleri: **Dönem / Bölge / Hanedan / Kişi / Bilim / Kültür / Savaş / Dinî gelişme** olacaktır.
385. Biyografi sistemi olacaktır.
386. Önemli kişi sayfaları kronolojideki olaylara bağlanacaktır.
387. Tarihi coğrafya için telifi uygun yerel vektör haritalar kullanılacaktır.
388. Harita kesin değilse “yaklaşık/schematic” belirtilecektir.
389. TDV İslâm Ansiklopedisi araştırma/doğrulama kaynağı olabilir ancak metni izinsiz kopyalanmayacaktır.

---

## Q. EK EĞİTİM MODÜLLERİ

390. **Peygamberler ve Vahiy** rehberi ana kapsamda bulunacaktır.
391. **Esmâü’l-Hüsnâ** rehberi bulunacaktır.
392. **Hac & Umre** eğitsel rehberi sunucusuz biçimde eklenebilir.
393. Hac/Umre rehberi canlı fiyat, uçuş veya tur bilgisi içermeyecektir.
394. **Korunma ve Sahih Rukye** rehberi değerlendirilebilir.
395. Rukye alanı cin teşhisi yapan bir sistem olmayacaktır.
396. Rukye tıbbi tedavinin yerine gösterilmeyecektir.
397. **Oruç Günlüğü** eklenebilir.
398. Oruç Günlüğü sahur/iftar saati hesaplamayacaktır.
399. Kullanıcı yalnız tuttuğu oruç günlerini kendisi işaretleyebilir.
400. **Namaz Günlüğü** isteğe bağlı eklenebilir.
401. Namaz Günlüğü namaz vakti hesaplamadan yalnız kullanıcının manuel işaretlemesine dayanacaktır.

---

## R. PAYLAŞIM SİSTEMİ

402. Uygulamanın viral/görsel yönü güçlü olacaktır.
403. Kullanıcı aynı ayet veya duayı farklı arka planlarda önizleyebilecektir.
404. Toplam **30 final paylaşım görseli** olacaktır.
405. 3 tasarım ücretsiz ve sınırsız olacaktır.
406. Kalan 27 tasarım kilitli olacaktır.
407. Kilitli tasarım kullanıcının isteğiyle rewarded reklam izlenerek o paylaşım için açılabilecektir.
408. Premium kullanıcı 30 tasarımın tamamını sınırsız kullanacaktır.
409. Paylaşım formatları: **Instagram Story 9:16 / WhatsApp Durum 9:16 / Instagram Post 4:5 / kare 1:1** olacaktır.
410. Reels için kısa motion kart desteği sonraki sürümde tamamen cihaz üzerinde üretilebilir.
411. Reels çıktısında telifli müzik gömülmeyecektir.
412. Kullanıcı müziği Instagram içerisinde kendisi ekleyebilir.
413. Paylaşım kartında ayet ise sure/ayet kaynağı bulunacaktır.
414. Kullanıcı kaynak satırını gizleyemeyecektir.
415. Dua genel editoryalse “Genel Dua” etiketi paylaşım kartında gerektiğinde korunacaktır.
416. Kullanıcı yazı boyutunu güvenli aralıkta değiştirebilir.
417. Ayet metnini değiştiremez.
418. Arka plan değiştirebilir.
419. Metin hizasını sınırlı seçeneklerle değiştirebilir.
420. Kontrast otomatik kontrol edilecektir.
421. Açık görselde koyu metin, koyu görselde açık metin kullanılacaktır.
422. Tasarım export öncesi okunabilirlik testi uygulanacaktır.
423. Canva yalnız stil araştırma kaynağı olabilir.
424. Canva Pro içeriklerinin yeniden kullanılabilir/export edilebilir uygulama arka planı olarak gömülmesi yazılı lisans olmadan yapılmayacaktır.
425. Final 30 assetin her birinde kaynak, lisans, lisans tarihi, kanıt ve dosya hash tutulacaktır.
426. En güvenli seçenek özgün veya açık yeniden dağıtım lisanslı asset kullanmaktır.

---

## S. BİLDİRİMLER VE WIDGET

427. Ezan bildirimi olmayacaktır.
428. Namaz vakti bildirimi olmayacaktır.
429. Günün ayeti bildirimi bulunabilir.
430. Günün duası bildirimi bulunabilir.
431. Zikir hatırlatması bulunabilir.
432. Dini gün hatırlatması yalnız güvenilir takvim verisi olduğunda kullanılacaktır.
433. Bildirimlerin tamamı opt-in olacaktır.
434. Kullanıcı her bildirim kategorisini ayrı kapatabilecektir.
435. Bildirimler cihazda planlanacaktır; kendi push backendimiz zorunlu olmayacaktır.
436. Uygulama kapalıyken yerel bildirim gelebilecektir.
437. Android reboot sonrasında gerekli yerel planlama yeniden kurulacaktır.
438. Bildirim metni dini yanlış bilgi içermemelidir.
439. Free kullanıcı offline iken bildirimde tam Premium içerik sızdırılmayacaktır.
440. Free kullanıcının bildirimi “Bugünün duası hazır” gibi olabilir.
441. Premium bildiriminde seçime bağlı olarak daha fazla içerik gösterilebilir.
442. Android ana ekran widget’ı bulunabilir.
443. Widget Günün Ayeti veya Günün Duası gösterebilir.
444. Widget tasarım özelleştirmelerinin bazıları Premium olabilir.

---

## T. FREE / PRO ÜRÜN MODELİ

445. İki ana kullanıcı durumu olacaktır: **FREE** ve **PRO/PREMIUM.**
446. Free kullanıcı reklamlıdır.
447. Pro kullanıcı kesinlikle reklamsızdır.
448. Pro entitlement aktif olduğunda reklam SDK yolları mümkün olan en erken aşamada devre dışı bırakılacaktır.
449. Pro kullanıcıya banner gösterilmez.
450. Pro kullanıcıya interstitial gösterilmez.
451. Pro kullanıcıya rewarded teklif edilmez.
452. Önceden yüklenmiş reklam varsa Pro geçişinde dispose edilir.
453. FREE kullanıcı için internet zorunlu olacaktır.
454. Uygulama cihazın doğrulanmış internet bağlantı durumunu Android ağ API’leriyle kontrol edecektir.
455. Free kullanıcı uygulamayı internet olmadan açarsa offline gate ekranı görecektir.
456. Free kullanıcı çevrimdışı dini kütüphaneyi kullanamayacaktır.
457. Pro kullanıcının temel içerikleri çevrimdışı çalışacaktır.
458. Free kullanıcının interneti kısa süre kesilirse mevcut ekran aniden kapatılmadan yeni içerik geçişinde gate uygulanabilir.
459. Reklamın dolmaması kullanıcının dini içeriğe erişimini ayrıca engellememelidir; internet var ama ad-fill yoksa içerik açılacaktır.
460. Free kullanıcı için ana ekranda uygun yerleştirilmiş reklam bulunabilir.
461. Kur’an metninin içinde reklam bulunmaz.
462. Dua metninin ortasında reklam bulunmaz.
463. Zikir esnasında reklam gösterilmez.
464. Reklam kutsal metni bölemez.
465. Rewarded reklam kullanıcı kendi iradesiyle Premium paylaşım görseli istediğinde kullanılacaktır.
466. Reward açıkça **“Reklamı tamamla → bu tasarımla 1 paylaşım hakkı”** şeklinde anlatılacaktır.
467. Rewarded reklam tamamlanmadan ödül verilmez.
468. Reklam başarısız yüklenirse kullanıcıya hata verilir; Pro satın alma zorlanmaz.
469. Google rewarded politika şartlarına uyulacaktır.
470. Reklam kategorileri mümkün olan en sıkı şekilde filtrelenecektir.
471. Alkol, kumar, yetişkin içerik, flört ve uygunsuz kategoriler bloklanacaktır.
472. Max ad content rating düşük tutulacaktır.
473. Dini kullanım verisi reklam kişiselleştirmesinde kullanılmayacaktır.
474. Mümkün olan yerlerde non-personalized/contextual reklam tercih edilecektir.
475. Kullanıcı Premium’a geçtiğinde reklam consent tercihi artık ürün içi reklam göstermek için kullanılmayacaktır.
476. Premium temel öneri **tek seferlik Lifetime PRO** olabilir.
477. Android’de dijital Premium açılımı Google Play Billing non-consumable one-time product olarak yapılandırılabilir.
478. Ürün ID baştan doğru seçilecektir.
479. Satın alma geri yükleme olacaktır.
480. Pro satın alma internete bağlıyken Google Play’den doğrulanacaktır.
481. Doğrulanmış Pro durumu cihazda güvenli biçimde cache edilecektir ki kullanıcı daha sonra offline kullanabilsin.
482. Yeni kurulumda Lifetime Pro restore için ilk kez internet gerekebilir.
483. Kendi sunucumuz olmayacağı için lisans korsanlığına karşı korumanın sunucu doğrulamalı sistem kadar güçlü olamayacağı teknik olarak kabul edilecektir.
484. Kullanıcı deneyimini bozacak aşırı DRM uygulanmayacaktır.
485. iOS’a çıkıldığında dijital Premium özellik Apple In-App Purchase ile satılacaktır.

---

## U. PREMIUM DEĞER ÖNERİSİ

486. Premium dini doğruluğu satın alma konusu yapmayacaktır.
487. Premium şu değerleri verecektir: tüm reklamların kaldırılması, offline kullanım, 30 paylaşım tasarımının tamamı, rewarded reklamsız sınırsız paylaşım, gelişmiş tema seçenekleri, gelişmiş widget görünümleri, daha fazla görsel özelleştirme ve bazı kişisel kullanım kolaylıkları.
488. Kur’an’ın temel metni Premium’a kilitlenmeyecektir.
489. Dini günlerde “doğru bilgi görmek için ödeme yap” modeli kullanılmayacaktır.
490. Dua kaynak bilgisi Premium’a kilitlenmeyecektir.
491. Hadis derecesi Premium’a kilitlenmeyecektir.
492. Zikrin dini dayanağı Premium’a kilitlenmeyecektir.
493. Premium **bilginin doğruluğunu değil deneyimin konforunu** satar.

---

## V. GİZLİLİK

494. Gizlilik uygulamanın ana marka değerlerinden biri olacaktır.
495. Kullanıcının dini soruları cihazdan çıkmayacaktır.
496. Kullanıcının hangi konuları aradığı reklam ağına aktarılmayacaktır.
497. “Borç”, “evlilik”, “hastalık”, “tövbe” gibi kişisel sorgular analytics olayı haline getirilmeyecektir.
498. Kendi analytics backendimiz olmayacaktır.
499. Firebase Analytics V1’de zorunlu olmayacaktır.
500. Meta/Facebook Pixel benzeri takip SDK’ları eklenmeyecektir.
501. Crash analizi için mümkün olduğunca Google Play Android Vitals kullanılacaktır.
502. Remote crash SDK eklenirse hassas kullanıcı metni kesinlikle loglanmayacaktır.
503. Kullanıcı notları cihazda kalacaktır.
504. Favoriler cihazda kalacaktır.
505. Zikir geçmişi cihazda kalacaktır.
506. Soru geçmişini tutmak varsayılan olarak kullanıcı tercihine bağlı olabilir.
507. Kullanıcı geçmişi tek düğmeyle silebilecektir.
508. Kullanıcı tüm yerel kişisel verileri sıfırlayabilecektir.
509. Android Auto Backup içinde hassas dini soru/not verisinin otomatik buluta çıkması engellenecek veya açıkça kontrol edilecektir.
510. Uygulama konum izni istemeyecektir; namaz vakti çıkarıldığı için gerek yoktur.
511. Kıble ileride eklenirse konum yalnız kullanıcı Kıble’yı açtığında istenecek ve cihazda işlenecektir.
512. Free/Pro ayrımı dışında kullanıcı profilleme yapılmayacaktır.
513. Reklam kullanıcı sorgularına göre hedeflenmeyecektir.
514. Dini inanç verileri hassas veri kabul edilerek veri minimizasyonu uygulanacaktır.

---

## W. HUKUK VE LİSANSLAR

515. Uygulamanın Privacy Policy’si olacaktır.
516. Kullanım Koşulları olacaktır.
517. Dini İçerik Metodolojisi sayfası olacaktır.
518. Kaynaklar ve Lisanslar sayfası olacaktır.
519. “Fetva hizmeti değildir” açıklaması olacaktır.
520. Tıbbi sonuç garantisi olmadığı gerekli alanlarda belirtilecektir.
521. Finansal sonuç garantisi olmadığı gerekli alanlarda belirtilecektir.
522. Genel/editoryal dualar kaynaklı vahiy metni gibi sunulmayacaktır.
523. Kullanılan her Qur’an API/veri kaynağı için güncel developer terms ve kaynak-spesifik lisans kontrol edilecektir.
524. API/cache/offline kuralları ürün mimarisiyle uyumlu olmak zorundadır.
525. Her üçüncü taraf dini içeriğin ayrı lisans kaydı tutulacaktır.
526. Font lisansları kaydedilecektir.
527. Görsel lisansları kaydedilecektir.
528. Hadis kaynaklarının exact translation telifleri kontrol edilecektir.
529. Telif hakkı belirsiz meal uygulamaya alınmayacaktır.
530. TDV metinleri izinsiz kopyalanmayacaktır.
531. Sosyal medyadan bulunan görsel/dua doğrudan kopyalanmayacaktır.
532. Uygulama gerçek yazılı yetki olmadan “Diyanet onaylı”, “Quran Foundation approved”, “resmî Kur’an uygulaması” gibi ifadeler kullanmayacaktır.
533. Mağaza görsellerinde yanlış veya yanıltıcı dini alıntı kullanılmayacaktır.
534. Hedef ülkeler için yayın matrisi oluşturulacaktır.
535. Türkiye ayrıca incelenecektir.
536. Avrupa Ekonomik Alanı ayrıca incelenecektir.
537. Birleşik Krallık ayrıca incelenecektir.
538. ABD/California ayrıca incelenecektir.
539. Körfez ülkeleri ayrıca incelenecektir.
540. Malezya/Endonezya/Pakistan gibi Kur’an yayıncılığı konusunda özel yerel düzenleme bulunabilecek pazarlar ayrıca incelenecektir.
541. Hukuki gerekliliği belirsiz pazarda “nasıl olsa Play kabul eder” mantığı kullanılmayacaktır.
542. Uygulama global açılmadan önce ülke bazlı `GREEN / REVIEW / HOLD` matrisi hazırlanacaktır.
543. Şartname hukuki riskleri teknik olarak azaltır ancak gerektiğinde yerel hukuk görüşünün yerini tutmaz.

---

## X. YAŞ / ÇOCUKLAR

544. V1 özel olarak çocuk uygulaması şeklinde pazarlanmayacaktır.
545. Store hedef yaş grubu buna göre seçilecektir.
546. Çocuklara yönelik özel gamification veya çizgi film dili kullanılmayacaktır.
547. İleride ayrı Kids Mode yapılırsa Google Play Families/COPPA vb. kurallar yeniden ele alınacaktır.
548. Çocuk hedefleme açılırsa kişiselleştirilmiş reklam kullanılmayacaktır.

---

## Y. ERİŞİLEBİLİRLİK

549. Sistem font büyütme desteklenecektir.
550. Uzun meal metinleri font büyüyünce kesilmeyecektir.
551. Screen reader label’ları olacaktır.
552. İkonlar yalnız görsel anlama dayanmayacaktır.
553. Kaynak güvenilirlik seviyesi yalnız renkle anlatılmayacaktır; yazı etiketi de olacaktır.
554. Minimum dokunma alanları yaklaşık 44–48 dp olacaktır.
555. Kontrast erişilebilirlik prensiplerine göre kontrol edilecektir.
556. Reduced motion tercihine saygı gösterilecektir.
557. Arapça harekeler küçük ekranlarda okunabilir olacaktır.
558. Kur’an font boyutu bağımsız değiştirilebilir olacaktır.

---

## Z. PERFORMANS VE KALİTE

559. Uygulama ilk açılış süresi gereksiz SDK’larla uzatılmayacaktır.
560. Ana ekran mümkün olduğunca 1–2 saniye içinde kullanılabilir hale gelmelidir.
561. Büyük history verisi lazy load edilecektir.
562. Arama indeksleri cihazda hazırlanacaktır.
563. 30 görsel uygun sıkıştırmayla saklanacaktır.
564. Kutsal metin görsel sıkıştırmadan etkilenmeyecek; metin runtime render edilecektir.
565. Ana uygulama boyutu kontrol altında tutulacaktır.
566. Tam ses kütüphanesi V1 paketine gömülmeyecektir.
567. Crash-free hedefi yayın öncesi yüksek tutulacaktır.
568. Düşük RAM cihazlarda test yapılacaktır.
569. Android farklı ekran oranları test edilecektir.
570. Tablet düzeni bozulmayacaktır.

---

## AA. DİNİ İÇERİK YÖNETİMİ

571. Her dini kayıt benzersiz ID taşır.
572. Her kayıt `source_status` taşır.
573. Her kayıt `review_status` taşır.
574. Her kayıt `version` taşır.
575. Her kayıt `last_reviewed_at` taşır.
576. Her kayıt `reviewer` bilgisi taşıyabilir.
577. Yayın statüleri: **draft / research / religious-review / language-review / approved / published / withdrawn.**
578. Onaylanmamış kayıt uygulama final verisine girmez.
579. Kaynak bulunamayan iddia ayrıca “research rejected” arşivinde tutulabilir; uygulamaya çıkmaz.
580. Kritik dini kayıtlar çift kontrol edilir.
581. Ayetlerin tamamı otomatik doğrulamadan geçer.
582. Hadis numaraları manuel/otomatik kontrol edilir.
583. Tarih olayları mümkün olduğunca en az iki güvenilir kaynakla çapraz kontrol edilir.
584. Tartışmalı tarih olaylarında tek anlatı dayatılmaz.
585. Editoryal genel dualar ana dil editörlüğünden ve dini uygunluk kontrolünden geçer.
586. Arapça dini metinler native Arabic reviewer tarafından kontrol edilir.
587. İngilizce native/editorial review yapılır.
588. Türkçe native/editorial review yapılır.
589. Üç dil onayı olmadan final dataset oluşturulmaz.

---

## AB. QA — DİNİ DOĞRULUK TESTLERİ

590. 114 sure varlık testi.
591. Her surenin doğru ayet sayısı testi.
592. Her ayetin doğru sure numarası testi.
593. Kaynak metin hash karşılaştırması.
594. Kur’an’da eksik karakter testi.
595. Arapça hareke/pause işaretlerinin seçilen kaynakla uyum testi.
596. TR meal içerik bütünlüğü testi.
597. EN meal içerik bütünlüğü testi.
598. Her meal kaydında source ID testi.
599. Dua kaynak zorunluluğu testi.
600. Hadis duası authenticity metadata testi.
601. “Genel dua”ların yanlışlıkla hadis etiketi almaması testi.
602. Zikir kaynak sayısı testi.
603. Ebced sayısının “sünnet” etiketi alamaması testi.
604. Geleneksel uygulamaların source badge testi.
605. “Kesin para getirir / kesin şifa verir / kesin âşık eder” gibi yasak sonuç vaatlerini veri setinde tarayan test olacaktır.
606. “Allah sana cevap verdi” benzeri yasak dil kalıpları otomatik taranacaktır.
607. Dini günlerde özel dua iddiaları kontrol edilecektir.
608. Tarih kesinlik etiketleri kontrol edilecektir.

---

## AC. QA — DİL SIZINTISI

609. TR UI tam tarama.
610. EN UI tam tarama.
611. AR UI tam tarama.
612. TR→EN sızıntı testi.
613. TR→AR sızıntı testi.
614. EN→TR sızıntı testi.
615. EN→AR sızıntı testi.
616. AR→TR sızıntı testi.
617. AR→EN sızıntı testi.
618. Ana ekran test edilir.
619. Kur’an test edilir.
620. Dua test edilir.
621. Zikir test edilir.
622. Peygamberler test edilir.
623. Tarih test edilir.
624. Dini gün test edilir.
625. Konu arama test edilir.
626. Premium test edilir.
627. Reklam hata durumları test edilir.
628. Billing mesajları test edilir.
629. Offline gate test edilir.
630. Bildirimler test edilir.
631. Widget test edilir.
632. Paylaşım görselleri test edilir.
633. Empty states test edilir.
634. Hata dialogları test edilir.
635. Permission dialog açıklamaları test edilir.
636. Her alan üç dilde test edilecektir.

---

## AD. QA — MONETİZASYON VE PAYLAŞIM

637. Free online test.
638. Free offline bloke testi.
639. Pro online test.
640. Pro offline test.
641. Free reklam görünürlük testi.
642. Pro reklam sıfır testi.
643. Rewarded başarılı test.
644. Rewarded iptal testi.
645. Rewarded network fail testi.
646. Rewarded tamamlanınca bir kullanım hakkı testi.
647. Pro geçişte yüklü reklam dispose testi.
648. Purchase success.
649. Purchase cancel.
650. Purchase pending.
651. Purchase restore.
652. Reinstall restore.
653. Offline cached entitlement.
654. Refund/revoked purchase online olduğunda kontrol edilmelidir.
655. Premium görsel kilitleri test edilir.
656. 3 free görselin sürekli açık olması test edilir.
657. 27 premium görselin gate davranışı test edilir.
658. Instagram Story 9:16 export birebir test edilir.
659. WhatsApp Status 9:16 export birebir test edilir.
660. Instagram Post 4:5 export birebir test edilir.
661. Kare 1:1 export birebir test edilir.
662. Uzun ayetin hiçbir formatta kesilmediği test edilir.
663. Arapça RTL paylaşım render’ı test edilir.
664. Kaynak satırının exportta silinemediği test edilir.
665. Rewarded ile açılan tasarımın yalnız tanımlanan kullanım hakkını verdiği test edilir.
666. Pro kullanıcının 30 görselde hiçbir reklam akışına düşmediği test edilir.

---

## AE. QA — GİZLİLİK VE GÜVENLİK

667. Soru yazılırken network packet kontrolü yapılacaktır.
668. Ham soru hiçbir ad request’ine girmemelidir.
669. Ham soru analytics’e gitmemelidir.
670. Ham dua/zikir kullanım tercihleri reklam segmentine gitmemelidir.
671. Sensitive local DB encryption testi.
672. App backup testi.
673. Clipboard sızıntı testi.
674. Screenshot/share dışında kişisel not yanlışlıkla export edilmemelidir.
675. Debug loglarda soru metni bulunmamalıdır.
676. Release build’de debug loglar kapatılmalıdır.
677. API key varsa APK içine gereksiz gizli secret gömülmemelidir.
678. Kullanılmayan Android izinları manifestten çıkarılacaktır.
679. Konum izni olmayacaktır.
680. Mikrofon izni V1’de olmayacaktır.
681. Kamera izni olmayacaktır.
682. Rehber/contacts izni olmayacaktır.

---

## AF. KRONOLOJİK GELİŞTİRME PLANI

683. **Önce bu master şartname dondurulacaktır.**
684. Ürün adı ve marka kimliği kesinleştirilecektir.
685. Dini metodoloji belgesi hazırlanacaktır.
686. “Ne fetvadır / ne değildir” sınırı yazılı hale getirilecektir.
687. Kullanılacak Kur’an Arapça kaynak/lisansı kesinleştirilecektir.
688. Türkçe meal kesinleştirilecektir.
689. İngilizce meal kesinleştirilecektir.
690. Hadis/dua kaynak zinciri kesinleştirilecektir.
691. Görsel lisans politikası kesinleştirilecektir.
692. Font lisansları kesinleştirilecektir.
693. Üç dil terminoloji sözlüğü oluşturulacaktır.
694. Ana tema taksonomisi çıkarılacaktır.
695. Dua kategorileri çıkarılacaktır.
696. Zikir rehberi veri modeli çıkarılacaktır.
697. Ebced/geleneksel kaynak ayrım modeli çıkarılacaktır.
698. Peygamberler ve vahiy kronolojisi veri modeli çıkarılacaktır.
699. İslam tarihi dönem ağacı çıkarılacaktır.
700. Uygulamanın tüm bilgi mimarisi kağıt üzerinde tamamlanacaktır.
701. 5 tab bottom navigation kilitlenecektir.
702. Wireframe hazırlanacaktır.
703. Wireframe üzerinde karmaşa testi yapılacaktır.
704. Light-first marka tasarım sistemi hazırlanacaktır.
705. Koyu AI-dashboard tasarım kalıpları yasak tasarım listesine alınacaktır.
706. Ana ekran final wireframe oluşturulacaktır.
707. Kur’an wireframe.
708. Keşfet wireframe.
709. Zikir wireframe.
710. Profil wireframe.
711. Dua detay wireframe.
712. Peygamberler wireframe.
713. Vahiy kronolojisi wireframe.
714. Tarih timeline wireframe.
715. Konu arama wireframe.
716. Share editor wireframe.
717. Premium store wireframe.
718. Arapça RTL wireframe ayrıca kontrol edilecektir.
719. Daha sonra Flutter proje iskeleti kurulacaktır.
720. Locale altyapısı ilk kodlanan modüllerden biri olacaktır.
721. Theme/design token sistemi ikinci temel altyapı olacaktır.
722. Yerel veritabanı mimarisi kurulacaktır.
723. Content schema oluşturulacaktır.
724. User-data schema oluşturulacaktır.
725. Kur’an import pipeline yapılacaktır.
726. Kur’an bütünlük scriptleri hazırlanacaktır.
727. TR/EN meal import pipeline.
728. Kaynak ekranı.
729. Kur’an reader.
730. Favorites/history.
731. Daily engine.
732. Dua database.
733. Dua reader.
734. Zikir counter.
735. Zikir guide.
736. Esmâ rehberi.
737. Ebced source layers.
738. Question normalization engine.
739. TR phrase dictionary.
740. EN phrase dictionary.
741. AR phrase dictionary.
742. Fuzzy matcher.
743. Theme scorer.
744. Ayet-theme mapping.
745. Low-confidence safety flow.
746. Dini gün database.
747. Peygamberler database.
748. Vahiy timeline.
749. Peygamber biyografi bağlantıları.
750. İslam tarihi database.
751. Timeline.
752. Biographies.
753. Search index.
754. Universal search.
755. Local notifications.
756. Widget.
757. Share renderer.
758. 30 final lisanslı arka plan.
759. Story export.
760. Post export.
761. WhatsApp Status export.
762. Rewarded ad integration.
763. Free/Pro ad suppression.
764. Play Billing.
765. Lifetime Pro entitlement.
766. Offline gate.
767. Premium offline access.
768. Privacy controls.
769. Legal screens.
770. Üç dil full pass.
771. Religious content full pass.
772. Security/network audit.
773. Monetization audit.
774. UI consistency audit.
775. Accessibility audit.
776. Performance/stress audit.
777. Release candidate oluşturulacaktır.
778. Release candidate dataset hash'i sabitlenecektir.
779. Final dini içerik review yapılacaktır.
780. Final TR native review.
781. Final EN native review.
782. Final AR native review.
783. Final legal/store review.
784. Android internal test.
785. Closed beta.
786. Beta hata raporları sınıflandırılacaktır.
787. Dini içerik hatası teknik bugdan daha yüksek öncelikte ele alınacaktır.
788. Dini doğruluk, dil veya privacy kırmızı hatası varsa release durdurulacaktır.
789. Final AAB/APK exact hash kayıt altına alınacaktır.
790. Store listing TR hazırlanacaktır.
791. Store listing EN hazırlanacaktır.
792. Store listing AR hazırlanacaktır.
793. Screenshots üç dilde hazırlanacaktır.
794. Premium açıklaması yanıltıcı olmayacaktır.
795. Privacy URL çalışır olacaktır.
796. İlk ülke grubu hukuk matrisiyle yayınlanacaktır.

---

## AG. “FINAL” DENMESİNİ ENGELLEYEN KIRMIZI ÇİZGİLER

797. Bir Kur’an ayeti kaynakla birebir doğrulanmadıysa final değildir.
798. Meal lisansı belirsizse final değildir.
799. Kaynağı olmayan hadis iddiası varsa final değildir.
800. Hadis derecesi yanlışsa final değildir.
801. Kaynaksız özel dini gün duası varsa final değildir.
802. Ebced sayısı sünnet sayısı gibi gösteriliyorsa final değildir.
803. “Kesin para/aşk/şifa” iddiası varsa final değildir.
804. Kullanıcı sorusu dış servise sızıyorsa final değildir.
805. Free offline çalışıyorsa iş modeli şartına göre final değildir.
806. Pro reklam görüyorsa final değildir.
807. Herhangi bir dil sızıntısı varsa final değildir.
808. Arapça RTL bozuksa final değildir.
809. Ayet paylaşımda kesiliyorsa final değildir.
810. Kaynak paylaşım kartında yanlışsa final değildir.
811. Canva/stock asset lisansı belirsizse final değildir.
812. Store Billing restore çalışmıyorsa final değildir.
813. Privacy Policy uygulamanın gerçek davranışıyla uyuşmuyorsa final değildir.
814. Uygulama herhangi bir yerde kendisini resmî dini otorite gibi yanlış tanıtıyorsa final değildir.
815. Koyu/jenerik AI mockup UI’sı kalmışsa tasarım final değildir.
816. Uygulamanın ana ekranı kullanıcıya karmaşık geliyorsa özellikler tamamlanmış olsa bile ürün final değildir.
817. Instagram Story / WhatsApp Status / Post paylaşım akışlarından biri gerçek cihaz testinde bozuksa final değildir.
818. Rewarded reklam ödül davranışı gerçek cihaz testinde hatalıysa final değildir.
819. Pro entitlement sonrası herhangi bir reklam isteği/gösterimi devam ediyorsa final değildir.

---

## AH. PEYGAMBERLER VE VAHİY TARİHİ — ANA MODÜL

820. Uygulamada ayrı **“Peygamberler”** ana bölümü bulunacaktır.
821. Bölüm aynı zamanda **“Vahiy Tarihi”** kronolojisi olarak çalışacaktır.
822. Hz. Âdem’den Hz. Muhammed’e kadar Kur’an’da adı açıkça geçen 25 peygamberin tamamı ayrı kapsamlı dosyaya sahip olacaktır.
823. Hz. Âdem ilk, Hz. Muhammed son peygamber olarak İslami kaynak çerçevesinde gösterilecektir.
824. Kur’an’da isimleri geçmekle birlikte peygamberlikleri ihtilaflı olan Lokman, Üzeyir ve Zülkarneyn kesin peygamber listesine karıştırılmayacaktır.
825. Şît gibi sonraki İslami rivayetlerde peygamber kabul edilen fakat Kur’an’da adı bulunmayan kişiler ayrı **“Geleneksel Rivayetler”** statüsünde ele alınacaktır.
826. Hızır gibi kimliği veya peygamberliği tartışmalı kişiler ayrıca işaretlenecektir.
827. Uygulama “tarihte yaşamış bütün peygamberlerin isimlerini biliyoruz” iddiasında bulunmayacaktır.
828. Kur’an’ın isimleri bildirilmeyen başka peygamberlerin de bulunduğunu bildiren yaklaşımı korunacaktır.
829. Uygulama “peygamberlerin toplam sayısı kesin 124.000’dir” gibi tartışmalı rivayetleri kesin bilgi olarak sunmayacaktır.
830. Ana kronoloji mümkün olduğu ölçüde şu çizgide kurulacaktır: **Âdem → İdris → Nuh → Hud → Salih → İbrahim/Lut → İsmail/İshak → Yakub → Yusuf → Eyyub → Şuayb → Musa/Harun → Davud → Süleyman → İlyas → Elyesa → Yunus → Zülkifl → Zekeriyya → Yahya → İsa → Muhammed.**
831. Bu sıra “miladi kesin tarih çizgisi” olarak değil, kaynakların izin verdiği yaklaşık peygamberlik zinciri olarak sunulacaktır.
832. Aynı dönemde yaşamış peygamberler paralel timeline üzerinde gösterilebilecektir.
833. Tarihi bilinmeyen peygambere tarih uydurulmayacaktır.
834. Kesin olmayan tarih `yaklaşık`, `geleneksel`, `tartışmalı` veya `bilinmiyor` statüsü taşıyacaktır.
835. Her peygamber sayfasında isim bulunacaktır.
836. Arapça isim bulunacaktır.
837. Türkçe yerleşik isim bulunacaktır.
838. İngilizce yerleşik isim bulunacaktır.
839. Kur’an’da geçtiği sure/ayet referansları bulunacaktır.
840. İlgili ayetlere doğrudan Kur’an okuyucudan erişilebilecektir.
841. Aile/soy ilişkileri yalnız güvenilir olduğu ölçüde gösterilecektir.
842. Gönderildiği kavim/toplum bilgisi bulunacaktır.
843. Yaşadığı düşünülen coğrafya bulunacaktır.
844. Yaşadığı dönem bilgisi bulunacaktır.
845. Kesin tarih varsa kesin tarih gösterilecektir.
846. Yaklaşık tarih varsa açıkça **“yaklaşık”** yazılacaktır.
847. Tarih bilinmiyorsa **“Kesin tarih bilinmiyor”** denecektir.
848. Doğumu hakkında güvenilir bilgiler bulunacaktır.
849. Çocukluk/gençlik bilgileri yalnız güvenilir kaynak varsa bulunacaktır.
850. Peygamberlik görevinin başlangıcı anlatılacaktır.
851. Tebliğinin ana mesajı anlatılacaktır.
852. Kavminin/toplumunun tepkileri anlatılacaktır.
853. Hayatındaki önemli olaylar kronolojik sırada anlatılacaktır.
854. Mucizeler yalnız kaynaklarıyla anlatılacaktır.
855. Kendisine kitap/sahife verilip verilmediği kaynak durumuyla gösterilecektir.
856. İlgili duaları bağlanacaktır.
857. Kur’an kıssasının tematik anlatımı olacaktır.
858. Vefatı hakkında güvenilir bilgi varsa gösterilecektir.
859. Mezar yeri iddiaları kesinmiş gibi yazılmayacaktır.
860. Sonraki İslam tarihindeki etkisi gerektiğinde anlatılacaktır.
861. Yahudilik/Hristiyanlıkta karşılığı varsa ayrı karşılaştırmalı tarih bölümü olabilir.
862. Karşılaştırma diğer dini gelenekleri küçümsemeyecektir.
863. İslami anlatı ile Kitab-ı Mukaddes anlatısı birbirine karıştırılmayacaktır.
864. Her bilgi satırı şu kaynak sınıflarından birini taşıyabilecektir: **Kur’an / Sahih-Hasen Hadis / Erken İslam tarihi-tefsir / İsrailiyat / Sonraki gelenek / Modern tarih-arkeoloji / Tartışmalı / Bilinmiyor.**
865. İsrailiyat kaynaklı anlatı Kur’an gerçeği gibi gösterilmeyecektir.
866. Popüler “peygamber hikâyeleri”ndeki ayrıntılar tek tek doğrulanacaktır.
867. Çocuk kitaplarından veya sosyal medyadan kaynak alınmayacaktır.
868. Bir olay yalnız zayıf/tartışmalı kaynaklarda bulunuyorsa kullanıcı bunu görecektir.
869. Modern arkeoloji bir geleneksel tarihle uyuşmuyorsa çatışma saklanmayacak; iki perspektif ayrılacaktır.
870. Kullanıcı **“Vahiy Yolculuğu”** isimli timeline açabilecektir.
871. Timeline yalnız düz liste olmayacaktır.
872. Aynı dönemde yaşayan peygamberler paralel gösterilebilecektir.
873. Soy/aile ilişkileri için ayrı sade şema bulunacaktır.
874. Harita üzerinde güvenilir olduğu ölçüde ilgili bölgeler gösterilecektir.
875. Kesin konum bilinmiyorsa pin “yaklaşık bölge” diye işaretlenecektir.
876. Kullanıcı kronolojiyi dönemlere göre gezebilecektir.
877. Filtreler **İlk peygamberler / İbrahimî dönem / İsrailoğulları peygamberleri / Hz. İsa dönemi / Hz. Muhammed dönemi** gibi olabilir.
878. Hz. Nuh gibi örneklerde Kur’an’ın açıkça verdiği bilgi ile sonraki rivayet ayrıntıları aynı güven düzeyinde gösterilmeyecektir.
879. Hz. Musa’nın Firavun döneminin hangi firavun olduğu kesin değilse tek isim kesinleştirilmeyecektir.
880. Hz. İbrahim için kesin miladi doğum yılı güvenilir biçimde bilinmiyorsa tek yıl uydurulmayacaktır.
881. Hz. Âdem için bilimsel/tarihsel yıl hesapları dinî gerçek gibi sunulmayacaktır.
882. Hz. İsa bölümünde İslam’ın inanç anlatısı ile Roma dönemi tarih araştırmaları ayrı katmanda gösterilecektir.
883. Hz. Muhammed’in hayatı kaynak hacmi nedeniyle diğer peygamberlerden doğal olarak çok daha ayrıntılı olacaktır.
884. Siyer kronolojisi doğum/Mekke, gençlik, evlilik, Hira, ilk vahiy, Mekke tebliği, Habeşistan hicretleri, boykot, Tâif, İsrâ/Miraç, Akabe, hicret, Medine, gazve ve antlaşmalar, Hudeybiye, Mekke’nin fethi, Veda Haccı ve vefat gibi ayrıntılı alt olaylara bölünecektir.
885. Bir peygamberin duasına dokunulduğunda Dua bölümüne gidilebilecektir.
886. İlgili ayete dokunulduğunda Kur’an okuyucu açılacaktır.
887. Peygamberin yaşadığı dönem İslam Tarihi kronolojisine bağlanacaktır.
888. İlgili coğrafya tarih haritasına bağlanacaktır.
889. Günün Ayeti bir peygamber kıssasına aitse **“Bu kıssayı keşfet”** butonu çıkabilecektir.
890. “Bugün ne öğrenelim?” bölümünde peygamber hayatlarından kısa fakat kaynaklı okuma önerileri çıkabilecektir.
891. Peygamber hayatlarının tamamı TR/EN/AR ana dil seviyesinde hazırlanacaktır.
892. Arapça içerik Türkçeden otomatik çevrilmeyecektir.
893. İngilizce içerik Türkçeden kelime kelime çevrilmeyecektir.
894. Kişi adları her dilde o kültürde yerleşmiş dini biçimiyle gösterilecektir: `Musa / Moses / موسى` gibi.
895. Her peygamberin Kur’an referanslarının otomatik listesi oluşturulacaktır.
896. Referansların tamamı ayet veri tabanıyla karşılaştırılacaktır.
897. Kaynaksız biyografi cümlesi tespit edilmeye çalışılacaktır.
898. Kesin tarih olmayan kayıtta tek kesin tarih gösterilmesi QA hatası olacaktır.
899. İsrailiyat içeriklerinin kaynak etiketi test edilecektir.
900. Üç dil içerik eşleşmesi test edilecektir.
901. Soy ilişkilerinin birbiriyle çelişmediği veri doğrulaması yapılacaktır.
902. Vahiy timeline ile İslam Tarihi timeline’ın kronolojik çatışmaları kontrol edilecektir.
903. Temel ilke: **“Bilmiyoruz” diyebilmek uygulamanın zayıflığı değil, güvenilirliğinin göstergesidir.**

---

## AI. 30 PAYLAŞIM GÖRSELİ — SEÇİM ÖNCESİ KİLİTLİ TASARIM GÖREVİ

904. Bu şartname kaydedildiği anda 30 final paylaşım görseli **henüz seçilmiş kabul edilmeyecektir**.
905. Görsel seçimi geliştirmeden önce ayrı bir tasarım aşaması olarak yapılacaktır.
906. 30 görsel tek tonda olmayacaktır.
907. Koyu petrol yeşili ağırlıklı tekrar eden AI mockup dili yasaktır.
908. 30 görsel en az birkaç ayrı görsel aileye ayrılacaktır; örneğin sıcak minimal, doğal doku, gece/gökyüzü, mimari soyut, tipografik, soft geometrik, sakin ışık gibi.
909. Tarot, astroloji, chakra, kristal, yoga veya dini kimliği bulanıklaştıran görseller kullanılmayacaktır.
910. Cami/minare görselleri her tasarımda tekrar edilmeyecektir.
911. Ayet ve dua için yeterli temiz metin alanı zorunludur.
912. Uzun metinlerde de okunabilirlik korunmalıdır.
913. TR/EN/AR aynı görsel üzerinde ayrı ayrı okunabilir olmalıdır.
914. Arapça RTL için metin güvenli alanı ayrıca kontrol edilecektir.
915. Story 9:16 crop güvenliği her görselde test edilecektir.
916. Post 4:5 crop güvenliği her görselde test edilecektir.
917. Kare 1:1 crop güvenliği her görselde test edilecektir.
918. WhatsApp Status güvenli alanı test edilecektir.
919. Her asset için uygulamada yeniden dağıtım/export hakkı kanıtlanmadan seçime alınmayacaktır.
920. Her asset için source/license manifest tutulacaktır.
921. 30 görsel kullanıcıyla ayrıca incelenip seçim tamamlandıktan sonra bu bölümde asset kimlikleri sabitlenecektir.
922. 3 ücretsiz görsel ve 27 kilitli görsel tasarım kalitesi bakımından yapay biçimde “kötü/iyi” ayrımı taşımayacaktır; ücretsiz üçlü de uygulamayı iyi temsil etmelidir.
923. Final görseller seçilmeden paylaşım sistemi görsel anlamda final kabul edilmeyecektir.

---

## AJ. ŞARTNAMEDEN ÜRETİLECEK YAPILACAK LİSTESİ VE TAMAMLAMA KURALI

924. Daha sonra oluşturulacak `TODO.md`, bu şartnamedeki tüm uygulanabilir maddeleri iş paketlerine dönüştürecektir.
925. TODO maddeleri kronolojik olacak; temel mimari tamamlanmadan ona bağlı ileri iş “tamamlandı” sayılmayacaktır.
926. Her TODO maddesinde şartname madde numarası referansı bulunacaktır.
927. Bir şartname maddesi birden fazla teknik görev gerektiriyorsa TODO’da alt görevlere bölünecektir.
928. Hiçbir şartname maddesi “zaten yapılmış sayıldı” diye sessizce atlanmayacaktır.
929. Her tamamlanan görev için mümkün olduğunda test/kanıt bulunacaktır.
930. UI tamamlandı demek yalnız ekranın görünmesi anlamına gelmeyecektir; navigation, state, hata durumu, empty state ve üç dil davranışı test edilecektir.
931. Reklam tamamlandı demek yalnız AdMob SDK’nın eklenmesi anlamına gelmeyecektir; Free/Pro ayrımı, rewarded ödülü, failure/cancel, loaded-ad disposal ve kutsal içerik çevresindeki yasak alanlar gerçek davranışla test edilecektir.
932. Story paylaşımı tamamlandı demek yalnız Share düğmesinin açılması anlamına gelmeyecektir; gerçek 9:16 görsel render, kaynak satırı, uzun ayet, RTL, galeri/uygulamalar arası paylaşım akışı ve rewarded kilit davranışı gerçek cihazda test edilecektir.
933. Offline sistemi tamamlandı demek yalnız internet flag’i kontrolü anlamına gelmeyecektir; Free kullanıcının online başlayıp sonra interneti kapatması dahil hile/açık senaryoları test edilecektir.
934. Pro tamamlandı demek yalnız satın alma ekranının çalışması anlamına gelmeyecektir; satın alma, restore, reinstall, cached entitlement, online revoke/refund kontrolü ve sıfır reklam davranışı test edilecektir.
935. Dil tamamlandı demek yalnız çeviri dosyalarının bulunması anlamına gelmeyecektir; bütün ekran ve hata yollarında TR/EN/AR sızıntı testi yapılacaktır.
936. Dini içerik tamamlandı demek yalnız veri tabanının dolu olması anlamına gelmeyecektir; kaynak, lisans, statü, dil ve kronoloji kontrolleri geçecektir.
937. Peygamberler tamamlandı demek yalnız 25 isim listesinin bulunması anlamına gelmeyecektir; her biyografi, ayet bağlantısı, kaynak statüsü, timeline ve bilinmeyen/tartışmalı bilgi etiketi test edilecektir.
938. İslam Tarihi tamamlandı demek yalnız timeline görünmesi anlamına gelmeyecektir; dönem, bölge, kişi, harita, kaynak ve kronolojik ilişki doğrulanacaktır.
939. Final sürümde her ana modül için en az bir gerçek cihaz happy-path testi ve temel failure-path testleri olacaktır.
940. Son APK/AAB kullanıcıya verilmeden önce dosya gerçekten üretilecek, dosyanın açılabilir/indirilebilir olduğu doğrulanacak ve exact SHA-256 kaydedilecektir.
941. Bir APK linki veya artifact teslim edilecekse link/path doğrulanmadan kullanıcıya gönderilmeyecektir.
942. “Final” kelimesi yalnız şartname + TODO + test matrisinde kırmızı açık kalmadığında kullanılacaktır.

---

# SON ÜRÜN TANIMI

**İslami Hayat**, yalnız bir Kur’an okuyucu veya zikir sayacı olmayacaktır.

Kullanıcı uygulamayı açtığında:

- Bugünün ayetini görür.
- Bugünün duasını okur.
- Kur’an’da yaşadığı konuyu araştırır.
- Zikrini kaynaklarıyla öğrenir ve sayar.
- Esmâ’nın anlamını ve hangi amaçla anıldığını öğrenir.
- Ebced veya geleneksel sayı gördüğünde bunun sünnet mi, gelenek mi olduğunu ayırt edebilir.
- Dini günlerde internetteki yanlış bilgiler yerine kaynaklı bilgi görür.
- Hz. Âdem’den Hz. Muhammed’e kadar Kur’an’da adı geçen peygamberlerin hayatlarını kaynak seviyeleriyle ve mümkün olan en güvenilir kronolojiyle keşfeder.
- İslam’ın ortaya çıktığı dünyadan bugüne kadar ayrıntılı tarihini keşfeder.
- Beğendiği ayeti veya duayı 30 estetik tasarımdan biriyle Story/Post/Status formatında paylaşır.
- Üç dilde doğal bir uygulama kullanır.
- Soruları cihazından çıkmaz.
- Premium ise reklam görmez ve internet olmadan kullanabilir.

Uygulamanın ana üstünlüğü **özellik sayısı değil; doğruluk + kaynak şeffaflığı + mahremiyet + görsel kalite + bütünlük + gerçek davranış testleri** olacaktır.

---

## SONRAKİ PLANLI ADIMLAR

1. **30 paylaşım görselini seçmek ve lisans durumlarını netleştirmek.**
2. Şartnameyi görsel seçimlerinden sonra v1.2 olarak güncellemek.
3. Bu şartnameden hiçbir maddeyi atlamadan kronolojik `TODO.md` üretmek.
4. Daha sonra uygulama geliştirmesine TODO sırasıyla başlamak.
