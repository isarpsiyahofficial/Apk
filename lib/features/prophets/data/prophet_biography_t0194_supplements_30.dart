import '../../../core/content/content_governance.dart';
import 'canonical_prophet_biographies.dart';
import 'prophet_content.dart';

SourceReference _quranSource(String stableId, String locator) => SourceReference(
      id: 'tanzil-uthmani-v1.1-$stableId',
      title: 'Tanzil Project — Uthmani Quran Text v1.1',
      sourceClass: ReligiousSourceClass.quran,
      licenseId: 'CC-BY-3.0',
      locator: locator,
    );

ProphetBiographyField _quranGeographyField({
  required LocalizedReligiousText text,
  required String stableId,
  required String locator,
}) =>
    ProphetBiographyField(
      text: text,
      status: ProphetBiographyFieldStatus.sourceBacked,
      sources: <SourceReference>[_quranSource(stableId, locator)],
    );

/// Thirtieth T0194 source-reviewed batch.
///
/// Adds only spatial contexts stated directly by the Quran. These records do
/// not infer modern borders, coordinates, routes, archaeological identities,
/// or exact historical dates from the cited verses.
final t0194ProphetBiographySupplements30 =
    <String, Map<ProphetBiographySectionKey, ProphetBiographyField>>{
  'yakub': <ProphetBiographySectionKey, ProphetBiographyField>{
    ProphetBiographySectionKey.geography: _quranGeographyField(
      text: const LocalizedReligiousText(
        tr: 'Kur’an, Yûsuf’un anne ve babasını yanına aldığını ve ailesine güven içinde Mısır’a girmelerini söylediğini bildirir. Bu alan Ya‘kûb için yalnız bu açık Mısır bağlamını kaydeder; yol, şehir, sınır veya kesin tarih eklemez.',
        en: 'The Quran states that Joseph received his parents and told his family to enter Egypt in safety. For Jacob, this field records only that explicit Egypt context and adds no route, city, boundary, or exact date.',
        ar: 'يذكر القرآن أن يوسف آوى إليه أبويه وقال لأهله ادخلوا مصر إن شاء الله آمنين. ويسجل هذا الحقل ليعقوب سياق مصر الصريح فقط، من غير إضافة طريق أو مدينة أو حدود أو تاريخ دقيق.',
      ),
      stableId: 'yakub-q12-99-egypt-geography',
      locator: 'Quran 12:99',
    ),
  },
  'yunus': <ProphetBiographySectionKey, ProphetBiographyField>{
    ProphetBiographySectionKey.geography: _quranGeographyField(
      text: const LocalizedReligiousText(
        tr: 'Kur’an, Yûnus’un hasta halde açık bir sahile bırakıldığını bildirir. Bu alan yalnız ayetin verdiği sahil bağlamını kaydeder; sahilin modern konumunu veya kesin tarihini belirlemez.',
        en: 'The Quran states that Jonah was cast onto an open shore while ill. This field records only the shore context stated by the verse and does not identify a modern location or exact date.',
        ar: 'يذكر القرآن أن يونس نُبذ بالعراء وهو سقيم. ويقتصر هذا الحقل على سياق المكان المكشوف الوارد في الآية، من غير تعيين موقع حديث أو تاريخ دقيق.',
      ),
      stableId: 'yunus-q37-145-open-shore-geography',
      locator: 'Quran 37:145',
    ),
  },
  'ayyub': <ProphetBiographySectionKey, ProphetBiographyField>{
    ProphetBiographySectionKey.geography: _quranGeographyField(
      text: const LocalizedReligiousText(
        tr: 'Kur’an, Eyyûb’a ayağını yere vurmasının emredildiğini ve orada yıkanılacak ve içilecek serin bir su bulunduğunu bildirir. Bu alan yalnız bu yerel su/kaynak bağlamını kaydeder; modern konum veya kesin tarih çıkarmaz.',
        en: 'The Quran commands Job to strike the ground with his foot and describes a cool water there for washing and drinking. This field records only that local water/spring context and derives no modern location or exact date.',
        ar: 'يأمر القرآن أيوب أن يركض برجله ويذكر ماءً باردًا للاغتسال والشرب. ويقتصر هذا الحقل على سياق الماء المحلي المذكور، من غير استنتاج موقع حديث أو تاريخ دقيق.',
      ),
      stableId: 'ayyub-q38-42-water-geography',
      locator: 'Quran 38:42',
    ),
  },
  'sulayman': <ProphetBiographySectionKey, ProphetBiographyField>{
    ProphetBiographySectionKey.geography: _quranGeographyField(
      text: const LocalizedReligiousText(
        tr: 'Kur’an, Süleyman ve ordularının Karınca Vadisi’ne geldiklerini bildirir. Bu alan yalnız ayetteki vadi bağlamını kaydeder; modern koordinat, sınır, güzergâh veya kesin tarih eklemez.',
        en: 'The Quran states that Solomon and his forces came to the Valley of the Ants. This field records only the valley context in the verse and adds no modern coordinate, boundary, route, or exact date.',
        ar: 'يذكر القرآن أن سليمان وجنوده أتوا على وادي النمل. ويقتصر هذا الحقل على سياق الوادي الوارد في الآية، من غير إضافة إحداثيات حديثة أو حدود أو مسار أو تاريخ دقيق.',
      ),
      stableId: 'sulayman-q27-18-valley-of-ants-geography',
      locator: 'Quran 27:18',
    ),
  },
  'zakariya': <ProphetBiographySectionKey, ProphetBiographyField>{
    ProphetBiographySectionKey.geography: _quranGeographyField(
      text: const LocalizedReligiousText(
        tr: 'Kur’an, Zekeriyyâ’nın Rabbine dua ettiğini ve mihrapta namaz kılarken meleklerin ona Yahyâ’yı müjdelediğini bildirir. Bu alan yalnız mihrap/ibadet yeri bağlamını kaydeder; şehir veya modern konum çıkarımı yapmaz.',
        en: 'The Quran relates Zechariah’s prayer and says that the angels called to him while he stood praying in the sanctuary, giving him news of John. This field records only that sanctuary context and infers no city or modern location.',
        ar: 'يذكر القرآن دعاء زكريا وأن الملائكة نادته وهو قائم يصلي في المحراب وبشرته بيحيى. ويقتصر هذا الحقل على سياق المحراب، من غير استنتاج مدينة أو موقع حديث.',
      ),
      stableId: 'zakariya-q3-38-39-sanctuary-geography',
      locator: 'Quran 3:38-39',
    ),
  },
  'dawud': <ProphetBiographySectionKey, ProphetBiographyField>{
    ProphetBiographySectionKey.geography: _quranGeographyField(
      text: const LocalizedReligiousText(
        tr: 'Kur’an, Dâvûd’a lütuf verildiğini ve dağlara onunla birlikte tesbih etmelerinin emredildiğini bildirir. Bu alan yalnız ayetin açık dağ çevresi bağlamını kaydeder; belirli bir dağ, ülke, koordinat veya kesin tarih belirlemez.',
        en: 'The Quran states that David was granted favor and commands the mountains to echo praise with him. This field records only that explicit mountain-setting context and identifies no specific mountain, country, coordinate, or exact date.',
        ar: 'يذكر القرآن ما أوتي داود من فضل ويأمر الجبال أن تسبح معه. ويقتصر هذا الحقل على سياق الجبال الصريح في الآية، من غير تعيين جبل بعينه أو بلد أو إحداثيات أو تاريخ دقيق.',
      ),
      stableId: 'dawud-q34-10-mountains-geography',
      locator: 'Quran 34:10',
    ),
  },
};

final t0194ProphetSupplementReferences30 = <String, List<ProphetVerseReference>>{
  'yakub': const <ProphetVerseReference>[
    ProphetVerseReference(surah: 12, ayah: 99),
  ],
  'yunus': const <ProphetVerseReference>[
    ProphetVerseReference(surah: 37, ayah: 145),
  ],
  'ayyub': const <ProphetVerseReference>[
    ProphetVerseReference(surah: 38, ayah: 42),
  ],
  'sulayman': const <ProphetVerseReference>[
    ProphetVerseReference(surah: 27, ayah: 18),
  ],
  'zakariya': const <ProphetVerseReference>[
    ProphetVerseReference(surah: 3, ayah: 38),
    ProphetVerseReference(surah: 3, ayah: 39),
  ],
  'dawud': const <ProphetVerseReference>[
    ProphetVerseReference(surah: 34, ayah: 10),
  ],
};