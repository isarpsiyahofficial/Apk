import '../domain/history_event_contract.dart';
import 'high_medieval_seljuq_crusades_mamluks.dart';
import 'pre_islam_world_context.dart';

LocalizedHistorySummary _l(String tr, String en, String ar) =>
    LocalizedHistorySummary(tr: tr, en: en, ar: ar);

final Set<String> _knownT0215SourceIds = highMedievalHistoryT0215Sources
    .map((source) => source.locator.id)
    .toSet();

HistoryDateCertainty _certaintyFor(HighMedievalHistoryCertainty certainty) {
  switch (certainty) {
    case HighMedievalHistoryCertainty.establishedChronology:
      return HistoryDateCertainty.approximate;
    case HighMedievalHistoryCertainty.broadPeriod:
      return HistoryDateCertainty.broadRange;
    case HighMedievalHistoryCertainty.contestedInterpretation:
      return HistoryDateCertainty.contested;
  }
}

LocalizedHistorySummary _dateCaveatFor(HighMedievalHistoryEntry entry) {
  return entry.caveat ??
      _l(
        'Bu yıl aralığı dönem kronolojisini gösterir; gün ve ay düzeyinde kesinlik iddia edilmez.',
        'This year range represents period chronology; day- or month-level precision is not asserted.',
        'يمثل هذا النطاق الزمني تسلسل المرحلة، ولا تُدّعى دقة على مستوى اليوم أو الشهر.',
      );
}

const _seljuqDynasty = HistoryPersonRef(
  id: 'great_seljuq_dynasty',
  name: LocalizedHistorySummary(
    tr: 'Büyük Selçuklu hanedanı',
    en: 'Great Seljuq dynasty',
    ar: 'السلالة السلجوقية الكبرى',
  ),
);
const _latinCrusadingPowers = HistoryPersonRef(
  id: 'latin_crusading_powers',
  name: LocalizedHistorySummary(
    tr: 'Latin Haçlı güçleri',
    en: 'Latin crusading powers',
    ar: 'القوى الصليبية اللاتينية',
  ),
);
const _muslimLevantPowers = HistoryPersonRef(
  id: 'muslim_levant_powers',
  name: LocalizedHistorySummary(
    tr: 'Levant’taki Müslüman siyasi güçler',
    en: 'Muslim political powers in the Levant',
    ar: 'القوى السياسية الإسلامية في بلاد الشام',
  ),
);
const _saladin = HistoryPersonRef(
  id: 'saladin_salah_al_din',
  name: LocalizedHistorySummary(
    tr: 'Selâhaddin Eyyûbî',
    en: 'Saladin',
    ar: 'صلاح الدين الأيوبي',
  ),
);
const _mongolPowers = HistoryPersonRef(
  id: 'mongol_imperial_powers',
  name: LocalizedHistorySummary(
    tr: 'Moğol imparatorluk güçleri',
    en: 'Mongol imperial powers',
    ar: 'القوى الإمبراطورية المغولية',
  ),
);
const _mamlukSultanate = HistoryPersonRef(
  id: 'mamluk_sultanate_rulers',
  name: LocalizedHistorySummary(
    tr: 'Memlük sultanları ve askerî elitleri',
    en: 'Mamluk sultans and military elites',
    ar: 'سلاطين المماليك ونخبهم العسكرية',
  ),
);

const _iranKhorasanBaghdad = HistoryGeographyRef(
  id: 'iran_khorasan_baghdad',
  label: LocalizedHistorySummary(
    tr: 'Horasan, İran ve Bağdat',
    en: 'Khurasan, Iran and Baghdad',
    ar: 'خراسان وإيران وبغداد',
  ),
  precision: HistoryGeographyPrecision.regional,
);
const _easternMediterraneanLevant = HistoryGeographyRef(
  id: 'eastern_mediterranean_levant',
  label: LocalizedHistorySummary(
    tr: 'Doğu Akdeniz ve Levant',
    en: 'Eastern Mediterranean and the Levant',
    ar: 'شرق البحر المتوسط وبلاد الشام',
  ),
  precision: HistoryGeographyPrecision.regional,
);
const _egyptSyria = HistoryGeographyRef(
  id: 'egypt_syria',
  label: LocalizedHistorySummary(
    tr: 'Mısır ve Suriye',
    en: 'Egypt and Syria',
    ar: 'مصر والشام',
  ),
  precision: HistoryGeographyPrecision.regional,
);
const _transoxianaToSyria = HistoryGeographyRef(
  id: 'transoxiana_khorasan_iran_iraq_syria',
  label: LocalizedHistorySummary(
    tr: 'Mâverâünnehir, Horasan, İran, Irak ve Suriye',
    en: 'Transoxiana, Khurasan, Iran, Iraq and Syria',
    ar: 'ما وراء النهر وخراسان وإيران والعراق والشام',
  ),
  precision: HistoryGeographyPrecision.regional,
);

HistoryEventRecord _eventFor(HighMedievalHistoryEntry entry) {
  final certainty = _certaintyFor(entry.certainty);
  final caveat = _dateCaveatFor(entry);

  switch (entry.id) {
    case 'great_seljuq_sultanate':
      return HistoryEventRecord.validated(
        id: entry.id,
        title: entry.title,
        startYearCe: entry.startYearCe,
        endYearCe: entry.endYearCe,
        dateCertainty: certainty,
        dateCaveat: caveat,
        beforeContext: _l(
          '11. yüzyıl başlarında Horasan ve İran’da Gazneli, yerel İranlı ve çeşitli Türk siyasi güçleri bir arada bulunuyordu; Abbâsî halifeliğinin doğrudan siyasi gücü sınırlıydı.',
          'In the early eleventh century, Ghaznavid, local Iranian and various Turkic political powers coexisted across Khurasan and Iran, while direct Abbasid political power was limited.',
          'في أوائل القرن الحادي عشر تعايشت في خراسان وإيران قوى غزنوية وإيرانية محلية وتركية متعددة، بينما كانت السلطة السياسية المباشرة للخلافة العباسية محدودة.',
        ),
        causes: [
          _l(
            'Selçuklu hanedanının Horasan ve İran’daki askerî-siyasi yükselişi yeni bir sultanlık düzeninin oluşmasına yol açtı.',
            'The Seljuq dynasty’s military and political rise in Khurasan and Iran led to the formation of a new sultanate order.',
            'أدى الصعود العسكري والسياسي للسلالة السلجوقية في خراسان وإيران إلى تشكل نظام سلطاني جديد.',
          ),
        ],
        consequences: [
          _l(
            'Selçuklu iktidarı Bağdat’taki Abbâsî halifeliğiyle yeni bir sultan-halife ilişkisi kurdu; 12. yüzyılda merkezî çizginin parçalanması farklı Selçuklu kolları ve bölgesel güçlerin yükselişine eşlik etti.',
            'Seljuq rule established a new sultan-caliph relationship with the Abbasid caliphate in Baghdad; fragmentation of the central line in the twelfth century accompanied the rise of different Seljuq branches and regional powers.',
            'أقام الحكم السلجوقي علاقة جديدة بين السلطان والخليفة العباسي في بغداد، وترافق تفكك الخط المركزي في القرن الثاني عشر مع صعود فروع سلجوقية وقوى إقليمية مختلفة.',
          ),
        ],
        people: const [_seljuqDynasty],
        geographies: const [_iranKhorasanBaghdad],
        sourceIds: entry.sourceIds,
        knownSourceIds: _knownT0215SourceIds,
        status: entry.status,
      );
    case 'crusading_movement_levant':
      return HistoryEventRecord.validated(
        id: entry.id,
        title: entry.title,
        startYearCe: entry.startYearCe,
        endYearCe: entry.endYearCe,
        dateCertainty: certainty,
        dateCaveat: caveat,
        beforeContext: _l(
          '11. yüzyılın sonlarında Doğu Akdeniz ve Levant, Bizans, Selçuklu ve başka bölgesel güçlerin değişen siyasi dengeleri içindeydi.',
          'By the late eleventh century, the eastern Mediterranean and the Levant were shaped by changing balances among Byzantine, Seljuq and other regional powers.',
          'في أواخر القرن الحادي عشر تشكل شرق البحر المتوسط وبلاد الشام ضمن موازين سياسية متغيرة بين البيزنطيين والسلاجقة وقوى إقليمية أخرى.',
        ),
        causes: [
          _l(
            '1095’ten itibaren Batı Avrupa’dan düzenlenen Latin Hristiyan seferleri Levant’a yöneldi; farklı seferlerin amaçları, katılımcıları ve siyasi bağlamları birbirinden ayrılır.',
            'From 1095, Latin Christian expeditions organised from western Europe moved toward the Levant; the aims, participants and political contexts of individual crusades differed.',
            'منذ سنة 1095 اتجهت حملات مسيحية لاتينية منظمة من أوروبا الغربية نحو بلاد الشام، مع اختلاف أهداف الحملات ومشاركيها وسياقاتها السياسية.',
          ),
        ],
        consequences: [
          _l(
            'Levant’ta Latin siyasi oluşumları kuruldu; Müslüman güçlerin tepkileri, ittifakları ve çatışmaları zaman içinde değişti ve dönem 1291’e kadar tek kesintisiz savaş değil çok evreli bir süreç olarak gelişti.',
            'Latin polities were established in the Levant; Muslim responses, alliances and conflicts changed over time, and the period through 1291 developed as a multi-phase process rather than one uninterrupted war.',
            'قامت كيانات سياسية لاتينية في بلاد الشام، وتغيرت ردود القوى الإسلامية وتحالفاتها وصراعاتها مع الزمن، وتطورت المرحلة حتى 1291 كسيرورة متعددة الأطوار لا كحرب واحدة متصلة.',
          ),
        ],
        people: const [_latinCrusadingPowers, _muslimLevantPowers],
        geographies: const [_easternMediterraneanLevant],
        sourceIds: entry.sourceIds,
        knownSourceIds: _knownT0215SourceIds,
        status: entry.status,
      );
    case 'ayyubid_egypt_syria':
      return HistoryEventRecord.validated(
        id: entry.id,
        title: entry.title,
        startYearCe: entry.startYearCe,
        endYearCe: entry.endYearCe,
        dateCertainty: certainty,
        dateCaveat: caveat,
        beforeContext: _l(
          '12. yüzyıl ortalarında Mısır Fâtımî yönetimindeydi; Suriye’de ise farklı Müslüman hanedanlar ve Haçlı siyasi oluşumları arasında parçalı bir güç dengesi vardı.',
          'In the mid-twelfth century Egypt remained under Fatimid rule, while Syria had a fragmented balance among different Muslim dynasties and crusader polities.',
          'في منتصف القرن الثاني عشر بقيت مصر تحت الحكم الفاطمي، بينما شهدت بلاد الشام توازنًا مجزأً بين سلالات إسلامية مختلفة وكيانات صليبية.',
        ),
        causes: [
          _l(
            'Selâhaddin’in Mısır’daki siyasi yükselişi ve 1171’de Fâtımî halifeliğinin sona ermesi Eyyûbî iktidarının temelini oluşturdu.',
            'Saladin’s political rise in Egypt and the end of the Fatimid caliphate there in 1171 formed the basis of Ayyubid rule.',
            'شكّل صعود صلاح الدين السياسي في مصر وانتهاء الخلافة الفاطمية فيها سنة 1171 أساس الحكم الأيوبي.',
          ),
        ],
        consequences: [
          _l(
            'Eyyûbîler Mısır ve Suriye’de geniş bir hanedan ağı kurdu; Selâhaddin’in 1193’teki ölümünden sonra yönetim hanedan üyeleri arasında paylaşıldı ve Mısır’daki Eyyûbî sultanlığı 1250’de Memlük iktidarına geçti.',
            'The Ayyubids built a broad dynastic network in Egypt and Syria; after Saladin’s death in 1193 rule was divided among members of the dynasty, and the Ayyubid sultanate in Egypt gave way to Mamluk rule in 1250.',
            'أقام الأيوبيون شبكة سلالية واسعة في مصر والشام، وبعد وفاة صلاح الدين سنة 1193 توزع الحكم بين أفراد الأسرة، وانتقلت السلطنة الأيوبية في مصر إلى حكم المماليك سنة 1250.',
          ),
        ],
        people: const [_saladin],
        geographies: const [_egyptSyria],
        sourceIds: entry.sourceIds,
        knownSourceIds: _knownT0215SourceIds,
        status: entry.status,
      );
    case 'mongol_invasions_islamic_lands':
      return HistoryEventRecord.validated(
        id: entry.id,
        title: entry.title,
        startYearCe: entry.startYearCe,
        endYearCe: entry.endYearCe,
        dateCertainty: certainty,
        dateCaveat: caveat,
        beforeContext: _l(
          '13. yüzyıl başında Mâverâünnehir, Horasan, İran ve Irak farklı Müslüman hanedanların ve Abbâsî hilafet merkezinin bulunduğu çok merkezli bir siyasi yapı sergiliyordu.',
          'At the start of the thirteenth century, Transoxiana, Khurasan, Iran and Iraq formed a multi-centred political landscape of different Muslim dynasties and the Abbasid caliphal centre.',
          'في مطلع القرن الثالث عشر شكّلت ما وراء النهر وخراسان وإيران والعراق مشهدًا سياسيًا متعدد المراكز يضم سلالات إسلامية مختلفة ومركز الخلافة العباسية.',
        ),
        causes: [
          _l(
            'Moğol İmparatorluğu’nun batıya doğru genişlemesi 1219’dan itibaren Orta ve Batı Asya’daki siyasi düzenleri doğrudan etkileyen büyük istila dalgaları başlattı.',
            'The Mongol Empire’s westward expansion launched major invasion waves from 1219 that directly affected political orders across Central and Western Asia.',
            'أطلق توسع الإمبراطورية المغولية غربًا منذ سنة 1219 موجات غزو كبرى أثرت مباشرة في النظم السياسية بآسيا الوسطى والغربية.',
          ),
        ],
        consequences: [
          _l(
            '1258’de Bağdat’ın alınması Abbâsîlerin Bağdat’taki siyasi merkezini sona erdirdi; sonraki Moğol ve İlhanlı yönetimleri ile Müslüman toplumlar arasındaki ilişkiler ilk fetih dalgalarından daha karmaşık biçimde gelişti.',
            'The conquest of Baghdad in 1258 ended the Abbasid political centre there; later relations between Mongol and Ilkhanid rulers and Muslim societies developed in ways more complex than the initial conquest waves.',
            'أنهى الاستيلاء على بغداد سنة 1258 المركز السياسي العباسي فيها، ثم تطورت العلاقات بين الحكام المغول والإيلخانيين والمجتمعات الإسلامية بصورة أكثر تعقيدًا من موجات الفتح الأولى.',
          ),
        ],
        people: const [_mongolPowers],
        geographies: const [_transoxianaToSyria],
        sourceIds: entry.sourceIds,
        knownSourceIds: _knownT0215SourceIds,
        status: entry.status,
      );
    case 'mamluk_sultanate_egypt_syria':
      return HistoryEventRecord.validated(
        id: entry.id,
        title: entry.title,
        startYearCe: entry.startYearCe,
        endYearCe: entry.endYearCe,
        dateCertainty: certainty,
        dateCaveat: caveat,
        beforeContext: _l(
          '13. yüzyıl ortasında Mısır’da Eyyûbî yönetimi çözülürken doğudan Moğol ilerleyişi Suriye’ye ulaşıyordu.',
          'In the mid-thirteenth century Ayyubid rule in Egypt was breaking down as Mongol expansion from the east reached Syria.',
          'في منتصف القرن الثالث عشر كان الحكم الأيوبي في مصر يتفكك بينما وصل التوسع المغولي من الشرق إلى بلاد الشام.',
        ),
        causes: [
          _l(
            '1250’de Mısır’daki askerî elitlerin iktidarı ele geçirmesi Memlük sultanlık düzeninin başlangıcını oluşturdu.',
            'The seizure of power by military elites in Egypt in 1250 marked the beginning of the Mamluk sultanate order.',
            'مثّل استيلاء النخب العسكرية على السلطة في مصر سنة 1250 بداية نظام السلطنة المملوكية.',
          ),
        ],
        consequences: [
          _l(
            'Memlükler Mısır ve Suriye’nin başlıca siyasi gücü hâline geldi; 1260 Ayn Câlût zaferi Moğol ilerleyişine karşı önemli bir dönüm noktası oldu ve sultanlık 1517’de Osmanlı fethine kadar sürdü.',
            'The Mamluks became the principal political power in Egypt and Syria; the victory at Ayn Jalut in 1260 was an important turning point against Mongol advances, and the sultanate continued until the Ottoman conquest of 1517.',
            'أصبح المماليك القوة السياسية الرئيسية في مصر والشام، وكان انتصار عين جالوت سنة 1260 نقطة تحول مهمة في مواجهة التقدم المغولي، واستمرت السلطنة حتى الفتح العثماني سنة 1517.',
          ),
        ],
        people: const [_mamlukSultanate],
        geographies: const [_egyptSyria],
        sourceIds: entry.sourceIds,
        knownSourceIds: _knownT0215SourceIds,
        status: entry.status,
      );
    default:
      throw StateError('Unmapped T0215 history event: ${entry.id}');
  }
}

final highMedievalHistoryT0215EventsT0220 =
    highMedievalHistoryT0215.entries.map(_eventFor).toList(growable: false);

final highMedievalHistoryT0215EventDatasetT0220 =
    HistoryEventContractDataset.validated(highMedievalHistoryT0215EventsT0220);
