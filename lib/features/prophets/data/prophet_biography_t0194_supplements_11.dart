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

/// Eleventh T0194 source-reviewed batch.
///
/// Quran 3:39 explicitly gives Zechariah the good news of Yahya and describes
/// Yahya as a prophet among the righteous. Quran 19:12-14 directly addresses
/// Yahya, commands him to hold firmly to the Book, states that judgement was
/// granted to him while still a child, and describes compassion, purity,
/// God-consciousness, and dutifulness to his parents. The field below records
/// only those Quranic facts. It does not construct an unsupported mission date,
/// geography, community reaction, or later historical episode.
final t0194ProphetBiographySupplements11 =
    <String, Map<ProphetBiographySectionKey, ProphetBiographyField>>{
  'yahya': <ProphetBiographySectionKey, ProphetBiographyField>{
    ProphetBiographySectionKey.keyEvents: _quranField(
      tr: 'Kur’an, Yahyâ’yı salihlerden bir peygamber olarak anar. Ona “Kitab”a kuvvetle sarılması emredilmiş, çocuk yaşta hüküm/hikmet verilmiş; kendisine katından şefkat ve arınmışlık verildiği, takvâ sahibi ve anne-babasına iyi davranan biri olduğu bildirilmiştir. Ayetler bu bilgilerin ötesinde kesin bir görev başlangıç tarihi veya ayrıntılı hayat kronolojisi vermez.',
      en: 'The Quran describes John as a prophet among the righteous. He is commanded to hold firmly to “the Book”, is granted judgement/wisdom while still a child, and is described as receiving compassion and purity, being God-conscious, and dutiful to his parents. The verses do not provide an exact mission-start date or a detailed life chronology beyond these statements.',
      ar: 'يصف القرآن يحيى بأنه نبي من الصالحين، ويأمره أن يأخذ «الكتاب» بقوة، ويذكر أنه أوتي الحكم صبيًا، وأن الله آتاه حنانًا وزكاة، وكان تقيًا وبارًا بوالديه. ولا تعطي هذه الآيات تاريخًا دقيقًا لبدء رسالته ولا تسلسلًا زمنيًا مفصلًا لحياته يتجاوز هذه الأخبار.',
      stableId: 'yahya-q3-39-q19-12-14-key-events',
      locator: 'Quran 3:39; 19:12-14',
    ),
  },
};

final t0194ProphetSupplementReferences11 = <String, List<ProphetVerseReference>>{
  'yahya': const <ProphetVerseReference>[
    ProphetVerseReference(surah: 3, ayah: 39),
    ProphetVerseReference(surah: 19, ayah: 12),
    ProphetVerseReference(surah: 19, ayah: 13),
    ProphetVerseReference(surah: 19, ayah: 14),
  ],
};
