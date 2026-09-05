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

/// Ninth T0194 source-reviewed batch.
///
/// Quran 19:11 explicitly refers to Zechariah going out from the sanctuary to
/// his people and signalling to them to glorify Allah morning and evening. The
/// verse does not supply a named ethnicity, tribe, city, or later historical
/// community label, so none is inferred here.
final t0194ProphetBiographySupplements9 =
    <String, Map<ProphetBiographySectionKey, ProphetBiographyField>>{
  'zakariya': <ProphetBiographySectionKey, ProphetBiographyField>{
    ProphetBiographySectionKey.community: _quranField(
      tr: 'Kur’an, Zekeriyyâ’nın ibadet yerinden kendi kavminin/toplumunun karşısına çıktığını ve onlara sabah akşam Allah’ı tesbih etmelerini işaret ettiğini bildirir; ayet bu topluluğa ayrıca bir etnik, kabilevî veya şehir adı vermez.',
      en: 'The Quran states that Zechariah came out from the sanctuary to his people and signalled to them to glorify Allah morning and evening; the verse does not additionally assign that community an ethnic, tribal, or city label.',
      ar: 'يذكر القرآن أن زكريا خرج من المحراب على قومه فأشار إليهم أن يسبحوا الله بكرة وعشيًا؛ ولا تعطي الآية لهذه الجماعة اسمًا عرقيًا أو قبليًا أو اسم مدينة إضافيًا.',
      stableId: 'zakariya-q19-11-community',
      locator: 'Quran 19:11',
    ),
  },
};

final t0194ProphetSupplementReferences9 = <String, List<ProphetVerseReference>>{
  'zakariya': const <ProphetVerseReference>[
    ProphetVerseReference(surah: 19, ayah: 11),
  ],
};
