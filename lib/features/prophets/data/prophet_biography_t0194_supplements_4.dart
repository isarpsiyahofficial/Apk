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

/// Fourth T0194 source-reviewed batch.
///
/// The Quran gives only brief notices about Dhul-Kifl, so this dataset does not
/// manufacture a mission narrative, geography, chronology, birth/death report,
/// or later identification for him. Zechariah and John likewise remain limited
/// to claims directly supported by the pinned Quran source. Extra-Quranic
/// chronology and historical reconstruction stay pending research.
final t0194ProphetBiographySupplements4 =
    <String, Map<ProphetBiographySectionKey, ProphetBiographyField>>{
  'dhul_kifl': <ProphetBiographySectionKey, ProphetBiographyField>{
    ProphetBiographySectionKey.keyEvents: _quranField(
      tr: 'Kur’an, Zülkifl’i İsmâil ve İdris ile birlikte anar ve üçünün de sabredenlerden olduğunu bildirir.',
      en: 'The Quran names Dhul-Kifl together with Ishmael and Idris and states that all three were among the steadfast.',
      ar: 'يذكر القرآن ذا الكفل مع إسماعيل وإدريس، ويبين أن الثلاثة كانوا من الصابرين.',
      stableId: 'dhul-kifl-q21-85',
      locator: 'Quran 21:85',
    ),
    ProphetBiographySectionKey.laterImpact: _quranField(
      tr: 'Kur’an, Zülkifl’i rahmete kabul edilen salih kimseler arasında ve başka bir yerde de hayırlı kimseler arasında anar; bunun ötesinde ayrıntılı bir hayat anlatısı vermez.',
      en: 'The Quran counts Dhul-Kifl among the righteous admitted to divine mercy and elsewhere among the excellent, without supplying a detailed life narrative.',
      ar: 'يعد القرآن ذا الكفل من الصالحين الذين أدخلهم الله في رحمته، ويذكره في موضع آخر مع الأخيار، من غير سيرة تفصيلية.',
      stableId: 'dhul-kifl-q21-86-q38-48',
      locator: 'Quran 21:86; 38:48',
    ),
  },
  'zakariya': <ProphetBiographySectionKey, ProphetBiographyField>{
    ProphetBiographySectionKey.dua: _quranField(
      tr: 'Kur’an, Zekeriyyâ’nın Rabbinden temiz bir nesil istediğini ve ayrıca kendisini yalnız bırakmaması için dua ettiğini; Allah’ın duasını kabul ederek ona Yahyâ’yı verdiğini bildirir.',
      en: 'The Quran records Zechariah asking his Lord for good offspring and also praying not to be left without an heir; it states that Allah answered him and granted him John.',
      ar: 'يسجل القرآن دعاء زكريا ربه أن يهب له ذرية طيبة وألا يذره فردًا، ويذكر أن الله استجاب له ووهب له يحيى.',
      stableId: 'zakariya-q3-38-q21-89-90',
      locator: 'Quran 3:38; 21:89-90',
    ),
    ProphetBiographySectionKey.keyEvents: _quranField(
      tr: 'Kur’an, Zekeriyyâ’ya yaşlılığı ve eşinin çocuk sahibi olamaması bağlamında Yahyâ’nın müjdelendiğini; istediği işaretin de belirli bir süre insanlarla yalnız işaret yoluyla konuşması olduğunu anlatır.',
      en: 'The Quran recounts Zechariah receiving the good news of John despite his old age and his wife’s inability to bear children, and being given as a sign a period in which he would communicate with people only by gesture.',
      ar: 'يروي القرآن بشارة زكريا بيحيى مع بلوغه الكبر وعقر امرأته، وأن العلامة التي أُعطيت له كانت مدة لا يكلم فيها الناس إلا بالإشارة.',
      stableId: 'zakariya-q3-39-41',
      locator: 'Quran 3:39-41',
    ),
    ProphetBiographySectionKey.mainMessage: _quranField(
      tr: 'Kur’an, Zekeriyyâ’nın ibadet yerinden kavminin karşısına çıkarak onlara sabah akşam Allah’ı tesbih etmelerini işaret ettiğini bildirir.',
      en: 'The Quran states that Zechariah came out from the sanctuary to his people and signaled to them to glorify Allah morning and evening.',
      ar: 'يذكر القرآن أن زكريا خرج من المحراب على قومه فأوحى إليهم أن يسبحوا الله بكرة وعشيًا.',
      stableId: 'zakariya-q19-11',
      locator: 'Quran 19:11',
    ),
  },
  'yahya': <ProphetBiographySectionKey, ProphetBiographyField>{
    ProphetBiographySectionKey.birth: _quranField(
      tr: 'Kur’an, Zekeriyyâ’ya Yahyâ adlı bir oğul müjdelendiğini bildirir; onun için kesin bir takvim tarihi vermez.',
      en: 'The Quran records Zechariah being given the good news of a son named John, without providing a calendar date for his birth.',
      ar: 'يذكر القرآن بشارة زكريا بغلام اسمه يحيى، من غير تحديد تاريخ زمني لميلاده.',
      stableId: 'yahya-q19-7',
      locator: 'Quran 19:7',
    ),
    ProphetBiographySectionKey.missionStart: _quranField(
      tr: 'Kur’an, Yahyâ’yı salihlerden bir peygamber olarak açıkça niteler.',
      en: 'The Quran explicitly describes John as a prophet among the righteous.',
      ar: 'يصف القرآن يحيى صراحة بأنه نبي من الصالحين.',
      stableId: 'yahya-q3-39',
      locator: 'Quran 3:39',
    ),
    ProphetBiographySectionKey.keyEvents: _quranField(
      tr: 'Kur’an, Yahyâ’ya kitaba kuvvetle sarılmasının emredildiğini; kendisine küçük yaşta hikmet, şefkat ve temizlik verildiğini, Allah’a karşı sorumlu ve anne babasına iyi davranan biri olduğunu bildirir.',
      en: 'The Quran records John being commanded to hold firmly to the Scripture and says that he was granted wisdom while young, compassion and purity, and that he was mindful of Allah and dutiful to his parents.',
      ar: 'يذكر القرآن أمر يحيى أن يأخذ الكتاب بقوة، وأنه أوتي الحكم صبيًا والحنان والزكاة، وكان تقيًا وبرًا بوالديه.',
      stableId: 'yahya-q19-12-14',
      locator: 'Quran 19:12-14',
    ),
    ProphetBiographySectionKey.laterImpact: _quranField(
      tr: 'Kur’an, Yahyâ’ya doğduğu gün, öleceği gün ve yeniden diriltileceği gün selâm olduğunu bildirir; vefatının tarihi veya biçimi hakkında burada ayrıntı vermez.',
      en: 'The Quran states that peace is upon John on the day he was born, the day he dies, and the day he is raised alive, without giving a date or manner of death there.',
      ar: 'يذكر القرآن السلام على يحيى يوم ولد ويوم يموت ويوم يبعث حيًا، من غير بيان تاريخ وفاته أو كيفيتها في هذا الموضع.',
      stableId: 'yahya-q19-15',
      locator: 'Quran 19:15',
    ),
  },
};

final t0194ProphetSupplementReferences4 = <String, List<ProphetVerseReference>>{
  'dhul_kifl': const <ProphetVerseReference>[
    ProphetVerseReference(surah: 21, ayah: 85),
    ProphetVerseReference(surah: 21, ayah: 86),
    ProphetVerseReference(surah: 38, ayah: 48),
  ],
  'zakariya': const <ProphetVerseReference>[
    ProphetVerseReference(surah: 3, ayah: 38),
    ProphetVerseReference(surah: 3, ayah: 39),
    ProphetVerseReference(surah: 3, ayah: 41),
    ProphetVerseReference(surah: 19, ayah: 7),
    ProphetVerseReference(surah: 19, ayah: 11),
    ProphetVerseReference(surah: 21, ayah: 89),
    ProphetVerseReference(surah: 21, ayah: 90),
  ],
  'yahya': const <ProphetVerseReference>[
    ProphetVerseReference(surah: 3, ayah: 39),
    ProphetVerseReference(surah: 19, ayah: 7),
    ProphetVerseReference(surah: 19, ayah: 12),
    ProphetVerseReference(surah: 19, ayah: 14),
    ProphetVerseReference(surah: 19, ayah: 15),
  ],
};
