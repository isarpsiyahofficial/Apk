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

/// Twelfth T0194 source-reviewed batch.
///
/// Quran 19:7 presents Yahya as the son announced to Zechariah, while Quran
/// 3:39 describes Yahya as a prophet among the righteous. These verses support
/// only a relative narrative period tied to Zechariah; they do not supply a
/// calendar year, century, ruler, or independent historical chronology.
final t0194ProphetBiographySupplements12 =
    <String, Map<ProphetBiographySectionKey, ProphetBiographyField>>{
  'yahya': <ProphetBiographySectionKey, ProphetBiographyField>{
    ProphetBiographySectionKey.period: _quranField(
      tr: 'Kur’an, Yahyâ’yı Zekeriyyâ’ya verilen oğul müjdesi bağlamında anar ve onu salihlerden bir peygamber olarak niteler. Bu anlatı Yahyâ’nın dönemini Zekeriyyâ’nın hayatıyla ilişkili olarak konumlandırır; ancak takvim yılı, yüzyıl veya hükümdar adı vermez.',
      en: 'The Quran presents John in the context of the son announced to Zechariah and describes him as a prophet among the righteous. This places his Quranic period in relation to Zechariah’s lifetime, but gives no calendar year, century, or ruler.',
      ar: 'يعرض القرآن يحيى في سياق البشارة به ولدًا لزكريا، ويصفه بأنه نبي من الصالحين. وهذا يضع زمنه القرآني في صلة بحياة زكريا، من غير تحديد سنة تقويمية أو قرن أو اسم حاكم.',
      stableId: 'yahya-q3-39-q19-7-period',
      locator: 'Quran 3:39; 19:7',
    ),
  },
};

final t0194ProphetSupplementReferences12 = <String, List<ProphetVerseReference>>{
  'yahya': const <ProphetVerseReference>[
    ProphetVerseReference(surah: 3, ayah: 39),
    ProphetVerseReference(surah: 19, ayah: 7),
  ],
};
