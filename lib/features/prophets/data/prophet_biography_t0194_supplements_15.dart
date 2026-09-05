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

/// Fifteenth T0194 source-reviewed batch.
///
/// Quran 3:52 records Jesus perceiving disbelief from some of those addressed,
/// asking who would be his helpers toward Allah, and the disciples answering
/// that they were Allah's helpers, believed in Allah, and submitted to Him.
/// Quran 3:53 records their prayer affirming belief in what Allah revealed and
/// following the messenger. The field therefore preserves both sides of the
/// response visible in the verses and does not generalise the disbelief to the
/// entire community or infer a date, place, ruler, or later historical outcome.
final t0194ProphetBiographySupplements15 =
    <String, Map<ProphetBiographySectionKey, ProphetBiographyField>>{
  'isa': <ProphetBiographySectionKey, ProphetBiographyField>{
    ProphetBiographySectionKey.communityResponse: _quranField(
      tr: 'Kur’an, Îsâ’nın muhataplarından inkâr sezdiğinde Allah yolunda kimlerin kendisine yardımcı olacağını sorduğunu; havârilerin ise Allah’ın yardımcıları olduklarını, Allah’a iman ettiklerini ve teslim olduklarına şahit olunmasını istediklerini bildirir. Ardından indirilen vahye iman ettiklerini ve elçiye uyduklarını dua ile ifade ederler. Bu alan inkârı bütün topluluğa genellemez ve ayetlerin vermediği tarih, yer veya sonraki tarihsel sonucu eklemez.',
      en: 'The Quran records that when Jesus perceived disbelief among those he addressed, he asked who would be his helpers toward Allah; the disciples replied that they were Allah’s helpers, affirmed faith in Allah, and asked that their submission be witnessed. They then prayed that they believed in what Allah had sent down and followed the messenger. This field does not generalise the disbelief to the entire community or add a date, place, or later historical outcome not given by the verses.',
      ar: 'يذكر القرآن أن عيسى لما أحس الكفر من بعض من خاطبهم سأل من أنصاره إلى الله، فأجاب الحواريون بأنهم أنصار الله وآمنوا بالله وطلبوا الشهادة بأنهم مسلمون. ثم دعوا ربهم مؤكدين إيمانهم بما أنزل واتباعهم الرسول. ولا يعمم هذا الحقل الكفر على الجماعة كلها، ولا يضيف تاريخًا أو مكانًا أو نتيجة تاريخية لاحقة لم تذكرها الآيات.',
      stableId: 'isa-q3-52-53-community-response',
      locator: 'Quran 3:52-53',
    ),
  },
};

final t0194ProphetSupplementReferences15 = <String, List<ProphetVerseReference>>{
  'isa': const <ProphetVerseReference>[
    ProphetVerseReference(surah: 3, ayah: 52),
    ProphetVerseReference(surah: 3, ayah: 53),
  ],
};
