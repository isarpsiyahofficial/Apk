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

/// Tenth T0194 source-reviewed batch.
///
/// Quran 3:37-41 places Zechariah in Mary's care narrative and records the
/// announcement of Yahya while Zechariah is praying. Quran 19:7 likewise gives
/// Zechariah the good news of a son named Yahya. Together these verses provide
/// a safe relative-period boundary: Zechariah is presented in the same Quranic
/// narrative period as Mary and before Yahya's birth. They do not provide a
/// Gregorian/Hijri year, century, reign, or other exact calendar date, so none
/// is inferred here.
final t0194ProphetBiographySupplements10 =
    <String, Map<ProphetBiographySectionKey, ProphetBiographyField>>{
  'zakariya': <ProphetBiographySectionKey, ProphetBiographyField>{
    ProphetBiographySectionKey.period: _quranField(
      tr: 'Kur’an, Zekeriyyâ’yı Meryem’in bakımını üstlendiği ve Yahyâ’nın doğumundan önce onun müjdesini aldığı aynı anlatı dönemi içinde gösterir. Ayetler miladî, hicrî veya başka bir kesin takvim tarihi vermez.',
      en: 'The Quran presents Zechariah in the same narrative period in which he was entrusted with Mary’s care and, before Yahya’s birth, received the good news of him. The verses provide no Gregorian, Hijri, or other exact calendar date.',
      ar: 'يعرض القرآن زكريا في الفترة السردية نفسها التي كفل فيها مريم، وقبل ولادة يحيى حين بُشّر به. ولا تعطي هذه الآيات سنة ميلادية أو هجرية ولا تاريخًا تقويميًا دقيقًا آخر.',
      stableId: 'zakariya-q3-37-41-q19-7-period',
      locator: 'Quran 3:37-41; 19:7',
    ),
  },
};

final t0194ProphetSupplementReferences10 = <String, List<ProphetVerseReference>>{
  'zakariya': const <ProphetVerseReference>[
    ProphetVerseReference(surah: 3, ayah: 37),
    ProphetVerseReference(surah: 3, ayah: 38),
    ProphetVerseReference(surah: 3, ayah: 39),
    ProphetVerseReference(surah: 3, ayah: 40),
    ProphetVerseReference(surah: 3, ayah: 41),
    ProphetVerseReference(surah: 19, ayah: 7),
  ],
};
