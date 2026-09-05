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

/// Eighth T0194 source-reviewed batch.
///
/// Quran 19:7 records the glad tidings to Zakariyya of a boy named Yahya;
/// Quran 19:12 directly addresses Yahya, commands him to take the Book with
/// strength, and states that he was granted judgement/wisdom while still a
/// child; Quran 19:15 invokes peace upon him on the day he was born, the day he
/// dies, and the day he is raised alive. These fields intentionally preserve the
/// Quran's own wording: they do not invent a birth date/place, promote a later
/// identification of `al-kitab`, construct a wider childhood chronology, or
/// supply a death date/place/cause or later death narrative that the verses do
/// not state.
final t0194ProphetBiographySupplements8 =
    <String, Map<ProphetBiographySectionKey, ProphetBiographyField>>{
  'yahya': <ProphetBiographySectionKey, ProphetBiographyField>{
    ProphetBiographySectionKey.birth: _quranField(
      tr: 'Kur’an, Zekeriyyâ’ya Yahyâ adında bir oğul müjdelendiğini bildirir; ayet doğum tarihi, yeri veya doğum anına ilişkin ek ayrıntı vermez.',
      en: 'The Quran records that Zechariah was given good news of a boy named John; the verse gives no date, place, or further details of the birth itself.',
      ar: 'يذكر القرآن بشارة زكريا بغلام اسمه يحيى؛ ولا تذكر الآية تاريخ الميلاد ولا مكانه ولا تفاصيل أخرى عن واقعة الولادة نفسها.',
      stableId: 'yahya-q19-7-birth',
      locator: 'Quran 19:7',
    ),
    ProphetBiographySectionKey.childhoodYouth: _quranField(
      tr: 'Kur’an, Yahyâ’ya çocuk yaşta hüküm ve hikmet verildiğini açıkça bildirir; bu alan ayetin ötesine geçerek çocukluk yıllarına ilişkin ayrıntılı bir kronoloji kurmaz.',
      en: 'The Quran explicitly states that John was granted judgement and wisdom while still a child; this field does not go beyond the verse by constructing a detailed childhood chronology.',
      ar: 'يصرح القرآن بأن يحيى أوتي الحكم وهو صبي؛ ولا يتجاوز هذا الحقل نص الآية بإنشاء تسلسل زمني مفصل لطفولته.',
      stableId: 'yahya-q19-12-childhood',
      locator: 'Quran 19:12',
    ),
    ProphetBiographySectionKey.scriptureScrolls: _quranField(
      tr: 'Kur’an, Yahyâ’ya “Kitab”a kuvvetle sarılmasını emreder ve ona çocuk yaşta hikmet verildiğini bildirir; bu alan ayetin kendi ifadesini aşarak Kitabın adını kesinleştirmez.',
      en: 'The Quran commands John to hold firmly to “the Book” and states that he was granted wisdom while still young; this field does not go beyond the verse by assigning a definite title to that Book.',
      ar: 'يأمر القرآن يحيى أن يأخذ «الكتاب» بقوة، ويذكر أنه أوتي الحكم صبيًا؛ ولا يتجاوز هذا الحقل لفظ الآية بتعيين اسم قطعي لذلك الكتاب.',
      stableId: 'yahya-q19-12-scripture',
      locator: 'Quran 19:12',
    ),
    ProphetBiographySectionKey.death: _quranField(
      tr: 'Kur’an, Yahyâ’ya doğduğu gün, öleceği gün ve yeniden diri olarak kaldırılacağı gün selâm olduğunu bildirir; ayet ölüm tarihi, yeri, sebebi veya ölüm biçimi hakkında ayrıntı vermez.',
      en: 'The Quran states that peace is upon John on the day he was born, the day he dies, and the day he is raised alive; the verse gives no date, place, cause, or manner of his death.',
      ar: 'يذكر القرآن أن السلام على يحيى يوم وُلد ويوم يموت ويوم يُبعث حيًا؛ ولا تذكر الآية تاريخ موته ولا مكانه ولا سببه ولا كيفيته.',
      stableId: 'yahya-q19-15-death',
      locator: 'Quran 19:15',
    ),
  },
};

final t0194ProphetSupplementReferences8 = <String, List<ProphetVerseReference>>{
  'yahya': const <ProphetVerseReference>[
    ProphetVerseReference(surah: 19, ayah: 7),
    ProphetVerseReference(surah: 19, ayah: 12),
    ProphetVerseReference(surah: 19, ayah: 15),
  ],
};
