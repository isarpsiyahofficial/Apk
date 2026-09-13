import '../../../core/content/content_governance.dart';
import 'canonical_prophet_biographies.dart';
import 'prophet_biography_t0194_supplements_19.dart';
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

/// Eighteenth T0194 source-reviewed batch.
///
/// Quran 5:46 states that Jesus son of Mary followed the earlier prophets,
/// confirmed the Torah before him, and was given the Gospel containing
/// guidance and light. This field records only that Quranic scripture claim.
/// It does not claim that a specific surviving manuscript is identical to the
/// revealed Gospel, invent a delivery date or place, or add a textual history
/// not stated by the verse.
///
/// The nineteenth source-reviewed supplement is composed here as the next
/// chronological layer, adding only the Quran 5:112-115 table event.
final t0194ProphetBiographySupplements18 =
    <String, Map<ProphetBiographySectionKey, ProphetBiographyField>>{
  'isa': <ProphetBiographySectionKey, ProphetBiographyField>{
    ...t0194ProphetBiographySupplements19['isa']!,
    ProphetBiographySectionKey.scriptureScrolls: _quranField(
      tr: 'Kur’an, Meryem oğlu Îsâ’nın kendisinden önceki Tevrat’ı doğruladığını ve ona içinde hidayet ve nur bulunan İncil’in verildiğini bildirir. Bu alan günümüze ulaşmış belirli bir nüshanın vahyedilen İncil ile birebir aynı olduğunu iddia etmez; veriliş tarihi veya yeri uydurmaz ve ayetin söylemediği bir metin tarihi eklemez.',
      en: 'The Quran states that Jesus son of Mary confirmed the Torah before him and was given the Gospel containing guidance and light. This field does not claim that any specific surviving manuscript is identical to the revealed Gospel, does not invent a date or place of delivery, and adds no textual history not stated by the verse.',
      ar: 'يذكر القرآن أن عيسى ابن مريم كان مصدقًا لما بين يديه من التوراة، وأن الله آتاه الإنجيل فيه هدى ونور. ولا يدعي هذا الحقل أن مخطوطًا معينًا باقيا اليوم مطابق حرفيا للإنجيل المنزل، ولا يختلق تاريخًا أو مكانًا لإيتائه، ولا يضيف تاريخًا نصيًا لم تذكره الآية.',
      stableId: 'isa-q5-46-scripture',
      locator: 'Quran 5:46',
    ),
  },
};

final t0194ProphetSupplementReferences18 = <String, List<ProphetVerseReference>>{
  'isa': <ProphetVerseReference>[
    const ProphetVerseReference(surah: 5, ayah: 46),
    ...t0194ProphetSupplementReferences19['isa']!,
  ],
};
