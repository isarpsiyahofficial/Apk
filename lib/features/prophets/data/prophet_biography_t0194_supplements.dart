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

/// T0194 research supplements layered after the source-backed base biographies.
///
/// Only claims directly supportable from the pinned Quran dataset are placed
/// here. Exact birth/death years, modern map coordinates and chronology that
/// the Quran does not establish remain pending instead of being inferred.
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
  'ayyub': <ProphetBiographySectionKey, ProphetBiographyField>{
    ProphetBiographySectionKey.keyEvents: _quranField(
      tr: 'Kur’an, Eyyûb’un ağır bir sıkıntıyla Rabbine yöneldiğini, ardından sıkıntısının giderildiğini ve ailesinin kendisine yeniden bağışlandığını bildirir; hastalığın türünü veya süresini kesinleştirmez.',
      en: 'The Quran recounts Job turning to his Lord in severe distress, after which his distress was removed and his family was restored to him; it does not specify the illness or its duration.',
      ar: 'يروي القرآن توجه أيوب إلى ربه عند الضر، ثم كشف الضر عنه ورد أهله إليه، من غير تحديد نوع المرض أو مدته.',
      stableId: 'ayyub-q21-83-84',
      locator: 'Quran 21:83-84',
    ),
    ProphetBiographySectionKey.dua: _quranField(
      tr: 'Eyyûb, kendisine sıkıntı dokunduğunu belirterek Allah’ın merhametine sığınır.',
      en: 'Job calls upon Allah while acknowledging the distress that has touched him and appealing to His mercy.',
      ar: 'يدعو أيوب ربه مقرًا بما مسه من الضر ومتوسلًا برحمته.',
      stableId: 'ayyub-q21-83',
      locator: 'Quran 21:83',
    ),
    ProphetBiographySectionKey.laterImpact: _quranField(
      tr: 'Kur’an, Eyyûb’un sıkıntısının giderilmesini Allah’tan bir rahmet ve kulluk edenler için bir hatırlatma olarak sunar.',
      en: 'The Quran presents the removal of Job’s distress as mercy from Allah and a reminder for worshippers.',
      ar: 'يعرض القرآن كشف الضر عن أيوب رحمةً من الله وذكرى للعابدين.',
      stableId: 'ayyub-q21-84',
      locator: 'Quran 21:84',
    ),
  },
  'shuayb': <ProphetBiographySectionKey, ProphetBiographyField>{
    ProphetBiographySectionKey.community: _quranField(
      tr: 'Kur’an, Şuayb’ın Medyen halkına gönderildiğini açıkça belirtir.',
      en: 'The Quran explicitly states that Shuayb was sent to the people of Midian.',
      ar: 'يصرح القرآن بأن شعيبًا أُرسل إلى أهل مدين.',
      stableId: 'shuayb-q11-84',
      locator: 'Quran 11:84',
    ),
    ProphetBiographySectionKey.missionStart: _quranField(
      tr: 'Şuayb’ın çağrısı Allah’a kulluğu, ölçü ve tartıda hakkaniyeti, insanların mallarını eksiltmemeyi ve yeryüzünde bozgunculuk yapmamayı birlikte vurgular.',
      en: 'Shuayb’s call joins worship of Allah with fairness in measure and weight, not depriving people of their goods, and avoiding corruption on earth.',
      ar: 'تجمع دعوة شعيب بين عبادة الله والعدل في الكيل والميزان وعدم بخس الناس أشياءهم وترك الفساد في الأرض.',
      stableId: 'shuayb-q11-84-86',
      locator: 'Quran 11:84-86',
    ),
    ProphetBiographySectionKey.communityResponse: _quranField(
      tr: 'Kavmi, atalarının taptıklarını ve mallarında diledikleri gibi tasarrufu bırakmalarını istemesini alaycı bir itirazla karşıladı.',
      en: 'His people answered with a mocking objection to being asked to leave what their ancestors worshipped and to restrain how they dealt with their property.',
      ar: 'واجه قومه دعوته باعتراض ساخر على ترك ما كان يعبد آباؤهم وعلى تقييد تصرفهم في أموالهم.',
      stableId: 'shuayb-q11-87',
      locator: 'Quran 11:87',
    ),
    ProphetBiographySectionKey.keyEvents: _quranField(
      tr: 'Kur’an, hüküm geldiğinde Şuayb ve beraberindeki iman edenlerin rahmetle kurtarıldığını, zulmedenlerin ise cezaya uğradığını bildirir.',
      en: 'The Quran states that when the decree came, Shuayb and those who believed with him were saved by mercy, while the wrongdoers were overtaken by punishment.',
      ar: 'يذكر القرآن أنه لما جاء الأمر نُجّي شعيب والذين آمنوا معه برحمة، وأخذ العذاب الذين ظلموا.',
      stableId: 'shuayb-q11-94-95',
      locator: 'Quran 11:94-95',
    ),
  },
  'musa': <ProphetBiographySectionKey, ProphetBiographyField>{
    ProphetBiographySectionKey.childhoodYouth: _quranField(
      tr: 'Kur’an, Mûsâ’nın annesine onu emzirmesinin, korktuğunda nehre bırakmasının bildirildiğini; ardından Mûsâ’nın annesine geri döndürüldüğünü anlatır.',
      en: 'The Quran recounts Moses’ mother being instructed to nurse him and, when afraid for him, place him in the river; it then recounts his return to his mother.',
      ar: 'يروي القرآن إلهام أم موسى أن ترضعه وأن تلقيه في اليم عند الخوف عليه، ثم إعادته إليها.',
      stableId: 'musa-q28-7-13',
      locator: 'Quran 28:7-13',
    ),
    ProphetBiographySectionKey.missionStart: _quranField(
      tr: 'Kur’an, Mûsâ’ya vadide hitap edildiğini, Allah’ın kendisini tanıttığını ve ona Firavun ile ileri gelenlerine yönelmesi için deliller verildiğini anlatır.',
      en: 'The Quran recounts Moses being addressed in the valley, Allah identifying Himself to him, and signs being given for his mission to Pharaoh and his chiefs.',
      ar: 'يروي القرآن نداء موسى في الوادي وتعريف الله له بنفسه وإعطاءه آيات لمهمته إلى فرعون وملئه.',
      stableId: 'musa-q28-30-32',
      locator: 'Quran 28:30-32',
    ),
    ProphetBiographySectionKey.communityResponse: _quranField(
      tr: 'Firavun, Mûsâ’nın çağrısına karşı çıkarak onu hapisle tehdit etti; Mûsâ ise kendisine verilen açık delilleri gösterdi.',
      en: 'Pharaoh opposed Moses’ call and threatened him with imprisonment, while Moses presented the clear signs given to him.',
      ar: 'عارض فرعون دعوة موسى وهدده بالسجن، فأظهر موسى ما أُعطي من الآيات البينات.',
      stableId: 'musa-q26-29-33',
      locator: 'Quran 26:29-33',
    ),
    ProphetBiographySectionKey.miracles: _quranField(
      tr: 'Kur’an, Mûsâ’ya asasının dönüşmesi ve elinin kusursuz biçimde beyaz görünmesi şeklinde iki açık delil verildiğini bildirir.',
      en: 'The Quran states that Moses was given two clear signs: the transformation of his staff and his hand appearing white without harm.',
      ar: 'يذكر القرآن أن موسى أُعطي برهانين ظاهرين: تحول عصاه وخروج يده بيضاء من غير سوء.',
      stableId: 'musa-q28-31-32',
      locator: 'Quran 28:31-32',
    ),
    ProphetBiographySectionKey.dua: _quranField(
      tr: 'Mûsâ, görevinin başında gönlüne ferahlık verilmesini, işinin kolaylaştırılmasını, sözünün anlaşılmasını ve kardeşi Hârûn’un kendisine yardımcı kılınmasını diler.',
      en: 'At the outset of his mission, Moses asks for ease in his task, clarity in his speech, and for his brother Aaron to be appointed as his helper.',
      ar: 'في بداية مهمته يسأل موسى ربه شرح صدره وتيسير أمره وفهم كلامه وأن يجعل أخاه هارون معينًا له.',
      stableId: 'musa-q20-25-35',
      locator: 'Quran 20:25-35',
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
  'ayyub': const <ProphetVerseReference>[
    ProphetVerseReference(surah: 6, ayah: 84),
    ProphetVerseReference(surah: 21, ayah: 83),
    ProphetVerseReference(surah: 21, ayah: 84),
  ],
  'shuayb': const <ProphetVerseReference>[
    ProphetVerseReference(surah: 11, ayah: 84),
    ProphetVerseReference(surah: 11, ayah: 85),
    ProphetVerseReference(surah: 11, ayah: 86),
    ProphetVerseReference(surah: 11, ayah: 87),
    ProphetVerseReference(surah: 11, ayah: 94),
    ProphetVerseReference(surah: 11, ayah: 95),
  ],
  'musa': const <ProphetVerseReference>[
    ProphetVerseReference(surah: 20, ayah: 25),
    ProphetVerseReference(surah: 20, ayah: 35),
    ProphetVerseReference(surah: 26, ayah: 29),
    ProphetVerseReference(surah: 26, ayah: 33),
    ProphetVerseReference(surah: 28, ayah: 7),
    ProphetVerseReference(surah: 28, ayah: 13),
    ProphetVerseReference(surah: 28, ayah: 30),
    ProphetVerseReference(surah: 28, ayah: 32),
  ],
};
