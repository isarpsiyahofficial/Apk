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

/// Thirteenth T0194 source-reviewed batch.
///
/// Quran 3:45-47 records the angelic announcement of Jesus, son of Mary, and
/// Mary's question about having a child when no man had touched her. The birth
/// field stays inside that Quranic claim and does not invent a calendar date,
/// exact place, or medical mechanism.
///
/// Quran 3:46 states that Jesus would speak to people in the cradle and in
/// maturity. Quran 19:29-30 presents the cradle scene and Jesus declaring
/// himself a servant of Allah who was given scripture and made a prophet. The
/// childhood field records only that Quranic early-life scene; it does not add
/// later childhood narratives.
final t0194ProphetBiographySupplements13 =
    <String, Map<ProphetBiographySectionKey, ProphetBiographyField>>{
  'isa': <ProphetBiographySectionKey, ProphetBiographyField>{
    ProphetBiographySectionKey.birth: _quranField(
      tr: 'Kur’an, meleklerin Meryem’e Mesih Îsâ b. Meryem’i müjdelediğini ve Meryem’in kendisine bir erkek dokunmamışken nasıl çocuğu olacağını sorduğunu bildirir. Bu alan yalnız bu Kur’anî doğum haberini aktarır; kesin doğum tarihi, doğum yeri veya tıbbi mekanizma eklemez.',
      en: 'The Quran records the angelic announcement to Mary of the Messiah, Jesus son of Mary, and Mary asking how she could have a child when no man had touched her. This field records only that Quranic birth account and adds no exact birth date, birthplace, or medical mechanism.',
      ar: 'يذكر القرآن بشارة الملائكة لمريم بالمسيح عيسى ابن مريم، وسؤالها كيف يكون لها ولد ولم يمسسها بشر. ويقتصر هذا الحقل على خبر الميلاد القرآني من غير إضافة تاريخ ميلاد دقيق أو مكان ولادة أو تفسير طبي.',
      stableId: 'isa-q3-45-47-birth',
      locator: 'Quran 3:45-47',
    ),
    ProphetBiographySectionKey.childhoodYouth: _quranField(
      tr: 'Kur’an, Îsâ’nın beşikte insanlarla konuşacağını bildirir; Meryem sûresinde de beşikteyken Allah’ın kulu olduğunu, kendisine Kitap verildiğini ve peygamber kılındığını söylediği aktarılır. Bunun ötesinde doğrulanmamış çocukluk anlatıları eklenmez.',
      en: 'The Quran states that Jesus would speak to people in the cradle; Surah Maryam also presents him speaking in the cradle, declaring that he is a servant of Allah, that he was given the Scripture, and made a prophet. No unverified childhood narrative is added beyond this.',
      ar: 'يذكر القرآن أن عيسى يكلم الناس في المهد، وتعرض سورة مريم كلامه في المهد معلنًا أنه عبد الله وأنه أوتي الكتاب وجُعل نبيًا. ولا تُضاف إلى ذلك روايات طفولة غير موثقة.',
      stableId: 'isa-q3-46-q19-29-30-childhood',
      locator: 'Quran 3:46; 19:29-30',
    ),
  },
};

final t0194ProphetSupplementReferences13 = <String, List<ProphetVerseReference>>{
  'isa': const <ProphetVerseReference>[
    ProphetVerseReference(surah: 3, ayah: 45),
    ProphetVerseReference(surah: 3, ayah: 46),
    ProphetVerseReference(surah: 3, ayah: 47),
    ProphetVerseReference(surah: 19, ayah: 29),
    ProphetVerseReference(surah: 19, ayah: 30),
  ],
};
