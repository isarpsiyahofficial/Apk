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

ProphetBiographyField _quranField({
  required String tr,
  required String en,
  required String ar,
  required String stableId,
  required String locator,
}) =>
    ProphetBiographyField(
      text: LocalizedReligiousText(tr: tr, en: en, ar: ar),
      status: ProphetBiographyFieldStatus.sourceBacked,
      sources: <SourceReference>[_quranSource(stableId, locator)],
    );

/// Ninth T0194 source-reviewed batch.
///
/// Quran 19:11 explicitly refers to Zechariah going out from the sanctuary to
/// his people and signalling to them to glorify Allah morning and evening. The
/// verse does not supply a named ethnicity, tribe, city, or later historical
/// community label, so none is inferred here.
///
/// Quran 3:37 explicitly places Mary under Zechariah's care and records him
/// entering her sanctuary. Quran 3:39-41 states that the angels gave him good
/// news of Yahya while he was standing in prayer in the sanctuary and records
/// the three-day sign in which he would address people only by gesture. The
/// key-events field stays at those Quranic facts and does not infer a specific
/// kinship degree between Zechariah and Mary.
///
/// Quran 3:38 records Zechariah asking his Lord for good offspring.
///
/// Quran 19:8-10 additionally preserves the explicit extraordinary-sign
/// boundary: Zechariah names his old age and his wife's barrenness, Allah states
/// that granting the child is easy for Him, and a three-night inability to
/// speak to people while sound is given as a sign. The miracles field therefore
/// records only those Quranic facts; it does not infer a date, place, diagnosis,
/// mechanism, or later historical embellishment.
final t0194ProphetBiographySupplements9 =
    <String, Map<ProphetBiographySectionKey, ProphetBiographyField>>{
  'zakariya': <ProphetBiographySectionKey, ProphetBiographyField>{
    ProphetBiographySectionKey.community: _quranField(
      tr: 'Kur’an, Zekeriyyâ’nın ibadet yerinden kendi kavminin/toplumunun karşısına çıktığını ve onlara sabah akşam Allah’ı tesbih etmelerini işaret ettiğini bildirir; ayet bu topluluğa ayrıca bir etnik, kabilevî veya şehir adı vermez.',
      en: 'The Quran states that Zechariah came out from the sanctuary to his people and signalled to them to glorify Allah morning and evening; the verse does not additionally assign that community an ethnic, tribal, or city label.',
      ar: 'يذكر القرآن أن زكريا خرج من المحراب على قومه فأشار إليهم أن يسبحوا الله بكرة وعشيًا؛ ولا تعطي الآية لهذه الجماعة اسمًا عرقيًا أو قبليًا أو اسم مدينة إضافيًا.',
      stableId: 'zakariya-q19-11-community',
      locator: 'Quran 19:11',
    ),
    ProphetBiographySectionKey.dua: _quranField(
      tr: 'Kur’an, Zekeriyyâ’nın Rabbinden kendi katından temiz ve iyi bir nesil bağışlamasını istediği duayı kaydeder.',
      en: 'The Quran records Zechariah asking his Lord to grant him good offspring from Himself.',
      ar: 'يسجل القرآن دعاء زكريا ربه أن يهبه من لدنه ذرية طيبة.',
      stableId: 'zakariya-q3-38-dua',
      locator: 'Quran 3:38',
    ),
    ProphetBiographySectionKey.keyEvents: _quranField(
      tr: 'Kur’an, Meryem’in bakımının Zekeriyyâ’ya verildiğini ve onun Meryem’in yanına ibadet yerine girdiğini; daha sonra Zekeriyyâ mihrapta namaz kılarken meleklerin ona Yahyâ’yı müjdelediğini ve kendisine insanlarla üç gün yalnız işaretle konuşacağı bir alamet verildiğini bildirir. Ayetler Zekeriyyâ ile Meryem arasında ayrıca kesin bir akrabalık derecesi belirtmez.',
      en: 'The Quran states that Mary was placed in Zechariah’s care and that he entered the sanctuary where she was; later, while Zechariah was standing in prayer in the sanctuary, the angels gave him good news of Yahya, and he was given a sign that for three days he would speak to people only by gesture. The verses do not additionally specify an exact degree of kinship between Zechariah and Mary.',
      ar: 'يذكر القرآن أن مريم جُعلت في كفالة زكريا وأنه كان يدخل عليها المحراب؛ ثم نادته الملائكة وهو قائم يصلي في المحراب فبشرته بيحيى، وجُعلت له آية ألا يكلم الناس ثلاثة أيام إلا رمزًا. ولا تحدد هذه الآيات درجة قرابة بعينها بين زكريا ومريم.',
      stableId: 'zakariya-q3-37-41-key-events',
      locator: 'Quran 3:37; 3:39-41',
    ),
    ProphetBiographySectionKey.miracles: _quranField(
      tr: 'Kur’an, Zekeriyyâ’nın ileri yaşını ve eşinin kısır olduğunu dile getirmesine rağmen Yahyâ’nın kendisine verileceğinin bildirildiğini; ayrıca sağlam olduğu hâlde insanlarla üç gece konuşamamasının kendisine bir işaret kılındığını bildirir. Bunun ötesinde bir mekanizma veya tarihsel ayrıntı eklenmez.',
      en: 'The Quran states that Zechariah was told Yahya would be granted to him despite his old age and his wife being barren, and that being unable to speak to people for three nights while sound was made a sign for him. No mechanism or later historical detail is added beyond this.',
      ar: 'يذكر القرآن أن زكريا بُشّر بيحيى مع بلوغه الكبر وكون امرأته عاقرًا، وأن من آياته ألا يكلم الناس ثلاث ليال وهو سويّ. ولا يضاف إلى ذلك تفسير للكيفية أو تفصيل تاريخي لاحق.',
      stableId: 'zakariya-q19-8-10-sign',
      locator: 'Quran 19:8-10',
    ),
  },
};

final t0194ProphetSupplementReferences9 = <String, List<ProphetVerseReference>>{
  'zakariya': const <ProphetVerseReference>[
    ProphetVerseReference(surah: 3, ayah: 37),
    ProphetVerseReference(surah: 3, ayah: 38),
    ProphetVerseReference(surah: 3, ayah: 39),
    ProphetVerseReference(surah: 3, ayah: 40),
    ProphetVerseReference(surah: 3, ayah: 41),
    ProphetVerseReference(surah: 19, ayah: 8),
    ProphetVerseReference(surah: 19, ayah: 9),
    ProphetVerseReference(surah: 19, ayah: 10),
    ProphetVerseReference(surah: 19, ayah: 11),
  ],
};
