import '../../../core/content/content_governance.dart';
import 'canonical_prophet_biographies.dart';
import 'prophet_biography_t0194_supplements_22.dart';
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

/// Twenty-first T0194 source-reviewed batch.
///
/// Quran 23:50 states that the son of Mary and his mother were given refuge on
/// elevated ground described as having a settled/resting place and flowing
/// water. The verse does not name that place. Classical exegetical literature
/// contains differing location identifications, so this Quran-only geography
/// field deliberately records only the terrain description and does not repeat
/// or promote any later named-location proposal as Quranic evidence.
///
/// The twenty-second supplement is composed here as a separate provenance
/// layer. It adds only a broad first-century historical period from modern
/// scholarship and explicitly prevents that chronology from being presented as
/// a Quranic date or as an exact birth/death year.
final t0194ProphetBiographySupplements21 =
    <String, Map<ProphetBiographySectionKey, ProphetBiographyField>>{
  'isa': <ProphetBiographySectionKey, ProphetBiographyField>{
    ...t0194ProphetBiographySupplements22['isa']!,
    ProphetBiographySectionKey.geography: _quranField(
      tr: 'Kur’an, Meryem oğlu Îsâ ile annesinin yerleşmeye elverişli ve akarsu bulunan yüksekçe bir yere sığındırıldığını bildirir. Ayet bu yerin adını vermez; bu nedenle ayetin belirtmediği herhangi bir şehir, bölge veya ülke adı Kur’an’ın kesin coğrafî tespiti gibi sunulmaz.',
      en: 'The Quran states that Jesus son of Mary and his mother were given refuge on elevated ground with a suitable resting place and flowing water. The verse does not name that place, so no city, region, or country not identified by the verse is presented as a definite Quranic location.',
      ar: 'يذكر القرآن أن عيسى ابن مريم وأمه أُويا إلى ربوة ذات قرار ومعين. ولا تسمّي الآية ذلك الموضع، لذلك لا يقدّم هذا الحقل اسم مدينة أو إقليم أو بلد لم تعيّنه الآية على أنه تحديد جغرافي قرآني قطعي.',
      stableId: 'isa-q23-50-geography',
      locator: 'Quran 23:50',
    ),
  },
};

final t0194ProphetSupplementReferences21 = <String, List<ProphetVerseReference>>{
  'isa': <ProphetVerseReference>[
    const ProphetVerseReference(surah: 23, ayah: 50),
    ...?t0194ProphetSupplementReferences22['isa'],
  ],
};
