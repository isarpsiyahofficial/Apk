import 'pre_islam_world_context.dart';

enum HighMedievalHistoryTrack {
  seljuq,
  crusades,
  ayyubid,
  mongol,
  mamluk,
}

enum HighMedievalHistoryCertainty {
  establishedChronology,
  broadPeriod,
  contestedInterpretation,
}

class HighMedievalHistoryResearchSource {
  const HighMedievalHistoryResearchSource({
    required this.locator,
    required this.workFamilyId,
  });

  final HistorySourceLocator locator;
  final String workFamilyId;
}

class HighMedievalHistoryEntry {
  const HighMedievalHistoryEntry({
    required this.id,
    required this.track,
    required this.title,
    required this.summary,
    required this.startYearCe,
    required this.endYearCe,
    required this.certainty,
    required this.caveat,
    required this.sourceIds,
    required this.status,
  });

  final String id;
  final HighMedievalHistoryTrack track;
  final LocalizedHistorySummary title;
  final LocalizedHistorySummary summary;
  final int startYearCe;
  final int endYearCe;
  final HighMedievalHistoryCertainty certainty;
  final LocalizedHistorySummary? caveat;
  final List<String> sourceIds;
  final HistoryResearchStatus status;
}

class HighMedievalHistoryDataset {
  HighMedievalHistoryDataset._({
    required this.sources,
    required this.entries,
  });

  factory HighMedievalHistoryDataset.validated({
    required List<HighMedievalHistoryResearchSource> sources,
    required List<HighMedievalHistoryEntry> entries,
  }) {
    if (sources.isEmpty || entries.isEmpty) {
      throw StateError('T0215 history research dataset must not be empty.');
    }

    final sourcesById = <String, HighMedievalHistoryResearchSource>{};
    for (final source in sources) {
      if (!source.locator.isComplete ||
          source.workFamilyId.trim().isEmpty ||
          sourcesById.containsKey(source.locator.id)) {
        throw StateError('T0215 sources must be unique and complete.');
      }
      sourcesById[source.locator.id] = source;
    }

    final entryIds = <String>{};
    final tracks = <HighMedievalHistoryTrack>{};
    final previousStartByTrack = <HighMedievalHistoryTrack, int>{};

    for (final entry in entries) {
      if (entry.id.trim().isEmpty ||
          !entryIds.add(entry.id) ||
          !entry.title.isComplete ||
          !entry.summary.isComplete ||
          entry.startYearCe > entry.endYearCe ||
          entry.sourceIds.toSet().length < 2 ||
          entry.sourceIds.any((sourceId) => !sourcesById.containsKey(sourceId))) {
        throw StateError('T0215 entry failed identity/content/date/source validation.');
      }

      final sourceFamilies = entry.sourceIds
          .map((sourceId) => sourcesById[sourceId]!.workFamilyId)
          .toSet();
      if (sourceFamilies.length < 2) {
        throw StateError(
          'T0215 entries require two independent academic work families.',
        );
      }

      if (entry.certainty != HighMedievalHistoryCertainty.establishedChronology &&
          (entry.caveat == null || !entry.caveat!.isComplete)) {
        throw StateError('Non-exact T0215 entries require TR/EN/AR caveats.');
      }

      final previousStart = previousStartByTrack[entry.track];
      if (previousStart != null && entry.startYearCe < previousStart) {
        throw StateError(
          'Chronology may overlap across tracks but not run backwards inside a track.',
        );
      }
      previousStartByTrack[entry.track] = entry.startYearCe;
      tracks.add(entry.track);
    }

    final missingTracks = HighMedievalHistoryTrack.values.toSet().difference(tracks);
    if (missingTracks.isNotEmpty) {
      throw StateError('Missing required T0215 historical tracks: $missingTracks');
    }

    final missingEntries = requiredEntryIds.difference(entryIds);
    if (missingEntries.isNotEmpty) {
      throw StateError('Missing required T0215 entries: $missingEntries');
    }

    return HighMedievalHistoryDataset._(
      sources: List.unmodifiable(sources),
      entries: List.unmodifiable(entries),
    );
  }

  static const Set<String> requiredEntryIds = {
    'great_seljuq_sultanate',
    'crusading_movement_levant',
    'ayyubid_egypt_syria',
    'mongol_invasions_islamic_lands',
    'mamluk_sultanate_egypt_syria',
  };

  final List<HighMedievalHistoryResearchSource> sources;
  final List<HighMedievalHistoryEntry> entries;

  List<HighMedievalHistoryEntry> get productionEntries => List.unmodifiable(
        entries.where(
          (entry) => entry.status == HistoryResearchStatus.reviewedForProduction,
        ),
      );
}

const highMedievalHistoryT0215Sources = <HighMedievalHistoryResearchSource>[
  HighMedievalHistoryResearchSource(
    workFamilyId: 'cambridge_history_iran_bosworth',
    locator: HistorySourceLocator(
      id: 'bosworth_iran_1000_1217',
      kind: HistorySourceKind.academicChapter,
      citation: 'C. E. Bosworth, “The Political and Dynastic History of the Iranian World (A.D. 1000–1217)”, The Cambridge History of Iran, vol. 5, Cambridge University Press.',
      locator: 'Cambridge Core chapter 024AA8933D346C06170E0D72EA6D71A4',
    ),
  ),
  HighMedievalHistoryResearchSource(
    workFamilyId: 'new_cambridge_medieval_history_brett',
    locator: HistorySourceLocator(
      id: 'brett_abbasids_fatimids_seljuqs',
      kind: HistorySourceKind.academicChapter,
      citation: 'Michael Brett, “Abbasids, Fatimids and Seljuqs”, The New Cambridge Medieval History, Cambridge University Press.',
      locator: 'doi:10.1017/CHOL9780521414111.026',
    ),
  ),
  HighMedievalHistoryResearchSource(
    workFamilyId: 'new_cambridge_islam_edde',
    locator: HistorySourceLocator(
      id: 'edde_bilad_al_sham_970_1260',
      kind: HistorySourceKind.academicChapter,
      citation: 'Anne-Marie Eddé, “Bilād al-Shām, from the Fāṭimid conquest to the fall of the Ayyūbids (970–1260)”, The New Cambridge History of Islam, Cambridge University Press.',
      locator: 'doi:10.1017/CHOL9780521839570.008',
    ),
  ),
  HighMedievalHistoryResearchSource(
    workFamilyId: 'hillenbrand_crusades_islamic_perspectives',
    locator: HistorySourceLocator(
      id: 'hillenbrand_crusades_1999',
      kind: HistorySourceKind.academicMonograph,
      citation: 'Carole Hillenbrand, The Crusades: Islamic Perspectives, Edinburgh University Press, 1999.',
      locator: 'ISBN:9780748606306',
    ),
  ),
  HighMedievalHistoryResearchSource(
    workFamilyId: 'new_cambridge_islam_lev',
    locator: HistorySourceLocator(
      id: 'lev_fatimid_ayyubid_egypt',
      kind: HistorySourceKind.academicChapter,
      citation: 'Yaacov Lev, “The Fāṭimid caliphate (969–1171) and the Ayyūbids in Egypt (1171–1250)”, The New Cambridge History of Islam, Cambridge University Press.',
      locator: 'doi:10.1017/CHOL9780521839570.009',
    ),
  ),
  HighMedievalHistoryResearchSource(
    workFamilyId: 'humphreys_saladin_to_mongols',
    locator: HistorySourceLocator(
      id: 'humphreys_ayyubids_damascus',
      kind: HistorySourceKind.academicMonograph,
      citation: 'R. Stephen Humphreys, From Saladin to the Mongols: The Ayyubids of Damascus, 1193–1260, State University of New York Press, 1977.',
      locator: 'ISBN:9780873952637',
    ),
  ),
  HighMedievalHistoryResearchSource(
    workFamilyId: 'new_cambridge_islam_jackson_mongols',
    locator: HistorySourceLocator(
      id: 'jackson_mongols_islamic_world',
      kind: HistorySourceKind.academicChapter,
      citation: 'Peter Jackson, “The rule of the infidels: the Mongols and the Islamic world”, The New Cambridge History of Islam, Cambridge University Press, 2010.',
      locator: 'doi:10.1017/CHOL9780521850315.006',
    ),
  ),
  HighMedievalHistoryResearchSource(
    workFamilyId: 'cambridge_world_history_biran',
    locator: HistorySourceLocator(
      id: 'biran_mongol_exchange_2015',
      kind: HistorySourceKind.academicChapter,
      citation: 'Michal Biran, “The Mongol Empire and inter-civilizational exchange”, The Cambridge World History, Cambridge University Press, 2015.',
      locator: 'doi:10.1017/CBO9780511667480.021',
    ),
  ),
  HighMedievalHistoryResearchSource(
    workFamilyId: 'new_cambridge_islam_levanoni',
    locator: HistorySourceLocator(
      id: 'levanoni_mamluks_1250_1517',
      kind: HistorySourceKind.academicChapter,
      citation: 'Amalia Levanoni, “The Mamlūks in Egypt and Syria: the Turkish Mamlūk sultanate (1250–1382) and the Circassian Mamlūk sultanate (1382–1517)”, The New Cambridge History of Islam, Cambridge University Press, 2010.',
      locator: 'doi:10.1017/CHOL9780521839570.010',
    ),
  ),
  HighMedievalHistoryResearchSource(
    workFamilyId: 'petry_mamluk_sultanate',
    locator: HistorySourceLocator(
      id: 'petry_mamluk_2022',
      kind: HistorySourceKind.academicMonograph,
      citation: 'Carl F. Petry, The Mamluk Sultanate: A History, Cambridge University Press, 2022.',
      locator: 'doi:10.1017/9781108557382',
    ),
  ),
];

const highMedievalHistoryT0215Entries = <HighMedievalHistoryEntry>[
  HighMedievalHistoryEntry(
    id: 'great_seljuq_sultanate',
    track: HighMedievalHistoryTrack.seljuq,
    title: LocalizedHistorySummary(
      tr: 'Büyük Selçuklu Sultanlığı',
      en: 'Great Seljuq Sultanate',
      ar: 'السلطنة السلجوقية الكبرى',
    ),
    summary: LocalizedHistorySummary(
      tr: 'Selçuklu hanedanı 11. yüzyılda Horasan ve İran merkezli büyük bir siyasi güç hâline geldi; Bağdat’ta Abbâsî halifeliğiyle yeni bir sultanlık-halifelik ilişkisi kuruldu. 12. yüzyıldaki parçalanma süreci farklı Selçuklu kolları ve bölgesel güçlerin yükselişiyle ilerledi.',
      en: 'The Seljuq dynasty became a major political power centred on Khurasan and Iran in the eleventh century, forming a new sultan-caliph relationship with the Abbasid caliphate in Baghdad. Fragmentation in the twelfth century proceeded alongside the rise of different Seljuq branches and regional powers.',
      ar: 'أصبحت السلالة السلجوقية قوة سياسية كبرى متمركزة في خراسان وإيران خلال القرن الحادي عشر، ونشأت علاقة جديدة بين السلطنة والخلافة العباسية في بغداد. وتقدمت عملية التفكك في القرن الثاني عشر مع صعود فروع سلجوقية وقوى إقليمية مختلفة.',
    ),
    startYearCe: 1037,
    endYearCe: 1194,
    certainty: HighMedievalHistoryCertainty.broadPeriod,
    caveat: LocalizedHistorySummary(
      tr: '1037–1194 aralığı Büyük Selçuklu merkezî hanedan çizgisini özetler; Anadolu, Suriye ve diğer Selçuklu kolları aynı tarihlerde başlayıp biten tek bir devlet gibi değerlendirilmemelidir.',
      en: 'The 1037–1194 range summarises the central Great Seljuq dynastic line; Anatolian, Syrian and other Seljuq branches should not be treated as one state beginning and ending on the same dates.',
      ar: 'يلخص نطاق 1037–1194 الخط السلالي المركزي للسلاجقة الكبار؛ ولا ينبغي اعتبار فروع الأناضول والشام وغيرها دولة واحدة تبدأ وتنتهي في التواريخ نفسها.',
    ),
    sourceIds: ['bosworth_iran_1000_1217', 'brett_abbasids_fatimids_seljuqs'],
    status: HistoryResearchStatus.researchDraft,
  ),
  HighMedievalHistoryEntry(
    id: 'crusading_movement_levant',
    track: HighMedievalHistoryTrack.crusades,
    title: LocalizedHistorySummary(
      tr: 'Haçlı Seferleri ve Doğu Akdeniz',
      en: 'The Crusades and the Eastern Mediterranean',
      ar: 'الحروب الصليبية وشرق البحر المتوسط',
    ),
    summary: LocalizedHistorySummary(
      tr: '1095’te başlayan Latin Hristiyan seferleri, Doğu Akdeniz’de Latin devletlerinin kurulması, Müslüman siyasi güçlerin farklı tepkileri, ittifaklar ve uzun süreli çatışmalarla şekillenen çok evreli bir dönem oluşturdu. Bu dönem tek bir kesintisiz savaş veya tek taraflı anlatı olarak sunulmaz.',
      en: 'Latin Christian expeditions beginning in 1095 opened a multi-phase period shaped by the establishment of Latin states in the eastern Mediterranean, varied responses by Muslim powers, alliances and prolonged conflicts. It should not be presented as one uninterrupted war or a one-sided narrative.',
      ar: 'فتحت الحملات اللاتينية المسيحية التي بدأت سنة 1095 مرحلة متعددة الأطوار، تشكلت بقيام دول لاتينية في شرق البحر المتوسط وتنوع ردود القوى الإسلامية والتحالفات والصراعات الطويلة. ولا ينبغي عرضها كحرب واحدة متصلة أو كسرد أحادي الجانب.',
    ),
    startYearCe: 1095,
    endYearCe: 1291,
    certainty: HighMedievalHistoryCertainty.broadPeriod,
    caveat: LocalizedHistorySummary(
      tr: '1095–1291, seferler ve Levant’taki başlıca Latin siyasi varlıkları için geniş bir öğretici çerçevedir; farklı seferlerin amaçları, tarafları ve coğrafyaları birbirinden ayrılmalıdır.',
      en: '1095–1291 is a broad teaching frame for the expeditions and the principal Latin polities in the Levant; the aims, participants and geographies of individual crusades must be distinguished.',
      ar: 'يمثل 1095–1291 إطارًا تعليميًا واسعًا للحملات ولأبرز الكيانات اللاتينية في بلاد الشام؛ ويجب التمييز بين أهداف الحملات المختلفة وأطرافها ومجالاتها الجغرافية.',
    ),
    sourceIds: ['edde_bilad_al_sham_970_1260', 'hillenbrand_crusades_1999'],
    status: HistoryResearchStatus.researchDraft,
  ),
  HighMedievalHistoryEntry(
    id: 'ayyubid_egypt_syria',
    track: HighMedievalHistoryTrack.ayyubid,
    title: LocalizedHistorySummary(
      tr: 'Eyyûbîler: Mısır ve Suriye',
      en: 'Ayyubids in Egypt and Syria',
      ar: 'الأيوبيون في مصر والشام',
    ),
    summary: LocalizedHistorySummary(
      tr: 'Selâhaddin 1171’de Mısır’daki Fâtımî halifeliğine son verdi ve Eyyûbî hanedanı Mısır ile Suriye’de geniş bir siyasi ağ kurdu. Selâhaddin’in 1193’teki ölümünden sonra yönetim hanedan üyeleri arasında paylaşıldı; Mısır’daki Eyyûbî sultanlığı 1250’de Memlük iktidarına geçti.',
      en: 'Saladin ended the Fatimid caliphate in Egypt in 1171, and the Ayyubid dynasty built a broad political network across Egypt and Syria. After Saladin’s death in 1193, rule was divided among members of the dynasty; the Ayyubid sultanate in Egypt gave way to Mamluk rule in 1250.',
      ar: 'أنهى صلاح الدين الخلافة الفاطمية في مصر سنة 1171، وأقامت السلالة الأيوبية شبكة سياسية واسعة في مصر والشام. وبعد وفاة صلاح الدين سنة 1193 توزع الحكم بين أفراد السلالة، وانتهت السلطنة الأيوبية في مصر سنة 1250 مع انتقال السلطة إلى المماليك.',
    ),
    startYearCe: 1171,
    endYearCe: 1250,
    certainty: HighMedievalHistoryCertainty.establishedChronology,
    caveat: null,
    sourceIds: ['lev_fatimid_ayyubid_egypt', 'humphreys_ayyubids_damascus'],
    status: HistoryResearchStatus.researchDraft,
  ),
  HighMedievalHistoryEntry(
    id: 'mongol_invasions_islamic_lands',
    track: HighMedievalHistoryTrack.mongol,
    title: LocalizedHistorySummary(
      tr: 'Moğol İstilaları ve İslam Dünyası',
      en: 'Mongol Invasions and the Islamic World',
      ar: 'الغزوات المغولية والعالم الإسلامي',
    ),
    summary: LocalizedHistorySummary(
      tr: '13. yüzyıldaki Moğol genişlemesi Mâverâünnehir, Horasan, İran, Irak ve Suriye’nin siyasi düzenini derinden değiştirdi. 1258’de Bağdat’ın alınması Abbâsî halifeliğinin Bağdat’taki siyasi merkezini sona erdirdi; sonraki Moğol hanedanları ve İslam toplumları arasındaki ilişkiler ise fetih döneminden daha karmaşık bir gelişim gösterdi.',
      en: 'Mongol expansion in the thirteenth century profoundly changed the political order of Transoxiana, Khurasan, Iran, Iraq and Syria. The conquest of Baghdad in 1258 ended the Abbasid political centre there, while later relations between Mongol dynasties and Muslim societies developed in ways more complex than the initial conquests.',
      ar: 'غيّر التوسع المغولي في القرن الثالث عشر بعمق النظام السياسي في ما وراء النهر وخراسان وإيران والعراق والشام. وأنهى سقوط بغداد سنة 1258 المركز السياسي العباسي فيها، بينما تطورت العلاقات اللاحقة بين السلالات المغولية والمجتمعات الإسلامية بصورة أكثر تعقيدًا من مرحلة الفتوحات الأولى.',
    ),
    startYearCe: 1219,
    endYearCe: 1260,
    certainty: HighMedievalHistoryCertainty.broadPeriod,
    caveat: LocalizedHistorySummary(
      tr: '1219–1260 ilk büyük istila dalgalarını öğretici biçimde sınırlar; Moğol ve İlhanlı siyasi hâkimiyeti bu tarihte bütün bölgelerde sona ermiş değildir.',
      en: '1219–1260 bounds the major early invasion waves for teaching purposes; Mongol and Ilkhanid political rule did not end across all regions in 1260.',
      ar: 'يحدد نطاق 1219–1260 موجات الغزو الكبرى المبكرة لأغراض تعليمية؛ ولم ينته الحكم المغولي والإيلخاني في جميع المناطق سنة 1260.',
    ),
    sourceIds: ['jackson_mongols_islamic_world', 'biran_mongol_exchange_2015'],
    status: HistoryResearchStatus.researchDraft,
  ),
  HighMedievalHistoryEntry(
    id: 'mamluk_sultanate_egypt_syria',
    track: HighMedievalHistoryTrack.mamluk,
    title: LocalizedHistorySummary(
      tr: 'Memlük Sultanlığı',
      en: 'Mamluk Sultanate',
      ar: 'سلطنة المماليك',
    ),
    summary: LocalizedHistorySummary(
      tr: 'Memlükler 1250’de Mısır’da iktidarı ele geçirdi ve Suriye ile birlikte güçlü bir sultanlık kurdu. 1260 Ayn Câlût zaferi Moğol ilerleyişine karşı önemli bir dönüm noktası oldu; sultanlık 1517’de Osmanlı fethine kadar Mısır ve Suriye’nin başlıca siyasi gücü olarak sürdü.',
      en: 'The Mamluks took power in Egypt in 1250 and built a powerful sultanate spanning Egypt and Syria. The victory at Ayn Jalut in 1260 was an important turning point against Mongol advances; the sultanate remained the principal political power in Egypt and Syria until the Ottoman conquest in 1517.',
      ar: 'تولى المماليك السلطة في مصر سنة 1250 وأقاموا سلطنة قوية شملت مصر والشام. وكان انتصار عين جالوت سنة 1260 نقطة تحول مهمة في مواجهة التقدم المغولي، واستمرت السلطنة قوة سياسية رئيسية في مصر والشام حتى الفتح العثماني سنة 1517.',
    ),
    startYearCe: 1250,
    endYearCe: 1517,
    certainty: HighMedievalHistoryCertainty.establishedChronology,
    caveat: null,
    sourceIds: ['levanoni_mamluks_1250_1517', 'petry_mamluk_2022'],
    status: HistoryResearchStatus.researchDraft,
  ),
];

final highMedievalHistoryT0215 = HighMedievalHistoryDataset.validated(
  sources: highMedievalHistoryT0215Sources,
  entries: highMedievalHistoryT0215Entries,
);
