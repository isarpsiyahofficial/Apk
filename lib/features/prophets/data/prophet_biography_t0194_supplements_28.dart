import '../../../core/content/content_governance.dart';
import 'canonical_prophet_biographies.dart';
import 'prophet_biography_t0194_supplements_29.dart';
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

/// Twenty-eighth T0194 source-reviewed batch.
///
/// Adds two geography associations supported by Quranic cross-reference:
/// Hud with the people of 'Ad in al-Ahqaf (46:21, with Hud explicitly named as
/// the brother of 'Ad in 11:50), and Harun in the Pharaoh setting associated
/// with Egypt (23:45-46; 43:51). These records deliberately avoid modern
/// borders, coordinates, inferred routes, reign identification, and exact
/// historical dates.
///
/// The twenty-ninth source-reviewed batch is composed here so the conservative
/// Salih/Thamud settlement and Lut town/road geography evidence remains in the
/// same fail-closed T0194 provenance chain.
final t0194ProphetBiographySupplements28 =
    <String, Map<ProphetBiographySectionKey, ProphetBiographyField>>{
  ...t0194ProphetBiographySupplements29,
  'hud': <ProphetBiographySectionKey, ProphetBiographyField>{
    ProphetBiographySectionKey.geography: _quranGeographyField(
      text: const LocalizedReligiousText(
        tr: 'Kur’an, Hûd’u Âd kavminin kardeşi olarak tanıtır; ayrıca Âd’in kardeşinin Ahkâf’ta kavmini uyardığını bildirir. Bu alan yalnız bu Kur’an içi çapraz bağlantıyı kaydeder; Ahkâf için modern sınır, koordinat, rota veya kesin tarih eklemez.',
        en: 'The Quran identifies Hud as the brother of the people of Aad and also states that the brother of Aad warned his people in al-Ahqaf. This field records only that Quranic cross-reference and adds no modern boundary, coordinate, route, or exact date for al-Ahqaf.',
        ar: 'يعرّف القرآن هودًا بأنه أخو عاد، ويذكر كذلك أن أخا عاد أنذر قومه بالأحقاف. ويقتصر هذا الحقل على هذا الربط القرآني الداخلي، من غير إضافة حدود حديثة أو إحداثيات أو مسار أو تاريخ دقيق للأحقاف.',
      ),
      stableId: 'hud-q11-50-q46-21-ahqaf-geography',
      locator: 'Quran 11:50; 46:21',
    ),
  },
  'harun': <ProphetBiographySectionKey, ProphetBiographyField>{
    ProphetBiographySectionKey.geography: _quranGeographyField(
      text: const LocalizedReligiousText(
        tr: 'Kur’an, Mûsâ ile kardeşi Hârûn’un Firavun ve ileri gelenlerine gönderildiğini bildirir; aynı Firavun anlatısında Mısır onun egemenlik alanı olarak anılır. Bu alan yalnız bu Kur’an içi bağlamı kaydeder; firavunun kimliği, modern sınırlar veya kesin tarih hakkında çıkarım yapmaz.',
        en: 'The Quran states that Moses and his brother Aaron were sent to Pharaoh and his chiefs; within the same Pharaoh narrative, Egypt is named as his domain. This field records only that Quranic context and makes no inference about Pharaoh’s identity, modern borders, or an exact date.',
        ar: 'يذكر القرآن أن موسى وأخاه هارون أُرسلا إلى فرعون وملئه، ويذكر في سياق فرعون نفسه مصر بوصفها نطاق ملكه. ويقتصر هذا الحقل على هذا السياق القرآني، من غير استنتاج لهوية فرعون أو حدود حديثة أو تاريخ دقيق.',
      ),
      stableId: 'harun-q23-45-46-q43-51-egypt-geography',
      locator: 'Quran 23:45-46; 43:51',
    ),
  },
};

final t0194ProphetSupplementReferences28 = <String, List<ProphetVerseReference>>{
  ...t0194ProphetSupplementReferences29,
  'hud': const <ProphetVerseReference>[
    ProphetVerseReference(surah: 11, ayah: 50),
    ProphetVerseReference(surah: 46, ayah: 21),
  ],
  'harun': const <ProphetVerseReference>[
    ProphetVerseReference(surah: 23, ayah: 45),
    ProphetVerseReference(surah: 23, ayah: 46),
    ProphetVerseReference(surah: 43, ayah: 51),
  ],
};
