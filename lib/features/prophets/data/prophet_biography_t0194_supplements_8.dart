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

/// Eighth T0194 source-reviewed batch.
///
/// Quran 19:12 directly addresses Yahya and commands him to take the Book with
/// strength. This field intentionally preserves the Quran's own generic
/// `al-kitab` wording and does not promote a later identification of that Book
/// into the Quran-backed claim.
final t0194ProphetBiographySupplements8 =
    <String, Map<ProphetBiographySectionKey, ProphetBiographyField>>{
  'yahya': <ProphetBiographySectionKey, ProphetBiographyField>{
    ProphetBiographySectionKey.scriptureScrolls: _quranField(
      tr: 'Kur’an, Yahyâ’ya “Kitab”a kuvvetle sarılmasını emreder ve ona çocuk yaşta hikmet verildiğini bildirir; bu alan ayetin kendi ifadesini aşarak Kitabın adını kesinleştirmez.',
      en: 'The Quran commands John to hold firmly to “the Book” and states that he was granted wisdom while still young; this field does not go beyond the verse by assigning a definite title to that Book.',
      ar: 'يأمر القرآن يحيى أن يأخذ «الكتاب» بقوة، ويذكر أنه أوتي الحكم صبيًا؛ ولا يتجاوز هذا الحقل لفظ الآية بتعيين اسم قطعي لذلك الكتاب.',
      stableId: 'yahya-q19-12-scripture',
      locator: 'Quran 19:12',
    ),
  },
};

final t0194ProphetSupplementReferences8 = <String, List<ProphetVerseReference>>{
  'yahya': const <ProphetVerseReference>[
    ProphetVerseReference(surah: 19, ayah: 12),
  ],
};
