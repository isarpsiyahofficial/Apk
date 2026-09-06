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

/// Second T0194 source-reviewed batch. Claims remain limited to what the
/// pinned Quran dataset directly supports; unsupported chronology, coordinates
/// and later narrative detail stay in the base draft as pending research.
final t0194ProphetBiographySupplements2 =
    <String, Map<ProphetBiographySectionKey, ProphetBiographyField>>{
  'harun': <ProphetBiographySectionKey, ProphetBiographyField>{
    ProphetBiographySectionKey.missionStart: _quranField(
      tr: 'Kur’an, Mûsâ’nın kardeşi Hârûn’un Allah’ın rahmetiyle kendisine destek olarak verildiğini ve Hârûn’un bir peygamber olduğunu bildirir.',
      en: 'The Quran states that Aaron, the brother of Moses, was granted to him as a mercy and identifies Aaron as a prophet.',
      ar: 'يذكر القرآن أن هارون أخا موسى وُهب له رحمةً من الله، ويصف هارون بأنه نبي.',
      stableId: 'harun-q19-53',
      locator: 'Quran 19:53',
    ),
    ProphetBiographySectionKey.keyEvents: _quranField(
      tr: 'Buzağı fitnesi sırasında Hârûn, kavmini daha önce uyarmış; Rablerinin Rahmân olduğunu söyleyerek kendisine uymalarını ve emrine itaat etmelerini istemiştir.',
      en: 'During the calf episode, Aaron had already warned his people, saying that their Lord was the Most Merciful and calling them to follow him and obey his command.',
      ar: 'في فتنة العجل كان هارون قد أنذر قومه من قبل، وذكرهم بأن ربهم الرحمن ودعاهم إلى اتباعه وطاعة أمره.',
      stableId: 'harun-q20-90',
      locator: 'Quran 20:90-94',
    ),
    ProphetBiographySectionKey.laterImpact: _quranField(
      tr: 'Kur’an, Mûsâ ve Hârûn’a nimet verildiğini, onların ve kavimlerinin büyük sıkıntıdan kurtarıldığını, kendilerine yardım edildiğini ve doğru yola iletildiklerini birlikte anar.',
      en: 'The Quran jointly recounts favor upon Moses and Aaron, their deliverance with their people from great distress, divine help, and guidance to the straight path.',
      ar: 'يذكر القرآن معًا إنعام الله على موسى وهارون، ونجاتهما وقومهما من الكرب العظيم، ونصرهما وهدايتهما إلى الصراط المستقيم.',
      stableId: 'harun-q37-114-122',
      locator: 'Quran 37:114-122',
    ),
  },
  'dawud': <ProphetBiographySectionKey, ProphetBiographyField>{
    ProphetBiographySectionKey.missionStart: _quranField(
      tr: 'Kur’an, Dâvûd’un yeryüzünde halife kılındığını ve insanlar arasında hak ile hükmetmesinin emredildiğini bildirir.',
      en: 'The Quran states that David was appointed as a successor on earth and commanded to judge between people with truth.',
      ar: 'يذكر القرآن أن داود جُعل خليفةً في الأرض وأُمر أن يحكم بين الناس بالحق.',
      stableId: 'dawud-q38-26',
      locator: 'Quran 38:26',
    ),
    ProphetBiographySectionKey.miracles: _quranField(
      tr: 'Kur’an, dağların ve toplanan kuşların Dâvûd ile birlikte tesbih etmek üzere boyun eğdirildiğini bildirir.',
      en: 'The Quran states that the mountains and gathered birds were subjected to glorify Allah together with David.',
      ar: 'يذكر القرآن تسخير الجبال والطير المجموعة لتسبح مع داود.',
      stableId: 'dawud-q38-18-19',
      locator: 'Quran 38:18-19',
    ),
    ProphetBiographySectionKey.scriptureScrolls: _quranField(
      tr: 'Kur’an, Dâvûd’a Zebur’un verildiğini açıkça bildirir.',
      en: 'The Quran explicitly states that David was given the Psalms (Zabur).',
      ar: 'يصرح القرآن بأن داود أُوتي الزبور.',
      stableId: 'dawud-q4-163',
      locator: 'Quran 4:163',
    ),
    ProphetBiographySectionKey.dua: _quranField(
      tr: 'Kur’an, Dâvûd’un imtihan edildiğini anlayınca Rabbinden bağışlanma dilediğini, secdeye kapanıp Allah’a yöneldiğini bildirir.',
      en: 'The Quran recounts David realizing that he had been tested, seeking his Lord’s forgiveness, falling down in prostration, and turning back to Allah.',
      ar: 'يروي القرآن أن داود أدرك أنه فُتن فاستغفر ربه وخر راكعًا وأناب إلى الله.',
      stableId: 'dawud-q38-24',
      locator: 'Quran 38:24-25',
    ),
  },
  'sulayman': <ProphetBiographySectionKey, ProphetBiographyField>{
    ProphetBiographySectionKey.keyEvents: _quranField(
      tr: 'Kur’an, Dâvûd ve Süleyman’a ilim verildiğini, Süleyman’ın Dâvûd’a vâris olduğunu ve kuşların dilinin kendisine öğretildiğini anlatır.',
      en: 'The Quran recounts David and Solomon being given knowledge, Solomon inheriting from David, and Solomon being taught the speech of birds.',
      ar: 'يروي القرآن أن داود وسليمان أُوتيا علمًا، وأن سليمان ورث داود وعُلّم منطق الطير.',
      stableId: 'sulayman-q27-15-16',
      locator: 'Quran 27:15-16',
    ),
    ProphetBiographySectionKey.miracles: _quranField(
      tr: 'Kur’an, rüzgârın Süleyman’ın emrine verildiğini ve cinlerden bir grubun Rabbi’nin izniyle onun için çalıştığını bildirir.',
      en: 'The Quran states that the wind was subjected to Solomon and that a group of jinn worked for him by his Lord’s permission.',
      ar: 'يذكر القرآن تسخير الريح لسليمان وعمل فريق من الجن له بإذن ربه.',
      stableId: 'sulayman-q34-12',
      locator: 'Quran 34:12-13',
    ),
    ProphetBiographySectionKey.dua: _quranField(
      tr: 'Süleyman, kendisine ve anne-babasına verilen nimetlere şükretmek, Allah’ın razı olacağı salih amel işlemek ve rahmetle salih kullar arasına katılmak için dua eder.',
      en: 'Solomon asks to be enabled to give thanks for the favors granted to him and his parents, to do righteous deeds pleasing to Allah, and to be admitted by mercy among the righteous servants.',
      ar: 'يدعو سليمان أن يُوزع شكر نعمة الله عليه وعلى والديه، وأن يعمل صالحًا يرضاه الله، وأن يُدخله برحمته في عباده الصالحين.',
      stableId: 'sulayman-q27-19',
      locator: 'Quran 27:19',
    ),
  },
};

final t0194ProphetSupplementReferences2 = <String, List<ProphetVerseReference>>{
  'harun': const <ProphetVerseReference>[
    ProphetVerseReference(surah: 19, ayah: 53),
    ProphetVerseReference(surah: 20, ayah: 90),
    ProphetVerseReference(surah: 20, ayah: 94),
    ProphetVerseReference(surah: 37, ayah: 114),
    ProphetVerseReference(surah: 37, ayah: 122),
  ],
  'dawud': const <ProphetVerseReference>[
    ProphetVerseReference(surah: 4, ayah: 163),
    ProphetVerseReference(surah: 38, ayah: 18),
    ProphetVerseReference(surah: 38, ayah: 19),
    ProphetVerseReference(surah: 38, ayah: 24),
    ProphetVerseReference(surah: 38, ayah: 25),
    ProphetVerseReference(surah: 38, ayah: 26),
  ],
  'sulayman': const <ProphetVerseReference>[
    ProphetVerseReference(surah: 27, ayah: 15),
    ProphetVerseReference(surah: 27, ayah: 16),
    ProphetVerseReference(surah: 27, ayah: 19),
    ProphetVerseReference(surah: 34, ayah: 12),
    ProphetVerseReference(surah: 34, ayah: 13),
  ],
};
