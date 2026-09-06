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

/// Nineteenth T0194 source-reviewed batch.
///
/// Quran 5:112-115 records the disciples asking Jesus son of Mary about a
/// table from heaven, Jesus first calling them to fear Allah, their stated
/// reasons for the request, Jesus's supplication, and Allah's response that He
/// would send it down together with a warning against disbelief afterwards.
/// This field records only that Quranic sequence. It does not invent the food
/// on the table, a date or place, a recurring ritual, or details from later
/// narrative traditions.
final t0194ProphetBiographySupplements19 =
    <String, Map<ProphetBiographySectionKey, ProphetBiographyField>>{
  'isa': <ProphetBiographySectionKey, ProphetBiographyField>{
    ProphetBiographySectionKey.keyEvents: _quranField(
      tr: 'Kur’an, havârilerin Meryem oğlu Îsâ’dan gökten bir sofra indirilmesi hakkında Rablerine dua etmesini istemeleri bağlamını anlatır. Îsâ önce Allah’tan sakınmalarını söyler; onlar sofradan yemek, kalplerinin tatmin olması, Îsâ’nın kendilerine doğru söylediğini bilmek ve olaya şahitlik etmek istediklerini belirtirler. Îsâ dua eder; Allah da sofrayı indireceğini bildirir ve sonrasında inkâr edenler için ağır bir uyarıda bulunur. Bu alan sofradaki yiyecekleri, tarih veya yeri, tekrarlanan bir ritüeli ya da sonraki rivayet ayrıntılarını uydurmaz.',
      en: 'The Quran recounts the disciples asking Jesus son of Mary about a table being sent down from heaven. Jesus first tells them to fear Allah; they say that they wish to eat from it, have their hearts reassured, know that he has spoken truthfully to them, and be witnesses to it. Jesus supplicates, and Allah states that He will send it down while warning against disbelief afterwards. This field does not invent the food on the table, a date or place, a recurring ritual, or details from later narrative traditions.',
      ar: 'يروي القرآن أن الحواريين سألوا عيسى ابن مريم عن إنزال مائدة من السماء، فدعاهم عيسى أولًا إلى تقوى الله. وذكروا أنهم يريدون أن يأكلوا منها وتطمئن قلوبهم ويعلموا صدقه ويكونوا عليها من الشاهدين. ثم دعا عيسى ربه، فأخبر الله أنه سينزلها وحذّر من الكفر بعد ذلك. ولا يختلق هذا الحقل نوع الطعام على المائدة، ولا تاريخًا أو مكانًا، ولا عبادة متكررة، ولا تفاصيل من روايات لاحقة.',
      stableId: 'isa-q5-112-115-key-events',
      locator: 'Quran 5:112-115',
    ),
  },
};

final t0194ProphetSupplementReferences19 = <String, List<ProphetVerseReference>>{
  'isa': const <ProphetVerseReference>[
    ProphetVerseReference(surah: 5, ayah: 112),
    ProphetVerseReference(surah: 5, ayah: 113),
    ProphetVerseReference(surah: 5, ayah: 114),
    ProphetVerseReference(surah: 5, ayah: 115),
  ],
};
