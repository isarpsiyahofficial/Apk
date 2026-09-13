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

/// Third T0194 source-reviewed batch. The claims below intentionally stop at
/// what the pinned Quran dataset states. Later historical identifications,
/// exact chronology, modern map pins, birth/death reports and extra-Quranic
/// narrative detail remain pending research in the base drafts.
final t0194ProphetBiographySupplements3 =
    <String, Map<ProphetBiographySectionKey, ProphetBiographyField>>{
  'ilyas': <ProphetBiographySectionKey, ProphetBiographyField>{
    ProphetBiographySectionKey.missionStart: _quranField(
      tr: 'Kur’an, İlyâs’ın gönderilmiş peygamberlerden olduğunu açıkça bildirir.',
      en: 'The Quran explicitly identifies Elijah as one of the messengers.',
      ar: 'يصرح القرآن بأن إلياس كان من المرسلين.',
      stableId: 'ilyas-q37-123',
      locator: 'Quran 37:123',
    ),
    ProphetBiographySectionKey.mainMessage: _quranField(
      tr: 'İlyâs kavmini Allah’a karşı sorumluluk bilincine çağırmış; Ba‘l’e yönelmek yerine kendilerinin ve önceki atalarının Rabbi olan Allah’a kulluğu hatırlatmıştır.',
      en: 'Elijah called his people to be mindful of Allah, challenging their devotion to Baal and reminding them of Allah, their Lord and the Lord of their forefathers.',
      ar: 'دعا إلياس قومه إلى تقوى الله، وأنكر توجههم إلى بعل، وذكّرهم بالله ربهم ورب آبائهم الأولين.',
      stableId: 'ilyas-q37-124-126',
      locator: 'Quran 37:124-126',
    ),
    ProphetBiographySectionKey.communityResponse: _quranField(
      tr: 'Kur’an, kavminin İlyâs’ı yalanladığını; Allah’ın ihlâslı kullarının ise bu hükmün dışında tutulduğunu bildirir.',
      en: 'The Quran states that his people denied Elijah, while Allah’s sincere servants are excepted from the stated consequence.',
      ar: 'يذكر القرآن أن قوم إلياس كذبوه، مع استثناء عباد الله المخلصين من العاقبة المذكورة.',
      stableId: 'ilyas-q37-127-128',
      locator: 'Quran 37:127-128',
    ),
    ProphetBiographySectionKey.laterImpact: _quranField(
      tr: 'Kur’an, İlyâs için sonraki nesiller arasında güzel bir anılış bırakıldığını ve onun mümin kullardan olduğunu bildirir.',
      en: 'The Quran states that a favorable remembrance was left for Elijah among later generations and describes him as one of the believing servants.',
      ar: 'يذكر القرآن أنه أبقى لإلياس ذكرًا حسنًا في الآخرين، وأنه كان من عباد الله المؤمنين.',
      stableId: 'ilyas-q37-129-132',
      locator: 'Quran 37:129-132',
    ),
  },
  'alyasa': <ProphetBiographySectionKey, ProphetBiographyField>{
    ProphetBiographySectionKey.keyEvents: _quranField(
      tr: 'Kur’an, Elyesa‘ı İsmâil, Yûnus ve Lût ile birlikte anar ve hepsinin âlemlere üstün kılındığını bildirir.',
      en: 'The Quran names Elisha together with Ishmael, Jonah, and Lot, stating that all of them were favored above the worlds.',
      ar: 'يذكر القرآن اليسع مع إسماعيل ويونس ولوط، ويبين أن الله فضلهم على العالمين.',
      stableId: 'alyasa-q6-86',
      locator: 'Quran 6:86',
    ),
    ProphetBiographySectionKey.laterImpact: _quranField(
      tr: 'Kur’an, Elyesa‘ın anılmasını emreder ve onu hayırlı kimseler arasında sayar; bunun ötesinde ayrıntılı hayat anlatısı vermez.',
      en: 'The Quran commands that Elisha be remembered and counts him among the excellent, without providing a detailed life narrative there.',
      ar: 'يأمر القرآن بذكر اليسع ويعده من الأخيار، من غير أن يورد في هذا الموضع سيرة تفصيلية له.',
      stableId: 'alyasa-q38-48',
      locator: 'Quran 38:48',
    ),
  },
  'yunus': <ProphetBiographySectionKey, ProphetBiographyField>{
    ProphetBiographySectionKey.community: _quranField(
      tr: 'Kur’an, topluluğu özel bir şehir adı vermeden “Yûnus’un kavmi” olarak anar ve onların iman ettiğini bildirir.',
      en: 'The Quran refers to the community without naming a city, calling them “the people of Jonah” and stating that they believed.',
      ar: 'يذكر القرآن الجماعة من غير تسمية مدينة بعينها بوصفهم «قوم يونس»، ويخبر أنهم آمنوا.',
      stableId: 'yunus-q10-98',
      locator: 'Quran 10:98',
    ),
    ProphetBiographySectionKey.missionStart: _quranField(
      tr: 'Kur’an, Yûnus’un gönderilmiş peygamberlerden olduğunu açıkça bildirir.',
      en: 'The Quran explicitly identifies Jonah as one of the messengers.',
      ar: 'يصرح القرآن بأن يونس كان من المرسلين.',
      stableId: 'yunus-q37-139',
      locator: 'Quran 37:139',
    ),
    ProphetBiographySectionKey.communityResponse: _quranField(
      tr: 'Kur’an, Yûnus’un kavminin iman ettiğini; bunun üzerine dünya hayatındaki azabın onlardan kaldırıldığını ve bir süre daha yaşatıldıklarını bildirir.',
      en: 'The Quran states that Jonah’s people believed, after which the worldly punishment was removed from them and they were allowed to enjoy life for a time.',
      ar: 'يذكر القرآن أن قوم يونس آمنوا، فكُشف عنهم عذاب الخزي في الحياة الدنيا ومُتعوا إلى حين.',
      stableId: 'yunus-q10-98-response',
      locator: 'Quran 10:98',
    ),
    ProphetBiographySectionKey.keyEvents: _quranField(
      tr: 'Kur’an, Yûnus’un yüklü bir gemiye gidişini, kuraya katılmasını, büyük bir balık tarafından yutulmasını, ardından kıyıya çıkarılmasını ve yeniden büyük bir topluluğa gönderilmesini anlatır.',
      en: 'The Quran recounts Jonah going to a laden ship, taking part in a drawing of lots, being swallowed by a great fish, later being cast onto the shore, and being sent to a large community.',
      ar: 'يروي القرآن ذهاب يونس إلى الفلك المشحون، ومساهمته في القرعة، وابتلاع الحوت له، ثم طرحه بالعراء وإرساله إلى جماعة كبيرة.',
      stableId: 'yunus-q37-140-148',
      locator: 'Quran 37:140-148',
    ),
    ProphetBiographySectionKey.dua: _quranField(
      tr: 'Kur’an, Yûnus’un karanlıklar içinde Allah’ı tenzih ederek O’ndan başka ilâh olmadığını ikrar ettiğini ve kendi yanlışını kabul ettiğini; duasının kabul edilip sıkıntıdan kurtarıldığını bildirir.',
      en: 'The Quran records Jonah, in the darknesses, declaring Allah’s transcendence and that there is no deity but Him, acknowledging his own wrong; it then states that his prayer was answered and he was delivered from distress.',
      ar: 'يسجل القرآن دعاء يونس في الظلمات بتنزيه الله والإقرار بأنه لا إله إلا هو واعترافه بظلمه لنفسه، ثم يذكر استجابة دعائه ونجاته من الغم.',
      stableId: 'yunus-q21-87-88',
      locator: 'Quran 21:87-88',
    ),
  },
};

final t0194ProphetSupplementReferences3 = <String, List<ProphetVerseReference>>{
  'ilyas': const <ProphetVerseReference>[
    ProphetVerseReference(surah: 37, ayah: 123),
    ProphetVerseReference(surah: 37, ayah: 124),
    ProphetVerseReference(surah: 37, ayah: 126),
    ProphetVerseReference(surah: 37, ayah: 127),
    ProphetVerseReference(surah: 37, ayah: 128),
    ProphetVerseReference(surah: 37, ayah: 129),
    ProphetVerseReference(surah: 37, ayah: 132),
  ],
  'alyasa': const <ProphetVerseReference>[
    ProphetVerseReference(surah: 6, ayah: 86),
    ProphetVerseReference(surah: 38, ayah: 48),
  ],
  'yunus': const <ProphetVerseReference>[
    ProphetVerseReference(surah: 10, ayah: 98),
    ProphetVerseReference(surah: 21, ayah: 87),
    ProphetVerseReference(surah: 21, ayah: 88),
    ProphetVerseReference(surah: 37, ayah: 139),
    ProphetVerseReference(surah: 37, ayah: 140),
    ProphetVerseReference(surah: 37, ayah: 148),
  ],
};
