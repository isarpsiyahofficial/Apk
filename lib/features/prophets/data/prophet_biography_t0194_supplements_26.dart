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

/// Twenty-sixth T0194 source-reviewed batch.
///
/// Adds only geography explicitly anchored by the Quran: Ibrahim and Ismail at
/// the House/Kaaba, Yusuf in Egypt, and Shuayb with Midian. The fields avoid
/// modern borders, coordinates, inferred routes and exact historical dates.
final t0194ProphetBiographySupplements26 =
    <String, Map<ProphetBiographySectionKey, ProphetBiographyField>>{
  'ibrahim': <ProphetBiographySectionKey, ProphetBiographyField>{
    ProphetBiographySectionKey.geography: _quranGeographyField(
      text: const LocalizedReligiousText(
        tr: 'Kur’an, İbrâhim ile İsmâil’in Beyt’in (Kâbe’nin) temellerini birlikte yükselttiklerini bildirir. Bu alan yalnız bu açık mekân bağını kaydeder; modern koordinat, yol güzergâhı veya kesin tarih eklemez.',
        en: 'The Quran states that Abraham and Ishmael raised the foundations of the House (the Kaaba) together. This field records only that explicit place association and adds no modern coordinates, route, or exact date.',
        ar: 'يذكر القرآن أن إبراهيم وإسماعيل كانا يرفعان قواعد البيت (الكعبة) معًا. ويقتصر هذا الحقل على هذا الارتباط المكاني الصريح، من غير إضافة إحداثيات حديثة أو مسار أو تاريخ دقيق.',
      ),
      stableId: 'ibrahim-q2-127-kaaba-geography',
      locator: 'Quran 2:127',
    ),
  },
  'ismail': <ProphetBiographySectionKey, ProphetBiographyField>{
    ProphetBiographySectionKey.geography: _quranGeographyField(
      text: const LocalizedReligiousText(
        tr: 'Kur’an, İsmâil’in İbrâhim ile birlikte Beyt’in (Kâbe’nin) temellerini yükselttiğini bildirir. Bu alan yalnız ayetin açık mekân bilgisini taşır; modern koordinat, rota veya kesin tarih türetmez.',
        en: 'The Quran states that Ishmael, together with Abraham, raised the foundations of the House (the Kaaba). This field carries only the verse’s explicit geographic information and derives no modern coordinates, route, or exact date.',
        ar: 'يذكر القرآن أن إسماعيل رفع مع إبراهيم قواعد البيت (الكعبة). ويقتصر هذا الحقل على الدلالة المكانية الصريحة في الآية، ولا يستنبط إحداثيات حديثة ولا مسارًا ولا تاريخًا دقيقًا.',
      ),
      stableId: 'ismail-q2-127-kaaba-geography',
      locator: 'Quran 2:127',
    ),
  },
  'yusuf': <ProphetBiographySectionKey, ProphetBiographyField>{
    ProphetBiographySectionKey.geography: _quranGeographyField(
      text: const LocalizedReligiousText(
        tr: 'Kur’an, Yûsuf’u satın alan kişinin Mısır’dan olduğunu ve Yûsuf’un orada yerleştirildiğini bildirir. Bu alan yalnız Mısır bağlantısını kaydeder; şehir, saray, rota veya kesin tarih gibi ayetin açıkça vermediği ayrıntıları eklemez.',
        en: 'The Quran states that the man who bought Joseph was from Egypt and that Joseph was established there. This field records only the Egypt association and adds no city, palace, route, or exact date not explicitly supplied by the verse.',
        ar: 'يذكر القرآن أن الذي اشترى يوسف كان من مصر وأن يوسف مُكّن له هناك. ويقتصر هذا الحقل على صلته الصريحة بمصر، من غير إضافة مدينة أو قصر أو مسار أو تاريخ دقيق لم تنص عليه الآية.',
      ),
      stableId: 'yusuf-q12-21-egypt-geography',
      locator: 'Quran 12:21',
    ),
  },
  'shuayb': <ProphetBiographySectionKey, ProphetBiographyField>{
    ProphetBiographySectionKey.geography: _quranGeographyField(
      text: const LocalizedReligiousText(
        tr: 'Kur’an, Şuayb’ın Medyen halkına gönderildiğini açıkça bildirir. Bu alan yalnız Medyen bağlantısını kaydeder; modern sınır, koordinat veya kesin tarih eklemez.',
        en: 'The Quran explicitly states that Shuayb was sent to the people of Midian. This field records only the Midian association and adds no modern boundary, coordinate, or exact date.',
        ar: 'يصرح القرآن بأن شعيبًا أُرسل إلى أهل مدين. ويقتصر هذا الحقل على الارتباط بمدين، من غير إضافة حدود حديثة أو إحداثيات أو تاريخ دقيق.',
      ),
      stableId: 'shuayb-q11-84-madyan-geography',
      locator: 'Quran 11:84',
    ),
  },
};

final t0194ProphetSupplementReferences26 = <String, List<ProphetVerseReference>>{
  'ibrahim': const <ProphetVerseReference>[
    ProphetVerseReference(surah: 2, ayah: 127),
  ],
  'ismail': const <ProphetVerseReference>[
    ProphetVerseReference(surah: 2, ayah: 127),
  ],
  'yusuf': const <ProphetVerseReference>[
    ProphetVerseReference(surah: 12, ayah: 21),
  ],
  'shuayb': const <ProphetVerseReference>[
    ProphetVerseReference(surah: 11, ayah: 84),
  ],
};