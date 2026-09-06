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

/// Seventeenth T0194 source-reviewed batch.
///
/// Quran 4:157 rejects the claim that Jesus son of Mary was killed or
/// crucified and explicitly says that those disputing the matter have no
/// certain knowledge beyond conjecture. Quran 4:158 states instead that Allah
/// raised him to Himself. This field records only those Quranic boundaries. It
/// does not invent an exact death date, identify another person as the one
/// crucified, explain the mechanism of the event, or add later-return details
/// that are not stated in these verses.
final t0194ProphetBiographySupplements17 =
    <String, Map<ProphetBiographySectionKey, ProphetBiographyField>>{
  'isa': <ProphetBiographySectionKey, ProphetBiographyField>{
    ProphetBiographySectionKey.death: _quranField(
      tr: 'Kur’an, Meryem oğlu Îsâ hakkında onu öldürdükleri ve çarmıha gerdikleri iddiasını reddeder; bu konuda ihtilaf edenlerin kesin bilgiye değil zanna dayandığını bildirir. Ardından Allah’ın onu kendisine yükselttiğini söyler. Bu alan kesin bir vefat tarihi vermez, çarmıha gerilen başka bir kişiyi isimlendirmez, olayın mekanizmasını açıklamaz ve bu ayetlerde bulunmayan sonraki dönüş ayrıntıları eklemez.',
      en: 'The Quran rejects the claim that Jesus son of Mary was killed or crucified and states that those disputing the matter have no certain knowledge beyond conjecture. It then says that Allah raised him to Himself. This field gives no exact death date, does not identify another person as having been crucified, does not explain the mechanism of the event, and adds no later-return details absent from these verses.',
      ar: 'يرفض القرآن دعوى قتل عيسى ابن مريم أو صلبه، ويذكر أن المختلفين في الأمر ليس عندهم علم يقيني وإنما يتبعون الظن، ثم يقرر أن الله رفعه إليه. ولا يحدد هذا الحقل تاريخ وفاة دقيقًا، ولا يسمي شخصًا آخر على أنه المصلوب، ولا يشرح كيفية الواقعة، ولا يضيف تفاصيل عن عودة لاحقة لم تذكرها هاتان الآيتان.',
      stableId: 'isa-q4-157-158-death',
      locator: 'Quran 4:157-158',
    ),
  },
};

final t0194ProphetSupplementReferences17 = <String, List<ProphetVerseReference>>{
  'isa': const <ProphetVerseReference>[
    ProphetVerseReference(surah: 4, ayah: 157),
    ProphetVerseReference(surah: 4, ayah: 158),
  ],
};
