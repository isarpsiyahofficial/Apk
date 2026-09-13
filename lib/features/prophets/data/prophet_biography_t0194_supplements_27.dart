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

ProphetBiographyField _quranGeographyField({
  required LocalizedReligiousText text,
  required String stableId,
  required String locator,
}) =>
    ProphetBiographyField(
      text: text,
      status: ProphetBiographyFieldStatus.sourceBacked,
      sources: <SourceReference>[_quranSource(stableId, locator)],
    );

/// Twenty-seventh T0194 source-reviewed batch.
///
/// Adds only the explicit Quranic geography association for Nuh: the Ark came
/// to rest on al-Judi (Quran 11:44). The record deliberately does not turn
/// later geographic identification, voyage duration, route, or traditional
/// calendar claims into Quran-backed facts.
final t0194ProphetBiographySupplements27 =
    <String, Map<ProphetBiographySectionKey, ProphetBiographyField>>{
  'nuh': <ProphetBiographySectionKey, ProphetBiographyField>{
    ProphetBiographySectionKey.geography: _quranGeographyField(
      text: const LocalizedReligiousText(
        tr: 'Kur’an, tufanın suları çekildikten sonra geminin Cûdî üzerine oturduğunu bildirir. Bu alan yalnız ayetin açıkça verdiği Cûdî bağlantısını kaydeder; modern konum eşlemesi, yol güzergâhı, yolculuk süresi veya kesin tarih eklemez.',
        en: 'The Quran states that after the floodwaters receded, the Ark came to rest on al-Judi. This field records only the explicit al-Judi association in the verse and adds no modern location identification, travel route, voyage duration, or exact date.',
        ar: 'يذكر القرآن أن السفينة استوت على الجودي بعد انحسار ماء الطوفان. ويقتصر هذا الحقل على الارتباط الصريح بالجودي في الآية، من غير إضافة تحديد جغرافي حديث أو مسار رحلة أو مدة سفر أو تاريخ دقيق.',
      ),
      stableId: 'nuh-q11-44-al-judi-geography',
      locator: 'Quran 11:44',
    ),
  },
};

final t0194ProphetSupplementReferences27 = <String, List<ProphetVerseReference>>{
  'nuh': const <ProphetVerseReference>[
    ProphetVerseReference(surah: 11, ayah: 44),
  ],
};
