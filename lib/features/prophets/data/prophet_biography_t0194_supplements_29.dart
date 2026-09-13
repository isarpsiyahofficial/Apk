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

/// Twenty-ninth T0194 source-reviewed batch.
///
/// Adds two deliberately conservative Quranic geography associations. Salih is
/// tied only to the settlement landscape explicitly described for Thamud in
/// 7:73-74 and 89:9; the record does not promote later exact site or migration
/// traditions into Quran-backed facts. Lut is tied only to the unnamed town
/// from which the Quran says he was delivered (21:74) and to the surviving
/// road-side trace described in 15:76; the field does not make a Quran-backed
/// claim that the town's proper name, modern coordinates, or borders are given
/// by those verses.
final t0194ProphetBiographySupplements29 =
    <String, Map<ProphetBiographySectionKey, ProphetBiographyField>>{
  'salih': <ProphetBiographySectionKey, ProphetBiographyField>{
    ProphetBiographySectionKey.geography: _quranGeographyField(
      text: const LocalizedReligiousText(
        tr: 'Kur’an, Sâlih’i Semûd’a gönderilmiş peygamber olarak anarken kavminin düzlüklerde yapılar kurup dağları oyarak evler yaptığını; başka bir ayette de Semûd’un vadide kayaları oyduğunu bildirir. Bu alan yalnız bu yerleşim ve vadi bağlamını kaydeder; modern konum, sınır, göç rotası veya kesin tarih eklemez.',
        en: 'The Quran identifies Salih as the prophet sent to Thamud and describes his people as building on the plains and carving homes into mountains; another verse describes Thamud as carving rocks in the valley. This field records only that settlement-and-valley context and adds no modern location, boundary, migration route, or exact date.',
        ar: 'يذكر القرآن صالحًا نبيًّا إلى ثمود، ويصف قومه بأنهم يتخذون من سهول الأرض قصورًا وينحتون الجبال بيوتًا، كما يذكر ثمود الذين جابوا الصخر بالواد. ويقتصر هذا الحقل على سياق الاستيطان والوادي هذا، من غير إضافة موقع حديث أو حدود أو مسار هجرة أو تاريخ دقيق.',
      ),
      stableId: 'salih-q7-73-74-q89-9-thamud-settlement-geography',
      locator: 'Quran 7:73-74; 89:9',
    ),
  },
  'lut': <ProphetBiographySectionKey, ProphetBiographyField>{
    ProphetBiographySectionKey.geography: _quranGeographyField(
      text: const LocalizedReligiousText(
        tr: 'Kur’an, Lût’un kötülük işleyen bir kasabadan kurtarıldığını bildirir; Lût kavmine ait ibret izlerinin de işlek bir yol üzerinde bulunduğunu söyler. Bu alan yalnız Kur’an’ın verdiği kasaba ve yol bağlamını kaydeder; kasabanın özel adını, modern koordinatını veya kesin sınırını ayetlerden türetmez.',
        en: 'The Quran states that Lot was delivered from a town whose people practiced grave wrongdoing and says that the trace of Lot’s people remained by an established road. This field records only the Quranic town-and-road context and does not derive the town’s proper name, modern coordinates, or exact boundaries from those verses.',
        ar: 'يذكر القرآن أن لوطًا نُجّي من القرية التي كان أهلها يعملون الخبائث، ويذكر أن آثار قومه كانت على طريق قائم. ويقتصر هذا الحقل على سياق القرية والطريق الوارد في القرآن، من غير استنتاج اسم المدينة الخاص أو إحداثياتها الحديثة أو حدودها الدقيقة من الآيات.',
      ),
      stableId: 'lut-q21-74-q15-76-town-road-geography',
      locator: 'Quran 21:74; 15:76',
    ),
  },
};

final t0194ProphetSupplementReferences29 = <String, List<ProphetVerseReference>>{
  'salih': const <ProphetVerseReference>[
    ProphetVerseReference(surah: 7, ayah: 73),
    ProphetVerseReference(surah: 7, ayah: 74),
    ProphetVerseReference(surah: 89, ayah: 9),
  ],
  'lut': const <ProphetVerseReference>[
    ProphetVerseReference(surah: 21, ayah: 74),
    ProphetVerseReference(surah: 15, ayah: 76),
  ],
};
