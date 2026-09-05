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
/// Quran 3:38 records Zechariah asking his Lord for good offspring. Quran
/// 3:39-41 states that the angels gave him good news of Yahya while he was
/// standing in prayer in the sanctuary and records the three-day sign in which
/// he would address people only by gesture. These fields intentionally stop at
/// the Quranic wording: no date, location beyond the sanctuary, or later
/// historical detail is inferred.
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
      tr: 'Kur’an, Zekeriyyâ mihrapta namaz kılarken meleklerin ona Yahyâ’yı müjdelediğini; ardından kendisine, insanlarla üç gün yalnız işaretle konuşacağı bir alamet verildiğini bildirir.',
      en: 'The Quran states that while Zechariah was standing in prayer in the sanctuary, the angels gave him good news of Yahya; he was then given a sign that for three days he would speak to people only by gesture.',
      ar: 'يذكر القرآن أن الملائكة نادت زكريا وهو قائم يصلي في المحراب فبشرته بيحيى؛ ثم جُعلت له آية ألا يكلم الناس ثلاثة أيام إلا رمزًا.',
      stableId: 'zakariya-q3-39-41-key-events',
      locator: 'Quran 3:39-41',
    ),
  },
};

final t0194ProphetSupplementReferences9 = <String, List<ProphetVerseReference>>{
  'zakariya': const <ProphetVerseReference>[
    ProphetVerseReference(surah: 3, ayah: 38),
    ProphetVerseReference(surah: 3, ayah: 39),
    ProphetVerseReference(surah: 3, ayah: 40),
    ProphetVerseReference(surah: 3, ayah: 41),
    ProphetVerseReference(surah: 19, ayah: 11),
  ],
};
