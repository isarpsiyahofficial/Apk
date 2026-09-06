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

/// Fifth T0194 source-reviewed batch.
///
/// Claims remain bounded by the pinned Quran source. No calendar birth/death
/// dates, modern exact geography, or later historical reconstruction is
/// promoted into Quran-backed biography fields.
final t0194ProphetBiographySupplements5 =
    <String, Map<ProphetBiographySectionKey, ProphetBiographyField>>{
  'isa': <ProphetBiographySectionKey, ProphetBiographyField>{
    ProphetBiographySectionKey.community: _quranField(
      tr: 'Kur’an, Îsâ’nın İsrâiloğulları’na elçi olarak gönderildiğini bildirir.',
      en: 'The Quran states that Jesus was sent as a messenger to the Children of Israel.',
      ar: 'يذكر القرآن أن عيسى أُرسل رسولًا إلى بني إسرائيل.',
      stableId: 'isa-q3-49-community',
      locator: 'Quran 3:49',
    ),
    ProphetBiographySectionKey.birth: _quranField(
      tr: 'Kur’an, Meryem’e Meryem oğlu Mesîh Îsâ’nın müjdelendiğini ve Allah’ın dilediğini yaratacağını bildirir; doğum için kesin bir takvim tarihi vermez.',
      en: 'The Quran records Mary receiving the good news of the Messiah Jesus son of Mary and states that Allah creates what He wills; it gives no exact calendar date for the birth.',
      ar: 'يذكر القرآن بشارة مريم بالمسيح عيسى ابن مريم وأن الله يخلق ما يشاء، من غير تحديد تاريخ زمني دقيق للميلاد.',
      stableId: 'isa-q3-45-47',
      locator: 'Quran 3:45-47',
    ),
    ProphetBiographySectionKey.childhoodYouth: _quranField(
      tr: 'Kur’an, Îsâ’nın beşikte insanlarla konuşacağını bildirir; Meryem sûresinde de beşikte konuştuğu anlatılır.',
      en: 'The Quran states that Jesus would speak to people in the cradle and recounts him speaking in the cradle in Surah Maryam.',
      ar: 'يذكر القرآن أن عيسى يكلم الناس في المهد، ويروي في سورة مريم كلامه وهو في المهد.',
      stableId: 'isa-q3-46-q19-29-33',
      locator: 'Quran 3:46; 19:29-33',
    ),
    ProphetBiographySectionKey.missionStart: _quranField(
      tr: 'Kur’an, Îsâ’yı İsrâiloğulları’na gönderilmiş bir elçi olarak tanımlar ve rabbinden bir delille geldiğini bildirir.',
      en: 'The Quran identifies Jesus as a messenger sent to the Children of Israel and records him coming with a sign from his Lord.',
      ar: 'يصف القرآن عيسى رسولًا إلى بني إسرائيل ويذكر أنه جاءهم بآية من ربه.',
      stableId: 'isa-q3-49-mission',
      locator: 'Quran 3:49',
    ),
    ProphetBiographySectionKey.mainMessage: _quranField(
      tr: 'Kur’an, Îsâ’nın Allah’ın hem kendi Rabbi hem de muhataplarının Rabbi olduğunu bildirerek yalnız O’na kulluğa çağırdığını aktarır.',
      en: 'The Quran records Jesus declaring Allah to be his Lord and their Lord and calling people to worship Him alone.',
      ar: 'ينقل القرآن قول عيسى إن الله ربه ورب قومه ودعوته إلى عبادته وحده.',
      stableId: 'isa-q3-50-51',
      locator: 'Quran 3:50-51',
    ),
    ProphetBiographySectionKey.communityResponse: _quranField(
      tr: 'Kur’an, Îsâ inkârı sezdiğinde havârilerin Allah yolunda yardımcı olacaklarını ve iman ettiklerini bildirdiklerini anlatır.',
      en: 'The Quran recounts that when Jesus sensed disbelief, the disciples declared that they would be helpers in Allah’s cause and affirmed their faith.',
      ar: 'يروي القرآن أنه لما أحس عيسى الكفر أعلن الحواريون أنهم أنصار لله وأقروا بإيمانهم.',
      stableId: 'isa-q3-52',
      locator: 'Quran 3:52',
    ),
    ProphetBiographySectionKey.keyEvents: _quranField(
      tr: 'Kur’an, Îsâ’nın öldürüldüğü ve çarmıha gerildiği iddiasını reddeder ve Allah’ın onu kendisine yükselttiğini bildirir.',
      en: 'The Quran rejects the claim that Jesus was killed and crucified and states that Allah raised him to Himself.',
      ar: 'يرفض القرآن دعوى قتل عيسى وصلبه، ويذكر أن الله رفعه إليه.',
      stableId: 'isa-q4-157-158',
      locator: 'Quran 4:157-158',
    ),
    ProphetBiographySectionKey.miracles: _quranField(
      tr: 'Kur’an, Îsâ’nın kuş biçimindeki bir şekle üflemesi, doğuştan kör ve alaca hastalığı bulunan kimseleri iyileştirmesi ve ölüleri diriltmesi gibi mûcizeleri özellikle Allah’ın iznine bağlı olarak aktarır.',
      en: 'The Quran recounts signs associated with Jesus—including breathing into a bird-shaped form, healing the blind and leprous, and raising the dead—explicitly as occurring by Allah’s permission.',
      ar: 'يذكر القرآن من آيات عيسى النفخ في هيئة الطير وشفاء الأكمه والأبرص وإحياء الموتى، ويؤكد أن ذلك كله بإذن الله.',
      stableId: 'isa-q3-49-miracles',
      locator: 'Quran 3:49',
    ),
    ProphetBiographySectionKey.scriptureScrolls: _quranField(
      tr: 'Kur’an, Îsâ’ya İncil’in verildiğini ve onun kendinden önceki Tevrat’ı doğrulayıcı olduğunu bildirir.',
      en: 'The Quran states that Jesus was given the Gospel, confirming the Torah that came before him.',
      ar: 'يذكر القرآن أن عيسى أوتي الإنجيل مصدقًا لما بين يديه من التوراة.',
      stableId: 'isa-q5-46',
      locator: 'Quran 5:46',
    ),
    ProphetBiographySectionKey.dua: _quranField(
      tr: 'Kur’an, Îsâ’nın Allah’tan gökten bir sofra indirmesini, bunun bir işaret olmasını ve rızık vermesini istediği duayı kaydeder.',
      en: 'The Quran records Jesus asking Allah to send down a table from heaven as a sign and to provide sustenance.',
      ar: 'يسجل القرآن دعاء عيسى أن ينزل الله مائدة من السماء تكون آية وأن يرزقهم.',
      stableId: 'isa-q5-114',
      locator: 'Quran 5:114',
    ),
  },
  'muhammad': <ProphetBiographySectionKey, ProphetBiographyField>{
    ProphetBiographySectionKey.community: _quranField(
      tr: 'Kur’an, Muhammed’in risâletinin bütün insanlara yönelik olduğunu açıkça bildirir.',
      en: 'The Quran explicitly presents Muhammad’s mission as addressed to all people.',
      ar: 'يصرح القرآن بأن رسالة محمد موجهة إلى الناس جميعًا.',
      stableId: 'muhammad-q7-158',
      locator: 'Quran 7:158',
    ),
    ProphetBiographySectionKey.missionStart: _quranField(
      tr: 'Kur’an, Muhammed’i açıkça Allah’ın elçisi olarak niteler.',
      en: 'The Quran explicitly identifies Muhammad as the Messenger of Allah.',
      ar: 'يصف القرآن محمدًا صراحة بأنه رسول الله.',
      stableId: 'muhammad-q48-29',
      locator: 'Quran 48:29',
    ),
    ProphetBiographySectionKey.mainMessage: _quranField(
      tr: 'Kur’an, kendisinin uyarıda bulunması için vahyedildiğini ve ilâhın yalnız bir tek ilâh olduğunu bildirmesini emreder.',
      en: 'The Quran states that revelation was given to him so that he may warn, and it commands him to affirm that there is only one God.',
      ar: 'يذكر القرآن أن الوحي أُنزل إليه لينذر، ويأمره بالإقرار بأن الإله إله واحد.',
      stableId: 'muhammad-q6-19-message',
      locator: 'Quran 6:19',
    ),
    ProphetBiographySectionKey.keyEvents: _quranField(
      tr: 'Kur’an, inkâr edenlerin onu yurdundan çıkardığı sırada mağarada arkadaşıyla birlikte bulunduğunu ve Allah’ın ona yardım ettiğini anlatır.',
      en: 'The Quran recounts that when the disbelievers drove him out, he was in the cave with his companion and that Allah helped him.',
      ar: 'يروي القرآن أنه حين أخرجه الذين كفروا كان في الغار مع صاحبه وأن الله نصره.',
      stableId: 'muhammad-q9-40',
      locator: 'Quran 9:40',
    ),
    ProphetBiographySectionKey.scriptureScrolls: _quranField(
      tr: 'Kur’an, bu Kur’an’ın kendisine vahyedildiğini açıkça bildirir.',
      en: 'The Quran explicitly states that this Quran was revealed to him.',
      ar: 'يصرح القرآن بأن هذا القرآن أوحي إليه.',
      stableId: 'muhammad-q6-19-scripture',
      locator: 'Quran 6:19',
    ),
    ProphetBiographySectionKey.dua: _quranField(
      tr: 'Kur’an, Muhammed’e Rabbinden ilmini artırmasını istemesini emreder.',
      en: 'The Quran commands Muhammad to ask his Lord to increase him in knowledge.',
      ar: 'يأمر القرآن محمدًا أن يسأل ربه أن يزيده علمًا.',
      stableId: 'muhammad-q20-114',
      locator: 'Quran 20:114',
    ),
    ProphetBiographySectionKey.laterImpact: _quranField(
      tr: 'Kur’an, Muhammed’i Allah’ın elçisi ve peygamberlerin sonuncusu olarak niteler.',
      en: 'The Quran identifies Muhammad as the Messenger of Allah and the last of the prophets.',
      ar: 'يصف القرآن محمدًا بأنه رسول الله وخاتم النبيين.',
      stableId: 'muhammad-q33-40',
      locator: 'Quran 33:40',
    ),
  },
};

final t0194ProphetSupplementReferences5 = <String, List<ProphetVerseReference>>{
  'isa': const <ProphetVerseReference>[
    ProphetVerseReference(surah: 3, ayah: 45),
    ProphetVerseReference(surah: 3, ayah: 46),
    ProphetVerseReference(surah: 3, ayah: 47),
    ProphetVerseReference(surah: 3, ayah: 49),
    ProphetVerseReference(surah: 3, ayah: 50),
    ProphetVerseReference(surah: 3, ayah: 51),
    ProphetVerseReference(surah: 3, ayah: 52),
    ProphetVerseReference(surah: 4, ayah: 157),
    ProphetVerseReference(surah: 4, ayah: 158),
    ProphetVerseReference(surah: 5, ayah: 46),
    ProphetVerseReference(surah: 5, ayah: 114),
    ProphetVerseReference(surah: 19, ayah: 29),
    ProphetVerseReference(surah: 19, ayah: 33),
  ],
  'muhammad': const <ProphetVerseReference>[
    ProphetVerseReference(surah: 6, ayah: 19),
    ProphetVerseReference(surah: 7, ayah: 158),
    ProphetVerseReference(surah: 9, ayah: 40),
    ProphetVerseReference(surah: 20, ayah: 114),
    ProphetVerseReference(surah: 33, ayah: 40),
    ProphetVerseReference(surah: 48, ayah: 29),
  ],
};
