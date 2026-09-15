import 'pre_islam_world_context.dart';

enum EarlyModernEmpireTrack { ottoman, safavid, mughal }

enum EarlyModernHistoryCertainty {
  establishedChronology,
  broadPeriod,
  contestedInterpretation,
}

class EarlyModernHistoryResearchSource {
  const EarlyModernHistoryResearchSource({
    required this.locator,
    required this.workFamilyId,
  });

  final HistorySourceLocator locator;
  final String workFamilyId;
}

class EarlyModernEmpireEntry {
  const EarlyModernEmpireEntry({
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
  final EarlyModernEmpireTrack track;
  final LocalizedHistorySummary title;
  final LocalizedHistorySummary summary;
  final int startYearCe;
  final int endYearCe;
  final EarlyModernHistoryCertainty certainty;
  final LocalizedHistorySummary? caveat;
  final List<String> sourceIds;
  final HistoryResearchStatus status;
}

class EarlyModernEmpiresDataset {
  EarlyModernEmpiresDataset._({required this.sources, required this.entries});

  factory EarlyModernEmpiresDataset.validated({
    required List<EarlyModernHistoryResearchSource> sources,
    required List<EarlyModernEmpireEntry> entries,
  }) {
    if (sources.isEmpty || entries.isEmpty) {
      throw StateError('T0216 history research dataset must not be empty.');
    }

    final sourcesById = <String, EarlyModernHistoryResearchSource>{};
    for (final source in sources) {
      if (!source.locator.isComplete ||
          source.workFamilyId.trim().isEmpty ||
          sourcesById.containsKey(source.locator.id)) {
        throw StateError('T0216 sources must be unique and complete.');
      }
      sourcesById[source.locator.id] = source;
    }

    final ids = <String>{};
    final tracks = <EarlyModernEmpireTrack>{};
    final previousStartByTrack = <EarlyModernEmpireTrack, int>{};
    for (final entry in entries) {
      if (entry.id.trim().isEmpty ||
          !ids.add(entry.id) ||
          !entry.title.isComplete ||
          !entry.summary.isComplete ||
          entry.startYearCe > entry.endYearCe ||
          entry.sourceIds.toSet().length < 2 ||
          entry.sourceIds.any((id) => !sourcesById.containsKey(id))) {
        throw StateError('T0216 entry failed identity/content/date/source validation.');
      }

      final families = entry.sourceIds
          .map((id) => sourcesById[id]!.workFamilyId)
          .toSet();
      if (families.length < 2) {
        throw StateError(
          'T0216 entries require two independent academic work families.',
        );
      }

      if (entry.certainty != EarlyModernHistoryCertainty.establishedChronology &&
          (entry.caveat == null || !entry.caveat!.isComplete)) {
        throw StateError('Non-exact T0216 entries require TR/EN/AR caveats.');
      }

      final previousStart = previousStartByTrack[entry.track];
      if (previousStart != null && entry.startYearCe < previousStart) {
        throw StateError(
          'Chronology may overlap across empires but not run backwards inside a track.',
        );
      }
      previousStartByTrack[entry.track] = entry.startYearCe;
      tracks.add(entry.track);
    }

    final missingTracks = EarlyModernEmpireTrack.values.toSet().difference(tracks);
    if (missingTracks.isNotEmpty) {
      throw StateError('Missing required T0216 historical tracks: $missingTracks');
    }
    final missingEntries = requiredEntryIds.difference(ids);
    if (missingEntries.isNotEmpty) {
      throw StateError('Missing required T0216 entries: $missingEntries');
    }

    return EarlyModernEmpiresDataset._(
      sources: List.unmodifiable(sources),
      entries: List.unmodifiable(entries),
    );
  }

  static const Set<String> requiredEntryIds = {
    'ottoman_empire',
    'safavid_iran',
    'mughal_empire',
  };

  final List<EarlyModernHistoryResearchSource> sources;
  final List<EarlyModernEmpireEntry> entries;

  List<EarlyModernEmpireEntry> get productionEntries => List.unmodifiable(
        entries.where(
          (entry) => entry.status == HistoryResearchStatus.reviewedForProduction,
        ),
      );
}

const earlyModernEmpiresT0216Sources = <EarlyModernHistoryResearchSource>[
  EarlyModernHistoryResearchSource(
    workFamilyId: 'cambridge_history_turkey',
    locator: HistorySourceLocator(
      id: 'cambridge_history_turkey_v2',
      kind: HistorySourceKind.academicMonograph,
      citation: 'Suraiya N. Faroqhi and Kate Fleet (eds.), The Cambridge History of Turkey, Volume 2: The Ottoman Empire as a World Power, 1453–1603, Cambridge University Press, 2012.',
      locator: 'doi:10.1017/CHO9781139049047',
    ),
  ),
  EarlyModernHistoryResearchSource(
    workFamilyId: 'imber_ottoman_structure_power',
    locator: HistorySourceLocator(
      id: 'imber_ottoman_1300_1650',
      kind: HistorySourceKind.academicMonograph,
      citation: 'Colin Imber, The Ottoman Empire, 1300–1650: The Structure of Power, 3rd ed., Bloomsbury Academic, 2019.',
      locator: 'ISBN:9781352004137',
    ),
  ),
  EarlyModernHistoryResearchSource(
    workFamilyId: 'cambridge_history_iran_v6',
    locator: HistorySourceLocator(
      id: 'cambridge_history_iran_safavid',
      kind: HistorySourceKind.academicChapter,
      citation: 'The Safavid period, The Cambridge History of Iran, Volume 6, Cambridge University Press.',
      locator: 'Cambridge Core volume 5A33A1DB3F9C8F94837B52BE8D770EBA',
    ),
  ),
  EarlyModernHistoryResearchSource(
    workFamilyId: 'newman_safavid_iran',
    locator: HistorySourceLocator(
      id: 'newman_safavid_iran',
      kind: HistorySourceKind.academicMonograph,
      citation: 'Andrew J. Newman, Safavid Iran: Rebirth of a Persian Empire, I.B. Tauris, 2008.',
      locator: 'ISBN:9781845118303',
    ),
  ),
  EarlyModernHistoryResearchSource(
    workFamilyId: 'richards_mughal_empire',
    locator: HistorySourceLocator(
      id: 'richards_mughal_empire',
      kind: HistorySourceKind.academicMonograph,
      citation: 'John F. Richards, The Mughal Empire, The New Cambridge History of India, Cambridge University Press, 1993.',
      locator: 'doi:10.1017/CBO9780511584060',
    ),
  ),
  EarlyModernHistoryResearchSource(
    workFamilyId: 'asher_talbot_india_before_europe',
    locator: HistorySourceLocator(
      id: 'asher_talbot_india_before_europe',
      kind: HistorySourceKind.academicMonograph,
      citation: 'Catherine B. Asher and Cynthia Talbot, India before Europe, Cambridge University Press, 2006.',
      locator: 'doi:10.1017/CBO9780511808586',
    ),
  ),
];

const earlyModernEmpiresT0216Entries = <EarlyModernEmpireEntry>[
  EarlyModernEmpireEntry(
    id: 'ottoman_empire',
    track: EarlyModernEmpireTrack.ottoman,
    title: LocalizedHistorySummary(
      tr: 'Osmanlı İmparatorluğu',
      en: 'Ottoman Empire',
      ar: 'الدولة العثمانية',
    ),
    summary: LocalizedHistorySummary(
      tr: 'Osmanlı siyasi yapısı yaklaşık 1300 çevresinde kuzeybatı Anadolu’da ortaya çıktı, 15. ve 16. yüzyıllarda çok bölgeli bir imparatorluğa dönüştü ve Birinci Dünya Savaşı sonrasındaki çözülme sürecinde sona erdi. Tarih hattı kuruluş, genişleme, kurumlar, dönüşüm ve çözülmeyi tek bir değişmez “yükseliş-çöküş” kalıbına indirgemez.',
      en: 'The Ottoman polity emerged around 1300 in north-western Anatolia, developed into a multi-regional empire in the fifteenth and sixteenth centuries, and ended in the dissolution that followed the First World War. The timeline does not reduce its long history to a single unchanging rise-and-decline formula.',
      ar: 'ظهر الكيان السياسي العثماني نحو سنة 1300 في شمال غربي الأناضول، وتحوّل في القرنين الخامس عشر والسادس عشر إلى إمبراطورية متعددة الأقاليم، وانتهى في سياق التفكك الذي أعقب الحرب العالمية الأولى. ولا يختزل الخط الزمني تاريخه الطويل في قالب ثابت من «الصعود والانحدار».',
    ),
    startYearCe: 1300,
    endYearCe: 1922,
    certainty: EarlyModernHistoryCertainty.broadPeriod,
    caveat: LocalizedHistorySummary(
      tr: '1300 başlangıcı yaklaşık bir öğretici sınırdır; erken Osmanlı oluşumunun kesin kuruluş yılı konusunda tarih yazımında nüans vardır. 1922 ise saltanatın kaldırılmasını işaretler; imparatorluğun askerî ve siyasî çözülmesi daha uzun bir süreçtir.',
      en: 'The 1300 start is an approximate teaching boundary; scholarship is more nuanced than a single exact founding year for the early Ottoman polity. The year 1922 marks the abolition of the sultanate, while imperial military and political dissolution was a longer process.',
      ar: 'تمثل سنة 1300 حدًا تعليميًا تقريبيًا؛ فالدراسات التاريخية أكثر تعقيدًا من تحديد سنة تأسيس واحدة دقيقة للكيان العثماني المبكر. وتشير سنة 1922 إلى إلغاء السلطنة، بينما كان التفكك العسكري والسياسي للإمبراطورية عملية أطول.',
    ),
    sourceIds: ['cambridge_history_turkey_v2', 'imber_ottoman_1300_1650'],
    status: HistoryResearchStatus.researchDraft,
  ),
  EarlyModernEmpireEntry(
    id: 'safavid_iran',
    track: EarlyModernEmpireTrack.safavid,
    title: LocalizedHistorySummary(
      tr: 'Safevî İranı',
      en: 'Safavid Iran',
      ar: 'إيران الصفوية',
    ),
    summary: LocalizedHistorySummary(
      tr: 'Safevî hanedanı 1501’de Şah İsmail’in Tebriz’i ele geçirmesiyle İran’da yeni bir siyasi düzen kurdu. Hanedan döneminde On İki İmam Şiiliğinin devlet dini olarak yerleşmesi, Kızılbaş güçleri, merkezî kurumlar, Osmanlı-Safevî rekabeti ve Şah Abbas dönemindeki dönüşümler belirleyici başlıklardır.',
      en: 'The Safavid dynasty established a new political order in Iran after Shah Ismail captured Tabriz in 1501. The establishment of Twelver Shiism as the state religion, Qizilbash power, central institutions, Ottoman-Safavid rivalry and transformations under Shah Abbas are central themes of the period.',
      ar: 'أقامت السلالة الصفوية نظامًا سياسيًا جديدًا في إيران بعد استيلاء الشاه إسماعيل على تبريز سنة 1501. ومن أبرز سمات العصر ترسيخ التشيع الاثني عشري دينًا للدولة، ودور القزلباش، والمؤسسات المركزية، والتنافس العثماني الصفوي، والتحولات في عهد الشاه عباس.',
    ),
    startYearCe: 1501,
    endYearCe: 1736,
    certainty: EarlyModernHistoryCertainty.broadPeriod,
    caveat: LocalizedHistorySummary(
      tr: '1501 hanedan iktidarının İran’daki başlangıcı için güçlü bir sınırdır. 1722 İsfahan’ın düşüşü ve hanedan iktidarındaki kırılma açısından kritik olsa da Safevî hanedan çizgisinin sonlandırılması çoğu kronolojide 1736’daki Nâdir Şah tahta çıkışıyla verilir.',
      en: 'The year 1501 is a strong boundary for Safavid dynastic rule in Iran. Although 1722 is critical because of the fall of Isfahan and the rupture of dynastic power, many chronologies extend the Safavid dynastic line to Nadir Shah’s accession in 1736.',
      ar: 'تُعد سنة 1501 حدًا قويًا لبداية الحكم الصفوي في إيران. ومع أن سنة 1722 حاسمة بسبب سقوط أصفهان وانقطاع السلطة السلالية، فإن كثيرًا من التسلسلات التاريخية تمد الخط الصفوي حتى اعتلاء نادر شاه العرش سنة 1736.',
    ),
    sourceIds: ['cambridge_history_iran_safavid', 'newman_safavid_iran'],
    status: HistoryResearchStatus.researchDraft,
  ),
  EarlyModernEmpireEntry(
    id: 'mughal_empire',
    track: EarlyModernEmpireTrack.mughal,
    title: LocalizedHistorySummary(
      tr: 'Babür İmparatorluğu',
      en: 'Mughal Empire',
      ar: 'الإمبراطورية المغولية في الهند',
    ),
    summary: LocalizedHistorySummary(
      tr: 'Babür’ün 1526’daki Panipat zaferiyle kurduğu hanedan devleti, 16. ve 17. yüzyıllarda Hint alt kıtasının büyük bölümünü kapsayan güçlü bir imparatorluğa dönüştü. Yönetim, vergi düzeni, saray kültürü, bölgesel toplumlarla ilişkiler ve 18. yüzyıldaki siyasî parçalanma birlikte ele alınmalıdır.',
      en: 'The dynastic state founded by Babur after the victory at Panipat in 1526 developed into a powerful empire covering much of the Indian subcontinent in the sixteenth and seventeenth centuries. Administration, revenue systems, court culture, relations with regional societies and eighteenth-century political fragmentation must be considered together.',
      ar: 'تحولت الدولة السلالية التي أسسها بابر بعد انتصاره في بانيبات سنة 1526 إلى إمبراطورية قوية شملت أجزاء واسعة من شبه القارة الهندية في القرنين السادس عشر والسابع عشر. وينبغي تناول الإدارة ونظام الإيرادات وثقافة البلاط والعلاقات مع المجتمعات الإقليمية والتفكك السياسي في القرن الثامن عشر معًا.',
    ),
    startYearCe: 1526,
    endYearCe: 1858,
    certainty: EarlyModernHistoryCertainty.broadPeriod,
    caveat: LocalizedHistorySummary(
      tr: '1526 hanedan kuruluşu için temel tarihtir; 18. yüzyılda merkezî güç büyük ölçüde zayıfladığı için 1858’e kadar olan süre kesintisiz aynı siyasî kapasite anlamına gelmez. 1858, Britanya yönetiminin son Babür hükümdarını resmen tasfiye ettiği hukuki-siyasî sonu gösterir.',
      en: 'The year 1526 is the principal dynastic starting point, but central power weakened greatly in the eighteenth century, so continuity to 1858 does not imply unchanged political capacity. The year 1858 marks the formal political-legal end under British rule after the last Mughal emperor was deposed.',
      ar: 'تُعد سنة 1526 نقطة البداية السلالية الأساسية، لكن السلطة المركزية ضعفت كثيرًا في القرن الثامن عشر، لذلك لا تعني الاستمرارية حتى 1858 بقاء القدرة السياسية نفسها. وتشير سنة 1858 إلى النهاية السياسية والقانونية الرسمية في ظل الحكم البريطاني بعد عزل آخر أباطرة المغول.',
    ),
    sourceIds: ['richards_mughal_empire', 'asher_talbot_india_before_europe'],
    status: HistoryResearchStatus.researchDraft,
  ),
];

final earlyModernEmpiresT0216 = EarlyModernEmpiresDataset.validated(
  sources: earlyModernEmpiresT0216Sources,
  entries: earlyModernEmpiresT0216Entries,
);
