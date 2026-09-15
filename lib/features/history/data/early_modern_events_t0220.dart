import '../domain/history_event_contract.dart';
import 'early_modern_ottoman_safavid_mughal.dart';
import 'pre_islam_world_context.dart';

LocalizedHistorySummary _l(String tr, String en, String ar) =>
    LocalizedHistorySummary(tr: tr, en: en, ar: ar);

final Set<String> _knownT0216SourceIds = earlyModernEmpiresT0216Sources
    .map((source) => source.locator.id)
    .toSet();

HistoryDateCertainty _certaintyFor(EarlyModernHistoryCertainty certainty) {
  switch (certainty) {
    case EarlyModernHistoryCertainty.establishedChronology:
      return HistoryDateCertainty.approximate;
    case EarlyModernHistoryCertainty.broadPeriod:
      return HistoryDateCertainty.broadRange;
    case EarlyModernHistoryCertainty.contestedInterpretation:
      return HistoryDateCertainty.contested;
  }
}

LocalizedHistorySummary _dateCaveatFor(EarlyModernEmpireEntry entry) {
  return entry.caveat ??
      _l(
        'Bu yıl aralığı dönem kronolojisini gösterir; gün ve ay düzeyinde kesinlik iddia edilmez.',
        'This year range represents period chronology; day- or month-level precision is not asserted.',
        'يمثل هذا النطاق الزمني تسلسل المرحلة، ولا تُدّعى دقة على مستوى اليوم أو الشهر.',
      );
}

const _ottomanDynasty = HistoryPersonRef(
  id: 'ottoman_dynasty',
  name: LocalizedHistorySummary(
    tr: 'Osmanlı hanedanı ve devlet aktörleri',
    en: 'Ottoman dynasty and state actors',
    ar: 'السلالة العثمانية وفاعلو الدولة',
  ),
);
const _safavidDynasty = HistoryPersonRef(
  id: 'safavid_dynasty',
  name: LocalizedHistorySummary(
    tr: 'Safevî hanedanı ve Kızılbaş güçleri',
    en: 'Safavid dynasty and Qizilbash forces',
    ar: 'السلالة الصفوية وقوات القزلباش',
  ),
);
const _shahIsmail = HistoryPersonRef(
  id: 'shah_ismail_i',
  name: LocalizedHistorySummary(
    tr: 'Şah İsmail I',
    en: 'Shah Ismail I',
    ar: 'الشاه إسماعيل الأول',
  ),
);
const _babur = HistoryPersonRef(
  id: 'babur',
  name: LocalizedHistorySummary(
    tr: 'Babür',
    en: 'Babur',
    ar: 'بابر',
  ),
);
const _mughalDynasty = HistoryPersonRef(
  id: 'mughal_dynasty',
  name: LocalizedHistorySummary(
    tr: 'Babür hanedanı ve imparatorluk aktörleri',
    en: 'Mughal dynasty and imperial actors',
    ar: 'السلالة المغولية وفاعلو الإمبراطورية',
  ),
);

const _ottomanRegions = HistoryGeographyRef(
  id: 'anatolia_balkans_eastern_mediterranean',
  label: LocalizedHistorySummary(
    tr: 'Anadolu, Balkanlar ve Doğu Akdeniz merkezli Osmanlı coğrafyaları',
    en: 'Ottoman geographies centred on Anatolia, the Balkans and the eastern Mediterranean',
    ar: 'المجالات العثمانية المتمركزة في الأناضول والبلقان وشرق البحر المتوسط',
  ),
  precision: HistoryGeographyPrecision.regional,
);
const _safavidIran = HistoryGeographyRef(
  id: 'safavid_iran_caucasus',
  label: LocalizedHistorySummary(
    tr: 'İran, Azerbaycan ve Kafkasya bağlantılı Safevî sahası',
    en: 'Safavid sphere across Iran, Azerbaijan and connected Caucasian regions',
    ar: 'المجال الصفوي في إيران وأذربيجان والمناطق القوقازية المتصلة بها',
  ),
  precision: HistoryGeographyPrecision.regional,
);
const _mughalSouthAsia = HistoryGeographyRef(
  id: 'north_india_indian_subcontinent',
  label: LocalizedHistorySummary(
    tr: 'Kuzey Hindistan ve Hint alt kıtası',
    en: 'North India and the Indian subcontinent',
    ar: 'شمال الهند وشبه القارة الهندية',
  ),
  precision: HistoryGeographyPrecision.regional,
);

HistoryEventRecord _eventFor(EarlyModernEmpireEntry entry) {
  final certainty = _certaintyFor(entry.certainty);
  final caveat = _dateCaveatFor(entry);

  switch (entry.id) {
    case 'ottoman_empire':
      return HistoryEventRecord.validated(
        id: entry.id,
        title: entry.title,
        startYearCe: entry.startYearCe,
        endYearCe: entry.endYearCe,
        dateCertainty: certainty,
        dateCaveat: caveat,
        beforeContext: _l(
          '13. yüzyıl sonlarında Anadolu, Moğol/İlhanlı baskısı, Selçuklu siyasal çözülmesi, Bizans sınır bölgeleri ve çok sayıda yerel Türkmen beyliğiyle parçalı bir siyasi yapıya sahipti.',
          'In the late thirteenth century Anatolia had a fragmented political landscape shaped by Mongol/Ilkhanid pressure, Seljuq political dissolution, Byzantine frontier zones and numerous local Turkmen principalities.',
          'في أواخر القرن الثالث عشر كان الأناضول ذا مشهد سياسي مجزأ تشكله الضغوط المغولية/الإيلخانية وتفكك السلطة السلجوقية ومناطق الحدود البيزنطية وإمارات تركمانية محلية عديدة.',
        ),
        causes: [
          _l(
            'Osmanlı hanedanının kuzeybatı Anadolu sınır ortamında yerel askerî-siyasi ağlar kurması ve komşu bölgelere doğru genişlemesi, uzun ömürlü bir hanedan devletinin oluşmasına katkı sağladı.',
            'The Ottoman dynasty’s formation of local military-political networks in the north-west Anatolian frontier and its expansion into neighbouring regions contributed to the emergence of a durable dynastic state.',
            'أسهم بناء السلالة العثمانية شبكات عسكرية وسياسية محلية في حدود شمال غربي الأناضول وتوسعها نحو المناطق المجاورة في نشوء دولة سلالية طويلة العمر.',
          ),
        ],
        consequences: [
          _l(
            'Osmanlı iktidarı yüzyıllar içinde Anadolu, Balkanlar, Arap vilayetleri ve Akdeniz çevresinde çok bölgeli bir imparatorluğa dönüştü; kurumsal dönüşümler ve 19.–20. yüzyıl çözülme süreçleri 1922’de saltanatın kaldırılmasına uzandı.',
            'Ottoman rule developed over centuries into a multi-regional empire spanning Anatolia, the Balkans, Arab provinces and Mediterranean zones; institutional transformations and nineteenth- to twentieth-century dissolution processes culminated in the abolition of the sultanate in 1922.',
            'تطور الحكم العثماني عبر القرون إلى إمبراطورية متعددة الأقاليم شملت الأناضول والبلقان والولايات العربية ومناطق المتوسط، وانتهت تحولات المؤسسات وعمليات التفكك في القرنين التاسع عشر والعشرين بإلغاء السلطنة سنة 1922.',
          ),
        ],
        people: const [_ottomanDynasty],
        geographies: const [_ottomanRegions],
        sourceIds: entry.sourceIds,
        knownSourceIds: _knownT0216SourceIds,
        status: entry.status,
      );
    case 'safavid_iran':
      return HistoryEventRecord.validated(
        id: entry.id,
        title: entry.title,
        startYearCe: entry.startYearCe,
        endYearCe: entry.endYearCe,
        dateCertainty: certainty,
        dateCaveat: caveat,
        beforeContext: _l(
          '15. yüzyıl sonlarında İran ve çevresi Akkoyunlu iktidarı, yerel hanedanlar ve rekabet eden askerî-siyasi ağların bulunduğu parçalı bir sahaydı; Safeviyye tarikatı da bu ortamda siyasi bir harekete dönüşüyordu.',
          'In the late fifteenth century Iran and its surroundings were a fragmented arena of Aq Qoyunlu rule, local dynasties and competing military-political networks, while the Safaviyya order was becoming a political movement.',
          'في أواخر القرن الخامس عشر كانت إيران ومحيطها ساحة مجزأة تضم حكم الآق قويونلو وسلالات محلية وشبكات عسكرية وسياسية متنافسة، بينما كانت الطريقة الصفوية تتحول إلى حركة سياسية.',
        ),
        causes: [
          _l(
            'Şah İsmail’in Kızılbaş destekli askerî-siyasi yükselişi ve 1501’de Tebriz’i ele geçirmesi Safevî hanedan iktidarının kurulmasında dönüm noktası oldu.',
            'Shah Ismail’s Qizilbash-backed military-political rise and his capture of Tabriz in 1501 were decisive in establishing Safavid dynastic rule.',
            'كان صعود الشاه إسماعيل العسكري والسياسي بدعم القزلباش واستيلاؤه على تبريز سنة 1501 حاسمين في تأسيس الحكم الصفوي.',
          ),
        ],
        consequences: [
          _l(
            'Safevî yönetimi İran’da merkezî hanedan yapısını güçlendirdi, On İki İmam Şiiliğini devlet dini olarak kurumsallaştırdı ve Osmanlı-Safevî rekabetini bölgesel siyasetin kalıcı unsurlarından biri haline getirdi; 1722 kırılması sonrasında hanedan çizgisi 1736’da sona erdi.',
            'Safavid rule strengthened a central dynastic structure in Iran, institutionalised Twelver Shiism as the state religion and made Ottoman-Safavid rivalry a lasting feature of regional politics; after the rupture of 1722, the dynastic line ended in 1736.',
            'عزز الحكم الصفوي بنية سلالية مركزية في إيران ورسخ التشيع الاثني عشري دينًا للدولة وجعل التنافس العثماني الصفوي عنصرًا دائمًا في السياسة الإقليمية؛ وبعد انقطاع سنة 1722 انتهى الخط السلالي سنة 1736.',
          ),
        ],
        people: const [_shahIsmail, _safavidDynasty],
        geographies: const [_safavidIran],
        sourceIds: entry.sourceIds,
        knownSourceIds: _knownT0216SourceIds,
        status: entry.status,
      );
    case 'mughal_empire':
      return HistoryEventRecord.validated(
        id: entry.id,
        title: entry.title,
        startYearCe: entry.startYearCe,
        endYearCe: entry.endYearCe,
        dateCertainty: certainty,
        dateCaveat: caveat,
        beforeContext: _l(
          '16. yüzyıl başlarında Kuzey Hindistan’da Delhi Sultanlığı’nın Lodi hanedanı, Afgan ve Rajput güçleri ile başka bölgesel aktörler arasında rekabet vardı; Babür ise Orta Asya ve Kabil bağlantılı Timurlu mirasına dayanıyordu.',
          'In the early sixteenth century North India was contested among the Lodi dynasty of the Delhi Sultanate, Afghan and Rajput powers and other regional actors, while Babur drew on a Timurid legacy linked to Central Asia and Kabul.',
          'في أوائل القرن السادس عشر شهد شمال الهند تنافسًا بين سلالة لودي في سلطنة دلهي وقوى أفغانية وراجبوتية وفاعلين إقليميين آخرين، بينما استند بابر إلى إرث تيموري مرتبط بآسيا الوسطى وكابل.',
        ),
        causes: [
          _l(
            'Babür’ün Kuzey Hindistan’a yönelik askerî seferleri ve 1526’daki Birinci Panipat Muharebesi zaferi yeni hanedan devletinin kuruluşunu mümkün kıldı.',
            'Babur’s campaigns into North India and victory at the First Battle of Panipat in 1526 enabled the establishment of the new dynastic state.',
            'أتاحت حملات بابر إلى شمال الهند وانتصاره في معركة بانيبات الأولى سنة 1526 تأسيس الدولة السلالية الجديدة.',
          ),
        ],
        consequences: [
          _l(
            'Babür hanedanı 16. ve 17. yüzyıllarda geniş bir imparatorluk düzeni kurdu; 18. yüzyıldaki merkezî zayıflama ve bölgesel güçlerin yükselişine rağmen hanedan sembolik olarak sürdü ve 1858’de Britanya yönetimi tarafından resmen sona erdirildi.',
            'The Mughal dynasty built a large imperial order in the sixteenth and seventeenth centuries; despite eighteenth-century weakening of central authority and the rise of regional powers, the dynasty continued symbolically until it was formally ended by British rule in 1858.',
            'بنت السلالة المغولية نظامًا إمبراطوريًا واسعًا في القرنين السادس عشر والسابع عشر؛ ورغم ضعف السلطة المركزية وصعود القوى الإقليمية في القرن الثامن عشر استمرت السلالة رمزيًا حتى أنهى الحكم البريطاني وجودها رسميًا سنة 1858.',
          ),
        ],
        people: const [_babur, _mughalDynasty],
        geographies: const [_mughalSouthAsia],
        sourceIds: entry.sourceIds,
        knownSourceIds: _knownT0216SourceIds,
        status: entry.status,
      );
    default:
      throw StateError('Unmapped T0216 event entry: ${entry.id}');
  }
}

final earlyModernEventsT0220 = HistoryEventContractDataset.validated(
  earlyModernEmpiresT0216Entries.map(_eventFor).toList(growable: false),
);
