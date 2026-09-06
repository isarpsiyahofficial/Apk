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

/// Sixteenth T0194 source-reviewed batch.
///
/// Quran 5:114 explicitly records Jesus son of Mary praying to Allah, asking
/// for a table from heaven to be a festival for the first and last of them, a
/// sign from Allah, and for provision while affirming Allah as the best of
/// providers. This field records only that Quranic supplication context. It
/// does not convert the verse into a general promise of material provision,
/// prescribe a repetition count, or add a date, place, or later tradition.
final t0194ProphetBiographySupplements16 =
    <String, Map<ProphetBiographySectionKey, ProphetBiographyField>>{
  'isa': <ProphetBiographySectionKey, ProphetBiographyField>{
    ProphetBiographySectionKey.dua: _quranField(
      tr: 'Kur’an, Meryem oğlu Îsâ’nın Allah’a dua ederek gökten kendilerine bir sofra indirmesini; bunun öncekileri ve sonrakileri için bir bayram ve Allah’tan bir işaret olmasını; ayrıca kendilerine rızık verilmesini istediğini bildirir. Îsâ duasını Allah’ın rızık verenlerin en hayırlısı olduğunu ifade ederek tamamlar. Bu alan ayeti genel bir maddi kazanç garantisine dönüştürmez, tekrar sayısı önermez ve ayetin vermediği tarih, yer ya da sonraki gelenek ayrıntısı eklemez.',
      en: 'The Quran records Jesus son of Mary praying to Allah for a table to be sent down from heaven, asking that it be a festival for the first and last of them and a sign from Allah, and asking for provision. Jesus closes the supplication by affirming that Allah is the best of providers. This field does not turn the verse into a general guarantee of material gain, prescribe a repetition count, or add a date, place, or later tradition not stated by the verse.',
      ar: 'يذكر القرآن أن عيسى ابن مريم دعا الله أن ينزل عليهم مائدة من السماء تكون عيدًا لأولهم وآخرهم وآية من الله، وسأله الرزق، وختم دعاءه بالإقرار بأن الله خير الرازقين. ولا يحول هذا الحقل الآية إلى ضمان عام للكسب المادي، ولا يحدد عددًا للتكرار، ولا يضيف تاريخًا أو مكانًا أو تفصيلًا من تقاليد لاحقة لم تذكره الآية.',
      stableId: 'isa-q5-114-dua',
      locator: 'Quran 5:114',
    ),
  },
};

final t0194ProphetSupplementReferences16 = <String, List<ProphetVerseReference>>{
  'isa': const <ProphetVerseReference>[
    ProphetVerseReference(surah: 5, ayah: 114),
  ],
};
