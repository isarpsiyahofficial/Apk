enum HistoryResearchStatus { researchDraft, reviewedForProduction }

enum HistorySourceKind { academicMonograph, academicChapter, peerReviewedArticle }

class HistorySourceLocator {
  const HistorySourceLocator({
    required this.id,
    required this.kind,
    required this.citation,
    required this.locator,
  });

  final String id;
  final HistorySourceKind kind;
  final String citation;
  final String locator;

  bool get isComplete =>
      id.trim().isNotEmpty &&
      citation.trim().isNotEmpty &&
      locator.trim().isNotEmpty;
}

class LocalizedHistorySummary {
  const LocalizedHistorySummary({
    required this.tr,
    required this.en,
    required this.ar,
  });

  final String tr;
  final String en;
  final String ar;

  bool get isComplete =>
      tr.trim().isNotEmpty && en.trim().isNotEmpty && ar.trim().isNotEmpty;
}

class PreIslamWorldContextEntry {
  const PreIslamWorldContextEntry({
    required this.id,
    required this.title,
    required this.summary,
    required this.sourceIds,
    required this.status,
  });

  final String id;
  final LocalizedHistorySummary title;
  final LocalizedHistorySummary summary;
  final List<String> sourceIds;
  final HistoryResearchStatus status;
}

class PreIslamWorldContextDataset {
  PreIslamWorldContextDataset._({
    required this.sources,
    required this.entries,
  });

  factory PreIslamWorldContextDataset.validated({
    required List<HistorySourceLocator> sources,
    required List<PreIslamWorldContextEntry> entries,
  }) {
    if (sources.isEmpty || entries.isEmpty) {
      throw StateError('History research dataset must not be empty.');
    }

    final sourceIds = <String>{};
    for (final source in sources) {
      if (!source.isComplete || !sourceIds.add(source.id)) {
        throw StateError('History sources require unique, complete locators.');
      }
    }

    final entryIds = <String>{};
    for (final entry in entries) {
      if (entry.id.trim().isEmpty ||
          !entry.title.isComplete ||
          !entry.summary.isComplete ||
          entry.sourceIds.isEmpty ||
          !entryIds.add(entry.id)) {
        throw StateError('History entries require unique IDs, TR/EN/AR text and sources.');
      }
      if (entry.sourceIds.any((sourceId) => !sourceIds.contains(sourceId))) {
        throw StateError('History entry ${entry.id} references an unknown source.');
      }
    }

    final missingRequired = requiredTopicIds.difference(entryIds);
    if (missingRequired.isNotEmpty) {
      throw StateError('Missing required pre-Islam topics: $missingRequired');
    }

    return PreIslamWorldContextDataset._(
      sources: List.unmodifiable(sources),
      entries: List.unmodifiable(entries),
    );
  }

  static const Set<String> requiredTopicIds = {
    'late_antiquity',
    'byzantine_world',
    'sasanian_world',
    'aksum',
    'south_arabia_yemen',
    'mecca',
    'yathrib_medina',
    'tribal_society',
    'jewish_communities',
    'christian_communities',
    'arabian_polytheism',
  };

  final List<HistorySourceLocator> sources;
  final List<PreIslamWorldContextEntry> entries;

  List<PreIslamWorldContextEntry> get productionEntries {
    return List.unmodifiable(
      entries.where(
        (entry) => entry.status == HistoryResearchStatus.reviewedForProduction,
      ),
    );
  }
}

const preIslamWorldResearchSources = <HistorySourceLocator>[
  HistorySourceLocator(
    id: 'grasso_2023_ch1',
    kind: HistorySourceKind.academicChapter,
    citation: 'Valentina A. Grasso, Pre-Islamic Arabia, chapter 1, Cambridge University Press, 2023.',
    locator: 'doi:10.1017/9781009252997.001',
  ),
  HistorySourceLocator(
    id: 'grasso_2023_ch3',
    kind: HistorySourceKind.academicChapter,
    citation: 'Valentina A. Grasso, Pre-Islamic Arabia, chapter 3, Cambridge University Press, 2023.',
    locator: 'doi:10.1017/9781009252997.003',
  ),
  HistorySourceLocator(
    id: 'grasso_2023_ch4',
    kind: HistorySourceKind.academicChapter,
    citation: 'Valentina A. Grasso, Pre-Islamic Arabia, chapter 4, Cambridge University Press, 2023.',
    locator: 'doi:10.1017/9781009252997.004',
  ),
  HistorySourceLocator(
    id: 'cambridge_history_islam_pre_islamic_arabia',
    kind: HistorySourceKind.academicChapter,
    citation: 'Michael Lecker, “Pre-Islamic Arabia”, The New Cambridge History of Islam, Cambridge University Press.',
    locator: 'Cambridge Core: The New Cambridge History of Islam, vol. 1, Pre-Islamic Arabia, pp. 153–170',
  ),
  HistorySourceLocator(
    id: 'hallaq_pre_islamic_near_east',
    kind: HistorySourceKind.academicChapter,
    citation: 'Wael B. Hallaq, The Origins and Evolution of Islamic Law, chapter 1, Cambridge University Press.',
    locator: 'doi:10.1017/CBO9780511818783.004',
  ),
  HistorySourceLocator(
    id: 'hawting_idolatry',
    kind: HistorySourceKind.academicMonograph,
    citation: 'G. R. Hawting, The Idea of Idolatry and the Emergence of Islam, Cambridge University Press.',
    locator: 'Cambridge Core ISBN 9780521651653',
  ),
];

const preIslamWorldResearchEntries = <PreIslamWorldContextEntry>[
  PreIslamWorldContextEntry(
    id: 'late_antiquity',
    title: LocalizedHistorySummary(
      tr: 'Geç Antik Çağ',
      en: 'Late Antiquity',
      ar: 'العصور القديمة المتأخرة',
    ),
    summary: LocalizedHistorySummary(
      tr: 'İslam’ın doğduğu yedinci yüzyıl Arabistanı, Bizans, Sasani ve Kızıldeniz dünyalarıyla temas hâlindeki daha geniş Geç Antik Çağ bağlamının parçasıydı. Bölgeyi tek ve değişmez bir kültür olarak anlatmak yerine yerel toplumların çeşitliliği korunmalıdır.',
      en: 'Seventh-century Arabia belonged to a wider Late Antique setting connected with Byzantine, Sasanian and Red Sea worlds. The region should not be presented as one static culture; local societies were diverse.',
      ar: 'كانت الجزيرة العربية في القرن السابع جزءًا من سياق أوسع للعصور القديمة المتأخرة، ومتّصلة بالعالم البيزنطي والساساني وعالم البحر الأحمر. ولا ينبغي عرض المنطقة بوصفها ثقافة واحدة ثابتة، إذ كانت مجتمعاتها المحلية متنوّعة.',
    ),
    sourceIds: ['grasso_2023_ch1'],
    status: HistoryResearchStatus.researchDraft,
  ),
  PreIslamWorldContextEntry(
    id: 'byzantine_world',
    title: LocalizedHistorySummary(tr: 'Bizans Dünyası', en: 'Byzantine World', ar: 'العالم البيزنطي'),
    summary: LocalizedHistorySummary(
      tr: 'Bizans İmparatorluğu, Arabistan’ın kuzey ve kuzeybatısındaki siyaset, ticaret ve dinî ağlar üzerinde etkiliydi. Arabistan ilişkileri çoğu zaman sınır toplulukları ve müttefik Arap grupları üzerinden yürüyordu.',
      en: 'The Byzantine Empire shaped political, commercial and religious networks to Arabia’s north and northwest, often interacting with Arabia through frontier communities and allied Arab groups.',
      ar: 'أثّرت الإمبراطورية البيزنطية في الشبكات السياسية والتجارية والدينية شمال الجزيرة العربية وشمال غربها، وكثيرًا ما جرى التواصل عبر مجتمعات الحدود والجماعات العربية الحليفة.',
    ),
    sourceIds: ['cambridge_history_islam_pre_islamic_arabia'],
    status: HistoryResearchStatus.researchDraft,
  ),
  PreIslamWorldContextEntry(
    id: 'sasanian_world',
    title: LocalizedHistorySummary(tr: 'Sasani Dünyası', en: 'Sasanian World', ar: 'العالم الساساني'),
    summary: LocalizedHistorySummary(
      tr: 'Sasani İmparatorluğu doğu ve kuzeydoğu Arabistanla siyasi ve ekonomik bağlar kurdu; Bizans-Sasani rekabeti Arabistan çevresindeki güç dengelerini etkiledi. Etkinin derecesi bölgeye ve döneme göre değişiyordu.',
      en: 'The Sasanian Empire maintained political and economic links with eastern and northeastern Arabia, while Byzantine-Sasanian rivalry affected regional balances. The degree of influence varied by place and period.',
      ar: 'أقامت الإمبراطورية الساسانية روابط سياسية واقتصادية مع شرق الجزيرة العربية وشمالها الشرقي، كما أثّر التنافس البيزنطي الساساني في توازنات المنطقة. وكانت درجة التأثير تختلف باختلاف المكان والزمن.',
    ),
    sourceIds: ['cambridge_history_islam_pre_islamic_arabia'],
    status: HistoryResearchStatus.researchDraft,
  ),
  PreIslamWorldContextEntry(
    id: 'aksum',
    title: LocalizedHistorySummary(tr: 'Aksum ve Habeşistan', en: 'Aksum and Ethiopia', ar: 'أكسوم والحبشة'),
    summary: LocalizedHistorySummary(
      tr: 'Aksum Krallığı Kızıldeniz ticaretinin önemli aktörlerinden biriydi ve altıncı yüzyılda Güney Arabistan siyasetine doğrudan müdahil oldu. Bu ilişki din, ticaret ve siyaset boyutlarını birlikte taşıyordu.',
      en: 'The Kingdom of Aksum was an important Red Sea power and became directly involved in South Arabian politics in the sixth century. These connections combined religious, commercial and political dimensions.',
      ar: 'كانت مملكة أكسوم قوة مهمّة في البحر الأحمر، وتدخّلت مباشرة في سياسة جنوب الجزيرة العربية في القرن السادس. وقد جمعت هذه الصلات بين الأبعاد الدينية والتجارية والسياسية.',
    ),
    sourceIds: ['grasso_2023_ch4'],
    status: HistoryResearchStatus.researchDraft,
  ),
  PreIslamWorldContextEntry(
    id: 'south_arabia_yemen',
    title: LocalizedHistorySummary(tr: 'Yemen ve Güney Arabistan', en: 'Yemen and South Arabia', ar: 'اليمن وجنوب الجزيرة العربية'),
    summary: LocalizedHistorySummary(
      tr: 'Güney Arabistan uzun yerleşik devlet geleneklerine sahipti. Himyer döneminde tek tanrıcılığa yöneliş, Yahudi ve Hristiyan topluluklar, Aksum müdahalesi ve bölgesel ticaret altıncı yüzyılın siyasal-dinî bağlamını şekillendirdi.',
      en: 'South Arabia had long traditions of settled states. Under Himyar, moves toward monotheism, Jewish and Christian communities, Aksumite intervention and regional trade shaped the sixth-century political and religious setting.',
      ar: 'امتلك جنوب الجزيرة العربية تقاليد طويلة من الدول المستقرّة. وفي عهد حمير أسهم التوجّه نحو التوحيد، ووجود الجماعات اليهودية والمسيحية، والتدخّل الأكسومي، والتجارة الإقليمية في تشكيل سياق القرن السادس السياسي والديني.',
    ),
    sourceIds: ['grasso_2023_ch3', 'grasso_2023_ch4'],
    status: HistoryResearchStatus.researchDraft,
  ),
  PreIslamWorldContextEntry(
    id: 'mecca',
    title: LocalizedHistorySummary(tr: 'Mekke', en: 'Mecca', ar: 'مكة'),
    summary: LocalizedHistorySummary(
      tr: 'Mekke, Kâbe merkezli dinî önemi ve Kureyş’in kabile ilişkileriyle İslam öncesi Hicaz’ın önemli yerleşimlerinden biriydi. Ekonomik ağlarının kapsamı konusunda kaynak ve yorum farklılıkları bulunduğu için ticaret rolü abartısız anlatılmalıdır.',
      en: 'Mecca was an important Hijazi settlement whose significance included the Kaaba and Quraysh tribal relationships. Because sources and interpretations differ over the scale of its economic networks, its commercial role should be described cautiously.',
      ar: 'كانت مكة من المراكز المهمة في الحجاز قبل الإسلام، وارتبطت مكانتها بالكعبة وبعلاقات قريش القبلية. ونظرًا لاختلاف المصادر والتفسيرات في تقدير حجم شبكاتها الاقتصادية، ينبغي عرض دورها التجاري بحذر ودون مبالغة.',
    ),
    sourceIds: ['cambridge_history_islam_pre_islamic_arabia', 'hallaq_pre_islamic_near_east'],
    status: HistoryResearchStatus.researchDraft,
  ),
  PreIslamWorldContextEntry(
    id: 'yathrib_medina',
    title: LocalizedHistorySummary(tr: 'Yasrib / Medine', en: 'Yathrib / Medina', ar: 'يثرب / المدينة'),
    summary: LocalizedHistorySummary(
      tr: 'Yasrib, daha sonra Medine adıyla anılacak, tarımsal yerleşimlerin ve farklı kabile-topluluk ilişkilerinin bulunduğu bir Hicaz vahasıydı. Mekke ile aynı toplumsal yapıya sahipmiş gibi sunulmamalıdır.',
      en: 'Yathrib, later known as Medina, was a Hijazi oasis with agriculture and a distinct network of tribal and communal relationships. It should not be presented as socially identical to Mecca.',
      ar: 'كانت يثرب، التي عُرفت لاحقًا بالمدينة، واحة حجازية ذات نشاط زراعي وشبكة خاصة من العلاقات القبلية والجماعية. ولا ينبغي تصوير بنيتها الاجتماعية على أنها مطابقة لبنية مكة.',
    ),
    sourceIds: ['cambridge_history_islam_pre_islamic_arabia', 'hallaq_pre_islamic_near_east'],
    status: HistoryResearchStatus.researchDraft,
  ),
  PreIslamWorldContextEntry(
    id: 'tribal_society',
    title: LocalizedHistorySummary(tr: 'Kabile ve Yerleşim Düzeni', en: 'Tribal and Settlement Patterns', ar: 'البنية القبلية وأنماط الاستقرار'),
    summary: LocalizedHistorySummary(
      tr: 'Arabistan toplumları göçebe, yarı göçebe ve yerleşik grupları birlikte içeriyordu. Kabile aidiyeti önemliydi; ancak bütün yarımadayı tek bir kabile modeliyle açıklamak tarihsel çeşitliliği siler.',
      en: 'Arabian societies included nomadic, semi-nomadic and settled groups. Tribal affiliation mattered, but using one tribal model for the entire peninsula would erase historical diversity.',
      ar: 'ضمّت مجتمعات الجزيرة العربية جماعات بدوية وشبه بدوية ومستقرّة. وكانت الانتماءات القبلية مهمّة، لكن تفسير شبه الجزيرة كلّها بنموذج قبلي واحد يطمس تنوّعها التاريخي.',
    ),
    sourceIds: ['grasso_2023_ch1', 'cambridge_history_islam_pre_islamic_arabia'],
    status: HistoryResearchStatus.researchDraft,
  ),
  PreIslamWorldContextEntry(
    id: 'jewish_communities',
    title: LocalizedHistorySummary(tr: 'Yahudi Toplulukları', en: 'Jewish Communities', ar: 'الجماعات اليهودية'),
    summary: LocalizedHistorySummary(
      tr: 'İslam öncesi Arabistan’ın bazı bölgelerinde Yahudi toplulukları ve Yahudilikten etkilenen çevreler bulunuyordu. Güney Arabistan’daki Himyer tecrübesi ile Hicaz’daki topluluklar aynı tarihsel süreçmiş gibi birleştirilmemelidir.',
      en: 'Jewish communities and groups influenced by Judaism existed in parts of pre-Islamic Arabia. The Himyarite experience in South Arabia and communities in the Hijaz should not be collapsed into a single historical process.',
      ar: 'وُجدت جماعات يهودية وبيئات متأثرة باليهودية في أجزاء من الجزيرة العربية قبل الإسلام. ولا ينبغي دمج تجربة حمير في جنوب الجزيرة مع جماعات الحجاز في مسار تاريخي واحد مبسّط.',
    ),
    sourceIds: ['grasso_2023_ch3', 'cambridge_history_islam_pre_islamic_arabia'],
    status: HistoryResearchStatus.researchDraft,
  ),
  PreIslamWorldContextEntry(
    id: 'christian_communities',
    title: LocalizedHistorySummary(tr: 'Hristiyan Toplulukları', en: 'Christian Communities', ar: 'الجماعات المسيحية'),
    summary: LocalizedHistorySummary(
      tr: 'Hristiyanlık Geç Antik Çağ’da Arabistan’ın farklı çevrelerinde, özellikle kuzey sınır ağları ve Güney Arabistan-Kızıldeniz bağlantılarında görünür durumdaydı. Bölgesel mezhep ve siyaset farklılıkları göz ardı edilmemelidir.',
      en: 'Christianity was present in several Arabian settings in Late Antiquity, notably northern frontier networks and South Arabia–Red Sea connections. Regional confessional and political differences should not be flattened.',
      ar: 'كان للمسيحية حضور في بيئات متعددة من الجزيرة العربية في العصور القديمة المتأخرة، ولا سيما في شبكات الحدود الشمالية وصلات جنوب الجزيرة بالبحر الأحمر. وينبغي عدم إغفال الفروق المذهبية والسياسية بين المناطق.',
    ),
    sourceIds: ['grasso_2023_ch4', 'cambridge_history_islam_pre_islamic_arabia'],
    status: HistoryResearchStatus.researchDraft,
  ),
  PreIslamWorldContextEntry(
    id: 'arabian_polytheism',
    title: LocalizedHistorySummary(tr: 'Arap Politeizmi ve Kültler', en: 'Arabian Polytheism and Cults', ar: 'تعدّد الآلهة والعبادات في الجزيرة العربية'),
    summary: LocalizedHistorySummary(
      tr: 'İslam öncesi Arabistan’da çoktanrılı kültler bulunuyordu; ancak dinî manzara bölgeden bölgeye değişiyor ve tek tanrıcı etkilerle de kesişiyordu. Geç kaynaklardaki “putperestlik” anlatıları çağdaş epigrafi ve modern araştırmayla birlikte değerlendirilmelidir.',
      en: 'Polytheistic cults existed in pre-Islamic Arabia, but religious landscapes varied by region and intersected with monotheistic influences. Later accounts of “idolatry” should be assessed alongside contemporary epigraphy and modern scholarship.',
      ar: 'وُجدت عبادات تعدّدية في الجزيرة العربية قبل الإسلام، غير أن المشهد الديني اختلف من منطقة إلى أخرى وتداخل مع تأثيرات توحيدية. وينبغي قراءة الروايات المتأخرة عن «عبادة الأصنام» إلى جانب النقوش المعاصرة والبحث الحديث.',
    ),
    sourceIds: ['grasso_2023_ch1', 'grasso_2023_ch3', 'hawting_idolatry'],
    status: HistoryResearchStatus.researchDraft,
  ),
];

final preIslamWorldContextDataset = PreIslamWorldContextDataset.validated(
  sources: preIslamWorldResearchSources,
  entries: preIslamWorldResearchEntries,
);
