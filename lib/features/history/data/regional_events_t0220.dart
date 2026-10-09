import '../domain/history_event_contract.dart';
import 'pre_islam_world_context.dart';
import 'regional_islamic_histories.dart';

LocalizedHistorySummary _l(String tr, String en, String ar) =>
    LocalizedHistorySummary(tr: tr, en: en, ar: ar);

final Set<String> _knownT0217SourceIds = regionalIslamicHistoriesT0217Sources
    .map((source) => source.locator.id)
    .toSet();

HistoryDateCertainty _certaintyFor(RegionalIslamicHistoryCertainty certainty) {
  switch (certainty) {
    case RegionalIslamicHistoryCertainty.broadPeriod:
      return HistoryDateCertainty.broadRange;
    case RegionalIslamicHistoryCertainty.contestedInterpretation:
      return HistoryDateCertainty.contested;
  }
}

const _africanMuslimSocieties = HistoryPersonRef(
  id: 'african_muslim_societies_historical_actors',
  name: LocalizedHistorySummary(
    tr: 'Afrika’daki Müslüman toplumlar, âlimler, tüccarlar ve siyasi aktörler',
    en: 'Muslim societies, scholars, merchants and political actors in Africa',
    ar: 'المجتمعات المسلمة والعلماء والتجار والفاعلون السياسيون في أفريقيا',
  ),
);
const _centralAsianActors = HistoryPersonRef(
  id: 'central_asian_muslim_historical_actors',
  name: LocalizedHistorySummary(
    tr: 'Orta Asya’daki Müslüman toplumlar, hanedanlar, âlimler ve ticaret ağları',
    en: 'Muslim societies, dynasties, scholars and trade networks in Central Asia',
    ar: 'المجتمعات المسلمة والسلالات والعلماء وشبكات التجارة في آسيا الوسطى',
  ),
);
const _southeastAsianActors = HistoryPersonRef(
  id: 'southeast_asian_muslim_historical_actors',
  name: LocalizedHistorySummary(
    tr: 'Güneydoğu Asya’daki Müslüman tüccarlar, sultanlıklar, âlimler ve yerel toplumlar',
    en: 'Muslim merchants, sultanates, scholars and local societies in Southeast Asia',
    ar: 'التجار المسلمون والسلطنات والعلماء والمجتمعات المحلية في جنوب شرق آسيا',
  ),
);
const _indianSubcontinentActors = HistoryPersonRef(
  id: 'indian_subcontinent_muslim_historical_actors',
  name: LocalizedHistorySummary(
    tr: 'Hint alt kıtasındaki Müslüman toplumlar, hanedanlar, sûfî ağlar ve yerel aktörler',
    en: 'Muslim societies, dynasties, Sufi networks and local actors in the Indian subcontinent',
    ar: 'المجتمعات المسلمة والسلالات والشبكات الصوفية والفاعلون المحليون في شبه القارة الهندية',
  ),
);
const _europeanMuslimActors = HistoryPersonRef(
  id: 'european_muslim_historical_actors',
  name: LocalizedHistorySummary(
    tr: 'Avrupa’daki Müslüman toplumlar, hanedanlar, tüccarlar ve siyasi aktörler',
    en: 'Muslim societies, dynasties, merchants and political actors in Europe',
    ar: 'المجتمعات المسلمة والسلالات والتجار والفاعلون السياسيون في أوروبا',
  ),
);

const _africa = HistoryGeographyRef(
  id: 'africa_regional_history',
  label: LocalizedHistorySummary(
    tr: 'Kuzey, Batı ve Doğu Afrika’nın farklı tarihsel bölgeleri',
    en: 'Distinct historical regions of North, West and East Africa',
    ar: 'الأقاليم التاريخية المختلفة في شمال أفريقيا وغربها وشرقها',
  ),
  precision: HistoryGeographyPrecision.regional,
);
const _centralAsia = HistoryGeographyRef(
  id: 'central_asia_regional_history',
  label: LocalizedHistorySummary(
    tr: 'Mâverâünnehir, Horasan bağlantıları ve Orta Asya’nın farklı tarihsel bölgeleri',
    en: 'Transoxiana, connected Khurasan zones and distinct historical regions of Central Asia',
    ar: 'ما وراء النهر والمناطق المرتبطة بخراسان والأقاليم التاريخية المختلفة في آسيا الوسطى',
  ),
  precision: HistoryGeographyPrecision.regional,
);
const _southeastAsia = HistoryGeographyRef(
  id: 'southeast_asia_regional_history',
  label: LocalizedHistorySummary(
    tr: 'Malay-Endonezya takımadaları ve Güneydoğu Asya deniz ticaret bölgeleri',
    en: 'The Malay-Indonesian archipelago and maritime regions of Southeast Asia',
    ar: 'أرخبيل الملايو-إندونيسيا والمناطق البحرية في جنوب شرق آسيا',
  ),
  precision: HistoryGeographyPrecision.regional,
);
const _indianSubcontinent = HistoryGeographyRef(
  id: 'indian_subcontinent_regional_history',
  label: LocalizedHistorySummary(
    tr: 'Hint alt kıtasının farklı kıyı, sınır, şehir ve imparatorluk bölgeleri',
    en: 'Distinct coastal, frontier, urban and imperial regions of the Indian subcontinent',
    ar: 'المناطق الساحلية والحدودية والحضرية والإمبراطورية المختلفة في شبه القارة الهندية',
  ),
  precision: HistoryGeographyPrecision.regional,
);
const _europe = HistoryGeographyRef(
  id: 'europe_regional_islamic_history',
  label: LocalizedHistorySummary(
    tr: 'Endülüs, Akdeniz, Balkanlar ve Avrupa’daki diğer tarihsel Müslüman coğrafyaları',
    en: 'Al-Andalus, the Mediterranean, the Balkans and other historical Muslim geographies in Europe',
    ar: 'الأندلس والبحر المتوسط والبلقان ومجالات إسلامية تاريخية أخرى في أوروبا',
  ),
  precision: HistoryGeographyPrecision.regional,
);

HistoryEventRecord _eventFor(RegionalIslamicHistoryEntry entry) {
  final certainty = _certaintyFor(entry.certainty);

  switch (entry.id) {
    case 'africa_islamic_history':
      return HistoryEventRecord.validated(
        id: entry.id,
        title: entry.title,
        startYearCe: entry.startYearCe,
        endYearCe: entry.endYearCe,
        dateCertainty: certainty,
        dateCaveat: entry.caveat,
        beforeContext: _l(
          'İslam’ın ortaya çıkışından önce Afrika, Bizans ve Aksum gibi siyasal güçler ile çok çeşitli yerel krallıklar, ticaret ağları, dinî gelenekler ve toplumların bulunduğu çok merkezli bir kıtaydı.',
          'Before the emergence of Islam, Africa was a highly diverse continent of political powers such as Byzantium and Aksum alongside local kingdoms, trade networks, religious traditions and societies.',
          'قبل ظهور الإسلام كانت أفريقيا قارة شديدة التنوع تضم قوى سياسية مثل بيزنطة وأكسوم إلى جانب ممالك محلية وشبكات تجارة وتقاليد دينية ومجتمعات متعددة.',
        ),
        causes: [
          _l(
            'Erken Müslüman göçleri ve fetihlerin yanı sıra Sahra, Kızıldeniz ve Hint Okyanusu ticaret ağları, âlim hareketliliği, devlet oluşumları ve yerel toplumsal ilişkiler İslam’ın farklı Afrika bölgelerinde yayılmasına katkı sağladı.',
            'Alongside early Muslim migrations and conquests, trans-Saharan, Red Sea and Indian Ocean trade, scholarly mobility, state formation and local social relationships contributed to the spread of Islam in different African regions.',
            'إلى جانب الهجرات والفتوحات الإسلامية المبكرة أسهمت تجارة الصحراء والبحر الأحمر والمحيط الهندي وحركة العلماء ونشوء الدول والعلاقات الاجتماعية المحلية في انتشار الإسلام في مناطق أفريقية مختلفة.',
          ),
        ],
        consequences: [
          _l(
            'Yüzyıllar içinde Afrika’nın farklı bölgelerinde birbirinden farklı Müslüman toplumlar, devletler, eğitim ve ilim ağları oluştu; bu süreç tek bir fetih veya tek bir İslamlaşma tarihiyle açıklanamaz.',
            'Over centuries, distinct Muslim societies, states, educational institutions and scholarly networks developed across Africa; the process cannot be explained by one conquest or one date of Islamization.',
            'نشأت عبر القرون مجتمعات ودول ومؤسسات تعليمية وشبكات علمية إسلامية مختلفة في أنحاء أفريقيا، ولا يمكن تفسير هذه العملية بفتح واحد أو تاريخ واحد للأسلمة.',
          ),
        ],
        people: const [_africanMuslimSocieties],
        geographies: const [_africa],
        sourceIds: entry.sourceIds,
        knownSourceIds: _knownT0217SourceIds,
        status: entry.status,
      );
    case 'central_asia_islamic_history':
      return HistoryEventRecord.validated(
        id: entry.id,
        title: entry.title,
        startYearCe: entry.startYearCe,
        endYearCe: entry.endYearCe,
        dateCertainty: certainty,
        dateCaveat: entry.caveat,
        beforeContext: _l(
          'Orta Asya, İslam öncesinde İranî ve Türk toplulukların, şehir devletlerinin, bozkır güçlerinin ve İpek Yolu ağlarının kesiştiği dinî ve siyasi açıdan çoğul bir bölgeydi.',
          'Before Islam, Central Asia was a religiously and politically plural region where Iranian and Turkic peoples, urban polities, steppe powers and Silk Road networks intersected.',
          'كانت آسيا الوسطى قبل الإسلام منطقة متعددة دينيًا وسياسيًا تتقاطع فيها الشعوب الإيرانية والتركية والكيانات الحضرية وقوى السهوب وشبكات طريق الحرير.',
        ),
        causes: [
          _l(
            'Erken Müslüman fetihleri, Sâmânî dönemindeki siyasal ve kültürel dönüşümler, ticaret, şehirleşme, âlim ağları ve Türk topluluklarıyla uzun süreli etkileşimler bölgesel İslamlaşmayı şekillendirdi.',
            'Early Muslim conquests, political and cultural transformations under the Samanids, trade, urban life, scholarly networks and long interaction with Turkic peoples shaped regional Islamization.',
            'شكّلت الفتوحات الإسلامية المبكرة والتحولات السياسية والثقافية في العصر الساماني والتجارة والحياة الحضرية وشبكات العلماء والتفاعل الطويل مع الشعوب التركية مسارات الأسلمة الإقليمية.',
          ),
        ],
        consequences: [
          _l(
            'Orta Asya, sonraki yüzyıllarda önemli Müslüman şehir, eğitim ve ilim merkezleri ile Türk-İslam siyasi geleneklerinin geliştiği başlıca bölgelerden biri oldu.',
            'Central Asia became one of the major regions in which important Muslim urban, educational and scholarly centres and Turkic-Islamic political traditions developed.',
            'أصبحت آسيا الوسطى من المناطق الرئيسة التي تطورت فيها مدن ومراكز تعليم وعلم إسلامية مهمة وتقاليد سياسية تركية إسلامية.',
          ),
        ],
        people: const [_centralAsianActors],
        geographies: const [_centralAsia],
        sourceIds: entry.sourceIds,
        knownSourceIds: _knownT0217SourceIds,
        status: entry.status,
      );
    case 'southeast_asia_islamic_history':
      return HistoryEventRecord.validated(
        id: entry.id,
        title: entry.title,
        startYearCe: entry.startYearCe,
        endYearCe: entry.endYearCe,
        dateCertainty: certainty,
        dateCaveat: entry.caveat,
        beforeContext: _l(
          'Güneydoğu Asya, Hint Okyanusu ticaretine bağlı limanlar, yerel krallıklar ve Hindu-Budist ile yerel dinî geleneklerin birlikte bulunduğu geniş bir deniz dünyasıydı.',
          'Southeast Asia was a broad maritime world of ports connected to Indian Ocean trade, local kingdoms and overlapping Hindu-Buddhist and local religious traditions.',
          'كان جنوب شرق آسيا عالمًا بحريًا واسعًا من الموانئ المرتبطة بتجارة المحيط الهندي والممالك المحلية والتقاليد الهندوسية والبوذية والمحلية المتداخلة.',
        ),
        causes: [
          _l(
            'Müslüman tüccarların deniz ağlarındaki varlığı, liman şehirlerindeki yerel siyasi dönüşümler, sultanlıkların oluşumu, âlim ve sûfî dolaşımı ile Hint Okyanusu bağlantıları İslamlaşmanın bölgesel biçimlerini etkiledi.',
            'Muslim participation in maritime networks, local political change in port cities, the formation of sultanates, the circulation of scholars and Sufis, and Indian Ocean connections shaped regional forms of Islamization.',
            'أثّر حضور المسلمين في الشبكات البحرية والتحولات السياسية المحلية في مدن الموانئ ونشوء السلطنات وحركة العلماء والصوفية وصلات المحيط الهندي في أشكال الأسلمة الإقليمية.',
          ),
        ],
        consequences: [
          _l(
            '14.–16. yüzyıllarda birçok bölgede Müslüman sultanlıklar ve topluluklar güçlenirken dönüşüm adadan adaya ve toplumdan topluma farklı hızlarda ilerledi.',
            'From the fourteenth to sixteenth centuries Muslim sultanates and communities strengthened in many areas, while conversion proceeded at different rates across islands and societies.',
            'بين القرنين الرابع عشر والسادس عشر تعززت سلطنات ومجتمعات إسلامية في مناطق عديدة، بينما جرت التحولات بسرعات مختلفة بين الجزر والمجتمعات.',
          ),
        ],
        people: const [_southeastAsianActors],
        geographies: const [_southeastAsia],
        sourceIds: entry.sourceIds,
        knownSourceIds: _knownT0217SourceIds,
        status: entry.status,
      );
    case 'indian_subcontinent_islamic_history':
      return HistoryEventRecord.validated(
        id: entry.id,
        title: entry.title,
        startYearCe: entry.startYearCe,
        endYearCe: entry.endYearCe,
        dateCertainty: certainty,
        dateCaveat: entry.caveat,
        beforeContext: _l(
          'Hint alt kıtası, İslam’ın yayılmasından önce çok sayıda siyasi merkez, ticaret limanı, dil ve dinî geleneğe sahip geniş ve çeşitlilik gösteren bir coğrafyaydı.',
          'Before the spread of Islam, the Indian subcontinent was a large and diverse region with numerous political centres, trading ports, languages and religious traditions.',
          'كانت شبه القارة الهندية قبل انتشار الإسلام منطقة واسعة ومتنوعة تضم مراكز سياسية وموانئ تجارية ولغات وتقاليد دينية عديدة.',
        ),
        causes: [
          _l(
            'Deniz ticareti ve kıyı temasları, kuzeybatı sınırındaki askerî-siyasi gelişmeler, Delhi sultanlıkları ve Babürler gibi devletler ile sûfî, ilmî ve yerel toplumsal ağlar Müslüman varlığının farklı biçimlerini oluşturdu.',
            'Maritime trade and coastal contact, military-political developments on the north-west frontier, states such as the Delhi sultanates and the Mughals, and Sufi, scholarly and local social networks produced different forms of Muslim presence.',
            'أنتجت التجارة البحرية والاتصالات الساحلية والتطورات العسكرية والسياسية على الحدود الشمالية الغربية ودول مثل سلطنات دلهي والمغول والشبكات الصوفية والعلمية والاجتماعية المحلية أشكالًا متعددة من الوجود الإسلامي.',
          ),
        ],
        consequences: [
          _l(
            'Alt kıtada çok çeşitli Müslüman siyasi, kültürel ve toplumsal gelenekler gelişti; din değiştirme ve toplumsal dönüşüm süreçleri tek bir askerî nedene veya tarihe indirgenemez.',
            'A wide range of Muslim political, cultural and social traditions developed across the subcontinent; conversion and social change cannot be reduced to a single military cause or date.',
            'تطورت في شبه القارة تقاليد سياسية وثقافية واجتماعية إسلامية متنوعة، ولا يمكن اختزال التحول الديني والاجتماعي في سبب عسكري واحد أو تاريخ واحد.',
          ),
        ],
        people: const [_indianSubcontinentActors],
        geographies: const [_indianSubcontinent],
        sourceIds: entry.sourceIds,
        knownSourceIds: _knownT0217SourceIds,
        status: entry.status,
      );
    case 'europe_islamic_history':
      return HistoryEventRecord.validated(
        id: entry.id,
        title: entry.title,
        startYearCe: entry.startYearCe,
        endYearCe: entry.endYearCe,
        dateCertainty: certainty,
        dateCaveat: entry.caveat,
        beforeContext: _l(
          'Erken ortaçağ Avrupa ve Akdeniz dünyası Bizans, Latin Hristiyan krallıkları, Akdeniz adaları ve farklı ticaret ağları arasında siyasi ve dinî açıdan çoğul bir alan oluşturuyordu.',
          'Early medieval Europe and the Mediterranean formed a politically and religiously plural space of Byzantium, Latin Christian kingdoms, Mediterranean islands and multiple trade networks.',
          'شكّلت أوروبا والبحر المتوسط في العصور الوسطى المبكرة فضاءً متعددًا سياسيًا ودينيًا ضم بيزنطة والممالك المسيحية اللاتينية وجزر المتوسط وشبكات تجارة متعددة.',
        ),
        causes: [
          _l(
            'Endülüs’teki Müslüman siyasi varlık, Akdeniz’deki temaslar, Sicilya ve diğer bölgelerdeki dönemsel yönetimler, Osmanlı Balkanları, ticaret, diplomasi ve daha sonraki göçler Avrupa’daki Müslüman tarihinin farklı katmanlarını oluşturdu.',
            'Muslim political presence in al-Andalus, Mediterranean contacts, periods of rule in Sicily and elsewhere, the Ottoman Balkans, trade, diplomacy and later migrations formed different layers of Muslim history in Europe.',
            'شكّل الوجود السياسي الإسلامي في الأندلس واتصالات المتوسط وفترات الحكم في صقلية ومناطق أخرى والبلقان العثماني والتجارة والدبلوماسية والهجرات اللاحقة طبقات مختلفة من تاريخ المسلمين في أوروبا.',
          ),
        ],
        consequences: [
          _l(
            'Avrupa’daki Müslüman tarihi tek bir başlangıca veya kesintisiz siyasi çizgiye sahip değildir; farklı bölgelerde kalıcı ve geçici topluluklar, kurumlar ve kültürel etkileşimler farklı dönemlerde ortaya çıktı.',
            'Muslim history in Europe has neither a single beginning nor one continuous political line; enduring and temporary communities, institutions and cultural interactions emerged in different regions at different times.',
            'ليس لتاريخ المسلمين في أوروبا بداية واحدة ولا خط سياسي متصل واحد؛ فقد ظهرت مجتمعات ومؤسسات وتفاعلات ثقافية دائمة ومؤقتة في مناطق وأزمنة مختلفة.',
          ),
        ],
        people: const [_europeanMuslimActors],
        geographies: const [_europe],
        sourceIds: entry.sourceIds,
        knownSourceIds: _knownT0217SourceIds,
        status: entry.status,
      );
    default:
      throw StateError('Unmapped T0217 regional history entry: ${entry.id}');
  }
}

final regionalEventsT0220 = HistoryEventContractDataset.validated(
  regionalIslamicHistoriesT0217Entries.map(_eventFor).toList(growable: false),
);
