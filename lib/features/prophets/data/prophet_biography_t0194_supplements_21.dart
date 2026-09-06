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

/// Twenty-first T0194 source-reviewed batch.
///
/// Quran 23:50 states that the son of Mary and his mother were given refuge on
/// elevated ground described as having a settled/resting place and flowing
/// water. The verse does not name that place. Classical exegetical literature
/// contains differing location identifications, so this Quran-only geography
/// field deliberately records the described terrain without promoting any
/// named city, country, or region to a Quranic fact.
final t0194ProphetBiographySupplements21 =
    <String, Map<ProphetBiographySectionKey, ProphetBiographyField>>{
  'isa': <ProphetBiographySectionKey, ProphetBiographyField>{
    ProphetBiographySectionKey.geography: _quranField(
      tr: 'Kur’an, Meryem oğlu Îsâ ile annesinin yerleşmeye elverişli ve akarsu bulunan yüksekçe bir yere sığındırıldığını bildirir. Ayet bu yerin adını vermez; bu nedenle bu alan Kudüs, Şam, Filistin veya başka bir adlandırmayı Kur’an’ın kesin coğrafî tespiti gibi sunmaz.',
      en: 'The Quran states that Jesus son of Mary and his mother were given refuge on elevated ground with a suitable resting place and flowing water. The verse does not name that place, so this field does not present Jerusalem, Damascus, Palestine, or any other identification as a definite Quranic location.',
      ar: 'يذكر القرآن أن عيسى ابن مريم وأمه أُويا إلى ربوة ذات قرار ومعين. ولا تسمّي الآية ذلك الموضع، لذلك لا يقدّم هذا الحقل القدس أو دمشق أو فلسطين أو أي تعيين آخر على أنه تحديد جغرافي قرآني قطعي.',
      stableId: 'isa-q23-50-geography',
      locator: 'Quran 23:50',
    ),
  },
};

final t0194ProphetSupplementReferences21 = <String, List<ProphetVerseReference>>{
  'isa': const <ProphetVerseReference>[
    ProphetVerseReference(surah: 23, ayah: 50),
  ],
};
