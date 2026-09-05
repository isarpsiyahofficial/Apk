import '../domain/history_event_contract.dart';
import 'modern_global_islamic_history.dart';
import 'pre_islam_world_context.dart';

LocalizedHistorySummary _l(String tr, String en, String ar) =>
    LocalizedHistorySummary(tr: tr, en: en, ar: ar);

final Set<String> _knownT0218SourceIds = modernGlobalHistoryT0218Sources
    .map((source) => source.locator.id)
    .toSet();

HistoryDateCertainty _certaintyFor(ModernGlobalHistoryCertainty certainty) {
  switch (certainty) {
    case ModernGlobalHistoryCertainty.broadPeriod:
      return HistoryDateCertainty.broadRange;
    case ModernGlobalHistoryCertainty.contestedInterpretation:
      return HistoryDateCertainty.contested;
    case ModernGlobalHistoryCertainty.snapshotBounded:
      return HistoryDateCertainty.broadRange;
  }
}

const _colonialActors = HistoryPersonRef(
  id: 'colonial_imperial_muslim_societies_and_empires',
  name: LocalizedHistorySummary(
    tr: 'Müslüman toplumlar, yerel siyasi aktörler ve Avrupa imparatorluk yönetimleri',
    en: 'Muslim societies, local political actors and European imperial administrations',
    ar: 'المجتمعات المسلمة والفاعلون السياسيون المحليون والإدارات الإمبراطورية الأوروبية',
  ),
);
const _decolonizationActors = HistoryPersonRef(
  id: 'decolonization_muslim_societies_and_state_builders',
  name: LocalizedHistorySummary(
    tr: 'Bağımsızlık hareketleri, Müslüman toplumlar ve modern devlet kurucu aktörler',
    en: 'Independence movements, Muslim societies and modern state-building actors',
    ar: 'حركات الاستقلال والمجتمعات المسلمة والفاعلون في بناء الدول الحديثة',
  ),
);
const _twentiethCenturyActors = HistoryPersonRef(
  id: 'twentieth_century_muslim_social_religious_actors',
  name: LocalizedHistorySummary(
    tr: '20. yüzyıl Müslüman toplumları, âlimler, reform hareketleri ve sivil-siyasi aktörler',
    en: 'Twentieth-century Muslim societies, scholars, reform movements and civic-political actors',
    ar: 'المجتمعات المسلمة في القرن العشرين والعلماء وحركات الإصلاح والفاعلون المدنيون والسياسيون',
  ),
);
const _contemporaryActors = HistoryPersonRef(
  id: 'contemporary_global_muslim_societies_actors',
  name: LocalizedHistorySummary(
    tr: 'Çağdaş Müslüman toplumlar, göçmen topluluklar, kurumlar ve ulusötesi ağlar',
    en: 'Contemporary Muslim societies, migrant communities, institutions and transnational networks',
    ar: 'المجتمعات المسلمة المعاصرة وجماعات المهاجرين والمؤسسات والشبكات العابرة للحدود',
  ),
);

const _colonialGeographies = HistoryGeographyRef(
  id: 'colonial_imperial_muslim_regions',
  label: LocalizedHistorySummary(
    tr: 'Afrika, Güney ve Güneydoğu Asya, Orta Asya ve diğer farklı sömürge/imparatorluk bölgeleri',
    en: 'Distinct colonial and imperial regions across Africa, South and Southeast Asia, Central Asia and elsewhere',
    ar: 'مناطق استعمارية وإمبراطورية مختلفة في أفريقيا وجنوب وجنوب شرق آسيا وآسيا الوسطى وغيرها',
  ),
  precision: HistoryGeographyPrecision.regional,
);
const _decolonizationGeographies = HistoryGeographyRef(
  id: 'decolonization_muslim_regions',
  label: LocalizedHistorySummary(
    tr: 'Ortadoğu, Kuzey Afrika, Güney ve Güneydoğu Asya ile diğer dekolonizasyon coğrafyaları',
    en: 'The Middle East, North Africa, South and Southeast Asia and other decolonization geographies',
    ar: 'الشرق الأوسط وشمال أفريقيا وجنوب وجنوب شرق آسيا ومجالات أخرى لإنهاء الاستعمار',
  ),
  precision: HistoryGeographyPrecision.regional,
);
const _twentiethCenturyGeographies = HistoryGeographyRef(
  id: 'twentieth_century_global_muslim_regions',
  label: LocalizedHistorySummary(
    tr: '20. yüzyıldaki farklı Müslüman çoğunluklu ve azınlık toplumlarının bölgesel coğrafyaları',
    en: 'Regional geographies of diverse Muslim-majority and Muslim-minority societies in the twentieth century',
    ar: 'المجالات الإقليمية لمجتمعات مسلمة متنوعة ذات أغلبية أو أقلية خلال القرن العشرين',
  ),
  precision: HistoryGeographyPrecision.regional,
);
const _contemporaryGeographies = HistoryGeographyRef(
  id: 'contemporary_global_muslim_geographies',
  label: LocalizedHistorySummary(
    tr: 'Müslüman çoğunluklu ülkeler ile Avrupa ve diğer göç/azınlık toplumlarını kapsayan küresel coğrafyalar',
    en: 'Global geographies spanning Muslim-majority countries and Muslim migrant/minority societies in Europe and elsewhere',
    ar: 'مجالات عالمية تشمل البلدان ذات الأغلبية المسلمة ومجتمعات الهجرة والأقليات المسلمة في أوروبا وغيرها',
  ),
  precision: HistoryGeographyPrecision.regional,
);

HistoryEventRecord _eventFor(ModernGlobalHistoryEntry entry) {
  final certainty = _certaintyFor(entry.certainty);

  switch (entry.id) {
    case 'colonial_imperial_rule':
      return HistoryEventRecord.validated(
        id: entry.id,
        title: entry.title,
        startYearCe: entry.startYearCe,
        endYearCe: entry.endYearCe,
        dateCertainty: certainty,
        dateCaveat: entry.caveat,
        beforeContext: _l(
          '18. yüzyılın sonlarına gelindiğinde Müslüman toplumlar çok farklı imparatorluk, hanedan, yerel yönetim ve ticaret düzenleri içinde yaşıyordu; Avrupa gücü ve müdahalesinin derecesi bölgelere göre aynı değildi.',
          'By the late eighteenth century Muslim societies lived under diverse empires, dynasties, local governments and commercial systems; the degree of European power and intervention differed substantially by region.',
          'بحلول أواخر القرن الثامن عشر عاشت المجتمعات المسلمة ضمن إمبراطوريات وسلالات وإدارات محلية ونظم تجارية متنوعة، وكانت درجة القوة والتدخل الأوروبي تختلف اختلافًا كبيرًا بين المناطق.',
        ),
        causes: [
          _l(
            'Avrupa imparatorluklarının askerî ve deniz gücü, ticari rekabet, toprak genişlemesi ve yerel siyasi-ekonomik ilişkiler 19. yüzyılda farklı bölgelerde doğrudan veya dolaylı imparatorluk yönetimlerinin genişlemesine katkı sağladı.',
            'European imperial military and naval power, commercial competition, territorial expansion and local political-economic relationships contributed to the spread of direct and indirect imperial rule in different regions during the nineteenth century.',
            'أسهمت القوة العسكرية والبحرية للإمبراطوريات الأوروبية والمنافسة التجارية والتوسع الإقليمي والعلاقات السياسية والاقتصادية المحلية في اتساع أشكال الحكم الإمبراطوري المباشر وغير المباشر في مناطق مختلفة خلال القرن التاسع عشر.',
          ),
        ],
        consequences: [
          _l(
            'Yönetim, hukuk, ekonomi, eğitim ve yerel kurumlar farklı biçimlerde dönüştü; işbirliği, müzakere ve direniş de bölgelere göre değişti. Bu nedenle dönem tek bir sömürgeleşme modeliyle açıklanamaz.',
            'Government, law, economies, education and local institutions changed in different ways, while accommodation, negotiation and resistance also varied by region. The period cannot be reduced to one colonial model.',
            'تغيرت أنظمة الحكم والقانون والاقتصاد والتعليم والمؤسسات المحلية بطرق مختلفة، كما اختلف التعاون والتفاوض والمقاومة بحسب المنطقة؛ لذلك لا يمكن اختزال المرحلة في نموذج استعماري واحد.',
          ),
        ],
        people: const [_colonialActors],
        geographies: const [_colonialGeographies],
        sourceIds: entry.sourceIds,
        knownSourceIds: _knownT0218SourceIds,
        status: entry.status,
      );
    case 'decolonization_nation_states':
      return HistoryEventRecord.validated(
        id: entry.id,
        title: entry.title,
        startYearCe: entry.startYearCe,
        endYearCe: entry.endYearCe,
        dateCertainty: certainty,
        dateCaveat: entry.caveat,
        beforeContext: _l(
          'Birinci Dünya Savaşı sonrasında eski imparatorluk topraklarının önemli bir bölümü manda, sömürge veya yeniden çizilen siyasi sınırlar içinde kaldı; yerel toplumların siyasi deneyimleri ve talepleri birbirinden farklıydı.',
          'After the First World War, many former imperial territories remained under mandates, colonial rule or newly drawn political boundaries, while local societies had different political experiences and demands.',
          'بعد الحرب العالمية الأولى بقيت مناطق كثيرة من أراضي الإمبراطوريات السابقة تحت الانتداب أو الاستعمار أو ضمن حدود سياسية أعيد رسمها، وكانت للمجتمعات المحلية تجارب ومطالب سياسية مختلفة.',
        ),
        causes: [
          _l(
            'İmparatorlukların çözülmesi, sömürge karşıtı hareketler, savaşların ekonomik ve siyasi etkileri, milliyetçilik ve farklı yerel bağımsızlık talepleri dekolonizasyon süreçlerini şekillendirdi.',
            'Imperial dissolution, anti-colonial movements, the economic and political effects of war, nationalism and diverse local demands for independence shaped processes of decolonization.',
            'شكّل تفكك الإمبراطوريات والحركات المناهضة للاستعمار والآثار الاقتصادية والسياسية للحروب والقومية ومطالب الاستقلال المحلية المتنوعة مسارات إنهاء الاستعمار.',
          ),
        ],
        consequences: [
          _l(
            'Farklı tarihlerde bağımsız devletler ve yeni siyasi kurumlar ortaya çıktı; sınırlar, vatandaşlık, hukuk ve devlet-toplum ilişkileri birçok bölgede yeniden tanımlandı ve süreçlerin sonuçları eşit veya tek biçimli olmadı.',
            'Independent states and new political institutions emerged at different times; borders, citizenship, law and state-society relations were redefined in many regions, with unequal and non-uniform outcomes.',
            'ظهرت دول مستقلة ومؤسسات سياسية جديدة في أوقات مختلفة، وأعيد تعريف الحدود والمواطنة والقانون وعلاقات الدولة بالمجتمع في مناطق كثيرة بنتائج غير متساوية وغير موحدة.',
          ),
        ],
        people: const [_decolonizationActors],
        geographies: const [_decolonizationGeographies],
        sourceIds: entry.sourceIds,
        knownSourceIds: _knownT0218SourceIds,
        status: entry.status,
      );
    case 'twentieth_century_transformations':
      return HistoryEventRecord.validated(
        id: entry.id,
        title: entry.title,
        startYearCe: entry.startYearCe,
        endYearCe: entry.endYearCe,
        dateCertainty: certainty,
        dateCaveat: entry.caveat,
        beforeContext: _l(
          '20. yüzyılın başında Müslüman toplumlar imparatorluk, sömürge yönetimi, bağımsız devlet ve yerel siyasi yapıların farklı bileşimleri içinde bulunuyor; eğitim, basın ve reform ağları da bölgeler arasında eşit gelişmiyordu.',
          'At the start of the twentieth century Muslim societies existed within different combinations of empire, colonial rule, independent states and local political structures, while education, print and reform networks developed unevenly across regions.',
          'في مطلع القرن العشرين عاشت المجتمعات المسلمة ضمن تركيبات مختلفة من الإمبراطوريات والاستعمار والدول المستقلة والبنى السياسية المحلية، كما تطورت شبكات التعليم والطباعة والإصلاح بدرجات متفاوتة بين المناطق.',
        ),
        causes: [
          _l(
            'Kentleşme, kitlesel eğitim ve basın, devlet ve hukuk reformları, yeni iletişim araçları, göç ve dinî-siyasi reform hareketleri toplumsal ve dinî kurumların değişiminde etkili oldu.',
            'Urbanization, mass education and print, state and legal reforms, new communication media, migration and religious-political reform movements influenced changes in social and religious institutions.',
            'أثر التمدّن والتعليم الجماهيري والطباعة وإصلاحات الدولة والقانون ووسائل الاتصال الجديدة والهجرة وحركات الإصلاح الديني والسياسي في تغير المؤسسات الاجتماعية والدينية.',
          ),
        ],
        consequences: [
          _l(
            'Dinî otorite, eğitim, kamusal alan, örgütlenme ve gündelik hayat farklı bölgelerde yeni biçimler aldı; modernleşme ve dinî değişim tek yönlü bir sekülerleşme veya tek bir reform modeli olarak okunamaz.',
            'Religious authority, education, public life, organization and everyday practice took new forms in different regions; modernization and religious change cannot be read as one-way secularization or a single reform model.',
            'اتخذت السلطة الدينية والتعليم والحياة العامة والتنظيم والممارسات اليومية أشكالًا جديدة في مناطق مختلفة، ولا يمكن قراءة الحداثة والتغير الديني بوصفهما علمنة أحادية الاتجاه أو نموذج إصلاح واحدًا.',
          ),
        ],
        people: const [_twentiethCenturyActors],
        geographies: const [_twentiethCenturyGeographies],
        sourceIds: entry.sourceIds,
        knownSourceIds: _knownT0218SourceIds,
        status: entry.status,
      );
    case 'contemporary_global_muslim_societies':
      return HistoryEventRecord.validated(
        id: entry.id,
        title: entry.title,
        startYearCe: entry.startYearCe,
        endYearCe: entry.endYearCe,
        dateCertainty: certainty,
        dateCaveat: entry.caveat,
        beforeContext: _l(
          '20. yüzyılın ortalarına kadar modern İslam tarihi anlatıları çoğu zaman Müslüman çoğunluklu bölgeler ve devletler etrafında kuruluyordu; savaş sonrası göç ve kalıcı diasporalar bu çerçeveyi giderek genişletti.',
          'By the mid-twentieth century modern Islamic history was often narrated around Muslim-majority regions and states; post-war migration and durable diasporas increasingly widened that frame.',
          'حتى منتصف القرن العشرين غالبًا ما رُوي تاريخ الإسلام الحديث حول المناطق والدول ذات الأغلبية المسلمة، ثم وسعت هجرات ما بعد الحرب والجاليات المستقرة هذا الإطار تدريجيًا.',
        ),
        causes: [
          _l(
            'Savaş sonrası göç, işgücü hareketliliği, eğitim, vatandaşlık süreçleri, kentleşme, mülteci hareketleri ve ulusötesi iletişim ağları Müslüman toplumların küresel dağılımını ve kurumlarını dönüştürdü.',
            'Post-war migration, labour mobility, education, citizenship processes, urbanization, refugee movements and transnational communication networks transformed the global distribution and institutions of Muslim societies.',
            'حوّلت هجرات ما بعد الحرب وحركة العمال والتعليم ومسارات المواطنة والتمدّن وحركات اللجوء وشبكات الاتصال العابرة للحدود التوزع العالمي للمجتمعات المسلمة ومؤسساتها.',
          ),
        ],
        consequences: [
          _l(
            'Avrupa ve diğer Batı toplumlarındaki kalıcı Müslüman topluluklar, ulusötesi ağlar ve Müslüman çoğunluklu ülkelerdeki eşzamanlı dönüşümler çağdaş İslam tarihinin birbirine bağlı fakat tek tip olmayan parçalarıdır. 2026 yalnız veri sürümünün güncellik sınırıdır.',
            'Established Muslim communities in Europe and other Western societies, transnational networks and simultaneous changes in Muslim-majority countries are connected but non-uniform parts of contemporary Islamic history. The year 2026 is only the dataset currency boundary.',
            'تمثل الجماعات المسلمة المستقرة في أوروبا وغيرها من المجتمعات الغربية والشبكات العابرة للحدود والتحولات المتزامنة في البلدان ذات الأغلبية المسلمة أجزاء مترابطة ولكن غير موحدة من تاريخ الإسلام المعاصر. وسنة 2026 ليست إلا حد تحديث مجموعة البيانات.',
          ),
        ],
        people: const [_contemporaryActors],
        geographies: const [_contemporaryGeographies],
        sourceIds: entry.sourceIds,
        knownSourceIds: _knownT0218SourceIds,
        status: entry.status,
      );
    default:
      throw StateError('Unmapped T0218 modern history entry: ${entry.id}');
  }
}

final modernGlobalEventsT0220 = HistoryEventContractDataset.validated(
  modernGlobalHistoryT0218Entries.map(_eventFor).toList(growable: false),
);
