import '../domain/history_event_contract.dart';
import 'medieval_caliphates_regional_dynasties.dart';
import 'pre_islam_world_context.dart';

LocalizedHistorySummary _l(String tr, String en, String ar) =>
    LocalizedHistorySummary(tr: tr, en: en, ar: ar);

final Set<String> _knownT0214SourceIds = medievalHistoryT0214Sources
    .map((source) => source.locator.id)
    .toSet();

HistoryDateCertainty _certaintyFor(MedievalHistoryCertainty certainty) {
  switch (certainty) {
    case MedievalHistoryCertainty.establishedChronology:
      return HistoryDateCertainty.approximate;
    case MedievalHistoryCertainty.broadPeriod:
      return HistoryDateCertainty.broadRange;
    case MedievalHistoryCertainty.contestedInterpretation:
      return HistoryDateCertainty.contested;
  }
}

LocalizedHistorySummary _dateCaveatFor(MedievalHistoryEntry entry) {
  return entry.caveat ??
      _l(
        'Bu yıl aralığı dönem kronolojisini gösterir; gün ve ay düzeyinde kesinlik iddia edilmez.',
        'This year range represents period chronology; day- or month-level precision is not asserted.',
        'يمثل هذا النطاق الزمني تسلسل المرحلة، ولا تُدّعى دقة على مستوى اليوم أو الشهر.',
      );
}

const _muawiya = HistoryPersonRef(
  id: 'muawiya_ibn_abi_sufyan',
  name: LocalizedHistorySummary(
    tr: 'Muâviye b. Ebû Süfyân',
    en: 'Muawiya ibn Abi Sufyan',
    ar: 'معاوية بن أبي سفيان',
  ),
);
const _abdAlMalik = HistoryPersonRef(
  id: 'abd_al_malik_ibn_marwan',
  name: LocalizedHistorySummary(
    tr: 'Abdülmelik b. Mervân',
    en: 'Abd al-Malik ibn Marwan',
    ar: 'عبد الملك بن مروان',
  ),
);
const _alSaffah = HistoryPersonRef(
  id: 'abu_al_abbas_al_saffah',
  name: LocalizedHistorySummary(
    tr: 'Ebû’l-Abbâs es-Seffâh',
    en: 'Abu al-Abbas al-Saffah',
    ar: 'أبو العباس السفاح',
  ),
);
const _alMansur = HistoryPersonRef(
  id: 'abu_jafar_al_mansur',
  name: LocalizedHistorySummary(
    tr: 'Ebû Ca‘fer el-Mansûr',
    en: 'Abu Jafar al-Mansur',
    ar: 'أبو جعفر المنصور',
  ),
);
const _abdAlRahmanI = HistoryPersonRef(
  id: 'abd_al_rahman_i',
  name: LocalizedHistorySummary(
    tr: 'I. Abdurrahman',
    en: 'Abd al-Rahman I',
    ar: 'عبد الرحمن الداخل',
  ),
);
const _abdAlRahmanIII = HistoryPersonRef(
  id: 'abd_al_rahman_iii',
  name: LocalizedHistorySummary(
    tr: 'III. Abdurrahman',
    en: 'Abd al-Rahman III',
    ar: 'عبد الرحمن الناصر',
  ),
);
const _alMahdi = HistoryPersonRef(
  id: 'ubayd_allah_al_mahdi',
  name: LocalizedHistorySummary(
    tr: 'Ubeydullah el-Mehdî',
    en: 'Ubayd Allah al-Mahdi',
    ar: 'عبيد الله المهدي',
  ),
);
const _alMuizz = HistoryPersonRef(
  id: 'al_muizz_li_din_allah',
  name: LocalizedHistorySummary(
    tr: 'Muiz-Lidînillâh',
    en: 'al-Muizz li-Din Allah',
    ar: 'المعز لدين الله',
  ),
);
const _ismailSamani = HistoryPersonRef(
  id: 'ismail_ibn_ahmad_samani',
  name: LocalizedHistorySummary(
    tr: 'İsmâil b. Ahmed es-Sâmânî',
    en: 'Ismail ibn Ahmad al-Samani',
    ar: 'إسماعيل بن أحمد الساماني',
  ),
);
const _muizzAlDawla = HistoryPersonRef(
  id: 'ahmad_ibn_buya_muizz_al_dawla',
  name: LocalizedHistorySummary(
    tr: 'Ahmed b. Büveyh (Muizzüddevle)',
    en: 'Ahmad ibn Buya (Muizz al-Dawla)',
    ar: 'أحمد بن بويه (معز الدولة)',
  ),
);

const _syriaDamascus = HistoryGeographyRef(
  id: 'syria_damascus',
  label: LocalizedHistorySummary(
    tr: 'Suriye ve Şam',
    en: 'Syria and Damascus',
    ar: 'بلاد الشام ودمشق',
  ),
  precision: HistoryGeographyPrecision.regional,
);
const _iraqBaghdad = HistoryGeographyRef(
  id: 'iraq_baghdad',
  label: LocalizedHistorySummary(
    tr: 'Irak ve Bağdat',
    en: 'Iraq and Baghdad',
    ar: 'العراق وبغداد',
  ),
  precision: HistoryGeographyPrecision.regional,
);
const _alAndalusCordoba = HistoryGeographyRef(
  id: 'al_andalus_cordoba',
  label: LocalizedHistorySummary(
    tr: 'Endülüs ve Kurtuba',
    en: 'al-Andalus and Cordoba',
    ar: 'الأندلس وقرطبة',
  ),
  precision: HistoryGeographyPrecision.regional,
);
const _ifriqiyaEgyptCairo = HistoryGeographyRef(
  id: 'ifriqiya_egypt_cairo',
  label: LocalizedHistorySummary(
    tr: 'İfrîkıye, Mısır ve Kahire',
    en: 'Ifriqiya, Egypt and Cairo',
    ar: 'إفريقية ومصر والقاهرة',
  ),
  precision: HistoryGeographyPrecision.regional,
);
const _transoxianaKhorasan = HistoryGeographyRef(
  id: 'transoxiana_khorasan_bukhara',
  label: LocalizedHistorySummary(
    tr: 'Mâverâünnehir, Horasan ve Buhara',
    en: 'Transoxiana, Khurasan and Bukhara',
    ar: 'ما وراء النهر وخراسان وبخارى',
  ),
  precision: HistoryGeographyPrecision.regional,
);
const _westernIranIraq = HistoryGeographyRef(
  id: 'western_iran_iraq',
  label: LocalizedHistorySummary(
    tr: 'Batı İran ve Irak',
    en: 'Western Iran and Iraq',
    ar: 'غربي إيران والعراق',
  ),
  precision: HistoryGeographyPrecision.regional,
);

HistoryEventRecord _eventFor(MedievalHistoryEntry entry) {
  final common = (
    dateCertainty: _certaintyFor(entry.certainty),
    dateCaveat: _dateCaveatFor(entry),
  );

  switch (entry.id) {
    case 'umayyad_caliphate':
      return HistoryEventRecord.validated(
        id: entry.id,
        title: entry.title,
        startYearCe: entry.startYearCe,
        endYearCe: entry.endYearCe,
        dateCertainty: common.dateCertainty,
        dateCaveat: common.dateCaveat,
        beforeContext: _l(
          '656–661 arasındaki İlk Fitne ve Ali ile Muâviye arasındaki siyasi mücadele, erken hilafetin yönetim düzenini dönüştürdü.',
          'The First Fitna of 656–661 and the political struggle between Ali and Muawiya transformed the governing order of the early caliphate.',
          'غيّرت الفتنة الأولى بين 656 و661 والصراع السياسي بين علي ومعاوية نظام الحكم في الخلافة المبكرة.',
        ),
        causes: [
          _l(
            '661’de Muâviye’nin üstün gelmesiyle Suriye merkezli yeni bir hanedan yönetimi oluştu.',
            'Muawiya’s ascendancy in 661 produced a new dynastic government centred in Syria.',
            'أدى تفوق معاوية سنة 661 إلى قيام حكم سلالي جديد مركزه بلاد الشام.',
          ),
        ],
        consequences: [
          _l(
            'Emevî yönetimi geniş bir imparatorluk alanını idare etti; iç siyasi muhalefet ve Abbâsî hareketi 750’de merkezî Emevî yönetiminin sona ermesine yol açtı.',
            'Umayyad rule governed a wide imperial realm; internal political opposition and the Abbasid movement culminated in the end of central Umayyad rule in 750.',
            'حكم الأمويون مجالًا إمبراطوريًا واسعًا، وانتهى حكمهم المركزي سنة 750 مع تصاعد المعارضة السياسية والحركة العباسية.',
          ),
        ],
        people: const [_muawiya, _abdAlMalik],
        geographies: const [_syriaDamascus],
        sourceIds: entry.sourceIds,
        knownSourceIds: _knownT0214SourceIds,
        status: entry.status,
      );
    case 'abbasid_caliphate':
      return HistoryEventRecord.validated(
        id: entry.id,
        title: entry.title,
        startYearCe: entry.startYearCe,
        endYearCe: entry.endYearCe,
        dateCertainty: common.dateCertainty,
        dateCaveat: common.dateCaveat,
        beforeContext: _l(
          'Geç Emevî döneminde siyasi muhalefet ve Hâşimî meşruiyet iddiaları etrafında örgütlenen Abbâsî hareketi güç kazandı.',
          'In the late Umayyad period, the Abbasid movement gained strength amid political opposition and claims of Hashimite legitimacy.',
          'قويت الحركة العباسية في أواخر العصر الأموي وسط المعارضة السياسية ودعاوى الشرعية الهاشمية.',
        ),
        causes: [
          _l(
            'Abbâsî Devrimi 750’de Emevî merkezî yönetimini devirdi ve Abbâsî hanedanını iktidara taşıdı.',
            'The Abbasid Revolution overthrew central Umayyad rule in 750 and brought the Abbasid dynasty to power.',
            'أسقطت الثورة العباسية الحكم الأموي المركزي سنة 750 وأوصلت الأسرة العباسية إلى السلطة.',
          ),
        ],
        consequences: [
          _l(
            'Bağdat 762’de yeni başkent olarak kuruldu; Abbâsîlerin doğrudan siyasi hâkimiyeti zamanla parçalanırken halifelik kurumu Bağdat’ın 1258’de Moğollar tarafından alınmasına kadar sürdü.',
            'Baghdad was founded as the new capital in 762; while direct Abbasid political control fragmented over time, the caliphal institution endured there until the Mongol conquest of Baghdad in 1258.',
            'أُسست بغداد عاصمة جديدة سنة 762، ومع تفتت السيطرة السياسية العباسية المباشرة مع الزمن استمرت مؤسسة الخلافة فيها حتى استيلاء المغول على بغداد سنة 1258.',
          ),
        ],
        people: const [_alSaffah, _alMansur],
        geographies: const [_iraqBaghdad],
        sourceIds: entry.sourceIds,
        knownSourceIds: _knownT0214SourceIds,
        status: entry.status,
      );
    case 'umayyad_al_andalus':
      return HistoryEventRecord.validated(
        id: entry.id,
        title: entry.title,
        startYearCe: entry.startYearCe,
        endYearCe: entry.endYearCe,
        dateCertainty: common.dateCertainty,
        dateCaveat: common.dateCaveat,
        beforeContext: _l(
          '750’de doğudaki Emevî merkezî yönetimi sona erdi; Emevî ailesinden I. Abdurrahman batıya geçerek Endülüs’te yeni bir siyasi merkez kurdu.',
          'Central Umayyad rule in the east ended in 750; Abd al-Rahman I of the Umayyad family moved west and established a new political centre in al-Andalus.',
          'انتهى الحكم الأموي المركزي في المشرق سنة 750، وانتقل عبد الرحمن الداخل من الأسرة الأموية غربًا وأقام مركزًا سياسيًا جديدًا في الأندلس.',
        ),
        causes: [
          _l(
            'I. Abdurrahman’ın Endülüs’te iktidar kurması 756’da Kurtuba merkezli bağımsız Emevî emirliğini oluşturdu.',
            'Abd al-Rahman I’s establishment of power in al-Andalus created an independent Umayyad emirate centred on Cordoba in 756.',
            'أدى تأسيس عبد الرحمن الداخل سلطته في الأندلس إلى قيام إمارة أموية مستقلة مركزها قرطبة سنة 756.',
          ),
        ],
        consequences: [
          _l(
            'III. Abdurrahman 929’da halife unvanını benimsedi; Kurtuba Emevî halifeliği 1031’de sona erdi ve Endülüs’te siyasi yapı yeniden parçalandı.',
            'Abd al-Rahman III assumed the caliphal title in 929; the Umayyad caliphate of Cordoba ended in 1031 and political authority in al-Andalus fragmented again.',
            'اتخذ عبد الرحمن الناصر لقب الخليفة سنة 929، وانتهت الخلافة الأموية في قرطبة سنة 1031 لتعود السلطة السياسية في الأندلس إلى التفتت.',
          ),
        ],
        people: const [_abdAlRahmanI, _abdAlRahmanIII],
        geographies: const [_alAndalusCordoba],
        sourceIds: entry.sourceIds,
        knownSourceIds: _knownT0214SourceIds,
        status: entry.status,
      );
    case 'fatimid_caliphate':
      return HistoryEventRecord.validated(
        id: entry.id,
        title: entry.title,
        startYearCe: entry.startYearCe,
        endYearCe: entry.endYearCe,
        dateCertainty: common.dateCertainty,
        dateCaveat: common.dateCaveat,
        beforeContext: _l(
          'İsmâilî davet ağları Kuzey Afrika’da siyasi destek oluşturdu ve Abbâsî halifeliğine rakip bir imamet-halifelik iddiasının zemini gelişti.',
          'Ismaili missionary networks built political support in North Africa, creating the basis for an imam-caliphate that rivalled Abbasid claims.',
          'بنت شبكات الدعوة الإسماعيلية دعمًا سياسيًا في شمال أفريقيا، ومهّدت لقيام إمامة وخلافة تنافس الدعوى العباسية.',
        ),
        causes: [
          _l(
            'Ubeydullah el-Mehdî’nin 909’da İfrîkıye’de hâkimiyet kurması Fâtımî devletinin başlangıcını oluşturdu.',
            'Ubayd Allah al-Mahdi’s establishment of rule in Ifriqiya in 909 marked the beginning of the Fatimid state.',
            'مثّل تأسيس عبيد الله المهدي حكمه في إفريقية سنة 909 بداية الدولة الفاطمية.',
          ),
        ],
        consequences: [
          _l(
            'Fâtımîler 969’da Mısır’ı ele geçirip Kahire’yi yeni merkez haline getirdi; hanedan ve halifelik 1171’de sona erdi.',
            'The Fatimids conquered Egypt in 969 and made Cairo their new centre; the dynasty and caliphate ended in 1171.',
            'فتح الفاطميون مصر سنة 969 واتخذوا القاهرة مركزًا جديدًا، ثم انتهت السلالة والخلافة سنة 1171.',
          ),
        ],
        people: const [_alMahdi, _alMuizz],
        geographies: const [_ifriqiyaEgyptCairo],
        sourceIds: entry.sourceIds,
        knownSourceIds: _knownT0214SourceIds,
        status: entry.status,
      );
    case 'samanid_regional_power':
      return HistoryEventRecord.validated(
        id: entry.id,
        title: entry.title,
        startYearCe: entry.startYearCe,
        endYearCe: entry.endYearCe,
        dateCertainty: common.dateCertainty,
        dateCaveat: common.dateCaveat,
        beforeContext: _l(
          'Abbâsî merkezî siyasi denetimi doğu bölgelerinde gevşerken yerel hanedanlar Horasan ve Mâverâünnehir’de giderek daha bağımsız yönetim alanları kurdu.',
          'As direct Abbasid political control weakened in the east, regional dynasties developed increasingly autonomous rule in Khurasan and Transoxiana.',
          'مع ضعف السيطرة السياسية العباسية المباشرة في المشرق، أقامت سلالات إقليمية حكمًا متزايد الاستقلال في خراسان وما وراء النهر.',
        ),
        causes: [
          _l(
            'Sâmânî ailesinin Abbâsî idari düzeni içinde bölgesel valiliklerden güç kazanması, 9. yüzyılda daha bağımsız bir hanedan yönetimine dönüştü.',
            'The Samanid family’s rise through regional governorships within the Abbasid order developed into more autonomous dynastic rule during the ninth century.',
            'تطور صعود الأسرة السامانية عبر الولايات الإقليمية ضمن النظام العباسي إلى حكم سلالي أكثر استقلالًا خلال القرن التاسع.',
          ),
        ],
        consequences: [
          _l(
            'Buhara merkezli Sâmânî yönetimi Mâverâünnehir ve Horasan’da önemli bir bölgesel güç oldu; hanedanın siyasi hâkimiyeti 999’da sona erdi.',
            'Samanid rule centred on Bukhara became a major regional power in Transoxiana and Khurasan; the dynasty’s political rule ended in 999.',
            'أصبح الحكم الساماني المتمركز في بخارى قوة إقليمية مهمة في ما وراء النهر وخراسان، وانتهى حكم السلالة السياسي سنة 999.',
          ),
        ],
        people: const [_ismailSamani],
        geographies: const [_transoxianaKhorasan],
        sourceIds: entry.sourceIds,
        knownSourceIds: _knownT0214SourceIds,
        status: entry.status,
      );
    case 'buyid_regional_power':
      return HistoryEventRecord.validated(
        id: entry.id,
        title: entry.title,
        startYearCe: entry.startYearCe,
        endYearCe: entry.endYearCe,
        dateCertainty: common.dateCertainty,
        dateCaveat: common.dateCaveat,
        beforeContext: _l(
          '10. yüzyılda Abbâsî merkezî otoritesinin siyasi ve askerî denetimi zayıflarken İran ve Irak’ta bölgesel askerî hanedanların etkisi arttı.',
          'During the tenth century, as Abbasid central political and military control weakened, regional military dynasties gained influence in Iran and Iraq.',
          'خلال القرن العاشر، ومع ضعف السيطرة السياسية والعسكرية المركزية للعباسيين، ازداد نفوذ السلالات العسكرية الإقليمية في إيران والعراق.',
        ),
        causes: [
          _l(
            'Büveyhî kardeşlerin batı İran’da kurduğu askerî-siyasi güç genişleyerek Ahmed b. Büveyh’in 945’te Bağdat’a girmesine uzandı.',
            'The military-political power built by the Buyid brothers in western Iran expanded until Ahmad ibn Buya entered Baghdad in 945.',
            'اتسعت القوة العسكرية والسياسية التي بناها الإخوة البويهيون في غربي إيران حتى دخل أحمد بن بويه بغداد سنة 945.',
          ),
        ],
        consequences: [
          _l(
            'Büveyhî emirleri Irak ve batı İran’da fiilî siyasi üstünlük kurarken Abbâsî halifesi Bağdat’ta dinî ve sembolik meşruiyet odağı olarak varlığını sürdürdü; Büveyhî üstünlüğü 1055’te Selçuklu müdahalesiyle sona erdi.',
            'Buyid amirs exercised effective political predominance in Iraq and western Iran while the Abbasid caliph remained in Baghdad as a religious and symbolic source of legitimacy; Buyid predominance ended with Seljuk intervention in 1055.',
            'مارس الأمراء البويهيون تفوقًا سياسيًا فعليًا في العراق وغربي إيران، بينما بقي الخليفة العباسي في بغداد مصدرًا دينيًا ورمزيًا للشرعية؛ وانتهى التفوق البويهي بتدخل السلاجقة سنة 1055.',
          ),
        ],
        people: const [_muizzAlDawla],
        geographies: const [_westernIranIraq, _iraqBaghdad],
        sourceIds: entry.sourceIds,
        knownSourceIds: _knownT0214SourceIds,
        status: entry.status,
      );
    default:
      throw StateError('Unmapped T0214 event: ${entry.id}');
  }
}

final List<HistoryEventRecord> medievalHistoryT0214EventsT0220 =
    List.unmodifiable(medievalHistoryT0214.entries.map(_eventFor));

final HistoryEventContractDataset medievalHistoryT0214EventDatasetT0220 =
    HistoryEventContractDataset.validated(medievalHistoryT0214EventsT0220);
