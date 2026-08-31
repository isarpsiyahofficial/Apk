import 'pre_islam_world_context.dart';

enum RegionalIslamicHistoryTrack {
  africa,
  centralAsia,
  southeastAsia,
  indianSubcontinent,
  europe,
}

enum RegionalIslamicHistoryCertainty { broadPeriod, contestedInterpretation }

class RegionalHistoryResearchSource {
  const RegionalHistoryResearchSource({
    required this.locator,
    required this.workFamilyId,
  });

  final HistorySourceLocator locator;
  final String workFamilyId;
}

class RegionalIslamicHistoryEntry {
  const RegionalIslamicHistoryEntry({
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
  final RegionalIslamicHistoryTrack track;
  final LocalizedHistorySummary title;
  final LocalizedHistorySummary summary;
  final int startYearCe;
  final int endYearCe;
  final RegionalIslamicHistoryCertainty certainty;
  final LocalizedHistorySummary caveat;
  final List<String> sourceIds;
  final HistoryResearchStatus status;
}

class RegionalIslamicHistoriesDataset {
  RegionalIslamicHistoriesDataset._({required this.sources, required this.entries});

  factory RegionalIslamicHistoriesDataset.validated({
    required List<RegionalHistoryResearchSource> sources,
    required List<RegionalIslamicHistoryEntry> entries,
  }) {
    if (sources.isEmpty || entries.isEmpty) {
      throw StateError('T0217 regional history dataset must not be empty.');
    }

    final sourcesById = <String, RegionalHistoryResearchSource>{};
    for (final source in sources) {
      if (!source.locator.isComplete ||
          source.workFamilyId.trim().isEmpty ||
          sourcesById.containsKey(source.locator.id)) {
        throw StateError('T0217 sources must be unique and complete.');
      }
      sourcesById[source.locator.id] = source;
    }

    final ids = <String>{};
    final tracks = <RegionalIslamicHistoryTrack>{};
    final previousStartByTrack = <RegionalIslamicHistoryTrack, int>{};
    for (final entry in entries) {
      if (entry.id.trim().isEmpty ||
          !ids.add(entry.id) ||
          !entry.title.isComplete ||
          !entry.summary.isComplete ||
          !entry.caveat.isComplete ||
          entry.startYearCe > entry.endYearCe ||
          entry.sourceIds.toSet().length < 2 ||
          entry.sourceIds.any((id) => !sourcesById.containsKey(id))) {
        throw StateError('T0217 entry failed identity/content/date/source validation.');
      }

      final families = entry.sourceIds
          .map((id) => sourcesById[id]!.workFamilyId)
          .toSet();
      if (families.length < 2) {
        throw StateError('T0217 entries require two independent academic work families.');
      }

      final previousStart = previousStartByTrack[entry.track];
      if (previousStart != null && entry.startYearCe < previousStart) {
        throw StateError('Regional tracks may overlap, but chronology cannot run backwards inside one track.');
      }
      previousStartByTrack[entry.track] = entry.startYearCe;
      tracks.add(entry.track);
    }

    final missingTracks = RegionalIslamicHistoryTrack.values.toSet().difference(tracks);
    if (missingTracks.isNotEmpty) {
      throw StateError('Missing required T0217 regional tracks: $missingTracks');
    }
    final missingEntries = requiredEntryIds.difference(ids);
    if (missingEntries.isNotEmpty) {
      throw StateError('Missing required T0217 entries: $missingEntries');
    }

    return RegionalIslamicHistoriesDataset._(
      sources: List.unmodifiable(sources),
      entries: List.unmodifiable(entries),
    );
  }

  static const Set<String> requiredEntryIds = {
    'africa_islamic_history',
    'central_asia_islamic_history',
    'southeast_asia_islamic_history',
    'indian_subcontinent_islamic_history',
    'europe_islamic_history',
  };

  final List<RegionalHistoryResearchSource> sources;
  final List<RegionalIslamicHistoryEntry> entries;

  List<RegionalIslamicHistoryEntry> get productionEntries => List.unmodifiable(
        entries.where((entry) => entry.status == HistoryResearchStatus.reviewedForProduction),
      );
}

const regionalIslamicHistoriesT0217Sources = <RegionalHistoryResearchSource>[
  RegionalHistoryResearchSource(
    workFamilyId: 'robinson_muslim_societies_africa',
    locator: HistorySourceLocator(
      id: 'robinson_muslim_societies_africa',
      kind: HistorySourceKind.academicMonograph,
      citation: 'David Robinson, Muslim Societies in African History, Cambridge University Press, 2004.',
      locator: 'doi:10.1017/CBO9780511811746',
    ),
  ),
  RegionalHistoryResearchSource(
    workFamilyId: 'lapidus_history_islamic_societies',
    locator: HistorySourceLocator(
      id: 'lapidus_west_africa',
      kind: HistorySourceKind.academicChapter,
      citation: 'Ira M. Lapidus, “Islam in West Africa”, A History of Islamic Societies, 3rd ed., Cambridge University Press, 2014.',
      locator: 'book-doi:10.1017/CBO9781139048828',
    ),
  ),
  RegionalHistoryResearchSource(
    workFamilyId: 'tor_islamization_central_asia',
    locator: HistorySourceLocator(
      id: 'tor_samanid_islamization',
      kind: HistorySourceKind.peerReviewedArticle,
      citation: 'D. G. Tor, “The Islamization of Central Asia in the Sāmānid era and the reshaping of the Muslim world”, Bulletin of the School of Oriental and African Studies, 2009.',
      locator: 'Cambridge Core article F6CA6EE366B2F69F3D215CB14A072F0F',
    ),
  ),
  RegionalHistoryResearchSource(
    workFamilyId: 'formichi_islam_and_asia',
    locator: HistorySourceLocator(
      id: 'formichi_islam_across_oxus',
      kind: HistorySourceKind.academicMonograph,
      citation: 'Chiara Formichi, Islam and Asia: A History, Cambridge University Press, 2020.',
      locator: 'Cambridge Core book CDAB63D89D04F13A8BA1379B6DCFB1CC',
    ),
  ),
  RegionalHistoryResearchSource(
    workFamilyId: 'lapidus_history_islamic_societies',
    locator: HistorySourceLocator(
      id: 'lapidus_southeast_asia',
      kind: HistorySourceKind.academicChapter,
      citation: 'Ira M. Lapidus, “Islam in Southeast Asia: Indonesia, Malaysia, and the Philippines”, A History of Islamic Societies, 3rd ed., Cambridge University Press, 2014.',
      locator: 'book-doi:10.1017/CBO9781139048828; chapter 55',
    ),
  ),
  RegionalHistoryResearchSource(
    workFamilyId: 'feener_monsoon_asia_conversion',
    locator: HistorySourceLocator(
      id: 'feener_muslim_circulations_monsoon_asia',
      kind: HistorySourceKind.academicChapter,
      citation: 'R. Michael Feener, “Muslim Circulations and Islamic Conversion in Monsoon Asia”, in Monsoon Asia, Amsterdam University Press, 2023.',
      locator: 'doi:10.1017/9789400604360.009',
    ),
  ),
  RegionalHistoryResearchSource(
    workFamilyId: 'wink_indo_islamic_world',
    locator: HistorySourceLocator(
      id: 'wink_medieval_india_rise_islam',
      kind: HistorySourceKind.academicChapter,
      citation: 'André Wink, “Medieval India and the Rise of Islam”, The Making of the Indo-Islamic World, Cambridge University Press, 2020.',
      locator: 'doi:10.1017/9781108278287.006',
    ),
  ),
  RegionalHistoryResearchSource(
    workFamilyId: 'lapidus_islamic_societies_nineteenth',
    locator: HistorySourceLocator(
      id: 'lapidus_indian_subcontinent',
      kind: HistorySourceKind.academicChapter,
      citation: 'Ira M. Lapidus, “The Indian Subcontinent: The Delhi Sultanates and the Mughal Empire”, Islamic Societies to the Nineteenth Century, Cambridge University Press, 2012.',
      locator: 'Cambridge Core chapter 5746D6AA9CCB455C519E5F611ED98267',
    ),
  ),
  RegionalHistoryResearchSource(
    workFamilyId: 'berger_islam_europe',
    locator: HistorySourceLocator(
      id: 'berger_brief_history_islam_europe',
      kind: HistorySourceKind.academicMonograph,
      citation: 'Maurits S. Berger, A Brief History of Islam in Europe: Thirteen Centuries of Creed, Conflict and Coexistence, Leiden University Press, 2014.',
      locator: 'ISBN:9789087281953; doi:10.1017/9789400601505',
    ),
  ),
  RegionalHistoryResearchSource(
    workFamilyId: 'new_cambridge_history_islam_v6',
    locator: HistorySourceLocator(
      id: 'nchi_muslims_west_europe',
      kind: HistorySourceKind.academicChapter,
      citation: '“Muslims in the West: Europe”, The New Cambridge History of Islam, Volume 6, Cambridge University Press, 2010.',
      locator: 'Cambridge Core chapter B724D75D8A60F28F516977AB38CAD71D',
    ),
  ),
];

const regionalIslamicHistoriesT0217Entries = <RegionalIslamicHistoryEntry>[
  RegionalIslamicHistoryEntry(
    id: 'africa_islamic_history',
    track: RegionalIslamicHistoryTrack.africa,
    title: LocalizedHistorySummary(tr: 'Afrika’da İslam tarihi', en: 'Islamic history in Africa', ar: 'تاريخ الإسلام في أفريقيا'),
    summary: LocalizedHistorySummary(
      tr: 'Afrika’daki İslam tarihi tek bir fetih çizgisine indirgenemez. Kuzey, Batı ve Doğu Afrika’da devletler, ticaret ağları, âlimler, göçler, tasavvufî çevreler ve yerel toplumlarla uzun süreli etkileşimler farklı zamanlarda farklı biçimler oluşturdu.',
      en: 'Islamic history in Africa cannot be reduced to a single line of conquest. Across North, West and East Africa, states, trade networks, scholars, migration, Sufi communities and long interaction with local societies produced different regional trajectories at different times.',
      ar: 'لا يمكن اختزال تاريخ الإسلام في أفريقيا في مسار واحد للفتح. فقد صنعت الدول وشبكات التجارة والعلماء والهجرات والطرق الصوفية والتفاعلات الطويلة مع المجتمعات المحلية مسارات إقليمية متعددة في شمال أفريقيا وغربها وشرقها.',
    ),
    startYearCe: 615,
    endYearCe: 1800,
    certainty: RegionalIslamicHistoryCertainty.broadPeriod,
    caveat: LocalizedHistorySummary(
      tr: '615, Habeşistan hicreti nedeniyle erken bir temas sınırıdır; kıta çapında İslamlaşmanın başlangıç veya tamamlanma yılı değildir. Bölgelere göre süreçler yüzyıllara yayılmıştır.',
      en: 'The year 615 is an early-contact boundary because of the migration to Abyssinia; it is not a continent-wide start or completion date for Islamization. Regional processes unfolded over centuries.',
      ar: 'تمثل سنة 615 حدًا مبكرًا للاتصال بسبب الهجرة إلى الحبشة، وليست تاريخًا موحدًا لبدء أسلمة القارة أو اكتمالها. فقد امتدت العمليات الإقليمية عبر قرون.',
    ),
    sourceIds: ['robinson_muslim_societies_africa', 'lapidus_west_africa'],
    status: HistoryResearchStatus.researchDraft,
  ),
  RegionalIslamicHistoryEntry(
    id: 'central_asia_islamic_history',
    track: RegionalIslamicHistoryTrack.centralAsia,
    title: LocalizedHistorySummary(tr: 'Orta Asya’da İslam tarihi', en: 'Islamic history in Central Asia', ar: 'تاريخ الإسلام في آسيا الوسطى'),
    summary: LocalizedHistorySummary(
      tr: 'Orta Asya’da İslamın yayılması erken fetihler, Sâmânî dönemi, şehirli Farsça kültürler, Türk topluluklarının dönüşümü, ticaret ve ilmî ağlar üzerinden uzun ve çok katmanlı bir süreçti.',
      en: 'The spread of Islam in Central Asia was a long, layered process involving early conquests, the Samanid period, urban Persianate cultures, transformations among Turkic peoples, trade and scholarly networks.',
      ar: 'كان انتشار الإسلام في آسيا الوسطى عملية طويلة ومتعددة الطبقات شملت الفتوحات المبكرة والعصر الساماني والثقافات الحضرية الفارسية وتحولات المجتمعات التركية وشبكات التجارة والعلم.',
    ),
    startYearCe: 700,
    endYearCe: 1800,
    certainty: RegionalIslamicHistoryCertainty.broadPeriod,
    caveat: LocalizedHistorySummary(
      tr: '700 yalnız öğretici bir yaklaşık başlangıçtır; fetih, siyasi hâkimiyet ve toplumsal din değiştirme aynı anda gerçekleşmedi. İslamlaşma bölge ve topluluğa göre farklı hızlarda ilerledi.',
      en: 'The year 700 is only an approximate teaching boundary; conquest, political rule and social conversion did not occur simultaneously. Islamization proceeded at different rates across regions and communities.',
      ar: 'تمثل سنة 700 حدًا تعليميًا تقريبيًا فقط؛ فلم تحدث الفتوحات والسيطرة السياسية والتحولات الدينية الاجتماعية في وقت واحد، بل اختلفت سرعة الأسلمة باختلاف المناطق والجماعات.',
    ),
    sourceIds: ['tor_samanid_islamization', 'formichi_islam_across_oxus'],
    status: HistoryResearchStatus.researchDraft,
  ),
  RegionalIslamicHistoryEntry(
    id: 'southeast_asia_islamic_history',
    track: RegionalIslamicHistoryTrack.southeastAsia,
    title: LocalizedHistorySummary(tr: 'Güneydoğu Asya’da İslam tarihi', en: 'Islamic history in Southeast Asia', ar: 'تاريخ الإسلام في جنوب شرق آسيا'),
    summary: LocalizedHistorySummary(
      tr: 'Güneydoğu Asya’da Müslüman tüccarlar erken dönemlerden itibaren deniz ağlarında yer aldı; yerel toplumların geniş ölçekli İslamlaşması ise özellikle 14.–16. yüzyıllarda liman şehirleri, sultanlıklar, âlimler ve Hint Okyanusu bağlantılarıyla hızlandı.',
      en: 'Muslim merchants participated in Southeast Asian maritime networks from early periods, while large-scale local Islamization accelerated especially from the fourteenth to sixteenth centuries through port cities, sultanates, scholars and Indian Ocean connections.',
      ar: 'شارك التجار المسلمون في الشبكات البحرية لجنوب شرق آسيا منذ فترات مبكرة، بينما تسارعت أسلمة المجتمعات المحلية على نطاق واسع خصوصًا بين القرنين الرابع عشر والسادس عشر عبر مدن الموانئ والسلطنات والعلماء وصلات المحيط الهندي.',
    ),
    startYearCe: 1200,
    endYearCe: 1800,
    certainty: RegionalIslamicHistoryCertainty.broadPeriod,
    caveat: LocalizedHistorySummary(
      tr: '1200 tek ve kesin bir başlangıç yılı değildir. Erken ticari Müslüman varlığı daha eskidir; kitlesel dönüşüm ve siyasi kurumsallaşma takımada ve bölgelere göre farklı tarihlerde gerçekleşmiştir.',
      en: 'The year 1200 is not a single exact beginning. Muslim commercial presence is older, while mass conversion and political institutionalization occurred at different dates across islands and regions.',
      ar: 'ليست سنة 1200 بداية واحدة دقيقة؛ فالوجود التجاري الإسلامي أقدم، أما التحول الواسع والمؤسسات السياسية الإسلامية فقد ظهرت في تواريخ مختلفة بحسب الجزر والمناطق.',
    ),
    sourceIds: ['lapidus_southeast_asia', 'feener_muslim_circulations_monsoon_asia'],
    status: HistoryResearchStatus.researchDraft,
  ),
  RegionalIslamicHistoryEntry(
    id: 'indian_subcontinent_islamic_history',
    track: RegionalIslamicHistoryTrack.indianSubcontinent,
    title: LocalizedHistorySummary(tr: 'Hint alt kıtasında İslam tarihi', en: 'Islamic history in the Indian subcontinent', ar: 'تاريخ الإسلام في شبه القارة الهندية'),
    summary: LocalizedHistorySummary(
      tr: 'Hint alt kıtasındaki İslam tarihi deniz ticareti, sınır bölgeleri, Delhi sultanlıkları, Babürler, sûfî ağlar ve farklı yerel toplumlarla etkileşimleri birlikte içerir; yalnız askerî fetihle açıklanamaz.',
      en: 'Islamic history in the Indian subcontinent includes maritime trade, frontier regions, the Delhi sultanates, the Mughals, Sufi networks and interaction with diverse local societies; it cannot be explained by military conquest alone.',
      ar: 'يشمل تاريخ الإسلام في شبه القارة الهندية التجارة البحرية والمناطق الحدودية وسلطنات دلهي والمغول والشبكات الصوفية والتفاعل مع مجتمعات محلية متنوعة، ولا يمكن تفسيره بالفتح العسكري وحده.',
    ),
    startYearCe: 700,
    endYearCe: 1800,
    certainty: RegionalIslamicHistoryCertainty.broadPeriod,
    caveat: LocalizedHistorySummary(
      tr: '700 yaklaşık temas sınırıdır. Alt kıtada Müslüman varlığının siyasi ve toplumsal biçimleri bölgeden bölgeye değişmiş, din değiştirme süreçleri de tek bir sebep veya tarihle açıklanamamıştır.',
      en: 'The year 700 is an approximate contact boundary. Political and social forms of Muslim presence varied across the subcontinent, and conversion processes cannot be assigned one cause or one date.',
      ar: 'تمثل سنة 700 حدًا تقريبيًا للاتصال. وقد اختلفت أشكال الوجود الإسلامي السياسية والاجتماعية بين مناطق شبه القارة، ولا يمكن رد عمليات التحول الديني إلى سبب واحد أو تاريخ واحد.',
    ),
    sourceIds: ['wink_medieval_india_rise_islam', 'lapidus_indian_subcontinent'],
    status: HistoryResearchStatus.researchDraft,
  ),
  RegionalIslamicHistoryEntry(
    id: 'europe_islamic_history',
    track: RegionalIslamicHistoryTrack.europe,
    title: LocalizedHistorySummary(tr: 'Avrupa’da İslam tarihi', en: 'Islamic history in Europe', ar: 'تاريخ الإسلام في أوروبا'),
    summary: LocalizedHistorySummary(
      tr: 'Avrupa’daki İslam tarihi Endülüs ve Akdeniz adalarından Osmanlı Balkanlarına, ticaret ve diplomasiye ve daha sonraki Müslüman topluluklara uzanan çok merkezli bir tarihtir; “Avrupa” ile “İslam”ı birbirinden bütünüyle ayrı iki sabit dünya gibi sunmaz.',
      en: 'Islamic history in Europe is multi-centred, extending from al-Andalus and Mediterranean islands to the Ottoman Balkans, trade and diplomacy, and later Muslim communities; it does not present “Europe” and “Islam” as two permanently separate fixed worlds.',
      ar: 'تاريخ الإسلام في أوروبا متعدد المراكز، ويمتد من الأندلس وجزر البحر المتوسط إلى البلقان العثماني والتجارة والدبلوماسية والمجتمعات الإسلامية اللاحقة، ولا يعرض «أوروبا» و«الإسلام» كعالمين ثابتين منفصلين دائمًا.',
    ),
    startYearCe: 711,
    endYearCe: 1800,
    certainty: RegionalIslamicHistoryCertainty.broadPeriod,
    caveat: LocalizedHistorySummary(
      tr: '711 Endülüs için önemli bir siyasi sınırdır fakat Avrupa’daki bütün Müslüman varlığının tek başlangıcı değildir. Sicilya, Balkanlar, Akdeniz ve modern toplulukların kronolojileri birbirinden farklıdır.',
      en: 'The year 711 is an important political boundary for al-Andalus but not the single beginning of all Muslim presence in Europe. Sicily, the Balkans, the Mediterranean and modern communities have distinct chronologies.',
      ar: 'تمثل سنة 711 حدًا سياسيًا مهمًا للأندلس، لكنها ليست البداية الوحيدة لكل وجود إسلامي في أوروبا؛ فلصقلية والبلقان والبحر المتوسط والمجتمعات الحديثة تسلسلات زمنية مختلفة.',
    ),
    sourceIds: ['berger_brief_history_islam_europe', 'nchi_muslims_west_europe'],
    status: HistoryResearchStatus.researchDraft,
  ),
];

final regionalIslamicHistoriesT0217 = RegionalIslamicHistoriesDataset.validated(
  sources: regionalIslamicHistoriesT0217Sources,
  entries: regionalIslamicHistoriesT0217Entries,
);
