import '../../../core/content/content_governance.dart';
import 'canonical_prophet_biographies.dart';
import 'prophet_biography_t0194_supplements_21.dart';
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

/// Twentieth T0194 source-reviewed batch.
///
/// Quran 61:14 recalls Jesus son of Mary asking the disciples who would be his
/// helpers toward Allah, records their answer, then states that a faction of
/// the Children of Israel believed while another faction disbelieved and that
/// Allah supported those who believed against their enemy so they prevailed.
/// This later-impact field stays inside that Quranic statement. It does not map
/// the verse onto a named later church, empire, state, denomination, date, or
/// political event, and it does not claim that every member of a community
/// shared one response.
///
/// The twenty-first source-reviewed supplement is composed here as the next
/// chronological layer. It adds only Quran 23:50's unnamed elevated-place
/// description for geography and keeps later location identifications out of
/// the Quran-backed claim.
final t0194ProphetBiographySupplements20 =
    <String, Map<ProphetBiographySectionKey, ProphetBiographyField>>{
  'isa': <ProphetBiographySectionKey, ProphetBiographyField>{
    ...t0194ProphetBiographySupplements21['isa']!,
    ProphetBiographySectionKey.laterImpact: _quranField(
      tr: 'Kur’an, Meryem oğlu Îsâ’nın havârilere Allah yolunda kimlerin kendisine yardımcı olacağını sorduğunu ve onların Allah’ın yardımcıları olduklarını söylediklerini hatırlatır. Ardından İsrailoğullarından bir grubun iman ettiğini, bir grubun inkâr ettiğini ve Allah’ın iman edenleri düşmanlarına karşı desteklediğini bildirir. Bu alan ayeti daha sonraki belirli bir kilise, mezhep, imparatorluk, devlet, tarih veya siyasî olaya eşitlemez ve bütün bir topluluğun tek bir tepki verdiğini iddia etmez.',
      en: 'The Quran recalls Jesus son of Mary asking the disciples who would be his helpers toward Allah and their reply that they were Allah’s helpers. It then states that a faction of the Children of Israel believed, another faction disbelieved, and that Allah supported those who believed against their enemy. This field does not identify the verse with any specific later church, denomination, empire, state, date, or political event, and it does not claim that an entire community had one uniform response.',
      ar: 'يذكّر القرآن بقول عيسى ابن مريم للحواريين: من أنصاري إلى الله، وبجوابهم أنهم أنصار الله. ثم يذكر أن طائفة من بني إسرائيل آمنت وطائفة كفرت، وأن الله أيّد الذين آمنوا على عدوهم. ولا يربط هذا الحقل الآية بكنيسة أو طائفة مذهبية أو إمبراطورية أو دولة أو تاريخ أو حدث سياسي معين في عصور لاحقة، ولا يدّعي أن جماعة كاملة كان لها موقف واحد.',
      stableId: 'isa-q61-14-later-impact',
      locator: 'Quran 61:14',
    ),
  },
};

final t0194ProphetSupplementReferences20 = <String, List<ProphetVerseReference>>{
  'isa': <ProphetVerseReference>[
    const ProphetVerseReference(surah: 61, ayah: 14),
    ...t0194ProphetSupplementReferences21['isa']!,
  ],
};
