import '../../../core/content/content_governance.dart';
import 'prophet_content.dart';

enum SeerahPhase { birthAndEarlyLife, meccan, hijrah, medinan, finalYears }

enum SeerahEventKind {
  birth,
  youth,
  marriage,
  hira,
  firstRevelation,
  meccanPreaching,
  abyssiniaMigration,
  boycott,
  taif,
  israMiraj,
  aqaba,
  hijrah,
  medinaArrival,
  badr,
  pledgeUnderTree,
  hudaybiyyahTreaty,
  conquestOfMecca,
  farewellPilgrimage,
  death,
}

class SeerahEventLink {
  const SeerahEventLink.quran(this.verse)
      : hadithLocator = null,
        biographySectionId = null;

  const SeerahEventLink.hadith(this.hadithLocator)
      : verse = null,
        biographySectionId = null;

  const SeerahEventLink.biography(this.biographySectionId)
      : verse = null,
        hadithLocator = null;

  final ProphetVerseReference? verse;
  final String? hadithLocator;
  final String? biographySectionId;

  bool get isValid {
    final populated = <Object?>[verse, hadithLocator, biographySectionId]
        .where((value) => value != null)
        .length;
    if (populated != 1) return false;
    if (verse != null) return verse!.isValid;
    if (hadithLocator != null) return hadithLocator!.trim().isNotEmpty;
    return biographySectionId!.trim().isNotEmpty;
  }
}

class MuhammadSeerahEvent {
  const MuhammadSeerahEvent({
    required this.id,
    required this.order,
    required this.kind,
    required this.phase,
    required this.title,
    required this.summary,
    required this.certainty,
    required this.sources,
    required this.links,
  });

  final String id;
  final int order;
  final SeerahEventKind kind;
  final SeerahPhase phase;
  final LocalizedReligiousText title;
  final LocalizedReligiousText summary;
  final CertaintyLevel certainty;
  final List<SourceReference> sources;
  final List<SeerahEventLink> links;

  bool get isValid =>
      id.trim().isNotEmpty &&
      order > 0 &&
      title.isComplete &&
      summary.isComplete &&
      certainty != CertaintyLevel.unknown &&
      sources.isNotEmpty &&
      sources.every(_isAllowedSeerahSource) &&
      links.isNotEmpty &&
      links.every((link) => link.isValid);
}

bool _isAllowedSeerahSource(SourceReference source) =>
    source.id.trim().isNotEmpty &&
    source.title.trim().isNotEmpty &&
    source.licenseId.trim().isNotEmpty &&
    (source.locator?.trim().isNotEmpty ?? false) &&
    source.sourceClass != ReligiousSourceClass.unknown &&
    source.sourceClass != ReligiousSourceClass.israiliyat &&
    source.sourceClass != ReligiousSourceClass.laterTradition &&
    source.sourceClass != ReligiousSourceClass.disputed;

SourceReference _quran(String id, String locator) => SourceReference(
      id: id,
      title: 'Tanzil Project Uthmani Quran v1.1',
      sourceClass: ReligiousSourceClass.quran,
      licenseId: 'CC-BY-3.0',
      locator: locator,
    );

SourceReference _sahih(String id, String title, String locator) =>
    SourceReference(
      id: id,
      title: title,
      sourceClass: ReligiousSourceClass.sahihHasanHadith,
      licenseId: 'REFERENCE-ONLY',
      locator: locator,
    );

/// T0201 production-candidate seerah chronology for the high-confidence layer.
///
/// Every user-facing sentence below is an editorial paraphrase. Third-party
/// hadith translations are not bundled as content assets. Hadith references are
/// bibliographic (`REFERENCE-ONLY`) and Quran references use the pinned Tanzil
/// source contract. Event order is relative chronology only; the dataset never
/// turns an unstated traditional/modern date into an exact Gregorian/Hijri date.
final muhammadSeerahT0201Events = <MuhammadSeerahEvent>[
  MuhammadSeerahEvent(
    id: 'muhammad-birth-monday',
    order: 10,
    kind: SeerahEventKind.birth,
    phase: SeerahPhase.birthAndEarlyLife,
    title: const LocalizedReligiousText(
      tr: 'Doğum hakkında güvenilir sınır',
      en: 'Reliable boundary for the birth',
      ar: 'الحد الموثوق لمعلومة الميلاد',
    ),
    summary: const LocalizedReligiousText(
      tr: 'Sahih rivayet pazartesiyi doğduğu gün olarak bildirir; bu kayıt kesin miladi tarih veya doğum yılı üretmez.',
      en: 'A sahih report identifies Monday as the day of his birth; this record does not manufacture an exact Gregorian date or birth year.',
      ar: 'تذكر رواية صحيحة أن يوم الاثنين هو يوم مولده، ولا يستخرج هذا السجل تاريخًا ميلاديًا أو سنة ميلاد دقيقة.',
    ),
    certainty: CertaintyLevel.stronglyAttested,
    sources: <SourceReference>[
      _sahih('muslim-1162e-seerah-birth', 'Sahih Muslim', 'Sahih Muslim 1162e'),
    ],
    links: const <SeerahEventLink>[
      SeerahEventLink.hadith('Sahih Muslim 1162e'),
      SeerahEventLink.biography('muhammad.birth'),
    ],
  ),
  MuhammadSeerahEvent(
    id: 'muhammad-youth-shepherding',
    order: 12,
    kind: SeerahEventKind.youth,
    phase: SeerahPhase.birthAndEarlyLife,
    title: const LocalizedReligiousText(
      tr: 'Gençlik döneminden güvenilir bir kayıt',
      en: 'A reliable record from early life',
      ar: 'خبر موثوق من مرحلة الشباب',
    ),
    summary: const LocalizedReligiousText(
      tr: 'Sahih Buhârî’de Hz. Muhammed Mekke halkının koyunlarını güttüğünü bildirir. Rivayetin vermediği yaş, yıl veya ek gençlik ayrıntıları kesinleştirilmez.',
      en: 'A Sahih al-Bukhari report records Prophet Muhammad saying that he shepherded sheep for the people of Mecca. No age, year, or extra youth detail absent from the report is asserted.',
      ar: 'تثبت رواية في صحيح البخاري أن النبي محمد رعى غنم أهل مكة، ولا يُجزم بعمر أو سنة أو تفاصيل شبابه التي لا تذكرها الرواية.',
    ),
    certainty: CertaintyLevel.stronglyAttested,
    sources: <SourceReference>[
      _sahih('bukhari-2262-seerah-youth', 'Sahih al-Bukhari', 'Sahih al-Bukhari 2262'),
    ],
    links: const <SeerahEventLink>[
      SeerahEventLink.hadith('Sahih al-Bukhari 2262'),
    ],
  ),
  MuhammadSeerahEvent(
    id: 'muhammad-marriage-khadija',
    order: 14,
    kind: SeerahEventKind.marriage,
    phase: SeerahPhase.birthAndEarlyLife,
    title: const LocalizedReligiousText(
      tr: 'Hz. Hatice ile evlilik',
      en: 'Marriage to Khadija',
      ar: 'الزواج من خديجة',
    ),
    summary: const LocalizedReligiousText(
      tr: 'Sahih Buhârî, Hz. Hatice’yi Hz. Muhammed’in eşi olarak açıkça kaydeder. Bu kronoloji, yalnız bu kaynakla kesin yaş veya evlilik yılı üretmez.',
      en: 'Sahih al-Bukhari explicitly records Khadija as Prophet Muhammad’s wife. This chronology does not derive an exact age or marriage year from that report alone.',
      ar: 'يثبت صحيح البخاري زواج النبي محمد من خديجة، ولا يستخرج هذا التسلسل من هذه الرواية وحدها عمرًا أو سنة زواج دقيقة.',
    ),
    certainty: CertaintyLevel.stronglyAttested,
    sources: <SourceReference>[
      _sahih('bukhari-3817-seerah-marriage', 'Sahih al-Bukhari', 'Sahih al-Bukhari 3817'),
    ],
    links: const <SeerahEventLink>[
      SeerahEventLink.hadith('Sahih al-Bukhari 3817'),
    ],
  ),
  MuhammadSeerahEvent(
    id: 'muhammad-hira-retreat',
    order: 20,
    kind: SeerahEventKind.hira,
    phase: SeerahPhase.meccan,
    title: const LocalizedReligiousText(
      tr: 'Hira’da inziva',
      en: 'Retreat in Hira',
      ar: 'الخلوة في حراء',
    ),
    summary: const LocalizedReligiousText(
      tr: 'Âişe rivayeti vahiyden önce Hira mağarasındaki inziva dönemini kaydeder; bu kayıttan bağımsız bir kesin takvim tarihi türetilmez.',
      en: 'Aisha’s report records the period of retreat in the cave of Hira before the opening revelation; no independent exact calendar date is derived from it.',
      ar: 'تسجل رواية عائشة الخلوة في غار حراء قبل بدء الوحي، ولا يستخرج منها تاريخ تقويمي دقيق مستقل.',
    ),
    certainty: CertaintyLevel.stronglyAttested,
    sources: <SourceReference>[
      _sahih('bukhari-3-seerah-hira', 'Sahih al-Bukhari', 'Sahih al-Bukhari 3'),
    ],
    links: const <SeerahEventLink>[
      SeerahEventLink.hadith('Sahih al-Bukhari 3'),
    ],
  ),
  MuhammadSeerahEvent(
    id: 'muhammad-first-revelation',
    order: 22,
    kind: SeerahEventKind.firstRevelation,
    phase: SeerahPhase.meccan,
    title: const LocalizedReligiousText(
      tr: 'İlk vahiy',
      en: 'The first revelation',
      ar: 'بدء الوحي',
    ),
    summary: const LocalizedReligiousText(
      tr: 'Sahih rivayet ilk vahyin Hira’daki başlangıcını anlatır; Alak 96:1–5 açılış emirlerinin Kur’an bağlantısı olarak tutulur.',
      en: 'A sahih report records the beginning of revelation in Hira; Quran 96:1–5 is retained as the Quran link for the opening commands.',
      ar: 'تثبت رواية صحيحة بدء الوحي في حراء، وتُربط الآيات 96:1–5 بالأوامر القرآنية الأولى.',
    ),
    certainty: CertaintyLevel.stronglyAttested,
    sources: <SourceReference>[
      _sahih('bukhari-3-seerah-first-revelation', 'Sahih al-Bukhari', 'Sahih al-Bukhari 3'),
      _quran('quran-96-1-5-seerah', '96:1-5'),
    ],
    links: const <SeerahEventLink>[
      SeerahEventLink.hadith('Sahih al-Bukhari 3'),
      SeerahEventLink.quran(ProphetVerseReference(surah: 96, ayah: 1)),
    ],
  ),
  MuhammadSeerahEvent(
    id: 'muhammad-meccan-nearest-kindred',
    order: 30,
    kind: SeerahEventKind.meccanPreaching,
    phase: SeerahPhase.meccan,
    title: const LocalizedReligiousText(
      tr: 'Mekke tebliği: yakınları uyarma emri',
      en: 'Meccan preaching: command to warn close kindred',
      ar: 'الدعوة في مكة: أمر إنذار العشيرة الأقربين',
    ),
    summary: const LocalizedReligiousText(
      tr: 'Kur’an, yakın akrabanın uyarılmasını emreder. Ayetin vermediği takvim tarihi olaya eklenmez.',
      en: 'The Quran commands warning the nearest kindred. No calendar date absent from the verse is added.',
      ar: 'يأمر القرآن بإنذار العشيرة الأقربين، ولا يضاف تاريخ تقويمي لا تنص عليه الآية.',
    ),
    certainty: CertaintyLevel.explicitSource,
    sources: <SourceReference>[_quran('quran-26-214-seerah', '26:214')],
    links: const <SeerahEventLink>[
      SeerahEventLink.quran(ProphetVerseReference(surah: 26, ayah: 214)),
    ],
  ),
  MuhammadSeerahEvent(
    id: 'muhammad-abyssinia-migrations',
    order: 34,
    kind: SeerahEventKind.abyssiniaMigration,
    phase: SeerahPhase.meccan,
    title: const LocalizedReligiousText(
      tr: 'Habeşistan hicretleri',
      en: 'Migrations to Abyssinia',
      ar: 'الهجرة إلى الحبشة',
    ),
    summary: const LocalizedReligiousText(
      tr: 'Sahih Buhârî, Habeşistan’daki Necâşî yanında Ca‘fer b. Ebû Tâlib’le bulunan muhacirleri ve iki hicret ifadesini kaydeder. Rivayetin söylemediği ayrıntılar eklenmez.',
      en: 'Sahih al-Bukhari records emigrants with Ja‘far ibn Abi Talib under the Negus in Abyssinia and refers to two migrations. Details absent from the report are not added.',
      ar: 'يثبت صحيح البخاري وجود مهاجرين مع جعفر بن أبي طالب عند النجاشي في الحبشة، ويذكر لهم هجرتين، ولا تضاف تفاصيل لا تنص عليها الرواية.',
    ),
    certainty: CertaintyLevel.stronglyAttested,
    sources: <SourceReference>[
      _sahih('bukhari-3876-seerah-abyssinia', 'Sahih al-Bukhari', 'Sahih al-Bukhari 3876'),
    ],
    links: const <SeerahEventLink>[
      SeerahEventLink.hadith('Sahih al-Bukhari 3876'),
    ],
  ),
  MuhammadSeerahEvent(
    id: 'muhammad-boycott-banu-hashim',
    order: 36,
    kind: SeerahEventKind.boycott,
    phase: SeerahPhase.meccan,
    title: const LocalizedReligiousText(
      tr: 'Hâşimoğullarına karşı boykot',
      en: 'Boycott against Banu Hashim',
      ar: 'المقاطعة ضد بني هاشم',
    ),
    summary: const LocalizedReligiousText(
      tr: 'Sahih Buhârî, Kureyş ve Kinâne’nin Hâşimoğullarıyla alışveriş ve barınma ilişkisini kesmeye yönelik anlaşmasını kaydeder. Süre veya ek ayrıntı bu kaynaktan uydurulmaz.',
      en: 'Sahih al-Bukhari records an agreement by Quraysh and Kinana to cut dealings and shelter with Banu Hashim. Duration or extra details are not manufactured from this source.',
      ar: 'يثبت صحيح البخاري تعاهد قريش وكنانة على قطع المعاملة والإيواء عن بني هاشم، ولا تستخرج من هذا المصدر مدة أو تفاصيل زائدة.',
    ),
    certainty: CertaintyLevel.stronglyAttested,
    sources: <SourceReference>[
      _sahih('bukhari-3058-seerah-boycott', 'Sahih al-Bukhari', 'Sahih al-Bukhari 3058'),
    ],
    links: const <SeerahEventLink>[
      SeerahEventLink.hadith('Sahih al-Bukhari 3058'),
    ],
  ),
  MuhammadSeerahEvent(
    id: 'muhammad-taif-rejection',
    order: 38,
    kind: SeerahEventKind.taif,
    phase: SeerahPhase.meccan,
    title: const LocalizedReligiousText(
      tr: 'Tâif’te reddediliş',
      en: 'Rejection at Taif',
      ar: 'الرد في الطائف',
    ),
    summary: const LocalizedReligiousText(
      tr: 'Âişe’nin sahih rivayetinde Hz. Muhammed, kavminden gördüğü ağır günlerden birini İbn Abd Yâlîl’e yaptığı çağrının karşılıksız kalmasıyla ilişkilendirir. Kaynak dışı dramatik ayrıntılar eklenmez.',
      en: 'In a sahih report from Aisha, Prophet Muhammad associates one of the hardest days he faced from his people with his appeal to Ibn Abd Yalil being rejected. Extra dramatic details outside the source are not added.',
      ar: 'في رواية صحيحة عن عائشة يربط النبي محمد أحد أشد الأيام التي لقيها من قومه برد ابن عبد ياليل لدعوته، ولا تضاف تفاصيل درامية خارج المصدر.',
    ),
    certainty: CertaintyLevel.stronglyAttested,
    sources: <SourceReference>[
      _sahih('bukhari-3231-seerah-taif', 'Sahih al-Bukhari', 'Sahih al-Bukhari 3231'),
    ],
    links: const <SeerahEventLink>[
      SeerahEventLink.hadith('Sahih al-Bukhari 3231'),
    ],
  ),
  MuhammadSeerahEvent(
    id: 'muhammad-isra-miraj',
    order: 40,
    kind: SeerahEventKind.israMiraj,
    phase: SeerahPhase.meccan,
    title: const LocalizedReligiousText(
      tr: 'İsrâ ve Mi‘rac',
      en: 'Isra and Mi‘raj',
      ar: 'الإسراء والمعراج',
    ),
    summary: const LocalizedReligiousText(
      tr: 'İsrâ 17:1 gece yolculuğunu açıkça bildirir; Sahih Buhârî’de Mi‘rac anlatısı ayrıca yer alır. Kaynakların vermediği kesin takvim tarihi üretilmez.',
      en: 'Quran 17:1 explicitly records the Night Journey, while Sahih al-Bukhari separately records the Mi‘raj account. No exact calendar date absent from the sources is manufactured.',
      ar: 'تنص الآية 17:1 صراحة على الإسراء، ويورد صحيح البخاري خبر المعراج أيضًا، ولا ينشأ تاريخ تقويمي دقيق لا تذكره المصادر.',
    ),
    certainty: CertaintyLevel.stronglyAttested,
    sources: <SourceReference>[
      _quran('quran-17-1-seerah', '17:1'),
      _sahih('bukhari-3887-seerah-miraj', 'Sahih al-Bukhari', 'Sahih al-Bukhari 3887'),
    ],
    links: const <SeerahEventLink>[
      SeerahEventLink.quran(ProphetVerseReference(surah: 17, ayah: 1)),
      SeerahEventLink.hadith('Sahih al-Bukhari 3887'),
    ],
  ),
  MuhammadSeerahEvent(
    id: 'muhammad-aqaba-pledge',
    order: 45,
    kind: SeerahEventKind.aqaba,
    phase: SeerahPhase.meccan,
    title: const LocalizedReligiousText(
      tr: 'Akabe biatı',
      en: 'The pledge at Aqaba',
      ar: 'بيعة العقبة',
    ),
    summary: const LocalizedReligiousText(
      tr: 'Sahih Buhârî, Akabe biatına katılan nakiblerden birinin doğrudan şahitliğini kaydeder. Bu olay güvenilir kaynak sınırında tutulur.',
      en: 'Sahih al-Bukhari records direct testimony from one of the representatives who took part in the pledge at Aqaba. The event is kept within that reliable source boundary.',
      ar: 'يثبت صحيح البخاري شهادة أحد النقباء الذين شاركوا في بيعة العقبة، ويبقى عرض الحدث ضمن حدود هذا المصدر الموثوق.',
    ),
    certainty: CertaintyLevel.stronglyAttested,
    sources: <SourceReference>[
      _sahih('bukhari-3893-seerah-aqaba', 'Sahih al-Bukhari', 'Sahih al-Bukhari 3893'),
    ],
    links: const <SeerahEventLink>[
      SeerahEventLink.hadith('Sahih al-Bukhari 3893'),
    ],
  ),
  MuhammadSeerahEvent(
    id: 'muhammad-hijrah-cave',
    order: 50,
    kind: SeerahEventKind.hijrah,
    phase: SeerahPhase.hijrah,
    title: const LocalizedReligiousText(
      tr: 'Hicret ve mağara olayı',
      en: 'Hijrah and the cave episode',
      ar: 'الهجرة وواقعة الغار',
    ),
    summary: const LocalizedReligiousText(
      tr: 'Tevbe 9:40 iki kişiden ve mağaradaki teselliden söz eder; sahih rivayet Ebû Bekir’in mağarada Hz. Muhammed ile bulunduğunu ayrıca doğrular.',
      en: 'Quran 9:40 speaks of the two and reassurance in the cave; a sahih report independently identifies Abu Bakr as being there with Prophet Muhammad.',
      ar: 'تذكر الآية 9:40 الاثنين والتثبيت في الغار، وتؤكد رواية صحيحة أن أبا بكر كان مع النبي محمد في الغار.',
    ),
    certainty: CertaintyLevel.stronglyAttested,
    sources: <SourceReference>[
      _quran('quran-9-40-seerah', '9:40'),
      _sahih('bukhari-4663-seerah-cave', 'Sahih al-Bukhari', 'Sahih al-Bukhari 4663'),
    ],
    links: const <SeerahEventLink>[
      SeerahEventLink.quran(ProphetVerseReference(surah: 9, ayah: 40)),
      SeerahEventLink.hadith('Sahih al-Bukhari 4663'),
    ],
  ),
  MuhammadSeerahEvent(
    id: 'muhammad-medina-arrival',
    order: 55,
    kind: SeerahEventKind.medinaArrival,
    phase: SeerahPhase.medinan,
    title: const LocalizedReligiousText(
      tr: 'Medine’ye varış',
      en: 'Arrival in Medina',
      ar: 'القدوم إلى المدينة',
    ),
    summary: const LocalizedReligiousText(
      tr: 'Sahih Buhârî, Hz. Muhammed’in Medine’ye gelişini ve Medinelilerin sevincini açıkça kaydeder. Burada rivayetin ötesinde kesin gün/saat üretilmez.',
      en: 'Sahih al-Bukhari explicitly records Prophet Muhammad’s arrival in Medina and the joy of its people. No exact day or hour beyond the report is manufactured here.',
      ar: 'يثبت صحيح البخاري قدوم النبي محمد إلى المدينة وفرح أهلها، ولا ينشأ هنا يوم أو وقت دقيق يتجاوز نص الرواية.',
    ),
    certainty: CertaintyLevel.stronglyAttested,
    sources: <SourceReference>[
      _sahih('bukhari-3925-seerah-medina', 'Sahih al-Bukhari', 'Sahih al-Bukhari 3925'),
    ],
    links: const <SeerahEventLink>[
      SeerahEventLink.hadith('Sahih al-Bukhari 3925'),
    ],
  ),
  MuhammadSeerahEvent(
    id: 'muhammad-badr',
    order: 60,
    kind: SeerahEventKind.badr,
    phase: SeerahPhase.medinan,
    title: const LocalizedReligiousText(tr: 'Bedir', en: 'Badr', ar: 'بدر'),
    summary: const LocalizedReligiousText(
      tr: 'Âl-i İmrân 3:123 Bedir’i adıyla anarak Allah’ın yardımını hatırlatır; olay bu açık Kur’an bağlantısıyla kronolojiye alınır.',
      en: 'Quran 3:123 names Badr while recalling divine help; the event enters the chronology through this explicit Quran link.',
      ar: 'تذكر الآية 3:123 بدرًا بالاسم وتذكّر بنصر الله، ولذلك يثبت الحدث في التسلسل بهذا الرابط القرآني الصريح.',
    ),
    certainty: CertaintyLevel.explicitSource,
    sources: <SourceReference>[_quran('quran-3-123-seerah', '3:123')],
    links: const <SeerahEventLink>[
      SeerahEventLink.quran(ProphetVerseReference(surah: 3, ayah: 123)),
    ],
  ),
  MuhammadSeerahEvent(
    id: 'muhammad-pledge-under-tree',
    order: 68,
    kind: SeerahEventKind.pledgeUnderTree,
    phase: SeerahPhase.medinan,
    title: const LocalizedReligiousText(
      tr: 'Ağaç altındaki biat',
      en: 'The pledge under the tree',
      ar: 'البيعة تحت الشجرة',
    ),
    summary: const LocalizedReligiousText(
      tr: 'Fetih 48:18 müminlerin ağaç altında biatını açıkça kaydeder. Ayetin kendi metninin vermediği yer veya tarih kesinleştirilmez.',
      en: 'Quran 48:18 explicitly records the believers’ pledge under the tree. A place or date not supplied by the verse itself is not promoted to certainty.',
      ar: 'تسجل الآية 48:18 بيعة المؤمنين تحت الشجرة صراحة، ولا يُجزم بمكان أو تاريخ لا تنص عليه الآية نفسها.',
    ),
    certainty: CertaintyLevel.explicitSource,
    sources: <SourceReference>[_quran('quran-48-18-seerah', '48:18')],
    links: const <SeerahEventLink>[
      SeerahEventLink.quran(ProphetVerseReference(surah: 48, ayah: 18)),
    ],
  ),
  MuhammadSeerahEvent(
    id: 'muhammad-hudaybiyyah-treaty',
    order: 70,
    kind: SeerahEventKind.hudaybiyyahTreaty,
    phase: SeerahPhase.medinan,
    title: const LocalizedReligiousText(
      tr: 'Hudeybiye Antlaşması',
      en: 'Treaty of Hudaybiyyah',
      ar: 'صلح الحديبية',
    ),
    summary: const LocalizedReligiousText(
      tr: 'Sahih Buhârî, Hudeybiye’de yapılan antlaşmanın şartlarından bazılarını açıkça aktarır. Kronoloji antlaşmanın varlığını ve kaynakta geçen şartları ayırır; kaynak dışı ayrıntı eklemez.',
      en: 'Sahih al-Bukhari explicitly records several conditions of the treaty at Hudaybiyyah. The chronology distinguishes the treaty itself from details not supported by the source.',
      ar: 'يثبت صحيح البخاري عددًا من شروط الصلح في الحديبية، ويفصل هذا التسلسل بين أصل الصلح وما لا يثبته المصدر من تفاصيل.',
    ),
    certainty: CertaintyLevel.stronglyAttested,
    sources: <SourceReference>[
      _sahih('bukhari-2711-2712-seerah-hudaybiyyah', 'Sahih al-Bukhari', 'Sahih al-Bukhari 2711-2712'),
    ],
    links: const <SeerahEventLink>[
      SeerahEventLink.hadith('Sahih al-Bukhari 2711-2712'),
    ],
  ),
  MuhammadSeerahEvent(
    id: 'muhammad-conquest-mecca',
    order: 80,
    kind: SeerahEventKind.conquestOfMecca,
    phase: SeerahPhase.medinan,
    title: const LocalizedReligiousText(
      tr: 'Mekke’nin fethi',
      en: 'Conquest of Mecca',
      ar: 'فتح مكة',
    ),
    summary: const LocalizedReligiousText(
      tr: 'Sahih Buhârî rivayeti Mekke’nin fethi günündeki ilerleyişi ve sancağın konumlandırılmasını aktarır; burada üçüncü taraf tercüme kopyalanmaz.',
      en: 'A Sahih al-Bukhari report records the advance on the day of the Conquest of Mecca and the placing of the flag; no third-party translation is copied here.',
      ar: 'تروي رواية في صحيح البخاري مسير يوم فتح مكة وموضع الراية، من غير نسخ ترجمة لطرف ثالث في هذا السجل.',
    ),
    certainty: CertaintyLevel.stronglyAttested,
    sources: <SourceReference>[
      _sahih('bukhari-4280-seerah-conquest', 'Sahih al-Bukhari', 'Sahih al-Bukhari 4280'),
    ],
    links: const <SeerahEventLink>[
      SeerahEventLink.hadith('Sahih al-Bukhari 4280'),
    ],
  ),
  MuhammadSeerahEvent(
    id: 'muhammad-farewell-pilgrimage',
    order: 90,
    kind: SeerahEventKind.farewellPilgrimage,
    phase: SeerahPhase.finalYears,
    title: const LocalizedReligiousText(
      tr: 'Veda Haccı',
      en: 'Farewell Pilgrimage',
      ar: 'حجة الوداع',
    ),
    summary: const LocalizedReligiousText(
      tr: 'Sahih Buhârî, Veda Haccı sırasında kurban günü yapılan hitabı kaydeder. Bu kayıt olayın güçlü kaynaklı varlığını doğrular; üçüncü taraf çeviri metni uygulamaya alınmaz.',
      en: 'Sahih al-Bukhari records an address delivered on the Day of Sacrifice during the Farewell Pilgrimage. It confirms the event without bundling a third-party translation as app content.',
      ar: 'يثبت صحيح البخاري خطبة يوم النحر في حجة الوداع، ويثبت الحدث من غير إدخال ترجمة لطرف ثالث ضمن محتوى التطبيق.',
    ),
    certainty: CertaintyLevel.stronglyAttested,
    sources: <SourceReference>[
      _sahih('bukhari-1739-seerah-farewell', 'Sahih al-Bukhari', 'Sahih al-Bukhari 1739'),
    ],
    links: const <SeerahEventLink>[
      SeerahEventLink.hadith('Sahih al-Bukhari 1739'),
    ],
  ),
  MuhammadSeerahEvent(
    id: 'muhammad-death',
    order: 100,
    kind: SeerahEventKind.death,
    phase: SeerahPhase.finalYears,
    title: const LocalizedReligiousText(tr: 'Vefat', en: 'Death', ar: 'الوفاة'),
    summary: const LocalizedReligiousText(
      tr: 'Âişe’den gelen sahih rivayet vefatını ve son anlarını aktarır; kaynaktan kesin miladi tarih türetilmez.',
      en: 'A sahih report from Aisha records his death and final moments; no exact Gregorian date is derived from the report.',
      ar: 'تنقل رواية صحيحة عن عائشة وفاته وساعاته الأخيرة، ولا يُستنبط منها تاريخ ميلادي دقيق.',
    ),
    certainty: CertaintyLevel.stronglyAttested,
    sources: <SourceReference>[
      _sahih('bukhari-4449-seerah-death', 'Sahih al-Bukhari', 'Sahih al-Bukhari 4449'),
    ],
    links: const <SeerahEventLink>[
      SeerahEventLink.hadith('Sahih al-Bukhari 4449'),
      SeerahEventLink.biography('muhammad.death'),
    ],
  ),
];

List<String> auditMuhammadSeerahT0201(List<MuhammadSeerahEvent> events) {
  final issues = <String>[];
  if (events.isEmpty) return <String>['seerah timeline is empty'];

  final ids = <String>{};
  final sourceIds = <String>{};
  var previousOrder = 0;
  for (final event in events) {
    if (!event.isValid) issues.add('${event.id}: invalid event metadata');
    if (!ids.add(event.id)) issues.add('${event.id}: duplicate event id');
    if (event.order <= previousOrder) {
      issues.add('${event.id}: event order is not strictly increasing');
    }
    previousOrder = event.order;

    for (final source in event.sources) {
      if (!sourceIds.add(source.id)) {
        issues.add('${event.id}: duplicate source id ${source.id}');
      }
    }
  }

  final present = events.map((event) => event.kind).toSet();
  for (final kind in SeerahEventKind.values.toSet().difference(present)) {
    issues.add('missing required seerah event: ${kind.name}');
  }

  return issues;
}
