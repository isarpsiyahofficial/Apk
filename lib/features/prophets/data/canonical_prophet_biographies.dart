import '../../../core/content/content_governance.dart';
import 'canonical_prophets.dart';
import 'prophet_content.dart';

enum ProphetBiographySectionKey {
  community,
  geography,
  period,
  birth,
  childhoodYouth,
  missionStart,
  mainMessage,
  communityResponse,
  keyEvents,
  miracles,
  scriptureScrolls,
  dua,
  death,
  laterImpact,
}

enum ProphetBiographyFieldStatus {
  sourceBacked,
  unknownPendingResearch,
}

class ProphetBiographyField {
  const ProphetBiographyField({
    required this.text,
    required this.status,
    required this.sources,
  });

  final LocalizedReligiousText text;
  final ProphetBiographyFieldStatus status;
  final List<SourceReference> sources;

  bool get isValid {
    if (!text.isComplete) return false;
    switch (status) {
      case ProphetBiographyFieldStatus.sourceBacked:
        return sources.isNotEmpty &&
            sources.every(
              (source) =>
                  source.id.trim().isNotEmpty &&
                  source.title.trim().isNotEmpty &&
                  source.licenseId.trim().isNotEmpty &&
                  source.sourceClass != ReligiousSourceClass.unknown,
            );
      case ProphetBiographyFieldStatus.unknownPendingResearch:
        return sources.isEmpty;
    }
  }
}

class CanonicalProphetBiographyDraft {
  const CanonicalProphetBiographyDraft({
    required this.identity,
    required this.quranReferences,
    required this.sections,
  });

  final CanonicalProphetIdentity identity;
  final List<ProphetVerseReference> quranReferences;
  final Map<ProphetBiographySectionKey, ProphetBiographyField> sections;

  bool get isStructurallyComplete {
    if (!identity.isValid || quranReferences.isEmpty) return false;
    if (quranReferences.any((reference) => !reference.isValid)) return false;
    if (quranReferences.map((e) => e.stableId).toSet().length !=
        quranReferences.length) {
      return false;
    }
    if (sections.length != ProphetBiographySectionKey.values.length ||
        sections.keys.toSet().length != ProphetBiographySectionKey.values.length ||
        sections.values.any((field) => !field.isValid)) {
      return false;
    }
    return ProphetBiographySectionKey.values.every(sections.containsKey);
  }

  /// T0194 is an editorial/research dataset stage. Unknown fields are explicit
  /// and prevent an incomplete biography from being mistaken for reviewed
  /// production content.
  bool get hasPendingResearch => sections.values.any(
        (field) =>
            field.status == ProphetBiographyFieldStatus.unknownPendingResearch,
      );
}

const prophetQuranDatasetSource = SourceReference(
  id: 'tanzil-uthmani-v1.1',
  title: 'Tanzil Project — Uthmani Quran Text v1.1',
  sourceClass: ReligiousSourceClass.quran,
  licenseId: 'CC-BY-3.0',
);

const prophetUniversalMessageSource = SourceReference(
  id: 'tanzil-uthmani-v1.1-q21-25',
  title: 'Tanzil Project — Uthmani Quran Text v1.1',
  sourceClass: ReligiousSourceClass.quran,
  licenseId: 'CC-BY-3.0',
  locator: 'Quran 21:25',
);

const _unknownField = ProphetBiographyField(
  text: LocalizedReligiousText(
    tr: 'Bu alan için güvenilir ayrıntı henüz doğrulanmadı; kesin bilgi uydurulmayacaktır.',
    en: 'Reliable detail for this field has not yet been verified; no definite claim will be invented.',
    ar: 'لم تُتحقق بعدُ تفاصيل موثوقة لهذا الحقل؛ ولن تُختلق معلومة قطعية.',
  ),
  status: ProphetBiographyFieldStatus.unknownPendingResearch,
  sources: <SourceReference>[],
);

const _universalMainMessageField = ProphetBiographyField(
  text: LocalizedReligiousText(
    tr: 'Kur’an’ın peygamberlik için verdiği ortak ana mesaj, yalnız Allah’a kulluk edilmesi ve O’ndan başka ilâh olmadığıdır.',
    en: 'The Quran presents the shared core message of prophethood as worshipping Allah alone, with no deity besides Him.',
    ar: 'يعرض القرآن الرسالة الجامعة للنبوة بأنها عبادة الله وحده، فلا إله إلا هو.',
  ),
  status: ProphetBiographyFieldStatus.sourceBacked,
  sources: <SourceReference>[prophetUniversalMessageSource],
);

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

Map<ProphetBiographySectionKey, ProphetBiographyField> _researchSections() =>
    <ProphetBiographySectionKey, ProphetBiographyField>{
      for (final key in ProphetBiographySectionKey.values) key: _unknownField,
      ProphetBiographySectionKey.mainMessage: _universalMainMessageField,
    };

Map<ProphetBiographySectionKey, ProphetBiographyField> _sectionsFor(
  String canonicalId,
) {
  final sections = _researchSections();

  switch (canonicalId) {
    case 'adam':
      sections[ProphetBiographySectionKey.keyEvents] = _quranField(
        tr: 'Kur’an, Âdem’e isimlerin öğretilmesini, cennetteki imtihanı ve ardından yeryüzüne iniş bağlamını birlikte anlatır.',
        en: 'The Quran recounts Adam being taught the names, the garden trial, and the subsequent descent to earth within the same narrative.',
        ar: 'يروي القرآن تعليم آدم الأسماء، وابتلاء الجنة، ثم سياق الهبوط إلى الأرض ضمن القصة نفسها.',
        stableId: 'adam-q2-31-38',
        locator: 'Quran 2:31-38',
      );
      sections[ProphetBiographySectionKey.dua] = _quranField(
        tr: 'Kur’an, Âdem ve eşinin hatalarını kabul edip Allah’tan bağışlanma ve merhamet diledikleri duayı kaydeder.',
        en: 'The Quran records Adam and his spouse acknowledging their wrong and asking Allah for forgiveness and mercy.',
        ar: 'يسجل القرآن دعاء آدم وزوجه باعترافهما بالخطأ وطلبهما المغفرة والرحمة من الله.',
        stableId: 'adam-q7-23',
        locator: 'Quran 7:23',
      );
      break;
    case 'idris':
      sections[ProphetBiographySectionKey.keyEvents] = _quranField(
        tr: 'Kur’an, İdris’i özü sözü doğru bir kimse ve peygamber olarak anar; yüksek bir makama yükseltildiğini bildirir.',
        en: 'The Quran describes Idris as a man of truth and a prophet, and states that he was raised to a high station.',
        ar: 'يصف القرآن إدريس بأنه صدّيق ونبي، ويذكر أنه رُفع مكانًا عليًا.',
        stableId: 'idris-q19-56-57',
        locator: 'Quran 19:56-57',
      );
      break;
    case 'nuh':
      sections[ProphetBiographySectionKey.community] = _quranField(
        tr: 'Kur’an, Nûh’un kendi kavmine uyarıcı olarak gönderildiğini açıkça bildirir.',
        en: 'The Quran explicitly states that Noah was sent as a warner to his own people.',
        ar: 'يصرح القرآن بأن نوحًا أُرسل إلى قومه منذرًا لهم.',
        stableId: 'nuh-q71-1',
        locator: 'Quran 71:1',
      );
      sections[ProphetBiographySectionKey.missionStart] = _quranField(
        tr: 'Nûh’un tebliği, kavmini uyarması; Allah’a kulluk, takvâ ve peygambere itaat çağrısıyla anlatılır.',
        en: 'Noah’s mission is presented as warning his people and calling them to worship Allah, be mindful of Him, and obey the messenger.',
        ar: 'تُعرض دعوة نوح بإنذار قومه ودعوتهم إلى عبادة الله وتقواه وطاعة الرسول.',
        stableId: 'nuh-q71-1-4',
        locator: 'Quran 71:1-4',
      );
      sections[ProphetBiographySectionKey.communityResponse] = _quranField(
        tr: 'Nûh, Kur’an’da kavmini gece gündüz çağırdığını fakat onların yüz çevirip çağrıdan kaçındığını anlatır.',
        en: 'In the Quran, Noah says that he called his people night and day, while they repeatedly turned away from his call.',
        ar: 'يذكر نوح في القرآن أنه دعا قومه ليلًا ونهارًا، لكنهم أعرضوا عن دعوته مرارًا.',
        stableId: 'nuh-q71-5-7',
        locator: 'Quran 71:5-7',
      );
      sections[ProphetBiographySectionKey.keyEvents] = _quranField(
        tr: 'Kur’an, geminin yapılışını, tufanın başlamasını, iman edenlerin gemiye alınmasını ve geminin güvenle durmasını anlatır.',
        en: 'The Quran recounts the building of the ark, the onset of the flood, the boarding of the believers, and the ark coming safely to rest.',
        ar: 'يروي القرآن صنع السفينة، وبدء الطوفان، وركوب المؤمنين، واستقرار السفينة بأمان.',
        stableId: 'nuh-q11-36-44',
        locator: 'Quran 11:36-44',
      );
      sections[ProphetBiographySectionKey.dua] = _quranField(
        tr: 'Nûh sûresinin sonunda Nûh’un kendisi, anne-babası ve müminler için bağışlanma dilediği dua yer alır.',
        en: 'At the end of Surah Noah, the Quran records Noah asking forgiveness for himself, his parents, and the believers.',
        ar: 'في ختام سورة نوح يذكر القرآن دعاء نوح بالمغفرة لنفسه ولوالديه وللمؤمنين.',
        stableId: 'nuh-q71-26-28',
        locator: 'Quran 71:26-28',
      );
      break;
    case 'hud':
      sections[ProphetBiographySectionKey.community] = _quranField(
        tr: 'Kur’an, Hûd’un Âd kavmine gönderildiğini açıkça belirtir.',
        en: 'The Quran explicitly identifies Hud as being sent to the people of ‘Ad.',
        ar: 'يذكر القرآن صراحة أن هودًا أُرسل إلى قوم عاد.',
        stableId: 'hud-q11-50',
        locator: 'Quran 11:50',
      );
      sections[ProphetBiographySectionKey.missionStart] = _quranField(
        tr: 'Hûd’un çağrısı Allah’a kulluk etmeyi, bağışlanma dilemeyi ve O’na yönelmeyi içerir.',
        en: 'Hud’s call includes worshipping Allah, seeking His forgiveness, and turning back to Him.',
        ar: 'تتضمن دعوة هود عبادة الله والاستغفار له والتوبة إليه.',
        stableId: 'hud-q11-50-52',
        locator: 'Quran 11:50-52',
      );
      sections[ProphetBiographySectionKey.communityResponse] = _quranField(
        tr: 'Âd’ın önde gelen itirazı, Hûd’un açık bir delil getirmediğini söylemeleri ve ilâhlarını terk etmeyi reddetmeleridir.',
        en: 'The people of ‘Ad objected that Hud had not brought what they considered clear proof and refused to abandon their deities.',
        ar: 'اعترض قوم عاد بأن هودًا لم يأتهم بما عدّوه بينة، ورفضوا ترك آلهتهم.',
        stableId: 'hud-q11-53-55',
        locator: 'Quran 11:53-55',
      );
      sections[ProphetBiographySectionKey.keyEvents] = _quranField(
        tr: 'Kur’an, ilâhî hüküm geldiğinde Hûd ve beraberindeki iman edenlerin kurtarıldığını bildirir.',
        en: 'The Quran states that when the divine judgment came, Hud and the believers with him were saved.',
        ar: 'يذكر القرآن أنه عند مجيء أمر الله نُجّي هود والذين آمنوا معه.',
        stableId: 'hud-q11-58-60',
        locator: 'Quran 11:58-60',
      );
      break;
    case 'salih':
      sections[ProphetBiographySectionKey.community] = _quranField(
        tr: 'Kur’an, Sâlih’in Semûd kavmine gönderildiğini açıkça bildirir.',
        en: 'The Quran explicitly states that Salih was sent to the people of Thamud.',
        ar: 'يصرح القرآن بأن صالحًا أُرسل إلى قوم ثمود.',
        stableId: 'salih-q11-61',
        locator: 'Quran 11:61',
      );
      sections[ProphetBiographySectionKey.missionStart] = _quranField(
        tr: 'Sâlih, kavmini yalnız Allah’a kulluğa, O’ndan bağışlanma dilemeye ve O’na yönelmeye çağırır.',
        en: 'Salih calls his people to worship Allah alone, seek His forgiveness, and turn back to Him.',
        ar: 'يدعو صالح قومه إلى عبادة الله وحده والاستغفار له والتوبة إليه.',
        stableId: 'salih-q11-61',
        locator: 'Quran 11:61',
      );
      sections[ProphetBiographySectionKey.communityResponse] = _quranField(
        tr: 'Kavmi, daha önce kendisinden ümitli olduklarını söyleyerek atalarının taptıklarından vazgeçme çağrısına şüpheyle karşılık verir.',
        en: 'His people respond with doubt, saying they had previously expected much from him and questioning his call to leave what their ancestors worshipped.',
        ar: 'قابله قومه بالشك، وقالوا إنهم كانوا يرجون فيه خيرًا من قبل، واستنكروا دعوته إلى ترك ما كان يعبد آباؤهم.',
        stableId: 'salih-q11-62',
        locator: 'Quran 11:62',
      );
      sections[ProphetBiographySectionKey.miracles] = _quranField(
        tr: 'Kur’an, Allah’ın devesini Sâlih’in kavmine açık bir işaret olarak sunar ve ona zarar vermemelerini emreder.',
        en: 'The Quran presents the she-camel of Allah as a clear sign for Salih’s people and commands them not to harm her.',
        ar: 'يقدم القرآن ناقة الله آيةً لقوم صالح، ويأمرهم ألا يمسوها بسوء.',
        stableId: 'salih-q11-64',
        locator: 'Quran 11:64',
      );
      sections[ProphetBiographySectionKey.keyEvents] = _quranField(
        tr: 'Kur’an, devenin öldürülmesinin ardından verilen süreyi, sonra Sâlih ile iman edenlerin kurtuluşunu ve inkârcı topluluğun sonunu anlatır.',
        en: 'The Quran recounts the period granted after the she-camel was killed, followed by the rescue of Salih and the believers and the end of the rejecting community.',
        ar: 'يروي القرآن المهلة بعد عقر الناقة، ثم نجاة صالح والذين آمنوا معه، ونهاية القوم المكذبين.',
        stableId: 'salih-q11-65-68',
        locator: 'Quran 11:65-68',
      );
      break;
    case 'ibrahim':
      sections[ProphetBiographySectionKey.community] = _quranField(
        tr: 'Kur’an, İbrâhim’in babasına ve toplumuna taptıkları heykelleri sorgulayarak hitap ettiğini anlatır.',
        en: 'The Quran recounts Abraham addressing his father and people by questioning the statues to which they were devoted.',
        ar: 'يروي القرآن مخاطبة إبراهيم لأبيه وقومه وسؤاله لهم عن التماثيل التي كانوا يعكفون عليها.',
        stableId: 'ibrahim-q21-52-54',
        locator: 'Quran 21:52-54',
      );
      sections[ProphetBiographySectionKey.missionStart] = _quranField(
        tr: 'İbrâhim, göklerin ve yerin Rabbi’ni gerçek Rab olarak göstererek toplumunun putperest geleneğine karşı tevhid çağrısını açıkça ortaya koyar.',
        en: 'Abraham openly sets out a monotheistic call against his people’s inherited idol worship, identifying the Lord of the heavens and earth as the true Lord.',
        ar: 'يعلن إبراهيم دعوة التوحيد في مواجهة عبادة الأصنام الموروثة، ويقرر أن رب السماوات والأرض هو الرب الحق.',
        stableId: 'ibrahim-q21-55-57',
        locator: 'Quran 21:55-57',
      );
      sections[ProphetBiographySectionKey.communityResponse] = _quranField(
        tr: 'Kur’an, putların kırılmasından sonra toplumunun İbrâhim’i sorguladığını ve sonunda onun yakılmasını istediğini bildirir.',
        en: 'The Quran states that after the idols were broken, his people questioned Abraham and eventually called for him to be burned.',
        ar: 'يذكر القرآن أن قومه حاكموا إبراهيم بعد كسر الأصنام ثم دعوا إلى إحراقه.',
        stableId: 'ibrahim-q21-59-68',
        locator: 'Quran 21:59-68',
      );
      sections[ProphetBiographySectionKey.miracles] = _quranField(
        tr: 'Kur’an, ateşe İbrâhim için serin ve güvenli olması emrinin verildiğini bildirir.',
        en: 'The Quran states that the fire was commanded to become cool and safe for Abraham.',
        ar: 'يذكر القرآن أن النار أُمرت أن تكون بردًا وسلامًا على إبراهيم.',
        stableId: 'ibrahim-q21-69',
        locator: 'Quran 21:69',
      );
      sections[ProphetBiographySectionKey.keyEvents] = _quranField(
        tr: 'Kur’an, İbrâhim ile İsmâil’in Beyt’in temellerini yükseltmesini ve bu sırada Allah’a yönelmelerini anlatır.',
        en: 'The Quran recounts Abraham and Ishmael raising the foundations of the House while turning to Allah in prayer.',
        ar: 'يروي القرآن رفع إبراهيم وإسماعيل قواعد البيت وتوجههما إلى الله بالدعاء أثناء ذلك.',
        stableId: 'ibrahim-q2-125-129',
        locator: 'Quran 2:125-129',
      );
      sections[ProphetBiographySectionKey.dua] = _quranField(
        tr: 'Kur’an, İbrâhim’in güvenli bir belde, putperestlikten korunma, namazı sürdürme ve bağışlanma için yaptığı duaları kaydeder.',
        en: 'The Quran records Abraham praying for a secure land, protection from idolatry, steadfast prayer, and forgiveness.',
        ar: 'يسجل القرآن دعاء إبراهيم بالأمن، والبعد عن عبادة الأصنام، وإقامة الصلاة، والمغفرة.',
        stableId: 'ibrahim-q14-35-41',
        locator: 'Quran 14:35-41',
      );
      break;
    case 'lut':
      sections[ProphetBiographySectionKey.community] = _quranField(
        tr: 'Kur’an, Lût’un kendi kavmine hitap ederek onların açık bir ahlâkî sapmasını eleştirdiğini bildirir.',
        en: 'The Quran presents Lot addressing his own people and condemning a grave moral transgression among them.',
        ar: 'يعرض القرآن لوطًا مخاطبًا قومه ومنكرًا عليهم فاحشة ظاهرة.',
        stableId: 'lut-q7-80-81',
        locator: 'Quran 7:80-81',
      );
      sections[ProphetBiographySectionKey.missionStart] = _quranField(
        tr: 'Lût’un tebliğinde, toplumunun işlediği kötülükten vazgeçme çağrısı açıkça yer alır.',
        en: 'Lot’s preaching explicitly includes calling his people away from the wrongdoing described in the Quranic account.',
        ar: 'تتضمن دعوة لوط إنكار المنكر الذي وصفه القرآن ودعوة قومه إلى تركه.',
        stableId: 'lut-q7-80-81-call',
        locator: 'Quran 7:80-81',
      );
      sections[ProphetBiographySectionKey.communityResponse] = _quranField(
        tr: 'Kavminin cevabı, Lût ve beraberindekileri yerleşimlerinden çıkarmayı istemek olmuştur.',
        en: 'His people’s response was to call for Lot and his household to be expelled from their settlement.',
        ar: 'كان جواب قومه أن دعوا إلى إخراج لوط وأهله من قريتهم.',
        stableId: 'lut-q7-82',
        locator: 'Quran 7:82',
      );
      sections[ProphetBiographySectionKey.keyEvents] = _quranField(
        tr: 'Kur’an, melek elçilerin Lût’a gelişini, ailesinin kurtarılmasını ve inkârcı toplumun cezalandırılmasını anlatır; eşinin istisna edildiğini de açıkça belirtir.',
        en: 'The Quran recounts the angelic messengers arriving to Lot, the rescue of his household, and the punishment of the rejecting community, while explicitly excepting his wife.',
        ar: 'يروي القرآن مجيء الملائكة إلى لوط ونجاة أهله وعقوبة القوم المكذبين، مع استثناء امرأته صراحة.',
        stableId: 'lut-q11-77-83',
        locator: 'Quran 11:77-83',
      );
      break;
    case 'ismail':
      sections[ProphetBiographySectionKey.missionStart] = _quranField(
        tr: 'Kur’an, İsmâil’i sözünde duran, resul ve peygamber olarak anar.',
        en: 'The Quran describes Ishmael as true to his promise and as a messenger and prophet.',
        ar: 'يصف القرآن إسماعيل بأنه صادق الوعد ورسولًا نبيًا.',
        stableId: 'ismail-q19-54',
        locator: 'Quran 19:54',
      );
      sections[ProphetBiographySectionKey.community] = _quranField(
        tr: 'Kur’an, İsmâil’in ailesine namazı ve zekâtı emrettiğini bildirir; bunun ötesinde doğrulanmamış bir topluluk adı eklenmez.',
        en: 'The Quran states that Ishmael enjoined prayer and almsgiving upon his household; no unverified tribal or community label is added beyond that.',
        ar: 'يذكر القرآن أن إسماعيل كان يأمر أهله بالصلاة والزكاة، ولا يُضاف إلى ذلك اسم قوم غير موثق.',
        stableId: 'ismail-q19-55',
        locator: 'Quran 19:55',
      );
      sections[ProphetBiographySectionKey.keyEvents] = _quranField(
        tr: 'Kur’an, İsmâil’in İbrâhim ile birlikte Beyt’in temellerini yükselttiğini açıkça anlatır.',
        en: 'The Quran explicitly recounts Ishmael raising the foundations of the House together with Abraham.',
        ar: 'يصرح القرآن بأن إسماعيل شارك إبراهيم في رفع قواعد البيت.',
        stableId: 'ismail-q2-127',
        locator: 'Quran 2:127',
      );
      sections[ProphetBiographySectionKey.dua] = _quranField(
        tr: 'İbrâhim ve İsmâil, Beyt’in temellerini yükseltirken amellerinin kabulünü, teslimiyetlerini ve soylarından teslim olan bir ümmet çıkmasını Allah’tan birlikte diler.',
        en: 'While raising the foundations of the House, Abraham and Ishmael jointly ask Allah to accept their work, keep them submitted to Him, and bring forth a submitting community from their descendants.',
        ar: 'يدعو إبراهيم وإسماعيل عند رفع قواعد البيت بقبول العمل والثبات على الإسلام وأن يجعل من ذريتهما أمةً مسلمة له.',
        stableId: 'ismail-q2-127-129',
        locator: 'Quran 2:127-129',
      );
      break;
  }

  return sections;
}

List<ProphetVerseReference> _referencesFor(
  CanonicalProphetIdentity identity,
) {
  final references = <ProphetVerseReference>[identity.explicitNameReference];
  switch (identity.canonicalId) {
    case 'adam':
      references.addAll(const <ProphetVerseReference>[
        ProphetVerseReference(surah: 2, ayah: 31),
        ProphetVerseReference(surah: 2, ayah: 38),
        ProphetVerseReference(surah: 7, ayah: 23),
      ]);
      break;
    case 'idris':
      references.addAll(const <ProphetVerseReference>[
        ProphetVerseReference(surah: 19, ayah: 57),
      ]);
      break;
    case 'nuh':
      references.addAll(const <ProphetVerseReference>[
        ProphetVerseReference(surah: 11, ayah: 36),
        ProphetVerseReference(surah: 11, ayah: 44),
        ProphetVerseReference(surah: 71, ayah: 4),
        ProphetVerseReference(surah: 71, ayah: 7),
        ProphetVerseReference(surah: 71, ayah: 28),
      ]);
      break;
    case 'hud':
      references.addAll(const <ProphetVerseReference>[
        ProphetVerseReference(surah: 11, ayah: 52),
        ProphetVerseReference(surah: 11, ayah: 55),
        ProphetVerseReference(surah: 11, ayah: 60),
      ]);
      break;
    case 'salih':
      references.addAll(const <ProphetVerseReference>[
        ProphetVerseReference(surah: 11, ayah: 62),
        ProphetVerseReference(surah: 11, ayah: 64),
        ProphetVerseReference(surah: 11, ayah: 68),
      ]);
      break;
    case 'ibrahim':
      references.addAll(const <ProphetVerseReference>[
        ProphetVerseReference(surah: 2, ayah: 127),
        ProphetVerseReference(surah: 14, ayah: 35),
        ProphetVerseReference(surah: 14, ayah: 41),
        ProphetVerseReference(surah: 21, ayah: 52),
        ProphetVerseReference(surah: 21, ayah: 69),
      ]);
      break;
    case 'lut':
      references.addAll(const <ProphetVerseReference>[
        ProphetVerseReference(surah: 7, ayah: 82),
        ProphetVerseReference(surah: 11, ayah: 77),
        ProphetVerseReference(surah: 11, ayah: 83),
      ]);
      break;
    case 'ismail':
      references.addAll(const <ProphetVerseReference>[
        ProphetVerseReference(surah: 2, ayah: 127),
        ProphetVerseReference(surah: 2, ayah: 129),
        ProphetVerseReference(surah: 19, ayah: 55),
      ]);
      break;
  }

  final deduped = <String, ProphetVerseReference>{};
  for (final reference in references) {
    deduped[reference.stableId] = reference;
  }
  return deduped.values.toList(growable: false);
}

final canonicalProphetBiographyDrafts = <CanonicalProphetBiographyDraft>[
  for (final identity in canonicalQuranNamedProphets)
    CanonicalProphetBiographyDraft(
      identity: identity,
      quranReferences: _referencesFor(identity),
      sections: _sectionsFor(identity.canonicalId),
    ),
];

bool get canonicalProphetBiographyDraftsAreValid {
  if (canonicalProphetBiographyDrafts.length != 25 ||
      canonicalProphetBiographyDrafts.any(
        (draft) => !draft.isStructurallyComplete || !draft.hasPendingResearch,
      )) {
    return false;
  }

  final ids = canonicalProphetBiographyDrafts
      .map((draft) => draft.identity.canonicalId)
      .toSet();
  return ids.length == 25 &&
      ids.containsAll(
        canonicalQuranNamedProphets.map((entry) => entry.canonicalId),
      );
}
