import '../../../core/content/content_governance.dart';
import 'canonical_prophet_biographies.dart';
import 'prophet_biography_t0194_supplements_26.dart';
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

/// Twenty-fifth T0194 source-reviewed batch.
///
/// This batch adds only geography that the Quran states explicitly. It does not
/// infer chronology, modern borders, archaeological identification, route
/// details, or exact historical dates from the place references.
///
/// The twenty-sixth Quran-reviewed geography batch is composed here so the
/// additional Ibrahim/Ismail/Yusuf/Shuayb geography evidence enters the same
/// canonical T0194 composition chain without bypassing provenance checks.
final t0194ProphetBiographySupplements25 =
    <String, Map<ProphetBiographySectionKey, ProphetBiographyField>>{
  ...t0194ProphetBiographySupplements26,
  'musa': <ProphetBiographySectionKey, ProphetBiographyField>{
    ProphetBiographySectionKey.geography: _quranGeographyField(
      text: const LocalizedReligiousText(
        tr: 'Kur’an, Mûsâ’nın şehirden ayrıldıktan sonra Medyen’e doğru yöneldiğini ve Medyen suyuna ulaştığını bildirir. Bu alan yalnız ayetin açık coğrafya bilgisini taşır; Medyen’in modern sınırlarını, yol güzergâhını veya kesin tarihini ayetten türetmez.',
        en: 'The Quran states that after leaving the city Moses headed toward Midian and reached the water of Midian. This field carries only that explicit geographic information and does not derive modern borders, a travel route, or an exact date from the verse.',
        ar: 'يذكر القرآن أن موسى بعد خروجه من المدينة توجه تلقاء مدين ثم ورد ماء مدين. ويقتصر هذا الحقل على الدلالة الجغرافية الصريحة في الآيات، ولا يستنبط منها حدودًا حديثة ولا مسار سفر ولا تاريخًا دقيقًا.',
      ),
      stableId: 'musa-q28-22-23-madyan-geography',
      locator: 'Quran 28:22-23',
    ),
  },
  'muhammad': <ProphetBiographySectionKey, ProphetBiographyField>{
    ProphetBiographySectionKey.geography: _quranGeographyField(
      text: const LocalizedReligiousText(
        tr: 'Kur’an, İsrâ anlatısında Allah’ın kulunu bir gece Mescid-i Harâm’dan Mescid-i Aksâ’ya götürdüğünü bildirir. Bu alan yalnız ayette açıkça verilen iki coğrafî durağı kaydeder; güzergâh, modern sınır veya kesin tarih eklemez.',
        en: 'In the Night Journey account, the Quran states that Allah took His servant by night from al-Masjid al-Haram to al-Masjid al-Aqsa. This field records only the two geographic endpoints explicitly stated in the verse and adds no route, modern boundary, or exact date.',
        ar: 'يذكر القرآن في خبر الإسراء أن الله أسرى بعبده ليلًا من المسجد الحرام إلى المسجد الأقصى. ويثبت هذا الحقل الموضعين الجغرافيين المذكورين صراحة في الآية فقط، من غير إضافة مسار أو حدود حديثة أو تاريخ دقيق.',
      ),
      stableId: 'muhammad-q17-1-isra-geography',
      locator: 'Quran 17:1',
    ),
  },
};

final t0194ProphetSupplementReferences25 = <String, List<ProphetVerseReference>>{
  ...t0194ProphetSupplementReferences26,
  'musa': const <ProphetVerseReference>[
    ProphetVerseReference(surah: 28, ayah: 22),
    ProphetVerseReference(surah: 28, ayah: 23),
  ],
  'muhammad': const <ProphetVerseReference>[
    ProphetVerseReference(surah: 17, ayah: 1),
  ],
};
