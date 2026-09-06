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

/// Twenty-third T0194 source-reviewed batch.
///
/// Quran 17:1 recounts Allah taking His servant by night from al-Masjid
/// al-Haram to al-Masjid al-Aqsa in order to show him some of His signs. In the
/// Prophet Muhammad biography this is kept at the Quranic boundary of the
/// Night Journey: the field does not add a calendar date, route, transport
/// mechanism, or details of the Ascension that are not stated in this verse.
final t0194ProphetBiographySupplements23 =
    <String, Map<ProphetBiographySectionKey, ProphetBiographyField>>{
  'muhammad': <ProphetBiographySectionKey, ProphetBiographyField>{
    ProphetBiographySectionKey.miracles: ProphetBiographyField(
      text: LocalizedReligiousText(
        tr: 'Kur’an, Allah’ın kulunu bir gece Mescid-i Harâm’dan çevresini bereketlendirdiği Mescid-i Aksâ’ya, ona ayetlerinden bazılarını göstermek için götürdüğünü bildirir. Bu alan İsrâ olayını ayetin verdiği sınırda aktarır; kesin tarih, güzergâh, ulaşım mekanizması veya ayette yer almayan Mi‘rac ayrıntıları eklemez.',
        en: 'The Quran states that Allah took His servant by night from al-Masjid al-Haram to al-Masjid al-Aqsa, whose surroundings He blessed, in order to show him some of His signs. This field records the Night Journey only within the verse’s boundary and adds no exact date, route, transport mechanism, or Ascension details not stated in the verse.',
        ar: 'يذكر القرآن أن الله أسرى بعبده ليلًا من المسجد الحرام إلى المسجد الأقصى الذي بارك حوله ليريه من آياته. ويقتصر هذا الحقل على حادثة الإسراء في حدود ما تنص عليه الآية، فلا يضيف تاريخًا دقيقًا ولا مسارًا ولا كيفية انتقال ولا تفاصيل عن المعراج لم تذكرها الآية.',
      ),
      status: ProphetBiographyFieldStatus.sourceBacked,
      sources: <SourceReference>[
        _quranSource('muhammad-q17-1-night-journey', 'Quran 17:1'),
      ],
    ),
  },
};

final t0194ProphetSupplementReferences23 = <String, List<ProphetVerseReference>>{
  'muhammad': const <ProphetVerseReference>[
    ProphetVerseReference(surah: 17, ayah: 1),
  ],
};
