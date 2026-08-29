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

/// T0194 research supplements for Ishaq, Ya'qub and Yusuf.
///
/// Only claims directly supportable from the pinned Quran dataset are placed
/// here. Exact birth/death years and speculative geography remain outside this
/// supplement until a later source/certainty review can support them.
final t0194ProphetBiographySupplements =
    <String, Map<ProphetBiographySectionKey, ProphetBiographyField>>{
  'ishaq': <ProphetBiographySectionKey, ProphetBiographyField>{
    ProphetBiographySectionKey.birth: _quranField(
      tr: 'Kur’an, İbrâhim’in eşine İshak’ın, ardından da Ya‘kūb’un müjdelendiğini bildirir; doğum yılı vermez.',
      en: 'The Quran states that Abraham’s wife was given glad tidings of Isaac and, after him, Jacob; it does not give a birth year.',
      ar: 'يذكر القرآن بشارة امرأة إبراهيم بإسحاق ومن وراء إسحاق يعقوب، ولا يذكر سنةً لميلاده.',
      stableId: 'ishaq-q11-71',
      locator: 'Quran 11:71',
    ),
    ProphetBiographySectionKey.missionStart: _quranField(
      tr: 'Kur’an, İshak’ı salihlerden bir peygamber olarak müjdeler.',
      en: 'The Quran gives glad tidings of Isaac as a prophet among the righteous.',
      ar: 'يبشر القرآن بإسحاق نبيًا من الصالحين.',
      stableId: 'ishaq-q37-112',
      locator: 'Quran 37:112',
    ),
    ProphetBiographySectionKey.laterImpact: _quranField(
      tr: 'Kur’an, İbrâhim’e İshak ve Ya‘kūb’un bağışlandığını ve soyunda peygamberlik ile kitabın bulunduğunu bildirir.',
      en: 'The Quran states that Isaac and Jacob were granted to Abraham and that prophethood and scripture were placed among his descendants.',
      ar: 'يذكر القرآن أن الله وهب لإبراهيم إسحاق ويعقوب وجعل في ذريته النبوة والكتاب.',
      stableId: 'ishaq-q29-27',
      locator: 'Quran 29:27',
    ),
  },
  'yakub': <ProphetBiographySectionKey, ProphetBiographyField>{
    ProphetBiographySectionKey.birth: _quranField(
      tr: 'Kur’an, Ya‘kūb’u İshak’tan sonra verilen bir müjde olarak anar; kesin doğum tarihi vermez.',
      en: 'The Quran mentions Jacob as glad tidings after Isaac; it gives no exact birth date.',
      ar: 'يذكر القرآن يعقوب بشارةً من بعد إسحاق، ولا يحدد تاريخ ميلاده.',
      stableId: 'yakub-q11-71',
      locator: 'Quran 11:71',
    ),
    ProphetBiographySectionKey.keyEvents: _quranField(
      tr: 'Yûsuf kıssasında Ya‘kūb, oğlunun kaybı karşısında sabrı tercih eder ve ümidini Allah’tan kesmez.',
      en: 'In Joseph’s story, Jacob chooses patient endurance in the face of his son’s loss and does not give up hope in Allah.',
      ar: 'في قصة يوسف يلتزم يعقوب الصبر عند فقد ابنه ولا ييأس من رحمة الله.',
      stableId: 'yakub-q12-83-87',
      locator: 'Quran 12:83-87',
    ),
    ProphetBiographySectionKey.dua: _quranField(
      tr: 'Ya‘kūb, sıkıntısını ve üzüntüsünü yalnız Allah’a arz ettiğini söyler.',
      en: 'Jacob says that he complains of his anguish and sorrow only to Allah.',
      ar: 'يقول يعقوب إنه إنما يشكو بثه وحزنه إلى الله.',
      stableId: 'yakub-q12-86',
      locator: 'Quran 12:86',
    ),
    ProphetBiographySectionKey.laterImpact: _quranField(
      tr: 'Kur’an, Ya‘kūb’un ölüm yaklaşınca oğullarına kendisinden sonra kime kulluk edeceklerini sorduğunu ve tevhid vasiyetini aktardığını bildirir.',
      en: 'The Quran recounts Jacob, as death approached, asking his sons whom they would worship after him and conveying a monotheistic legacy.',
      ar: 'يروي القرآن أن يعقوب عند حضور الموت سأل بنيه ماذا يعبدون من بعده، مثبتًا وصية التوحيد.',
      stableId: 'yakub-q2-132-133',
      locator: 'Quran 2:132-133',
    ),
  },
  'yusuf': <ProphetBiographySectionKey, ProphetBiographyField>{
    ProphetBiographySectionKey.childhoodYouth: _quranField(
      tr: 'Kur’an, Yûsuf’un çocukluk/gençlik döneminde gördüğü rüyayı babası Ya‘kūb’a anlattığı sahneyle kıssayı başlatır.',
      en: 'The Quran opens Joseph’s story with the scene in which the young Joseph tells his father Jacob about his dream.',
      ar: 'يفتتح القرآن قصة يوسف بمشهد رؤياه في صغره وإخبار أبيه يعقوب بها.',
      stableId: 'yusuf-q12-4-6',
      locator: 'Quran 12:4-6',
    ),
    ProphetBiographySectionKey.communityResponse: _quranField(
      tr: 'Kur’an, Yûsuf’un kardeşlerinin kıskançlıkla onu uzaklaştırmayı planladığını ve sonunda kuyuya bıraktıklarını anlatır.',
      en: 'The Quran recounts Joseph’s brothers jealously planning to remove him and eventually leaving him in the well.',
      ar: 'يروي القرآن تخطيط إخوة يوسف بدافع الغيرة لإبعاده ثم إلقاءه في الجب.',
      stableId: 'yusuf-q12-8-15',
      locator: 'Quran 12:8-15',
    ),
    ProphetBiographySectionKey.keyEvents: _quranField(
      tr: 'Yûsuf kıssası; kuyuya bırakılma, Mısır’da satılma, iftira karşısındaki imtihan, hapis, rüyaların yorumlanması ve ailesiyle yeniden buluşma safhalarını Kur’an içinde ayrıntılı biçimde anlatır.',
      en: 'Joseph’s Quranic account details his being left in the well, sold in Egypt, tested by accusation, imprisoned, interpreting dreams, and eventually reuniting with his family.',
      ar: 'تفصل سورة يوسف مراحل إلقائه في الجب وبيعه في مصر وابتلائه بالاتهام والسجن وتأويل الرؤى ثم اجتماعه بأهله.',
      stableId: 'yusuf-q12-15-100',
      locator: 'Quran 12:15-100',
    ),
    ProphetBiographySectionKey.miracles: _quranField(
      tr: 'Kur’an, Yûsuf’a olayların ve rüyaların yorumuna dair bilgi verildiğini anlatır; bu alan bundan öte spekülatif bir mucize listesine genişletilmez.',
      en: 'The Quran describes Joseph as being taught the interpretation of events and dreams; this field is not expanded into a speculative miracle list.',
      ar: 'يذكر القرآن تعليم يوسف تأويل الأحاديث والرؤى، ولا يوسع هذا الحقل إلى قائمة معجزات غير موثقة.',
      stableId: 'yusuf-q12-6-21',
      locator: 'Quran 12:6, 12:21',
    ),
    ProphetBiographySectionKey.dua: _quranField(
      tr: 'Kıssanın sonunda Yûsuf, kendisine verilen hükümranlık ve yorum bilgisini anarak Allah’tan Müslüman olarak vefat etmeyi ve salihlere katılmayı diler.',
      en: 'At the end of the story, Joseph recalls the authority and interpretive knowledge granted to him and asks Allah to let him die in submission and join the righteous.',
      ar: 'في ختام القصة يذكر يوسف ما آتاه الله من الملك وعلمه من تأويل الأحاديث ويسأله أن يتوفاه مسلمًا ويلحقه بالصالحين.',
      stableId: 'yusuf-q12-101',
      locator: 'Quran 12:101',
    ),
  },
};

final t0194ProphetSupplementReferences = <String, List<ProphetVerseReference>>{
  'ishaq': const <ProphetVerseReference>[
    ProphetVerseReference(surah: 11, ayah: 71),
    ProphetVerseReference(surah: 29, ayah: 27),
    ProphetVerseReference(surah: 37, ayah: 112),
  ],
  'yakub': const <ProphetVerseReference>[
    ProphetVerseReference(surah: 2, ayah: 132),
    ProphetVerseReference(surah: 2, ayah: 133),
    ProphetVerseReference(surah: 11, ayah: 71),
    ProphetVerseReference(surah: 12, ayah: 83),
    ProphetVerseReference(surah: 12, ayah: 86),
    ProphetVerseReference(surah: 12, ayah: 87),
  ],
  'yusuf': const <ProphetVerseReference>[
    ProphetVerseReference(surah: 12, ayah: 4),
    ProphetVerseReference(surah: 12, ayah: 6),
    ProphetVerseReference(surah: 12, ayah: 15),
    ProphetVerseReference(surah: 12, ayah: 21),
    ProphetVerseReference(surah: 12, ayah: 100),
    ProphetVerseReference(surah: 12, ayah: 101),
  ],
};
