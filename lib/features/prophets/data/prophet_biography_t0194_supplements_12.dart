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

/// Twelfth T0194 source-reviewed batch.
///
/// Quran 19:7 presents Yahya as the son announced to Zechariah, while Quran
/// 3:39 describes Yahya as a prophet among the righteous. These verses support
/// only a relative narrative period tied to Zechariah; they do not supply a
/// calendar year, century, ruler, or independent historical chronology.
///
/// Quran 19:8-9 records Zechariah's old age and his wife's barrenness and the
/// divine answer that the promised son is easy for Allah; Quran 21:90 states
/// that the prayer was answered and Yahya was granted to him. The miracles
/// field therefore records only these Quranic extraordinary birth
/// circumstances and does not add medical mechanisms or later tradition.
final t0194ProphetBiographySupplements12 =
    <String, Map<ProphetBiographySectionKey, ProphetBiographyField>>{
  'yahya': <ProphetBiographySectionKey, ProphetBiographyField>{
    ProphetBiographySectionKey.period: _quranField(
      tr: 'Kur’an, Yahyâ’yı Zekeriyyâ’ya verilen oğul müjdesi bağlamında anar ve onu salihlerden bir peygamber olarak niteler. Bu anlatı Yahyâ’nın dönemini Zekeriyyâ’nın hayatıyla ilişkili olarak konumlandırır; ancak takvim yılı, yüzyıl veya hükümdar adı vermez.',
      en: 'The Quran presents John in the context of the son announced to Zechariah and describes him as a prophet among the righteous. This places his Quranic period in relation to Zechariah’s lifetime, but gives no calendar year, century, or ruler.',
      ar: 'يعرض القرآن يحيى في سياق البشارة به ولدًا لزكريا، ويصفه بأنه نبي من الصالحين. وهذا يضع زمنه القرآني في صلة بحياة زكريا، من غير تحديد سنة تقويمية أو قرن أو اسم حاكم.',
      stableId: 'yahya-q3-39-q19-7-period',
      locator: 'Quran 3:39; 19:7',
    ),
    ProphetBiographySectionKey.miracles: _quranField(
      tr: 'Kur’an’da Zekeriyyâ, ileri yaşına ulaştığını ve eşinin kısır olduğunu söyler; buna rağmen kendisine Yahyâ müjdelenir. Allah bu duaya karşılık verdiğini ve Yahyâ’yı ona bağışladığını bildirir. Burada yalnız Kur’an’ın anlattığı olağanüstü doğum şartları aktarılır; tıbbi mekanizma veya sonraki rivayet ayrıntısı eklenmez.',
      en: 'In the Quran, Zechariah says that he has reached old age and that his wife is barren, yet he is given the good news of John. Allah states that the prayer was answered and that John was granted to him. This records only the extraordinary birth circumstances stated by the Quran, without adding a medical mechanism or later traditional detail.',
      ar: 'يذكر القرآن أن زكريا بلغ من الكبر وأن امرأته كانت عاقرًا، ومع ذلك بُشِّر بيحيى. ويخبر الله أنه استجاب دعاءه ووهب له يحيى. ويقتصر هذا الوصف على ظروف الميلاد الخارقة للعادة التي نص عليها القرآن، من غير إضافة تفسير طبي أو تفاصيل من روايات متأخرة.',
      stableId: 'yahya-q19-8-9-q21-90-extraordinary-birth',
      locator: 'Quran 19:8-9; 21:90',
    ),
  },
};

final t0194ProphetSupplementReferences12 = <String, List<ProphetVerseReference>>{
  'yahya': const <ProphetVerseReference>[
    ProphetVerseReference(surah: 3, ayah: 39),
    ProphetVerseReference(surah: 19, ayah: 7),
    ProphetVerseReference(surah: 19, ayah: 8),
    ProphetVerseReference(surah: 19, ayah: 9),
    ProphetVerseReference(surah: 21, ayah: 90),
  ],
};
