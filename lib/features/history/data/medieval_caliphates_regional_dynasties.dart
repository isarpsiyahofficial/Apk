import 'pre_islam_world_context.dart';

enum MedievalHistoryTrack {
  umayyad,
  abbasid,
  alAndalus,
  fatimid,
  regionalDynasties,
}

enum MedievalHistoryCertainty {
  establishedChronology,
  broadPeriod,
  contestedInterpretation,
}

class MedievalHistoryResearchSource {
  const MedievalHistoryResearchSource({
    required this.locator,
    required this.workFamilyId,
  });

  final HistorySourceLocator locator;
  final String workFamilyId;
}

class MedievalHistoryEntry {
  const MedievalHistoryEntry({
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
  final MedievalHistoryTrack track;
  final LocalizedHistorySummary title;
  final LocalizedHistorySummary summary;
  final int startYearCe;
  final int endYearCe;
  final MedievalHistoryCertainty certainty;
  final LocalizedHistorySummary? caveat;
  final List<String> sourceIds;
  final HistoryResearchStatus status;
}

class MedievalHistoryDataset {
  MedievalHistoryDataset._({
    required this.sources,
    required this.entries,
  });

  factory MedievalHistoryDataset.validated({
    required List<MedievalHistoryResearchSource> sources,
    required List<MedievalHistoryEntry> entries,
  }) {
    if (sources.isEmpty || entries.isEmpty) {
      throw StateError('T0214 history research dataset must not be empty.');
    }

    final sourcesById = <String, MedievalHistoryResearchSource>{};
    for (final source in sources) {
      if (!source.locator.isComplete ||
          source.workFamilyId.trim().isEmpty ||
          sourcesById.containsKey(source.locator.id)) {
        throw StateError('T0214 sources must be unique and complete.');
      }
      sourcesById[source.locator.id] = source;
    }

    final entryIds = <String>{};
    final tracks = <MedievalHistoryTrack>{};
    final previousStartByTrack = <MedievalHistoryTrack, int>{};

    for (final entry in entries) {
      if (entry.id.trim().isEmpty ||
          !entryIds.add(entry.id) ||
          !entry.title.isComplete ||
          !entry.summary.isComplete ||
          entry.startYearCe > entry.endYearCe ||
          entry.sourceIds.toSet().length < 2 ||
          entry.sourceIds.any((sourceId) => !sourcesById.containsKey(sourceId))) {
        throw StateError('T0214 entry failed identity/content/date/source validation.');
      }

      final sourceFamilies = entry.sourceIds
          .map((sourceId) => sourcesById[sourceId]!.workFamilyId)
          .toSet();
      if (sourceFamilies.length < 2) {
        throw StateError('T0214 entries require two independent academic work families.');
      }

      if (entry.certainty != MedievalHistoryCertainty.establishedChronology &&
          (entry.caveat == null || !entry.caveat!.isComplete)) {
        throw StateError('Non-exact T0214 entries require TR/EN/AR caveats.');
      }

      final previousStart = previousStartByTrack[entry.track];
      if (previousStart != null && entry.startYearCe < previousStart) {
        throw StateError('Chronology may overlap across tracks but not run backwards inside a track.');
      }
      previousStartByTrack[entry.track] = entry.startYearCe;
      tracks.add(entry.track);
    }

    final missingTracks = MedievalHistoryTrack.values.toSet().difference(tracks);
    if (missingTracks.isNotEmpty) {
      throw StateError('Missing required T0214 historical tracks: $missingTracks');
    }

    final missingEntries = requiredEntryIds.difference(entryIds);
    if (missingEntries.isNotEmpty) {
      throw StateError('Missing required T0214 entries: $missingEntries');
    }

    return MedievalHistoryDataset._(
      sources: List.unmodifiable(sources),
      entries: List.unmodifiable(entries),
    );
  }

  static const Set<String> requiredEntryIds = {
    'umayyad_caliphate',
    'abbasid_caliphate',
    'umayyad_al_andalus',
    'fatimid_caliphate',
    'samanid_regional_power',
    'buyid_regional_power',
  };

  final List<MedievalHistoryResearchSource> sources;
  final List<MedievalHistoryEntry> entries;

  List<MedievalHistoryEntry> get productionEntries => List.unmodifiable(
        entries.where(
          (entry) => entry.status == HistoryResearchStatus.reviewedForProduction,
        ),
      );
}

const medievalHistoryT0214Sources = <MedievalHistoryResearchSource>[
  MedievalHistoryResearchSource(
    workFamilyId: 'cambridge_history_strategy_kader',
    locator: HistorySourceLocator(
      id: 'kader_caliphates_2025',
      kind: HistorySourceKind.academicChapter,
      citation: 'Mehdi Kurgan Kader, “The Rashidun, Umayyad (661–750) and Abbasid (750–1258) Caliphates”, The Cambridge History of Strategy, Cambridge University Press, 2025.',
      locator: 'doi:10.1017/9781108788090.012',
    ),
  ),
  MedievalHistoryResearchSource(
    workFamilyId: 'marsham_umayyad_empire',
    locator: HistorySourceLocator(
      id: 'marsham_umayyad_empire_2024',
      kind: HistorySourceKind.academicMonograph,
      citation: 'Andrew Marsham, The Umayyad Empire, Edinburgh University Press, 2024.',
      locator: 'Cambridge Core ISBN 9780748643011',
    ),
  ),
  MedievalHistoryResearchSource(
    workFamilyId: 'el_hibri_abbasid_caliphate',
    locator: HistorySourceLocator(
      id: 'el_hibri_abbasid_2021',
      kind: HistorySourceKind.academicMonograph,
      citation: 'Tayeb El-Hibri, The Abbasid Caliphate: A History, Cambridge University Press, 2021.',
      locator: 'doi:10.1017/9781316869567',
    ),
  ),
  MedievalHistoryResearchSource(
    workFamilyId: 'lapidus_islamic_societies',
    locator: HistorySourceLocator(
      id: 'lapidus_post_abbasid_states',
      kind: HistorySourceKind.academicChapter,
      citation: 'Ira M. Lapidus, “The Post-ʿAbbasid Middle Eastern State System”, Islamic Societies to the Nineteenth Century, Cambridge University Press.',
      locator: 'Cambridge Core chapter 20; book doi:10.1017/CBO9781139048828',
    ),
  ),
  MedievalHistoryResearchSource(
    workFamilyId: 'safran_andalus_legitimacy',
    locator: HistorySourceLocator(
      id: 'safran_al_andalus_2009',
      kind: HistorySourceKind.peerReviewedArticle,
      citation: 'Janina Safran, “The Command of the Faithful in al-Andalus: A Study in the Articulation of Caliphal Legitimacy”, International Journal of Middle East Studies.',
      locator: 'Cambridge Core article FB088A7AE8F9B3F978F0FF543D9D216A',
    ),
  ),
  MedievalHistoryResearchSource(
    workFamilyId: 'manzano_court_andalus',
    locator: HistorySourceLocator(
      id: 'manzano_al_andalus_2023',
      kind: HistorySourceKind.academicMonograph,
      citation: 'Eduardo Manzano Moreno, The Court of the Caliphate of al-Andalus: Four Years in Umayyad Córdoba, Edinburgh University Press, 2023.',
      locator: 'doi:10.3366/edinburgh/9781399516129.001.0001',
    ),
  ),
  MedievalHistoryResearchSource(
    workFamilyId: 'baker_fatimid_north_africa',
    locator: HistorySourceLocator(
      id: 'baker_fatimid_2018',
      kind: HistorySourceKind.peerReviewedArticle,
      citation: 'Christine D. Baker, “Ismaili and Fatimid North Africa”, Oxford Research Encyclopedia of African History, Oxford University Press, 2018.',
      locator: 'doi:10.1093/acrefore/9780190277734.013.327',
    ),
  ),
  MedievalHistoryResearchSource(
    workFamilyId: 'brett_realm_fatimid',
    locator: HistorySourceLocator(
      id: 'brett_fatimid_realm',
      kind: HistorySourceKind.peerReviewedArticle,
      citation: 'Michael Brett, “The Realm of the Imām: the Fāṭīmids in the tenth century”, Bulletin of the School of Oriental and African Studies.',
      locator: 'Cambridge Core article 5DB0C6427B69468A4DD429A231111045',
    ),
  ),
  MedievalHistoryResearchSource(
    workFamilyId: 'cambridge_history_iran_samanids',
    locator: HistorySourceLocator(
      id: 'frye_samanids',
      kind: HistorySourceKind.academicChapter,
      citation: 'R. N. Frye, “The Samanids”, The Cambridge History of Iran, Cambridge University Press.',
      locator: 'doi:10.1017/CHOL9780521200936.005',
    ),
  ),
  MedievalHistoryResearchSource(
    workFamilyId: 'cambridge_history_iran_buyids',
    locator: HistorySourceLocator(
      id: 'busse_buyids',
      kind: HistorySourceKind.academicChapter,
      citation: 'Heribert Busse, “Iran under the Buyids”, The Cambridge History of Iran, Cambridge University Press.',
      locator: 'doi:10.1017/CHOL9780521200936.008',
    ),
  ),
];

const medievalHistoryT0214Entries = <MedievalHistoryEntry>[
  MedievalHistoryEntry(
    id: 'umayyad_caliphate',
    track: MedievalHistoryTrack.umayyad,
    title: LocalizedHistorySummary(
      tr: 'Emevî Halifeliği',
      en: 'Umayyad Caliphate',
      ar: 'الخلافة الأموية',
    ),
    summary: LocalizedHistorySummary(
      tr: '661’de Muâviye’nin halifeliğiyle Şam merkezli Emevî hanedan yönetimi başladı. Halifelik geniş bir imparatorluk ölçeğine ulaştı; iç siyasi gerilimler ve Abbâsî hareketinin yükselişi 750’de merkezî Emevî yönetiminin sona ermesiyle sonuçlandı.',
      en: 'With Muʿawiya’s caliphate in 661, Umayyad dynastic rule centred on Damascus began. The caliphate grew to imperial scale; internal political tensions and the rise of the Abbasid movement culminated in the end of central Umayyad rule in 750.',
      ar: 'بدأ الحكم الأموي السلالي المتمركز في دمشق مع خلافة معاوية سنة 661. واتسعت الخلافة إلى نطاق إمبراطوري، ثم انتهى الحكم الأموي المركزي سنة 750 في سياق توترات سياسية داخلية وصعود الحركة العباسية.',
    ),
    startYearCe: 661,
    endYearCe: 750,
    certainty: MedievalHistoryCertainty.establishedChronology,
    caveat: null,
    sourceIds: <String>[
      'kader_caliphates_2025',
      'marsham_umayyad_empire_2024',
    ],
    status: HistoryResearchStatus.researchDraft,
  ),
  MedievalHistoryEntry(
    id: 'abbasid_caliphate',
    track: MedievalHistoryTrack.abbasid,
    title: LocalizedHistorySummary(
      tr: 'Abbâsî Halifeliği',
      en: 'Abbasid Caliphate',
      ar: 'الخلافة العباسية',
    ),
    summary: LocalizedHistorySummary(
      tr: 'Abbâsîler 750’de iktidarı ele geçirdi; Bağdat 762’de yeni başkent olarak kuruldu. Halifeliğin doğrudan siyasi hâkimiyeti zamanla parçalanırken kurum ve hanedan Bağdat’ın 1258’de Moğollar tarafından alınmasına kadar varlığını sürdürdü.',
      en: 'The Abbasids took power in 750, and Baghdad was founded as the new capital in 762. Direct caliphal political control fragmented over time, while the institution and dynasty endured until the Mongol conquest of Baghdad in 1258.',
      ar: 'تولى العباسيون السلطة سنة 750، وأُسست بغداد عاصمة جديدة سنة 762. ومع مرور الزمن تفتتت السيطرة السياسية المباشرة للخلافة، بينما استمرت المؤسسة والسلالة حتى استيلاء المغول على بغداد سنة 1258.',
    ),
    startYearCe: 750,
    endYearCe: 1258,
    certainty: MedievalHistoryCertainty.establishedChronology,
    caveat: null,
    sourceIds: <String>[
      'kader_caliphates_2025',
      'el_hibri_abbasid_2021',
    ],
    status: HistoryResearchStatus.researchDraft,
  ),
  MedievalHistoryEntry(
    id: 'umayyad_al_andalus',
    track: MedievalHistoryTrack.alAndalus,
    title: LocalizedHistorySummary(
      tr: 'Endülüs Emevî Yönetimi',
      en: 'Umayyad Rule in al-Andalus',
      ar: 'الحكم الأموي في الأندلس',
    ),
    summary: LocalizedHistorySummary(
      tr: 'Endülüs’te bağımsız Emevî emirliği 756’da Kurtuba merkezli olarak kuruldu. III. Abdurrahman 929’da halife unvanını ilan etti; Kurtuba Emevî halifeliği 1031’de sona erdi.',
      en: 'An independent Umayyad emirate was established in al-Andalus in 756 with Córdoba as its centre. Abd al-Rahman III assumed the caliphal title in 929, and the Umayyad caliphate of Córdoba ended in 1031.',
      ar: 'تأسست إمارة أموية مستقلة في الأندلس سنة 756 واتخذت قرطبة مركزًا لها. واتخذ عبد الرحمن الثالث لقب الخليفة سنة 929، وانتهت الخلافة الأموية في قرطبة سنة 1031.',
    ),
    startYearCe: 756,
    endYearCe: 1031,
    certainty: MedievalHistoryCertainty.establishedChronology,
    caveat: null,
    sourceIds: <String>[
      'safran_al_andalus_2009',
      'manzano_al_andalus_2023',
    ],
    status: HistoryResearchStatus.researchDraft,
  ),
  MedievalHistoryEntry(
    id: 'samanid_regional_power',
    track: MedievalHistoryTrack.regionalDynasties,
    title: LocalizedHistorySummary(
      tr: 'Sâmânîler',
      en: 'Samanids',
      ar: 'السامانيون',
    ),
    summary: LocalizedHistorySummary(
      tr: 'Sâmânî hanedanı dokuzuncu ve onuncu yüzyıllarda Mâverâünnehir ile Horasan’ın önemli bölgesel güçlerinden biri oldu. Yükselişi, Abbâsî dünyasında siyasi yetkinin tek merkezden farklı hanedanlara doğru dağılmasının örneklerinden biridir.',
      en: 'The Samanid dynasty became a major regional power in Transoxiana and Khurasan during the ninth and tenth centuries. Its rise illustrates the redistribution of political authority from a single Abbasid centre toward regional dynasties.',
      ar: 'أصبحت السلالة السامانية قوة إقليمية مهمة في ما وراء النهر وخراسان خلال القرنين التاسع والعاشر. ويُظهر صعودها انتقال جانب من السلطة السياسية في العالم العباسي من مركز واحد إلى سلالات إقليمية.',
    ),
    startYearCe: 819,
    endYearCe: 999,
    certainty: MedievalHistoryCertainty.broadPeriod,
    caveat: LocalizedHistorySummary(
      tr: 'Başlangıç ve hâkimiyet sınırları bölgeye ve kullanılan siyasi ölçüte göre farklı tarihlendirilebilir; 819–999 bu modülde genel hanedan çerçevesi olarak kullanılır.',
      en: 'The beginning and effective boundaries of Samanid rule can be periodized differently by region and political criterion; 819–999 is used here as a broad dynastic frame.',
      ar: 'قد تختلف بداية الحكم الساماني وحدوده الفعلية بحسب المنطقة والمعيار السياسي؛ وتُستخدم هنا مدة 819–999 بوصفها إطارًا سلاليًا عامًا.',
    ),
    sourceIds: <String>[
      'frye_samanids',
      'lapidus_post_abbasid_states',
    ],
    status: HistoryResearchStatus.researchDraft,
  ),
  MedievalHistoryEntry(
    id: 'buyid_regional_power',
    track: MedievalHistoryTrack.regionalDynasties,
    title: LocalizedHistorySummary(
      tr: 'Büveyhîler',
      en: 'Buyids',
      ar: 'البويهيون',
    ),
    summary: LocalizedHistorySummary(
      tr: 'Büveyhîler onuncu yüzyılda İran ve Irak’ta önemli bir bölgesel güç hâline geldi ve 945’ten itibaren Bağdat’ta fiilî siyasi üstünlük kurdu. Abbâsî halifeliği ise dinî ve sembolik bir kurum olarak varlığını sürdürdü.',
      en: 'The Buyids became a major regional power in Iran and Iraq in the tenth century and established effective political dominance in Baghdad from 945, while the Abbasid caliphate continued as a religious and symbolic institution.',
      ar: 'أصبح البويهيون قوة إقليمية مهمة في إيران والعراق في القرن العاشر، وفرضوا نفوذًا سياسيًا فعليًا في بغداد منذ سنة 945، بينما استمرت الخلافة العباسية مؤسسة دينية ورمزية.',
    ),
    startYearCe: 932,
    endYearCe: 1062,
    certainty: MedievalHistoryCertainty.broadPeriod,
    caveat: LocalizedHistorySummary(
      tr: 'Büveyhî hâkimiyetinin başlangıç ve bitiş tarihleri farklı bölgelerde aynı değildir; 932–1062 burada hanedanın genel siyasi dönemi için yaklaşık çerçeve olarak kullanılır.',
      en: 'The beginning and end of Buyid authority were not identical in every region; 932–1062 is used here as a broad frame for the dynasty’s political period.',
      ar: 'لم تبدأ سلطة البويهيين وتنتهِ في التاريخ نفسه في جميع المناطق؛ وتُستخدم مدة 932–1062 هنا بوصفها إطارًا عامًا تقريبيًا لفترة السلالة السياسية.',
    ),
    sourceIds: <String>[
      'busse_buyids',
      'lapidus_post_abbasid_states',
    ],
    status: HistoryResearchStatus.researchDraft,
  ),
  MedievalHistoryEntry(
    id: 'fatimid_caliphate',
    track: MedievalHistoryTrack.fatimid,
    title: LocalizedHistorySummary(
      tr: 'Fâtımî Halifeliği',
      en: 'Fatimid Caliphate',
      ar: 'الخلافة الفاطمية',
    ),
    summary: LocalizedHistorySummary(
      tr: 'İsmâilî Şiî Fâtımî hanedanı 909’da Kuzey Afrika’da halifelik ilan etti. 969’da Mısır’ı ele geçirip Kahire’yi merkez hâline getirdi; Abbâsî halifeliğine rakip bir siyasal-dinî merkez olarak 1171’e kadar varlığını sürdürdü.',
      en: 'The Ismaili Shiʿi Fatimid dynasty proclaimed a caliphate in North Africa in 909. It conquered Egypt in 969 and made Cairo its centre, continuing until 1171 as a political-religious rival to the Abbasid caliphate.',
      ar: 'أعلنت السلالة الفاطمية الإسماعيلية الشيعية خلافة في شمال أفريقيا سنة 909. واستولت على مصر سنة 969 واتخذت القاهرة مركزًا لها، واستمرت حتى سنة 1171 بوصفها مركزًا سياسيًا ودينيًا منافسًا للخلافة العباسية.',
    ),
    startYearCe: 909,
    endYearCe: 1171,
    certainty: MedievalHistoryCertainty.establishedChronology,
    caveat: null,
    sourceIds: <String>[
      'baker_fatimid_2018',
      'brett_fatimid_realm',
    ],
    status: HistoryResearchStatus.researchDraft,
  ),
];

final medievalHistoryT0214 = MedievalHistoryDataset.validated(
  sources: medievalHistoryT0214Sources,
  entries: medievalHistoryT0214Entries,
);
