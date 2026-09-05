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
/// Quran 19:12 directly addresses Yahya, commands him to take the Book with
/// strength, and states that he was granted judgement/wisdom while still a
/// child. These fields intentionally preserve the Quran's own wording: they do
/// not promote a later identification of `al-kitab` or invent a wider childhood
/// chronology beyond what the verse states.
final t0194ProphetBiographySupplements8 =
    <String, Map<ProphetBiographySectionKey, ProphetBiographyField>>{
  'yahya': <ProphetBiographySectionKey, ProphetBiographyField>{
    ProphetBiographySectionKey.childhoodYouth: _quranField(
      tr: 'Kur’an, Yahyâ’ya çocuk yaşta hüküm ve hikmet verildiğini açıkça bildirir; bu alan ayetin ötesine geçerek çocukluk yıllarına ilişkin ayrıntılı bir kronoloji kurmaz.',
      en: 'The Quran explicitly states that John was granted judgement and wisdom while still a child; this field does not go beyond the verse by constructing a detailed childhood chronology.',
      ar: 'يصرح القرآن بأن يحيى أوتي الحكم وهو صبي؛ ولا يتجاوز هذا الحقل نص الآية بإنشاء تسلسل زمني مفصل لطفولته.',
      stableId: 'yahya-q19-12-childhood',
      locator: 'Quran 19:12',
    ),
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