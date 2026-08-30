import '../../../core/content/content_governance.dart';
import 'prophet_content.dart';

enum SeerahPhase { birthAndEarlyLife, meccan, hijrah, medinan, finalYears }

enum SeerahEventKind {
  birth,
  hiraAndFirstRevelation,
  meccanPreaching,
  isra,
  hijrah,
  badr,
  pledgeUnderTree,
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
      sources.every((source) =>
          source.id.trim().isNotEmpty &&
          source.title.trim().isNotEmpty &&
          source.licenseId.trim().isNotEmpty &&
          (source.locator?.trim().isNotEmpty ?? false) &&
          source.sourceClass != ReligiousSourceClass.unknown &&
          source.sourceClass != ReligiousSourceClass.israiliyat &&
          source.sourceClass != ReligiousSourceClass.laterTradition &&
          source.sourceClass != ReligiousSourceClass.disputed) &&
      links.isNotEmpty &&
      links.every((link) => link.isValid);
}

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

/// T0201 working seerah chronology.
///
/// Text is an editorial paraphrase, not a copied third-party translation.
/// The model intentionally avoids invented Gregorian/Hijri dates: event order is
/// asserted only where the cited revelation/sahih report identifies the event.
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
    id: 'muhammad-hira-first-revelation',
    order: 20,
    kind: SeerahEventKind.hiraAndFirstRevelation,
    phase: SeerahPhase.meccan,
    title: const LocalizedReligiousText(
      tr: 'Hira ve ilk vahiy',
      en: 'Hira and the first revelation',
      ar: 'حراء وبداية الوحي',
    ),
    summary: const LocalizedReligiousText(
      tr: 'Âişe rivayeti vahyin başlangıcını Hira mağarasındaki inziva ve ilk vahiy olayıyla ilişkilendirir; Alak 96:1–5 ilk emirlerin Kur’an bağlantısı olarak tutulur.',
      en: 'Aisha’s report connects the beginning of revelation with retreat in the cave of Hira and the first revelation; Quran 96:1–5 is retained as the Quran link for the opening commands.',
      ar: 'تربط رواية عائشة بدء الوحي بالخلوة في غار حراء ونزول الوحي أول مرة، وتُربط الآيات 96:1–5 بالأوامر القرآنية الأولى.',
    ),
    certainty: CertaintyLevel.stronglyAttested,
    sources: <SourceReference>[
      _sahih('bukhari-3-seerah-hira', 'Sahih al-Bukhari', 'Sahih al-Bukhari 3'),
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
      tr: 'Kur’an, yakın akrabanın uyarılmasını emreder. Bu olay için ayetin vermediği takvim tarihi eklenmez.',
      en: 'The Quran commands warning the nearest kindred. No calendar date absent from the verse is added to this event.',
      ar: 'يأمر القرآن بإنذار العشيرة الأقربين، ولا يضاف إلى الحدث تاريخ تقويمي لا تنص عليه الآية.',
    ),
    certainty: CertaintyLevel.explicitSource,
    sources: <SourceReference>[_quran('quran-26-214-seerah', '26:214')],
    links: const <SeerahEventLink>[
      SeerahEventLink.quran(ProphetVerseReference(surah: 26, ayah: 214)),
    ],
  ),
  MuhammadSeerahEvent(
    id: 'muhammad-isra',
    order: 40,
    kind: SeerahEventKind.isra,
    phase: SeerahPhase.meccan,
    title: const LocalizedReligiousText(
      tr: 'İsrâ',
      en: 'The Night Journey (Isra)',
      ar: 'الإسراء',
    ),
    summary: const LocalizedReligiousText(
      tr: 'İsrâ 17:1 gece yolculuğunu açıkça bildirir. Bu kayıt ayetin söylemediği kesin takvim tarihini üretmez.',
      en: 'Quran 17:1 explicitly records the Night Journey. This entry does not manufacture an exact calendar date not stated by the verse.',
      ar: 'تنص الآية 17:1 صراحة على الإسراء، ولا ينشئ هذا السجل تاريخًا تقويميًا دقيقًا لم تذكره الآية.',
    ),
    certainty: CertaintyLevel.explicitSource,
    sources: <SourceReference>[_quran('quran-17-1-seerah', '17:1')],
    links: const <SeerahEventLink>[
      SeerahEventLink.quran(ProphetVerseReference(surah: 17, ayah: 1)),
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
    order: 70,
    kind: SeerahEventKind.pledgeUnderTree,
    phase: SeerahPhase.medinan,
    title: const LocalizedReligiousText(
      tr: 'Ağaç altındaki biat',
      en: 'The pledge under the tree',
      ar: 'البيعة تحت الشجرة',
    ),
    summary: const LocalizedReligiousText(
      tr: 'Fetih 48:18 müminlerin ağaç altında biatını açıkça kaydeder. Ayetin kendi metninin vermediği yer veya tarih bu alanda kesinleştirilmez.',
      en: 'Quran 48:18 explicitly records the believers’ pledge under the tree. A place or date not supplied by the verse itself is not promoted to certainty here.',
      ar: 'تسجل الآية 48:18 بيعة المؤمنين تحت الشجرة صراحة، ولا يُجزم هنا بمكان أو تاريخ لا تنص عليه الآية نفسها.',
    ),
    certainty: CertaintyLevel.explicitSource,
    sources: <SourceReference>[_quran('quran-48-18-seerah', '48:18')],
    links: const <SeerahEventLink>[
      SeerahEventLink.quran(ProphetVerseReference(surah: 48, ayah: 18)),
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
  var previousOrder = 0;
  for (final event in events) {
    if (!event.isValid) issues.add('${event.id}: invalid event metadata');
    if (!ids.add(event.id)) issues.add('${event.id}: duplicate event id');
    if (event.order <= previousOrder) {
      issues.add('${event.id}: event order is not strictly increasing');
    }
    previousOrder = event.order;
  }

  final requiredKinds = <SeerahEventKind>{
    SeerahEventKind.birth,
    SeerahEventKind.hiraAndFirstRevelation,
    SeerahEventKind.meccanPreaching,
    SeerahEventKind.isra,
    SeerahEventKind.hijrah,
    SeerahEventKind.badr,
    SeerahEventKind.pledgeUnderTree,
    SeerahEventKind.conquestOfMecca,
    SeerahEventKind.death,
  };
  final present = events.map((event) => event.kind).toSet();
  for (final kind in requiredKinds.difference(present)) {
    issues.add('missing required seerah event: ${kind.name}');
  }

  return issues;
}
